import 'package:bipolari_app/screen/ChartPaciente/chartPaciente.dart';
import 'package:bipolari_app/screen/FormRegister/formRegister.dart';
import 'package:bipolari_app/screen/paciente/paciente.dart';
import 'package:bipolari_app/screen/widgets/listRegisters.dart';
import 'package:bipolari_app/screen/psychologist/psychologist.dart';
import 'package:bipolari_app/screen/registerPacient/registerPacient.dart';
import 'package:bipolari_app/screen/sigIn/sigIn.dart';

import 'package:flutter/material.dart';


Map <String, WidgetBuilder> getRoutes(BuildContext context){
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => const SignInPage(),
    '/pacient': (BuildContext context) => const PacientePage(),
    '/pacient/form-register': (BuildContext context) => const FormRegister(),
    '/psychologistic': (BuildContext context) => const PsychologistPage(),
    '/psychologistic/form-pacient': (BuildContext context) => const RegisterPacientPage(),
    '/psychologistic/pacient/registers': (BuildContext context) => const ListRegisters(),
    '/psychologistic/pacient/chart': (BuildContext context) => const ChartPacient()
  };
}