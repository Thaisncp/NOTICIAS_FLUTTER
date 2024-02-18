import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:unidad3/controls/Conexion.dart';
import '../models/NoticiaModel.dart';
import 'MenuBarP.dart';

class MapaPorNoticia extends StatefulWidget {
  final NoticiaModel noticia;

  const MapaPorNoticia({Key? key, required this.noticia}) : super(key: key);

  @override
  _MapaPorNoticiaState createState() => _MapaPorNoticiaState();
}

class _MapaPorNoticiaState extends State<MapaPorNoticia> {
  static const MAPBOX_ACCESS_TOKEN =
      'pk.eyJ1IjoibHVpczE2OSIsImEiOiJjbHMyOWl2dW0wOWcwMnFuejFxc29wMG5iIn0.cxAolwZYn7HqhWoPFZK2mw';

  MapOptions _createMapOptions() {
    return MapOptions(
      center: LatLng(-3.9834385, -79.2159910),
      minZoom: 2,
      maxZoom: 20,
      zoom: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mapa de comentarios",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 22),
        ),
        elevation: 10,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white54,
        actions: const [MenuBarP()],
      ),
      body: FlutterMap(
        options: _createMapOptions(),
        nonRotatedChildren: [
          TileLayer(
            urlTemplate:
            'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: const {
              'accessToken': MAPBOX_ACCESS_TOKEN,
              'id': 'mapbox/streets-v12',
            },
          ),
          FutureBuilder<List<dynamic>>(
            future: fetchComentarios(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return MarkerLayer(
                  markers: _crearMarcadores(snapshot.data),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error al cargar comentarios'));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  List<Color> colores = [
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.amber,
    Colors.deepPurple,
    Colors.indigo,
    Colors.lime,
    Colors.pink,
    Colors.red,
    Colors.blueGrey,
  ];
  List<Marker> _crearMarcadores(List<dynamic> comentarios) {
    print("Cantidad de comentarios: ${comentarios.length}");

    return comentarios.map((comentario) {
      int colorIndex = comentarios.indexOf(comentario) % colores.length;

      print("Creando marcador para comentario: ${comentario['cuerpo']}");

      return Marker(
        point: LatLng(
          double.parse(comentario['latitud'].toString()),
          double.parse(comentario['longitud'].toString()),
        ),
        builder: (context) {
          return Container(
            child: IconButton(
              icon: Icon(
                Icons.comment_outlined,
                color: colores[colorIndex],
                size: 40,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      icon: Icon(
                        Icons.comment_rounded,
                        color: colores[colorIndex],
                        size: 40,
                      ),
                      content: Text(comentario['cuerpo'].toString(), style: TextStyle(color: Colors.white)),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cerrar"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      );
    }).toList();
  }
  Future<List<dynamic>> fetchComentarios() async {
    final Conexion c = new Conexion();
    try {
      final response = await http.get(
        Uri.parse('${c.URL}/admin/listaPorNoticia/${widget.noticia.id}'),
      );

      print('Respuesta del backend: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['datos'];
        return data;
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        throw Exception('Error al cargar comentarios');
      }
    } catch (error) {
      print('Error en fetchComentarios: $error');
      throw Exception('Error al cargar comentarios');
    }
  }
}
