import 'package:flutter/material.dart';
import '../../core/templates/message_template.dart';

class TemplateSelector extends StatelessWidget {
  final List<MessageTemplate> templates;
  final ValueChanged<MessageTemplate> onSelected;
  final bool Function(MessageTemplate)? highlightPredicate;

  const TemplateSelector({
    super.key,
    required this.templates,
    required this.onSelected,
    this.highlightPredicate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: templates.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final t = templates[index];
        final isHighlighted = highlightPredicate?.call(t) ?? false;
        return ListTile(
          leading: isHighlighted
              ? const Icon(Icons.star, color: Colors.amber)
              : null,
          title: Text(t.name),
          subtitle: Text(t.description),
          onTap: () => onSelected(t),
        );
      },
    );
  }
}
