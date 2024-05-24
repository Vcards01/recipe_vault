class Receita {
  int? id;
  String titulo;
  String ingredientes;
  String modoPreparo;
  String categorias;
  int favorita;

  Receita({
    this.id,
    required this.titulo,
    required this.ingredientes,
    required this.modoPreparo,
    required this.categorias,
    required this.favorita,
  });

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'ingredientes': ingredientes,
      'modo_preparo': modoPreparo,
      'categorias': categorias,
      'favorita': favorita,
    };
  }
}
