import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_recognizer/common/component/ct_button.dart';
import 'package:url_recognizer/common/component/ct_text.dart';
import 'package:url_recognizer/common/component/ct_text_field.dart';
import 'package:url_recognizer/common/const/ct_colors.dart';
import 'package:url_recognizer/common/layout/ct_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = TextEditingController();
  final singleController = TextEditingController();


  @override
  void initState() {
    recognize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CTLayout(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              CTButton(
                color: CTColors.gray4,
                paddingHor: 20,
                onPressed: recognize,
                child: CTText('카메라', size: 15),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CTTextField(type: CTTextFieldType.multiline, controller: singleController),
              ),
              CTButton(
                color: CTColors.gray4,
                paddingHor: 20,
                onPressed: () async {
                  print(singleController.text);
                  Share.share(singleController.text);
                },
                child: CTText('카톡 공유', size: 15),
              ),
              CTTextField(type: CTTextFieldType.multiline, controller: controller),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> recognize() async {
    final XFile? photo = await ImagePicker().pickImage(source: ImageSource.camera);
    if (photo == null) return;

    final image = InputImage.fromFilePath(photo.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final out = await textRecognizer.processImage(image);
    final text = out.text;

    controller.text = text;
    final texts = text.split('\n');

    setState(() {
      final  url = texts.firstWhere((e) => e.startsWith('http'), orElse: () => '인식 불가');

      singleController.text = url;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    singleController.dispose();
    super.dispose();
  }
}
