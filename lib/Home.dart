import 'dart:core';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stream4u/WebViewPage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkCurrentUser();
  }

  Future<void> checkCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _auth.signOut(); // Desconectar o usuário atual.
      // Tente fazer login novamente.
      signIn(); // Chama o método de login após o logout.
    }
  }

  Future<void> signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text + "@tv.com",
      );

      User? user = userCredential.user;
      if (user != null) {
        // Verifique a validade do usuário, por exemplo, a data de expiração, no Firestore.
        // Se expirado, exiba uma mensagem e faça logout.

        // Redirecione para a tela principal se estiver válido.
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => WebViewPage()));

            }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        // Trate o erro (usuário não encontrado, senha errada, etc.)
        // Exiba uma mensagem de erro para o usuário.
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Erro de login"),
              content: Text("Usuário ou senha incorretos."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Usuário'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: signIn,
                child: Text('Login'),
              ),
            ],
          ),
      ),
    );
  }
}
