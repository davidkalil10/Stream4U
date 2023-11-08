import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {

 // final Color backgroundColor;
  final IconData icon;
  final String lable;
  final List<Color> coresGradiente;
  final void callback;


  CustomCard({
  //  required this.backgroundColor,
    required this.icon,
    required this.lable,
    required this.coresGradiente,
    required this.callback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        this.callback;
      },
      child: Container(
        height: 100,
        width: 100,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          //color: this.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: this.coresGradiente
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(this.icon, size: 40, color: Colors.white,),
            Text(this.lable, style: TextStyle(color: Colors.white,fontSize: 20),)
          ],
        ),
      ),
    );
  }
}
