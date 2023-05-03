import 'dart:math';

import 'package:flutter/material.dart';
import 'package:toastify/toastify.dart';

class AdvanceUsage extends StatefulWidget {
  const AdvanceUsage({Key? key}) : super(key: key);

  @override
  State<AdvanceUsage> createState() => _AdvanceUsageState();
}

class _AdvanceUsageState extends State<AdvanceUsage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Advance usage',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            showToast(
              context,
              Toast(
                child: CustomInfoToast(
                  title: 'Hello, Flutter dev! ${Random().nextInt(10)}',
                  description: 'This is a custom info toast. '
                      'It has button confirm to close toast and distroy all',
                ),
              ),
            );
          },
          child: const Text('Show custom info toast'),
        ),
        ElevatedButton(
          onPressed: () {
            showToast(
              context,
              Toast(
                id: '_toast',
                child: const CustomInfoToast(
                  title: 'Hello, Flutter dev!',
                  description: 'Prevent duplicate toast',
                ),
              ),
            );
          },
          child: const Text('Prevent duplicate toast'),
        ),
      ],
    );
  }
}

class CustomInfoToast extends StatelessWidget {
  const CustomInfoToast({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 420,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
          )
        ],
      ),
      margin: const EdgeInsets.all(6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.info,
                  color: Colors.blue,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        overflow: TextOverflow.visible,
                        maxLines: 3,
                        style: const TextStyle(height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Toastify.of(context).removeAll();
                  },
                  child: const Text('Destroy All'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    Toastify.of(context).removeItem(this);
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
