
class Usuario{
  String? id;
  String nombre;
  String email;
  String? emailTutor;
  String rol;
  Map<String, dynamic>? historiaClinica;
  String? fotoUrl;

  Usuario({this.id,required this.nombre, this.emailTutor, required this.email, required this.rol,this.historiaClinica, this.fotoUrl});

  Map<String, dynamic> toMap(){
    return {
      "nombre":nombre,
      "email":email,
      "emailTutor": emailTutor,
      "rol":rol,
      "historiaClinica": historiaClinica
    };
  }
}