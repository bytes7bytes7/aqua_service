// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class SimpleBlocObserver extends BlocObserver {
//   @override
//   void onEvent(Bloc bloc, Object event) => super.onEvent(bloc, event);
//
//   @override
//   void onTransition(Bloc bloc, Transition transition) =>
//       super.onTransition(bloc, transition);
//
//   @override
//   void onError(BlocBase bloc, Object error, StackTrace stackTrace) =>
//       super.onError(bloc, error, stackTrace);
// }
//
// void main() {
//   Bloc.observer = SimpleBlocObserver();
//   runApp(App());
// }
//
// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => BlocProvider(
//         create: (_) => ThemeCubit(),
//         child: BlocBuilder<ThemeCubit, ThemeData>(
//           builder: (_, theme) {
//             return MaterialApp(
//               theme: theme,
//               home: BlocProvider(
//                 create: (_) => CounterBloc(),
//                 child: CounterPage(),
//               ),
//             );
//           },
//         ),
//       );
// }
//
// class CounterPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         body: BlocBuilder<CounterBloc, int>(
//           builder: (_, count) => Center(
//               child:
//                   Text('$count', style: Theme.of(context).textTheme.headline1)),
//         ),
//         floatingActionButton: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5.0),
//               child: FloatingActionButton(
//                 child: const Icon(Icons.add),
//                 onPressed: () =>
//                     context.read<CounterBloc>().add(CounterEvent.increment),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5.0),
//               child: FloatingActionButton(
//                 child: const Icon(Icons.remove),
//                 onPressed: () =>
//                     context.read<CounterBloc>().add(CounterEvent.decrement),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5.0),
//               child: FloatingActionButton(
//                 child: const Icon(Icons.brightness_6),
//                 onPressed: () => context.read<ThemeCubit>().toggleTheme(),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5.0),
//               child: FloatingActionButton(
//                 backgroundColor: Colors.red,
//                 child: const Icon(Icons.error),
//                 onPressed: () =>
//                     context.read<CounterBloc>().add(CounterEvent.error),
//               ),
//             ),
//           ],
//         ),
//       );
// }
//
// enum CounterEvent { increment, decrement, error }
//
// class CounterBloc extends Bloc<CounterEvent, int> {
//   CounterBloc() : super(0);
//
//   @override
//   Stream<int> mapEventToState(CounterEvent event) async* {
//     switch (event) {
//       case CounterEvent.decrement:
//         yield state - 1;
//         break;
//       case CounterEvent.increment:
//         yield state + 1;
//         break;
//       case CounterEvent.error:
//         addError(Exception('unsupported event'));
//     }
//   }
// }
//
// class ThemeCubit extends Cubit<ThemeData> {
//   ThemeCubit() : super(_lightTheme);
//
//   static final _lightTheme = ThemeData(
//     floatingActionButtonTheme:
//         const FloatingActionButtonThemeData(foregroundColor: Colors.white),
//     brightness: Brightness.light,
//   );
//
//   static final _darkTheme = ThemeData(
//     floatingActionButtonTheme:
//         const FloatingActionButtonThemeData(foregroundColor: Colors.black),
//     brightness: Brightness.dark,
//   );
//
//   void toggleTheme() =>
//       emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
// }

import 'package:flutter/material.dart';

void main() => runApp(MyTextFieldApp());

class MyTextFieldApp extends StatelessWidget {
  final ValueNotifier<bool> _textHasErrorNotifier = ValueNotifier(false);

  _updateErrorText(String text) {
    var result = (text == null || text == "");
    _textHasErrorNotifier.value = result;
  }

  Widget _getPrefixText() {
    return Icon(Icons.ac_unit);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
                padding: EdgeInsets.all(24.0),
                child: Center(
                  child: ValueListenableBuilder(
                    valueListenable: _textHasErrorNotifier,
                    child: _getPrefixText(),
                    builder: (BuildContext context, bool hasError, Widget child) {
                      return TextField(
                        onChanged: _updateErrorText,
                        decoration: InputDecoration(
                          prefix: child,
                          fillColor: Colors.grey[100],
                          filled: true,
                          errorText: hasError ? 'Invalid value entered...' : null,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.blueAccent, width: 0.0),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 0.0),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 0.0),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                      );
                    },
                  ),
                )
            )
        )
    );
  }
}
