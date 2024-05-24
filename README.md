# Recipe App

Este é um aplicativo de receitas desenvolvido com Flutter. Ele permite que os usuários adicionem, editem, excluam e favoritem receitas. O aplicativo utiliza um banco de dados SQLite para armazenar os dados das receitas localmente.

## Funcionalidades

- Listar todas as receitas.
- Listar receitas favoritas.
- Adicionar uma nova receita.
- Editar uma receita existente.
- Excluir uma receita.
- Favoritar/Desfavoritar receitas.

## Estrutura do Projeto

O projeto está organizado da seguinte maneira:

- **data/**: Contém a classe `DatabaseHelper` responsável por gerenciar as operações no banco de dados SQLite.
- **models/**: Contém a classe `Receita` que define o modelo de dados de uma receita.
- **screens/**: Contém as telas do aplicativo, como a lista de receitas, detalhes da receita e a tela de adicionar/editar receita.
- **main.dart**: O ponto de entrada do aplicativo.

## Estrutura do Banco de Dados
O banco de dados contém uma tabela receitas com os seguintes campos:

- **id**: Identificador único da receita (INTEGER PRIMARY KEY).
- **titulo**: Título da receita (TEXT).
- **ingredientes**: Lista de ingredientes da receita (TEXT).
- **modoPreparo**: Modo de preparo da receita (TEXT).
- **favorita**: Indicador se a receita é favorita (INTEGER, 0 ou 1).

## Demonstração Simples

