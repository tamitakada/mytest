import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';


class AnimatedEditorView extends StatelessWidget {

  final Widget child;
  final int index;
  final bool isEditing;
  final void Function() onDelete;

  const AnimatedEditorView({
    super.key,
    required this.index,
    required this.isEditing,
    required this.child,
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            child: isEditing ?
            Row(
              children: [
                ReorderableDragStartListener(
                  index: index,
                  child: const Icon(
                    Icons.drag_handle_rounded,
                    size: 16,
                    color: Constants.charcoal,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Constants.salmon
                      ),
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Constants.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ) : Container(),
            transitionBuilder: (child, position) {
              return SlideTransition(
                position: Tween(begin: const Offset(-1, 0), end: const Offset(0, 0))
                  .animate(position),
                child: child,
              );
            },
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
