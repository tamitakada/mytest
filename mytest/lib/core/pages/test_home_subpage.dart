import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_selector/file_selector.dart';

import 'package:mytest/app_state.dart';

import 'package:mytest/models/models.dart';

import 'package:mytest/utils/file_utils.dart';
import 'package:mytest/utils/data_manager.dart';

import 'package:mytest/global_mixins/alert_mixin.dart';

import 'package:mytest/pair.dart';
import 'package:mytest/constants.dart';

import 'package:mytest/widgets/error_page.dart';
import 'package:mytest/widgets/spaced_group.dart';
import 'package:mytest/widgets/mt_text_field.dart';
import '../widgets/test_home_widgets/widgets.dart';
import '../widgets/animated_editor_view.dart';


class TestHomeSubpage extends StatefulWidget {

  const TestHomeSubpage({ super.key });

  @override
  State<TestHomeSubpage> createState() => _TestHomeSubpageState();
}

class _TestHomeSubpageState extends State<TestHomeSubpage> with AlertMixin {

  Test? _currentTest;
  String _query = "";
  int _toAnimate = -1;
  bool _isEditing = false;

  late List<Pair<Question, bool>> _questions; // Question, showing question (vs. answer) side
  List<Question> _questionsToDelete = [];

  final TextEditingController _queryController = TextEditingController();

  /* UNWRITTEN QUESTION CHANGES ============================================= */

  void _addQuestion() {
    setState(() { // Trigger animation for added item
      _questions.add(
        Pair(
          a: Question(order: _questions.length, question: "", answer: "", images: List<String>.empty(growable: true)),
          b: true
        )
      );
      _toAnimate = _questions.length - 1;
    });
  }

  void _reorderQuestion(int oldIndex, int newIndex) {
    Pair<Question, bool> entry = _questions[oldIndex];
    entry.a.order = newIndex;
    _questions.removeAt(oldIndex);
    _questions.insert(newIndex - (oldIndex < newIndex ? 1 : 0), entry);
  }

  void _deleteQuestion(int index) {
    _questionsToDelete.add(_questions[index].a);
    setState(() { _questions.removeAt(index); });
  }

  /* IMAGE UPLOAD =========================================================== */

  void _selectNewImageSync(BuildContext context, int index) {
    _selectNewImage(index).then((success) {
      if (!success) { showErrorDialog(context, ErrorType.save); }
    });
  }

  Future<bool> _selectNewImage(int index) async {
    try {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'images',
        extensions: <String>['jpg', 'png'],
      );
      XFile? file = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
      if (file != null) {
        String filename = "${_questions[index].a.id}-${_questions[index].a.images.length}";
        File? copied = await FileUtils.copyFile(
          File(file.path), filename
        );
        if (copied != null) {
          setState(() => _questions[index].a.images.add(filename));
          return true;
        }
        return false;
      }
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }
  
  void _deleteImage(BuildContext context, int questionIndex, int imageIndex) {
    if (imageIndex < _questions[questionIndex].a.images.length) {
      FileUtils.deleteFile(_questions[questionIndex].a.images[imageIndex]).then((success) {
        if (success) {
          setState(() => _questions[questionIndex].a.images.removeAt(imageIndex));
        }
        else { showErrorDialog(context, ErrorType.save); }
      });
    }
  }

  /* WRITING QUESTION CHANGES =============================================== */

  void _saveChanges(BuildContext context) {
    List<Question> questions = [];
    for (int i = 0; i < _questions.length; i++) {
      _questions[i].a.order = i;
      questions.add(_questions[i].a);
    }
    DataManager.upsertQuestions(questions, AppState.selectedTest.value!).then((success) {
      if (success) {
        if (_questionsToDelete.isNotEmpty) { // Delete iff pending deletes
          DataManager.deleteQuestions(_questionsToDelete).then((success) {
            _questionsToDelete = []; // Reset delete queue REGARDLESS of success
            if (success) { AppState.selectedTest.value!.questions.load(); }
            else { showErrorDialog(context, ErrorType.save); }
          });
        }
      }
      else { showErrorDialog(context, ErrorType.save); }
    });
    setState(() => _isEditing = false);
  }

  /* BUILD ================================================================== */

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppState.selectedTest,
      builder: (context, test, child) {
        if (_currentTest != test) {
          _currentTest = test;
          _questions = test?.getOrderedQuestions().map(
            (e) => Pair<Question, bool>(a: e, b: true)
          ).toList() ?? [];
        }
        return test != null
          ? Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Text(
                  test.title,
                  style: Theme.of(context).textTheme.displayLarge,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
              scrolledUnderElevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                      "test_detail/settings",
                      arguments: {"test": test}
                    ),
                    icon: const Icon(
                      Icons.settings,
                      color: Constants.charcoal,
                      size: 20,
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                      "test_detail/stats",
                      arguments: {"test": test}
                    ),
                    icon: const Icon(
                      Icons.bar_chart_rounded,
                      color: Constants.charcoal,
                      size: 20,
                    )
                  ),
                ),
              ],
            ),
            backgroundColor: Constants.white,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
              child: SpacedGroup(
                axis: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  TestOptionsMenu(test: test),
                  SpacedGroup(
                    axis: Axis.horizontal,
                    spacing: 10,
                    children: [
                      Expanded(
                        child: MTTextField(
                          enabled: !_isEditing,
                          hintText: '問題を検索',
                          controller: _queryController,
                          onChanged: (query) => setState(() { _query = query; }),
                        )
                      ),
                      _isEditing
                        ? IconButton(
                          icon: const Icon(Icons.add, color: Constants.charcoal),
                          onPressed: _addQuestion
                        )
                        : Container(),
                      IconButton(
                        icon: Icon(
                          _isEditing ? Icons.check : Icons.edit,
                          color: Constants.charcoal
                        ),
                        onPressed: () {
                          if (_isEditing) { _saveChanges(context); }
                          else {
                            setState(() {
                              _queryController.clear();
                              _query = "";
                              _isEditing = true;
                            });
                          }
                        }
                      )
                    ]
                  ),
                  Expanded(
                    child: _questions.isNotEmpty || _isEditing
                      ? ReorderableListView.builder(
                        buildDefaultDragHandles: false,
                        proxyDecorator: (child, _, __) => Material(color: Colors.transparent, child: child,),
                        itemBuilder: (BuildContext context, int index) {
                          if (_query.isEmpty
                              || test.questions.elementAt(index).question.toLowerCase().contains(_query.toLowerCase())
                              || test.questions.elementAt(index).answer.toLowerCase().contains(_query.toLowerCase())
                          ) {
                            bool animate = index == _toAnimate;
                            _toAnimate = animate ? -1 : _toAnimate; // Reset to prevent double animation
                            return AnimatedEditorView(
                              key: Key('$index'),
                              index: index,
                              isEditing: _isEditing,
                              onDelete: () => _deleteQuestion(index),
                              onImageUpload: _questions[index].b
                                ? () => _selectNewImageSync(context, index) : null,
                              child: QuestionView(
                                index: index,
                                question: _questions[index].a,
                                enableEditing: _isEditing,
                                displayQuestion: _questions[index].b,
                                animate: animate,
                                updateDisplayState: (displayQuestion) => setState(() =>  _questions[index].b = displayQuestion),
                                onChangedQuestion: (updated) => _questions[index].a.question = updated,
                                onChangedAnswer: (updated) => _questions[index].a.answer = updated,
                                onDeleteImage: (imageIndex) => _deleteImage(context, index, imageIndex),
                              )
                            );
                          }
                          return Container(key: Key('$index'));
                        },
                        itemCount: _questions.length,
                        shrinkWrap: true,
                        onReorder: _reorderQuestion
                      )
                      : const ErrorPage(margin: EdgeInsets.zero, message: "問題集が空です")
                  )
                ],
              )
            ),
          )
          : const ErrorPage(
            margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
            message: "表示できるテストがありません"
          );
      }
    );
  }
}
