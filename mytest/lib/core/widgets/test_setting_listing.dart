import 'package:flutter/material.dart';
import 'package:mytest/constants.dart';


class TestSettingListing extends StatelessWidget {

  final String description;
  final Widget settingChild;

  const TestSettingListing({
    super.key, required this.description, required this.settingChild
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Constants.sakura
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              description,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          settingChild
        ],
      ),
    );
  }
}
