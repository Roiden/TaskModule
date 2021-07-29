import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_module/task_model.dart';
import 'database_helper.dart';

class AddTaskScreen extends StatefulWidget {
  final Task task;
  final Function updateTaskList;

  const AddTaskScreen({Key key, this.task, this.updateTaskList})
      : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _projectName = '';
  String _taskName = '';
  String _resource = '';
  String _duration = '';
  String _status = '';
  DateTime _startDate = DateTime.now();

  TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  final List<String> _statuses = ['Not Started', 'In Progress', 'Pending Approval','Approved','Overdue'];

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _startDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (date != null && date != _startDate) {
      setState(() {
        _startDate = date;
      });
      _dateController.text = _dateFormat.format(date);
    }
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('$_projectName $_taskName $_resource $_startDate $_duration $_status');

      //insert the task to our user's database
      Task task = Task(projectName: _projectName, taskName: _taskName, resource: _resource, startDate: _startDate, duration: _duration, status: _status);
      if (widget.task == null) {
        task.complete = 0;
        DatabaseHelper.instance.insertTask(task);
      } else {
        //update the task
        task.id = widget.task.id;
        task.complete = widget.task.complete;
        DatabaseHelper.instance.updateTask(task);
      }
      widget.updateTaskList();
      Navigator.pop(context);
    }
  }

  _delete() {
    DatabaseHelper.instance.deleteTask(widget.task.id);
    widget.updateTaskList();
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.task != null) {
      _projectName = widget.task.projectName;
      _taskName = widget.task.taskName;
      _resource = widget.task.resource;
      _startDate = widget.task.startDate;
      _duration = widget.task.duration;
      _status = widget.task.status;
    }
    _dateController.text = _dateFormat.format(_startDate);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    Text(widget.task == null ? 'Add Task' : 'Update Task',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  height: 1,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              labelText: 'Project Name',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          validator: (input) => input.trim().isEmpty
                              ? "Please enter a Project Name"
                              : null,
                          onSaved: (input) => _projectName = input,
                          initialValue: _projectName,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 9,
                        ),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              labelText: 'Task Name',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          validator: (input) => input.trim().isEmpty
                              ? "Please enter a Task Name"
                              : null,
                          onSaved: (input) => _taskName = input,
                          initialValue: _taskName,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 9,
                        ),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              labelText: 'Resource',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          validator: (input) => input.trim().isEmpty
                              ? "Please enter a Resource"
                              : null,
                          onSaved: (input) => _resource = input,
                          initialValue: _resource,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                        ),
                        child: TextFormField(
                          readOnly: true,
                          controller: _dateController,
                          onTap: _handleDatePicker,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              labelText: 'Start Date',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          validator: (input) => input.trim().isEmpty
                              ? "Please enter a Start Date"
                              : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 9,
                        ),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              labelText: 'Duration',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          validator: (input) => input.trim().isEmpty
                              ? "Please enter a Duration"
                              : null,
                          onSaved: (input) => _duration = input,
                          initialValue: _duration,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          child: DropdownButtonFormField(
                            isDense: true,
                            items: _statuses.map((String status) {
                              return DropdownMenuItem(
                                  value: status,
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ));
                            }).toList(),
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                                labelText: 'Status',
                                labelStyle: TextStyle(fontSize: 18),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (input) => _status == null
                                ? "Please Select a Project Status"
                                : null,
                            onChanged: (value) {
                              setState(() {
                                _status = value;
                              });
                            },
                          )),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30)),
                        child: FlatButton(
                          onPressed: _submit,
                          child: Text(
                            widget.task == null ? "Add" : 'Update',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      widget.task == null
                          ? SizedBox.shrink()
                          : Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30)),
                        child: FlatButton(
                          onPressed: _delete,
                          child: Text(
                            'Delete',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}