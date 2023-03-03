// bloc_reducible.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reduced/reduced.dart';

/// Derivation of the class [Bloc] with support of the [Reducible] interface.
class ReducibleBloc<S> extends Bloc<Reducer<S>, S> implements Reducible<S> {
  /// Accept events of type  [Reducer] by executing the [Reducer.call].
  ReducibleBloc(super.initialState) {
    on<Reducer<S>>((event, emit) => emit(event(state)));
  }

  @override
  reduce(reducer) => add(reducer);
}

extension ExtensionBlocOnBuildContext on BuildContext {
  /// Convenience method for getting a [ReducibleBloc] instance.
  ReducibleBloc<S> bloc<S>() => BlocProvider.of<ReducibleBloc<S>>(this);
}
