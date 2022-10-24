import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageHelper {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final Reference ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException {
      return null;
    }
  }
}
