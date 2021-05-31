import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final bool active;
  final Null Function()? function;
  MyButton(this.text, this.active, [this.function]);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        decoration: BoxDecoration(
          color: active ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(70),
          border: Border.all(
            color: Colors.grey[800]!,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            text,
            style: TextStyle(color: active ? Colors.white : Colors.grey[800],),
          ),
        ),
      ),
    );
  }
}
