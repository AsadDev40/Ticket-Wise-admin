import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FileUploadProvider extends ChangeNotifier {
  final _storageRef = FirebaseStorage.instance.ref();

  Future<List<String>> uploadMultipleFiles(
      {required List<File> files, required String folder}) async {
    List<String> fileUrls = [];

    for (File file in files) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final uploadTask = _storageRef.child('$folder/$fileName').putFile(file);
      final snapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshot.ref.getDownloadURL();
      fileUrls.add(imageUrl);
    }

    return fileUrls;
  }

  Future<String?> fileUpload(
      {required File file,
      required String fileName,
      required String folder}) async {
    try {
      final uploadTask = _storageRef.child('$folder/$fileName').putFile(file);
      final snapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> updateFile(
      {required File file,
      required String oldImageUrl,
      required String folder,
      required String name}) async {
    try {
      // Extract the file name from the old URL
      String fileName = name;

      // Delete the old file
      final oldFileRef = _storageRef.child('$folder/$fileName');
      await oldFileRef.delete();

      // Upload the new file with the same name
      final uploadTask = _storageRef.child('$folder/$fileName').putFile(file);
      final snapshot = await uploadTask.whenComplete(() => null);
      final newImageUrl = await snapshot.ref.getDownloadURL();
      return newImageUrl;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
