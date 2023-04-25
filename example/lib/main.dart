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
          children: [
            const SizedBox(height: 32),
            Text(
              'Adaptive selector',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.grey[800]),
            ),
            const SizedBox(height: 12),
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
                    leading: const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
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
                    leading: const Icon(
                      Icons.info,
                      color: Colors.blue,
                    ),
                  ),
                  duration: const Duration(seconds: 1),
                  alignment: Alignment.topLeft,
                );
              },
              child: const Text('Show info toast'),
            ),
            ElevatedButton(
              onPressed: () {
                final id = Random().nextInt(100);
                showToast(
                  context,
                  Toast(
                    title: 'Info',
                    description: 'This is a info toast $id',
                    leading: const Icon(
                      Icons.info,
                      color: Colors.blue,
                    ),
                  ),
                  duration: const Duration(seconds: 1),
                  alignment: Alignment.bottomCenter,
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
