import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/views/home_cubit.dart';
import 'home_view.dart';
import 'package:untitled1/models/task.dart';
import 'package:custom_accordion/custom_accordion.dart';



class TasksHistory extends StatelessWidget {
  const TasksHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(backgroundColor: Colors.deepPurple, title: const Text('Task History')),
        body:BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previousState, state) {
              print(previousState);
              return true;
              // return true/false to determine whether or not
              // to rebuild the widget with state
            },
          builder: (BuildContext context, state) => SingleChildScrollView(
              scrollDirection: Axis.vertical,
                  child: state.tasks == null
                      ? const RefreshProgressIndicator()
                      :Column(
                    children: [
                      Container(
                        height: 30,
                        color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('total tasks : ${state.tasks!.length} '),
                            Text('completed tasks : ${state.completedTasks!.length} '),
                            Text('failed tasks : ${state.failedTasks!.length} ')
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child:state.tasks == null
                            ? const RefreshProgressIndicator()
                            : Column(
                          children: state.completedTasks!
                              .map((e) => (CustomAccordion(
                            subTitle: e.status.toString(),
                            title: e.title,
                            widgetItems: Column(
                              children: [
                                Text('${e.description}'),
                                TextButton(
                                    onPressed: () => context.read<HomeCubit>().RemoveTask(e),
                                    child: const Text('remove'))
                              ],
                            ),
                          )))
                              .toList(),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: state.failedTasks!
                              .map((e) => (CustomAccordion(
                            subTitle: e.status.toString(),
                            title: e.title,
                            widgetItems: Column(
                              children: [
                                Text('${e.description}'),
                                TextButton(
                                    onPressed: () => context.read<HomeCubit>().RemoveTask(e),
                                    child: const Text('remove'))
                              ],
                            ),
                          )))
                              .toList(),
                        ),
                      ),
                    ],
                  )
          )));
  }
}
