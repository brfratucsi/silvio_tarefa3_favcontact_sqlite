class Contato {
  int? id;
  String? nome;
  String? email;
  String? telefone;
  String? caminhoImagem;

  static String tabela = 'contatos';
  static String colunaId = 'id';
  static String colunaNome = 'nome';
  static String colunaEmail = 'email';
  static String colunaTelefone = 'telefone';
  static String colunaCaminhoImagem = 'caminhoImagem';

  // Construtor com parametros nomeados
  Contato({this.nome, this.email, this.telefone, this.caminhoImagem});

  //Metodo converte objeto Contao em Mapa
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      colunaNome: nome,
      colunaEmail: email,
      colunaTelefone: telefone,
      colunaCaminhoImagem: caminhoImagem
    };

    if (id != null) {
      map[colunaId] = id;
    }
    return map;
  }

  //Metodo que converte Mapa em objeto Contato
  Contato.fromMap(Map<String, dynamic> map) {
    id = map[colunaId];
    nome = map[colunaNome];
    email = map[colunaEmail];
    telefone = map[colunaTelefone];
    caminhoImagem = map[colunaCaminhoImagem];
  }
}
