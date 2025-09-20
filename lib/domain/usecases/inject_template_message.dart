import '../entities/message_entity.dart'; // KEEP THIS - we need it!
import '../../data/repositories/conversation_repository.dart';
import '../../data/repositories/template_repository.dart';
import '../../core/templates/template_engine.dart';
import '../../data/models/message.dart';
import '../../core/templates/message_template.dart';

class InjectTemplateMessageUseCase {
  final ConversationRepository _conversationRepository;
  final TemplateRepository _templateRepository;

  InjectTemplateMessageUseCase(
    this._conversationRepository,
    this._templateRepository,
  );

  // Inject any template message - RETURNS MessageEntity
  Future<MessageEntity> injectTemplateMessage({
    required String contactId,
    required String templateId,
    required Map<String, String> userInputs,
  }) async {
    // Get template
    final template = await _templateRepository.getTemplateById(templateId);
    if (template == null) {
      throw Exception('Template not found');
    }

    // Validate inputs
    final errors = TemplateEngine.validateInputs(template, userInputs);
    if (errors.isNotEmpty) {
      throw Exception('Validation errors: ${errors.values.join(', ')}');
    }

    // Generate message
    final messageBody = TemplateEngine.processTemplate(template, userInputs);

    // Create message
    final message = Message(
      body: messageBody,
      timestamp: DateTime.now(),
      isIncoming: true,
      contactId: contactId,
      type: MessageType.template,
      templateId: templateId,
    );

    // Add to conversation
    await _conversationRepository.addMessageToConversation(contactId, message);

    // Return domain entity (this is why we need the import!)
    return MessageEntity(
      id: message.id,
      body: message.body,
      timestamp: message.timestamp,
      isIncoming: message.isIncoming,
      contactId: message.contactId,
      type: MessageTypeEntity.template,
      isRead: message.isRead,
      templateId: message.templateId,
    );
  }

  // Get available templates for contact
  Future<List<MessageTemplate>> getTemplatesForContact(String contactId) async {
    return await _templateRepository.getTemplatesForContact(contactId);
  }
}
