
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:unidad3/controls/servicio_back/FacadeService.dart';
import 'package:intl/intl.dart';
import 'package:validators/validators.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombreC = TextEditingController();
  final TextEditingController apellidoC = TextEditingController();
  final TextEditingController direccionC = TextEditingController();
  final TextEditingController celularC = TextEditingController();
  final TextEditingController correoC = TextEditingController();
  final TextEditingController claveC = TextEditingController();

  void _registrar() {
    setState(() {
      FacadeService servicio = FacadeService();

      if (_formKey.currentState!.validate()) {
        Map<String, String> mapa = {
          "nombres": nombreC.text,
          "apellidos": apellidoC.text,
          "direccion": direccionC.text,
          "celular": celularC.text,
          "correo": correoC.text,
          "clave": claveC.text
        };
        log(mapa.toString());
        servicio.registrarUsuario(mapa).then((value) async {
          if (value.code == 200) {
            final SnackBar msg =
            SnackBar(content: Text('Success: ${value.tag}'));
            ScaffoldMessenger.of(context).showSnackBar(msg);
          } else {
            log(value.msg.toString());
            log(value.code.toString());
            final SnackBar msg = SnackBar(content: Text('Error: ${value.code}'));
            ScaffoldMessenger.of(context).showSnackBar(msg);
          }
        });
      } else {
        log("Error");
      }
    });
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
                "Registro Usuarios",
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
                "La mejor app de Noticias",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                  controller: nombreC,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Debe ingresar sus nombres";
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Nombres',
                    labelStyle: TextStyle(color: Colors.white), // Ajusta el color del texto
                  )),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: apellidoC,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar sus apellidos";
                  }
                },
                decoration: const InputDecoration(labelText: 'Apellidos', labelStyle: TextStyle(color: Colors.white),),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: direccionC,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar su direccion";
                  }
                },
                decoration: const InputDecoration(labelText: 'Direccion',labelStyle: TextStyle(color: Colors.white),),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: celularC,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar sus nro de celular";
                  }
                },
                decoration: const InputDecoration(labelText: 'Celular',labelStyle: TextStyle(color: Colors.white),),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: correoC,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar su correo";
                  }
                  if (!isEmail(value)) {
                    return "Debe ingresar un correo valido";
                  }
                },
                decoration: const InputDecoration(
                    labelText: 'Correo',
                    suffixIcon: Icon(Icons.alternate_email),labelStyle: TextStyle(color: Colors.white),),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: claveC,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Debe ingresar su clave";
                  }
                },
                decoration: const InputDecoration(
                    labelText: 'Clave', suffixIcon: Icon(Icons.key),labelStyle: TextStyle(color: Colors.white),),
                obscureText: true,
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text("Registrar"),
                onPressed: () => (_registrar()),
              ),
            ),
            Row(
              children: <Widget>[
                const Text("Ya tienes una cuenta"),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/home");
                    },
                    child: const Text(
                      "Inicio de Sesion",
                      style: TextStyle(fontSize: 15),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}