import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String result;

  const ResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {

    final strengths = extractSection(
      result,
      "Key strengths:",
      "Missing skills:",
    );

    final suggestions = extractSection(
      result,
      "Suggestions for improvement:",
      "Best suited job roles:",
    );

    final roles = extractSection(
      result,
      "Best suited job roles:",
      null,
    );

    final atsScore = extractATS(result);

    return Scaffold(
      backgroundColor: const Color(0xFF050B2B),

      appBar: AppBar(
        backgroundColor: const Color(0xFF111936),
        elevation: 0,

        title: const Text(
          "Analysis Result",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            /// ATS SCORE CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF7F00FF),
                    Color(0xFF2563EB),
                  ],
                ),

                borderRadius: BorderRadius.circular(28),
              ),

              child: Column(
                children: [

                  const Text(
                    "ATS SCORE",
                    style: TextStyle(
                      color: Colors.white70,
                      letterSpacing: 3,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    atsScore,
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// STRENGTHS
            buildSection(
              title: "Key Strengths",
              icon: Icons.star,
              color: Colors.green,
              content: strengths,
            ),

            const SizedBox(height: 22),

            /// SUGGESTIONS
            buildSection(
              title: "Suggestions",
              icon: Icons.lightbulb,
              color: Colors.orange,
              content: suggestions,
            ),

            const SizedBox(height: 22),

            /// ROLES
            buildSection(
              title: "Recommended Roles",
              icon: Icons.work,
              color: Colors.blue,
              content: roles,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required String content,
  }) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: const Color(0xFF111936),
        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          /// HEADER
          Row(
            children: [

              Icon(
                icon,
                color: color,
                size: 32,
              ),

              const SizedBox(width: 12),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          /// BULLET POINTS
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: content
                .split(RegExp(r'[\n,•-]+'))
                .where(
                  (line) =>
              line.trim().isNotEmpty,
            )
                .map(
                  (line) => Padding(
                padding:
                const EdgeInsets.only(
                  bottom: 12,
                ),

                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    const Text(
                      "• ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),

                    Expanded(
                      child: Text(
                        line.trim(),

                        style:
                        const TextStyle(
                          color:
                          Colors.white70,
                          height: 1.7,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}

/// EXTRACT SECTION
String extractSection(
    String text,
    String start,
    String? end,
    ) {

  final startIndex = text.indexOf(start);

  if (startIndex == -1) return '';

  final fromStart =
  text.substring(startIndex + start.length);

  if (end == null) {

    return fromStart
        .replaceAll(
      RegExp(r'\d+\.'),
      '',
    )
        .trim();
  }

  final endIndex = fromStart.indexOf(end);

  if (endIndex == -1) {

    return fromStart
        .replaceAll(
      RegExp(r'\d+\.'),
      '',
    )
        .trim();
  }

  return fromStart
      .substring(0, endIndex)
      .replaceAll(
    RegExp(r'\d+\.'),
    '',
  )
      .trim();
}

/// EXTRACT ATS SCORE
String extractATS(String text) {

  final regex =
  RegExp(r'ATS Score:\s*(\d+\/100)');

  final match =
  regex.firstMatch(text);

  if (match != null) {
    return match.group(1)!;
  }

  return "75/100";
}