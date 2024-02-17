import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unidad3/models/NoticiaModel.dart';
import 'package:unidad3/views/MapaPorNoticia.dart';
import '../controls/Conexion.dart';
import 'DetalleNoticiaScreen.dart';
import 'MenuBarP.dart';
import 'package:unidad3/controls/utiles/Utiles.dart';

class NoticiasScreen extends StatefulWidget {
  @override
  _NoticiasScreenState createState() => _NoticiasScreenState();
}

class _NoticiasScreenState extends State<NoticiasScreen> {
  Conexion c = Conexion();
  List<NoticiaModel> noticias = [];
  final Utiles util = Utiles();

  @override
  void initState() {
    super.initState();
    print('Llamando a initState');
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('${c.URL}noticias'));
      print('Respuesta del backend: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['datos'];
        setState(() {
          noticias = data.map((item) => NoticiaModel.fromJson(item)).toList();
        });
      } else {
        // Manejar error de solicitud
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en fetchData: $error');
    }
  }

  Future<String?> _obtenerRol() async {
    Utiles util = Utiles();
    var rol = await util.getValue("rol");
    return rol;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "NOTICIAS",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
        elevation: 10,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey,
        actions: [
          MenuBarP(),
        ],
      ),
      body: FutureBuilder<String?>(
        future: _obtenerRol(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se obtiene el rol
            return Center(child: CircularProgressIndicator());
          } else {
            var rol = snapshot.data;
            return ListView.builder(
              itemCount: noticias.length,
              itemBuilder: (BuildContext context, int index) {
                final noticia = noticias[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(noticia.titulo),
                        subtitle: Text(noticia.cuerpo),
                      ),
                      Image.network(
                        '${c.URL_MEDIA}${noticia.archivo}',
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetalleNoticiaScreen(noticia: noticia),
                                  ),
                                );
                              },
                              child: Text('Añadir Comentario'),
                            ),
                            if (rol == 'ADMINISTRADOR')
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapaPorNoticia(noticia: noticia),
                                    ),
                                  );
                                },
                                child: Text('Mapa'),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

}
