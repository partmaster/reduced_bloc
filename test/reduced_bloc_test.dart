import 'package:bloc_test/bloc_test.dart';
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
    final objectUnderTest = ReducedBloc(0);
    expect(objectUnderTest.state, 0);
  });

  test('ReducibleBloc state 1', () {
    final objectUnderTest = ReducedBloc(1);
    expect(objectUnderTest.state, 1);
  });

  blocTest(
    'emits [1] when Incrementer is added',
    build: () => ReducedBloc(0),
    act: (ReducedStore<int> bloc) => bloc.reduce(Incrementer()),
    expect: () => [1],
  );

  test('ReducibleBloc reduce', () async {
    final objectUnderTest = ReducedBloc(0);
    objectUnderTest.reduce(Incrementer());
    await expectLater(objectUnderTest.stream, emitsInOrder([1]));
    expect(objectUnderTest.state, 1);
  });
}
