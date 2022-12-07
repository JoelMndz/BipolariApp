import 'package:bipolari_app/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class PacientProvider with ChangeNotifier{
  bool loading = false;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> emailValido(String email)async{
    try {
      var data = await _db.collection("usuarios")
        .where("email",isEqualTo: email.toLowerCase())
        .get();
      if(data.docs.isEmpty){
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  } 

  Future<bool> addPacient(Usuario user) async{
    try {
      await _db.collection("usuarios").add(user.toMap());
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<void> delete(String id)async{
    try {
      var data = await _db.collection("registros").where("_paciente", isEqualTo: id).get();
      for (var element in data.docs) {
        await _db.collection("registros").doc(element.id).delete();
      }
      await _db.collection("usuarios").doc(id).delete();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
  
}