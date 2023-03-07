// bloc_store.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reduced/reduced.dart';

/// Derivation of the class [Bloc] with support of the [ReducedStore] interface.
class ReducedBloc<S> extends Bloc<Reducer<S>, S> implements ReducedStore<S> {
  /// Accept events of type  [Reducer] by executing the [Reducer.call].
  ReducedBloc(super.initialState) {
    on<Reducer<S>>((event, emit) => emit(event(state)));
  }

  @override
  reduce(reducer) => add(reducer);
}

extension ExtensionBlocOnBuildContext on BuildContext {
  /// Convenience method for getting a [ReducedBloc] instance.
  ReducedBloc<S> bloc<S>() => BlocProvider.of<ReducedBloc<S>>(this);
}
