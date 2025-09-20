import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode, debugPrint;
import 'dart:io' show Platform;
import '../models/contact.dart';
import '../models/message.dart';
import '../models/conversation.dart';
import '../models/message_template.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HiveStorage {
  static const String _contactsBox = 'contacts';
  static const String _conversationsBox = 'conversations';
  static const String _templatesBox = 'templates';
  static const String _settingsBox = 'settings';

  late Box<Contact> _contactBox;
  late Box<Conversation> _conversationBox;
  late Box<MessageTemplate> _templateBox;
  Box? _settings;

  Future<void> init() async {
    // Platform-aware storage location:
    // - Web: IndexedDB (default)
    // - Mobile: default app sandbox (no explicit path)
    // - Desktop: Application Support dir with subfolder
    String? resolvedPath;
    if (kIsWeb) {
      await Hive.initFlutter();
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final baseDir = await getApplicationSupportDirectory();
      resolvedPath = '${baseDir.path}/film_sms';
      await Hive.initFlutter(resolvedPath);
    } else {
      await Hive.initFlutter();
    }

    if (!kIsWeb && kDebugMode) {
      debugPrint(
        'Hive path: \'${resolvedPath ?? '(default by HiveFlutter)'}\'',
      );
    }

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ContactAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ContactTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(MessageAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(MessageTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(ConversationAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(MessageTemplateAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(TemplateVariableAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(VariableTypeAdapter());
    }

    // Open boxes
    _contactBox = await Hive.openBox<Contact>(_contactsBox);
    _conversationBox = await Hive.openBox<Conversation>(_conversationsBox);
    _templateBox = await Hive.openBox<MessageTemplate>(_templatesBox);
    _settings = await Hive.openBox(_settingsBox);
  }

  // Contact operations
  Future<List<Contact>> getContacts() async {
    return _contactBox.values.toList();
  }

  Future<void> saveContacts(List<Contact> contacts) async {
    await _contactBox.clear();
    for (final contact in contacts) {
      await _contactBox.put(contact.id, contact);
    }
  }

  Future<void> saveContact(Contact contact) async {
    await _contactBox.put(contact.id, contact);
  }

  Future<void> deleteContact(String id) async {
    await _contactBox.delete(id);
  }

  // Conversation operations
  Future<List<Conversation>> getConversations() async {
    return _conversationBox.values.toList();
  }

  Future<void> saveConversations(List<Conversation> conversations) async {
    await _conversationBox.clear();
    for (final conversation in conversations) {
      await _conversationBox.put(conversation.id, conversation);
    }
  }

  Future<void> saveConversation(Conversation conversation) async {
    await _conversationBox.put(conversation.id, conversation);
  }

  Future<void> deleteConversation(String id) async {
    await _conversationBox.delete(id);
  }

  // Template operations
  Future<List<MessageTemplate>> getTemplates() async {
    return _templateBox.values.toList();
  }

  Future<void> saveTemplate(MessageTemplate template) async {
    await _templateBox.put(template.id, template);
  }

  Future<void> deleteTemplate(String id) async {
    await _templateBox.delete(id);
  }

  // Cleanup
  Future<void> clearAll() async {
    await _contactBox.clear();
    await _conversationBox.clear();
    await _templateBox.clear();
    await _settings?.clear();
  }

  // Hard reset: closes, deletes, and reopens boxes to guarantee a clean state
  Future<void> hardReset() async {
    // Close boxes
    await _contactBox.close();
    await _conversationBox.close();
    await _templateBox.close();
    await _settings?.close();

    // Delete boxes from disk
    await Hive.deleteBoxFromDisk(_contactsBox);
    await Hive.deleteBoxFromDisk(_conversationsBox);
    await Hive.deleteBoxFromDisk(_templatesBox);
    await Hive.deleteBoxFromDisk(_settingsBox);

    // Reopen fresh boxes
    _contactBox = await Hive.openBox<Contact>(_contactsBox);
    _conversationBox = await Hive.openBox<Conversation>(_conversationsBox);
    _templateBox = await Hive.openBox<MessageTemplate>(_templatesBox);
    _settings = await Hive.openBox(_settingsBox);
  }

  // Settings operations
  Future<String?> getLanguageOverride() async {
    try {
      return _settings?.get('language_code') as String?;
    } catch (_) {
      return null;
    }
  }

  Future<void> setLanguageOverride(String? code) async {
    try {
      if (_settings == null) return; // ignore if not initialized
      if (code == null || code.isEmpty) {
        await _settings!.delete('language_code');
      } else {
        await _settings!.put('language_code', code);
      }
    } catch (_) {
      // ignore in case hive not initialized (e.g., in pure widget tests)
    }
  }
}

// Provider

final hiveStorageProvider = Provider<HiveStorage>((ref) {
  return HiveStorage();
});
