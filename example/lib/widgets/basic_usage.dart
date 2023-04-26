import 'dart:math';

import 'package:flutter/material.dart';
import 'package:toastify/toastify.dart';

class BasicUsage extends StatefulWidget {
  const BasicUsage({Key? key}) : super(key: key);

  @override
  State<BasicUsage> createState() => _BasicUsageState();
}

class _BasicUsageState extends State<BasicUsage> {
  Alignment? alignment;
  bool autoClose = false;
  double lifeTime = 100;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Row(
            children: [
              const Text('Alignment'),
              const Spacer(),
              DropdownButton(
                value: alignment,
                items: [
                  Alignment.topRight,
                  Alignment.topLeft,
                  Alignment.topCenter,
                  Alignment.centerRight,
                  Alignment.center,
                ]
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.toString().split('.').last),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    alignment = value;
                  });
                },
              ),
            ],
          ),
        ),
        ListTile(
          title: Row(
            children: [
              Expanded(
                child: Text(
                  'Auto close ${autoClose ? 'after ${lifeTime.toInt()} ms' : ''}',
                ),
              ),
              Switch(
                value: autoClose,
                onChanged: (value) => setState(() => autoClose = value),
              ),
            ],
          ),
          horizontalTitleGap: 0,
          subtitle: autoClose
              ? Slider(
                  value: lifeTime,
                  onChanged: (value) => setState(() => lifeTime = value),
                  min: 100,
                  max: 2000,
                  divisions: 10,
                )
              : null,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final id = Random().nextInt(100);
            showToast(
              context,
              Toast(
                title: 'Basic toast',
                description: 'This is a basic toast $id '
                    '${autoClose ? '. It will close after ${lifeTime.toInt()} ms' : ''}',
              ),
              alignment: alignment ?? Alignment.topRight,
              duration: autoClose
                  ? Duration(
                      milliseconds: lifeTime.toInt(),
                    )
                  : null,
            );
          },
          child: const Text('Show basic toast'),
        ),
      ],
    );
  }
}
