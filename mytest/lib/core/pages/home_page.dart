import 'package:flutter/material.dart';
import 'package:mytest/models/models.dart';
import 'package:mytest/constants.dart';
import '../widgets/test_lisiting_widgets/test_listing_tree.dart';
import 'package:mytest/app_state.dart';
import 'test_detail_navigator.dart';
import 'package:mytest/global_mixins/alert_mixin.dart';
import '../../widgets/error_page.dart';
import 'package:mytest/widgets/static_loader.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AlertMixin {

  bool _isShowingDialog = false;

  @override
  Widget build(BuildContext context) {
    if (AppState.selectedTest.value == null && AppState.getAllTests().isNotEmpty) {
      AppState.selectedTest.value = AppState.getAllTests()[0];
    }
    return Scaffold(
      backgroundColor: Constants.white,
      body: FutureBuilder<bool>(
        future: AppState.fetchTests(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null && snapshot.data!) {
              if (AppState.selectedTest.value == null && AppState.getAllTests().isNotEmpty) {
                AppState.selectedTest.value = AppState.getAllTests()[0];
              }
              return Row(
                children: [
                  TestListingTree(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: TestDetailNavigator(),
                    )
                  )
                ],
              );
            }
            else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!_isShowingDialog) {
                  showErrorDialog(context, ErrorType.fetch).then((_) {
                    _isShowingDialog = false;
                  });
                  _isShowingDialog = true;
                }
              });
              return const ErrorPage();
            }
          } else {
            return const StaticLoader();
          }
        }
      ),
    );
  }
}
