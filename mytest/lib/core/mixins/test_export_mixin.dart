import 'dart:convert';

import 'package:mytest/utils/file_utils.dart';
import 'dart:io';
import 'package:mytest/models/models.dart';
import 'package:path_provider/path_provider.dart';

mixin TestExportMixin {

  void testToTxt(Test test) async {
    String content = "";
    for (Question q in test.questions) {
      content += "Q${q.question}${q.answer}";
    }


    final Directory? downloadsDir = await getDownloadsDirectory();

  }


}