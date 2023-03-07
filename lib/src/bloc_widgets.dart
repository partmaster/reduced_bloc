// bloc_wrapper.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reduced/reduced.dart';

import 'bloc_store.dart';

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

class ReducedConsumer<S, P> extends StatelessWidget {
  const ReducedConsumer({
    super.key,
    required this.transformer,
    required this.builder,
  });

  final ReducedTransformer<S, P> transformer;
  final ReducedWidgetBuilder<P> builder;

  @override
  Widget build(BuildContext context) => BlocSelector<ReducedBloc<S>, S, P>(
        selector: (state) => transformer(context.bloc<S>()),
        builder: (context, props) => builder(props: props),
      );
}
