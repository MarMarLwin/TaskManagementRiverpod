import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:task_management/src/common_widgets/custom_text_field.dart';
import 'package:task_management/src/common_widgets/primary_button.dart';
import 'package:task_management/src/constant/app_sizes.dart';
import 'package:task_management/src/constant/test_task.dart';
import 'package:task_management/src/features/task/data/task_repository.dart';
import 'package:task_management/src/features/task/domain/task.dart';
import 'package:task_management/src/features/task/presentation/task_controller.dart';

class CreateNewTask extends StatefulWidget {
  final int? id;
  const CreateNewTask({
    super.key,
    this.id,
  });

  @override
  State<StatefulWidget> createState() => _CreateNewTaskState();
}

class _CreateNewTaskState extends State<CreateNewTask> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Task'),
        ),
        body: Consumer(
          builder: (BuildContext context, WidgetRef ref, _) {
            if (widget.id != null) {
              final taskValue = ref.watch(taskProvider(widget.id!)).value;
              titleController.text = taskValue?.title ?? '';
              descriptionController.text = taskValue?.description ?? '';
            }
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  children: [
                    CustomTextFormField(
                      title: 'Title',
                      color: Colors.purple,
                      controller: titleController,
                      validator: (value) {
                        if (value == '') {
                          return "Title field is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      title: 'Description',
                      color: Colors.purple,
                      controller: descriptionController,
                      validator: (value) {
                        if (value == '') {
                          return "Description field is required";
                        }
                        return null;
                      },
                    ),
                    gapH12,
                    SizedBox(
                      height: 100,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.dateAndTime,
                        initialDateTime: _selectedDate,
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() {
                            _selectedDate = newDate;
                          });
                        },
                      ),
                    ),
                    gapH32,
                    PrimaryButton(
                      text: widget.id != null ? 'Update' : 'Create',
                      onPressed: () {
                        var task = AppTask(
                          id: widget.id ?? kTestTasks.length,
                          title: titleController.text,
                          description: descriptionController.text,
                          dueDate: _selectedDate,
                        );
                        if (widget.id != null) {
                          ref
                              .watch(taskControllerProvider.notifier)
                              .updateTask(task);
                        } else {
                          ref
                              .watch(taskControllerProvider.notifier)
                              .addTask(task);
                        }

                        context.pop();
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
