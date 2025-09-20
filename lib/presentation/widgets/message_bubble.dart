import 'package:flutter/material.dart';
import '../../core/utils/belgian_formatter.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isIncoming;
  final DateTime timestamp;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isIncoming,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = isIncoming ? scheme.surfaceContainerHighest : scheme.primary;
    final fg = isIncoming ? scheme.onSurface : scheme.onPrimary;

    return Align(
      alignment: isIncoming ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Card(
          color: bg,
          margin: EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: isIncoming ? 8 : 48,
            right: isIncoming ? 48 : 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: isIncoming
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(text, style: TextStyle(color: fg)),
                const SizedBox(height: 6),
                Text(
                  BelgianFormatter.formatBubbleLabel(timestamp),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: fg.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
