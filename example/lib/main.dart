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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                final id = Random().nextInt(100);
                showToast(
                  context,
                  Toast(
                    title: 'hhee baby',
                    description: 'This is a basic toast $id',
                  ),
                );
              },
              child: const Text('Show basic toast'),
            ),
            ElevatedButton(
              onPressed: () {
                final id = Random().nextInt(100);
                showToast(
                  context,
                  Toast(
                    title: 'Error',
                    description: 'This is a error toast $id',
                    icon: Icons.error,
                    color: Colors.red,
                  ),
                );
              },
              child: const Text('Show error toast'),
            ),
            ElevatedButton(
              onPressed: () {
                final id = Random().nextInt(100);
                showToast(
                  context,
                  Toast(
                    title: 'Info',
                    description: 'This is a info toast $id',
                    icon: Icons.info,
                    color: Colors.blue,
                  ),
                  duration: const Duration(seconds: 1),
                );
              },
              child: const Text('Show info toast'),
            ),
          ],
        ),
      ),
    );
  }
}
