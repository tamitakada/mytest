import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';
import 'package:mytest/models/question.dart';
import 'package:mytest/global_widgets/global_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';


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
        ScaleButton(
          onTap: () {
            widget.updateDisplayState(!_showQuestion);
            setState(() => _showQuestion = !_showQuestion);
          },
          child: SvgPicture.asset(
            'assets/images/switch.svg',
            height: 18,
          )
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: _showQuestion ? Constants.sakura : Constants.salmon,
              borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _showQuestion ? "問" : "答",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _showQuestion ? Constants.salmon : Constants.white
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        focusNode: _showQuestion ? _questionFocus : _answerFocus,
                        controller: _showQuestion ? _questionController : _answerController,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _showQuestion ? Constants.charcoal : Constants.white
                        ),
                        decoration: null,
                        expands: true,
                        onChanged: _showQuestion ? widget.onChangedQuestion : widget.onChangedAnswer,
                        maxLines: null,
                        minLines: null,
                        enabled: widget.enableEditing,
                      ),
                      _showQuestion && widget.question.images.isNotEmpty
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
                ),
              ],
            ),
          )
        ),
      ],
    );
  }
}
