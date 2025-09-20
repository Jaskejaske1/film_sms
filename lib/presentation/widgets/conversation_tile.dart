import 'package:flutter/material.dart';
import '../../core/utils/belgian_formatter.dart';

class ConversationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final int unreadCount;
  final DateTime? time;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ConversationTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.unreadCount = 0,
    this.time,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: scheme.secondaryContainer,
        foregroundColor: scheme.onSecondaryContainer,
        child: Text(_initials(title)),
      ),
      title: Text(title),
      subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (time != null)
            Text(
              BelgianFormatter.formatListLabel(time!),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('$unreadCount'),
            ),
          ],
        ],
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }

  String _initials(String s) {
    final parts = s
        .trim()
        .split(RegExp(r"\s+"))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first;
    return (parts[0].characters.first + parts[1].characters.first)
        .toUpperCase();
  }

  // No local timestamp helper; using BelgianFormatter.formatListLabel
}
