
import 'package:maids_project/models/TodoModel/TodoModel.dart';
import 'package:maids_project/modules/Todos/EditTodo/editTodo.dart';
import 'Imports/default_imports.dart';

/// Task Item Builder
/// * [context] Current BuildContext.
/// * [todo] TodoModel, Model to be built.
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
            TextButton(
              onPressed: ()
              {
                cubit.finishTask(todo);
              },
              child: Text(Localization.translate('finish_task')),


            ),


            TextButton(
                onPressed: ()
                {
                  navigateTo(context, EditTodo(todo: todo, isFromAllTasks: isAllTasks,));
                },
                child: Text(Localization.translate('edit_task'))
            ),
          ],
        ),
      ],
    ),
  );
}