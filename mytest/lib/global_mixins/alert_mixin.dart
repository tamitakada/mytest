import 'package:flutter/material.dart';
import 'package:mytest/constants.dart';
import 'package:mytest/widgets/mt_text_field.dart';
import 'package:mytest/widgets/mt_button.dart';
import 'package:mytest/widgets/shakeable_view.dart';


mixin AlertMixin {

  Future<void> showErrorDialog(BuildContext context, ErrorType type) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Constants.salmon,
          title: Text(
            'エラー発生',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Constants.white
            ),
          ),
          content: SizedBox(
            width: 150,
            height: 100,
            child: Center(
              child: Text(
                Constants.errorDescription(type),
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Constants.white
                ),
              ),
            ),
          ),
          actions: [
            MTButton(
              text: '了解',
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String description,
    required String confirmText,
    required void Function() onConfirm,
    void Function()? onCancel
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Constants.salmon,
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Constants.white
            ),
          ),
          content: SizedBox(
            width: 100,
            height: 80,
            child: Center(
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Constants.white
                ),
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: MTButton(
                    text: 'キャンセル',
                    onTap: () {
                      if (onCancel != null) { onCancel(); }
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MTButton(
                    text: confirmText,
                    onTap: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> showTitleEditDialog(
    BuildContext context,
    String title,
    void Function(String) onSubmitted,
    { String? initialValue }
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        controller.text = initialValue ?? "";
        FocusNode focusNode = FocusNode();
        focusNode.requestFocus();
        bool showInvalidAnimation = false;
        return StatefulBuilder(
          builder: (context, setState) {
            bool showInvalidAnimationOnBuild = showInvalidAnimation;
            showInvalidAnimation = false;
            return AlertDialog(
              backgroundColor: Constants.salmon,
              title: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Constants.white
                ),
              ),
              content: SizedBox(
                width: 150,
                height: 80,
                child: Center(
                  child: ShakeableView(
                    animated: showInvalidAnimationOnBuild,
                    child: MTTextField(
                      color: Constants.white,
                      hintText: 'テスト名',
                      controller: controller,
                      focusNode: focusNode,
                      onSubmitted: (String text) {
                        if (text.trim().isEmpty) {
                          setState(() {
                            showInvalidAnimation = true;
                            focusNode.requestFocus();
                          });
                        }
                        else {
                          onSubmitted(text);
                          Navigator.of(context).pop();
                        }
                      }
                    ),
                  ),
                ),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: MTButton(
                        onTap: () => Navigator.of(context).pop(),
                        text: 'キャンセル'
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MTButton(
                        onTap: () {
                          String text = controller.text;
                          if (text.trim().isEmpty) {
                            setState(() {
                              showInvalidAnimation = true;
                              focusNode.requestFocus();
                            });
                          }
                          else {
                            onSubmitted(text);
                            Navigator.of(context).pop();
                          }
                        },
                        text: '決定'
                      ),
                    ),
                  ],
                )
              ],
            );
          }
        );
      },
    );
  }

}