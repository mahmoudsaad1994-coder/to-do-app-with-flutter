import 'package:get/get.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';

class TaskController extends GetxController {
  //obs to change list to rxlist
  // to can make listen
  final RxList<Task> taskList = <Task>[].obs;

  // هنا بنضيف التاسكات ف الداتابيز
  Future<int> addTask({Task? task}) {
    return DBHelper.insert(task);
  }

  // هنجيب الداتا من الداتابيز و نضيفها ف الليست
  Future<void> getTasks() async {
    // هنجيب الداتا من الداتابيز ونضيفها ف متغير
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    // هنضيف الداتا دفعه واحده فالليست بتاعتنا
    taskList
        .assignAll(tasks.map((taskData) => Task.fromJson(taskData)).toList());
  }

  // delete task form database
  void deleteTask(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }

  // delete All tasks form database
  void deleteAllTasks() async {
    await DBHelper.deleteAll();
    taskList.remove;
    getTasks();
  }

  // update task form database
  void markCompletedTask(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
