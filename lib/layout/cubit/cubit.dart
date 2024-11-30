import 'dart:io';
import 'package:maids_project/models/LoginModel/LoginModel.dart';
import 'package:maids_project/models/TodoModel/TodoModel.dart';
import 'package:maids_project/models/UserDataModel/UserDataModel.dart';
import 'package:maids_project/modules/HomePage/HomePage.dart';
import 'package:maids_project/modules/AllTasks/AllTasks.dart';
import 'package:maids_project/modules/Settings/Settings.dart';
import 'package:maids_project/shared/components/Imports/default_imports.dart';
import 'package:maids_project/shared/network/end_points.dart';
import 'package:maids_project/shared/network/remote/main_dio_helper.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit(): super(AppInitialState());

  static AppCubit get(context)=> BlocProvider.of(context);

  ///DarkTheme Boolean
  bool isDarkTheme=false;

  ///Change Theme
  void changeTheme({bool? themeFromState})
  {
    if (themeFromState != null) //if a value is sent from main, then use it.. we didn't use CacheHelper because the value has already came from cache, then there is no need to..
        {
      isDarkTheme = themeFromState;
      emit(AppChangeThemeModeState());
    }

    else // else which means that the button of changing the theme has been pressed.
        {
      isDarkTheme = !isDarkTheme;
      CacheHelper.putBoolean(key: 'isDarkTheme', value: isDarkTheme).then((value) //Put the data in the sharedPref and then emit the change.
      {
        emit(AppChangeThemeModeState());
      });
    }
  }

  ///Returns current colorScheme
  ColorScheme currentColorScheme()
  {
    return isDarkTheme? darkColorScheme : lightColorScheme;
  }

  ///Current Language Code
  static String? language='';

  ///Change Language
  void changeLanguage(String lang) async
  {
    language=lang;
    emit(AppChangeLanguageState());
  }

  //TAB BAR

  ///TabBar Current Index
  int tabBarIndex=0;

  ///Specify the tabBar Widgets
  List<Widget> tabBarWidgets=
  [
    HomePage(),
    const AllTasks(),
    const Settings(),
  ];

  ///Alter the Current TabBar
  void changeTabBar(int index)
  {
    tabBarIndex = index;
    emit(AppChangeTabBar());
  }

  //--------------------------------------------------\\

  //USER APIS

  static UserData? userData;
  ///Get User Data by Token through API
  void getUserData()
  {
    if (token !='')
    {
      debugPrint('In getting user data');

      emit(AppGetUserDataLoadingState());

      MainDioHelper.getData(
        url: userDataByToken,
        token: token,
      ).then((value)
      {
        debugPrint('Got User Data...');

        userData= UserData.fromJson(value.data);

        emit(AppGetUserDataSuccessState());

        getUserTodos();
      }).catchError((error, stackTrace)
      {
        debugPrint('ERROR WHILE GETTING USER DATA, ${error.toString()}');
        emit(AppGetUserDataErrorState());

      });
    }
  }

  ///Get User Data by passing the loginModel
  void getUserDataByLoginModel({required LoginModel model})
  {
    debugPrint('In getting user data by loginModel');

    emit(AppGetUserDataLoadingState());

    try
    {
      userData= UserData.fromLoginModel(model);
      emit(AppGetUserDataSuccessState());

      getUserTodos();
    }
    catch(error)
    {
      debugPrint('ERROR WHILE SETTING USER DATA BY LOGIN-MODEL, ${error.toString()}');
      emit(AppGetUserDataErrorState());

    }
  }

  ///Refresh Authentication Token Lifetime
  void refreshAuthSession()
  {
    emit(AppRefreshTokenLoadingState());

    debugPrint('In refreshAuthSession...');

    MainDioHelper.postData(
        url: refreshAuth,
        data: {'refreshToken':refreshToken,},

    ).then((value)
    {
      debugPrint('Got refreshData...');

      value.data['refreshToken'] !=null? refreshToken = value.data['refreshToken'] : null;

      value.data['accessToken'] !=null? token = value.data['accessToken'] : null;

      emit(AppRefreshTokenSuccessState());

    }).catchError((error)
    {
      debugPrint('COULD NOT REFRESH AUTH SESSION..., ${error.toString()}');
      emit(AppRefreshTokenErrorState());
    });
  }

  ///Clear Data and Sign out
  Future<void> signOut() async
  {
    token='';
    refreshToken='';

    await CacheHelper.clearData(key: 'token');
    await CacheHelper.clearData(key: 'refresh_token');

    emit(AppSignOutState());

    exit(0);

  }


  //--------------------------------------------------\\

  //TODOS

  TodosModel? userTodos;

  ///Get User Todos
  void getUserTodos()
  {
    if(token!='')
    {
      debugPrint('in getUserTodos...');

      emit(AppGetUserTodosLoadingState());

      MainDioHelper.getData(
        url: '$getTodos/${userData?.id}',
      ).then((value)
      {
        debugPrint('Got This User Todos...');

        userTodos = TodosModel.fromJson(value.data);

        emit(AppGetUserTodosSuccessState());

      }).catchError((error)
      {
        debugPrint('ERROR WHILE GETTING THIS USER TODOS..., ${error.toString()}');
        emit(AppGetUserTodosErrorState(message: 'ERROR WHILE GETTING THIS USER TODOS..., ${error.toString()}'));
      });
    }
  }


  TodosModel? allTodos;
  ///Get All Todos
  void getAllTodos({int? limit, int? skip, bool isNextTodos = false})
  {
    if(token!='')
    {
      debugPrint('in getAllTodos...');

      emit(AppGetAllTodosLoadingState());

      MainDioHelper.getData(
        url: allTodosEndpoint,
        query:
        {
          if(limit!=null) 'limit':limit,
          if(skip!=null) 'skip':skip + (limit ?? 0),
        },
      ).then((value)
      {
        debugPrint('Got All Todos...');

        if(isNextTodos ==true)
        {
          allTodos?.addPagination(value.data);
          allTodos?.addTodos(value.data);
        }

        else
        {
          allTodos = TodosModel.fromJson(value.data);
        }

        emit(AppGetAllTodosSuccessState());

      }).catchError((error)
      {
        debugPrint('ERROR WHILE GETTING ALL TODOS..., ${error.toString()}');
        emit(AppGetAllTodosErrorState(message: 'ERROR WHILE GETTING ALL TODOS..., ${error.toString()}'));
      });
    }
  }

  ///Alter a To-do from [userTodos]
  void alterInMyTodos(TodoModel todo)
  {

    for (var item in userTodos?.todos ?? [])
    {
      if(item.id == todo.id)
      {
        item = todo;
        emit(AppAlterTodoState());
        break;
      }
    }
  }

  ///Finish Model; Set Status to Completed
  void finishTask(TodoModel todo)
  {
    todo.completed=true;
    emit(AppAlterTodoState());
  }

  ///Delete a Task
  void deleteTaskMyTodos(int? id)
  {
    for (var todo in userTodos?.todos ?? [])
    {
      if(todo.id == id)
      {
        userTodos?.todos.remove(todo);
        emit(AppAlterTodoState());
        break;
      }
    }
  }


  ///Alter a To-do from [allTodos]
  void alterInAllTodos(TodoModel todo)
  {

    for (var item in allTodos?.todos ?? [])
    {
      if(item.id == todo.id)
      {
        item = todo;
        emit(AppAlterTodoState());
        break;
      }
    }
  }

  ///Delete a Task
  void deleteTaskAllTodos(int? id)
  {
    for (var todo in allTodos?.todos ?? [])
    {
      if(todo.id == id)
      {
        allTodos?.todos.remove(todo);
        emit(AppAlterTodoState());
        break;
      }
    }
  }



}