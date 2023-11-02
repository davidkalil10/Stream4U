import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream4u/LoginForm.dart';
import 'package:stream4u/components/sign_in_form.dart';

Future<Object?> customSigninDialog(BuildContext context,
    {required ValueChanged onClosed}) {
  return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "Sign up",
      context: context,
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        Tween<Offset> tween = Tween(begin: Offset(0, -1), end: Offset.zero);
        return SlideTransition(
            position: tween.animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child);
      },
      pageBuilder: (context, _, __) => Center(
        child: SingleChildScrollView(
          child: Container(
            height: 620,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: const BorderRadius.all(Radius.circular(40))),
            child:  Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset:
              false, // avoid overflow error when keyboard shows up
              body: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(children: [
                    Text(
                      "Logar",
                      style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "Acesse já todos os seus filmes e séries preferidos na sua plataforma única de Streaming!",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child:  LoginForm(),
                    ),
                    Center(
                      child: Text(
                        "Não tem conta? Solicite seu teste já!",
                        style: TextStyle(color: Colors.black26),
                      ),
                    ),
                    // SignInForm(),
                    // Row(
                    //   children: [
                    //     // Expanded(
                    //     //   child: Divider(),
                    //     // ),
                    //     Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 0),
                    //       child: Text(
                    //         "Não tem conta? Solicite seu teste já!",
                    //         style: TextStyle(color: Colors.black26),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      )).then(onClosed);
}