import 'package:flutter/material.dart';
import 'screens/lista_receitas_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicativo de Receitas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListaReceitasScreen(),
    );
  }
}
