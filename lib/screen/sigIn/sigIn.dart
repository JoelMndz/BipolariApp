import 'package:bipolari_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlutterLogo(
                  size: 150,
                ),
              SizedBox(height: 20,),
              Text(
                "BiporaliApp",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(
                height: 40.0,
                width: 150.0,
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              _cardInfo(text: '"El trastorno bipolar es una explicación, no una excusa"') ,
              SizedBox(height: 50,),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  elevation: MaterialStateProperty.all<double>(5),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                ),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      child: Image.asset("images/google.png"),
                    ),
                    SizedBox(width: 10,),
                    Text("Iniciar Sesión con Google")
                  ],
                ),
                onPressed: _isDisabled ? null: ()async{
                  setState(()=> _isDisabled = true);
                  EasyLoading.show(status: 'Cargando...');
                  await context.read<AuthProvider>().signInGoogle();
                  EasyLoading.dismiss();
                  if (context.read<AuthProvider>().status == AuthStates.authenticated) {
                    if (context.read<AuthProvider>().user?.rol == "paciente") {
                      Navigator.pushNamedAndRemoveUntil(context,'/pacient',((route) => false));
                    }else{
                      Navigator.pushNamedAndRemoveUntil(context,'/psychologistic',((route) => false));
                    }
                  }
                  else if(context.read<AuthProvider>().status == AuthStates.noauthorized){
                    await EasyLoading.showError(
                      "No autorizado!",
                      duration: Duration(seconds: 2)
                    );
                  }
                  setState(()=> _isDisabled = false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardInfo({required String text}){
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            text,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );

  }
}