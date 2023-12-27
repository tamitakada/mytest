import 'package:flutter/material.dart';


class SpacedGroup extends StatelessWidget {

  final Axis axis;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final List<Widget> children;

  const SpacedGroup({
    super.key,
    required this.axis,
    required this.spacing,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center
  });

  List<Widget> _spaceChildren() {
    List<Widget> spacedChildren = [];
    for (int i = 0; i < (children.length - 1); i++) {
      spacedChildren.add(children[i]);
      spacedChildren.insert(
        i * 2 + 1,
        SizedBox(
          height: axis == Axis.horizontal ? 0 : spacing,
          width: axis == Axis.vertical ? 0 : spacing,
        )
      );
    }
    spacedChildren.add(children.last);
    return spacedChildren;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> spacedChildren = _spaceChildren();
    return axis == Axis.horizontal
      ? Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: spacedChildren
      )
      : Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: spacedChildren
      );
  }
}
