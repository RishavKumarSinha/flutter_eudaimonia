import 'package:flutter/material.dart';
import 'package:eudaimonia/database/habit_database.dart';
import 'package:eudaimonia/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //init the database
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();

  runApp(
 MultiProvider(providers: [
  //habit provider
  ChangeNotifierProvider(create: (context) => HabitDatabase()),

  //theme provider
   ChangeNotifierProvider(create: (context) => ThemeProvider()),
 ],
 child: const MyApp(),
 )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
     home:const HomePage(),
     title: "HabitHub",
     theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
