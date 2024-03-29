import 'package:flutter/material.dart';
import 'package:mytest/constants.dart';
import 'package:mytest/global_widgets/scale_button.dart';

class QuestionEditMenu extends StatelessWidget {

  final void Function() onDelete;
  final void Function()? onImageUpload;

  const QuestionEditMenu({
    super.key,
    required this.onDelete,
    required this.onImageUpload
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ScaleButton(
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
        const SizedBox(width: 5),
        ScaleButton(
          onTap: onImageUpload ?? () {},
          enabled: onImageUpload != null,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Constants.white,
              border: Border.all(
                color: onImageUpload != null
                  ? Constants.salmon
                  : Constants.charcoal.withOpacity(0.5),
                width: 2
              )
            ),
            padding: const EdgeInsets.all(3),
            child: Icon(
              Icons.image_outlined,
              color: onImageUpload != null
                ? Constants.salmon
                : Constants.charcoal.withOpacity(0.5),
              size: 14,
            ),
          ),
        )
      ],
    );
  }
}
