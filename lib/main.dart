import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './screens/screens.dart';
import './themes/dark_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aqua Service',
      theme: darkTheme,
      home: HomeScreen(),
    );
  }
}
