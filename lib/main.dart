import 'onlineUploaderPage.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgendaUploader',
      home: OnlineUploaderPage(title: 'AgendaUploader'),
    );
  }
}



