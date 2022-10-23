import 'package:flutter/material.dart';
import 'package:upload_file_app/widgets/button_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
            ),
            const SizedBox(
              height: 6,
            ),
            const Text(
              'No file selected',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        )),
      ),
    );
  }
}
