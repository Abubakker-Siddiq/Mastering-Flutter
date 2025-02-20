import 'package:flutter/material.dart';
import 'package:natpu_kavithaigal/pages/splash_screen_page.dart';
import 'package:natpu_kavithaigal/providers/bookmarks_provider.dart';
import 'package:natpu_kavithaigal/providers/favorites_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
        ChangeNotifierProvider(create: (context) => BookmarksProvider()),
      ],
      child: MaterialApp(
        title: "Natpu Kavithaigal",
        theme: ThemeData.dark(useMaterial3: true).copyWith(
          // TextTheme
          textTheme: TextTheme(
            titleLarge: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
            titleMedium: TextStyle(fontSize: 16),
          ),

          // PopMenuTheme
          popupMenuTheme: PopupMenuThemeData(
            color: Colors.black,
            elevation: 20,
          ),

          // AppBarTheme
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF0B1014),
            iconTheme: IconThemeData(size: 30),
            scrolledUnderElevation: 0,
          ),

          // ScaffoldTheme
          scaffoldBackgroundColor: Color(0xFF0B1014),

          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF0B1014),
          ),

          snackBarTheme: SnackBarThemeData(backgroundColor: Colors.black),

          iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(iconSize: WidgetStatePropertyAll(25)),
          ),
          
          cardTheme: CardThemeData(
            color: Colors.black38,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            )
          ),

          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.black38,
          )
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreenPage(),
      ),
    );
  }
}
