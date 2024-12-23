import 'package:flutter/material.dart';

class ImportProgressDialog extends StatefulWidget {
  final void Function(ImportProgressDialogState state) onInit;

  const ImportProgressDialog({
    super.key,
    required this.onInit,
  });

  @override
  State<ImportProgressDialog> createState() => ImportProgressDialogState();
}

class ImportProgressDialogState extends State<ImportProgressDialog> {
  double _progress = 0.0;
  String _message = '正在扫描本地音乐...';

  @override
  void initState() {
    super.initState();
    widget.onInit(this);
  }

  void updateProgress(double progress, String message) {
    setState(() {
      _progress = progress;
      _message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _progress),
          const SizedBox(height: 16),
          Text(_message),
        ],
      ),
    );
  }
}
