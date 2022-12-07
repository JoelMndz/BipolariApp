import 'package:bipolari_app/models/User.dart';
import 'package:bipolari_app/providers/pacientProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:intl/intl.dart';

class RegisterPacientPage extends StatefulWidget {
  const RegisterPacientPage({Key? key}) : super(key: key);

  @override
  State<RegisterPacientPage> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterPacientPage> {
  bool familiarAutista = false;
  DateTime date = DateTime.now();
  //TextEditingController email;
  final List<Map<String, dynamic>> _maritalStatus = [
    {
      'value': 'soltero',
      'label': 'Soltero'
    },
    {
      'value': 'casado',
      'label': 'Casado'
    },
    {
      'value': 'divorciado',
      'label': 'Divorciado'
    },
  ];
  final nombreController = TextEditingController();
  final emailController = TextEditingController();
  final emailTutorController = TextEditingController();
  final fechaController = TextEditingController();
  DateTime? fecha;
  String? estadoCivil = "soltero";
  final ocupacionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isDisabled = false;

  @override
  void dispose() {
    nombreController.dispose();
    emailController.dispose();
    emailTutorController.dispose();
    fechaController.dispose();
    familiarAutista = false;
    print('Dispose used');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BipolariApp'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Card(
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(32.0),
              constraints: const BoxConstraints(maxWidth: 350),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Ingresar paciente",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Ingresar los datos del paciente.",
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      controller: nombreController,
                      validator:(value) {
                        if (value == null || value.trim().isEmpty ) {
                          return "Debe inresar el nombre";
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        hintText: 'Ingresa el nombre',
                        border: OutlineInputBorder(),   
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Ingresa tu email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Debes ingresar el email';
                        }

                        bool _emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);
                        if (!_emailValid) {
                          return 'El email es inválido';
                        }
                        var data = value.toLowerCase().split("@");
                        if(data[1] != "gmail.com"){
                          return "El email debe ser de google";
                        }
                      },
                    ),
                    _gap(),
                    TextFormField(
                      controller: emailTutorController,
                      decoration: const InputDecoration(
                        labelText: 'Email del tutor',
                        hintText: 'Ingrea el email del tutor',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Debes ingresar el email';
                        }
                        bool _emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);
                        if (!_emailValid) {
                          return 'El email es inválido';
                        }
                        var data = value.toLowerCase().split("@");
                        if(data[1] != "gmail.com"){
                          return "El email debe ser de google";
                        }
                      },
                    ),
                    _gap(),
                    TextFormField(
                      keyboardType: TextInputType.none,
                      controller: fechaController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de nacimiento',
                        hintText: 'Ingresa la fecha de nacimiento',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.date_range)
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Debe ingresar la fecha de nacimiento";
                        }
                        return null;
                      },
                      onTap: ()async{
                        var response = await showDatePicker(
                          context: context, 
                          initialDate: DateTime.now(),
                          firstDate:DateTime(1920),
                          lastDate: DateTime(2024),
                          helpText: "Fecha de nacimiento",
                          cancelText: "Cancelar",
                          confirmText: "Ok");
                        setState((){
                          fecha = response;
                        });
                        if(fecha != null){
                          fechaController.text = DateFormat.yMMMd().format(fecha!);
                        }
                        print(fecha);
                      },
                    ),
                    _gap(),
                    SelectFormField(
                      type: SelectFormFieldType.dropdown, // or can be dialog
                      initialValue: 'soltero',
                      labelText: 'Estado civil',
                      items: _maritalStatus,
                      onChanged: (val) => setState(() {
                        estadoCivil = val;
                      }),
                      onSaved: (val) => setState(() {
                        estadoCivil = val;
                      }),
                    ),
                    _gap(),
                    TextFormField(
                      controller: ocupacionController,
                      decoration: const InputDecoration(
                        labelText: 'Ocupación',
                        hintText: 'Ingrese la ocupación',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value){
                        if(value == null || value.trim().isEmpty){
                          return "Debes ingresar la ocupación";
                        }
                      },
                    ),
                    _gap(),
                    CheckboxListTile(
                      value: familiarAutista,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          familiarAutista = value;
                        });
                      },
                      title: const Text(
                        'Familiar con bipolaridad',
                        style: TextStyle(fontSize: 15),),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      contentPadding: const EdgeInsets.all(0),
                    ),
                    _gap(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Ingresar',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: _isDisabled ? null : ()async{
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() => _isDisabled=true);
                            var pacient = Usuario(
                              nombre: nombreController.text.trim(), 
                              email: emailController.text.trim().toLowerCase(), 
                              emailTutor: emailTutorController.text.trim().toLowerCase(),
                              rol: "paciente",
                              historiaClinica: {
                                "fechaNacimiento":fecha,
                                "estadoCivil": estadoCivil,
                                "ocupacion": ocupacionController.text.trim(),
                                "familiarBipolar": familiarAutista
                              }
                            );
                            var emailValido = await context.read<PacientProvider>().emailValido(pacient.email);
                            if(emailValido){
                              await context.read<PacientProvider>().addPacient(pacient);
                              setState(() => _isDisabled=false);
                              Navigator.pop(context);
                            }else{
                              setState(() => _isDisabled=false);
                              await EasyLoading.showError(
                                "El email ya está registrado!",
                                duration: Duration(seconds: 2)
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
    
  Widget _gap() => const SizedBox(height: 16);
}