import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream4u/HomeScreen.dart';
import 'package:stream4u/components/animated_btn.dart';
import 'package:stream4u/components/custom_sign_in.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;


  Future<void> autoLogin() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');
      String? user = prefs.getString('user');
      String? pass = prefs.getString('pass');

      if (authToken == "true") {
        // Faça login usando o token
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user!,
          password: pass!,
        );

        await signIn(userCredential);

      }
    } catch (e) {
      print("Erro ao fazer login automaticamente: $e");
    }
  }

  Future<void> signIn(UserCredential userCredential) async {


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
          print("Usuário logado automaticamente: ${userCredential.user?.uid}");
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomeScreen(expirationDate:dt1 )));
        }

      }
    }

  void _setLandscapeOrientation(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    super.initState();
    _setLandscapeOrientation();
    autoLogin();
  }

  @override
  void dispose() {
    // Quando o State é descartado, volta para as orientações preferidas do sistema
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Positioned(
                width: MediaQuery.of(context).size.width * 1.7,
                bottom: 200,
                left: 100,
                child: Image.asset('assets/Backgrounds/Spline.png')),
            Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
                )),
            const RiveAnimation.asset('assets/RiveAssets/shapes.riv'),
            Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
                  child: const SizedBox(),
                )),
            AnimatedPositioned(
              duration: Duration(milliseconds: 240),
              top: isSignInDialogShown ? -50 : 0,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(),
                        const SizedBox(
                          width: 260,
                          child: Column(children: [
                            Text(
                              "Stream 4U",
                              style: TextStyle(
                                  fontSize: 60, fontFamily: "Poppins", height: 1.2),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                                "Seus filmes, séries e canais preferidos na palma de sua mão em um só lugar!",
                              style: TextStyle(
                                  fontSize: 25, fontFamily: "Poppins", height: 1.2),
                            )
                          ]),
                        ),
                        const Spacer(
                          flex: 2,
                        ),
                        AnimatedBtn(
                          btnAnimationController: _btnAnimationController,
                          press: () {
                            _btnAnimationController.isActive = true;
                            Future.delayed(Duration(milliseconds: 800), () {
                              setState(() {
                                isSignInDialogShown = true;
                              });
                              customSigninDialog(context, onClosed: (_) {
                                setState(() {
                                  isSignInDialogShown = false;
                                });
                              });
                            });
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(
                            "Ainda não é cliente? Solicite seu teste grátis agora mesmo!",
                            style: TextStyle(),
                          ),
                        )
                      ]),
                ),
              ),
            )
          ],
        ));
  }
}