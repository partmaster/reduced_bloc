![GitHub release (latest by date)](https://img.shields.io/github/v/release/partmaster/reduced_bloc)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/partmaster/reduced_bloc/dart.yml)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/partmaster/reduced_bloc)
![GitHub last commit](https://img.shields.io/github/last-commit/partmaster/reduced_bloc)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/partmaster/reduced_bloc)
# reduced_bloc

Implementation of the 'reduced' API for the 'Bloc' state management framework with following features:

1. Implementation of the ```Store``` interface 
2. Extension on the ```BuildContext``` for convenient access to the  ```Store``` instance.
3. Register a state for management.
4. Trigger a rebuild on widgets selectively after a state change.

## Features

#### 1. Implementation of the ```Store``` interface 

```dart
class ReducedBloc<S> extends Bloc<Event<S>, S> implements Store<S> {
  ReducedBloc(super.initialState) {
    on<Event<S>>((event, emit) => emit(event(state)));
  }

  @override
  process(event) => add(event);
}
```

#### 2. Extension on the ```BuildContext``` for convenient access to the  ```Reducible``` instance.

```dart
extension ExtensionBlocOnBuildContext on BuildContext {
  ReducedBloc<S> bloc<S>() => BlocProvider.of<ReducedBloc<S>>(this);
}
```

#### 3. Register a state for management.

```dart
class ReducedProvider<S> extends StatelessWidget {
  const ReducedProvider({
    super.key,
    required this.initialState,
    required this.child,
  });

  final S initialState;
  final Widget child;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => ReducedBloc(initialState),
        child: child,
      );
}
```

#### 4. Trigger a rebuild on widgets selectively after a state change.

```dart
class ReducedConsumer<S, P> extends StatelessWidget {
  const ReducedConsumer({
    super.key,
    required this.mapper,
    required this.builder,
  });

  final StateToPropsMapper<S, P> mapper;
  final WidgetFromPropsBuilder<P> builder;

  @override
  Widget build(BuildContext context) => _build(context.bloc());

  Widget _build(Store<S> store) => BlocSelector<ReducedBloc<S>, S, P>(
        selector: (state) => mapper(store.state, store),
        builder: (context, props) => builder(props: props),
      );
}
```

## Getting started

In the pubspec.yaml add dependencies on the package 'reduced' and on the package  'reduced_bloc'.

```
dependencies:
  reduced: 0.4.0
  reduced_bloc: 
    git:
      url: https://github.com/partmaster/reduced
      ref: v0.4.0-beta.1
  bloc: ^8.1.1
  flutter_bloc: ^8.1.2
```

Import package 'reduced' to implement the logic.

```dart
import 'package:reduced/reduced.dart';
```

Import package 'reduced' to use the logic.

```dart
import 'package:reduced_bloc/reduced_bloc.dart';
```

## Usage

Implementation of the counter demo app logic with the 'reduced' API without further dependencies on state management packages.

```dart
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
```

Finished counter demo app using logic.dart and 'reduced_bloc' package:

```dart
// main.dart

import 'package:flutter/material.dart';
import 'package:reduced_bloc/reduced_bloc.dart';
import 'logic.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ReducedProvider(
        initialState: 0,
        child: MaterialApp(
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const ReducedConsumer(
            mapper: transformer,
            builder: builder,
          ),
        ),
      );
}
```

# Additional information

Implementations of the 'reduced' API are available for the following state management frameworks:

|framework|implementation package for 'reduced' API|
|---|---|
|[Binder](https://pub.dev/packages/binder)|[reduced_binder](https://github.com/partmaster/reduced_binder)|
|[Bloc](https://bloclibrary.dev/#/)|[reduced_bloc](https://github.com/partmaster/reduced_bloc)|
|[FlutterCommand](https://pub.dev/packages/flutter_command)|[reduced_fluttercommand](https://github.com/partmaster/reduced_fluttercommand)|
|[FlutterTriple](https://pub.dev/packages/flutter_triple)|[reduced_fluttertriple](https://github.com/partmaster/reduced_fluttertriple)|
|[GetIt](https://pub.dev/packages/get_it)|[reduced_getit](https://github.com/partmaster/reduced_getit)|
|[GetX](https://pub.dev/packages/get)|[reduced_getx](https://github.com/partmaster/reduced_getx)|
|[MobX](https://pub.dev/packages/mobx)|[reduced_mobx](https://github.com/partmaster/reduced_mobx)|
|[Provider](https://pub.dev/packages/provider)|[reduced_provider](https://github.com/partmaster/reduced_provider)|
|[Redux](https://pub.dev/packages/redux)|[reduced_redux](https://github.com/partmaster/reduced_redux)|
|[Riverpod](https://riverpod.dev/)|[reduced_riverpod](https://github.com/partmaster/reduced_riverpod)|
|[Solidart](https://pub.dev/packages/solidart)|[reduced_solidart](https://github.com/partmaster/reduced_solidart)|
|[StatesRebuilder](https://pub.dev/packages/states_rebuilder)|[reduced_statesrebuilder](https://github.com/partmaster/reduced_statesrebuilder)|
