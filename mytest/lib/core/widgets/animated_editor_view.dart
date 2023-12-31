import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';

import 'package:mytest/global_mixins/alert_mixin.dart';
import 'test_home_widgets/question_edit_menu.dart';


class AnimatedEditorView extends StatelessWidget with AlertMixin {

  final Widget child;
  final int index;
  final bool isEditing;
  final void Function()? onDelete;
  final void Function()? onImageUpload;

  const AnimatedEditorView({
    super.key,
    required this.index,
    required this.isEditing,
    required this.child,
    this.onDelete,
    this.onImageUpload
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            child: isEditing ?
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                  child: onDelete != null && onImageUpload != null
                    ? QuestionEditMenu(
                      onDelete: () => showConfirmationDialog(
                        context: context,
                        title: "削除しますか？",
                        description: "復元は不可能になります。",
                        confirmText: "削除する",
                        onConfirm: onDelete!
                      ),
                      onImageUpload: onImageUpload!
                    )
                    : Container(),
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
