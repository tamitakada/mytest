import 'package:flutter/material.dart';
import 'package:mytest/models/models.dart';
import 'package:mytest/constants.dart';
import '../widgets/test_lisiting_widgets/test_listing_tree.dart';
import 'package:mytest/app_state.dart';
import 'test_detail_navigator.dart';
import 'package:mytest/global_mixins/alert_mixin.dart';
import 'error_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AlertMixin {

  final ValueNotifier<Test?> _selectedTest = ValueNotifier(null);
  bool _isShowingDialog = false;

  @override
  Widget build(BuildContext context) {
    if (_selectedTest.value == null && AppState.testsInitialized && AppState.getAllTests().isNotEmpty) {
      _selectedTest.value = AppState.getAllTests()[0];
    }
    return Scaffold(
      backgroundColor: Constants.white,
      body: AppState.testsInitialized
        ? Row(
          children: [
            TestListingTree(
              selectedTest: _selectedTest,
              onSelect: (test) => setState(() => _selectedTest.value = test)
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TestDetailNavigator(selectedTest: _selectedTest),
              )
            )
          ],
        )
         : FutureBuilder<bool>(
          future: AppState.fetchTests(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null && snapshot.data!) {
                if (_selectedTest.value == null && AppState.getAllTests().isNotEmpty) {
                  _selectedTest.value = AppState.getAllTests()[0];
                }
                return Row(
                  children: [
                    TestListingTree(
                      selectedTest: _selectedTest,
                      onSelect: (test) => setState(() => _selectedTest.value = test)
                    ),
                    Expanded(child: TestDetailNavigator(selectedTest: _selectedTest,))
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
              return Text("loading"); // TODO: load
            }
          }
        ),
    );
  }
}
