import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:task_management/src/common_widgets/async_value_widget.dart';
import 'package:task_management/src/common_widgets/custom_text_field.dart';
import 'package:task_management/src/common_widgets/primary_button.dart';
import 'package:task_management/src/constant/app_sizes.dart';
import 'package:task_management/src/features/task/application/task_service.dart';
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
  late DateTime _defaultDateTime;
  bool showTimePicker = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Task'),
          backgroundColor: Colors.purple,
        ),
        body: SingleChildScrollView(
          child: Consumer(
            builder: (BuildContext context, WidgetRef ref, _) {
              final taskListValue = ref.watch(taskListFutureProvider);
              return AsyncValueWidget(
                value: taskListValue,
                data: (tasks) {
                  if (widget.id != null) {
                    final taskValue =
                        ref.watch(taskProvider(tasks, widget.id!)).value;

                    titleController.text = taskValue?.title ?? '';
                    descriptionController.text = taskValue?.description ?? '';
                    _defaultDateTime = taskValue?.dueDate ?? DateTime.now();
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
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showTimePicker = !showTimePicker;
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.timer,
                                ),
                                const SizedBox(width: 8.0),
                                Flexible(
                                    child: Text(
                                        widget.id != null
                                            ? DateFormat('dd/MM/yyyy hh:mm:aa')
                                                .format(_defaultDateTime)
                                            : 'Set Due Date',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge))
                              ],
                            ),
                          ),
                          gapH12,
                          Offstage(
                            offstage: showTimePicker,
                            child: SizedBox(
                              height: 100,
                              child: CupertinoDatePicker(
                                // key: UniqueKey(), //only once show
                                mode: CupertinoDatePickerMode.dateAndTime,
                                initialDateTime: _selectedDate,
                                onDateTimeChanged: (DateTime newDate) {
                                  setState(() {
                                    _selectedDate = newDate;
                                  });
                                },
                              ),
                            ),
                          ),
                          gapH32,
                          PrimaryButton(
                            text: widget.id != null ? 'Update' : 'Create',
                            onPressed: () {
                              var task = AppTask(
                                  id: widget.id ?? tasks.length + 1,
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  dueDate: _selectedDate,
                                  isDone: false);

                              ref
                                  .watch(taskControllerProvider.notifier)
                                  .addOrUpdateTask(task);
                              context.pop();
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}
