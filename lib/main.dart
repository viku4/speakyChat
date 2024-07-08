import 'index.dart';
import 'hive/chat_user.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:hive/hive.dart';
import 'hive/chat_user_hive.dart';
import 'flutter_flow/nav/nav.dart';
import 'offline/message_hive.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'bindings/global_bindings.dart';
import 'package:provider/provider.dart';
import '/backend/supabase/supabase.dart';
import 'package:hive_flutter/adapters.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/internationalization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:speaky_chat/screens/splash_screen.dart';
import 'package:speaky_chat/providers/chats_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter_localizations/flutter_localizations.dart';

// import 'auth/supabase_auth/supabase_user_provider.dart';
// import 'auth/supabase_auth/auth_util.dart';
late SharedPreferences preferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // await Hive.openBox('chatUsersBox');
  Hive.registerAdapter(MessageHiveAdapter());
  Hive.registerAdapter(MessageTypeAdapter());
  preferences = await SharedPreferences.getInstance();

  await Hive.openBox<List<MessageHive>>('messages');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  //
  // await SupaFlow.initialize();
  //
  // await FlutterFlowTheme.initialize();

  // final appState = FFAppState(); // Initialize FFAppState
  // await appState.initializePersistedState();

  // runApp(ChangeNotifierProvider(
  //   create: (context) => appState,
  //   child: MyApp(),
  // ));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  // late Stream<BaseAuthUser> userStream;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    // userStream = speakyChatSupabaseUserStream()
    //   ..listen((user) => _appStateNotifier.update(user));
    // jwtTokenStream.listen((_) {});
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Speaky Chat',
        initialBinding: GlobalBinding(),
        // localizationsDelegates: const [
        //   FFLocalizationsDelegate(),
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        // ],
        locale: _locale,
        supportedLocales: const [Locale('en', '')],
        theme: ThemeData(
          brightness: Brightness.light,
          scrollbarTheme: const ScrollbarThemeData(),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scrollbarTheme: const ScrollbarThemeData(),
        ),
        themeMode: _themeMode,
        home: const SplashScreen(),
      ),
    );
  }
}
