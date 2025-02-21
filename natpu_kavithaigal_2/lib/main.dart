import 'package:flutter/material.dart';
import 'package:natpu_kavithaigal/pages/splash_screen_page.dart';
import 'package:natpu_kavithaigal/providers/favorites_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoritesProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF3C505B),
            actionsIconTheme: IconThemeData(color: Color(0xFFB1B9BD), size: 30),
          ),

          textTheme: TextTheme(
            titleLarge: TextStyle(color: Colors.white, fontSize: 18),
          ),

          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Color(0xFF35505A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero),
            ),
          ),

          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color(0xFF303030),
            selectedIconTheme: IconThemeData(size: 0),
            unselectedIconTheme: IconThemeData(size: 0),
            selectedLabelStyle: TextStyle(fontSize: 0),
            unselectedLabelStyle: TextStyle(fontSize: 0),
          ),
        ),

        home: SplashScreenPage(),
      ),
    );
  }
}
