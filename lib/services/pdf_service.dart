import 'dart:io';

import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfService {
  static Future<String> extractText(File file) async {
    try {
      final bytes = await file.readAsBytes();

      final document = PdfDocument(inputBytes: bytes);

      String text = '';

      for (int i = 0; i < document.pages.count; i++) {
        text += PdfTextExtractor(document)
            .extractText(startPageIndex: i, endPageIndex: i);
      }

      document.dispose();

      return text;
    } catch (e) {
      return 'Error reading PDF: $e';
    }
  }
}