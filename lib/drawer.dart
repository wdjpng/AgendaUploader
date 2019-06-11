import 'package:flutter/material.dart';
import 'selectorPage.dart';
import 'eventsPage.dart';
import 'onlineUploaderPage.dart';

class DrawerOnly extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    return new Drawer(
        child: new ListView(
          children: <Widget>[
            new DrawerHeader(
              child: new Container(
                child:Column(
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        elevation: 0,
                        child: Padding(padding : EdgeInsets.all(0.0),
                        child: Image.asset('assets/images/icon.png', width:90, height:90),),
                      ),
                      Padding(padding: EdgeInsets.all(8.0), child: Text('AgendaUploader', style: TextStyle(color: Colors.white, fontSize: 22.0),))
                    ]
                )
              ),
              decoration: new BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[Colors.lightBlueAccent, Colors.blueAccent])
              ),
            ),
            new ListTile(
              title: new Text("Kalender"),
              leading: new Icon( Icons.calendar_today),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventsPage(title: 'AgendaApp'))
                );
              }
            ),
            new ListTile(
                title: new Text("Fächer auswählen"),
                leading: new Icon( Icons.rate_review),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SelectorPage())
                  );
                }
            ),
            new ListTile(
                title: new Text("Hochladen"),
                leading: new Icon( Icons.cloud_upload),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OnlineUploaderPage())
                  );
                }
            ),
          ],
        )
    );
  }
}