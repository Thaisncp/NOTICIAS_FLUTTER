import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unidad3/controls/servicio_back/FacadeService.dart';
import 'package:unidad3/controls/utiles/Utiles.dart';
import 'package:unidad3/views/NoticiasScreen.dart';
import 'package:validators/validators.dart';
import 'package:unidad3/views/RegisterView.dart';

class SessionView extends StatefulWidget {
  const SessionView({Key? key}) : super(key: key);
  @override
  _SessionViewState createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController correoControl = TextEditingController();
  final TextEditingController claveControl = TextEditingController();

  void _iniciar() {
    setState(() {
      FacadeService servicio = FacadeService();
        if(_formKey.currentState!.validate()){
          Map<String, String> mapa = {
            "correo": correoControl.text,
            "clave": claveControl.text
          };
          servicio.inicioSesion(mapa).then((value) async{

            if(value.code == 200){
              //log(value.datos['token']);
              Utiles util = Utiles();
              util.saveValue('token', value.datos['token']);
              util.saveValue('user', value.datos['user']);
              util.saveValue('external', value.datos['external']);
              util.saveValue('rol', value.datos['rol']);
              final SnackBar msg = SnackBar(content: Text('BIENVENIDO ${value.datos['user']}'));
              ScaffoldMessenger.of(context).showSnackBar(msg);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NoticiasScreen()),
              );
            }else{
              final SnackBar msg = SnackBar(content: Text('Error ${value.tag}'));
              ScaffoldMessenger.of(context).showSnackBar(msg);
              //log(value.tag.toString());
            }
          });

        }else{
          log("Errores");
        }
    });
  }

  void _irARegistro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterView()), // Ajusta el nombre de la clase según sea necesario
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Noticias",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "La mejor app de noticias",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Inicio de sesion",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'correo',
                  suffixIcon: Icon(Icons.alternate_email),
                  labelStyle: TextStyle(color: Colors.white)
                ),
                controller:
                    correoControl, // Mueve esta línea aquí, dentro del TextFormField
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Debe ingresar un correo";
                  }
                  if (!isEmail(value!)) {
                    return "Correo inválido";
                  }
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'clave', suffixIcon: Icon(Icons.key),labelStyle: TextStyle(color: Colors.white)),
                controller:
                    claveControl, // Mueve esta línea aquí, dentro del TextFormField
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Debe ingresar un clave";
                  }
                },
                obscureText: true,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                  child: const Text("Inicio"), onPressed: _iniciar),
            ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: ElevatedButton(
            child: const Text("Registrarse"),
            onPressed: _irARegistro,
          ),
        ),
          ],
        ),
      ),
    );
  }
}
