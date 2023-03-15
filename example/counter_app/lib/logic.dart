// logic.dart

import 'package:flutter/material.dart';
import 'package:reduced/reduced.dart';

class CounterIncremented extends Event<int> {
  @override
  int call(int state) => state + 1;
}

class Props {
  Props({required this.counterText, required this.onPressed});
  final String counterText;
  final Callable<void> onPressed;
}

Props transformer(int state, EventProcessor<int> processor) => Props(
      counterText: '$state',
      onPressed: EventCarrier(processor, CounterIncremented()),
    );

Widget builder({Key? key, required Props props}) => Scaffold(
      appBar: AppBar(title: const Text('reduced_bloc example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(props.counterText),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: props.onPressed,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
