import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contact.dart';
import '../datasources/hive_storage.dart';
import '../mock_data/belgian_contacts.dart';

class ContactRepository {
  final HiveStorage _storage;

  ContactRepository(this._storage);

  Future<List<Contact>> getAllContacts() async {
    try {
      final contacts = await _storage.getContacts();
      if (contacts.isEmpty) {
        // First time - populate with Belgian mock data
        final mockContacts = BelgianContactsData.getAllContacts();
        await _storage.saveContacts(mockContacts);
        return mockContacts;
      }
      return contacts;
    } catch (e) {
      // Fallback to mock data
      return BelgianContactsData.getAllContacts();
    }
  }

  Future<Contact?> getContactById(String id) async {
    final contacts = await getAllContacts();
    try {
      return contacts.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<Contact?> getContactByPhoneNumber(String phoneNumber) async {
    final contacts = await getAllContacts();
    try {
      return contacts.firstWhere((c) => c.phoneNumber == phoneNumber);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveContact(Contact contact) async {
    final contacts = await getAllContacts();
    final index = contacts.indexWhere((c) => c.id == contact.id);

    if (index >= 0) {
      contacts[index] = contact;
    } else {
      contacts.add(contact);
    }

    await _storage.saveContacts(contacts);
  }

  Future<void> deleteContact(String id) async {
    final contacts = await getAllContacts();
    contacts.removeWhere((c) => c.id == id);
    await _storage.saveContacts(contacts);
  }
}

// Provider
final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  final storage = ref.watch(hiveStorageProvider);
  return ContactRepository(storage);
});
