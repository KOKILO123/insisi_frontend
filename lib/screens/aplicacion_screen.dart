import 'package:flutter/material.dart';
import 'package:insisi/providers/aplicacion_provider.dart';
import 'package:insisi/models/aplicacion.dart';
import 'package:provider/provider.dart';

class AplicacionesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final aplicacionProvider = Provider.of<AplicacionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Aplicaciones'),
      ),
      body: FutureBuilder<List<Aplicacion>>(
        future: aplicacionProvider.getAplicaciones(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay aplicaciones disponiblesss'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Aplicacion aplicacion = snapshot.data![index];
                return ListTile(
                  title: Text(aplicacion.nombre),
                  subtitle: Text(aplicacion.descripcion),
                  onTap: () {
                    // Implementar navegación a pantalla de edición o detalle
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implementar navegación a pantalla de creación
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
