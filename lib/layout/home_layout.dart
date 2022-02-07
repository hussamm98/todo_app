import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/components/component.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class HomeLayoutScreen extends StatelessWidget {
  HomeLayoutScreen({Key key}) : super(key: key);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, states) {
          if (states is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, states) {
          AppCubit cubit = AppCubit.getCubit(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("About The App!" , style: TextStyle(fontWeight: FontWeight.bold),),
                          content: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: Colors.grey[500],
                                ),
                                buildDialog(text: 'Lets do some tasks!',),
                                buildDialog(text: 'Press on the right-bottom icon to add a new task.',),
                                buildDialog(text: 'Press on the check button if you did it.',),
                                buildDialog(text: 'Press on archive button to archive it.',),
                                buildDialog(text: 'Swipe in opposite direction to Delete a task.',),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.help_outline_rounded,
                      size: 30,
                    ))
              ],
            ),
            body: ConditionalBuilder(
              builder: (context) => cubit.screen[cubit.currentIndex],
              condition: states is! AppGetDatabaseLoadingState,
              fallback: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState.validate()) {
                    cubit.insertToDatabase(
                        name: titleController.text,
                        date: dateController.text,
                        time: timeController.text);
                  }
                } else {
                  scaffoldKey.currentState
                      .showBottomSheet(
                          (context) => Container(
                                padding: const EdgeInsets.all(20.0),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadiusDirectional.only(
                                    topEnd: Radius.circular(12.0),
                                    topStart: Radius.circular(12.0),
                                  ),
                                ),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultFormField(
                                          controller: titleController,
                                          validate: (String value) {
                                            if (value.isEmpty) {
                                              return 'Task Name Must be Not Empty';
                                            }
                                          },
                                          label: 'Task Title',
                                          prefix: Icons.title_rounded,
                                          type: TextInputType.text),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      defaultFormField(
                                          controller: timeController,
                                          validate: (String value) {
                                            if (value.isEmpty) {
                                              return 'Please Enter The Task Time';
                                            }
                                          },
                                          label: 'Task Time',
                                          prefix: Icons.watch_later_outlined,
                                          type: TextInputType.datetime,
                                          onTap: () {
                                            showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now())
                                                .then((value) {
                                              timeController.text = value
                                                  .format(context)
                                                  .toString();
                                            });
                                          }),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      defaultFormField(
                                        controller: dateController,
                                        validate: (String value) {
                                          if (value.isEmpty) {
                                            return 'Please Enter The Task Date';
                                          }
                                        },
                                        label: 'Task Date',
                                        prefix: Icons.calendar_today_outlined,
                                        type: TextInputType.datetime,
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2030),
                                          ).then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value)
                                                    .toString();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          elevation: 20.0)
                      .closed
                      .then((value) {
                    cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheet(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeScreen(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/icons/todo0.png',
                      scale: 3,
                    ),
                    label: "New"),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/icons/done_task.png',
                      scale: 16,
                    ),
                    label: "Done"),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/icons/archived.png',
                      scale: 16,
                    ),
                    label: "Archived"),
              ],
            ),
          );
        },
      ),
    );
  }
}
