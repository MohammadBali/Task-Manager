
import 'package:maids_project/models/TodoModel/TodoModel.dart';
import 'package:maids_project/modules/Todos/EditTodo/editTodo.dart';
import 'Imports/default_imports.dart';

/// Task Item Builder
/// * [context] Current BuildContext.
/// * [to-do] TodoModel, Model to be built.
/// Returns [Widget]
Widget taskItemBuilder({required BuildContext context, required TodoModel todo, required AppCubit cubit, bool isAllTasks=false})
{
  return Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text('${todo.todo}'),
          subtitle: Text('${Localization.translate('task_status')} ${todo.completed}'),

          leading: Text('${todo.id}'),
          trailing: IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outlined, size: 20, color: Colors.redAccent,),
            onPressed: ()
            {
              isAllTasks
              ?cubit.deleteTaskAllTodos(todo.id)
              :cubit.deleteTaskMyTodos(todo.id);
            },
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children:
          [
            defaultButton(
              onPressed: todo.completed !=true
                ?null
                :()
                {
                  cubit.finishTask(todo);
                },
              message: Localization.translate('finish_task'),
              type: ButtonType.text


            ),


            defaultButton(
                onPressed: ()
                {
                  navigateTo(context, EditTodo(todo: todo, isFromAllTasks: isAllTasks,));
                },
                message: Localization.translate('edit_task'),
                type: ButtonType.text
            ),
          ],
        ),
      ],
    ),
  );
}