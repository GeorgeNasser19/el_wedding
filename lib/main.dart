import 'package:el_wedding/app.dart';
import 'package:el_wedding/core/helpers/sheard_pref.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPrefs().init();
  runApp(const ElWedding());
}
