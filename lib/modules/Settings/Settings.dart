import 'package:maids_project/shared/components/Imports/default_imports.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  List<String> listOfLanguages = ['ar','en'];

  String currentLanguage= AppCubit.language??='en';

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder:(context,state)
        {
          var cubit = AppCubit.get(context);

          return OrientationBuilder(
              builder: (context,orientation)
              {
                if(orientation == Orientation.portrait)
                {
                  return RefreshIndicator(
                    onRefresh: ()async
                    {
                      cubit.refreshAuthSession();
                    },
                    child: CustomScrollView(
                      slivers:
                      [
                        SliverFillRemaining(
                          child: Column(
                            children:
                            [
                              const SizedBox(height: 15,),

                              Center(
                                child: CircleAvatar(
                                  radius: 85,
                                  backgroundColor: Colors.transparent,
                                  child: Image(
                                      image: NetworkImage(AppCubit.userData?.image ?? ''),

                                      errorBuilder: (context, u, stackTrace)
                                      {
                                        return const Image(
                                          image: AssetImage('assets/images/personal/personal.png'),
                                        );
                                      }
                                  ),
                                ),
                              ),

                              Text(
                                '${Localization.translate('welcome_back')} ${AppCubit.userData?.firstName ?? 'NAME' }!',
                                style: textStyleBuilder(),
                              ),

                              defaultDivider(),

                              const SizedBox(height: 25,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:
                                [
                                  const Icon(Icons.language_outlined),

                                  const SizedBox(width: 5,),

                                  Text(
                                    Localization.translate('language_name_general_settings'),
                                    style: textStyleBuilder(fontSize: 18),
                                  ),

                                  const Spacer(),

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
                                                style: TextStyle(color: cubit.isDarkTheme? defaultDarkColor : defaultColor),
                                                value: currentLanguage,
                                                isDense: true,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    debugPrint('Current Language is: $newValue');
                                                    currentLanguage = newValue!;
                                                    state.didChange(newValue);

                                                    CacheHelper.saveData(key: 'language', value: newValue).then((value){
                                                      cubit.changeLanguage(newValue);
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

                              const SizedBox(height: 15,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:
                                [
                                  Icon(
                                      cubit.isDarkTheme
                                          ?Icons.dark_mode_outlined
                                          :Icons.light_mode_outlined
                                  ),

                                  const SizedBox(width: 5,),

                                  Text(
                                    Localization.translate('dark_mode'),
                                    style: textStyleBuilder(fontSize: 18),
                                  ),

                                  const Spacer(),

                                  Switch(
                                    value: cubit.isDarkTheme,
                                    onChanged: (val)
                                    {
                                      cubit.changeTheme();
                                    },

                                  ),
                                ],
                              ),

                              const Spacer(),

                              defaultButton(
                                type: ButtonType.text,
                                customChild: Text(
                                  Localization.translate('sign_out'),
                                  style: textStyleBuilder(fontWeight: FontWeight.w400),
                                ),
                                onPressed: ()
                                {
                                  showDialog(
                                      context: context,
                                      builder: (dialogContext)
                                      {
                                        return defaultAlertDialog(
                                            context: context,
                                            title: Localization.translate('exit_app_title'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children:
                                              [
                                                Center(
                                                    child: Text(
                                                      Localization.translate('exit_app_secondary_title'),
                                                      style: textStyleBuilder(fontSize: 18),
                                                    )
                                                ),

                                                Row(
                                                  children:
                                                  [
                                                    defaultButton(
                                                        message: Localization.translate('exit_app_yes'),
                                                        type: ButtonType.text,
                                                        onPressed: ()async
                                                        {
                                                          await cubit.signOut();
                                                        }
                                                    ),

                                                    const Spacer(),

                                                    defaultButton(
                                                        message: Localization.translate('exit_app_no'),
                                                        type: ButtonType.text,
                                                        onPressed: ()
                                                        {
                                                          Navigator.of(dialogContext).pop();
                                                        }
                                                    ),

                                                  ],
                                                ),
                                              ],
                                            )
                                        );
                                      }
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }
                else
                {
                  return RefreshIndicator(
                    onRefresh: ()async
                    {
                      cubit.refreshAuthSession();
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                        [
                          const SizedBox(height: 15,),

                          Center(
                            child: CircleAvatar(
                              radius: 85,
                              backgroundColor: Colors.transparent,
                              child: Image(
                                  image: NetworkImage(AppCubit.userData!.image!),

                                  errorBuilder: (context, u, stackTrace)
                                  {
                                    snackBarBuilder(message: '', context: context);
                                    return const Image(
                                      image: AssetImage('assets/images/personal/personal.png'),
                                    );
                                  }
                              ),
                            ),
                          ),

                          Text(
                            '${Localization.translate('welcome_back')} ${AppCubit.userData?.firstName}!',
                            style: textStyleBuilder(),
                          ),

                          defaultDivider(),

                          const SizedBox(height: 25,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:
                            [
                              const Icon(Icons.language_outlined),

                              const SizedBox(width: 5,),

                              Text(
                                Localization.translate('language_name_general_settings'),
                                style: textStyleBuilder(fontSize: 18),
                              ),

                              const Spacer(),

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
                                            style: TextStyle(color: cubit.isDarkTheme? defaultDarkColor : defaultColor),
                                            value: currentLanguage,
                                            isDense: true,
                                            onChanged: (newValue) {
                                              setState(() {
                                                debugPrint('Current Language is: $newValue');
                                                currentLanguage = newValue!;
                                                state.didChange(newValue);

                                                CacheHelper.saveData(key: 'language', value: newValue).then((value){
                                                  cubit.changeLanguage(newValue);
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

                          const SizedBox(height: 15,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:
                            [
                              Icon(
                                  cubit.isDarkTheme
                                      ?Icons.dark_mode_outlined
                                      :Icons.light_mode_outlined
                              ),

                              const SizedBox(width: 5,),

                              Text(
                                Localization.translate('dark_mode'),
                                style: textStyleBuilder(fontSize: 18),
                              ),

                              const Spacer(),

                              Switch(
                                value: cubit.isDarkTheme,
                                onChanged: (val)
                                {
                                  cubit.changeTheme();
                                },

                              ),
                            ],
                          ),

                          const SizedBox(height: 25,),

                          defaultButton(
                            type: ButtonType.text,
                            customChild: Text(
                              Localization.translate('sign_out'),
                              style: textStyleBuilder(fontWeight: FontWeight.w600),
                            ),
                            onPressed: ()
                            {

                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
              });
        }
    );
  }
}
