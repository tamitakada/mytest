import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';
import 'package:mytest/models/question.dart';
import 'package:mytest/widgets/spaced_group.dart';
import 'package:mytest/widgets/scrollable_image_display.dart';


class QuestionView extends StatefulWidget {

  final Question question;
  final int index;
  final bool animate;
  final bool enableEditing;
  final bool displayQuestion;

  final void Function(bool) updateDisplayState;
  final void Function(String) onChangedQuestion;
  final void Function(String) onChangedAnswer;
  final void Function(int) onDeleteImage;

  final Color? color;

  const QuestionView({
    Key? key,
    required this.question,
    required this.index,
    required this.enableEditing,
    required this.displayQuestion,
    required this.updateDisplayState,
    required this.onChangedQuestion,
    required this.onChangedAnswer,
    required this.onDeleteImage,
    this.color,
    this.animate = false
  }) : super(key: key);

  @override
  State<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late bool _animate;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300)
    );
    _animate = widget.animate;
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_animate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _animationController.reset();
        _animationController.forward();
        _animate = false;
      });
    }
    return _animate
        ? SlideTransition(
        position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: const Offset(0, 0)
        ).animate(_animationController),
        child: QuestionEditView(
          key: UniqueKey(),
          question: widget.question,
          enableEditing: widget.enableEditing,
          displayQuestion: widget.displayQuestion,
          index: widget.index,
          updateDisplayState: widget.updateDisplayState,
          onChangedQuestion: widget.onChangedQuestion,
          onChangedAnswer: widget.onChangedAnswer,
          onDeleteImage: widget.onDeleteImage,
          color: widget.color,
        )
    )
        : QuestionEditView(
      key: UniqueKey(),
      question: widget.question,
      enableEditing: widget.enableEditing,
      displayQuestion: widget.displayQuestion,
      index: widget.index,
      updateDisplayState: widget.updateDisplayState,
      onChangedQuestion: widget.onChangedQuestion,
      onChangedAnswer: widget.onChangedAnswer,
      onDeleteImage: widget.onDeleteImage,
      color: widget.color,
    );
  }
}

class QuestionEditView extends StatefulWidget {

  final Question question;
  final int index;
  final bool displayQuestion;
  final bool enableEditing;
  final void Function(bool) updateDisplayState;
  final void Function(String) onChangedQuestion;
  final void Function(String) onChangedAnswer;
  final void Function(int) onDeleteImage;
  final Color? color;

  const QuestionEditView({
    Key? key,
    required this.question,
    required this.index,
    required this.enableEditing,
    required this.displayQuestion,
    required this.updateDisplayState,
    required this.onChangedQuestion,
    required this.onChangedAnswer,
    required this.onDeleteImage,
    this.color,
  }) : super(key: key);

  @override
  State<QuestionEditView> createState() => _QuestionEditViewState();
}

class _QuestionEditViewState extends State<QuestionEditView> {

  late bool _showQuestion;

  late final TextEditingController _questionController;
  late final TextEditingController _answerController;

  final FocusNode _questionFocus = FocusNode();
  final FocusNode _answerFocus = FocusNode();

  @override
  void initState() {
    _questionController = TextEditingController(text: widget.question.question);
    _answerController = TextEditingController(text: widget.question.answer);
    _questionFocus.addListener(() {
      if (!_questionFocus.hasFocus) {
        widget.onChangedQuestion(_questionController.text);
      }
    });
    _answerFocus.addListener(() {
      if (!_answerFocus.hasFocus) {
        widget.onChangedAnswer(_answerController.text);
      }
    });
    _showQuestion = widget.displayQuestion;
    super.initState();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    _questionFocus.dispose();
    _answerFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpacedGroup(
      axis: Axis.horizontal,
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() => _showQuestion = true);
                widget.updateDisplayState(true);
              },
              child: Container(
                width: 22, height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: _showQuestion ? Constants.sakura : Constants.white,
                  border: Border.all(
                    color: _showQuestion ? Constants.sakura : Constants.charcoal,
                    width: 2
                  )
                ),
                child: Center(
                  child: Text(
                    "問",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _showQuestion ? Constants.salmon : Constants.charcoal
                    )
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                setState(() => _showQuestion = false);
                widget.updateDisplayState(false);
              },
              child: Container(
                width: 22, height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: !_showQuestion ? Constants.sakura : Constants.white,
                  border: Border.all(
                    color: !_showQuestion ? Constants.sakura : Constants.charcoal,
                    width: 2
                  )
                ),
                child: Center(
                  child: Text(
                    "答",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: !_showQuestion ? Constants.salmon : Constants.charcoal
                    )
                  ),
                ),
              ),
            )
          ],
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Constants.sakura,
              borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 16),
            child: Column(
              children: [
                TextField(
                  focusNode: _showQuestion ? _questionFocus : _answerFocus,
                  controller: _showQuestion ? _questionController : _answerController,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: null,
                  expands: true,
                  onChanged: _showQuestion ? widget.onChangedQuestion : widget.onChangedAnswer,
                  maxLines: null,
                  minLines: null,
                  enabled: widget.enableEditing,
                ),
                _showQuestion && (widget.question.images?.isNotEmpty ?? false)
                  ? Container(
                    height: 200,
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ScrollableImageDisplay(
                      images: widget.question.images,
                      onDelete: widget.enableEditing ? widget.onDeleteImage : null,
                    ),
                  )
                  : Container()
              ],
            ),
          )
        ),
      ],
    );
  }
}
