import 'dart:io';
import 'result_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../services/gemini_service.dart';
import '../services/pdf_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? selectedFile;

  String extractedText = '';
  String analysis = '';

  bool isLoading = false;

  Future<void> pickResume() async {
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      selectedFile = File(result.files.single.path!);

      setState(() {});
    }
  }

  Future<void> analyzeResume() async {

    setState(() {
      isLoading = true;
      analysis = '';
    });

    extractedText =
    await PdfService.extractText(selectedFile!);

    analysis =
    await GeminiService.analyzeResume(extractedText);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          result: analysis,
        ),
      ),
    );

    setState(() {
      isLoading = false;
    });
  }

  Widget buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color1,
    required Color color2,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [color1, color2],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              const Text(
                'AI Resume Analyzer',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(),

              const SizedBox(height: 8),

              const Text(
                'Analyze your resume with AI',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ).animate().fadeIn(delay: 300.ms),

              const SizedBox(height: 35),

              buildFeatureCard(
                icon: Icons.analytics,
                title: 'ATS Score',
                subtitle: 'Check resume performance',
                color1: const Color(0xFF6A11CB),
                color2: const Color(0xFF2575FC),
              ).animate().slideX(),

              const SizedBox(height: 18),

              buildFeatureCard(
                icon: Icons.psychology,
                title: 'AI Suggestions',
                subtitle: 'Improve your resume instantly',
                color1: const Color(0xFFFF512F),
                color2: const Color(0xFFDD2476),
              ).animate().slideX(delay: 200.ms),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: pickResume,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    selectedFile == null
                        ? 'Upload Resume PDF'
                        : 'Resume Selected',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: isLoading ? null : analyzeResume,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Analyze Resume',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}