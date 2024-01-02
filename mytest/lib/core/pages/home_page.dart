import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';
import 'package:mytest/app_state.dart';

import 'package:mytest/global_mixins/alert_mixin.dart';

import 'test_detail_navigator.dart';
import '../widgets/test_lisiting_widgets/test_listing_tree.dart';

import 'package:mytest/global_widgets/error_page.dart';
import 'package:mytest/global_widgets/static_loader.dart';

import 'package:mytest/restore.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AlertMixin {

  bool _isShowingDialog = false; // Prevent duplicate errors

  // bool _didRestore = false;
  //
  // Future<String> loadAsset(String filename) async {
  //   return await DefaultAssetBundle.of(context).loadString('assets/$filename.txt');
  // }

  void restore() async {
    // Development.addBackup("古文文法", 0, await loadAsset("kobun"));
    //Development.addBackup("仏教", 1, await loadAsset("bukkyo"));
    // Development.addBackup("神道", 2, await loadAsset("shinto"));
    // Development.addBackup("百人一首", 3, await loadAsset("hyakunin"));
    // Development.addBackup("漢文", 4, await loadAsset("kanbun"));
  }

  @override
  Widget build(BuildContext context) {
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
              return const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [TestListingTree(), Expanded(child: TestDetailNavigator())]
                ),
              );
            }
            else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!_isShowingDialog) {
                  showErrorDialog(context, ErrorType.fetch)
                    .then((_) => _isShowingDialog = false);
                  _isShowingDialog = true;
                }
              });
              return const ErrorPage(margin: EdgeInsets.all(20));
            }
          } else {
            return const StaticLoader();
          }
        }
      ),
    );
  }
}
