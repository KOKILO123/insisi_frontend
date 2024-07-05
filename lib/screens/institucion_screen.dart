import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:insisi/providers/institucion_provider.dart';
import 'package:insisi/models/institucion.dart';
import 'package:provider/provider.dart';
import 'package:insisi/util/colors.dart';

class InstitucionesScreen extends StatefulWidget {
  @override
  _InstitucionesScreenState createState() => _InstitucionesScreenState();
}

class _InstitucionesScreenState extends State<InstitucionesScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _siglaController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Institucion> _filteredInstituciones = [];
  bool isSearchClicked = false;

  @override
  void initState() {
    super.initState();
    final institucionProvider = Provider.of<InstitucionProvider>(context, listen: false);
    institucionProvider.fetchInstituciones(); // Fetch instituciones on init
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
    final institucionProvider = Provider.of<InstitucionProvider>(context, listen: false);
    final allInstituciones = institucionProvider.instituciones;
    setState(() {
      if (value.isEmpty) {
        _filteredInstituciones = allInstituciones;
      } else {
        _filteredInstituciones = allInstituciones
            .where((institucion) => institucion.nombre.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _delete(int institucionId) async {
    final institucionProvider = Provider.of<InstitucionProvider>(context, listen: false);
    final success = await institucionProvider.deleteInstitucion(institucionId);
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

  Future<void> _create([Institucion? institucion]) async {
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
                  "Creando Institucion",
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
              TextField(
                controller: _siglaController,
                decoration: const InputDecoration(
                  labelText: 'Sigla',
                  hintText: 'Sigla',
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
                    final String sigla = _siglaController.text;

                    if (name.isNotEmpty && descripcion.isNotEmpty) {
                      final newInstitucion = Institucion(
                        institucionId: 0, // Placeholder ID, backend should generate
                        nombre: name,
                        descripcion: descripcion,
                        sigla: sigla,
                        estado: 1, // Default status
                      );

                      final institucionProvider = Provider.of<InstitucionProvider>(context, listen: false);
                      final success = await institucionProvider.createInstitucion(newInstitucion);

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
    final institucionProvider = Provider.of<InstitucionProvider>(context);
    final instituciones = _filteredInstituciones.isEmpty && _searchController.text.isEmpty
        ? institucionProvider.instituciones
        : _filteredInstituciones;

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
                  color: const Color.fromARGB(255, 92, 39, 176),
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
            : const Text('Lista Instituciones'),
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
      body: Consumer<InstitucionProvider>(
        builder: (context, institucionProvider, child) {
          return ListView.builder(
            itemCount: instituciones.length,
            itemBuilder: (context, index) {
              Institucion institucion = instituciones[index];
              return Card(
                color: const Color.fromARGB(255, 92, 39, 176),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.all(3),
                child: ListTile(
                  title: Text(
                    institucion.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(institucion.descripcion),
                  trailing: SizedBox(
                    width: 60,
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.black,
                          onPressed: () => _delete(institucion.institucionId),
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
