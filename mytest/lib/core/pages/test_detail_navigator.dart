import 'package:flutter/material.dart';
import 'package:mytest/models/test.dart';
import 'test_home_subpage.dart';
import 'test_settings_subpage.dart';
import 'test_stats_subpage.dart';


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
            builder = (context) => TestHomeSubpage();
            break;
          case 'test_detail/stats':
            builder = (BuildContext context) => TestStatsSubpage();
            break;
          case 'test_detail/settings':
            builder = (BuildContext context) => TestSettingsSubpage();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute<void>(builder: builder, settings: settings);
      },
    );
  }
}
