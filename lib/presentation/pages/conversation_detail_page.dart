import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/conversations_provider.dart';
import '../../presentation/providers/contacts_provider.dart';
import '../widgets/message_bubble.dart';
import '../../l10n/app_localizations.dart';
import '../../core/utils/belgian_formatter.dart';

class ConversationDetailPage extends ConsumerStatefulWidget {
  final String contactId;
  const ConversationDetailPage({super.key, required this.contactId});

  @override
  ConsumerState<ConversationDetailPage> createState() =>
      _ConversationDetailPageState();
}

class _ConversationDetailPageState
    extends ConsumerState<ConversationDetailPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Mark as read when opening the conversation
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final mark = ref.read(markAsReadActionProvider);
      await mark(widget.contactId);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contact = ref.watch(contactByIdProvider(widget.contactId));
    final convoAsync = ref.watch(
      conversationByContactIdProvider(widget.contactId),
    );

    final l10n = AppLocalizations.of(context);
    final name = (contact?.name ?? '').trim();
    final rawPhone = contact?.phoneNumber;
    final phone = rawPhone?.trim();
    final titleText = name.isNotEmpty
        ? name
        : (phone != null && phone.isNotEmpty
              ? BelgianFormatter.formatBelgianPhone(phone)
              : (l10n?.conversations ?? 'Gesprek'));

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        bottom: (name.isNotEmpty && phone != null && phone.trim().isNotEmpty)
            ? PreferredSize(
                preferredSize: const Size.fromHeight(20),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    BelgianFormatter.formatBelgianPhone(phone.trim()),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: convoAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(
                child: Text(l10n?.errorWithMessage(e.toString()) ?? 'Fout: $e'),
              ),
              data: (conversation) {
                final messages = conversation?.messages ?? [];
                // Try to keep view at bottom after updates
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(
                      _scrollController.position.maxScrollExtent,
                    );
                  }
                });
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final m = messages[index];
                    return MessageBubble(
                      text: m.body,
                      isIncoming: m.isIncoming,
                      timestamp: m.timestamp,
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: (l10n?.typeMessageHint ?? 'Typ een bericht…'),
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () async {
                      final text = _controller.text.trim();
                      if (text.isEmpty) return;
                      final send = ref.read(sendMessageActionProvider);
                      await send((contactId: widget.contactId, body: text));
                      if (!mounted) return;
                      _controller.clear();
                      await Future<void>.delayed(
                        const Duration(milliseconds: 50),
                      );
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent + 80,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
