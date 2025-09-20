import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_template.dart';
import '../datasources/hive_storage.dart';
import '../mock_data/de_lijn_template.dart';

class TemplateRepository {
  final HiveStorage _storage;

  TemplateRepository(this._storage);

  Future<List<MessageTemplate>> getAllTemplates() async {
    try {
      return await _storage.getTemplates();
    } catch (e) {
      return [];
    }
  }

  Future<List<MessageTemplate>> getTemplatesForContact(String contactId) async {
    final allTemplates = await getAllTemplates();
    return allTemplates
        .where((t) => t.contactId == contactId && t.isActive)
        .toList();
  }

  Future<MessageTemplate?> getTemplateById(String id) async {
    final templates = await getAllTemplates();
    try {
      return templates.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveTemplate(MessageTemplate template) async {
    await _storage.saveTemplate(template);
  }

  Future<void> deleteTemplate(String id) async {
    await _storage.deleteTemplate(id);
  }

  // Initialize default templates (De Lijn)
  Future<void> initializeDefaultTemplates(String deLijnContactId) async {
    final existingTemplates = await getTemplatesForContact(deLijnContactId);

    if (existingTemplates.isEmpty) {
      // Create De Lijn template
      final deLijnTemplate = DeLijnTemplateData.createDeLijnTemplate(
        deLijnContactId,
      );
      await saveTemplate(deLijnTemplate);
    }
  }
}

// Provider
final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  final storage = ref.watch(hiveStorageProvider);
  return TemplateRepository(storage);
});
