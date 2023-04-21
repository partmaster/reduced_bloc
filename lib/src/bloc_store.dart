// bloc_store.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reduced/reduced.dart';

/// Derivation of the class [Bloc] with support of the [Store] interface.
class ReducedBloc<S> extends Bloc<Event<S>, S> implements Store<S> {
  /// Accept events of type [Event] by executing the [Event.call].
  ReducedBloc(super.initialState) {
    on<Event<S>>((event, emit) => emit(event(state)));
  }

  @override
  process(event) => add(event);

  @override
  StoreSnapshot<S> get snapshot => StoreSnapshot(state, this);
}

extension ExtensionBlocOnBuildContext on BuildContext {
  /// Convenience method for getting a [ReducedBloc] instance.
  ReducedBloc<S> bloc<S>() => BlocProvider.of<ReducedBloc<S>>(this);
}
