import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class AdminControls extends StatelessWidget {
  final VoidCallback onInjectDeLijn;
  final VoidCallback onInjectTemplate;
  final VoidCallback onWipeData;

  const AdminControls({
    super.key,
    required this.onInjectDeLijn,
    required this.onInjectTemplate,
    required this.onWipeData,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: 8,
      children: [
        FilledButton.icon(
          onPressed: onInjectDeLijn,
          icon: const Icon(Icons.directions_bus),
          label: Text(l10n?.menuInjectDeLijn ?? 'Inject De Lijn'),
        ),
        OutlinedButton.icon(
          onPressed: onInjectTemplate,
          icon: const Icon(Icons.article),
          label: Text(l10n?.menuInjectTemplate ?? 'Inject Template…'),
        ),
        TextButton.icon(
          onPressed: onWipeData,
          icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
          label: Text(l10n?.menuWipeData ?? 'Wipe data'),
        ),
      ],
    );
  }
}
