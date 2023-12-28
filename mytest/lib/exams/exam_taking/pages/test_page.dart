import 'package:flutter/material.dart';

import '../mixins/exam_mixin.dart';

import '../widgets/paused_test_view.dart';
import '../widgets/answer_view.dart';

import 'package:mytest/models/models.dart';

import 'package:mytest/constants.dart';
import 'package:mytest/widgets/spaced_group.dart';
import 'package:mytest/widgets/mt_text_field.dart';
import 'package:mytest/widgets/scrollable_image_display.dart';

import 'package:mytest/pair.dart';

import '../widgets/shakeable_view.dart';


class TestPage extends StatefulWidget {

  final TestMode mode;

  const TestPage({ super.key, required this.mode });

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with ExamMixin {

  Test? _test;

  final TextEditingController _answerController = TextEditingController();
  final FocusNode _answerNode = FocusNode();

  late List<Question> _questions;
  final List<Pair<Question, bool>> _testQuestions = []; // Question, didGetCorrect

  late int _initialQuestionCount;
  int _mistakeCount = 0;

  bool _isPaused = false;
  bool _isInMistakeMode = false;

  void _checkAnswer(String answer) {
    _answerController.clear();
    if (isAnswerCorrect(_testQuestions.last.a, answer, _test!.flipTerms, _test!.allowError)) {
      _testQuestions.last.b = !_isInMistakeMode; // Only correct when not in mistake mode
      if (
        (widget.mode == TestMode.full && _questions.isEmpty)
        || (widget.mode == TestMode.lives && _isInMistakeMode && _mistakeCount == 4)
      ) { _showResults(); }
      else { _showNextQuestion(); }
    }
    else {
      setState(() {
        _mistakeCount += _isInMistakeMode ? 0 : 1; // Only add once per question
        _isInMistakeMode = true;
        _answerNode.requestFocus();
      });
    }
  }

  void _showNextQuestion() {
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

  void _showResults() {
    Navigator.of(context, rootNavigator: true).pushNamed(
      '/exams/result',
      arguments: {'questions': _testQuestions, 'mode': widget.mode}
    );
  }

  // TEST MODE BASED VIEW BUILDERS =============================================

  Widget _buildQuizTracker() {
    if (widget.mode == TestMode.lives) {
      return SpacedGroup( // Lives tracker for lives mode
        axis: Axis.horizontal,
        spacing: 5,
        children: [
          Icon(
            Icons.favorite_rounded,
            color: _mistakeCount <= 0 ? Constants.salmon : Constants.charcoal,
            size: 24,
          ),
          Icon(
            Icons.favorite_rounded,
            color: _mistakeCount <= 1 ? Constants.salmon : Constants.charcoal,
            size: 24,
          ),
          Icon(
            Icons.favorite_rounded,
            color: _mistakeCount <= 2 ? Constants.salmon : Constants.charcoal,
            size: 24,
          )
        ],
      );
    }
    return Column( // Accuracy % for practice & full test modes
      children: [
        Text(
          "正解率",
          style: Theme.of(context).textTheme.bodySmall
        ),
        const SizedBox(height: 5),
        Text(
          _testQuestions.length > 1
            ? "${(( _testQuestions.length - _mistakeCount) / _testQuestions.length * 100).toInt()}%"
            : "- %",
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    );
  }

  Widget _buildQuestionCounter() {
    return widget.mode == TestMode.full
      ? Column( // Show fraction complete for full length test
        children: [
          Text(
          "${_testQuestions.length}",
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Constants.salmon
            )
          ),
          Container(
            width: 50,
            height: 3,
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Constants.salmon
            ),
          ),
          Text(
            "$_initialQuestionCount",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Constants.salmon,
              fontWeight: FontWeight.bold
            )
          ),
        ],
      )
      : Text(
        "${_testQuestions.length}",
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
          color: Constants.salmon
        )
      );
  }

  // INIT / DISPOSE / BUILD ====================================================

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_test == null) {
      Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey("test")) {
        _test = args["test"] as Test;
        _questions = _test!.questions.toList();
        _initialQuestionCount = _questions.length;
        _testQuestions.add(
          Pair<Question, bool>(
            a: generateRandomQuestion(widget.mode, _questions),
            b: false
          )
        );
      }
      _answerNode.requestFocus();
    }
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      _test?.title ?? "",
                      style: Theme.of(context).textTheme.displaySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                SpacedGroup(
                  axis: Axis.horizontal,
                  spacing: 20,
                  children: [
                    !_isPaused
                      ? IconButton(
                        onPressed: () => setState(() => _isPaused = true),
                        icon: const Icon(
                          Icons.pause_rounded,
                          color: Constants.salmon,
                          size: 24,
                        ),
                      )
                      : Container(),
                    _buildQuizTracker()
                  ],
                )
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Constants.sakura
                ),
                child: _isPaused
                  ? PausedTestView(
                    test: _test!,
                    mode: widget.mode,
                    unpause: () => setState(() => _isPaused = false)
                  )
                  : SpacedGroup(
                    axis: Axis.vertical,
                    spacing: 20,
                    children: [
                      _buildQuestionCounter(),
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
                                     (i) => Pair<String, bool>(a: i, b: true)
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
                  enabled: !_isPaused,
                  controller: _answerController,
                  focusNode: _answerNode,
                  decoration: InputDecoration(
                    hintText: _isInMistakeMode ? "答えを入力" : "正しい答えを入力",
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    border: const UnderlineInputBorder(borderSide: BorderSide(color: Constants.charcoal, width: 2)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Constants.charcoal, width: 2)),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Constants.charcoal, width: 2)),
                    focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Constants.charcoal, width: 2)),
                    disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Constants.charcoal.withOpacity(0.4), width: 2)),
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
