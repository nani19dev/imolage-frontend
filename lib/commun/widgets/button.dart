import 'package:flutter/material.dart';
const padding = EdgeInsets.fromLTRB(25, 0, 25, 25);
const buttonSize = Size(390, 50);

class FormButton extends StatelessWidget {
  final GlobalKey<FormState> formkey;
  final Function()? onPressed;
  final String text;

  const FormButton({
    super.key,
    required this.formkey,
    required this.onPressed,
    required this.text
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: FilledButton(
        onPressed: onPressed,
        //style: ElevatedButton.styleFrom(fixedSize: buttonSize),
        child: Text(text),
      ),
    );
  }
}