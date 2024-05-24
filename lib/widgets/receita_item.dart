import 'package:flutter/material.dart';
import '../models/receita.dart';

class ReceitaItem extends StatelessWidget {
  final Receita receita;

  ReceitaItem({required this.receita});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(receita.titulo),
      subtitle: Text(receita.categorias),
      onTap: () {
        // Navegar para a tela de detalhes da receita
      },
    );
  }
}
