import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Página responsável por exibir a pontuação total do jogador
class Score extends StatelessWidget {
  final Function callback;
  final String username;

  Score(this.callback, this.username);

  Future<Map<String, dynamic>> fetchScore() async {
    final response = await http.get(Uri.parse('https://par-impar.glitch.me/pontos/$username'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load score');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pontuação')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchScore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final score = snapshot.data?['pontos'] ?? 0;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Pontuação Atual: $score', style: TextStyle(fontSize: 24)),
                ElevatedButton(
                  child: Text('Jogar Novamente'),
                  onPressed: () => callback(1),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
