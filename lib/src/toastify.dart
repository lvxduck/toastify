import 'package:flutter/material.dart';

import 'toast_tile.dart';

void showToast(
  BuildContext context,
  Widget child, {
  Duration? duration,
  AlignmentGeometry alignment = Alignment.topRight,
}) {
  final overlayState = Overlay.of(context, rootOverlay: true);
  final controller = ToastifyController.instance;
  final key = controller.genKey(context, alignment);
  if (!controller.has(key)) {
    final toast = Toastify(alignment: alignment, key: key);
    controller.add(key, toast);
    final overlayEntry = OverlayEntry(
      builder: (_) => toast,
    );
    toast.overlayEntry = overlayEntry;
    overlayState.insert(overlayEntry);
  }
  WidgetsBinding.instance.addPostFrameCallback((_) {
    controller.get(key).addItem(child, duration);
  });
}

class ToastifyController {
  factory ToastifyController._internal() {
    return ToastifyController();
  }

  ToastifyController();

  static final instance = ToastifyController._internal();

  final Map<Key, Toastify> _multiToast = {};

  bool has(Key key) => _multiToast.containsKey(key);

  Key genKey(BuildContext context, AlignmentGeometry alignment) =>
      Key('${context.toString()}_${alignment.toString()}');

  void add(Key key, Toastify toast) {
    _multiToast[key] = toast;
  }

  void remove(Key key) {
    _multiToast.remove(key);
  }

  Toastify get(Key key) => _multiToast[key]!;
}

class Toastify extends StatelessWidget {
  Toastify({
    super.key,
    required this.alignment,
  });

  final AlignmentGeometry alignment;
  final listDuration = const Duration(milliseconds: 260);
  final listKey = GlobalKey<AnimatedListState>();
  final List<Widget> items = [];
  late final OverlayEntry? overlayEntry;

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
      (context, animation) => buildAnimatedItem(animation, item),
      duration: listDuration,
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (items.isEmpty && ToastifyController.instance.has(key!)) {
        overlayEntry?.remove();
        ToastifyController.instance.remove(key!);
      }
    });
  }

  static Toastify of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<Toastify>()!;
  }

  Widget buildAnimatedItem(Animation<double> animation, Widget item) {
    return ToastWrapper(
      animation: animation,
      child: Align(
        alignment: alignment,
        child: item,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: alignment,
        child: AnimatedList(
          padding: const EdgeInsets.all(12),
          key: listKey,
          shrinkWrap: true,
          initialItemCount: items.length,
          itemBuilder: (context, index, animation) {
            return buildAnimatedItem(animation, items[index]);
          },
        ),
      ),
    );
  }
}
