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