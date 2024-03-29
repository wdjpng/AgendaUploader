import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String selected;
List<String> classes = List<String>();

class UploaderPage extends StatefulWidget {
  UploaderPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _UploaderPageState createState() => _UploaderPageState();
}

class _UploaderPageState extends State<UploaderPage> {
  TextEditingController messageText = new TextEditingController();

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

  void showMessage(BuildContext context, String title, String message, AlertType alertType){
    Alert(
      context: context,
      type: alertType,
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

  bool isCorrectUserData(String message, BuildContext context){
    if(message == "" || selectedDate == initialDateTime || selected == null){
      if(selected != null){
        if(message == "" && selectedDate != initialDateTime){
          showMessage(context, "NICHT ALLE FELDER AUSGEFÜLLT", "Bitte geben Sie eine Nachricht ein", AlertType.error);
        } else if(message != "" && selectedDate == initialDateTime){
          showMessage(context, "NICHT ALLE FELDER AUSGEFÜLLT", "Bitte wählen Sie ein Datum aus",  AlertType.error);
        } else{
          showMessage(context, "NICHT ALLE FELDER AUSGEFÜLLT", "Bitte wählen Sie ein Datum aus und geben Sie bitte eine Nachricht ein",  AlertType.error);
        }
      } else{
        if(message == "" && selectedDate != initialDateTime){
          showMessage(context, "NICHT ALLE FELDER AUSGEFÜLLT", "Bitte geben Sie eine Nachricht ein und wählen Sie eine Klasse aus", AlertType.error);
        } else if(message != "" && selectedDate == initialDateTime){
          showMessage(context, "NICHT ALLE FELDER AUSGEFÜLLT", "Bitte wählen Sie ein Datum und eine Klasse aus",  AlertType.error);
        } else{
          showMessage(context, "NICHT ALLE FELDER AUSGEFÜLLT", "Bitte wählen Sie ein Datum und eine Klasse aus und geben Sie bitte eine Nachricht ein",  AlertType.error);
        }
      }


      return false;
    }

    return true;
  }

  void resetFields(){
    messageText.text = "";
    selectedDate = initialDateTime;
  }
  void pushEvent(String message){
    Firestore.instance.collection('events').document()
        .setData({ 'message': message, 'dateOfEvent': selectedDate, 'subject' : selected });
    resetFields();
  }

  void onUploadButtonPressed(BuildContext context, TextEditingController textEditingController){
    String message = textEditingController.text;

    if(!isCorrectUserData(message, context)){
      return;
    }

    pushEvent(message);
    showMessage(context, "DATEN ERFOLGREICH HOCHGELADEN", "", AlertType.success);
    FocusScope.of(context).requestFocus(new FocusNode());
    resetFields();
  }

  void updateClasses(List<DocumentSnapshot> snapshot){
    classes = [];
    for(var i = 0; i < snapshot.length; i++){
      classes.add(snapshot[i]['name']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('subjects').snapshots(),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        updateClasses(snapshot.data.documents);
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 20.0,),
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.lightBlue,
                  onPressed: () => _selectDate(context),
                  child: Text(getButtonText()),
                ),
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
                DropdownButton<String>(
                  value: selected,
                  hint: Text('Klasse auswählen'),
                  items: classes
                      .map((label) => DropdownMenuItem(
                    child: Text(label),
                    value: label,
                  ))
                      .toList(),
                  onChanged: (String newValue) {
                    setState(() {
                      selected = newValue;
                    });
                  },
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
      });
  }
}