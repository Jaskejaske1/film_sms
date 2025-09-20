import '../entities/message_entity.dart'; // KEEP THIS - we need it!
import '../../data/repositories/conversation_repository.dart';
import '../../data/repositories/template_repository.dart';
import '../../data/repositories/contact_repository.dart';
import '../../core/templates/template_engine.dart';
import '../../data/mock_data/de_lijn_template.dart';
import '../../data/models/message.dart';
import '../../core/constants/belgian_constants.dart';

class GenerateDeLijnSMSUseCase {
  final ConversationRepository _conversationRepository;
  final TemplateRepository _templateRepository;
  final ContactRepository _contactRepository;

  GenerateDeLijnSMSUseCase(
    this._conversationRepository,
    this._templateRepository,
    this._contactRepository,
  );

  // Generate and inject De Lijn SMS - RETURNS MessageEntity
  Future<MessageEntity> generateAndInjectDeLijnSMS({
    String? customPrice,
  }) async {
    // Find De Lijn contact
    final deLijnContact = await _contactRepository.getContactByPhoneNumber(
      BelgianConstants.deLijnNumber,
    );

    if (deLijnContact == null) {
      throw Exception('De Lijn contact not found');
    }

    // Get De Lijn template
    var templates = await _templateRepository.getTemplatesForContact(
      deLijnContact.id,
    );
    // Fallback: if missing, create and save the default De Lijn template
    if (templates.isEmpty) {
      final created = DeLijnTemplateData.createDeLijnTemplate(deLijnContact.id);
      await _templateRepository.saveTemplate(created);
      templates = await _templateRepository.getTemplatesForContact(
        deLijnContact.id,
      );
    }
    final deLijnTemplate = templates.firstWhere(
      (t) => t.name.toLowerCase().contains('de lijn'),
    );

    // Prepare user inputs
    final userInputs = <String, String>{'price': customPrice ?? '2,50'};

    // Generate message using template engine
    final messageBody = TemplateEngine.processTemplate(
      deLijnTemplate,
      userInputs,
    );

    // Create message
    final message = Message(
      body: messageBody,
      timestamp: DateTime.now(),
      isIncoming: true,
      contactId: deLijnContact.id,
      type: MessageType.deLijn,
      templateId: deLijnTemplate.id,
    );

    // Add to conversation
    await _conversationRepository.addMessageToConversation(
      deLijnContact.id,
      message,
    );

    // Return domain entity (this is why we need the import!)
    return MessageEntity(
      id: message.id,
      body: message.body,
      timestamp: message.timestamp,
      isIncoming: message.isIncoming,
      contactId: message.contactId,
      type: MessageTypeEntity.deLijn,
      isRead: message.isRead,
      templateId: message.templateId,
    );
  }

  // Validate price input
  bool validatePrice(String? price) {
    if (price == null || price.trim().isEmpty) return false;

    final belgianPrice = price.replaceAll(',', '.');
    final parsed = double.tryParse(belgianPrice);

    return parsed != null && parsed > 0;
  }
}
