import 'package:flutter/material.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/models/visit.dart';

class ViewVisits extends StatefulWidget {
  final List<Visit> visits;

  ViewVisits({this.visits});

  @override
  _ViewVisitsState createState() => _ViewVisitsState(visits: this.visits);
}

class _ViewVisitsState extends State<ViewVisits> {
  final List<Visit> visits;

  _ViewVisitsState({this.visits});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.appBar(title: 'Visit History'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: AppTheme.backgroundColor,
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage(AppTheme.backgroundImage),
          //         repeat: ImageRepeat.repeat)),
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: ListTile(
                    title: Text('Dates',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20))),
              ),
              ListView(
                shrinkWrap: true,
                children: getVisitsWidgets(),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getVisitsWidgets() {
    List<Widget> widgets = [];
    if (visits.isNotEmpty) {
      visits.forEach((e) {
        Icon icon;
        if (e.isUploaded)
          icon = new Icon(Icons.check, color: Colors.green);
        else
          icon = new Icon(Icons.close, color: Colors.red);
        widgets.add(
          Card(
              color: Colors.white,
              child: ListTile(title: Text(e.getStringDate()), trailing: icon)),
        );
      });
    } else
      widgets.add(Card(
          color: Colors.white,
          child: ListTile(
            title: AppTheme.text(text: 'No Visits To Show.'),
            trailing: Icon(
              Icons.priority_high,
              color: Colors.blue,
            ),
          )));
    return widgets;
  }
}
