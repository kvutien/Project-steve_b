import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart'; // to use Markdown

const String _markdownData = """# Placeholder Page - Tab 4
""";

class Tab4 extends StatefulWidget {
  const Tab4({Key? key}) : super(key: key);
  @override
  _Tab4State createState() => _Tab4State();
}

class _Tab4State extends State<Tab4> {

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tab 4: placeholder',
      home: Scaffold(
        appBar: AppBar(title: const Text('Tab 4: placeholder'),),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Container(
                  child: MarkdownWidget(
                    data: _markdownData,
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
  //Widget buildMarkdown() => MarkdownWidget(data: _markdownData,);
}