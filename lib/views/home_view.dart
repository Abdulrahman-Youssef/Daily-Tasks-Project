import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/models/task.dart';
import 'package:untitled1/views/home_cubit.dart';
import 'package:custom_accordion/custom_accordion.dart';
import 'Home_Page_Drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Home_Page_Drawer(),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Tasks'),

      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previousState, state) {

          print(previousState);
          return true;
          // return true/false to determine whether or not
          // to rebuild the widget with state
        },
        builder: (BuildContext context, state) => SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: state.tasks == null
              ? RefreshProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: state.tasks!
                      .map((Task t) => CustomAccordion(
                            title: t.title,
                            subTitle: t.priority.toString() ?? '---',
                            backgroundColor: t.status == Status.failed
                                ? Colors.red
                                : Colors.green,
                            widgetItems: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${t.description}'),
                                Text('${t.status}'),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      style:  TextButton.styleFrom(
                                          foregroundColor: Colors.blue),
                                      onPressed: () => context.read<HomeCubit>().setCompleted(t),
                                      child: const Text('complete'),
                                    ),
                                    TextButton(
                                      style:  TextButton.styleFrom(
                                          foregroundColor: Colors.grey),
                                      onPressed: () => context.read<HomeCubit>().setFailed(t),
                                      child: const Text('Failed'),
                                    ),
                                    TextButton(
                                      style:  TextButton.styleFrom(
                                          foregroundColor: Colors.pink),
                                      onPressed: () => context.read<HomeCubit>().RemoveTask(t),
                                      child: const Text('Remove'),
                                    ),

                                  ],
                                ),

                              ],
                            ),
                          ))
                      .toList()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () => context.read<HomeCubit>().addNewTask(context),
        tooltip: 'New Task',
        child: const Icon(CupertinoIcons.add_circled),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
