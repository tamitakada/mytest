import 'package:flutter/material.dart';

import 'package:mytest/abstract_classes/counter_listener.dart';


class Counter extends StatefulWidget {

  final CounterListener listener;

  const Counter({ super.key, required this.listener });

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {

  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            widget.listener.valueChanged(_counter + 1);
            setState(() { _counter++; });
          },
          icon: Icon(Icons.arrow_drop_up)
        ),
        Text('$_counter'),
        IconButton(
          onPressed: () {
            widget.listener.valueChanged(_counter - 1);
            setState(() { _counter--; });
          },
          icon: Icon(Icons.arrow_drop_down)
        )
      ]
    );
  }
}
