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
import 'package:showcaseview/showcaseview.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  //Initializing Dio; HTTP Client
  MainDioHelper.init();

  //Initializing CacheHelper (SharedPreferences)
  await CacheHelper.init();

  //Load Language using Localization
  AppCubit.language= CacheHelper.getData(key: 'language');
  AppCubit.language ??= 'en';

  // Set the Initial Local; Language
  await Localization.load(Locale(AppCubit.language!));

  //print errors in console
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  //Bloc Observer; prints state changes & errors into console
  Bloc.observer = MyBlocObserver();

  //Getting the last Cached ThemeMode
  bool? isDark = CacheHelper.getData(key: 'isDarkTheme');
  isDark ??= true;

  if (CacheHelper.getData(key: 'token') != null) {
    token = CacheHelper.getData(key: 'token'); // Get User Token (Access Token)
  }

  if (CacheHelper.getData(key: 'refresh_token') != null) {
    refreshToken = CacheHelper.getData(key: 'refresh_token'); // Get refresh Token
  }

  //to figure out which widget to send (login or HomePage) we use a widget and set the value in it depending on the token.
  Widget widget;

  //Token is there, so user has logged in before
  if (token.isNotEmpty)
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
    //Start the bloc provider which creates our BLoC
    return BlocProvider(
      create: (BuildContext context)=> AppCubit()..changeTheme(themeFromState: isDark)..createDatabase()..getUserData(),
      //Using Consumer to listen to any new changes and rebuild depending on that
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
            //Animated Splash Screen to show logo on startup
            child: AnimatedSplashScreen(
              duration: 2000,
              animationDuration: const Duration(milliseconds: 200),
              splash:
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 14.0),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Expanded(
                      child: Image(
                        image: AssetImage(
                          'assets/images/splash/maids.png',
                        ),
                      ),
                    ),

                  Center(
                    child: Text(
                      'Get a Full-time Maid or a Maid Visa',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'WithoutSans',
                        color: AppCubit.get(context).isDarkTheme
                            ?darkColorScheme.secondary
                            :lightColorScheme.secondary
                      ),
                    ),
                  )
                  ],
                ),
              ),

              splashIconSize: MediaQuery.of(context).size.width /1.1,
              nextScreen: ShowCaseWidget(builder: (context)=>homeWidget,),
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

