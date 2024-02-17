import 'package:unidad3/controls/servicio_back/RespuestaGenerica.dart';

class InicioSesionSW extends RespuestaGenerica{
  String tag = '';
  InicioSesionSW({msg='', code=0, datos, this.tag= ''});
}