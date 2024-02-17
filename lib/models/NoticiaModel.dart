class NoticiaModel {
  final String titulo;
  final String cuerpo;
  final String id;
  final String tipoArchivo;
  final String tipoNoticia;
  final String fecha;
  final String archivo;
  final bool estado; // Cambiado a bool
  final String apellidos;
  final String nombres;
  final String external_id;

  NoticiaModel({
    required this.titulo,
    required this.cuerpo,
    required this.id,
    required this.tipoArchivo,
    required this.tipoNoticia,
    required this.fecha,
    required this.archivo,
    required this.estado,
    required this.apellidos,
    required this.nombres,
    required this.external_id,
  });

  factory NoticiaModel.fromJson(Map<String, dynamic> json) {
    return NoticiaModel(
      titulo: json['titulo'] ?? '',
      cuerpo: json['cuerpo'] ?? '',
      id: json['id'] ?? '',
      tipoArchivo: json['tipo_archivo'] ?? '',
      tipoNoticia: json['tipo_noticia'] ?? '',
      fecha: json['fecha'] ?? '',
      archivo: json['archivo'] ?? '',
      estado: json['estado'] ?? false, // Cambiado a bool
      apellidos: json['persona']?['apellidos'] ?? '',
      nombres: json['persona']?['nombres'] ?? '',
      external_id: json['persona']?['external_id'] ?? '',
    );
  }
}
