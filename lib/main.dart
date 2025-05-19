import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import 'package:screens/core/models/export_models.dart';
import 'package:screens/home.dart';
import 'core/theme/theme.dart';
import 'core/services/firebase_options.dart';
import 'providers/user_provider.dart';
import 'features/signin_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'data/globals.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  Gemini.init(apiKey: dotenv.env['gemini_key']!);
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider?>(context);
    final ThemeData appTheme = userProvider?.getTheme() ?? ThemeData.light();

    return MaterialApp(
      title: 'Thrive X',
      theme: appTheme,
      themeMode: ThemeMode.system,
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // return SigninPage();
    return HomePage();
  }
}
