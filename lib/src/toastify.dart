import 'package:flutter/material.dart';

import 'toast_tile.dart';

void showToast(
  BuildContext context,
  Widget child, {
  Duration? duration,
}) {
  final overlayState = Overlay.of(context, rootOverlay: true);
  final controller = ToastifyController.instance;
  if (!controller.isInit(context)) {
    final toast = Toastify();
    controller.add(context, toast);
    final overlayEntry = OverlayEntry(
      builder: (_) => toast,
    );
    overlayState.insert(overlayEntry);
  }
  WidgetsBinding.instance.addPostFrameCallback((_) {
    controller.multiToast[context]?.addItem(child, duration);
  });
}

class ToastifyController {
  factory ToastifyController._internal() {
    return ToastifyController();
  }

  ToastifyController();

  static final instance = ToastifyController._internal();

  Map<BuildContext, Toastify> multiToast = {};

  bool isInit(BuildContext context) {
    return multiToast.containsKey(context);
  }

  void add(BuildContext context, Toastify toast) {
    multiToast[context] = toast;
  }
}

class Toastify extends StatelessWidget {
  Toastify({super.key});

  final listDuration = const Duration(milliseconds: 260);
  final listKey = GlobalKey<AnimatedListState>();
  final List<Widget> items = [];

  void addItem(Widget item, Duration? duration) {
    if (items.contains(item)) return;
    items.insert(0, item);
    listKey.currentState!.insertItem(0, duration: listDuration);
    if (duration != null) {
      Future.delayed(duration + listDuration, () {
        removeItem(item);
      });
    }
  }

  void removeItem(Widget item) {
    final index = items.indexOf(item);
    if (index == -1) return;
    items.removeAt(index);
    listKey.currentState?.removeItem(
      index,
      (context, animation) => ToastWrapper(
        animation: animation,
        child: item,
      ),
      duration: listDuration,
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      if (items.isEmpty) {
        // remove overlayState
      }
    });
  }

  static Toastify of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<Toastify>()!;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        width: 420,
        child: AnimatedList(
          padding: const EdgeInsets.all(12),
          key: listKey,
          shrinkWrap: true,
          initialItemCount: items.length,
          itemBuilder: (context, index, animation) {
            return ToastWrapper(
              animation: animation,
              child: items[index],
            );
          },
        ),
      ),
    );
  }
}
