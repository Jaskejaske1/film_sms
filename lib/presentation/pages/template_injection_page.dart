import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class TemplateInjectionPage extends StatelessWidget {
  const TemplateInjectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: Text(
          l10n?.templateInjectionHint ??
              'Template-injectie wordt via long-press afgehandeld.',
        ),
      ),
    );
  }
}
