import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class Charts extends StatefulWidget {
  const Charts({super.key});

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('registros')
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
        
        Map<String, double> dataMap = _getDataMap(snapshot);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PieChart(
              dataMap: dataMap,
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 1.2,
              centerText: "Síntomas",
              legendOptions: LegendOptions(
                legendPosition: LegendPosition.top,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: true,
                showChartValuesInPercentage: true,
              ),
            )
          ],
        );
      },
    );
  }
  
  Map<String, double> _getDataMap(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    Map<String, double> dataMap = {};
    if(snapshot.data!.docs.length == 0){
      dataMap['No hay datos'] = 100;
      return dataMap;
    }
    var labels = snapshot.data!.docs.map((x){
        var data = x.data()! as Map<String, dynamic>;
        return data['sintoma'].toString();
      })
      .toSet()
      .toList();
    for(var item in labels){
      double count = 0;
      snapshot.data!.docs.forEach((x) {
        var data = x.data()! as Map<String, dynamic>;
        if(data['sintoma'].toString() == item){
          count++;
        }
      });
      dataMap[item] = count;
    }
    return dataMap;
  }
}