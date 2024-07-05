import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:insisi/providers/aplicacion_provider.dart';
import 'package:insisi/providers/tipo_incidencia_provider.dart';
import 'package:insisi/models/tipoIncidencia.dart';
import 'package:provider/provider.dart';
import 'package:insisi/util/colors.dart';

class TipoIncidenciaesScreen extends StatefulWidget {
  @override
  _TipoIncidenciaesScreenState createState() => _TipoIncidenciaesScreenState();
}

class _TipoIncidenciaesScreenState extends State<TipoIncidenciaesScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<TipoIncidencia> _filteredTipoIncidenciaes = [];
  bool isSearchClicked = false;
  int? _selectedAplicacionId;

  @override
  void initState() {
    super.initState();
    final tipoIncidenciaProvider = Provider.of<TipoIncidenciaProvider>(context, listen: false);
    tipoIncidenciaProvider.fetchTipoIncidenciaes(); // Fetch tipoIncidenciaes on init
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
    final tipoIncidenciaProvider = Provider.of<TipoIncidenciaProvider>(context, listen: false);
    final allTipoIncidenciaes = tipoIncidenciaProvider.tipoIncidenciaes;
    setState(() {
      if (value.isEmpty) {
        _filteredTipoIncidenciaes = allTipoIncidenciaes;
      } else {
        _filteredTipoIncidenciaes = allTipoIncidenciaes
            .where((tipoIncidencia) => tipoIncidencia.nombre.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _delete(int tipoIncidenciaId) async {
    final tipoIncidenciaProvider = Provider.of<TipoIncidenciaProvider>(context, listen: false);
    final success = await tipoIncidenciaProvider.deleteTipoIncidencia(tipoIncidenciaId);
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

  Future<void> _create([TipoIncidencia? tipoIncidencia]) async {
    final aplicacionProvider = Provider.of<AplicacionProvider>(context, listen: false);
    final aplicaciones = aplicacionProvider.aplicaciones;
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Creando TipoIncidencia",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              DropdownButton<int>(
                value: _selectedAplicacionId,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedAplicacionId = newValue;
                  });
                },
                items: aplicaciones.map<DropdownMenuItem<int>>((aplicacion) {
                  return DropdownMenuItem<int>(
                    value: aplicacion.aplicacionId,
                    child: Text(aplicacion.nombre),
                  );
                }).toList(),
                hint: const Text("Seleccione un área"),
                isExpanded: true,
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
                    backgroundColor: MaterialStateColor.resolveWith((states) => Color.fromARGB(255, 243, 146, 146)),
                  ),
                  onPressed: () async {
                    final String name = _nameController.text;
                    final String descripcion = _descripcionController.text;

                    if (name.isNotEmpty && descripcion.isNotEmpty && _selectedAplicacionId != null) {
                      final newTipoIncidencia = TipoIncidencia(
                        tipoIncidenciaId: 0,
                        aplicacionId: _selectedAplicacionId!,
                        nombre: name,
                        descripcion: descripcion,
                        estado: 1, // Default status
                      );

                      final tipoIncidenciaProvider = Provider.of<TipoIncidenciaProvider>(context, listen: false);
                      final success = await tipoIncidenciaProvider.createTipoIncidencia(newTipoIncidencia);

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
    final tipoIncidenciaProvider = Provider.of<TipoIncidenciaProvider>(context);
    final tipoIncidenciaes = _filteredTipoIncidenciaes.isEmpty && _searchController.text.isEmpty
        ? tipoIncidenciaProvider.tipoIncidenciaes
        : _filteredTipoIncidenciaes;

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
                  color: Colors.purple,
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
            : const Text('Lista TipoIncidenciaes'),
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
      body: Consumer<TipoIncidenciaProvider>(
        builder: (context, tipoIncidenciaProvider, child) {
          return ListView.builder(
            itemCount: tipoIncidenciaes.length,
            itemBuilder: (context, index) {
              TipoIncidencia tipoIncidencia = tipoIncidenciaes[index];
              return Card(
                color: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.all(3),
                child: ListTile(
                  title: Text(
                    tipoIncidencia.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(tipoIncidencia.descripcion),
                  trailing: SizedBox(
                    width: 60,
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.black,
                          onPressed: () => _delete(tipoIncidencia.tipoIncidenciaId),
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
