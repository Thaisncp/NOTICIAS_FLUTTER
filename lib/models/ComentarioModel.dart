class ComentarioModel {
  String cuerpo = '';
  String longitud = '';
  String latitud = '';
  String usuario = '';
  String external_id = '';

  ComentarioModel();

  ComentarioModel.fromMap(Map<dynamic, dynamic> mapa) {
    cuerpo = mapa['cuerpo'] ?? '';  // Add null check for cuerpo
    longitud = mapa['longitud'] ?? '';  // Add null check for longitud
    latitud = mapa['latitud'] ?? '';  // Add null check for latitud
    usuario = mapa['usuario'] ?? '';  // Add null check for usuario
    external_id = mapa['external_id'] ?? '';  // Add null check for external_id
  }
}
