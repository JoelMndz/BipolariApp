import 'package:bipolari_app/providers/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/auth.dart';

class ListRegisters extends StatefulWidget {
  const ListRegisters({super.key});

  @override
  State<ListRegisters> createState() => _ListRegistersState();
}

class _ListRegistersState extends State<ListRegisters> {

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('registros')
        .where("_paciente",isEqualTo: context.read<AuthProvider>().user?.id)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Upps, ocurrio un error!');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Cargando...");
        }
        
        if(snapshot.data?.docs.length == 0){
          return Text(
            "Aún no hay registros 😉",
            style: TextStyle(
              fontSize: 20 
            ),);
        }

        return ListView(
          children: _setItems(snapshot)
        );
      },
    );
  }

  List<Widget> _setItems(AsyncSnapshot<QuerySnapshot> snapshot){
    return snapshot.data!.docs.map((DocumentSnapshot document){
      var data = document.data()! as Map<String, dynamic>;
      return Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.green.shade300,
          borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        child: GestureDetector(
          onHorizontalDragEnd: (_) => context.read<RegisterProvider>().deleteRegister(document.id),
          child: ListTile(
            title: Text(
              data['sintoma'],
              style: TextStyle(
                fontSize: 20
              ),
            ),
            subtitle: Container(
              margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5,),
                  Text(_dateFormat(data['fechaCreacion'].toDate())),
                  SizedBox(height: 5,),
                  Text(data['descripcion'])
                ],
              ),
            ),
            //trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.green),
            onTap: () => print(data["sintoma"]),

          ),
        ),
      );
    }).toList();
  }

  String _dateFormat(DateTime date){
    return DateFormat("dd-MM-yyyy HH:mm").format(date);
  }
}
