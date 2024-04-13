import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:task_management/src/common_widgets/async_value_widget.dart';
import 'package:task_management/src/common_widgets/empty_placeholder_widget.dart';
import 'package:task_management/src/features/task/data/task_repository.dart';
import 'package:task_management/src/features/task/domain/task.dart';
import 'package:task_management/src/features/task/presentation/task_controller.dart';
import 'package:task_management/src/routing/app_router.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskList = ref.watch(taskControllerProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Tasks'),
      ),
      body: AsyncValueWidget<List<AppTask>>(
          value: taskList,
          data: (tasks) => tasks.isEmpty
              ? const EmptyPlaceholderWidget(message: 'No Tasks')
              : ReorderableListView.builder(
                  itemCount: tasks.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Slidable(
                      key: ValueKey(index),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.2,
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              ref
                                  .watch(taskControllerProvider.notifier)
                                  .removeTask(tasks[index]);
                            },
                            icon: Icons.close,
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          )
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          context.goNamed(AppRoute.newTask.name,
                              pathParameters: {'id': task.id.toString()});
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(task.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(task.description),
                                Row(
                                  children: [
                                    const Icon(Icons.timer, size: 30),
                                    Text(DateFormat('dd/MM/yyyy hh:mm')
                                        .format(task.dueDate))
                                  ],
                                )
                              ],
                            ),
                            trailing: const Icon(Icons.menu),
                          ),
                        ),
                      ),
                    );
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    // setState(() {
                    //   if (newIndex > oldIndex) {
                    //     newIndex--;
                    //   }
                    //   debugPrint('$oldIndex => $newIndex');
                    //   final item = items.removeAt(oldIndex);

                    //   items.insert(newIndex, item);
                    // });
                  },
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(AppRoute.newTask.name, pathParameters: {'id': 'new'});
        },
        tooltip: 'Add new task',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
