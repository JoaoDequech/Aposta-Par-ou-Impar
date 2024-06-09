import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Página de cadastro do jogador
class Cadastro extends StatelessWidget {
  final Function callback;

  Cadastro(this.callback);

  Future<void> cadastrarJogador(String username) async {
    final response = await http.post(
      Uri.parse('https://par-impar.glitch.me/novo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create player');
    }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final jogador = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextFormField(
                controller: jogador,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Jogador"),
              ),
            ),
            ElevatedButton(
              child: const Text('Apostar'),
              onPressed: () async {
                await cadastrarJogador(jogador.text);
                callback(jogador.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
