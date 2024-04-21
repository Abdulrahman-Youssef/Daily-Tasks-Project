import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/models/task.dart';
import 'package:untitled1/views/home_cubit.dart';
import 'package:custom_accordion/custom_accordion.dart';
import 'Home_Page_Drawer.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit()..init(),
      child: Scaffold(
        drawer: Home_Page_Drawer(),
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text('Tasks'),
          actions: [],
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (oldS, newS)=> true,
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
                                  TextButton(
                                    onPressed: () => context.read<HomeCubit>().setCompleted(t),
                                    child: Text('complete'),
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
      ),
    );
  }




}
