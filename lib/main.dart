import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate = DateTime.now();
  DateTime initialDateTime;

  @override
  void initState() {
    super.initState();
    initialDateTime = selectedDate;
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019, 4),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    print('Date selected: ' + selectedDate.toIso8601String());
  }

  String getButtonText(){
    if(selectedDate == initialDateTime){
      return 'Bitte das Datum auswählen';
    }

    return 'Der ' + selectedDate.day.toString() + '. ' + selectedDate.month.toString()
        + '. ' + selectedDate.year.toString() + ' ist ausgewählt';
  }

  void showErrorMessage(BuildContext context, String title, String message){
    Alert(
      context: context,
      type: AlertType.error,
      title: title,
      desc: message,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }
  void onUploadButtonPressed(BuildContext context, TextEditingController textEditingController){
    String message = textEditingController.text;

    if(message == "" || selectedDate == initialDateTime){
      if(message == "" && selectedDate != initialDateTime){
        showErrorMessage(context, "NICHT ALLE FELDER AUSGEFÜLLT", "Bitte geben Sie eine Nachricht ein");
      } else if(message != "" && selectedDate == initialDateTime){
        showErrorMessage(context, "NICHT ALLE FELDER AUSGEFÜLLT", "Bitte wählen Sie ein Datum aus");
      } else{
        showErrorMessage(context, "NICHT ALLE FELDER AUSGEFÜLLT", "Bitte wählen Sie ein Datum aus und geben Sie bitte eine Nachricht ein");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController messageText = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 20.0,),
            new Container(
              width: 350.0,
              child:TextField(
                  controller: messageText,
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nachricht'
                  )
              ),
            ),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.lightBlue,
              onPressed: () => _selectDate(context),
              child: Text(getButtonText()),
            ),
            FloatingActionButton(
              onPressed: () => onUploadButtonPressed(context, messageText),
              tooltip: 'Bestätigen',
              child: Icon(Icons.cloud_upload),
            ),
          ],
        ),
      ),
    );
  }
}