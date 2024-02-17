import 'dart:developer';

import 'package:flutter/material.dart';
import '../controls/servicio_back/FacadeService.dart';
import '../controls/utiles/Utiles.dart';
import 'MenuBarP.dart';

class EditarDatosPersona extends StatefulWidget {
  // Aquí puedes añadir más propiedades necesarias, como el external_id de la persona

  @override
  _EditarDatosPersonaState createState() => _EditarDatosPersonaState();
}

class _EditarDatosPersonaState extends State<EditarDatosPersona> {
  TextEditingController _nombresController = TextEditingController();
  TextEditingController _apellidosController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();
  TextEditingController _celularController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Aquí puedes inicializar los controladores con los valores actuales de la persona
    // Por ejemplo:
    _nombresController.text = "Nombre Actual";
    _apellidosController.text = "Apellido Actual";
    _direccionController.text = "Dirección Actual";
    _celularController.text = "Celular Actual";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Editar perfil",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 22),
        ),
        elevation: 10,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey,
        actions: const [MenuBarP()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombres:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            TextFormField(
              controller: _nombresController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Escribe los nuevos nombres...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                border: OutlineInputBorder(),
              ),
              onTap: () {
                setState(() {
                  _nombresController.text = '';
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'Apellidos:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            TextFormField(
              controller: _apellidosController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Escribe los nuevos apellidos...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                border: OutlineInputBorder(),
              ),
              onTap: () {
                setState(() {
                  _apellidosController.text = '';
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'Dirección:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            TextFormField(
              controller: _direccionController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Escribe la nueva dirección...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                border: OutlineInputBorder(),
              ),
              onTap: () {
                setState(() {
                  _direccionController.text = '';
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'Celular:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            TextFormField(
              controller: _celularController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Escribe el nuevo número de celular...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                border: OutlineInputBorder(),
              ),
              onTap: () {
                setState(() {
                  _celularController.text = '';
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _editarDatosPersona();
              },
              child: Text('Editar Datos'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editarDatosPersona() async {
    FacadeService servicio = FacadeService();
    Utiles util = Utiles();
    var user = await util.getValue("external");

    if (user != null) {
      Map<String, String> mapa = {
        "nombres": _nombresController.text,
        "apellidos": _apellidosController.text,
        "direccion": _direccionController.text,
        "celular": _celularController.text,
        "external": user,
      };

      servicio.editarDatosPersona(mapa).then((value) async {
        if (value?.code == 200) {
          final SnackBar msg = SnackBar(content: Text('Success: ${value!.tag}'));
          ScaffoldMessenger.of(context).showSnackBar(msg);
          Navigator.pushNamed(context, "/principal");
        } else {
          final SnackBar msg = SnackBar(content: Text('Error: ${value?.tag ?? "Unknown error"}'));
          ScaffoldMessenger.of(context).showSnackBar(msg);
        }
      });
    } else {
      log("Error: El external_id de la persona es nulo");
    }
  }
}
