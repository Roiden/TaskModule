import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_module/task_list_screen.dart';
import 'package:task_module/task_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'add_task_screen.dart';
import 'database_helper.dart';

class TaskStatisticsScreen extends StatefulWidget {
  @override
  _TaskStatisticsScreenState createState() => _TaskStatisticsScreenState();
}

class _TaskStatisticsScreenState extends State<TaskStatisticsScreen> {
  Future<List<Task>> _taskList;
  final DateFormat _dateFormat = DateFormat('MMM dd,yyyy');
  String dropdownValue = 'All    ';

  List<charts.Series<Ptask, String>> _seriesPieData;
  _generateData() {

    var piedata = [
      new Ptask('Approved', 4, Colors.green),
      new Ptask('In Progress', 3, Colors.blue),
      new Ptask('Overdue', 1, Colors.red),
      new Ptask('Pending Approval', 4, Colors.purple),
      new Ptask('Not Started', 2, Colors.grey),

    ];
    _seriesPieData.add(
      charts.Series(
        domainFn: (Ptask ptask, _) => ptask.ptask,
        measureFn: (Ptask ptask, _) => ptask.ptaskvalue,
        colorFn: (Ptask ptask, _) =>
            charts.ColorUtil.fromDartColor(ptask.pcolorval),
        id: 'Task Statistics',
        data: piedata,
        labelAccessorFn: (Ptask row, _) => '${row.ptaskvalue}',
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesPieData = List<charts.Series<Ptask, String>>();
    _generateData();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  Widget _buildTask(Task task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          ListTile(
            title: Column (
              crossAxisAlignment: CrossAxisAlignment.start,
              children:<Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      child: Text('Project Name   :',
                          style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              decoration: task.complete == 0
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough),
                          textAlign: TextAlign.left),
                    ),
                    Expanded(
                      child: Text(' ${task.projectName}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            decoration: task.complete == 0
                                ? TextDecoration.none
                                : TextDecoration.lineThrough),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      child: Text('Task Name       :',
                          style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              decoration: task.complete == 0
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough),
                          textAlign: TextAlign.left),
                    ),
                    Expanded(
                      child: Text(' ${task.taskName}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            decoration: task.complete == 0
                                ? TextDecoration.none
                                : TextDecoration.lineThrough),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      child: Text('Status                :',
                          style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              decoration: task.complete == 0
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough),
                          textAlign: TextAlign.left),
                    ),
                    Expanded(
                      child: Text(' ${task.status}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            decoration: task.complete == 0
                                ? TextDecoration.none
                                : TextDecoration.lineThrough),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 10,
                  thickness: 0.5,
                  color: Colors.black,
                ),
              ],
            ),
            ),
          Divider()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade300,
        leading: Icon(Icons.arrow_back),
        title: const Text('Task'),
        bottom: PreferredSize(
            child:Container(
              margin: EdgeInsets.fromLTRB(0,1,0.0,0.0),
              padding: EdgeInsets.fromLTRB(10,15,10,0.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child:
              Container(
                margin: EdgeInsets.fromLTRB(38,0,38,0),
                padding: EdgeInsets.fromLTRB(120,0,120,0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),

                ),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down_sharp),
                  iconSize: 25,
                  elevation: 10,
                  style: const TextStyle(color: Colors.blueGrey),

                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['All    ', 'Imp']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            preferredSize: Size.fromHeight(60.0)),
      ),
      body: Stack(
        children:[
          Container(
            child:Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text('     Task Statistics',
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                        textAlign: TextAlign.left),
                    const SizedBox(
                      height: 65,
                      width:150,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TaskListScreen()),);
                        },
                        child: Text("View",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color:Colors.teal,
                              fontSize:14
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal),
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child:Column(
                    children:<Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: 15,
                            width: 25,
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              child: new Text(""),
                            ),
                          ),
                          Text('   Approved   ',style: TextStyle(fontSize: 13.0,color:Colors.black),),
                          Container(
                            height: 15,
                            width: 25,
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              child: new Text(""),
                            ),
                          ),
                          Text('   InProgress   ',style: TextStyle(fontSize: 13.0,color:Colors.black),),
                          Container(
                            height: 15,
                            width: 25,
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              child: new Text(""),
                            ),
                          ),
                          Text('   Overdue   ',style: TextStyle(fontSize: 13.0,color:Colors.black),),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: 15,
                            width: 25,
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              child: new Text(""),
                            ),
                          ),
                          Text('   Pending Approval   ',style: TextStyle(fontSize: 13.0,color:Colors.black),),
                          Container(
                            height: 15,
                            width: 25,
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              child: new Text(""),
                            ),
                          ),
                          Text('   Not Started   ',style: TextStyle(fontSize: 13.0,color:Colors.black),),
                        ],
                      ),
                      const SizedBox(
                        height: 270,
                        width: 100,
                      ),
                    ],
                  ),
                ),//pie refrence colours
                const SizedBox(
                  height: 34,
                  width: 100,
                ),
              ],
            ),
          ),
          Container(
            margin:EdgeInsets.fromLTRB(60,50,60,100),
            padding:EdgeInsets.fromLTRB(1,1,1,1),
            child: Center(
              child: Expanded(
                child: charts.PieChart(
                    _seriesPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 3),
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 500,
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator(
                              labelPosition: charts.ArcLabelPosition.inside)
                        ])),
              ),
            ),
          ),//Pie Chart

          DraggableScrollableSheet(
            initialChildSize: 0.27,
            minChildSize: 0.27,
            maxChildSize: 1.0,
            builder: (BuildContext context, snapshot) {
              return FutureBuilder(
                  future: _taskList,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final int completedTaskCount = snapshot.data
                        .where((Task task) => task.complete == 1)
                        .toList()
                        .length;

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 1),
                      itemCount: 1 + snapshot.data.length,
                      itemBuilder: (BuildContext context, int i) {
                        if (i == 0) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  '  Task Status',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          );
                        }
                        return _buildTask(snapshot.data[i - 1]);
                      },
                    );
                  }) ;
            },
          ),
        ],
      ),


    );
  }
}

class Ptask {
  String ptask;
  double ptaskvalue;
  MaterialColor pcolorval;

  Ptask(this.ptask, this.ptaskvalue, this.pcolorval);
}