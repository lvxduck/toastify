import 'dart:math';

import 'package:flutter/material.dart';
import 'package:toastify/toastify.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showToast(
              context,
              Toast(
                title: 'hhee baby',
                description:
                    'Hello naoa dax asxas x le vinh nhan duc ${Random().nextInt(100)}',
              ),
            );
          },
          child: const Text('Create toast'),
        ),
      ),
    );
  }
}
