
import 'package:maids_project/models/TodoModel/TodoModel.dart';
import 'package:maids_project/modules/Todos/EditTodo/editTodo.dart';
import 'package:string_extensions/string_extensions.dart';
import 'Imports/default_imports.dart';

/// Task Item Builder
/// * [context] Current BuildContext.
/// * [to-do] TodoModel, Model to be built.
/// Returns [Widget]
Widget taskItemBuilder({required BuildContext context, required TodoModel todo, required AppCubit cubit, bool isAllTasks=false, bool showCompleted=true})
{
  return Dismissible(
    key: Key(todo.id.toString()),

    onDismissed: (direction)
    {
      isAllTasks
          ?cubit.deleteTaskAllTodos(todo.id)
          :cubit.deleteTaskMyTodos(todo.id);

      snackBarBuilder(context:context, message: Localization.translate('remove_an_item_swap'));
    },

    background: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.red.shade400,
      ),
    ),

    confirmDismiss: (direction)
    {
      return showDialog(
          context: context,
          builder: (dialogContext)
          {
            return defaultAlertDialog(
              context: dialogContext,
              title: Localization.translate('delete_item'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children:
                  [
                    Text(Localization.translate('delete_item_secondary')),

                    const SizedBox(height: 5,),

                    Row(
                      children:
                      [
                        TextButton(
                            onPressed: ()=>Navigator.of(dialogContext).pop(true), //Navigator.of(context).pop(true),
                            child: Text(Localization.translate('exit_app_yes'))
                        ),

                        const Spacer(),

                        TextButton(
                          onPressed: ()=> Navigator.of(dialogContext).pop(false),
                          child: Text(Localization.translate('exit_app_no')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
      );
    },

    child: Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              '${todo.todo}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: showCompleted? Text('${Localization.translate('task_status')} ${todo.completed.toString().capitalize}') : null,

            leading: Text('${todo.id}'),

          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children:
            [
              defaultButton(
                  onPressed: ()
                  {
                    navigateTo(context, EditTodo(todo: todo, isFromAllTasks: isAllTasks,));
                  },
                  message: Localization.translate('edit_task'),
                  type: ButtonType.text
              ),

              defaultButton(
                  onPressed: todo.completed ==true
                      ?null
                      :()
                  {
                    cubit.finishTask(todo);
                  },
                  message: Localization.translate('finish_task'),
                  type: ButtonType.text
              ),
            ],
          ),
        ],
      ),
    ),
  );
}