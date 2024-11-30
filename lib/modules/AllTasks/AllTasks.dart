import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_project/layout/cubit/cubit.dart';
import 'package:maids_project/layout/cubit/states.dart';
import 'package:maids_project/shared/components/Localization/Localization.dart';
import 'package:maids_project/shared/components/app_components.dart';
import 'package:maids_project/shared/components/components.dart';
import 'package:maids_project/shared/components/constants.dart';

class AllTasks extends StatefulWidget {
  const AllTasks({super.key});

  @override
  State<AllTasks> createState() => _AllTasksState();
}

class _AllTasksState extends State<AllTasks> {

  //Scroll Controller & listener for Lazy Loading
  ScrollController scrollController= ScrollController();

  @override
  void initState() {
    super.initState();

    AppCubit cubit = AppCubit.get(context);

    scrollController.addListener(()
    {
      _onScroll(cubit);
    });

    if(cubit.allTodos ==null)
    {
      cubit.getAllTodos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit = AppCubit.get(context);
        cubit.allTodos?.todos.sort((a,b)=>a!.id!.compareTo(b!.id!));

        return ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              physics: const BouncingScrollPhysics(),
              dragDevices: dragDevices,
            ),
            child: RefreshIndicator(
              onRefresh: ()async
              {
                cubit.getAllTodos();
              },

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  if(state is AppGetAllTodosLoadingState)
                    Column(
                      children: [
                        defaultLinearProgressIndicator(context: context),
                        const SizedBox(height: 15,),
                      ],
                    ),

                  Text(
                    Localization.translate('all_tasks'),
                    style: headlineStyleBuilder(),
                  ),

                  const SizedBox(height: 10,),

                  ConditionalBuilder  (
                      condition: cubit.allTodos !=null,
                      builder: (context)=>Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context,index)=>taskItemBuilder(context: context, cubit:cubit, todo: cubit.allTodos!.todos[index]!, isAllTasks: true),
                          separatorBuilder: (context,index)=>const SizedBox(height: 15,),
                          itemCount: cubit.allTodos!.todos.length,
                        ),
                      ),
                      fallback: (context)=>const SizedBox(height: 1,),
                  ),
                ],
              ),
            ),
        );
      },
    );
  }

  ///onScroll Function for to get next to-do items
  void _onScroll(AppCubit cubit)
  {
    //Will Scroll Only and Only if: Got to the end of the list
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent)
    {
      if(cubit.allTodos?.pagination?.limit !=null && cubit.allTodos!.pagination!.limit! > 0)
      {
        debugPrint('paginating next todos...');
        cubit.getAllTodos(
            limit: cubit.allTodos?.pagination?.limit?.toInt(),
            skip: cubit.allTodos?.pagination?.skip?.toInt(),
            isNextTodos: true);
      }

    }
  }
}
