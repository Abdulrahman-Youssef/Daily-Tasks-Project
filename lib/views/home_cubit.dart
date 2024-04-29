import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/models/task.dart';
import 'package:untitled1/services/cache_service.dart';
import 'new_task_dialog.dart';

class HomeState {
  List<Task>? tasks;
  // planned and onProgress
  List<Task>? PandOP;
  List<Task>? failedTasks;
  List<Task>? completedTasks;
  int lastId = 0;
// A constructor to put the initial values
  HomeState(
      {this.tasks,
      this.lastId = 0,
      this.PandOP,
      this.failedTasks,
      this.completedTasks});
}

// class LoadingHomeState extends HomeState{}
// class TasksHomeState extends HomeState{}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  final cache = CacheService();
  void init() {
    cache.init().then((_) => afterInit());
  }

  Future<void> addNewTask(BuildContext context) async {
    var task = await showDialog(
        context: context, builder: (context) => NewTaskDialog());

    // ANY change in the home state must be in the emit

    emit(HomeState(
        tasks: state.tasks!..add(task), PandOP: state.PandOP?..add(task)));
    cache.saveList('tasks', state.tasks!);
    state.lastId + 1;
  }

  Future<void> afterInit() async {
    // state.tasks = cache.getList('tasks', () => Task.empty()) ?? [];

    emit(HomeState(tasks: cache.getList('tasks', () => Task.empty()) ?? []));

    state.completedTasks =
        state.tasks!.where((e) => (e.status == Status.completed)).toList();
    // fill the
    state.failedTasks =
        state.tasks!.where((t) => (t.status == Status.failed)).toList();
    // full the to be print on main screen
    state.PandOP = state.tasks!
        .where((e) =>
            (e.status == Status.onProgress || e.status == Status.planned))
        .toList();

    // لي بنسيف هناهو اي التغير اللي عملناه علشان نعمل سيٌف
    await cache.saveList<Task>('tasks', state.tasks!);
  }

  void setCompleted(Task t) async {
    // A
    emit(HomeState(
        tasks: state.tasks
          ?..forEach((e) {
            if (e == t) {
              e.status = Status.completed;
            }
          }),
        PandOP: state.PandOP?..remove(t),
        completedTasks: state.completedTasks?..add(t)));

    //M
    // t.status = Status.completed;
    await cache.saveList<Task>('tasks', state.tasks!);
    //M
    // emit(state);
  }

  void setFailed(Task t) async {
    // A
    emit(HomeState(
        tasks: state.tasks
          ?..forEach((e) {
            if (e == t) {
              e.status = Status.failed;
            }
          }),
        PandOP: state.PandOP?..remove(t),
        failedTasks: state.failedTasks?..add(t)));

    await cache.saveList<Task>('tasks', state.tasks!);
  }

  // تحت الانشاء
  void RemoveTask(Task t) async {
    // A
    emit(HomeState(
        tasks: state.tasks?..remove(t),
        PandOP: state.PandOP?..remove(t),
        completedTasks: state.completedTasks?..remove(t),
        failedTasks: state.failedTasks?..remove(t)));

    await cache.saveList<Task>('tasks', state.tasks!);
  }
}
