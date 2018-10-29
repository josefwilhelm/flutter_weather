import 'package:flutter/material.dart';

abstract class BlocBase {
  void dispose();
}

// Generic BLoC provider
class BlocProviderGeneric<T extends BlocBase> extends StatefulWidget {
  BlocProviderGeneric({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  final T bloc;
  final Widget child;

  @override
  _BlocProviderGenericState<T> createState() => _BlocProviderGenericState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProviderGeneric<T>>();
    BlocProviderGeneric<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderGenericState<T>
    extends State<BlocProviderGeneric<BlocBase>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
