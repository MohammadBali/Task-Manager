import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_project/layout/cubit/cubit.dart';
import 'package:maids_project/layout/cubit/states.dart';
import 'package:maids_project/layout/home_layout.dart';
import 'package:maids_project/modules/Login/cubit/loginCubit.dart';
import 'package:maids_project/shared/components/Localization/Localization.dart';
import 'package:maids_project/shared/components/components.dart';
import 'package:maids_project/shared/components/constants.dart';
import 'package:maids_project/shared/network/local/cache_helper.dart';
import 'package:maids_project/shared/styles/colors.dart';
import 'package:showcaseview/showcaseview.dart';

import 'cubit/loginStates.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController usernameController=TextEditingController();

  TextEditingController passwordController=TextEditingController();

  var formKey=GlobalKey<FormState>();

  List<String> listOfLanguages = ['ar','en'];

  String currentLanguage= AppCubit.language??='en';


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=> LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (context,state)
        {
          if(state is LoginErrorState)
          {
            snackBarBuilder(message: state.error, context: context);
          }

          if(state is LoginSuccessState)
          {
            if([400,404].contains(state.status))
            {
              snackBarBuilder(message: Localization.translate('login_error_toast'), context: context);
            }

            else
            {
              snackBarBuilder(message: Localization.translate('login_successfully_toast'), context: context);

              CacheHelper.saveData(key: 'token', value: state.loginModel.token).then((value)
              {
                token=state.loginModel.token!;

                AppCubit.get(context).getUserDataByLoginModel(model:state.loginModel);

                CacheHelper.saveData(key: 'refresh_token', value: state.loginModel.refreshToken).then((value)
                {
                  refreshToken = state.loginModel.refreshToken!;

                  navigateAndFinish(context, ShowCaseWidget(builder: (context)=>const Home()));

                }).catchError((error)
                {
                  snackBarBuilder(message: '${Localization.translate('error')}, ${error.toString()}', context: context);
                  debugPrint('COULD NOT CACHE REFRESH TOKEN, ${error.toString()}');
                });

              }).catchError((error)
              {
                snackBarBuilder(message: '${Localization.translate('error')}, ${error.toString()}', context: context);
                debugPrint('ERROR WHILE CACHING USER TOKEN IN LOGIN, ${error.toString()}');
              });
            }
          }
        },

        builder: (context,state)
        {
          var cubit= LoginCubit.get(context);

          return BlocConsumer<AppCubit,AppStates>(
            listener: (appContext,appState){},

            builder: (appContext,appState)
            {
              var appCubit= AppCubit.get(appContext);

              return Directionality(
                textDirection: appDirectionality(),
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  appBar: AppBar(),

                  body: OrientationBuilder(
                    builder: (context, orientation)
                    {
                      if(orientation== Orientation.portrait)
                      {
                        return Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(top:24.0, start: 24.0, end: 24.0, bottom: 0.0),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,

                              children:
                              [
                                Text(
                                  Localization.translate('login_title'),
                                  style: TextStyle(
                                    color: appCubit.isDarkTheme? defaultDarkColor : defaultColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 32,
                                  ),

                                ),

                                const SizedBox(height: 5,),

                                Text(
                                  Localization.translate('login_second_title'),//'Login Now and Start Revealing the Truth',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor,
                                    fontWeight: FontWeight.w400
                                  ),
                                ),

                                const SizedBox(height: 60,),

                                defaultTextFormField(
                                  controller: usernameController,
                                  keyboard: TextInputType.text,
                                  label: Localization.translate('username_login_tfm'),
                                  prefix: Icons.person_outline_sharp,
                                  isFilled: false,

                                  validate: (value)
                                  {
                                    if(value!.isEmpty)
                                    {
                                      return Localization.translate('username_login_tfm_error');
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 25),


                                defaultTextFormField(
                                  controller: passwordController,
                                  keyboard: TextInputType.text,
                                  label: Localization.translate('password_login_tfm'),
                                  prefix: Icons.password_rounded,
                                  //suffixIconColor: Colors.grey,
                                  suffix: cubit.isPassVisible? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                  isFilled: false,

                                  validate: (value)
                                  {
                                    if(value!.isEmpty)
                                    {
                                      return Localization.translate('password_login_tfm_error');
                                    }
                                    return null;
                                  },

                                  isObscure: cubit.isPassVisible,

                                  onSubmit: (value)
                                  {
                                    if(formKey.currentState!.validate())
                                    {
                                      cubit.userLogin(
                                          usernameController.text,
                                          passwordController.text
                                      );
                                    }
                                  },

                                  onPressedSuffixIcon: ()
                                  {
                                    cubit.changePassVisibility();
                                  },

                                ),


                                const SizedBox(height: 20,),


                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment: AlignmentDirectional.centerStart,
                                          child: FormField<String>(
                                            builder: (FormFieldState<String> state) {
                                              return InputDecorator(
                                                decoration: InputDecoration(
                                                  enabledBorder: InputBorder.none,
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  errorStyle:const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                                  labelText: Localization.translate('language_name_general_settings'),
                                                ),

                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    style: TextStyle(color: appCubit.isDarkTheme? defaultDarkColor : defaultColor),
                                                    value: currentLanguage,
                                                    //dropdownColor: appCubit.isDarkTheme? defaultCanvasDarkColor : defaultCanvasColor,

                                                    isDense: true,
                                                    onChanged: (newValue) {

                                                      setState(() {
                                                        currentLanguage = newValue!;
                                                        state.didChange(newValue);

                                                        CacheHelper.saveData(key: 'language', value: newValue).then((value){
                                                          appCubit.changeLanguage(newValue);
                                                          Localization.load(Locale(newValue));

                                                        }).catchError((error)
                                                        {
                                                          debugPrint('ERROR WHILE SWITCHING LANGUAGES, ${error.toString()}');
                                                          snackBarBuilder(message: error.toString(), context: context);
                                                        });
                                                      });
                                                    },
                                                    items: listOfLanguages.map((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                value == 'ar' ? 'Arabic' : 'English'
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),

                                //const SizedBox(height: 40,),

                                Expanded(
                                  child: ConditionalBuilder(
                                    condition: state is LoginLoadingState,
                                    builder: (context)=> Center(child: defaultProgressIndicator(context: context)),
                                    fallback: (context)=> Center(
                                      child: defaultButton(
                                        message: Localization.translate('submit_button_login'),
                                        onPressed: ()
                                        {
                                          if(formKey.currentState!.validate())
                                          {
                                            cubit.userLogin(
                                              usernameController.text,
                                              passwordController.text,
                                            );
                                          }
                                        },
                                        type: ButtonType.filledTonal
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      else
                      {
                        return SingleChildScrollView(
                          child: Form(
                            key: formKey,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(top:24.0, start: 24.0, end: 24.0, bottom: 0.0),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children:
                                [
                                  Text(
                                    Localization.translate('login_title'),
                                    style: TextStyle(
                                      color: appCubit.isDarkTheme? defaultDarkColor : defaultColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 32,
                                    ),

                                  ),

                                  const SizedBox(height: 5,),

                                  Text(
                                    Localization.translate('login_second_title'),//'Login Now and Start Revealing the Truth',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),

                                  const SizedBox(height: 60,),

                                  defaultTextFormField(
                                    controller: usernameController,
                                    keyboard: TextInputType.text,
                                    label: Localization.translate('username_login_tfm'),
                                    prefix: Icons.person_outline_sharp,
                                    isFilled: false,
                                    validate: (value)
                                    {
                                      if(value!.isEmpty)
                                      {
                                        return Localization.translate('username_login_tfm_error');
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 30),


                                  defaultTextFormField(
                                    controller: passwordController,
                                    keyboard: TextInputType.text,
                                    label: Localization.translate('password_login_tfm'),
                                    prefix: Icons.password_rounded,
                                    //suffixIconColor: Colors.grey,
                                    suffix: cubit.isPassVisible? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                    isFilled: false,
                                    validate: (value)
                                    {
                                      if(value!.isEmpty)
                                      {
                                        return Localization.translate('password_login_tfm_error');
                                      }
                                      return null;
                                    },

                                    isObscure: cubit.isPassVisible,

                                    onSubmit: (value)
                                    {
                                      if(formKey.currentState!.validate())
                                      {
                                        cubit.userLogin(
                                            usernameController.text,
                                            passwordController.text
                                        );
                                      }
                                    },

                                    onPressedSuffixIcon: ()
                                    {
                                      cubit.changePassVisibility();
                                    },

                                  ),


                                  const SizedBox(height: 30,),


                                  Row(
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment: AlignmentDirectional.centerStart,
                                          child: FormField<String>(
                                            builder: (FormFieldState<String> state) {
                                              return InputDecorator(
                                                decoration: InputDecoration(
                                                  enabledBorder: InputBorder.none,
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  errorStyle:const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                                  labelText: Localization.translate('language_name_general_settings'),
                                                ),

                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    style: TextStyle(color: appCubit.isDarkTheme? defaultDarkColor : defaultColor),
                                                    value: currentLanguage,
                                                    isDense: true,
                                                    onChanged: (newValue) {

                                                      setState(() {
                                                        debugPrint('Current Language is: $newValue');
                                                        currentLanguage = newValue!;
                                                        state.didChange(newValue);

                                                        CacheHelper.saveData(key: 'language', value: newValue).then((value){
                                                          appCubit.changeLanguage(newValue);
                                                          Localization.load(Locale(newValue));

                                                        }).catchError((error)
                                                        {
                                                          debugPrint('ERROR WHILE SWITCHING LANGUAGES, ${error.toString()}');
                                                          snackBarBuilder(message: error.toString(), context: context);
                                                        });
                                                      });
                                                    },
                                                    items: listOfLanguages.map((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                value == 'ar' ? 'Arabic' : 'English'
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),

                                  const SizedBox(height: 40,),

                                  ConditionalBuilder(
                                    condition: state is LoginLoadingState,
                                    builder: (context)=> Center(child: defaultProgressIndicator(context:context)),
                                    fallback: (context)=> Center(
                                      child: defaultButton(
                                        message: Localization.translate('submit_button_login'),
                                        onPressed: ()
                                        {
                                          if(formKey.currentState!.validate())
                                          {
                                            cubit.userLogin(
                                              usernameController.text,
                                              passwordController.text,
                                            );
                                          }
                                        },
                                        type: ButtonType.filledTonal
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
