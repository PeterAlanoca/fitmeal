import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/injection_container.dart' as di;
import 'presentation/pages/login_page.dart';
import 'presentation/viewmodels/login_viewmodel.dart';
import 'presentation/viewmodels/register_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<LoginViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<RegisterViewModel>()),
      ],
      child: MaterialApp(
        title: 'FitMeal',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const LoginPage(),
      ),
    );
  }
}
