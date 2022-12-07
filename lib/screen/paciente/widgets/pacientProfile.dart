import 'package:bipolari_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PacientProfile extends StatefulWidget {
  const PacientProfile({super.key});

  @override
  State<PacientProfile> createState() => _PsycholgistProfileState();
}

class _PsycholgistProfileState extends State<PacientProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 10,
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 120,
                  backgroundColor: Colors.green,
                  child: CircleAvatar(
                    radius: 108,
                    backgroundImage: NetworkImage(context.read<AuthProvider>().user!.fotoUrl!),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    context.read<AuthProvider>().user!.nombre,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                      elevation: MaterialStateProperty.all<double>(5),
                    ),
                    child: Text("Cerrar sesión"),
                    onPressed: ()async{
                      await context.read<AuthProvider>().cerrarSesion();
                      Navigator.pushNamedAndRemoveUntil(context,'/',((route) => false));
                    }
                  ),
                ),
              ],
            ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
      ],
    );
  }
}