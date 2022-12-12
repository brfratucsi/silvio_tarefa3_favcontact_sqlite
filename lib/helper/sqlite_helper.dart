import 'package:silvio_tarefa3_favcontact_sqlite/model/contato.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class SQLiteOpenHelper {
  //Singleton para SQLiteOpenHelper
  static final SQLiteOpenHelper _instance = SQLiteOpenHelper._internal_();
  factory SQLiteOpenHelper() => _instance;

  SQLiteOpenHelper._internal_();

  Database? _dataBase;

  //Getter para instancia única de referencia para Banco de Dados sqlite
  Future<Database?> get dataBase async {
    if (_dataBase != null) {
      return _dataBase;
    } else {
      return _dataBase = await inicializarBanco();
    }
  }

  //Método responsavel por inicializar o banco de dados criar as tabelas necessárias
  Future<Database> inicializarBanco() async {
    // 1
    final databasePath = await getDatabasesPath();
    //2
    final path = join(databasePath, "contatos.db");

    //3
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) {
      db.execute('''
            CREATE TABLE IF NOT EXISTS $tabela(
              $colunaId INTEGER PRIMARY KEY,
              $colunaNome TEXT NOT NULL,
              $colunaEmail TEXT NOT NULL,
              $colunaTelefone TEXT,
              $colunaCaminhoImagem TEXT
            );
          ''');
    });
  }

  //Método de insercao de registro na tabela contato
  Future<Contato> insert(Contato contato) async {
    //1
    Database? db = await dataBase;
    //2
    contato.id = await db?.insert(tabela, contato.toMap());
    return contato;
  }

  //Método para recuperar um registro na tabela contato
  Future<Contato> findById(int id) async {
    Database? db = await dataBase;
    //1
    List<Map<String, dynamic>> map = await db!.query(tabela,
        distinct: true,
        //2
        columns: [
          colunaId,
          colunaNome,
          colunaEmail,
          colunaTelefone,
          colunaCaminhoImagem
        ],
        //3
        where: '$colunaId = ?',
        //4
        whereArgs: [id]);

    return Contato.fromMap(map.first);
  }

  //Método de atualizacao de registro
  Future<int> update(Contato contato) async {
    Database? db = await dataBase;
    return await db!.update(tabela, contato.toMap(),
        where: '$colunaId = ?', whereArgs: [contato.id]);
  }

  //Método de remocao de registro
  Future<void> delete(int id) async {
    final Database? db = await dataBase;
    await db!.delete(tabela, where: "id = ?", whereArgs: [id]);
  }

  //Método respnsável por buscar todos os contatos na tabela contato
  Future<List<Contato>> findAll() async {
    var db = await dataBase;

    List<Map<String, dynamic>> mapContatos =
        // Aqui adicionei um ORDER BY pra listar o contato em ordem alfabética
        await db!.rawQuery('SELECT * FROM ${Contato.tabela} ORDER BY nome ASC');

    var contatos = mapContatos.map((map) => Contato.fromMap(map)).toList();

    return contatos;
  }

  // Metodo para recuperar o total de registros
  Future<int?> getCount() async {
    Database db = dataBase as Database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tabela'));
  }

  Future close() {
    Database db = dataBase as Database;
    return db.close();
  }

  final String tabela = 'contatos';
  final String colunaId = 'id';
  final String colunaNome = 'nome';
  final String colunaEmail = 'email';
  final String colunaTelefone = 'telefone';
  final String colunaCaminhoImagem = 'caminhoImagem';
}
