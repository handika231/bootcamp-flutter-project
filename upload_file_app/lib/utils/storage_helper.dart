import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class StorageHelper {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final Reference ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException {
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final Reference ref = FirebaseStorage.instance.ref(destination);
      return ref.putData(data);
    } on FirebaseException {
      return null;
    }
  }
}
