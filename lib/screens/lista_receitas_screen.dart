import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/receita.dart';
import 'adicionar_editar_receita_screen.dart';
import 'detalhes_receita_screen.dart';

class ListaReceitasScreen extends StatefulWidget {
  @override
  _ListaReceitasScreenState createState() => _ListaReceitasScreenState();
}

class _ListaReceitasScreenState extends State<ListaReceitasScreen> {
  late Future<List<Receita>> _futureReceitas;
  late Future<List<Receita>> _futureReceitasFavoritas;

  @override
  void initState() {
    super.initState();
    _futureReceitas = DatabaseHelper.instance.getTodasReceitas();
    _futureReceitasFavoritas = DatabaseHelper.instance.getReceitasFavoritas();
  }

  void _atualizarLista() {
    setState(() {
      _futureReceitas = DatabaseHelper.instance.getTodasReceitas();
      _futureReceitasFavoritas = DatabaseHelper.instance.getReceitasFavoritas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Lista de Receitas',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey[900],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Todas'),
              Tab(text: 'Favoritas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildReceitasList(_futureReceitas, isFavoriteTab: false),
            _buildReceitasList(_futureReceitasFavoritas, isFavoriteTab: true),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdicionarEditarReceitaScreen()),
            );

            if (result == true) {
              _atualizarLista();
            }
          },
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
        ),
        backgroundColor: Colors.grey[850],
      ),
    );
  }

  Widget _buildReceitasList(Future<List<Receita>> futureReceitas,
      {required bool isFavoriteTab}) {
    return FutureBuilder<List<Receita>>(
      future: futureReceitas,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Erro ao carregar as receitas',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final receita = snapshot.data![index];
              return Dismissible(
                key: Key(receita.id.toString()),
                background: isFavoriteTab
                    ? Container(
                  color: Colors.yellow,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Icon(
                        Icons.thumb_down,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
                    : Container(
                  color: Colors.green,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Icon(
                        Icons.thumb_up,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                direction: DismissDirection.horizontal,
                confirmDismiss: (direction) async {
                  if (isFavoriteTab && direction == DismissDirection.startToEnd) {
                    return await _confirmarDesfavoritar(receita);
                  }else if (isFavoriteTab && direction == DismissDirection.endToStart) {
                    return await _confirmarExclusao(receita);
                  }
                  else if (!isFavoriteTab && direction == DismissDirection.endToStart) {
                    return await _confirmarExclusao(receita);
                  } else if (!isFavoriteTab && direction == DismissDirection.startToEnd) {
                    return await _confirmarFavoritar(receita);
                  }
                },
                onDismissed: (direction) async {
                  if (isFavoriteTab && direction == DismissDirection.startToEnd) {
                    await _desfavoritarReceita(receita);
                  } else if (isFavoriteTab && direction == DismissDirection.endToStart) {
                    await _excluirReceita(receita);
                  }
                  else if (!isFavoriteTab && direction == DismissDirection.endToStart) {
                    await _excluirReceita(receita);
                  } else if (!isFavoriteTab && direction == DismissDirection.startToEnd) {
                    await _favoritarReceita(receita);
                  }
                },
                child: ListTile(
                  title: Text(
                    receita.titulo,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    receita.categorias,
                    style: TextStyle(color: Colors.white70),
                  ),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesReceitaScreen(
                          receita: receita,
                          atualizarLista: _atualizarLista,
                        ),
                      ),
                    );

                    if (result == true) {
                      _atualizarLista();
                    }
                  },
                ),
              );
            },
          );
        } else {
          return Center(
            child: Text(
              'Nenhuma receita encontrada',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
      },
    );
  }

  Future<bool?> _confirmarExclusao(Receita receita) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirmar Exclusão',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Tem certeza que deseja excluir a receita "${receita.titulo}"?',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.grey[850],
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'Excluir',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _confirmarFavoritar(Receita receita) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirmar Favoritar',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Tem certeza que deseja favoritar a receita "${receita.titulo}"?',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.grey[850],
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'Favoritar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _confirmarDesfavoritar(Receita receita) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirmar Desfavoritar',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Tem certeza que deseja desfavoritar a receita "${receita.titulo}"?',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.grey[850],
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'Desfavoritar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _excluirReceita(Receita receita) async {
    await DatabaseHelper.instance.deleteReceita(receita.id!);
    _atualizarLista();
  }

  Future<void> _favoritarReceita(Receita receita) async {
    receita.favorita = 1;
    await DatabaseHelper.instance.updateReceita(receita);
    _atualizarLista();
  }

  Future<void> _desfavoritarReceita(Receita receita) async {
    receita.favorita = 0;
    await DatabaseHelper.instance.updateReceita(receita);
    _atualizarLista();
  }
}
