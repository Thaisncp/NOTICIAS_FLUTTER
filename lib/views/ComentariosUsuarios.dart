import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unidad3/controls/utiles/Utiles.dart';
import 'package:unidad3/models/ComentarioModel.dart';
import 'package:unidad3/views/DetalleNoticiaScreen.dart';
import 'package:unidad3/views/EditarComentario.dart';
import '../controls/Conexion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'MenuBarP.dart';

class ComentariosUsuarios extends StatefulWidget {
  @override
  _ComentariosUsuariosState createState() => _ComentariosUsuariosState();
}

class _ComentariosUsuariosState extends State<ComentariosUsuarios> {
  Utiles util = Utiles();
  Conexion c = Conexion();
  List<ComentarioModel> comentarios = [];
  int currentPage = 0;
  int itemsPerPage = 10;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print('Llamando a initState');
    fetchComentarios();
  }

  Future<void> fetchComentarios() async {
    var user = await util.getValue("external");
    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse('${c.URL}/admin/listaPorUsuario/${user}'),
      );

      print('Respuesta del backend: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['datos'];
        setState(() {
          comentarios = data.map((item) => ComentarioModel.fromMap(item)).toList();
        });
      } else {
        // Manejar error de solicitud
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en fetchComentarios: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<ComentarioModel> getComentariosToShow() {
    int startIndex = currentPage * itemsPerPage;
    int endIndex = (currentPage + 1) * itemsPerPage;
    return comentarios.sublist(
      startIndex,
      endIndex < comentarios.length ? endIndex : comentarios.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Construyendo el widget ComentariosScreen');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "COMENTARIOS",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 22),
        ),
        elevation: 10,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey,
        actions: const [MenuBarP()],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: getComentariosToShow().length,
              itemBuilder: (BuildContext context, int index) {
                final comentario = getComentariosToShow()[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(comentario.cuerpo),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditarComentario(comentario: comentario),
                                ),
                              );
                            },
                            child: Text('EDITAR COMENTARIO'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: currentPage > 0 && !isLoading
                    ? () {
                  setState(() {
                    currentPage--;
                  });
                }
                    : null,
                child: Text('Atrás'),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: !isLoading && (currentPage + 1) * itemsPerPage < comentarios.length
                    ? () {
                  setState(() {
                    currentPage++;
                  });
                }
                    : null,
                child: Text('Siguiente'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
