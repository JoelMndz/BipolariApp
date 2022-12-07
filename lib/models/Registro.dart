
class Registro{
  String? id;
  String paciente;
  String sintoma;
  String descripcion;
  DateTime fechaCreacion;

  Registro({
    this.id,
    required this.paciente, 
    required this.sintoma, 
    required this.descripcion, 
    required this.fechaCreacion
  });

  Map<String, dynamic> toMap(){
    return {
      "_paciente": paciente,
      "sintoma": sintoma,
      "descripcion": descripcion,
      "fechaCreacion": fechaCreacion
    };
  }
}