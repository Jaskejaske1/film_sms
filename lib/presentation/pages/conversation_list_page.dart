import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../presentation/providers/conversations_provider.dart';
import '../../presentation/providers/contacts_provider.dart';
import '../../presentation/widgets/conversation_tile.dart';
import '../../presentation/widgets/template_selector.dart';
import '../../core/templates/message_template.dart';
import '../../core/utils/belgian_formatter.dart';
import '../../core/constants/belgian_constants.dart';
import 'conversation_detail_page.dart';
import '../../l10n/app_localizations.dart';

class ConversationListPage extends ConsumerWidget {
  const ConversationListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = !kIsWeb && (io.Platform.isAndroid || io.Platform.isIOS);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.appTitle ?? 'Berichten'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'inject_delijn') {
                // Ensure init completed (contacts + templates) before injecting
                await ref.read(appInitProvider.future);
                final action = ref.read(injectDeLijnActionProvider);
                final res = await action();
                if (!context.mounted) return;
                final body = res.body;
                final preview = body.substring(
                  0,
                  body.length > 30 ? 30 : body.length,
                );
                final l10n = AppLocalizations.of(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n?.deLijnInsertedWithPreview(preview) ??
                          'De Lijn ingevoegd: $preview...',
                    ),
                  ),
                );
              } else if (value == 'inject_template') {
                final items = await ref.read(conversationsProvider.future);
                if (items.isEmpty) return;
                if (!context.mounted) return;
                // Prefer De Lijn contact if present; otherwise first contact with templates
                final contacts = await ref.read(contactsProvider.future);
                if (!context.mounted) return;
                final deLijn = contacts.firstWhere(
                  (c) => c.phoneNumber == BelgianConstants.deLijnNumber,
                  orElse: () => contacts.first,
                );
                final deLijnTemplates = await ref.read(
                  templatesForContactProvider(deLijn.id).future,
                );
                if (!context.mounted) return;
                final contactId = deLijnTemplates.isNotEmpty
                    ? deLijn.id
                    : items.first.contactId;
                await _showTemplateBottomSheet(context, ref, contactId);
              } else if (value == 'wipe_data') {
                final reseed = ref.read(reseedDataActionProvider);
                await reseed();
                if (!context.mounted) return;
                final l10n = AppLocalizations.of(context);
                final isMobile =
                    !kIsWeb && (io.Platform.isAndroid || io.Platform.isIOS);
                final text = isMobile
                    ? (l10n?.dataWipedMobile ??
                          'Data gewist — herstart de app voor een propere sessie.')
                    : (l10n?.dataWiped ??
                          'Data gewist en opnieuw geconfigureerd.');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(text),
                    action: isMobile
                        ? SnackBarAction(
                            label: l10n?.ok ?? 'OK',
                            onPressed: () {},
                          )
                        : null,
                  ),
                );
              } else if (value == 'hard_reset_exit') {
                final reseed = ref.read(reseedDataActionProvider);
                await reseed();
                if (!kIsWeb &&
                    (io.Platform.isWindows ||
                        io.Platform.isLinux ||
                        io.Platform.isMacOS)) {
                  io.exit(0);
                }
              } else if (value == 'settings') {
                if (!context.mounted) return;
                Navigator.of(context).pushNamed('/settings');
              }
            },
            itemBuilder: (context) {
              final l10n = AppLocalizations.of(context);
              return [
                PopupMenuItem(
                  value: 'inject_delijn',
                  child: Text(l10n?.menuInjectDeLijn ?? 'Inject De Lijn'),
                ),
                PopupMenuItem(
                  value: 'inject_template',
                  child: Text(l10n?.menuInjectTemplate ?? 'Inject Template…'),
                ),
                PopupMenuItem(
                  value: 'wipe_data',
                  child: Text(l10n?.menuWipeData ?? 'Wipe data'),
                ),
                PopupMenuItem(
                  value: 'settings',
                  child: Text(l10n?.menuSettings ?? 'Instellingen'),
                ),
                if (!isMobile)
                  PopupMenuItem(
                    value: 'hard_reset_exit',
                    child: Text(
                      l10n?.menuHardResetExit ?? 'Harde reset + afsluiten',
                    ),
                  ),
              ];
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final init = ref.watch(appInitProvider);
          final conversationsAsync = ref.watch(conversationsProvider);

          return init.when(
            loading: () => const _LoadingView(),
            error: (e, st) => _ErrorView(message: e.toString()),
            data: (_) => conversationsAsync.when(
              loading: () => const _LoadingView(),
              error: (e, st) => _ErrorView(message: e.toString()),
              data: (items) => ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final c = items[index];
                  final contact = ref.watch(contactByIdProvider(c.contactId));
                  final name = (contact?.name ?? '').trim();
                  final phone = contact?.phoneNumber;
                  final phoneTrimmed = phone?.trim();
                  final titleText = name.isNotEmpty
                      ? name
                      : (phoneTrimmed != null && phoneTrimmed.isNotEmpty
                            ? BelgianFormatter.formatBelgianPhone(phoneTrimmed)
                            : (AppLocalizations.of(context)?.unknownContact ??
                                  'Onbekend'));
                  return ConversationTile(
                    title: titleText,
                    phoneNumber: (() {
                      if (phoneTrimmed == null || phoneTrimmed.isEmpty) {
                        return null;
                      }
                      final formatted = BelgianFormatter.formatBelgianPhone(
                        phoneTrimmed,
                      );
                      // Avoid duplication: if title already matches formatted phone, skip subtitle
                      return titleText == formatted ? null : phoneTrimmed;
                    })(),
                    subtitle: c.lastMessageText,
                    unreadCount: c.unreadCount,
                    time: c.lastMessageTime,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ConversationDetailPage(contactId: c.contactId),
                        ),
                      );
                    },
                    onLongPress: () async {
                      await _showTemplateBottomSheet(context, ref, c.contactId);
                    },
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 8),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.message, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            l10n?.loading ?? 'Laden...',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(l10n?.errorWithMessage(message) ?? 'Fout: $message'),
      ),
    );
  }
}

Future<void> _showTemplateBottomSheet(
  BuildContext context,
  WidgetRef ref,
  String contactId,
) async {
  final templates = await ref.read(
    templatesForContactProvider(contactId).future,
  );
  if (!context.mounted) return;

  await showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: TemplateSelector(
          templates: templates,
          highlightPredicate: (t) => t.name.toLowerCase().contains('de lijn'),
          onSelected: (t) async {
            Navigator.of(ctx).pop();
            final inputs = await _promptUserInputs(ctx, t);
            if (inputs == null) return;
            try {
              final injectAction = ref.read(injectTemplateActionProvider);
              final res = await injectAction((
                contactId: contactId,
                templateId: t.id,
                userInputs: inputs,
              ));
              if (!ctx.mounted) return;
              final body = res.body;
              final preview = body.substring(
                0,
                body.length > 30 ? 30 : body.length,
              );
              final l10n = AppLocalizations.of(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n?.templateInsertedWithPreview(preview) ??
                        'Template ingevoegd: $preview...',
                  ),
                ),
              );
            } catch (e) {
              if (!ctx.mounted) return;
              final l10n = AppLocalizations.of(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n?.insertErrorWithMessage(e.toString()) ??
                        'Fout bij invoegen: $e',
                  ),
                ),
              );
            }
          },
        ),
      );
    },
  );
}

Future<Map<String, String>?> _promptUserInputs(
  BuildContext context,
  MessageTemplate template,
) async {
  final userVars = template.variables
      .where((v) => v.type.name == 'userInput')
      .toList();
  if (userVars.isEmpty) return <String, String>{};

  final controllers = {
    for (final v in userVars)
      v.key: TextEditingController(text: v.defaultValue ?? ''),
  };
  final formKey = GlobalKey<FormState>();

  return showDialog<Map<String, String>>(
    context: context,
    builder: (ctx) {
      final l10n = AppLocalizations.of(ctx);
      return AlertDialog(
        title: Text(l10n?.fillInData ?? 'Vul gegevens in'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final v in userVars)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextFormField(
                      controller: controllers[v.key],
                      decoration: InputDecoration(labelText: v.displayName),
                      validator: (val) => (val == null || val.trim().isEmpty)
                          ? (l10n?.required ?? 'Verplicht')
                          : null,
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: Text(l10n?.cancel ?? 'Annuleren'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() != true) return;
              final map = <String, String>{
                for (final v in userVars)
                  v.key: controllers[v.key]!.text.trim(),
              };
              if (map.containsKey('price')) {
                final raw = map['price']!.replaceAll(',', '.');
                final val = double.tryParse(raw) ?? 0.0;
                map['price'] = BelgianFormatter.formatPrice(val);
              }
              Navigator.of(ctx).pop(map);
            },
            child: Text(l10n?.ok ?? 'OK'),
          ),
        ],
      );
    },
  );
}
