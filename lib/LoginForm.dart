import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stream4u/WebViewPage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:stream4u/WebViewWidget.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

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
    String login = "${_emailController.text}@tv.com";
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: login,
        password: _passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Verifique a validade do usuário, por exemplo, a data de expiração, no Firestore.
        // Se expirado, exiba uma mensagem e faça logout.
        DocumentReference<Map<String, dynamic>> userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
        // Obter o documento correspondente ao UID
        DocumentSnapshot<Map<String, dynamic>> document = await userRef.get();

        Timestamp? expirationDate = document.data()?['expirationDate'];
        DateTime? dt1 = expirationDate?.toDate();

        //Verificar validade do usuario
        if (dt1!.isBefore(DateTime.now())) {
          print("expiration : usuário expirado");

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Erro de login",style: TextStyle(fontSize: 20, fontFamily: "Poppins")),
                content: Text("Usuário Expirado. Renove seu plano!",style: TextStyle(fontSize: 15)),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF77D8E),
                          minimumSize: const Size(double.infinity, 56),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25)))),
                      child: const Text("Fechar"))
                ],
              );
            },
          );

        } else{
          // Redirecione para a tela principal se estiver válido.
         // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => WebViewPage()));
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => WebViewWidget()));
        }



      }
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'INVALID_LOGIN_CREDENTIALS' || e.code == 'invalid-login-credentials') {
        // Trate o erro (usuário não encontrado, senha errada, etc.)
        // Exiba uma mensagem de erro para o usuário.
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Erro de login",style: TextStyle(fontSize: 20, fontFamily: "Poppins")),
              content: Text("Usuário ou senha incorretos.",style: TextStyle(fontSize: 15)),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF77D8E),
                        minimumSize: const Size(double.infinity, 56),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25)))),
                    child: const Text("Tentar Novamente"))
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
      resizeToAvoidBottomInset:
      false,
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Usuário",
              style: TextStyle(color: Colors.black54),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SvgPicture.asset("assets/icons/User.svg"),
                    )),
              ),
            ),
            const Text(
              "Senha",
              style: TextStyle(color: Colors.black54),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SvgPicture.asset("assets/icons/password.svg"),
                    )),
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 24),
              child: ElevatedButton.icon(
                  onPressed: signIn,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF77D8E),
                      minimumSize: const Size(double.infinity, 56),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25)))),
                  icon: const Icon(
                    CupertinoIcons.arrow_right,
                    color: Color(0xFFFE0037),
                  ),
                  label: const Text("Login")),
            ),
          ],
        ),
      ),
    );
  }
}
