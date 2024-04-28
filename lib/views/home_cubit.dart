import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/models/task.dart';
import 'package:untitled1/services/cache_service.dart';
import 'new_task_dialog.dart';

class HomeState {
  List<Task>? tasks;
  int lastId = 0;
// A
  HomeState({this.tasks, this.lastId = 0});
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

    emit(HomeState(tasks: state.tasks!..add(task)));
    cache.saveList('tasks', state.tasks!);
    state.lastId + 1;
  }

  Future<void> afterInit() async {
    // state.tasks = cache.getList('tasks', () => Task.empty()) ?? [];

    emit(HomeState(tasks: cache.getList('tasks', () => Task.empty()) ?? []));
    // تحت الانشاء
    // List<Task> failedTasks = state.tasks!
    //     .where((t) =>
    // (t.status == Status.planned || t.status == Status.onProgress) &&
    //     t.dueTime.isBefore(DateTime.now()))
    //     .toList();
    // failedTasks.forEach((t) => t.status = Status.failed);

    await cache.saveList<Task>('tasks', state.tasks!);

    emit(state);
  }

  void setCompleted(Task t) async {
    // A
    emit(HomeState(
        tasks: state.tasks
          ?..forEach((e) {
            if (e == t) {
              e.status = Status.completed;
            }
          })));
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
          })));

    await cache.saveList<Task>('tasks', state.tasks!);
    //M
    // emit(state);
  }

  // تحت الانشاء
  void RemoveTask(Task t) async {
    // A
    emit(HomeState(tasks: state.tasks?..remove(t)));

    await cache.saveList<Task>('tasks', state.tasks!);
    //M
    // emit(state);
  }
}
