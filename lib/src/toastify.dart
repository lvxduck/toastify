import 'package:flutter/material.dart';

import 'toast_tile.dart';

void showToast(
  BuildContext context,
  Toast toast, {
  AlignmentGeometry alignment = Alignment.topRight,
}) {
  final overlayState = Overlay.of(context, rootOverlay: true);
  final controller = ToastifyController.instance;
  final key = controller.genKey(context, alignment);
  if (!controller.has(key)) {
    final toast = Toastify(
      key: key,
      alignment: alignment,
    );
    controller.add(key, toast);
    final overlayEntry = OverlayEntry(
      builder: (_) => toast,
    );
    toast.overlayEntry = overlayEntry;
    overlayState.insert(overlayEntry);
  }
  WidgetsBinding.instance.addPostFrameCallback((_) {
    controller.get(key).addItem(toast);
  });
}

class Toast {
  Toast({
    this.id,
    Widget? child,
    this.lifeTime,
    this.transitionBuilder,
    this.title,
    this.description,
    this.leading,
    this.width,
    this.duration = const Duration(milliseconds: 300),
  }) {
    if (child == null) {
      _child = DefaultToast(toast: this);
    } else {
      _child = child;
    }
  }

  final String? id;
  late final Widget _child;

  Widget get child => _child;
  final Duration? lifeTime;
  final Duration duration;
  final Widget Function(Animation<double>, Widget child)? transitionBuilder;
  final String? title;
  final String? description;
  final Widget? leading;
  final double? width;
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
  final listKey = GlobalKey<AnimatedListState>();
  final List<Toast> items = [];
  late final OverlayEntry? overlayEntry;

  void addItem(Toast toast) {
    // Toast child is duplicate because child is constant
    if (items.where((e) => e.child == toast.child).isNotEmpty) {
      return;
    }
    // Toast child is duplicate by id
    if (toast.id != null && items.where((e) => e.id == toast.id).isNotEmpty) {
      return;
    }
    items.insert(0, toast);
    listKey.currentState!.insertItem(0, duration: toast.duration);
    if (toast.lifeTime != null) {
      Future.delayed(toast.lifeTime! + toast.duration, () {
        removeItem(toast.child);
      });
    }
  }

  void removeAll() {
    while (items.isNotEmpty) {
      removeItem(items.last.child);
    }
  }

  void removeItem(Widget toastWidget) {
    final index = items.indexWhere((e) => e.child == toastWidget);
    if (index == -1) return;
    final toast = items[index];
    items.removeAt(index);
    listKey.currentState?.removeItem(
      index,
      (context, animation) => buildAnimatedItem(animation, toast),
      duration: toast.duration,
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

  Widget buildAnimatedItem(Animation<double> animation, Toast toast) {
    final child = Align(
      alignment: alignment,
      child: toast.child,
    );
    return toast.transitionBuilder?.call(animation, child) ??
        ToastTransition(
          animation: animation,
          child: child,
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: alignment,
        child: Material(
          color: Colors.transparent,
          child: AnimatedList(
            padding: const EdgeInsets.all(16),
            key: listKey,
            shrinkWrap: true,
            initialItemCount: items.length,
            itemBuilder: (context, index, animation) {
              return buildAnimatedItem(animation, items[index]);
            },
          ),
        ),
      ),
    );
  }
}
