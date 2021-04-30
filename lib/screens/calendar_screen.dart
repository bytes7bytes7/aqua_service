import 'package:flutter/material.dart';

class A extends StatelessWidget {

  final ValueNotifier<List<int>> _listNotifier = ValueNotifier([100,100,100]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: _listNotifier,
          builder: (BuildContext context, _, __) {
            return TextButton(
              child: Text(_listNotifier.value.toString()),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => B(listNotifier: _listNotifier)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class B extends StatelessWidget {
  const B({Key key, this.listNotifier}) : super(key: key);

  final ValueNotifier<List<int>> listNotifier;

  _updateNotifier() => listNotifier.value = [0, 100, 100];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text(listNotifier.value.toString()),
          onPressed: () {
            _updateNotifier();
          },
        ),
      ),
    );
  }
}

