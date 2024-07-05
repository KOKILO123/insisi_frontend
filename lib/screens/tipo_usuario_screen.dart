import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:insisi/providers/tipo_usuario_provider.dart';
import 'package:insisi/models/tipoUsuario.dart';
import 'package:provider/provider.dart';
import 'package:insisi/util/colors.dart';

class TipoUsuarioesScreen extends StatefulWidget {
  @override
  _TipoUsuarioesScreenState createState() => _TipoUsuarioesScreenState();
}

class _TipoUsuarioesScreenState extends State<TipoUsuarioesScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<TipoUsuario> _filteredTipoUsuarioes = [];
  bool isSearchClicked = false;

  @override
  void initState() {
    super.initState();
    final tipoUsuarioProvider = Provider.of<TipoUsuarioProvider>(context, listen: false);
    tipoUsuarioProvider.fetchTipoUsuarioes(); // Fetch tipoUsuarioes on init
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
    final tipoUsuarioProvider = Provider.of<TipoUsuarioProvider>(context, listen: false);
    final allTipoUsuarioes = tipoUsuarioProvider.tipoUsuarioes;
    setState(() {
      if (value.isEmpty) {
        _filteredTipoUsuarioes = allTipoUsuarioes;
      } else {
        _filteredTipoUsuarioes = allTipoUsuarioes
            .where((tipoUsuario) => tipoUsuario.nombre.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _delete(int tipoUsuarioId) async {
    final tipoUsuarioProvider = Provider.of<TipoUsuarioProvider>(context, listen: false);
    final success = await tipoUsuarioProvider.deleteTipoUsuario(tipoUsuarioId);
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

  Future<void> _create([TipoUsuario? tipoUsuario]) async {
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
                  "Creando TipoUsuario",
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
                  hintText: 'Descipcion',
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
                      final newTipoUsuario = TipoUsuario(
                        tipoUsuarioId: 0, // Placeholder ID, backend should generate
                        nombre: name,
                        descripcion: descripcion,
                        estado: 1, // Default status
                      );

                      final tipoUsuarioProvider = Provider.of<TipoUsuarioProvider>(context, listen: false);
                      final success = await tipoUsuarioProvider.createTipoUsuario(newTipoUsuario);

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
    final tipoUsuarioProvider = Provider.of<TipoUsuarioProvider>(context);
    final tipoUsuarioes = _filteredTipoUsuarioes.isEmpty && _searchController.text.isEmpty
        ? tipoUsuarioProvider.tipoUsuarioes
        : _filteredTipoUsuarioes;

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
                  color: const Color.fromARGB(255, 39, 94, 176),
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
            : const Text('Lista TipoUsuarioes'),
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
      body: Consumer<TipoUsuarioProvider>(
        builder: (context, tipoUsuarioProvider, child) {
          return ListView.builder(
            itemCount: tipoUsuarioes.length,
            itemBuilder: (context, index) {
              TipoUsuario tipoUsuario = tipoUsuarioes[index];
              return Card(
                color: const Color.fromARGB(255, 39, 94, 176),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    tipoUsuario.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(tipoUsuario.descripcion),
                  trailing: SizedBox(
                    width: 60,
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.black,
                          onPressed: () => _delete(tipoUsuario.tipoUsuarioId),
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
