import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_project/layout/cubit/cubit.dart';
import 'package:maids_project/layout/cubit/states.dart';
import 'package:maids_project/shared/components/Localization/Localization.dart';
import 'package:maids_project/shared/components/components.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{

  double val = 0.5;
  late TabController tabController;

  @override
  void initState()
  {
    tabController = TabController(length: AppCubit.get(context).tabBarWidgets.length, vsync: this);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
      listener:(context,state){},

      builder:(context,state)
      {
        AppCubit cubit = AppCubit.get(context);
        return Directionality(
          textDirection: appDirectionality(),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title:  Text(Localization.translate('login_title')),

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
              padding: const EdgeInsets.all(18.0),
              child: cubit.tabBarWidgets[cubit.tabBarIndex],
            ),
            floatingActionButton: cubit.tabBarIndex == 0
                ?FloatingActionButton(

                onPressed: ()
                {
                  defaultModalBottomSheet(context: context);
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
