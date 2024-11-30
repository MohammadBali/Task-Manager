import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_project/layout/cubit/cubit.dart';
import 'package:maids_project/layout/cubit/states.dart';
import 'package:maids_project/layout/home_layout.dart';
import 'package:maids_project/modules/Login/login.dart';
import 'package:maids_project/shared/bloc_observer.dart';
import 'package:maids_project/shared/components/Localization/Localization.dart';
import 'package:maids_project/shared/components/components.dart';
import 'package:maids_project/shared/components/constants.dart';
import 'package:maids_project/shared/network/local/cache_helper.dart';
import 'package:maids_project/shared/network/remote/main_dio_helper.dart';
import 'package:maids_project/shared/styles/colors.dart';
import 'package:maids_project/shared/styles/themes.dart';
import 'package:page_transition/page_transition.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  MainDioHelper.init();

  await CacheHelper.init(); //Starting CacheHelper (SharedPreferences)

  //LOAD LANGUAGE
  AppCubit.language= CacheHelper.getData(key: 'language');
  AppCubit.language ??= 'ar';
  await Localization.load(Locale(AppCubit.language!)); // Set the initial locale

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
  Bloc.observer = MyBlocObserver(); //Running Bloc Observer which prints change in states and errors etc...  in console

  //Dio Initialization


  bool? isDark = CacheHelper.getData(key: 'isDarkTheme'); //Getting the last Cached ThemeMode
  isDark ??= true;

  if (CacheHelper.getData(key: 'token') != null) {
    token = CacheHelper.getData(key: 'token'); // Get User Token
  }

  if (CacheHelper.getData(key: 'refresh_token') != null) {
    refreshToken = CacheHelper.getData(key: 'refresh_token'); // Get User Token
  }


  Widget widget; //to figure out which widget to send (login, onBoarding or HomePage) we use a widget and set the value in it depending on the token.

  if (token.isNotEmpty) //Token is there, so user has logged in before
  {
    widget = const Home(); //Straight to Home Page.
  }

  else
  {
    widget= const Login();
  }

  runApp(MyApp(isDark: isDark, homeWidget: widget,));
}

class MyApp extends StatelessWidget
{
  final bool isDark;
  final Widget homeWidget;  // Passing the widget to be loaded.

  const MyApp({super.key, required this.isDark, required this.homeWidget});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=> AppCubit()..changeTheme(themeFromState: isDark)..getUserData(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state)=>MaterialApp(
          title: 'Todo App',
          theme: lightTheme(context),
          darkTheme: darkTheme(context),
          themeMode: AppCubit.get(context).isDarkTheme
              ? ThemeMode.dark
              : ThemeMode.light,
          home: Directionality(
            textDirection: appDirectionality(),

            child: AnimatedSplashScreen(
              duration: 3000,
              animationDuration: const Duration(milliseconds: 200),
              splash:
              const Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 14.0),
                child:
                Image(
                  image: const AssetImage(
                    'assets/images/splash/maids.png',
                  ),
                ),
              ),

              splashIconSize: 2, //150
              nextScreen: homeWidget,
              splashTransition: SplashTransition.fadeTransition,
              pageTransitionType: PageTransitionType.fade,
              backgroundColor:AppCubit.get(context).isDarkTheme? defaultHomeDarkColor : defaultHomeColor,
            ),
          ),
          debugShowCheckedModeBanner: false,

        ),
      ),
    );
  }
}

