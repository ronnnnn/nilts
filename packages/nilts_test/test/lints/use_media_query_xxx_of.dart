import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // expect_lint: use_media_query_xxx_of
    MediaQuery.of(context);
    // expect_lint: use_media_query_xxx_of
    MediaQuery.maybeOf(context);

    // expect_lint: use_media_query_xxx_of
    final size = MediaQuery.of(context).size;
    final nullableSize =
        // expect_lint: use_media_query_xxx_of
        MediaQuery.of(context)?.size; // ignore: invalid_null_aware_operator
    // expect_lint: use_media_query_xxx_of
    final maybeSize = MediaQuery.maybeOf(context)?.size;

    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
