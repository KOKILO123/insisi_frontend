import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:insisi/providers/aplicacion_provider.dart';
import 'package:insisi/models/aplicacion.dart';
import 'package:provider/provider.dart';
import 'package:insisi/util/colors.dart';

class AplicacionesScreen extends StatefulWidget {
  @override
  _AplicacionesScreenState createState() => _AplicacionesScreenState();
}

class _AplicacionesScreenState extends State<AplicacionesScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Aplicacion> _filteredAplicaciones = [];
  bool isSearchClicked = false;

  @override
  void initState() {
    super.initState();
    final aplicacionProvider = Provider.of<AplicacionProvider>(context, listen: false);
    aplicacionProvider.fetchAplicaciones(); // Fetch aplicaciones on init
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
    final aplicacionProvider = Provider.of<AplicacionProvider>(context, listen: false);
    final allAplicaciones = aplicacionProvider.aplicaciones;
    setState(() {
      if (value.isEmpty) {
        _filteredAplicaciones = allAplicaciones;
      } else {
        _filteredAplicaciones = allAplicaciones
            .where((aplicacion) => aplicacion.nombre.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _delete(int aplicacionId) async {
    final aplicacionProvider = Provider.of<AplicacionProvider>(context, listen: false);
    final success = await aplicacionProvider.deleteAplicacion(aplicacionId);
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

  Future<void> _create([Aplicacion? aplicacion]) async {
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
                  "Creando Aplicacion",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'SIAF',
                ),
              ),
              TextField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripcion',
                  hintText: 'Sistema Integrado de Administracion Financiera',
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
                      final newAplicacion = Aplicacion(
                        aplicacionId: 0, // Placeholder ID, backend should generate
                        nombre: name,
                        descripcion: descripcion,
                        estado: 1, // Default status
                      );

                      final aplicacionProvider = Provider.of<AplicacionProvider>(context, listen: false);
                      final success = await aplicacionProvider.createAplicacion(newAplicacion);

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
    final aplicacionProvider = Provider.of<AplicacionProvider>(context);
    final aplicaciones = _filteredAplicaciones.isEmpty && _searchController.text.isEmpty
        ? aplicacionProvider.aplicaciones
        : _filteredAplicaciones;

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
                  color: const Color.fromARGB(255, 95, 226, 77),
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
            : const Text('Lista Aplicaciones'),
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
      body: Consumer<AplicacionProvider>(
        builder: (context, aplicacionProvider, child) {
          return ListView.builder(
            itemCount: aplicaciones.length,
            itemBuilder: (context, index) {
              Aplicacion aplicacion = aplicaciones[index];
              return Card(
                color: const Color.fromARGB(255, 147, 175, 76),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.all(3),
                child: ListTile(
                  title: Text(
                    aplicacion.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(aplicacion.descripcion),
                  trailing: SizedBox(
                    width: 60,
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.black,
                          onPressed: () => _delete(aplicacion.aplicacionId),
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
        //focusColor: miColors.colorMaestroFondo,
        backgroundColor: miColors.colorMaestro,
        tooltip: "Aregar",
      ),
    );
  }
}
