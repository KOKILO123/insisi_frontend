import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:insisi/models/area.dart';
import 'package:insisi/models/incidencia.dart';
import 'package:insisi/providers/aplicacion_provider.dart';
import 'package:insisi/models/aplicacion.dart';
import 'package:insisi/providers/area_provider.dart';
import 'package:insisi/providers/institucion_provider.dart';
import 'package:insisi/providers/prioridad_provider.dart';
import 'package:insisi/providers/tipo_incidencia_provider.dart';
import 'package:insisi/providers/incidencia_provider.dart';
import 'package:provider/provider.dart';
import 'package:insisi/util/colors.dart';

class IncidenciasScreen extends StatefulWidget {
  @override
  _IncidenciasScreenState createState() => _IncidenciasScreenState();
}

class _IncidenciasScreenState extends State<IncidenciasScreen> {
  final TextEditingController _incidenciaController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Incidencia> _filteredIncidencias = [];
  bool isSearchClicked = false;
  int? _selectedAreaId;
  int? _selectedTipoIncidenciaId;
  int? _selectedPrioridadId;

  @override
  void initState() {
    super.initState();
    final incidenciaProvider = Provider.of<IncidenciaProvider>(context, listen: false);
    incidenciaProvider.fetchIncidencias(); 
    final prioridadProvider = Provider.of<PrioridadProvider>(context, listen: false);
    prioridadProvider.fetchPrioridades();
    final areaProvider = Provider.of<AreaProvider>(context, listen: false);
    areaProvider.fetchAreaes();
    final tipoIncidenciaProvider = Provider.of<TipoIncidenciaProvider>(context, listen: false);
    tipoIncidenciaProvider.fetchTipoIncidenciaes();
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _incidenciaController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final incidenciaProvider = Provider.of<IncidenciaProvider>(context, listen: false);
    final allIncidencias = incidenciaProvider.incidenciasx;
    setState(() {
      if (value.isEmpty) {
        _filteredIncidencias = allIncidencias;
      } else {
        _filteredIncidencias = allIncidencias
            .where((incidencia) => incidencia.descripcion.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _delete(int incidenciaId) async {
    final incidenciaProvider = Provider.of<IncidenciaProvider>(context, listen: false);
    final success = await incidenciaProvider.deleteIncidencia(incidenciaId);
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

  Future<void> _create([Incidencia? incidencia]) async {
    final tipoIncidenciaProvider = Provider.of<TipoIncidenciaProvider>(context, listen: false);
    final tipoIncidencias = tipoIncidenciaProvider.tipoIncidenciaes;
    final areaProvider = Provider.of<AreaProvider>(context, listen: false);
    final areas = areaProvider.areaes;
    
     final prioridadProvider = Provider.of<PrioridadProvider>(context, listen: false);
    final prioridades = prioridadProvider.prioridades;
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
                  "Creando Incidencia",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
               DropdownButton<int>(
                value: _selectedTipoIncidenciaId,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedTipoIncidenciaId = newValue;
                  });
                },
                items: tipoIncidencias.map<DropdownMenuItem<int>>((tipoIncidencia) {
                  return DropdownMenuItem<int>(
                    value: tipoIncidencia.tipoIncidenciaId,
                    child: Text(tipoIncidencia.nombre),
                  );
                }).toList(),
                hint: const Text("Seleccione un tipo de Incidencia"),
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
                value: _selectedPrioridadId,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedPrioridadId = newValue;
                  });
                },
                items: prioridades.map<DropdownMenuItem<int>>((prioridad) {
                  return DropdownMenuItem<int>(
                    value: prioridad.prioridadId,
                    child: Text(prioridad.nombre),
                  );
                }).toList(),
                hint: const Text("Seleccione una Prioridad"),
                isExpanded: true,
              ),
             
              TextField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripcion',
                  hintText: 'Descripcion',
                ),
                maxLines: 4,  // Allows for an unlimited number of lines
                keyboardType: TextInputType.multiline,
              ),
             
              
              const SizedBox(height: 10),
              Center(
                
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => Color.fromARGB(255, 243, 146, 146))
              
                  ),
                  onPressed: () async {
                    final String descripcion = _descripcionController.text;
                    

                    if (descripcion.isNotEmpty  && _selectedAreaId != null
                      && _selectedTipoIncidenciaId != null) {
                        
                      final newIncidencia = Incidencia(
                        incidenciaId: 0,
                        tipoIncidenciaId:_selectedTipoIncidenciaId!,
                        areaId:_selectedAreaId!,                        
                        prioridadId:_selectedPrioridadId!, 
                        usuarioId: 0,
                        //fechaSolicitado: null,
                        descripcion: descripcion,
                        estado: 1, // Default status
                      );
                      print(newIncidencia);
                      //final aplicacionProvider = Provider.of<AplicacionProvider>(context, listen: false);
                      final incidenciaProvider = Provider.of<IncidenciaProvider>(context, listen: false);
                      final success = await incidenciaProvider.createIncidencia(newIncidencia);

                      if (success) {
                        Navigator.of(context).pop();
                        _descripcionController.clear();
                        _onSearchChanged(_searchController.text); // Actualizar lista filtrada
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Error al crear Incidencia")),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("All fields are required")),
                      );
                    }
                  },
                  child: const Text("Agregarddd"),
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
    final incidenciaProvider = Provider.of<IncidenciaProvider>(context);
    final incidencias = _filteredIncidencias.isEmpty && _searchController.text.isEmpty
        ? incidenciaProvider.incidenciasx
        : _filteredIncidencias;

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
            : const Text('Lista Incidencias'),
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
      body: Consumer<IncidenciaProvider>(
        builder: (context, incidenciaProvider, child) {
          return ListView.builder(
            itemCount: incidencias.length,
            itemBuilder: (context, index) {
              Incidencia incidencia = incidencias[index];
              return Card(
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.all(3),
                child: ListTile(
                  title: Text(
                    incidencia.descripcion,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(incidencia.areaId.toString()),
                  trailing: SizedBox(
                    width: 60,
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.black,
                          onPressed: () => _delete(incidencia.incidenciaId),
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
