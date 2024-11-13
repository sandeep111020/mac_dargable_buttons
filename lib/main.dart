import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (e) {
              return DragableComponent(e: e);
            },
          ),
        ),
      ),
    );
  }
}

class DragableComponent extends StatefulWidget {
  final IconData e;
  const DragableComponent({
    super.key,
    required this.e,
  });
  @override
  State<DragableComponent> createState() => _DragableComponentState();
}

class _DragableComponentState extends State<DragableComponent> {
  Offset position = Offset(20.0, 20.0);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: position.dx,
        top: position.dy,
        child: Draggable(
            feedback: Container(
              constraints: const BoxConstraints(minWidth: 48),
              height: 48,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors
                    .primaries[widget.e.hashCode % Colors.primaries.length],
              ),
              child: Center(child: Icon(widget.e, color: Colors.white)),
            ),
            child: Container(
              constraints: const BoxConstraints(minWidth: 48),
              height: 48,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors
                    .primaries[widget.e.hashCode % Colors.primaries.length],
              ),
              child: Center(child: Icon(widget.e, color: Colors.white)),
            ),
            childWhenDragging: Container(),
            onDragEnd: (details) {
              setState(() {
                position = details.offset;
              });
            }));
  }
}

/// Dock of the reorderable [items].
class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T> extends State<Dock<T>> {
  /// [T] items being manipulated.
  late final List<T> _items = widget.items.toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _items.map(widget.builder).toList(),
      ),
    );
  }
}
