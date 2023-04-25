import 'package:flutter/material.dart';

import 'toast_tile.dart';

void showToast(
  BuildContext context,
  Widget child,
) {
  _showToast(context, child);
}

void _showToast(BuildContext context, Widget child) {
  final overlayState = Overlay.of(context, rootOverlay: true);
  final controller = ToastifyController.instance;
  if (controller.isInit(context)) {
    controller.multiToast[context]?.addItem(child);
  } else {
    final toast = Toastify();
    controller.add(context, toast);
    final overlayEntry = OverlayEntry(
      builder: (_) => toast,
    );
    overlayState.insert(overlayEntry);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.multiToast[context]?.addItem(child);
    });
  }
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

  final listKey = GlobalKey<AnimatedListState>();
  final List<Widget> items = [];

  void addItem(Widget item) {
    if (items.contains(item)) return;
    items.insert(0, item);
    listKey.currentState!.insertItem(0);
    Future.delayed(const Duration(milliseconds: 1000), () {
      // removeItem(item);
    });
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
