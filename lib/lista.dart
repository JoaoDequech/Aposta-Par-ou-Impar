import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Uma lista dos jogadores que já apostaram deve ser exibida
// O jogador seleciona qual será o seu oponente na lista
class Lista extends StatelessWidget {
  final Function(String) callback;
  Lista(this.callback);

  Future<List<dynamic>> fetchPlayers() async {
    final response = await http.get(Uri.parse('https://par-impar.glitch.me/jogadores'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['jogadores'];
    } else {
      throw Exception('Failed to load players');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista')),
      body: FutureBuilder<List<dynamic>>(
        future: fetchPlayers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final players = snapshot.data ?? [];
            return ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return ListTile(
                  title: Text(player['username']),
                  onTap: () => callback(player['username']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
