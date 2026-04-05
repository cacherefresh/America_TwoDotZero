library web_2;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_view/markdown_view.dart';

/// A scaffold representing the Web 2.0 body with a list of markdown files on the left and the selected content on the right.
class Web2View extends StatefulWidget {
  const Web2View({super.key});

  @override
  State<Web2View> createState() => _Web2ViewState();
}

class _Web2ViewState extends State<Web2View> {
  List<String> markdownFiles = [];
  String selectedFile = 'assets/vault/MDs/IDEA_TEMPLATE.md';

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final AssetManifest manifest =
        await AssetManifest.loadFromAssetBundle(rootBundle);
    final List<String> allAssets = manifest.listAssets();
    setState(() {
      markdownFiles = allAssets
          .where((key) =>
              key.startsWith('assets/vault/MDs/') && key.endsWith('.md'))
          .toList();
      if (markdownFiles.isNotEmpty && !markdownFiles.contains(selectedFile)) {
        selectedFile = markdownFiles.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ListView.builder(
            itemCount: markdownFiles.length,
            itemBuilder: (context, index) {
              final file = markdownFiles[index];
              final fileName = file.split('/').last;
              return ListTile(
                title: Text(fileName),
                selected: file == selectedFile,
                onTap: () {
                  setState(() {
                    selectedFile = file;
                  });
                },
              );
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: FutureBuilder<String>(
            future: rootBundle.loadString(selectedFile),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return MarkdownDisplay(markdownText: snapshot.data ?? '');
              }
            },
          ),
        ),
      ],
    );
  }
}
