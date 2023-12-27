import 'package:flutter/material.dart';

import '../mixins/exam_mixin.dart';
import '../widgets/answer_view.dart';

import 'package:mytest/models/models.dart';

import 'package:mytest/constants.dart';
import 'package:mytest/widgets/spaced_group.dart';
import 'package:mytest/widgets/mt_text_field.dart';
import 'package:mytest/widgets/scrollable_image_display.dart';

import 'package:mytest/pair.dart';

import '../widgets/shakeable_view.dart';


class BaseTestPage extends StatefulWidget {

  final TestMode mode;
  final Test test;
  final Widget? topRightChild;

  const BaseTestPage({
    super.key,
    required this.mode,
    required this.test,
    this.topRightChild
  });

  @override
  State<BaseTestPage> createState() => _BaseTestPageState();
}

class _BaseTestPageState extends State<BaseTestPage> with ExamMixin {

  final TextEditingController _answerController = TextEditingController();
  final FocusNode _answerNode = FocusNode();

  late List<Question> _questions;
  List<Pair<Question, bool>> _testQuestions = []; // Question, didGetCorrect

  bool _isPaused = false;
  bool _isInMistakeMode = false;

  void _checkAnswer(String answer) {
    _answerController.clear();
    if (isAnswerCorrect(_testQuestions.last.a, answer, widget.test.flipTerms, widget.test.allowError)) {
      _testQuestions.last.b = !_isInMistakeMode; // Only correct when not in mistake mode
      setState(() {
        _testQuestions.add(
          Pair<Question, bool>(
            a: generateRandomQuestion(widget.mode, _questions),
            b: false
          )
        );
        _isInMistakeMode = false;
        _answerNode.requestFocus();
      });
    }
    else {
      setState(() {
        _isInMistakeMode = true;
        _answerNode.requestFocus();
      });
    }
  }

  @override
  void initState() {
    _questions = widget.test.questions.toList();
    _testQuestions.add(
      Pair<Question, bool>(
        a: generateRandomQuestion(widget.mode, _questions),
        b: false
      )
    );
    _answerNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SpacedGroup(
          axis: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 20,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Constants.salmon
                      ),
                      child: Text(
                        Constants.modeName(widget.mode),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Constants.white
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      widget.test.title,
                      style: Theme.of(context).textTheme.displaySmall
                    )
                  ],
                ),
                widget.topRightChild ?? Container()
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Constants.sakura
                ),
                child: SpacedGroup(
                  axis: Axis.vertical,
                  spacing: 20,
                  children: [
                    Text(
                      "${_testQuestions.length}",
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Constants.salmon
                      )
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _testQuestions.last.a.question,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          _testQuestions.last.a.images?.isNotEmpty ?? false
                             ? Expanded(
                               child: ScrollableImageDisplay(
                                 images: _testQuestions.last.a.images!.map(
                                   (i) => Pair<String, bool>(a: i, b: false)
                                 ).toList()
                               ),
                             )
                             : Container()
                        ],
                      ),
                    ),
                    _isInMistakeMode
                      ? AnswerView(answer: _testQuestions.last.a.answer)
                      : Container()
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: ShakeableView(
                animated: _isInMistakeMode,
                child: TextField(
                  controller: _answerController,
                  focusNode: _answerNode,
                  decoration: InputDecoration(
                    hintText: _isInMistakeMode ? "答えを入力" : "正しい答えを入力",
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    border: const UnderlineInputBorder(borderSide: BorderSide(color: Constants.charcoal, width: 2)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Constants.charcoal, width: 2)),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Constants.charcoal, width: 2)),
                    focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Constants.charcoal, width: 2)),
                    disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Constants.charcoal, width: 2)),
                    errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Constants.charcoal, width: 2))
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                  onSubmitted: _checkAnswer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
