import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/models/task.dart';

class NewTaskDialog extends StatefulWidget {
  @override
  State<NewTaskDialog> createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<NewTaskDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      child: Container(

        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Task',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextFormField(
              initialValue: title,
              decoration: InputDecoration(
                label: Text('Task Title'),
              ),
              onChanged: (value) => title = value,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text('Task Description'),
              ),
              onChanged: (value) => description = value,
              maxLines: 5,
            ),
            Row(
              children: [
                Text('Priority: '),
                DropdownButton<Priority>(
                    value: priority,
                    items: priorityList
                        .map((e) => DropdownMenuItem(
                              child: Text(e.name),
                              value: e.val,
                            ))
                        .toList(),
                    onChanged: (value) { priority = value!; setState((){});}),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: () => _add(context), child: Text('Add')),
                OutlinedButton(
                    onPressed: () => _close(context), child: Text('Cancel'))
              ],
            )
          ],
        ),
      ),
    );
  }

  // state vars
  String title = 'Task';
  String? description;
  Priority priority = Priority.low;

  List<({Priority val, String name})> priorityList = [
    (val: Priority.low, name: 'Low'),
    (val: Priority.medium, name: 'Medium'),
    (val: Priority.high, name: 'High')
  ];

  void _add(BuildContext context) {
    Task task = Task(
        id: 0,
        title: title,
        priority: priority,
        timeCreated: DateTime.now(),
        dueTime: DateTime.now().add(Duration(days: 30)),
        status: Status.planned,
        description: description);

    Navigator.pop<Task>(context, task);
  }

  void _close(BuildContext context) {
    Navigator.pop(context);
  }
}
