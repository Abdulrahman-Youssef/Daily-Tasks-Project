
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/models/task.dart';
import 'package:untitled1/services/cache_service.dart';
import 'new_task_dialog.dart';

class HomeState {
  // state vaiables

// i think we have to put here the list that the changes will be on it *with value
  List<Task>? tasks ;
  int lastId = 0;
}

// class LoadingHomeState extends HomeState{}
// class TasksHomeState extends HomeState{}


// bloc?
class HomeCubit extends Cubit<HomeState>{
  HomeCubit():super(HomeState());

  final cache = CacheService();

  void init(){
    cache.init().then((_) => afterInit());
  }


  Future<void> addNewTask(BuildContext context) async {
    var task = await showDialog(
        context: context, builder: (context) => NewTaskDialog());

    if (task != null) {
      state.tasks!.add(task);
      cache.saveList('tasks', state.tasks!);
      state.lastId++;
    }

    emit(state);
  }

  Future<void> afterInit() async {
      state.tasks = cache.getList('tasks', () => Task.empty()) ?? [];
      List<Task> failedTasks = state.tasks!
          .where((t) =>
      (t.status == Status.planned || t.status == Status.onProgress) &&
          t.dueTime.isBefore(DateTime.now()))
          .toList();
      failedTasks.forEach((t) => t.status = Status.failed);

      await cache.saveList<Task>('tasks', state.tasks!);

    emit(state);
  }

  void setCompleted(Task t) async {
    t.status = Status.completed;
    await cache.saveList<Task>('tasks', state.tasks!);
    //
    emit(state);
  }

}