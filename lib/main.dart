import 'package:flutter/material.dart';
import 'package:flutter_project/api/AuthProvider.dart';
import 'package:flutter_project/data/models/HomePageModel.dart';
import 'package:flutter_project/data/models/User.dart';
import 'package:flutter_project/view/Login/ProfileForm.dart';
import 'package:flutter_project/view/Login/loginscreen.dart';
import 'package:flutter_project/view/MainRoutes/homepage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserModel(
            id: 0,
            phoneNumber: '',
            status: '',
            isAdmin: false,
            isProvider: false,
            isCustomer: false,
            //token: '',
          ),
        ),
        ChangeNotifierProvider(create: (_) => HomePageModel()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    print("helllllllllllo");
    return MaterialApp(
      theme: ThemeData(
        drawerTheme: DrawerThemeData(backgroundColor: Colors.white),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
        textTheme: TextTheme(
          bodySmall: TextStyle(fontSize: 18),
          bodyMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF437e76),
          onPrimary: Colors.white,
          tertiary: Color.fromARGB(255, 222, 208, 150),
          onTertiary: Colors.white,
          secondary: Color(0xFF74a29c),
        ),
      ),
      // home: LoginScreen()
      //context.read<AuthProvider>().token!
      home: Homepage(
        token: "3|IpPBTXrZr2zSntJH9xkf3huUMX3ugq67hyOjk6jM65be8b0a",
      ),
    );
  }
}
