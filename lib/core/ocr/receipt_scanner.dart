import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import 'receipt_parser.dart';

class ScanResult {
  const ScanResult({required this.parsed, required this.rawText});
  final ParsedReceipt parsed;
  final String rawText;
}

class ReceiptScanner {
  ReceiptScanner({ImagePicker? picker, TextRecognizer? recognizer})
      : _picker = picker ?? ImagePicker(),
        _recognizer =
            recognizer ?? TextRecognizer(script: TextRecognitionScript.latin);

  final ImagePicker _picker;
  final TextRecognizer _recognizer;

  Future<ScanResult?> scan({required ImageSource source}) async {
    final picked = await _picker.pickImage(source: source);
    if (picked == null) return null;
    final input = InputImage.fromFilePath(picked.path);
    final result = await _recognizer.processImage(input);
    return ScanResult(
      parsed: parseReceipt(result.text),
      rawText: result.text,
    );
  }

  void dispose() {
    _recognizer.close();
  }
}
