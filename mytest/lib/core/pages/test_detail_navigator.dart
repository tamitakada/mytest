import 'package:flutter/material.dart';

import 'subpages.dart';


class TestDetailNavigator extends StatelessWidget {

  const TestDetailNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'test_detail/home',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'test_detail/home':
            builder = (context) => const TestHomeSubpage();
            break;
          case 'test_detail/stats':
            builder = (context) => const TestStatsSubpage();
            break;
          case 'test_detail/settings':
            builder = (context) => const TestSettingsSubpage();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute<void>(builder: builder, settings: settings);
      },
    );
  }
}
