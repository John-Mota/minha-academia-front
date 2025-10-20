import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final String confirmText;
  final String cancelText;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.confirmText = 'Confirmar',
    this.cancelText = 'Cancelar',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: const Color(0xFF1E2638),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            cancelText,
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEA4D3C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(confirmText, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
