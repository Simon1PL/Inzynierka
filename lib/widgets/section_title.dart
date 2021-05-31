import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      alignment: Alignment.center,
      color: Colors.grey,
      child:
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
    );
  }
}
