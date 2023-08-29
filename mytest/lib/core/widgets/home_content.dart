import 'package:flutter/material.dart';

import 'package:mytest/abstract_classes/overlay_manager.dart';
import 'package:mytest/widgets/mt_text_field.dart';

import 'package:mytest/models/models.dart';
import 'package:mytest/utils/data_manager.dart';

import 'test_list_tile.dart';


class HomePageContent extends StatefulWidget {

  final OverlayManager manager;

  const HomePageContent({ super.key, required this.manager });

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 80, 30, 0),
      child: Column(
        children: [
          Text(
            "マイテスト",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: MTTextField()
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: widget.manager.openOverlay
                )
              ]
            ),
          ),
          FutureBuilder<List<Test>?>(
            future: DataManager.getAllTests(),
            builder: (BuildContext context, AsyncSnapshot<List<Test>?> snapshot) {
              if (snapshot.hasData) {
                List<Test> tests = snapshot.data ?? [];
                return  Expanded(
                  child: ListView.builder(
                    itemCount: tests.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TestListTile(
                        test: tests[index],
                        onTap: () => Navigator.of(context).pushNamed(
                          '/exams/home',
                          arguments: {'test': tests[index]}
                        ),
                      );
                    },
                  )
                );
              } else {
                return Container();
              }
            },
          )
        ]
      ),
    );
  }
}
