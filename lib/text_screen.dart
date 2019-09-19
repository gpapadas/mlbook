import 'package:flutter/material.dart';

class TextScreen extends StatelessWidget {
  TextScreen({this.text});

  final text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Text to show',
      )),
      body: Center(
        child: ListView.builder(itemBuilder: (context, index) {
          return Text(text[index]);
        }),
      ),
      // Center(
      //   child: Text(text),
      // ),
    );
  }
}
