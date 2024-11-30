import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:maids_project/shared/components/Imports/default_imports.dart';
import 'package:maids_project/shared/components/app_components.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
                cubit.getUserTodos();
              },

              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                
                    Text(
                      Localization.translate('completed_tasks'),
                      style: headlineStyleBuilder(),
                    ),
                
                    const SizedBox(height: 10,),
                
                    ConditionalBuilder(
                        condition: cubit.userTodos !=null,
                        builder: (context)=>ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context,index)=>taskItemBuilder(context: context, cubit:cubit, todo: completedTodos[index]!),
                          separatorBuilder: (context,index)=>const SizedBox(height: 15,),
                          itemCount: completedTodos!.length,
                        ),
                        fallback: (context)=>defaultLinearProgressIndicator(context: context)
                    ),
                
                    const SizedBox(height: 25,),
                
                    Text(
                      Localization.translate('non_completed_tasks'),
                      style: headlineStyleBuilder(),
                    ),
                
                    const SizedBox(height: 10,),
                
                    ConditionalBuilder(
                        condition: cubit.userTodos !=null,
                        builder: (context)=>ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context,index)=>taskItemBuilder(context: context, cubit:cubit, todo: nonCompletedTodos[index]!),
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

}
