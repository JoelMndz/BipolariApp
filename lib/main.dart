import 'package:bipolari_app/providers/auth.dart';
import 'package:bipolari_app/providers/pacientProvider.dart';
import 'package:bipolari_app/providers/register.dart';
import 'package:bipolari_app/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_)=> PacientProvider()),
        ChangeNotifierProvider(create: (_)=> RegisterProvider()),
      ],
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Login',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          initialRoute: '/',
          routes: getRoutes(context),
          builder: EasyLoading.init(),
        );
      }
    );
  }
}