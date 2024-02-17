import 'dart:developer';

import 'package:flutter/material.dart';
import '../controls/servicio_back/FacadeService.dart';
import '../controls/utiles/Utiles.dart';
import '../models/ComentarioModel.dart';
import 'MenuBarP.dart';

class EditarComentario extends StatefulWidget {
  final ComentarioModel comentario;

  const EditarComentario({Key? key, required this.comentario}) : super(key: key);

  @override
  _EditarComentarioState createState() => _EditarComentarioState();
}

class _EditarComentarioState extends State<EditarComentario> {
  TextEditingController _comentarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _comentarioController.text = widget.comentario.cuerpo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Editar comentario",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 22),
        ),
        elevation: 10,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey,
        actions: const [MenuBarP()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comentario Original:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              widget.comentario.cuerpo,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Editar Comentario:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            TextFormField(
              controller: _comentarioController,
              maxLines: 5,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Escribe tu comentario...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _editarComentario(widget.comentario.external_id!);
              },
              child: Text('Editar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editarComentario(param) async {
    FacadeService servicio = FacadeService();
    Utiles util = Utiles();
    log('cuerpo: ${widget.comentario.cuerpo}');
    log('Noticia ID: ${widget.comentario.external_id}');

    if (widget.comentario.external_id != null ) {
      Map<String, String> mapa = {
        "cuerpo": _comentarioController.text,
        "external_id": widget.comentario.external_id,
      };

      log('Mapa: $mapa');

      servicio.editarComentario(mapa).then((value) async {
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
      log("Error: Alguno de los valores es nulo");
    }
  }
}
