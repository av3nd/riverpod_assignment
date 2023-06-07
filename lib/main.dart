import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_class_app/view/student_view.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Riverpod state management',
        initialRoute: '/',
        routes: {
          '/': (context) => const StudentView(),
          // '/counter': (context) => const CounterView(),
          // '/add': (context) => const AddView(),
          // '/simpleinterest': (context) => SiView(),
        },
      ),
    ),
  );
}
