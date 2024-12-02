import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_project/layout/cubit/cubit.dart';
import 'package:maids_project/layout/cubit/states.dart';
import 'package:maids_project/shared/components/Localization/Localization.dart';
import 'package:maids_project/shared/components/app_components.dart';
import 'package:maids_project/shared/components/components.dart';
import 'package:maids_project/shared/components/constants.dart';
import 'package:showcaseview/showcaseview.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{

  late TabController tabController;
  var formKey=GlobalKey<FormState>();

  TextEditingController newTodoIdController = TextEditingController();
  TextEditingController newTodoNameController = TextEditingController();

  Timer? _timer;

  //Global keys for ShowCaseView
  final GlobalKey myTasksKey= GlobalKey();
  final GlobalKey settingsKey= GlobalKey();

  @override
  void initState()
  {
    super.initState();

    tabController = TabController(length: AppCubit.get(context).tabBarWidgets.length, vsync: this);

    // Update every minute
    _timer = Timer.periodic(const Duration(minutes: 20), (Timer t)
    {
      AppCubit.get(context).refreshAuthSession();
    });

  }


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
      listener:(context,state)
      {
        if(state is AppRefreshTokenSuccessState)
        {
          snackBarBuilder(context: context, message: Localization.translate('success'));
        }
      },

      builder:(context,state)
      {
        AppCubit cubit = AppCubit.get(context);
        return Directionality(
          textDirection: appDirectionality(),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title:  Text(Localization.translate('appBar_title_home')),

              bottom: defaultTabBar(
                  context: context,
                  controller: tabController,
                  isPrimary: true,
                  tabs:
                  [
                    Tab(
                      icon: const Icon(Icons.folder_open_outlined),

                      text: Localization.translate('my_tasks'),
                    ),

                    Tab(
                      icon: const Icon(Icons.task_outlined),

                      text: Localization.translate('all_tasks'),
                    ),

                    Tab(
                      icon: const Icon(Icons.settings_outlined),

                      text: Localization.translate('settings'),
                    ),
                  ]
              ),
            ),

            body: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 18.0, vertical: 30.0),
              child: cubit.tabBarWidgets[cubit.tabBarIndex],
            ),
            floatingActionButton: cubit.tabBarIndex == 0
                ?FloatingActionButton(

                onPressed: ()
                {
                  defaultModalBottomSheet(
                    context: context,
                    defaultButtonMessage: Localization.translate('submit_button'),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                        [
                          Center(
                            child: Text(
                              Localization.translate('new_task'),
                              style: headlineStyleBuilder(),
                            ),
                          ),

                          const SizedBox(height: 5,),

                          Text(
                            Localization.translate('task_id'),
                            style: textStyleBuilder(),
                          ),

                          const SizedBox(height: 10,),

                          defaultTextFormField(
                            controller: newTodoIdController,
                            keyboard: TextInputType.number,
                            label: Localization.translate('task_id'),
                            prefix: Icons.numbers_outlined,
                            validate: (value)
                            {
                              if(value == null || value.isEmpty)
                              {
                                return Localization.translate('empty_value');
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20,),

                          Text(
                            Localization.translate('task_name'),
                            style: textStyleBuilder(),
                          ),

                          const SizedBox(height: 10,),

                          defaultTextFormField(
                            controller: newTodoNameController,
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
                        ],
                      ),
                    ),
                    onPressed: ()
                    {
                      if(formKey.currentState!.validate())
                      {
                        cubit.insertIntoDatabase(
                            id: int.parse(newTodoIdController.value.text),
                            todo: newTodoNameController.value.text,
                            completed: 'false',
                            type: 'user',
                            userId: AppCubit.userData?.id ?? 0,
                        );

                        newTodoIdController.value = TextEditingValue.empty;
                        newTodoNameController.value = TextEditingValue.empty;
                      }
                    }

                  );
                },
                tooltip: 'Add Task',
                child: const Icon(Icons.add),
            )
                : null,
          ),
        );
      },
    );
  }
}
