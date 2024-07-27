import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/models/task.dart';
import 'package:untitled1/views/home_cubit.dart';
import 'package:custom_accordion/custom_accordion.dart';
import 'package:untitled1/views/task_card.dart';
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
      drawer: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
        return Home_Page_Drawer();
      }),
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
              ? const RefreshProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: state.PandOP!
                      .map((Task t) => TaskCard(context, t))
                      .toList(),
                ),
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
