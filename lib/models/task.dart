import 'package:flutter/material.dart';
import 'package:untitled1/models/serializable.dart';

class Task extends Serializable {
  late int id;
  late String title;
  String? description;
  late DateTime timeCreated;
  late DateTime dueTime;
  late Status status;
  late Priority priority;

  Task(
      {required this.id,
      required this.title,
      required this.timeCreated,
      this.description,
      required this.dueTime,
      required this.status,
      required this.priority});

  Task.empty();

  @override
  void fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    timeCreated = DateTime.parse(map['timeCreated']);
    description = map['description'];
    status = Status.values[map['status']];
    priority = Priority.values[map['priority']];
    dueTime = DateTime.parse(map['dueTime']);
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['timeCreated'] = this.timeCreated.toIso8601String();
    data['description'] = this.description;
    data['status'] = this.status.index;
    data['priority'] = this.priority.index;
    data['dueTime'] = this.dueTime.toIso8601String();
    return data;
  }
}

enum Status { planned, onProgress, completed, failed }

enum Priority { low, medium, high }

// {"id":1,"title" : "", "timeCreated": "" , "description" :"" , "status" : 1 , "priority" : 2  }
