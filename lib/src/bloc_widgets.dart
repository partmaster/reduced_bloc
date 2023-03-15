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
