import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

import 'dart:io';


class FileUtils {

  // Path

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  // File Read/Write

  static Future<bool> deleteFile(String fileName) async {
    try {
      final file = await localFile(fileName);
      await file.delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<File> writeToFile(String data, String fileName) async {
    final file = await localFile(fileName);
    return file.writeAsString(data);
  }

  static Future<String?> readFile(String fileName) async {
    try {
      final file = await localFile(fileName);
      final contents = await file.readAsString();
      return contents;
    } catch (e) { return null; }
  }

  static Future<Image?> readImageFile(String fileName) async {
    try {
      final file = await localFile(fileName);
      if (await file.exists()) { return Image.file(file, fit: BoxFit.cover, height: double.infinity,); }
      return null;
    } catch (e) { return null; }
  }

  // Copy file

  static Future<File?> copyFile(File source, String fileName) async {
    try {
      final File target = await localFile(fileName);
      return await source.copy(target.path);
    } catch (e) { print(e); return null; }
  }

}