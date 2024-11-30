import 'package:maids_project/models/TodoModel/TodoModel.dart';
import 'package:maids_project/shared/components/Imports/default_imports.dart';
import 'package:string_extensions/string_extensions.dart';

class EditTodo extends StatefulWidget {
  TodoModel todo;
  bool isFromAllTasks;
  EditTodo({super.key, required this.todo, required this.isFromAllTasks});

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {

  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskUserIdController = TextEditingController();
  TextEditingController taskIdController = TextEditingController();
  bool? isCompleted;

  @override
  void initState() {
    super.initState();

    taskNameController.value = TextEditingValue(text: widget.todo.todo ?? 'NAME');
    taskUserIdController.value = TextEditingValue(text: widget.todo.userId.toString());
    taskIdController.value = TextEditingValue(text: widget.todo.id.toString());
    isCompleted = widget.todo.completed;

  }

  @override
  void dispose() {
    taskNameController.dispose();
    taskUserIdController.dispose();
    taskIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          var cubit= AppCubit.get(context);

          return Directionality(
            textDirection: appDirectionality(),
            child: Scaffold(
              appBar: AppBar(
                title: Text(Localization.translate('edit_task')),
              ),
              body: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      Text(
                        Localization.translate('task_details'),
                        style: headlineStyleBuilder(),
                      ),

                      const SizedBox(height: 50,),

                      Text(
                        Localization.translate('task_id'),
                        style: textStyleBuilder(),
                      ),

                      const SizedBox(height: 10,),

                      defaultTextFormField(
                          controller: taskIdController,
                          keyboard: TextInputType.none,
                          label: Localization.translate('task_id'),
                          prefix: Icons.numbers_outlined,
                          validate: (value)=>null,
                          isClickable: false,
                      ),

                      const SizedBox(height: 20,),

                      Text(
                        Localization.translate('task_user_id'),
                        style: textStyleBuilder(),
                      ),

                      const SizedBox(height: 10,),

                      defaultTextFormField(
                        controller: taskUserIdController,
                        keyboard: TextInputType.none,
                        label: Localization.translate('task_user_id'),
                        prefix: Icons.person_outline_sharp,
                        validate: (value)=>null,
                        isClickable: false,
                      ),

                      const SizedBox(height: 20,),

                      Text(
                        Localization.translate('task_name'),
                        style: textStyleBuilder(),
                      ),

                      const SizedBox(height: 10,),

                      defaultTextFormField(
                        controller: taskNameController,
                        keyboard: TextInputType.text,
                        label: Localization.translate('task_name'),
                        prefix: Icons.abc_outlined,
                        validate: (value)
                        {
                          if(value==null || value.isEmpty)
                          {
                            return Localization.translate('empty_value');
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20,),

                      Text(
                        Localization.translate('task_status'),
                        style: textStyleBuilder(),
                      ),

                      const SizedBox(height: 10,),

                      defaultFormField(
                        context: context,
                        dropDownButtonValue: '$isCompleted',
                        onChanged: (value, formFieldState)
                        {
                          setState(() {
                            isCompleted = bool.parse(value!);
                          });
                        },
                        items: ['true','false'].map((String value)
                        {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Text(
                                  value.capitalize,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 25,),

                      Center(
                        child: defaultButton(
                          type: ButtonType.filledTonal,
                          onPressed: ()
                          {
                            widget.todo.todo = taskNameController.value.text;
                            widget.todo.completed = isCompleted;

                            widget.isFromAllTasks
                            ?cubit.alterInAllTodos(widget.todo)
                            :cubit.alterInMyTodos(widget.todo);

                            Navigator.of(context).pop();
                          }
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          );
        },
    );
  }
}
