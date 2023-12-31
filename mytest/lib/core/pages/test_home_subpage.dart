import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_selector/file_selector.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mytest/app_state.dart';

import 'package:mytest/models/models.dart';

import 'package:mytest/utils/file_utils.dart';
import 'package:mytest/utils/data_manager.dart';

import 'package:mytest/global_mixins/alert_mixin.dart';

import 'package:mytest/pair.dart';
import 'package:mytest/constants.dart';

import 'package:mytest/global_widgets/global_widgets.dart';
import '../widgets/test_home_widgets/widgets.dart';
import '../widgets/animated_editor_view.dart';


class TestHomeSubpage extends StatefulWidget {

  const TestHomeSubpage({ super.key });

  @override
  State<TestHomeSubpage> createState() => _TestHomeSubpageState();
}

class _TestHomeSubpageState extends State<TestHomeSubpage> with AlertMixin {

  Test? _currentTest; // Detect true changes in selected test

  String _query = "";
  int _toAnimate = -1;

  late List<Pair<Question, bool>> _questions; // Question, showing question (vs. answer) side
  List<Question> _questionsToDelete = [];

  final TextEditingController _queryController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  /* UNWRITTEN QUESTION CHANGES ============================================= */

  void _addQuestion() {
    setState(() {
      _questions.add(
        Pair(
          a: Question(
            order: _questions.length, question: "", answer: "",
            images: List<String>.empty(growable: true) // Explicitly growable
          ),
          b: true // Start with question side
        )
      );
      _toAnimate = _questions.length - 1; // Mark to animate in
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn
      );
    });
  }

  void _reorderQuestion(int oldIndex, int newIndex) {
    // Order property changed on validate; no need to update here
    Pair<Question, bool> entry = _questions[oldIndex];
    _questions.removeAt(oldIndex);
    _questions.insert(newIndex - (oldIndex < newIndex ? 1 : 0), entry);
  }

  void _deleteQuestion(int index) {
    AppState.selectedTest.value!.questions.remove(_questions[index]);
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
        label: 'images', extensions: <String>['jpg', 'png'],
      );
      XFile? file = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
      if (file != null) {
        String filename = Constants.uuid.v1(); // Copy image to unique filename
        File? copied = await FileUtils.copyFile(File(file.path), filename);
        if (copied != null) { // Add copied filename to images property
          setState(() => _questions[index].a.images.add(filename));
          return true;
        }
        return false; // Error copying
      }
      return true; // Cancelled image selection
    }
    catch (e) { return false; } // Error selecting image
  }
  
  void _deleteImage(BuildContext context, int questionIndex, int imageIndex) {
    if (imageIndex < _questions[questionIndex].a.images.length) {
      FileUtils.deleteFile(_questions[questionIndex].a.images[imageIndex]).then((success) {
        if (success) { // Reload & update property on success deleting image file
          setState(() => _questions[questionIndex].a.images.removeAt(imageIndex));
        }
        else { showErrorDialog(context, ErrorType.save); }
      });
    }
  }

  /* WRITING QUESTION CHANGES =============================================== */

  void _validateChanges(BuildContext context) {
    List<Question> questions = []; // Isolate Questions from Pairs
    for (int i = 0; i < _questions.length; i++) {
      if (_questions[i].a.question.trim().isEmpty // DON'T save if empty inputs
          || _questions[i].a.answer.trim().isEmpty) {
        showErrorDialog(context, ErrorType.emptyInput);
        return;
      }
      _questions[i].a.order = i; // Order written
      questions.add(_questions[i].a);
    }
    DataManager.upsertQuestions(questions, AppState.selectedTest.value!).then((success) {
      if (success) {
        if (_questionsToDelete.isNotEmpty) { // Delete iff pending deletes
          DataManager.deleteQuestions(_questionsToDelete).then((success) {
            _questionsToDelete = []; // Reset delete queue REGARDLESS of success
            // Load questions to update for deletes
            if (success) { AppState.selectedTest.value!.questions.load(); }
            else { showErrorDialog(context, ErrorType.save); }
          });
        }
      }
      else { showErrorDialog(context, ErrorType.save); }
    });
    setState(() => AppState.updateEditingState(EditingAction.endEditingTest));
  }

  /* STATE-AWARE NAVIGATION ================================================= */

  void _pushNewTestDetail() {
    if (_currentTest != AppState.selectedTest.value) {
      if (AppState.editingState.value != EditingState.notEditing) {
        showConfirmationDialog(
          context: context,
          title: "変更は保存されません",
          description: "保存されていない変更があります。変更を放棄して次の画面に進みますか？",
          confirmText: "進む",
          onConfirm: () {
            resetState();
            Navigator.of(context).pushReplacementNamed("test_detail/home");
          }
        );
      }
      else {
        resetState();
        Navigator.of(context).pushReplacementNamed("test_detail/home");
      }
    }
  }

  void _navigateWithEditConfirmation(String newRoute) {
    if (AppState.editingState.value != EditingState.notEditing) {
      showConfirmationDialog(
        context: context,
        title: "変更は保存されません",
        description: "保存されていない変更があります。変更を放棄して次の画面に進みますか？",
        confirmText: "進む",
        onConfirm: () {
          resetState();
          Navigator.of(context).pushNamed(newRoute);
        }
      );
    }
    else {
      resetState();
      Navigator.of(context).pushNamed(newRoute);
    }
  }

  /* STATE ================================================================== */

  void resetState() {
    // Clear search
    _query = "";
    _queryController.clear();
    // Reset edits
    _toAnimate = -1;
    AppState.updateEditingState(EditingAction.endEditingTest);
    AppState.updateEditingState(EditingAction.endEditingTestListing);
    _questions = AppState.selectedTest.value?.getOrderedQuestions().map(
            (q) => Pair(a: q, b: true)
    ).toList() ?? [];
    _questionsToDelete = [];
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _queryController.dispose();
    AppState.selectedTest.removeListener(_pushNewTestDetail);
    super.dispose();
  }

  @override
  void initState() {
    _currentTest = AppState.selectedTest.value;
    _questions = AppState.selectedTest.value?.getOrderedQuestions().map(
      (q) => Pair(a: q, b: true)
    ).toList() ?? [];
    AppState.selectedTest.addListener(_pushNewTestDetail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppState.selectedTest.value != null
      ? ListenableBuilder(
        listenable: AppState.selectedTest.value!,
        builder: (context, child) {
          return Scaffold(
            backgroundColor: Constants.white,
            body: Column(
              children: [
                MTAppBar(
                  title: AppState.selectedTest.value!.title,
                  actions: [
                    ScaleButton(
                      onTap: () => _navigateWithEditConfirmation("test_detail/settings"),
                      child: SvgPicture.asset(
                        'assets/images/settings.svg', height: 18,
                      )
                    ),
                    ScaleButton(
                      onTap: () => _navigateWithEditConfirmation("test_detail/stats"),
                      child: SvgPicture.asset(
                        'assets/images/stats.svg', height: 16,
                      )
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: SpacedGroup(
                      axis: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 20,
                      children: [
                        TestOptionsMenu(resetState: resetState),
                        SpacedGroup(
                          axis: Axis.horizontal,
                          spacing: 20,
                          children: [
                            Expanded(
                              child: MTTextField(
                                enabled: !AppState.isEditing(EditingType.test),
                                hintText: '問題を検索',
                                controller: _queryController,
                                onSubmitted: (query) => setState(() { _query = query; }),
                              )
                            ),
                            AppState.isEditing(EditingType.test)
                              ? ScaleButton(
                                onTap: _addQuestion,
                                child: SvgPicture.asset(
                                  'assets/images/add.svg',
                                  height: 16
                                ),
                              )
                              : Container(),
                            ScaleButton(
                              onTap: () {
                                if (AppState.isEditing(EditingType.test)) {
                                  _validateChanges(context);
                                }
                                else {
                                  setState(() {
                                    _queryController.clear();
                                    _query = "";
                                    AppState.updateEditingState(EditingAction.beginEditingTest);
                                  });
                                }
                              },
                              child: SvgPicture.asset(
                                'assets/images/${AppState.isEditing(EditingType.test) ? 'save' : 'edit'}.svg',
                                height: 16
                              ),
                            ),
                          ]
                        ),
                        Expanded(
                          child: _questions.isNotEmpty || AppState.isEditing(EditingType.test)
                            ? ReorderableListView.builder(
                              buildDefaultDragHandles: false,
                              scrollController: _scrollController,
                              proxyDecorator: (child, _, __) => Material(color: Colors.transparent, child: child,),
                              itemBuilder: (BuildContext context, int index) {
                                if (_query.isEmpty
                                    || AppState.selectedTest.value!.questions.elementAt(index).question.toLowerCase().contains(_query.toLowerCase())
                                    || AppState.selectedTest.value!.questions.elementAt(index).answer.toLowerCase().contains(_query.toLowerCase())
                                ) {
                                  bool animate = index == _toAnimate;
                                  _toAnimate = animate ? -1 : _toAnimate; // Reset to prevent double animation
                                  return AnimatedEditorView(
                                    key: Key('$index'),
                                    index: index,
                                    isEditing: AppState.isEditing(EditingType.test),
                                    onDelete: () => _deleteQuestion(index),
                                    onImageUpload: _questions[index].b
                                      ? () => _selectNewImageSync(context, index) : null,
                                    child: QuestionView(
                                      index: index,
                                      question: _questions[index].a,
                                      enableEditing: AppState.isEditing(EditingType.test),
                                      displayQuestion: _questions[index].b,
                                      animate: animate,
                                      updateDisplayState: (displayQuestion) {
                                        setState(() => _questions[index].b = displayQuestion);
                                      },
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
                            : const ErrorPage(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                              message: "問題集が空です"
                            )
                        )
                      ],
                    )
                  ),
                ),
              ],
            ),
          );
        }
      )
      : const ErrorPage(
        margin: EdgeInsets.fromLTRB(20, 0, 0, 20),
        message: "表示できるテストがありません"
      );
  }
}
