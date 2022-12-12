import 'dart:io';

import 'package:silvio_tarefa3_favcontact_sqlite/model/contato.dart';
import 'package:silvio_tarefa3_favcontact_sqlite/widgests/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdicionarContatoScreen extends StatefulWidget {
  final Contato? contato;
  AdicionarContatoScreen({required this.contato});

  @override
  _AdicionarContatoScreenState createState() => _AdicionarContatoScreenState();
}

class _AdicionarContatoScreenState extends State<AdicionarContatoScreen> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();

  // TODO: Mover cmodel
  late Contato? contatoEdicao;
  final ImagePicker imagePicker = ImagePicker();
  PickedFile? _caminhoImagem;

  @override
  void initState() {
    super.initState();
    if (widget.contato!.id == null) {
      contatoEdicao = Contato();
    } else {
      contatoEdicao = Contato.fromMap(widget.contato!.toMap());
      nomeController.text = contatoEdicao!.nome!;
      emailController.text = contatoEdicao!.email!;
      telefoneController.text = contatoEdicao!.telefone!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Contato'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            GestureDetector(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contatoEdicao?.caminhoImagem != null
                        ? FileImage(File(contatoEdicao!.caminhoImagem!))
                        : AssetImage('assets/images/social.png')
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: () {
                imagePicker.getImage(source: ImageSource.camera).then((value) {
                  // Atualizamos os dados da tela.
                  setState(() {
                    _caminhoImagem = value!;
                    //Depois de armazenae globalmente a referencia do arquivo, atualizamos o atributo caminhoImagem do contato, para recupera o arquivo para exibiçao.
                    contatoEdicao?.caminhoImagem = _caminhoImagem?.path;
                  });
                });
              },
            ),
            CustomTextField(
              hint: "Nome",
              icon: Icons.text_fields,
              controller: nomeController,
            ),
            CustomTextField(
              hint: "E-mail",
              icon: Icons.email,
              controller: emailController,
            ),
            CustomTextField(
              hint: "Telefone",
              icon: Icons.phone,
              controller: telefoneController,
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  elevation: 0.0,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {
                  Contato contato = Contato(
                      nome: nomeController.text,
                      email: emailController.text,
                      telefone: telefoneController.text,
                      caminhoImagem: _caminhoImagem?.path);
                  if (contatoEdicao?.nome != null) {
                    contato.id = contatoEdicao!.id;
                  }

                  Navigator.pop(context, contato);
                },
                child: Text('Salvar',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
