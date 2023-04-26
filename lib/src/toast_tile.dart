import 'package:flutter/material.dart';

import '../toastify.dart';

class Toast extends StatelessWidget {
  const Toast({
    Key? key,
    required this.title,
    required this.description,
    this.leading,
    this.width,
  }) : super(key: key);

  final String title;
  final String description;
  final Widget? leading;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final child = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16) - const EdgeInsets.only(right: 16),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 16),
            ] else
              const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
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
    if (width == null) {
      return child;
    }
    return SizedBox(
      width: width,
      child: child,
    );
  }
}

class ToastWrapper extends StatelessWidget {
  const ToastWrapper({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key);
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: child,
    );
  }
}
