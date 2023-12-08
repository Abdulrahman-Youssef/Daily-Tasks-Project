import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/models/task.dart';
import 'package:untitled1/services/cache_service.dart';
import 'package:untitled1/views/new_task_dialog.dart';
import 'package:custom_accordion/custom_accordion.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: [
              Row(
                children: [
                  Container(
                      width: 70,
                      height: 150,
                      child: Image.network(
                          "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg")),
                  Expanded(
                    child: ListTile(
                      title: Text('abdulrahman'),
                      subtitle: Text('abdooyossef@gamil.com'),
                    ),
                  )
                ],
              ),
              InkWell(
                onTap: (){},
                child: ListTile(
                  title: Text('home'),
                  leading: Icon(Icons.home),
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: ListTile(
                  title: Text('account'),
                  leading: Icon(Icons.account_balance),
                ),
              ),
              ListTile(
                title: Text('tasks history'),
                leading: Icon(Icons.content_paste_search),
              ),
              ListTile(
                title: Text('about us'),
                leading: Icon(Icons.groups),
              ),
              ListTile(
                title: Text('countact us'),
                leading: Icon(Icons.phone_iphone_rounded),
              ),
              ListTile(
                title: Text('sign out'),
                leading: Icon(Icons.output_rounded),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Tasks'),
        actions: [],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: tasks == null
            ? RefreshProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: tasks!
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
                                onPressed: () => setCompleted(t),
                                child: Text('complete'),
                              ),
                            ],
                          ),
                        ))
                    .toList()),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () => addNewTask(context),
        tooltip: 'New Task',
        child: const Icon(CupertinoIcons.add_circled),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // state vaiables
  List<Task>? tasks = null;
  int lastId = 0;
  //
  final cache = CacheService();

  @override
  void initState() {
    super.initState();
    cache.init().then((_) => afterInit());
  }

  Future<void> addNewTask(BuildContext context) async {
    var task = await showDialog(
        context: context, builder: (context) => NewTaskDialog());

    if (task != null) {
      tasks!.add(task);
      cache.saveList('tasks', tasks!);
    }

    lastId++;
    setState(() {});
  }

  void afterInit() {
    setState(() async {
      tasks = cache.getList('tasks', () => Task.empty()) ?? [];
      List<Task> failedTasks = tasks!
          .where((t) =>
              (t.status == Status.planned || t.status == Status.onProgress) &&
              t.dueTime.isBefore(DateTime.now()))
          .toList();
      failedTasks.forEach((t) => t.status = Status.failed);

      await cache.saveList<Task>('tasks', tasks!);

      setState(() {});
    });
  }

  setCompleted(Task t) async {
    t.status = Status.completed;
    await cache.saveList<Task>('tasks', tasks!);
    //
    setState(() {});
  }
}
