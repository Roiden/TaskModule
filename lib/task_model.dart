class Task {
  int id;
  String projectName;
  String taskName;
  String resource;
  DateTime startDate;
  String duration;
  String status;
  int complete; // 0 - complete, 1- complete

  Task({this.projectName, this.taskName, this.resource, this.startDate, this.duration, this.status, this.complete});
  Task.withId({this.id, this.projectName, this.taskName, this.resource, this.startDate, this.duration, this.status, this.complete});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['projectName'] = projectName;
    map['taskName'] = taskName;
    map['resource'] = resource;
    map['startDate'] = startDate.toIso8601String();
    map['duration'] = duration;
    map['status'] = status;
    map['complete'] = complete;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
        id: map['id'],
        projectName: map['projectName'],
        taskName: map['taskName'],
        resource: map['resource'],
        startDate: DateTime.parse(map['startDate']),
        duration: map['duration'],
        status: map['status'],
        complete: map['complete']);
  }
}