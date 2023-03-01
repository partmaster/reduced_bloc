# reduced_bloc

Implementation of the 'reduced' API für the 'Bloc' state management framework with following features:

1. Implementation of the ```Reducible``` interface 
2. Extension on the ```BuildContext``` for convenient access to the  ```Reducible``` instance.
3. Register a state for management.
4. Trigger a rebuild on widgets selectively after a state change.

## Features

#### 1. Implementation of the ```Reducible``` interface 

```dart
class ReducibleBloc<S> extends Bloc<Reducer<S>, S>
    implements Reducible<S> {

  ReducibleBloc(super.initialState) {
    on<Reducer<S>>((event, emit) => emit(event(state)));
  }

  @override reduce(reducer) => add(reducer);

  late final reducible = this;
}
```

#### 2. Extension on the ```BuildContext``` for convenient access to the  ```Reducible``` instance.

```dart
extension ExtensionBlocOnBuildContext on BuildContext {
  ReducibleBloc<S> bloc<S>() =>
      BlocProvider.of<ReducibleBloc<S>>(this);
}
```

#### 3. Register a state for management.

```dart
Widget wrapWithProvider<S>({
  required S initialState, 
  required Widget child,
});
```

#### 4. Trigger a rebuild on widgets selectively after a state change.

```dart
extension WrapWithConsumer<S> on ReducibleBloc<S> {
  Widget wrapWithConsumer<P>({
    required ReducedTransformer<S, P> transformer,
    required ReducedWidgetBuilder<P> builder,
  });
}
```

## Getting started

In the pubspec.yaml add dependencies on the package 'reduced' and on the package of an implementation of the 'reduced' API for a state management framework, e.g. 'reduced_bloc'.

```
dependencies:
  reduced: ^0.1.0
  reduced_bloc: ^0.1.0
  bloc: ^8.1.1
  flutter_bloc: ^8.1.2
```

Import package 'reduced' to implement the logic.

```dart
import 'package:reduced/reduced.dart';
```

Import choosen implementation package for the 'reduced' API to use the logic, e.g.

```dart
import 'package:reduced_bloc/reduced_bloc.dart';
```

## Usage

Implementation of the counter demo app logic with the 'reduced' API without further dependencies on state management packages.

```dart
// logic.dart

import 'package:flutter/material.dart';
import 'package:reduced/reduced.dart';

class Incrementer extends Reducer<int> {
  int call(int state) => state + 1;
}

class Props {
  Props({required this.counterText, required this.onPressed});
  final String counterText;
  final Callable<void> onPressed;
}

Props transformer(Reducible<int> reducible) => Props(
      counterText: '${reducible.state}',
      onPressed: CallableAdapter(reducible, Incrementer()),
    );

Widget builder({Key? key, required Props props}) => Scaffold(
      appBar: AppBar(title: Text('reduced_bloc example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text('${props.counterText}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: props.onPressed,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
```

Finished counter demo app using logic.dart and 'reduced_bloc' package:

```dart
// main.dart

import 'package:flutter/material.dart';
import 'package:reduced/reduced.dart';
import 'package:reduced_bloc/reduced_bloc.dart';
import 'logic.dart';

void main() => runApp(
      wrapWithProvider(
        initialState: 0,
        child: MaterialApp(
          theme: ThemeData(primarySwatch: Colors.blue),
          home: Builder(
            builder: (context) =>
                context.bloc<int>().wrapWithConsumer(
                      transformer: transformer,
                      builder: builder,
                    ),
          ),
        ),
      ),
    );
```

# Additional information

Implementations of the 'reduced' API are available for the following state management frameworks:

|Framework|implementation package for 'reduced' API|
|---|---|
|[Bloc](https://bloclibrary.dev/#/)|[reduced_bloc]()|
