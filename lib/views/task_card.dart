import 'package:custom_accordion/custom_accordion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task.dart';
import 'home_cubit.dart';



Widget TaskCard(BuildContext context, Task t) {
  return CustomAccordion(
    // why all the letters are capital
    title: t.title,
    subTitle: t.priority.name.toString() ?? '---',

    backgroundColor: t.status == Status.failed
        ? Colors.red
        : t.status == Status.planned || t.status == Status.onProgress
        ? Colors.deepPurpleAccent[300]
        : Colors.green,
    widgetItems: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(

              children: [
                Text("The Description \n" , style: TextStyle(color: Colors.green),),
                Text('${t.description}'),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end ,
          children: [
            Text(t.status.name),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              onPressed: () => context.read<HomeCubit>().setCompleted(t),
              child: const Text('complete'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              onPressed: () => context.read<HomeCubit>().setFailed(t),
              child: const Text('Failed'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.pink),
              onPressed: () => context.read<HomeCubit>().RemoveTask(t),
              child: const Text('Remove'),
            ),
          ],
        ),
      ],
    ),
  );
}
