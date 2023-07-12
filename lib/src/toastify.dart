import 'package:flutter/material.dart';

import 'default_toast.dart';

/// Displays a Toast above the current contents of the app.
void showToast(
  BuildContext context,
  Toast toast, {
  AlignmentGeometry alignment = Alignment.topRight,
  double? width,
}) {
  final overlayState = Overlay.of(context, rootOverlay: true);
  final controller = ToastifyController.instance;
  final key = controller.genKey(width, alignment);
  if (!controller.has(key)) {
    final toast = Toastify(
      key: key,
      alignment: alignment,
      width: width,
    );
    controller.add(key, toast);
    final overlayEntry = OverlayEntry(
      builder: (_) => toast,
    );
    toast.overlayEntry = overlayEntry;
    overlayState.insert(overlayEntry);
  }
  WidgetsBinding.instance.addPostFrameCallback((_) {
    controller.get(key).add(toast);
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
    this.duration = const Duration(milliseconds: 300),
  }) : assert(!((title == null || description == null) && child == null)) {
    if (child == null) {
      _child = DefaultToast(toast: this);
    } else {
      _child = child;
    }
  }

  /// This is the ID of the toast, which is used to prevent duplicate toasts.
  final String? id;

  /// The widget below this widget in the tree.
  late final Widget _child;

  /// The widget below this widget in the tree.
  Widget get child => _child;

  /// Toast will be auto close if [lifeTime] != null.
  final Duration? lifeTime;

  /// The duration of toast animation
  final Duration duration;

  /// The custom transition builder
  final Widget Function(
    Animation<double>,
    Widget child,
    bool isRemoving,
  )? transitionBuilder;

  /// The title of toast
  final String? title;

  /// The description of toast
  final String? description;

  /// The leading of toast
  final Widget? leading;
}

class ToastifyController {
  factory ToastifyController._internal() {
    return ToastifyController();
  }

  ToastifyController();

  static final instance = ToastifyController._internal();

  final Map<Key, Toastify> _multiToast = {};

  bool has(Key key) => _multiToast.containsKey(key);

  Key genKey(double? width, AlignmentGeometry alignment) =>
      Key('${width.toString()}_${alignment.toString()}');

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
    this.width,
  });

  /// How to align the toast.
  final AlignmentGeometry alignment;
  final double? width;
  final listKey = GlobalKey<AnimatedListState>();
  final List<Toast> items = [];
  late final OverlayEntry? overlayEntry;

  /// Add new toast
  void add(Toast toast) {
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
        remove(toast.child);
      });
    }
  }

  /// Remove all toasts held by this Toastify.
  void removeAll() {
    while (items.isNotEmpty) {
      remove(items.last.child);
    }
  }

  /// Remove toast
  void remove(Widget toastWidget) {
    final index = items.indexWhere((e) => e.child == toastWidget);
    if (index == -1) return;
    final toast = items[index];
    items.removeAt(index);
    listKey.currentState?.removeItem(
      index,
      (context, animation) => buildItem(animation, toast, true),
      duration: toast.duration,
    );
    Future.delayed(const Duration(seconds: 2) + toast.duration, () {
      if (items.isEmpty && ToastifyController.instance.has(key!)) {
        ToastifyController.instance.remove(key!);
        overlayEntry?.remove();
      }
    });
  }

  static Toastify of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<Toastify>()!;
  }

  /// Build toast item
  Widget buildItem(Animation<double> animation, Toast toast, bool isRemoving) {
    final child = Align(
      alignment: alignment,
      child: toast.child,
    );
    return toast.transitionBuilder?.call(animation, child, isRemoving) ??
        DefaultToastTransition(
          animation: animation,
          child: child,
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        type: MaterialType.transparency,
        child: Align(
          alignment: alignment,
          child: SizedBox(
            width: width,
            child: AnimatedList(
              padding: const EdgeInsets.all(16),
              key: listKey,
              shrinkWrap: true,
              clipBehavior: Clip.none,
              initialItemCount: items.length,
              itemBuilder: (context, index, animation) {
                return buildItem(animation, items[index], false);
              },
            ),
          ),
        ),
      ),
    );
  }
}
