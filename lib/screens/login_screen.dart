import 'package:flutter/material.dart';
import 'package:insisi/models/usuario.dart';
import 'package:insisi/providers/usuario_provider.dart';
import 'package:insisi/widgets/input_decoration.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //return Container();
    final size=MediaQuery.of(context).size;
    return Scaffold(
      body:SizedBox(
        width: double.infinity,
        height: double.infinity,
        //color: Color.fromARGB(10, 10, 10, 0.75),
        child: Stack(
          children: [
            CajaCabecera(size),
            Icono(),
            LoginForm(context)
          ],
        ),
      ),
    );
  }

  SingleChildScrollView LoginForm(BuildContext context) {
    final usuarioProvider=Provider.of<UsuarioProvider>(context);
    var txtUsuario=TextEditingController();
    var txtClave=TextEditingController();
    return SingleChildScrollView(
      child: Column(
              children: [
                const SizedBox(height: 300),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  width: double.infinity,
                  //height: 320,
                  decoration:BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [ BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      offset: Offset(0, 5)
                    )]
                  ),
                  child:Column(
                    children: [
                      const SizedBox(height:10),
                      Text('Login',style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height:30),
                      Container(
                        child: Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              TextFormField(
                                autocorrect: false,
                                controller: txtUsuario,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecorations.inputDecoration(hinttext: 'Usuario', labeltext: 'Usuario', icono: const Icon(Icons.supervised_user_circle_sharp))  
                                
                              ),
                              const SizedBox(height:10),
                              TextFormField(
                                autocorrect: false, 
                                controller: txtClave,
                                obscureText: true, 
                                decoration: InputDecorations.inputDecoration(hinttext: '************', labeltext: 'Contraseña', icono: const Icon(Icons.lock_outline)) ,
                                validator: (value){
                                  return (value!=null && value.length >=6) ? null : 'La contraseña debe ser mayor igual  a 6 caracteres';
                                },                          
                              ),
                              const SizedBox(height:20),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                                  disabledColor: Colors.grey,
                                  color: const Color.fromARGB(255, 196, 37, 37),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 15),
                                    child: const Text('Ingresar',style: TextStyle(color: Colors.white),),
                                  ),
                                  onPressed:() async {
                                    //var usuario=usuarioProvider.getUsuario(txtUsuario.text,txtClave.text);
                                    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
                                    final List<Usuario> usuarios = await usuarioProvider.getUsuario(txtUsuario.text, txtClave.text);
                                    if(usuarios.length==0){
                                      
                                    }else{
                                      Navigator.pushReplacementNamed(context, 'home');
                                      for (var usuario in usuarios) {
                                      print(usuario.clave); // Ajusta según los campos de la clase Usuario
                                    }
                                    }
                                    
                                    //Navigator.pushReplacementNamed(context, 'home');
                                  } ,

                              )
                            ],
                          )
                        ),
                      )
                    ],
                  )
                ),
                const SizedBox(height: 50),
                const Text('Crear una nueva Cuenta',
                  style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold)
                )
              ],
            ),
    );
  }

  SafeArea Icono() {
    return SafeArea(
            child: Container(  
              margin: const EdgeInsets.only(top: 30),           
              width: double.infinity,
              child: const Icon(
                Icons.person_pin,
                color: Colors.white,
                size: 100,
              )
                
              ),
          );
  }

  Container CajaCabecera(Size size) {
    return Container(
            //color: Color.fromARGB(255, 196, 37, 37),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 196, 37, 37),
                Color.fromARGB(255, 233, 66, 66)
              ])
            ),
            width: double.infinity,
            height: size.height * 0.4,
            child: Stack(
              children: [
                Positioned(top:90,left:30,child: Burbuja()),
                Positioned(top:-40,left:-30,child: Burbuja()),
                Positioned(top:-50,right:-20,child: Burbuja()),
                Positioned(bottom:-50,left:10,child: Burbuja()),
                Positioned(bottom:120,right:20,child: Burbuja()),                
              ],
            ),
            
          );
  }

  Container Burbuja() {
    return Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color.fromARGB(255, 233, 66, 66))                  
                );
  }
}