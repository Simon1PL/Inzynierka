import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final bool active;
  final double? width, fontSize;
  final List<double>? padding;
  final Function()? function;

  MyButton(this.text, this.active, this.function, {this.width, this.fontSize, this.padding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        decoration: BoxDecoration(
          color: active ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(70),
          border: Border.all(
            width: fontSize != null && fontSize! > 20.0 ? 3.0 : 1.0,
            color: Colors.grey[800]!,
          ),
        ),
        child: Padding(
          padding: padding != null
              ? EdgeInsets.fromLTRB(
                  padding![0], padding![1], padding![2], padding![3])
              : const EdgeInsets.all(5.0),
          child: Container(
            width: width != null ? width : 100,
            child: Center(
              child: Text(
                text,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    color: active ? Colors.white : Colors.grey[800],
                    fontSize: fontSize,
                    fontWeight: fontSize != null && fontSize! > 20.0 ? FontWeight.w600 : FontWeight.w300),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
