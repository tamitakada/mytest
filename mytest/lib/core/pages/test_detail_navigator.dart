import 'package:flutter/material.dart';
import 'package:mytest/models/test.dart';
import 'test_home_subpage.dart';


class TestDetailNavigator extends StatelessWidget {

  final ValueNotifier<Test?> selectedTest;

  const TestDetailNavigator({
    super.key,
    required this.selectedTest
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'test_detail/home',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'test_detail/home':
            builder = (context) => TestHomeSubpage(test: selectedTest);
            break;
          case 'test_detail/stats':
            builder = (BuildContext context) => Container();
            break;
          case 'test_detail/settings':
            builder = (BuildContext context) => Container();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute<void>(builder: builder, settings: settings);
      },
    );
  }
}
