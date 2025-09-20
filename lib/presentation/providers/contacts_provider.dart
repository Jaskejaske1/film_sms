import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/contact_repository.dart';
import '../../data/models/contact.dart';

final contactsProvider = FutureProvider<List<Contact>>((ref) async {
  final repo = ref.watch(contactRepositoryProvider);
  return repo.getAllContacts();
});

final contactByIdProvider = Provider.family<Contact?, String>((ref, id) {
  final contactsAsync = ref.watch(contactsProvider);
  return contactsAsync.when(
    data: (list) => list.where((c) => c.id == id).cast<Contact?>().firstOrNull,
    loading: () => null,
    error: (_, __) => null,
  );
});
