import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

Widget defaultButton(
        {@required Function function,
        @required String text,
        double width = double.infinity,
        double height = 40,
        Color color = Colors.blue,
        double radius = 0.0,
        bool isUpperCase = true}) =>
    Container(
      width: width,
      height: height,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,
      ),
    );

Widget defaultFormField({
  @required TextEditingController controller,
  @required Function validate,
  Function onSubmit,
  Function onChange,
  Function onTap,
  Function suffixPressed,
  @required String label,
  @required IconData prefix,
  @required TextInputType type,
  IconData suffix,
  bool isSuffix,
  bool isPassword = false,
}) =>
    TextFormField(
      controller: controller,
      validator: validate,
      keyboardType: type,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: IconButton(
          icon: Icon(suffix),
          onPressed: suffixPressed,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      onTap: onTap,
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 8,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 10.0,
                  top: 8.0,
                  bottom: 8.0,
                ),
                child: CircleAvatar(
                  radius: 40,
                  child: Text("${model['time']}"),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${model['name']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${model['date']}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  AppCubit.getCubit(context)
                      .updateDatabase(status: 'done', id: model['id']);
                },
                icon: Image.asset('assets/icons/done_task.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    AppCubit.getCubit(context)
                        .updateDatabase(status: 'archived', id: model['id']);
                  },
                  icon: Image.asset('assets/icons/archived.png'),
                ),
              ),
            ],
          ),
        ),
      ),
      onDismissed: (direction) {
        AppCubit.getCubit(context).deleteDatabase(id: model['id']);
      },
    );

Widget buildTasks({
  @required List<Map> tasks,
}) =>
    ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsetsDirectional.only(start: 20.0, end: 20.0),
                child: Container(
                  color: Colors.grey[300],
                  width: double.infinity,
                  height: 1.0,
                ),
              ),
          itemCount: tasks.length),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/todo.png',
              scale: 6,
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "No Tasks yet, Please add some tasks and be ready..!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );

Widget buildDialog({
  @required String text,
  TextStyle style,
}) {
  return Padding(
    padding: const EdgeInsets.all(14.0),
    child: Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.purple),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
