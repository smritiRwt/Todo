import 'package:flutter/material.dart';
import 'package:flutter_to_do/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_to_do/providers/add_new_task_provider.dart';

class AddnewTask extends StatefulWidget {
  final Map<String, dynamic>? task;
  final int? index;

  const AddnewTask({super.key, this.task, this.index});

  @override
  State<AddnewTask> createState() => _AddnewTaskState();
}

class _AddnewTaskState extends State<AddnewTask> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final taskProvider = Provider.of<AddNewTaskProvider>(
      context,
      listen: false,
    );
    taskProvider.initializeControllers(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<AddNewTaskProvider>(context);
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.appbarColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.task != null ? "EDIT TASK" : "ADD NEW TASK",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: taskProvider.taskTitleController,
                        decoration: InputDecoration(
                          labelText: "Task Title",
                          labelStyle: theme.textTheme.bodySmall,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Please enter a title' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: taskProvider.taskDescriptionController,
                        decoration: InputDecoration(
                          labelText: "Task Description",
                          labelStyle: theme.textTheme.bodySmall,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        maxLines: 3,
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? 'Please enter a description'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: taskProvider.taskDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Task Date",
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            size: 18,
                          ),
                          labelStyle: theme.textTheme.bodySmall,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Please enter date' : null,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          DateTime? picked = await showDatePicker(
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Constants.appbarColor,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            taskProvider.taskDateController.text =
                                picked.toLocal().toString().split(' ')[0];
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: taskProvider.taskTimeController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Task Time",
                          suffixIcon: const Icon(Icons.access_time, size: 18),
                          labelStyle: theme.textTheme.bodySmall,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Please enter time' : null,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          TimeOfDay? picked = await showTimePicker(
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  timePickerTheme: TimePickerThemeData(
                                    dayPeriodTextColor: Constants.appbarColor,
                                    dayPeriodColor:
                                        MaterialStateColor.resolveWith(
                                          (states) =>
                                              states.contains(
                                                    MaterialState.selected,
                                                  )
                                                  ? Constants.appbarColor
                                                      .withOpacity(0.2)
                                                  : Colors.transparent,
                                        ),
                                  ),
                                  colorScheme: const ColorScheme.light(
                                    primary: Constants.appbarColor,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            taskProvider.taskTimeController.text = picked
                                .format(context);
                          }
                        },
                      ),
                      const SizedBox(height: 60),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.appbarColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 32,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await taskProvider.saveTask(
                              context,
                              task: widget.task,
                              index: widget.index,
                            );
                          }
                        },
                        child:
                            taskProvider.isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : Text(
                                  widget.task != null
                                      ? "Update Task"
                                      : "Save Task",
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
