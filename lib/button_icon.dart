import 'package:flutter/material.dart';

class ButtonIcon extends StatelessWidget {
  final Color color;
  final IconData icon;
  final double size;
  final Function() onPressed;
  const ButtonIcon({
    super.key,
    required this.color,
    required this.icon,
    this.size = 35,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: ShapeDecoration(
        shadows: const [
          BoxShadow(
            color: Color.fromARGB(255, 148, 148, 148),
            offset: Offset(5, 5),
            blurRadius: 10,
          ),
        ],
        color: color,
        shape: const CircleBorder(),
      ),
      child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: size,
          )),
    );
  }
}
