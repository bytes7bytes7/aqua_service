import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './repository/clients_repository.dart';
import './repository/order_repository.dart';
import './screens/screens.dart';
import './themes/dark_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ClientRepository clientRepository = ClientRepository();
  final OrderRepository orderRepository = OrderRepository();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aqua Service',
      theme: darkTheme,
      home: HomeScreen(
        clientRepository: clientRepository,
        orderRepository: orderRepository,
      ),
    );
  }
}
