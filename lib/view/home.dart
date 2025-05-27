import 'package:flutter/material.dart';
import 'package:flutter_to_do/providers/tasks_provider.dart';
import 'package:flutter_to_do/utils/constants.dart';
import 'package:flutter_to_do/view/add_new_task.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.appbarColor,
        body: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "To Do App",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                    child:
                        provider.isLoading
                            ? ListView.builder(
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              },
                            )
                            : provider.tasks.isEmpty
                            ? Column(
                              children: [
                                const SizedBox(height: 80),
                                Image.asset(
                                  "assets/images/nodata.png",
                                  height: 120,
                                ),
                                SizedBox(height: 20),
                                Text("No tasks found"),
                              ],
                            )
                            : ListView.builder(
                              itemCount: provider.tasks.length,
                              itemBuilder: (context, index) {
                                final task = provider.tasks[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        task['isCompleted'] == true
                                            ? Colors.grey[100]
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    task['title'],
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Icon(
                                                    task['isCompleted'] == true
                                                        ? Icons
                                                            .check_circle_outline
                                                        : Icons.info_outline,
                                                    size: 20,
                                                    color:
                                                        task['isCompleted'] ==
                                                                true
                                                            ? Colors.green
                                                            : Colors.orange,
                                                  ),
                                                  const Spacer(),
                                                  PopupMenuButton(
                                                    padding: EdgeInsets.zero,
                                                    icon: const Icon(
                                                      Icons.more_vert_outlined,
                                                      size: 20,
                                                    ),
                                                    color: Colors.white,
                                                    itemBuilder:
                                                        (context) => [
                                                          if (task['isCompleted'] !=
                                                              true) ...[
                                                            PopupMenuItem(
                                                              child: Row(
                                                                children: const [
                                                                  Icon(
                                                                    Icons
                                                                        .edit_outlined,
                                                                    size: 15,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    'Edit',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              onTap: () {
                                                                Future.delayed(
                                                                  const Duration(
                                                                    seconds: 0,
                                                                  ),
                                                                  () => Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (
                                                                            context,
                                                                          ) => AddnewTask(
                                                                            task:
                                                                                task,
                                                                            index:
                                                                                index,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            PopupMenuItem(
                                                              child: Row(
                                                                children: const [
                                                                  Icon(
                                                                    Icons
                                                                        .check_circle_outline,
                                                                    size: 20,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    'Mark as Complete',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              onTap: () {
                                                                provider
                                                                    .toggleTaskCompletion(
                                                                      index,
                                                                    );
                                                              },
                                                            ),
                                                          ],
                                                          PopupMenuItem(
                                                            child: Row(
                                                              children: const [
                                                                Icon(
                                                                  Icons
                                                                      .delete_outline,
                                                                  size: 20,
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Text(
                                                                  'Delete',
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            onTap: () {
                                                              provider
                                                                  .deleteTask(
                                                                    index,
                                                                  );
                                                            },
                                                          ),
                                                        ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "${task['description']}\n${DateTime.parse(task['date']).day} ${_getMonth(DateTime.parse(task['date']).month)} ${DateTime.parse(task['date']).year} - ${task['time']}",
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          foregroundColor: Constants.appbarColor,
          splashColor: Constants.appbarColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddnewTask()),
            );
          },
          backgroundColor: Constants.appbarColor,
          child: Icon(Icons.add, color: Constants.whiteColor, size: 23),
        ),
      ),
    );
  }
}
