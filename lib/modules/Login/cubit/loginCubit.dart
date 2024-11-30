import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_project/models/LoginModel/LoginModel.dart';
import 'package:maids_project/shared/network/end_points.dart';
import 'package:maids_project/shared/network/remote/main_dio_helper.dart';
import 'loginStates.dart';

class LoginCubit extends Cubit<LoginStates>
{
  LoginCubit(): super(LoginInitialState());

  static LoginCubit get(context) =>BlocProvider.of(context);

  bool isPassVisible=true;

  void changePassVisibility()
  {
    isPassVisible=!isPassVisible;
    emit(LoginChangePassVisibilityState());
  }

  LoginModel? loginModel;
  void userLogin(String username, String password)
  {
    debugPrint('in User login ...');

    emit(LoginLoadingState());

    MainDioHelper.postData(
      url: login,
      isStatusCheck: true,
      data:
      {
        'username':username,
        'password':password,
      },
    ).then((value)
    {
      debugPrint('Got Login Data...');

      loginModel=LoginModel.fromJson(value.data);

      emit(LoginSuccessState(loginModel!, value.statusCode));

    }).catchError((error, stackTrace)
    {
      debugPrint('ERROR WHILE LOGGING IN, ${error.toString()}, $stackTrace');
      
      emit(LoginErrorState(error.toString()));
    });
  }
}