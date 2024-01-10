import 'package:flutter/material.dart';

Widget customElevatedButton(
    {required BuildContext context,
    required String label,
    required void Function() callback,
    required double fontSize}) {
  return SizedBox(
    child: ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.resolveWith(
          (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith(
          (_) => Color(0xFF69f0ae),
        ),
        textStyle: MaterialStateProperty.resolveWith(
          (states) => TextStyle(color: Colors.black54),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          label,
          style: TextStyle(fontSize: fontSize, color: Colors.black54),
        ),
      ),
      onPressed: callback,
    ),
  );
}
