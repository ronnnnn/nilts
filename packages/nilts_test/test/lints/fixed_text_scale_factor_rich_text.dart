import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            // expect_lint: fixed_text_scale_factor_rich_text
            RichText(
              text: const TextSpan(
                text: 'Hello World!',
              ),
            ),
            RichText(
              text: const TextSpan(
                text: 'Hello World!',
              ),
              textScaleFactor: MediaQuery.textScaleFactorOf(context),
            ),
          ],
        ),
      ),
    );
  }
}
