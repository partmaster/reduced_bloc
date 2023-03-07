// bloc_wrapper.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reduced/reduced.dart'
    show ReducedWidgetBuilder, ReducedTransformer;

import 'bloc_reducible.dart';

Widget wrapWithProvider<S>({
  required S initialState,
  required Widget child,
}) =>
    BlocProvider(
      create: (_) => ReducibleBloc(initialState),
      child: child,
    );

Widget wrapWithConsumer<S, P>({
  required ReducedTransformer<S, P> transformer,
  required ReducedWidgetBuilder<P> builder,
}) =>
    Builder(
      builder: (context) => internalWrapWithConsumer(
        transformer: transformer,
        bloc: context.bloc<S>(),
        builder: builder,
      ),
    );

@visibleForTesting
BlocSelector<ReducibleBloc<S>, S, P> internalWrapWithConsumer<S, P>({
  required ReducibleBloc<S> bloc,
  required ReducedTransformer<S, P> transformer,
  required ReducedWidgetBuilder<P> builder,
}) =>
    BlocSelector<ReducibleBloc<S>, S, P>(
      selector: (state) => transformer(bloc),
      builder: (context, props) => builder(props: props),
    );
