import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upload_file_app/widgets/button_widget.dart';

import '../utils/storage_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UploadTask? task;
  File? file;
  File? imageFile;
  @override
  Widget build(BuildContext context) {
    String fileName =
        file != null ? file!.path.split('/').last : 'No File Selected';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text('Firebase Upload File'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                icon: Icons.attach_file,
                text: 'Select File',
                onPressed: selectFile,
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                fileName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ButtonWidget(
                icon: Icons.cloud_upload_outlined,
                text: 'Upload File',
                onPressed: uploadFile,
              ),
              const SizedBox(
                height: 6,
              ),
              (task != null ? buildUploadTask(task!) : Container()),
              SizedBox(
                height: 20,
              ),
              ButtonWidget(
                  icon: Icons.camera,
                  text: 'Pick from camera',
                  onPressed: pickFromCamera),
              (imageFile != null
                  ? Text(imageFile!.path.split('/').last)
                  : Container())
            ],
          ),
        ),
      ),
    );
  }

  Future pickFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() {
      file = File(path);
    });
  }

  Future uploadFile() async {
    if (file == null) return;
    final fileName = file?.path.split('/').last;
    final destination = 'files/$fileName';
    task = StorageHelper.uploadFile(destination, file!);
    setState(() {});
    if (task == null) return;

    final snapshot = await task?.whenComplete(() {});
    final urlDownload = await snapshot?.ref.getDownloadURL();
    debugPrint('Download-Link: $urlDownload');
  }

  Widget buildUploadTask(UploadTask task) {
    if (task == null) return const SizedBox.shrink();

    return StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final snap = snapshot.data!;
          final progress = snap.bytesTransferred / snap.totalBytes;
          final percentage = (progress * 100).toStringAsFixed(2);
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            width: double.infinity,
            child: Column(
              children: [
                LinearProgressIndicator(value: progress),
                const SizedBox(
                  height: 6,
                ),
                Text('$percentage %'),
                percentage == '100.00'
                    ? const Text(
                        'Upload Completed',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
