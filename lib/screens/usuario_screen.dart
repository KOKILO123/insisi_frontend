import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:insisi/models/area.dart';
import 'package:insisi/models/usuario.dart';
import 'package:insisi/providers/aplicacion_provider.dart';
import 'package:insisi/models/aplicacion.dart';
import 'package:insisi/providers/area_provider.dart';
import 'package:insisi/providers/institucion_provider.dart';
import 'package:insisi/providers/tipo_usuario_provider.dart';
import 'package:insisi/providers/usuario_provider.dart';
import 'package:provider/provider.dart';
import 'package:insisi/util/colors.dart';

class UsuariosScreen extends StatefulWidget {
  @override
  _UsuariosScreenState createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Usuario> _filteredUsuarios = [];
  bool isSearchClicked = false;
  int? _selectedIntitucionId;
  int? _selectedAreaId;
  int? _selectedTipoUsuarioId;

  @override
  void initState() {
    super.initState();
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    usuarioProvider.fetchUsuarios(); 
    final institucionProvider = Provider.of<InstitucionProvider>(context, listen: false);
    institucionProvider.fetchInstituciones();
    final areaProvider = Provider.of<AreaProvider>(context, listen: false);
    areaProvider.fetchAreaes();
    final tipoUsuarioProvider = Provider.of<TipoUsuarioProvider>(context, listen: false);
    tipoUsuarioProvider.fetchTipoUsuarioes();
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nombreController.dispose();
    _usuarioController.dispose();
    _claveController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final allUsuarios = usuarioProvider.usuariosx;
    setState(() {
      if (value.isEmpty) {
        _filteredUsuarios = allUsuarios;
      } else {
        _filteredUsuarios = allUsuarios
            .where((usuario) => usuario.nombre.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _delete(int usuarioId) async {
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final success = await usuarioProvider.deleteUsuario(usuarioId);
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

  Future<void> _create([Usuario? usuario]) async {
    final institucionProvider = Provider.of<InstitucionProvider>(context, listen: false);
    final instituciones = institucionProvider.instituciones;
    final areaProvider = Provider.of<AreaProvider>(context, listen: false);
    final areas = areaProvider.areaes;
    final tipoUsuarioProvider = Provider.of<TipoUsuarioProvider>(context, listen: false);
    final tipoUsuarios = tipoUsuarioProvider.tipoUsuarioes;
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
                  "Creando Usuario",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              DropdownButton<int>(
                value: _selectedIntitucionId,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedIntitucionId = newValue;
                  });
                },
                items: instituciones.map<DropdownMenuItem<int>>((institucion) {
                  return DropdownMenuItem<int>(
                    value: institucion.institucionId,
                    child: Text(institucion.nombre),
                  );
                }).toList(),
                hint: const Text("Seleccione una Institucion"),
                isExpanded: true,
              ),
              DropdownButton<int>(
                value: _selectedAreaId,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedAreaId = newValue;
                  });
                },
                items: areas.map<DropdownMenuItem<int>>((area) {
                  return DropdownMenuItem<int>(
                    value: area.areaId,
                    child: Text(area.nombre),
                  );
                }).toList(),
                hint: const Text("Seleccione una Area"),
                isExpanded: true,
              ),
              DropdownButton<int>(
                value: _selectedTipoUsuarioId,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedTipoUsuarioId = newValue;
                  });
                },
                items: tipoUsuarios.map<DropdownMenuItem<int>>((tipoUsuario) {
                  return DropdownMenuItem<int>(
                    value: tipoUsuario.tipoUsuarioId,
                    child: Text(tipoUsuario.nombre),
                  );
                }).toList(),
                hint: const Text("Seleccione un tipo de Usuario"),
                isExpanded: true,
              ),
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Nombre',
                ),
              ),
              TextField(
                controller: _usuarioController,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  hintText: 'Usuario',
                ),
              ),
              TextField(
                controller: _claveController,
                decoration: const InputDecoration(
                  labelText: 'Clave',
                  hintText: 'Clave',
                ),
              ),
              const SizedBox(height: 10),
              Center(
                
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => Color.fromARGB(255, 243, 146, 146))
              
                  ),
                  onPressed: () async {
                    final String nombre = _nombreController.text;
                    final String usuario = _usuarioController.text;
                    final String clave = _claveController.text;
                    final String descripcion = _descripcionController.text;

                    if (nombre.isNotEmpty && usuario.isNotEmpty && clave.isNotEmpty
                      && _selectedIntitucionId != null && _selectedAreaId != null
                      && _selectedTipoUsuarioId != null) {
                      final newUsuario = Usuario(
                        usuarioId: 0,
                        institucionId:_selectedIntitucionId!, 
                        areaId:_selectedAreaId!,
                        tipoUsuarioid:_selectedTipoUsuarioId!,
                        nombre: nombre,
                        usuario: usuario,
                        clave: clave,
                        estado: 1, // Default status
                      );

                      //final aplicacionProvider = Provider.of<AplicacionProvider>(context, listen: false);
                      final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
                      final success = await usuarioProvider.createUsuario(newUsuario);

                      if (success) {
                        Navigator.of(context).pop();
                        _nombreController.clear();
                        _usuarioController.clear();
                        _claveController.clear();
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
    final usuarioProvider = Provider.of<UsuarioProvider>(context);
    final usuarios = _filteredUsuarios.isEmpty && _searchController.text.isEmpty
        ? usuarioProvider.usuariosx
        : _filteredUsuarios;

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
                  color: Colors.green,
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
            : const Text('Lista Usuarios'),
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
      body: Consumer<UsuarioProvider>(
        builder: (context, usuarioProvider, child) {
          return ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              Usuario usuario = usuarios[index];
              return Card(
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.all(3),
                child: ListTile(
                  title: Text(
                    usuario.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(usuario.usuario),
                  trailing: SizedBox(
                    width: 60,
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.black,
                          onPressed: () => _delete(usuario.usuarioId),
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
