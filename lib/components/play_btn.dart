import 'package:flutter/cupertino.dart';
import 'package:rive/rive.dart';

class PlayBtn extends StatelessWidget {
  const PlayBtn({
    super.key,
    required RiveAnimationController btnAnimationController,
    required this.press,
  }) : _btnAnimationController = btnAnimationController;

  final RiveAnimationController _btnAnimationController;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        height: 40,
        width: 150,
        child: Stack(children: [
          RiveAnimation.asset(
            "assets/RiveAssets/button.riv",
            controllers: [_btnAnimationController],
          ),
          const Positioned.fill(
              top: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Play",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18,))
                ],
              )),
        ]),
      ),
    );
  }
}