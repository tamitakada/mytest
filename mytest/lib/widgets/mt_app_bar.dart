import 'package:flutter/material.dart';
import 'package:mytest/constants.dart';
import 'package:mytest/widgets/spaced_group.dart';

class MTAppBar extends StatelessWidget {

  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  const MTAppBar({
    super.key, required this.title, this.leading, this.actions
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),
        leading != null
          ? Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
            child: leading!,
          )
          : Container(),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.displayLarge,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        actions != null
          ? Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: SpacedGroup(
              axis: Axis.horizontal,
              spacing: 20,
              children: actions!,
            ),
          )
          : Container()
      ],
    );
  }
}
