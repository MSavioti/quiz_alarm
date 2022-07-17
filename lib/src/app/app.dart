import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Waker',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.yellow[700]!,
          onPrimary: Colors.blue[800]!,
          secondary: Colors.blue[800]!,
          onSecondary: Colors.yellow[700]!,
          error: Colors.red[600]!,
          onError: Colors.white70,
          background: Colors.yellow[700]!,
          onBackground: Colors.blue[800]!,
          surface: Colors.blue[800]!,
          onSurface: Colors.yellow[700]!,
        ),
      ),
    );
  }
}
