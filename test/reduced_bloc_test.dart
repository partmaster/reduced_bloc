import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reduced/reduced.dart';

import 'package:reduced_bloc/reduced_bloc.dart';

class Incrementer extends Reducer<int> {
  @override
  int call(int state) {
    return state + 1;
  }
}

void main() {
  test('ReducibleBloc state 0', () {
    final objectUnderTest = ReducibleBloc(0);
    expect(objectUnderTest.state, 0);
  });

  test('ReducibleBloc state 1', () {
    final objectUnderTest = ReducibleBloc(1);
    expect(objectUnderTest.state, 1);
  });

  blocTest(
    'emits [1] when Incrementer is added',
    build: () => ReducibleBloc(0),
    act: (Reducible<int> bloc) => bloc.reduce(Incrementer()),
    expect: () => [1],
  );

  test('ReducibleBloc reduce', () async {
    final objectUnderTest = ReducibleBloc(0);
    objectUnderTest.reduce(Incrementer());
    await expectLater(objectUnderTest.stream, emitsInOrder([1]));
    expect(objectUnderTest.state, 1);
  });

  test('wrapWithProvider', () {
    const child = SizedBox();
    final objectUnderTest = wrapWithProvider(
      initialState: 0,
      child: child,
    );
    expect(objectUnderTest, isA<BlocProvider<ReducibleBloc<int>>>());
    final provider = objectUnderTest as BlocProvider<ReducibleBloc<int>>;
    expect(provider.child, child);
  });

  test('wrapWithConsumer', () {
    const child = SizedBox();
    final objectUnderTest = wrapWithConsumer(
      builder: ({Key? key, required int props}) => child,
      transformer: (reducible) => 1,
    );
    expect(objectUnderTest, isA<BlocSelector<ReducibleBloc<int>, int, int>>());
    final consumer =
        objectUnderTest as BlocSelector<ReducibleBloc<int>, int, int>;
    expect(consumer.selector(-1), 1);
  });
}
