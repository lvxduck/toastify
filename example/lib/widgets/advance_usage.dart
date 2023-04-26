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
              const CustomInfoToast(
                title: 'Hello, Flutter dev!',
                description: 'This is a custom info toast',
              ),
            );
          },
          child: const Text('Show custom info toast'),
        ),
        ElevatedButton(
          onPressed: () {
            showToast(
              context,
              const CustomInfoToast(
                key: Key('value'),
                title: 'Hello, Flutter dev!',
                description: 'Prevent duplicate toast',
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
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16) - const EdgeInsets.only(right: 16),
        child: Row(
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
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Toastify.of(context).removeItem(this);
              },
              icon: const Icon(Icons.close),
              splashRadius: 24,
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
