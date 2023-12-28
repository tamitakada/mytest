import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';

import 'package:mytest/global_mixins/alert_mixin.dart';


class AnimatedEditorView extends StatelessWidget with AlertMixin {

  final Widget child;
  final int index;
  final bool isEditing;
  final void Function() onDelete;
  final void Function()? onImageUpload;

  const AnimatedEditorView({
    super.key,
    required this.index,
    required this.isEditing,
    required this.child,
    required this.onDelete,
    this.onImageUpload
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      showDeletionConfirmationDialog(context, onDelete, () {});
                    },
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
                onImageUpload != null
                  ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: GestureDetector(
                      onTap: onImageUpload,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Constants.white,
                          border: Border.all(
                            color: Constants.salmon,
                            width: 2
                          )
                        ),
                        padding: const EdgeInsets.all(3),
                        child: const Icon(
                          Icons.image_outlined,
                          color: Constants.salmon,
                          size: 14,
                        ),
                      ),
                    ),
                  )
                  : Container(),
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
