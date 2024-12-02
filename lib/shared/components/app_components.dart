
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:maids_project/models/TodoModel/TodoModel.dart';
import 'package:maids_project/modules/Todos/EditTodo/editTodo.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:string_extensions/string_extensions.dart';
import 'Imports/default_imports.dart';

/// Task Item Builder
/// * [context] Current BuildContext.
/// * [to-do] TodoModel, Model to be built.
/// Returns [Widget]
Widget taskItemBuilder({
  required BuildContext context, required TodoModel todo,
  required AppCubit cubit, bool isAllTasks=false,
  bool showCompleted=true,
  List<GlobalKey>? keys,
})
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

    child: ConditionalBuilder(
      condition: keys !=null && keys.isNotEmpty,
      builder: (context)=>ShowCaseView(
          globalKey: keys![0],
          title: Localization.translate('delete_item_title_scv'),
          description: Localization.translate('delete_item_secondary_scv'),
          cubit: cubit,
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
      ),
      fallback: (context)=>Card(
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
    ),
  );
}

//---------------------------------------------------------

///Check if it's this cache first launch so it shows the Tutorial
/// * [cacheName] The cache value name
/// * Returns [bool] depending on what's stored in the cache preferences
Future<bool> isFirstLaunch(String cacheName) async{
  bool isFirstLaunch = CacheHelper.getData(key: cacheName) ?? true;
  if(isFirstLaunch) {
    CacheHelper.putBoolean(key: cacheName, value: false);
  }

  return isFirstLaunch;
}

//---------------------------------------------------------

///Show Case View Widget Builder
/// * [globalKey] The Case Key, Unique
/// * [title] ShowCase Title
/// * [description] ShowCase Description
/// * [child] the Widget to refer to
/// * [cubit] AppCubit Instance
class ShowCaseView extends StatelessWidget {
  const ShowCaseView(
      {super.key,
        required this.globalKey,
        required this.title,
        required this.description,
        required this.child,
        required this.cubit,
        this.isNotAnimated=false,
        this.shapeBorder = const CircleBorder()});

  final GlobalKey globalKey;
  final String title;
  final String description;
  final Widget child;
  final ShapeBorder shapeBorder;
  final bool isNotAnimated;
  final AppCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: globalKey,
      title: title,
      description: description,
      targetShapeBorder: shapeBorder,
      disableMovingAnimation: true,
      disableScaleAnimation: false,
      tooltipPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      descriptionAlignment: TextAlign.left,
      titleTextStyle: TextStyle(
          fontSize: 18,
          color: cubit.isDarkTheme? darkColorScheme.primary : lightColorScheme.secondary,
          fontWeight: FontWeight.w500,
      ),
      descTextStyle: const TextStyle(
          fontSize: 14,
      ),
      tooltipBackgroundColor: cubit.isDarkTheme? darkColorScheme.surfaceContainerLow : lightColorScheme.surfaceContainerLow,
      child: child,

    );
  }
}