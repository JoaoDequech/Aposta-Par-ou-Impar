import 'package:flutter/material.dart';
import 'package:par_impar/aposta.dart';
import 'package:par_impar/cadastro.dart';
import 'package:par_impar/lista.dart';
import 'package:par_impar/resultado.dart';
import 'package:par_impar/score.dart';

void main() {
  runApp(ParImpar());
}

class ParImpar extends StatefulWidget {
  @override
  State<ParImpar> createState() => ParImparState();
}

class ParImparState extends State<ParImpar> {
  var telaAtual = 0;
  var jogador = "";
  var oponente = "";

  // função para trocar de tela aceitando um argumento dynamic
  void trocaTela(dynamic idNovaTela) {
    setState(() {
      if (idNovaTela is int) {
        telaAtual = idNovaTela;
      } else if (idNovaTela is String) {
        oponente = idNovaTela;
        telaAtual = 3; // muda para a tela de resultado após selecionar oponente
      }
    });
  }

  void cadastro(String nome) {
    jogador = nome;
    trocaTela(1);
  }

  Widget exibirTela() {
    if (telaAtual == 0) {
      return Cadastro(cadastro);
    } else if (telaAtual == 1) {
      return Aposta(trocaTela, jogador);
    } else if (telaAtual == 2) {
      return Lista(trocaTela);
    } else if (telaAtual == 3) {
      return Resultado(trocaTela, jogador, oponente);
    } else {
      return Score(trocaTela, jogador);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Par ou Ímpar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: exibirTela(),
    );
  }
}
