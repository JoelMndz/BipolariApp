import 'package:bipolari_app/models/Registro.dart';
import 'package:bipolari_app/providers/auth.dart';
import 'package:bipolari_app/providers/register.dart';
import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';

class FormRegister extends StatefulWidget {
  const FormRegister({super.key});

  @override
  State<FormRegister> createState() => _formRegisterState();
}

class _formRegisterState extends State<FormRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var descripcionController = TextEditingController();
  String? sintoma = "😁 Muy buen ánimo";
  final List<Map<String, dynamic>> _symptom = [
    {"label":'😁 Muy buen ánimo', "value": "😁 Muy buen ánimo"},
    {"label":'😔 Depresión', "value":'😔 Depresión'},
    {"label":'😡 Irritabilidad', 'value': "😡 Irritabilidad"},
    {"label":'🥴 Verborrea',"value":'🥴 Verborrea'},
    {"label":'🥱 Sueño irregular',"value":'🥱 Sueño irregular'},
    {"label":'🥱 Ingesta de alcohol/drogas',"value":'🥱 Ingesta de alcohol/drogas'},
    {"label":'😑 Dificultad para hacer tareas', "value": '😑 Dificultad para completar tareas'},
  ];
  bool _isDisabled = false;

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
                    _gap(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Registrar síntoma",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Ingresa el síntoma y la descripción.",
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _gap(),
                    SelectFormField(
                      type: SelectFormFieldType.dropdown, // or can be dialog
                      initialValue: sintoma,
                      labelText: 'Síntoma',
                      items: _symptom,
                      onChanged: (val) => setState(() {
                        sintoma = val;
                      }),
                      onSaved: (val) => setState(() {
                        sintoma = val;
                      }),
                    ),
                    _gap(),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: descripcionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa la descripción';
                        }
                        return null;
                      },
                      minLines: 1,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        hintText: 'Ingresa la descripción',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    _gap(),
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
                            'Agregar',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: _isDisabled ? null : ()async{
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() => _isDisabled = true);
                            var registro = Registro(
                              paciente: context.read<AuthProvider>().user!.id!, 
                              sintoma: sintoma!, 
                              descripcion: descripcionController.text, 
                              fechaCreacion: DateTime.now()
                            );
                            await context.read<RegisterProvider>().addRegister(registro);
                            setState(() => _isDisabled = false);
                            Navigator.pushNamedAndRemoveUntil(context,'/pacient',((route) => false));
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