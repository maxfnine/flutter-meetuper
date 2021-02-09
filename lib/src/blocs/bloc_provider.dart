import 'package:flutter/material.dart';

Type _typeOf<T>()=>T;

abstract class BlocBase{
  void dispose();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final T bloc;
  final Widget child;
  BlocProvider({Key key,@required this.child, @required this.bloc}):super(key: key);

  @override
  State<StatefulWidget> createState()=>_BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    Type type= _typeOf<_BlocProviderInherited<T>>();
    _BlocProviderInherited provider =
    (context.ancestorInheritedElementForWidgetOfExactType(type)?.widget
    as _BlocProviderInherited<T>);

    return provider?.bloc;
  }

}

class _BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {
  dispose(){
    widget.bloc?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return _BlocProviderInherited<T>(child: widget.child, bloc: widget.bloc);
  }
}

class _BlocProviderInherited<T> extends InheritedWidget{
  final T bloc;
  _BlocProviderInherited({Key key,@required Widget child,@required this.bloc}):super(key:key,child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget)=>true;
}


