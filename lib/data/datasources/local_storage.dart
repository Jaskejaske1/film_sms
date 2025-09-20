abstract class LocalStorage {
  Future<void> init();

  // Contact operations
  Future<List<Map<String, dynamic>>> getContacts();
  Future<void> saveContacts(List<Map<String, dynamic>> contacts);
  Future<void> saveContact(Map<String, dynamic> contact);
  Future<void> deleteContact(String id);

  // Conversation operations
  Future<List<Map<String, dynamic>>> getConversations();
  Future<void> saveConversations(List<Map<String, dynamic>> conversations);
  Future<void> saveConversation(Map<String, dynamic> conversation);
  Future<void> deleteConversation(String id);

  // Template operations
  Future<List<Map<String, dynamic>>> getTemplates();
  Future<void> saveTemplate(Map<String, dynamic> template);
  Future<void> deleteTemplate(String id);

  Future<void> clearAll();
}
