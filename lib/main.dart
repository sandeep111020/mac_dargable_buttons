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
        body: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.bottomCenter,
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
  Offset position = Offset.zero;
double paddingValue=32;
GlobalKey _widgetKey = GlobalKey();

@override
  void initState() {
    super.initState();
    // Fetch the position after the widget is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWidgetPosition();
    });
  }

 void _fetchWidgetPosition() {
    // Get the RenderBox of the widget
    final RenderBox renderBox =
        _widgetKey.currentContext?.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      position = offset; // Update the position
    });
  }
  @override
  Widget build(BuildContext context) {
    return Draggable(
      key: _widgetKey,
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
            childWhenDragging: Container(
              margin: EdgeInsets.all(paddingValue),
            ),
            onDragUpdate: (details) {
             double temp = position.dy-details.localPosition.dy;
              
              if(temp<40 && temp>-40){
              setState(() {
                paddingValue= 40-temp.abs();
                paddingValue= paddingValue.abs();
              });
              }else{
                paddingValue=10;
              }
            },
            onDragEnd: (details) {
              setState(() {
                position = details.offset;
                paddingValue=32;
              });
            },
          );
       
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
      height: 100,
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
