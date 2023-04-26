import 'dart:math';

import 'package:flutter/material.dart';
import 'package:toastify/toastify.dart';

class BasicUsage extends StatefulWidget {
  const BasicUsage({Key? key}) : super(key: key);

  @override
  State<BasicUsage> createState() => _BasicUsageState();
}

class _BasicUsageState extends State<BasicUsage> {
  Alignment? alignment = Alignment.topRight;
  bool autoClose = false;
  bool showLeading = false;
  double lifeTime = 100;
  double duration = 200;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic usage',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 18,
          ),
        ),
        ListTile(
          title: Row(
            children: [
              const Text('Alignment'),
              const Spacer(),
              DropdownButton(
                value: alignment,
                items: [
                  Alignment.topLeft,
                  Alignment.topCenter,
                  Alignment.topRight,
                  Alignment.centerRight,
                  Alignment.centerLeft,
                  Alignment.center,
                  Alignment.bottomLeft,
                  Alignment.bottomRight,
                  Alignment.bottomCenter,
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
        SwitchListTile(
          value: showLeading,
          onChanged: (value) => setState(() => showLeading = value),
          title: const Text('Show leading'),
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
        ListTile(
          title: Text('Duration: ${duration.toInt()} ms'),
          subtitle: Slider(
            value: duration,
            onChanged: (value) => setState(() => duration = value),
            min: 100,
            max: 2000,
            divisions: 10,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final id = Random().nextInt(100);
            showToast(
              context,
              Toast(
                title: 'Basic toast',
                width: 320,
                leading: showLeading
                    ? const Icon(
                        Icons.info,
                        color: Colors.blue,
                      )
                    : null,
                description: 'This is a basic toast $id '
                    '${autoClose ? '. It will close after ${lifeTime.toInt()} ms' : ''}',
              ),
              alignment: alignment ?? Alignment.topRight,
              duration: Duration(milliseconds: duration.toInt()),
              lifeTime: autoClose
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
