import 'package:flutter/material.dart';
import 'package:flutter_to_do/providers/add_new_task_provider.dart';
import 'package:flutter_to_do/providers/login_provider.dart';
import 'package:flutter_to_do/providers/tasks_provider.dart';
import 'package:flutter_to_do/utils/constants.dart';
import 'package:flutter_to_do/view/home.dart';
import 'package:flutter_to_do/view/start_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool hasSeenStart = prefs.getBool('start_seen') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AddNewTaskProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MyApp(
        initialPage: hasSeenStart ? const HomeScreen() : const StartPage(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget initialPage;

  const MyApp({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.1,
        color: Constants.appbarColor,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Constants.appbarColor,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.25,
      ),
      headlineSmall: GoogleFonts.poppins(fontSize: 14),
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.15,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w400,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.0,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.0,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w200,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w200),
      labelSmall: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w200,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w200,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 13,
        color: Constants.appbarColor,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primaryTextTheme: textTheme,
        textTheme: textTheme,
      ),
      home: initialPage,
    );
  }
}
