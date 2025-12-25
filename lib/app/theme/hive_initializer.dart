import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

List<Box> boxList = [];
Future<List<Box>> openBox() async {
  final document = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(document.path);

  var themeBox = await Hive.openBox("isDarkMode");
  boxList.add(themeBox);
  return boxList;
}
