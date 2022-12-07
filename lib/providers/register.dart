
import 'package:bipolari_app/models/Registro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class RegisterProvider with ChangeNotifier{
  bool loading = false;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> addRegister(Registro registro) async{
    try {
      await _db.collection("registros").add(registro.toMap());
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> deleteRegister(String id) async{
    try {
      await _db.collection("registros").doc(id).delete();
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }
}