import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class WidgetTestBuilder extends StatelessWidget {
  final Widget _widget;
  final AsyncValueGetter<List<SingleChildWidget>> providers;

  WidgetTestBuilder(
    this._widget, {
    this.providers,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: providers ?? Future.value([Provider.value(value: '')]),
      builder: (context, AsyncSnapshot<List<SingleChildWidget>> snapshot) {
        if (snapshot.hasData) {
          return MultiProvider(
            providers: snapshot.data,
            child: MaterialApp(
              home: Scaffold(
                body: _widget,
              ),
            ),
          );
        }
        return SizedBox(
          child: CircularProgressIndicator(),
          width: 60,
          height: 60,
        );
      },
    );
  }
}
