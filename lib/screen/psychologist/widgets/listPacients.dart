import 'package:bipolari_app/providers/pacientProvider.dart';
import 'package:bipolari_app/screen/ChartPaciente/chartPaciente.dart';
import 'package:bipolari_app/screen/widgets/listRegisters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListPacients extends StatefulWidget {

  const ListPacients({Key? key}) : super(key: key); 
  
  @override
  _ListPacientsState createState() => _ListPacientsState();
}

class _ListPacientsState extends State<ListPacients> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('usuarios')
    .where("rol",isEqualTo: "paciente")
    .snapshots();

  @override
  Widget build(BuildContext context) {
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
            "Aún no hay pacientes 😉",
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
          color: Colors.green.shade100,
          borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        child: GestureDetector(
          onDoubleTap: () => Navigator.pushNamed(context, "/psychologistic/pacient/chart",arguments: ChartPacientArg(paciente: document.id)),
          onHorizontalDragEnd: (details) => context.read<PacientProvider>().delete(document.id),
          child: ListTile(
            title: Text(data['nombre']),
            contentPadding: EdgeInsets.all(10),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(data['email']),
                SizedBox(height: 5),
                Text(data['historiaClinica']['familiarBipolar'] ? 'Familiar con bipolaridad': 'No tiene familiar con bipolaridad')
              ],
            ),
            trailing: const Icon(Icons.keyboard_arrow_right, color: Color.fromARGB(255, 28, 133, 35)),
            onTap: () => Navigator.pushNamed(context, "/psychologistic/pacient/registers",arguments: ListRegistersArgs(paciente: document.id)),
          ),
        ) 
      );
    })
    .toList();
  }

}