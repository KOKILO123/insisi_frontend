import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:insisi/providers/area_provider.dart';
import 'package:insisi/models/area.dart';
import 'package:provider/provider.dart';
import 'package:insisi/util/colors.dart';

class AreaesScreen extends StatefulWidget {
  @override
  _AreaesScreenState createState() => _AreaesScreenState();
}

class _AreaesScreenState extends State<AreaesScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Area> _filteredAreaes = [];
  bool isSearchClicked = false;

  @override
  void initState() {
    super.initState();
    final areaProvider = Provider.of<AreaProvider>(context, listen: false);
    areaProvider.fetchAreaes(); // Fetch areaes on init
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final areaProvider = Provider.of<AreaProvider>(context, listen: false);
    final allAreaes = areaProvider.areaes;
    setState(() {
      if (value.isEmpty) {
        _filteredAreaes = allAreaes;
      } else {
        _filteredAreaes = allAreaes
            .where((area) => area.nombre.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _delete(int areaId) async {
    final areaProvider = Provider.of<AreaProvider>(context, listen: false);
    final success = await areaProvider.deleteArea(areaId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Has eliminado correctamente un elemento")),
      );
      _onSearchChanged(_searchController.text); // Update the filtered list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se puede Eliminar esta siendo usado")),
      );
    }
  }

  Future<void> _create([Area? area]) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            right: 20,
            left: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Creando Area",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Nombre',
                ),
              ),
              TextField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripcion',
                  hintText: 'Descripcion',
                ),
              ),
              const SizedBox(height: 10),
              Center(
                
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => Color.fromARGB(255, 243, 146, 146))
              
                  ),
                  onPressed: () async {
                    final String name = _nameController.text;
                    final String descripcion = _descripcionController.text;

                    if (name.isNotEmpty && descripcion.isNotEmpty) {
                      final newArea = Area(
                        areaId: 0, // Placeholder ID, backend should generate
                        nombre: name,
                        descripcion: descripcion,
                        estado: 1, // Default status
                      );

                      final areaProvider = Provider.of<AreaProvider>(context, listen: false);
                      final success = await areaProvider.createArea(newArea);

                      if (success) {
                        Navigator.of(context).pop();
                        _nameController.clear();
                        _descripcionController.clear();
                        _onSearchChanged(_searchController.text); // Actualizar lista filtrada
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Failed to create application")),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("All fields are required")),
                      );
                    }
                  },
                  child: const Text("Agregar"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final areaProvider = Provider.of<AreaProvider>(context);
    final areaes = _filteredAreaes.isEmpty && _searchController.text.isEmpty
        ? areaProvider.areaes
        : _filteredAreaes;

    return Scaffold(
      backgroundColor: miColors.colorMaestroFondo,
      appBar: AppBar(
        backgroundColor: miColors.colorMaestro,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'home');
          },
        ),
        title: isSearchClicked
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(5, 10, 10, 5),
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                      hintText: 'Search..'),
                ),
              )
            : const Text('Lista de Areas'),
        actions: [
          IconButton(
            icon: Icon(isSearchClicked ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearchClicked = !isSearchClicked;
                if (!isSearchClicked) {
                  _searchController.clear();
                  _onSearchChanged(''); // Reset search
                }
              });
            },
          ),
        ],
      ),
      body: Consumer<AreaProvider>(
        builder: (context, areaProvider, child) {
          return ListView.builder(
            itemCount: areaes.length,
            itemBuilder: (context, index) {
              Area area = areaes[index];
              return Card(
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.all(3),
                child: ListTile(
                  title: Text(
                    area.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(area.descripcion),
                  trailing: SizedBox(
                    width: 60,
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.black,
                          onPressed: () => _delete(area.areaId),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: Icon(Icons.add),
        backgroundColor: miColors.colorMaestro,
      ),
    );
  }
}
