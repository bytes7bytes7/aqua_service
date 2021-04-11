import 'package:aqua_service/repository/clients_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aqua_service/screens/screens.dart';
import 'package:aqua_service/themes/dark_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ClientRepository clientRepository = ClientRepository();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aqua Service',
      theme: darkTheme,
      home: HomeScreen(clientRepository: clientRepository),
    );
  }
}
