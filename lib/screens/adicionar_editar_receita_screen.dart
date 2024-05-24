import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/receita.dart';

class AdicionarEditarReceitaScreen extends StatefulWidget {
  final Receita? receita;

  AdicionarEditarReceitaScreen({this.receita});

  @override
  _AdicionarEditarReceitaScreenState createState() =>
      _AdicionarEditarReceitaScreenState();
}

class _AdicionarEditarReceitaScreenState
    extends State<AdicionarEditarReceitaScreen> {
  late TextEditingController _tituloController;
  late TextEditingController _ingredientesController;
  late TextEditingController _modoPreparoController;
  String _categoriaSelecionada = 'Entrada';
  List<String> _categorias = ['Entrada', 'Prato Principal', 'Sobremesa'];

  @override
  void initState() {
    super.initState();
    _tituloController =
        TextEditingController(text: widget.receita?.titulo ?? '');
    _ingredientesController =
        TextEditingController(text: widget.receita?.ingredientes ?? '');
    _modoPreparoController =
        TextEditingController(text: widget.receita?.modoPreparo ?? '');
    _categoriaSelecionada =
        widget.receita?.categorias ?? _categorias.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.receita == null ? 'Adicionar Receita' : 'Editar Receita',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _tituloController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Título',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _ingredientesController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Ingredientes',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _modoPreparoController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Modo de Preparo',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              maxLines: 8,
            ),
            SizedBox(height: 12.0),
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Categoria',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              value: _categoriaSelecionada,
              items: _categorias.map((categoria) {
                return DropdownMenuItem(
                  value: categoria,
                  child: Text(categoria),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _categoriaSelecionada = value.toString();
                });
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _salvarReceita,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.grey[800],
              ),
              child: Text(
                widget.receita == null ? 'Salvar' : 'Atualizar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[850],
    );
  }

  Future<void> _salvarReceita() async {
    final novaReceita = Receita(
      id: widget.receita?.id,
      titulo: _tituloController.text,
      ingredientes: _ingredientesController.text,
      modoPreparo: _modoPreparoController.text,
      categorias: _categoriaSelecionada,
      favorita: widget.receita?.favorita ?? 0,
    );

    if (widget.receita == null) {
      await DatabaseHelper.instance.insertReceita(novaReceita);
    } else {
      if (widget.receita!.id != null) {
        await DatabaseHelper.instance.updateReceita(novaReceita);
      }
    }

    Navigator.pop(context, true);
  }
}
