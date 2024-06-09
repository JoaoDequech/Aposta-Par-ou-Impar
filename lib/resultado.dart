import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Página responsável por exibir o resultado da aposta
class Resultado extends StatelessWidget {
  final Function callback;
  final String jogador;
  final String oponente;

  Resultado(this.callback, this.jogador, this.oponente);

  Future<Map<String, dynamic>> jogar() async {
    final response = await http.get(Uri.parse('https://par-impar.glitch.me/jogar/$jogador/$oponente'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to play the game');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resultado')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: jogar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final result = snapshot.data ?? {};
            final winner = result['vencedor']?['username'] ?? 'Ninguém';
            final message = result.containsKey('msg') ? result['msg'] : 'Vencedor: $winner';
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(message, style: TextStyle(fontSize: 24)),
                TextButton(
                  child: Text('Checar Pontuação'),
                  onPressed: () => callback(4),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
