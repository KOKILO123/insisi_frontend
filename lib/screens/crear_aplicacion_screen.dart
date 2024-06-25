import 'package:flutter/material.dart';
import 'package:insisi/models/aplicacion.dart';
import 'package:insisi/providers/aplicacion_provider.dart';
import 'package:provider/provider.dart';

class CrearAplicacionScreen extends StatefulWidget {
  @override
  _CrearAplicacionScreenState createState() => _CrearAplicacionScreenState();
}

class _CrearAplicacionScreenState extends State<CrearAplicacionScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final aplicacionProvider = Provider.of<AplicacionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Aplicación'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                Aplicacion nuevaAplicacion = Aplicacion(
                  aplicacionId: 0,
                  nombre: _nombreController.text,
                  descripcion: _descripcionController.text,
                  estado: 1,
                );

                bool success = await aplicacionProvider.createAplicacion(nuevaAplicacion);

                if (success) {
                  Navigator.pop(context); // Regresar a la pantalla anterior
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('No se pudo crear la aplicación'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
