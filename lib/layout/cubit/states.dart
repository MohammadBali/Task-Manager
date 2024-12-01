abstract class AppStates {}

class AppInitialState extends AppStates{}

class AppChangeTabBar extends AppStates{}

class AppChangeThemeModeState extends AppStates{}

class AppChangeLanguageState extends AppStates{}

class AppSignOutState extends AppStates{}

//------------------------------------

//USER DATA

class AppGetUserDataLoadingState extends AppStates{}

class AppGetUserDataErrorState extends AppStates{}

class AppGetUserDataSuccessState extends AppStates{}

//------------------------------------

//REFRESH AUTH TOKEN

class AppRefreshTokenLoadingState extends AppStates{}

class AppRefreshTokenSuccessState extends AppStates{}

class AppRefreshTokenErrorState extends AppStates{}


//------------------------------------

//GET USER TODOS

class AppGetUserTodosLoadingState extends AppStates{}

class AppGetUserTodosSuccessState extends AppStates{}

class AppGetUserTodosErrorState extends AppStates{
  final String message;

  AppGetUserTodosErrorState({required this.message});
}

//------------------------------------

//GET ALL TODOS

class AppGetAllTodosLoadingState extends AppStates{}

class AppGetAllTodosSuccessState extends AppStates{}

class AppGetAllTodosErrorState extends AppStates{
  final String message;

  AppGetAllTodosErrorState({required this.message});
}

//------------------------------------

//ALTER A TO-DO

class AppAlterTodoState extends AppStates{}

//------------------------------------

//DB

//GET DB
class AppGetDatabaseLoadingState extends AppStates{}

class AppGetDatabaseSuccessState extends AppStates{}

class AppGetDatabaseErrorState extends AppStates{

  final String message;

  AppGetDatabaseErrorState({required this.message});
}

//CREATE DB
class AppCreateDatabaseSuccessState extends AppStates{}

class AppCreateDatabaseLoadingState extends AppStates{}

class AppCreateDatabaseErrorState extends AppStates{}

//INSERT TO DB

class AppInsertDatabaseLoadingState extends AppStates{}

class AppInsertDatabaseErrorState extends AppStates{
  final String message;

  AppInsertDatabaseErrorState({required this.message});
}

class AppInsertDatabaseSuccessState extends AppStates{}

//UPDATE DB

class AppUpdateDatabaseLoadingState extends AppStates{}

class AppUpdateDatabaseErrorState extends AppStates{
  final String message;

  AppUpdateDatabaseErrorState({required this.message});
}

class AppUpdateDatabaseSuccessState extends AppStates{}

//DELETE FROM DB

class AppDeleteFromDatabaseLoadingState extends AppStates{}

class AppDeleteFromDatabaseErrorState extends AppStates{
  final String message;

  AppDeleteFromDatabaseErrorState({required this.message});
}

class AppDeleteFromDatabaseSuccessState extends AppStates{}

//------------------------------------

