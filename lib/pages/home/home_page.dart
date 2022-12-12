import 'dart:io';

import 'package:silvio_tarefa3_favcontact_sqlite/helper/sqlite_helper.dart';
import 'package:silvio_tarefa3_favcontact_sqlite/model/contato.dart';
import 'package:silvio_tarefa3_favcontact_sqlite/screens/adicionar_contato.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SQLiteOpenHelper helper = SQLiteOpenHelper();
  //Crie uma lista para armazenar os dados vindos do banco de dados.
  // ignore: deprecated_member_use
  List<Contato> listContatos = [];

  @override
  void initState() {
    super.initState();
    obterTodosContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQLite Contacts'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey<int>(listContatos[index].id!),
            direction: DismissDirection.startToEnd,
            background: Container(
              color: Colors.red,
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            onDismissed: (direction) {
              // O metodo delete vindo da classe SQLiteOpenHelper fará a exclusão
              helper.delete(listContatos[index].id!);
              setState(() {
                // Em seguida o setState fará a mudança na view da aplicação.
                listContatos.remove(listContatos[index]);
              });
            },
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: listContatos[index].caminhoImagem != null
                              ? FileImage(
                                  File(listContatos[index].caminhoImagem!))
                              : AssetImage('assets/images/social.png')
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.text_fields,
                                color: Colors.black26,
                                size: 24.0,
                              ),
                              SizedBox(width: 5),
                              Text(
                                listContatos[index].nome!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: Colors.black26,
                                size: 24.0,
                              ),
                              SizedBox(width: 5),
                              Text(
                                listContatos[index].email!,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Colors.black26,
                                size: 24.0,
                              ),
                              SizedBox(width: 5),
                              Text(
                                listContatos[index].telefone!,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 15),
                          backgroundColor: Colors.white,
                          elevation: 0.0,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () =>
                            _exibirPaginaContato(contato: listContatos[index]),
                        child: Icon(
                          Icons.edit,
                          color: Colors.blue.shade400,
                          size: 30,
                        ))
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: listContatos.length,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _exibirPaginaContato(contato: Contato());
        },
      ),
    );
  }

  obterTodosContatos() {
    helper
        .findAll()
        .then((list) => setState(() {
              listContatos = list;
            }))
        .catchError((error) {
      print('Erroa ao recuperar contatos: ${error.toString()}');
    });
  }

  _exibirPaginaContato({required Contato contato}) async {
    final retornoContato = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AdicionarContatoScreen(contato: contato)));

    if (retornoContato != null) {
      if (contato.id != null) {
        await helper.update(retornoContato);
      } else {
        await helper.insert(retornoContato);
      }
      obterTodosContatos();
    }
  }
}
