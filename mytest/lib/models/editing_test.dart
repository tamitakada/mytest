import 'test.dart';
import 'package:mytest/utils/data_manager.dart';

class EditingTest {

  Test? test;

  String title;
  int order;

  EditingTest({ required this.title, required this.order, this.test });
  EditingTest.test(Test this.test) :
    title = test.title,
    order = test.order;

  Future<bool> upsertTest() {
    test ??= Test(title: title, order: order);
    test?.title = title;
    test?.order = order;
    return DataManager.upsertTest(test!);
  }

}