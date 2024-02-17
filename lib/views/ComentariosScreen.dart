import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unidad3/models/ComentarioModel.dart';
import '../controls/Conexion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'MenuBarP.dart';

class ComentariosScreen extends StatefulWidget {
  @override
  _ComentariosScreenState createState() => _ComentariosScreenState();
}

class _ComentariosScreenState extends State<ComentariosScreen> {
  final _banearProvider = Provider<void Function(ComentarioModel)>((ref) {
    return (ComentarioModel comentario) {
      // Dejar el método vacío ya que la lógica se mueve al botón "Banear"
    };
  });
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
    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse('${c.URL}/admin/comentarios'),
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
          "NOTICIAS",
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
                              _banearComentario(comentario);
                            },
                            child: Text('Banear'),
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

  Future<void> _banearComentario(ComentarioModel comentario) async {
    try {
      final response = await http.post(
        Uri.parse('${c.URL}/admin/banear'),

        body: {
          'usuario': comentario.usuario.toString(),
          'external_id': comentario.external_id.toString()
        },
      );

      if (response.statusCode == 200) {
        print('Usuario Baneado con éxito');
        Navigator.pushNamed(context, "/principal");
      } else {
        print('Error al banear el usuario: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al enviar solicitud HTTP: $error');
    }
  }
}
