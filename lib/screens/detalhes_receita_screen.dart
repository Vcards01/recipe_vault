import 'package:flutter/material.dart';
import '../models/receita.dart';
import 'adicionar_editar_receita_screen.dart';
import 'lista_receitas_screen.dart';

class DetalhesReceitaScreen extends StatelessWidget {
  final Receita receita;
  final VoidCallback atualizarLista;

  DetalhesReceitaScreen({required this.receita, required this.atualizarLista});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          receita.titulo,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdicionarEditarReceitaScreen(
                    receita: receita,
                  ),
                ),
              );

              if (result == true) {
                atualizarLista();
                Navigator.pop(context); // Fechar a tela de detalhes
              }
            },
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ingredientes:',
                style: TextStyle(fontSize: 25, color: Colors.white)),
            Text(receita.ingredientes,
                style: TextStyle(fontSize: 18, color: Colors.white)),
            SizedBox(height: 16),
            Text('Modo de Preparo:',
                style: TextStyle(fontSize: 25, color: Colors.white)),
            Text(receita.modoPreparo,
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ],
        ),
      )),
      backgroundColor: Colors.grey[850],
    );
  }
}
