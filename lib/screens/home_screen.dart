import 'package:flutter/material.dart';
import 'package:insisi/providers/usuario_provider.dart';
import 'package:insisi/util/colors.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final usuarioProvider = Provider.of<UsuarioProvider>(context);
    String usuario = usuarioProvider.usuarios.first.usuario;
    int usuarioId = usuarioProvider.usuarios.first.usuarioId;
    int areId = usuarioProvider.usuarios.first.areaId;
    String usuarioNombre = usuarioProvider.usuarios.first.nombre;

  String? selectedUsuario;
  final TextEditingController txtClave = TextEditingController();
  final TextEditingController txtIncidencia = TextEditingController();

     return Scaffold(
      backgroundColor: miColors.colorMaestroFondo,
      appBar: AppBar(
        backgroundColor: miColors.colorMaestro,
        title: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 16.0,
              color: miColors.colorTexto,
              fontWeight: FontWeight.bold,
            ),
            children: [
              const TextSpan(text: 'Usuario: '),
              TextSpan(
                text: usuarioNombre ?? '',               
              ),
            ],
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context)
                    .openDrawer(); // Abre el Drawer al hacer clic en el icono
              },
              icon: const Icon(
                Icons.menu,
                size: 30.0,
                color: miColors.colorLogo,
              ),
            );
          },
        ),
        actions: [
          InkWell(
            onTap: () {
              // Lógica para cerrar sesión
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: IconButton(
                onPressed: () {
                  // Lógica para cerrar sesión
                  //avigator.pop(context);
                  Navigator.pushReplacementNamed(context, 'login');
                },
                icon: const Icon(
                  Icons.exit_to_app,
                  size: 30.0,
                  color: miColors.colorLogo,
                ),
              ),
            ),
          ),
        ],
      ),
     body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Incidencia',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Tipo de Incidencia',
                  border: OutlineInputBorder(),
                ),
                value: selectedUsuario,
                items: <String>['Incidencia1', 'Incidencia2', 'Incidencia3']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  /*setState(() {
                    selectedUsuario = newValue!;
                  });*/
                },
              ),
              /*SizedBox(height: 20),
              TextField(
                controller: txtClave,
                decoration: InputDecoration(
                  labelText: 'Clave',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),*/
              SizedBox(height: 20),
              TextField(
                controller: txtIncidencia,
                decoration: InputDecoration(
                  labelText: 'Descripcion',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  //await autenticarYRecorrerUsuarios(context);
                },
                child: Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
