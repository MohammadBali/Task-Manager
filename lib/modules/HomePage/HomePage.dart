import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:maids_project/shared/components/Imports/default_imports.dart';
import 'package:maids_project/shared/components/app_components.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
      listener: (context,state)
      {
        if(state is AppGetUserTodosSuccessState)
        {
          snackBarBuilder(message: Localization.translate('success'), context: context);
        }
        if(state is AppGetUserTodosErrorState)
        {
          snackBarBuilder(message: state.message, context: context);
        }

        if(state is AppInsertDatabaseSuccessState)
        {
          snackBarBuilder(message: Localization.translate('success'), context: context);
        }

        if(state is AppInsertDatabaseErrorState)
        {
          snackBarBuilder(message: state.message, context: context);
        }
      },
      builder: (context,state)
      {
        var cubit = AppCubit.get(context);
        var completedTodos = cubit.userTodos?.todos.where((item)=>item?.completed ==true).toList();
        var nonCompletedTodos = cubit.userTodos?.todos.where((item)=>item?.completed ==false).toList();

        return Builder(
          builder: (BuildContext context) =>ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              physics: const BouncingScrollPhysics(),
              dragDevices: dragDevices,
            ),
            child: RefreshIndicator(
              onRefresh: ()async
              {
                cubit.getUserTodos(getFromDB: true);
              },

              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [
                    if(state is AppGetUserTodosLoadingState)
                      Column(
                        children: [
                          defaultLinearProgressIndicator(context: context),
                          const SizedBox(height: 15,),
                        ],
                      ),
                
                    Visibility(
                      visible: completedTodos !=null && completedTodos.isNotEmpty,
                      child: Text(
                        Localization.translate('completed_tasks'),
                        style: headlineStyleBuilder(),
                      ),
                    ),
                
                    Visibility(
                      visible: completedTodos !=null && completedTodos.isNotEmpty,
                      child: const SizedBox(height: 10,))
                    ,
                
                    ConditionalBuilder(
                        condition: cubit.userTodos !=null,
                        builder: (context)=>ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context,index)=>taskItemBuilder(context: context, cubit:cubit, todo: completedTodos[index]!, showCompleted: false),
                          separatorBuilder: (context,index)=>const SizedBox(height: 15,),
                          itemCount: completedTodos!.length,
                        ),
                        fallback: (context)=>defaultLinearProgressIndicator(context: context)
                    ),
                
                    const SizedBox(height: 25,),
                
                    Visibility(
                      visible:  nonCompletedTodos !=null &&  nonCompletedTodos.isNotEmpty,
                      child: Text(
                        Localization.translate('non_completed_tasks'),
                        style: headlineStyleBuilder(),
                      ),
                    ),
                
                    const SizedBox(height: 10,),
                
                    ConditionalBuilder(
                        condition: cubit.userTodos !=null,
                        builder: (context)=>ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context,index)=>taskItemBuilder(context: context, cubit:cubit, todo: nonCompletedTodos[index]!, showCompleted: false),
                          separatorBuilder: (context,index)=>const SizedBox(height: 15,),
                          itemCount: nonCompletedTodos!.length,
                        ),
                        fallback: (context)=>defaultLinearProgressIndicator(context: context)
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

  ///onScroll Function for to get next to-do items
  void _onScroll(AppCubit cubit)
  {
    //Will Scroll Only and Only if: Got to the end of the list
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent)
    {
      if(cubit.userTodos?.pagination?.limit !=null && cubit.userTodos!.pagination!.limit! > 0)
      {
        debugPrint('paginating next user todos...');
        cubit.getUserTodos(
            limit: cubit.userTodos?.pagination?.limit?.toInt(),
            skip: cubit.userTodos?.pagination?.skip?.toInt(),
            isNextTodos: true);
      }

    }
  }

}
