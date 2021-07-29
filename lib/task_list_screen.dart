import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_module/task_model.dart';
import 'package:task_module/task_statistics_screen.dart';

import 'add_task_screen.dart';
import 'database_helper.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  Future<List<Task>> _taskList;
  final DateFormat _dateFormat = DateFormat('MMM dd,yyyy');
  String dropdownValue = 'All    ';

  @override
  void initState() {
    super.initState();
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
                      child: Text('Resource          :',
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
                      child: Text(' ${task.resource}',
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
                      child: Text('Start Date         :',
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
                      child: Text(' ${_dateFormat.format(task.startDate)}',
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
                      child: Text('Duration            :',
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
                      child: Text(' ${task.duration}',
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
            trailing: Checkbox(
                onChanged: (value) {
                  task.complete = value ? 1 : 0;
                  DatabaseHelper.instance.updateTask(task);
                  _updateTaskList();
                  print(value);
                },
                activeColor: Theme.of(context).primaryColor,
                value: task.complete == 1 ? true : false),
            onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (_) => AddTaskScreen(
                      task: task,
                      updateTaskList: _updateTaskList,
                    ))),
          ),
          Divider()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal.shade300,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>TaskStatisticsScreen()),),
            ),
            title: Text('Task',style: TextStyle(fontSize: 20.0),),
            bottom: PreferredSize(
                child:Container(
                  margin: EdgeInsets.fromLTRB(0,10,0.0,0.0),
                  padding: EdgeInsets.fromLTRB(10,15,5,0.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
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
                        ],
                      ),
                      TabBar(
                          isScrollable: true,
                          unselectedLabelColor: Colors.grey.withOpacity(0.8),
                          indicatorColor: Colors.grey,
                          tabs: [
                            Tab(
                              child: Text('   Approved   ',style: TextStyle(fontSize: 16.0,color:Colors.grey),),
                            ),
                            Tab(
                              child: Text('   In Progress   ',style: TextStyle(fontSize: 16.0,color:Colors.grey),),
                            ),
                            Tab(
                              child: Text('   Overdue   ',style: TextStyle(fontSize: 16.0,color:Colors.grey),),
                            ),
                            Tab(
                              child: Text('  Pending Approval  ',style: TextStyle(fontSize: 16.0,color:Colors.grey),),
                            ),
                            Tab(
                              child: Text('   Not Started   ',style: TextStyle(fontSize: 16.0,color:Colors.grey),),
                            ),
                          ]),
                    ],
                  ),

                ),
                preferredSize: Size.fromHeight(102.0)),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (_) => AddTaskScreen(
                        updateTaskList: _updateTaskList,
                      )));
            },
            child: Icon(Icons.add),
          ),
          body: TabBarView(
            children: <Widget>[
              FutureBuilder(
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
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        }
                        return _buildTask(snapshot.data[i - 1]);
                      },
                    );
                  }),
              FutureBuilder(
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
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        }
                        return _buildTask(snapshot.data[i - 1]);
                      },
                    );
                  }),
              FutureBuilder(
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
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        }
                        return _buildTask(snapshot.data[i - 1]);
                      },
                    );
                  }),
              FutureBuilder(
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
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        }
                        return _buildTask(snapshot.data[i - 1]);
                      },
                    );
                  }),
              FutureBuilder(
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
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        }
                        return _buildTask(snapshot.data[i - 1]);
                      },
                    );
                  }),
            ],
          ),


        ),
    );
  }
}