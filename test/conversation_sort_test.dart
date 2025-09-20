import 'package:flutter_test/flutter_test.dart';
import 'package:film_sms/data/repositories/conversation_repository.dart';
import 'package:film_sms/data/repositories/contact_repository.dart';
import 'package:film_sms/data/datasources/hive_storage.dart';
import 'package:film_sms/data/models/conversation.dart';
import 'package:film_sms/data/models/contact.dart';

class _FakeStorage extends HiveStorage {
  List<Conversation> conversations;
  _FakeStorage(this.conversations);

  @override
  Future<List<Conversation>> getConversations() async => conversations;

  @override
  Future<void> saveConversation(Conversation conversation) async {
    final idx = conversations.indexWhere((c) => c.id == conversation.id);
    if (idx >= 0) {
      conversations[idx] = conversation;
    } else {
      conversations.add(conversation);
    }
  }

  // Contacts/templates not used in this test; keep default behavior
}

class _FakeStorageForContacts extends HiveStorage {
  @override
  Future<List<Contact>> getContacts() async => <Contact>[];
}

void main() {
  test('Stable sort uses id tiebreaker on equal timestamps', () async {
    final ts = DateTime(2024, 1, 1, 12, 0, 0);
    final a = Conversation(id: '1', contactId: 'c1', lastMessageTime: ts);
    final b = Conversation(id: '2', contactId: 'c2', lastMessageTime: ts);

    final storage = _FakeStorage([a, b]);
    final contactRepo = ContactRepository(_FakeStorageForContacts());
    final repo = ConversationRepository(storage, contactRepo);

    final sorted = await repo.getConversationsSorted();
    expect(sorted.length, 2);
    // Since timestamps equal, order by id ascending: '1' then '2'
    expect(sorted.first.id, '1');
    expect(sorted.last.id, '2');

    // Reverse input and ensure result is still stable
    storage.conversations = [b, a];
    final sorted2 = await repo.getConversationsSorted();
    expect(sorted2.first.id, '1');
    expect(sorted2.last.id, '2');
  });
}
