import 'package:flutter/material.dart';
import 'package:quiz_waker/src/app/app.dart';
import 'package:quiz_waker/src/app/dependency_injection/dependency_injection_container.dart';

void main() async {
  await setupDependencyInjectionContainer();
  runApp(const App());
}
