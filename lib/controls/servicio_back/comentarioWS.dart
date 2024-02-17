import 'dart:developer';
import 'package:unidad3/controls/servicio_back/RespuestaGenerica.dart';
import 'package:unidad3/models/ComentarioModel.dart';

class comentarioWS extends RespuestaGenerica {
  late List<ComentarioModel> data = [];

  comentarioWS();

  comentarioWS.fromMap(List datos, String msg, int code) {
    datos.forEach((item) {
      Map<String, dynamic> mapa = item;
      ComentarioModel aux = ComentarioModel.fromMap(mapa);
      data.add(aux);
    });

    this.msg = msg;
    this.code = code;
  }
}