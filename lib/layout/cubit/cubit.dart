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
import 'package:showcaseview/showcaseview.dart';
import 'package:sqflite/sqflite.dart';

//Our State management, using BLoC
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
  static String? language='en';

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
    ShowCaseWidget(builder: (context)=>HomePage()),
    ShowCaseWidget(builder: (context)=>const AllTasks()),
    ShowCaseWidget(builder: (context)=>const Settings()),

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

        getUserTodos(getFromDB: true);
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

  //DB MANAGEMENT

  Database? database;

  ///Creates The Database
  ///* If Already exists => Open it
  void createDatabase()
  {
    emit(AppCreateDatabaseLoadingState());

    openDatabase(
      'todo.db',
      version: 1,

      onCreate: (database, version) async
      {
        debugPrint('Database has been created...');
        await database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY,todo TEXT, userId INTEGER, completed TEXT, type TEXT)'
        ).then((value)
        {
          debugPrint('Table tasks has been created.');
        }).catchError((error) {
          debugPrint('An error occurred when creating tasks table ${error.toString()}');
          emit(AppCreateDatabaseErrorState());
        });
      },
      onOpen: (database) {
        debugPrint('DB has been opened.');
        getDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseSuccessState());

    }).catchError((error)
    {
      debugPrint('ERROR WHILE CREATING DB..., ${error.toString()}');
      emit(AppCreateDatabaseErrorState());
    });
  }

  ///*Insert Into The Tasks Table
  ///[id] Task ID
  ///[to-do] Massage
  ///[completed] if the status is completed; default to false
  ///[type] Setting it to user so it's a user type not global
  ///[userId] User ID, usually the current user ID
  void insertIntoDatabase({
    required int id,
    required String todo,
    required String completed,
    required String type,
    required int userId,
  }) async
  {
    emit(AppInsertDatabaseLoadingState());

    await database?.transaction((txn) async {
      await txn
          .rawInsert(
          'INSERT INTO tasks(id,todo,userId, completed, type) VALUES("$id", "$todo", "$userId", "$completed", "$type")')
          .then((value) {
        debugPrint('$value has been Inserted successfully');
        emit(AppInsertDatabaseSuccessState());

        getDatabase(database!);

      }).catchError((error)
      {
        debugPrint('Error has occurred while inserting into database, ${error.toString()}');
        emit(AppInsertDatabaseErrorState(message: 'Error has occurred while inserting into database, ${error.toString()}'));
      });
    });
  }

  void getDatabase(Database? database)  {
    // userTodos=null;
    // allTodos=null;
    emit(AppGetDatabaseLoadingState());
    database?.rawQuery('SELECT * FROM tasks').then((value) async {
      for (var element in value)
      {
        // print(element.toString());
        element['type'] == 'user'
          ? userTodos?.addTodosFromDB(element)
          : allTodos?.addTodosFromDB(element);
      }
      emit(AppGetDatabaseSuccessState());
    }).catchError((error, stackTrace)
    {
      debugPrint('ERROR WHILE GETTING DATABASE..., ${error.toString()}');
      emit(AppGetDatabaseErrorState(message: 'ERROR WHILE GETTING DATABASE..., ${error.toString()}'));
    });
  }

  void updateDatabase({String? completed, String? todo, required int id}) async
  {
    emit(AppUpdateDatabaseLoadingState());

    String query;
    List<Object?> arguments;

    if(todo !=null && completed !=null)
    {
      query = 'UPDATE tasks SET completed = ?, todo = ? WHERE id = ?';
      arguments = [completed, todo, id,];
    }
    else if (todo ==null)
    {
      query = 'UPDATE tasks SET completed = ? WHERE id = ?';
      arguments = [completed, id,];
    }

    else if (completed ==null)
    {
      query = 'UPDATE tasks SET todo = ? WHERE id = ?';
      arguments = [todo, id,];
    }

    else
    {
      emit(AppUpdateDatabaseErrorState(message: 'All Arguments are empty'));
      return;
    }

    database!.rawUpdate(query,arguments).then((value)
    {
      getDatabase(database);
      emit(AppUpdateDatabaseSuccessState());
    }).catchError((error)
    {
      debugPrint('ERROR WHILE UPDATING DB..., ${error.toString()}');
      emit(AppUpdateDatabaseErrorState(message: 'ERROR WHILE UPDATING DB..., ${error.toString()}'));
    });
  }

  void deleteDatabase({required int id}) async
  {
    emit(AppDeleteFromDatabaseLoadingState());

    database!.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id]
    ).then((value)
    {
      getDatabase(database);
      emit(AppDeleteFromDatabaseSuccessState());
    }).catchError((error)
    {
      debugPrint('ERROR WHILE DELETING FROM DB..., ${error.toString()}');
      emit(AppDeleteFromDatabaseErrorState(message: 'ERROR WHILE DELETING FROM DB..., ${error.toString()}'));
    });
  }


  //--------------------------------------------------\\

  //TODOS

  TodosModel? userTodos;

  ///Get User Todos
  void getUserTodos({int? limit, int? skip, bool isNextTodos = false, bool getFromDB= false})
  {
    if(token!='')
    {
      debugPrint('in getUserTodos...');

      emit(AppGetUserTodosLoadingState());

      MainDioHelper.getData(
        url: '$getTodos/${userData?.id}',
        query:
        {
          if(limit!=null) 'limit':limit,
          if(skip!=null) 'skip':skip + (limit ?? 0),
        },
      ).then((value)
      {
        debugPrint('Got This User Todos...');

        if(isNextTodos ==true)
        {
          userTodos?.addPagination(value.data);
          userTodos?.addTodos(value.data);
        }

        else
        {
          userTodos = TodosModel.fromJson(value.data);
        }

        emit(AppGetUserTodosSuccessState());

        getFromDB? getDatabase(database) : null;

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
    updateDatabase(id: todo.id!, completed: todo.completed.toString(), todo: todo.todo);

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
    updateDatabase(id: todo.id!, completed: todo.completed.toString());

    todo.completed=true;
    emit(AppAlterTodoState());
  }

  ///Delete a Task
  void deleteTaskMyTodos(int? id)
  {
    deleteDatabase(id: id!);

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