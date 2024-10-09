import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:movie_hub/views/home_screen.dart';


void main() {
    testWidgets('Widget test example', (WidgetTester tester) async {
    await tester.pumpWidget(const HomeScreen());
    expect(find.text('Search Movies'), findsOneWidget);
  });
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello, World!'),
        ),
      ),
    );
  }
}