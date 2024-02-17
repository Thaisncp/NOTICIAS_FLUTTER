import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:unidad3/models/NoticiaModel.dart';
import '../controls/Conexion.dart';
import '../controls/servicio_back/FacadeService.dart';
import 'package:geolocator/geolocator.dart';
import '../controls/utiles/Utiles.dart';
import '../models/ComentarioModel.dart';
import 'package:http/http.dart' as http;

import 'MenuBarP.dart';
class DetalleNoticiaScreen extends StatefulWidget {
  final NoticiaModel noticia;

  const DetalleNoticiaScreen({Key? key, required this.noticia}) : super(key: key);
  //DetalleNoticiaScreen({required this.noticia});

  @override
  _DetalleNoticiaScreenState createState() => _DetalleNoticiaScreenState();
}

class _DetalleNoticiaScreenState extends State<DetalleNoticiaScreen> {
  List<ComentarioModel> comentarios = [];

  Conexion c = Conexion();
  final TextEditingController comentarioController = TextEditingController();
  double latitud = 0.0;
  double longitud = 0.0;
  int itemsPerPage = 5;
  int currentPage = 0;


  Future<Position> _Locacion() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        const SnackBar msg = SnackBar(
            content: Text('Se necesitan permisos de ubicacion para comentar'));
        ScaffoldMessenger.of(context).showSnackBar(msg);
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

  }

  void getCurrentLocation(param) async {
    Position posicion;

    try {
      posicion = await _Locacion();
      print(posicion);

      latitud = posicion.latitude;
      longitud = posicion.longitude;

      _registrar(param);
    } catch (e) {
      print('Error al obtener la posición: $e');
    }
  }

  Future<void> _registrar(param) async {
    FacadeService servicio = FacadeService();
    Utiles util = Utiles();
    var user = await util.getValue("external");

    if (user != null && widget.noticia.id != null ) {
      Map<String, String> mapa = {
        "cuerpo": comentarioController.text,
        "longitud": longitud.toString(),
        "latitud": latitud.toString(),
        "usuario": user.toString(),
        "id_noticia": widget.noticia.id!,
      };

      log('Mapa: $mapa');

      servicio.registrarComentario(mapa).then((value) async {
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



  @override
  void initState() {
    super.initState();
    fetchComentarios();
  }

  Future<void> fetchComentarios() async {
    try {
      final response = await http.get(Uri.parse('${c.URL}/admin/listaPorNoticia/${widget.noticia.id}'));
      print('Respuesta del backend: ${response.body}');
      print('Respuesta: ${widget.noticia.id}');
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
    }
  }



  @override
  Widget build(BuildContext context) {
    int startIndex = currentPage * itemsPerPage;
    int endIndex = (currentPage + 1) * itemsPerPage;

    List<ComentarioModel> comentariosToShow = comentarios.sublist(
      startIndex,
      endIndex < comentarios.length ? endIndex : comentarios.length,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detalles de la noticia",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 22),
        ),
        elevation: 10,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white54,
        actions: const [MenuBarP()],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.noticia.titulo,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              'Cuerpo: ${widget.noticia.cuerpo}',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              'Fecha: ${_formatFecha(widget.noticia.fecha)}', // Formatear la fecha
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              'Autor: ${widget.noticia.apellidos} ${widget.noticia.nombres}',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 16),
            Image.network(
              '${c.URL_MEDIA}${widget.noticia.archivo}',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                'Añadir un comentario',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
            TextField(
              controller: comentarioController,
              decoration: InputDecoration(
                hintText: 'Escribe tu comentario aquí',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Agregar lógica para agregar comentario
                getCurrentLocation(widget.noticia.external_id!);
              },
              child: Text('Agregar Comentario'),
            ),
            SizedBox(height: 20),
            Text(
              'Comentarios:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey
              ),
            ),
            Divider(),
            ListView.builder(
              shrinkWrap: true,
              itemCount: comentariosToShow.length,
              itemBuilder: (BuildContext context, int index) {
                final comentario = comentariosToShow[index];

                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(comentario.cuerpo),
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 0
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
                  onPressed: (currentPage + 1) * itemsPerPage < comentarios.length
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
      ),
    );
  }

  String _formatFecha(String fecha) {
    // Formatear la fecha de yyyy-MM-ddTHH:mm:ss.000Z a dd/MM/yyyy
    DateTime dateTime = DateTime.parse(fecha);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
