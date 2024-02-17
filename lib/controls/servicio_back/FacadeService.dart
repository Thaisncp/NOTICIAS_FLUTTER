import 'dart:convert';

import 'package:unidad3/controls/Conexion.dart';
import 'package:unidad3/controls/servicio_back/InicioSesionSW.dart';
import 'package:unidad3/controls/servicio_back/RespuestaGenerica.dart';
import 'package:http/http.dart' as http;

import '../utiles/Utiles.dart';
import 'comentarioWS.dart';

class FacadeService {
  Conexion c = Conexion();
  Future<InicioSesionSW> inicioSesion (Map<String, String> mapa) async{
    Map<String, String> header = {'Content-Type':'application/json'};
    final String _url = '${c.URL}login';
    final uri = Uri.parse(_url);
    InicioSesionSW isw = InicioSesionSW();
    try{
      final response = await http.post(uri, headers: header, body: jsonEncode(mapa));
      if(response.statusCode != 200){
        if(response.statusCode == 404){
          isw.code = 404;
          isw.msg = 'ERROR';
          isw.tag  = 'Recurso no encontrado';
          isw.datos = {};
        }else{
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          isw.code = mapa['code'];
          isw.msg = mapa['msg'];
          isw.tag  = mapa['tag'];
          isw.datos = mapa['datos'];
          //return _response(mapa['code'], mapa['msg'], mapa['datos']);
        }
        //log("Page no found");
      }else{
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        isw.code = mapa['code'];
        isw.msg = mapa['msg'];
        isw.tag  = mapa['tag'];
        isw.datos = mapa['datos'];
        //return _response(mapa['code'], mapa['msg'], mapa['datos']);
        //log(response.body);
      }
      //return RespuestaGenerica();
    }catch(e){
      isw.code = 500;
      isw.msg = 'Error';
      isw.tag  = 'Error inesperado';
      isw.datos = {};
      //return _response(500, "Error inesperado", []);
    }
    return isw;
  }
  Future<RespuestaGenerica> listarNoticiasTodo () async{
    return await c.solicitudGet('noticias', false);
  }

  Future<InicioSesionSW> registrarUsuario(Map<String, String> mapa) async {
    print('Mapa antes de la codificación JSON: $mapa');
    Map<String, String> header = {'Content-Type': 'application/json'};

    final String url = '${c.URL}admin/persona/save/usuario';
    final uri = Uri.parse(url);

    InicioSesionSW isw = InicioSesionSW();

    try {
      final response =
      await http.post(uri, headers: header, body: jsonEncode(mapa));
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          isw.code = 404;
          isw.msg = 'Error';
          isw.tag = 'Recurso no encontrado';
          isw.datos = {};
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          isw.code = mapa['code'];
          isw.msg = mapa['msg'];
          //isw.tag = mapa['tag'];
          //isw.datos = {};
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        isw.code = mapa['code'];
        isw.msg = mapa['msg'];
        //isw.tag = mapa['tag'];
        //isw.datos = {};
      }
    } catch (e) {
      isw.code = 500;
      isw.msg = 'Error';
      isw.tag = 'Error inesperado';
      isw.datos = {};
    }
    return isw;
  }

  Future<InicioSesionSW> registrarComentario(Map<String, String> mapa) async {
    Utiles util = Utiles();
    var token = await util.getValue("token");

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'news-token': token ?? '',
    };

    final String url = '${c.URL}admin/comentario/save';
    final uri = Uri.parse(url);

    InicioSesionSW isw = InicioSesionSW();

    try {
      final response =
      await http.post(uri, headers: header, body: jsonEncode(mapa));
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          isw.code = 404;
          isw.msg = 'Error';
          isw.tag = 'Recurso no encontrado';
          isw.datos = {};
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          isw.code = mapa['code'];
          isw.msg = mapa['msg'];
          isw.tag = mapa['tag'];
          isw.datos = {};
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        isw.code = mapa['code'];
        isw.msg = mapa['msg'];
        isw.tag = mapa['tag'];
        isw.datos = {};
      }
    } catch (e) {
      isw.code = 500;
      isw.msg = 'Error';
      isw.tag = 'Error inesperado';
      isw.datos = {};
    }
    return isw;
  }

  Future<InicioSesionSW> editarComentario(Map<String, String> mapa) async {
    Utiles util = Utiles();
    var token = await util.getValue("token");

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'news-token': token ?? '',
    };

    final String url = '${c.URL}admin/comentario/mod';
    final uri = Uri.parse(url);

    InicioSesionSW isw = InicioSesionSW();

    try {
      final response =
      await http.post(uri, headers: header, body: jsonEncode(mapa));
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          isw.code = 404;
          isw.msg = 'Error';
          isw.tag = 'Recurso no encontrado';
          isw.datos = {};
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          isw.code = mapa['code'];
          isw.msg = mapa['msg'];
          isw.tag = mapa['tag'];
          isw.datos = {};
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        isw.code = mapa['code'];
        isw.msg = mapa['msg'];
        isw.tag = mapa['tag'];
        isw.datos = {};
      }
    } catch (e) {
      isw.code = 500;
      isw.msg = 'Error';
      isw.tag = 'Error inesperado';
      isw.datos = {};
    }
    return isw;
  }

  Future<InicioSesionSW> editarDatosPersona(Map<String, String> mapa) async {
    Utiles util = Utiles();
    var token = await util.getValue("token");

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'news-token': token ?? '',
    };

    final String url = '${c.URL}admin/persona/modificar';
    final uri = Uri.parse(url);

    InicioSesionSW isw = InicioSesionSW();

    try {
      final response =
      await http.post(uri, headers: header, body: jsonEncode(mapa));
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          isw.code = 404;
          isw.msg = 'Error';
          isw.tag = 'Recurso no encontrado';
          isw.datos = {};
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          isw.code = mapa['code'];
          isw.msg = mapa['msg'];
          isw.tag = mapa['tag'];
          isw.datos = {};
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        isw.code = mapa['code'];
        isw.msg = mapa['msg'];
        isw.tag = mapa['tag'];
        isw.datos = {};
      }
    } catch (e) {
      isw.code = 500;
      isw.msg = 'Error';
      isw.tag = 'Error inesperado';
      isw.datos = {};
    }
    return isw;
  }

  Future<comentarioWS> listarComentarios() async {
    Utiles util = Utiles();
    var token = await util.getValue("token");

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'news-token': token ?? '',
    };

    final String url = '${c.URL}/admin/comentarios}';
    final uri = Uri.parse(url);

    comentarioWS isw = comentarioWS();

    try {
      final response = await (await (http.get(uri, headers: header)));

      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          isw = comentarioWS.fromMap(
              [], 'Error recurso no encontrado ', 404);
        } else {
          Map<String, dynamic> mapa = jsonDecode(response.body);
          isw = comentarioWS.fromMap(
              [], mapa["msg"], int.parse(mapa["code"].toString()));
        }
      } else {
        Map<String, dynamic> mapa = jsonDecode(response.body);
        List datos = jsonDecode(jsonEncode(mapa["datos"]));
        isw = comentarioWS.fromMap(
            datos, mapa["msg"], int.parse(mapa["code"].toString()));
      }
    } catch (e) {
      isw = comentarioWS.fromMap([], 'Error $e', 500);
    }
    return isw;
  }
}