import '../../core/templates/message_template.dart';
import '../../core/constants/belgian_constants.dart';

class DeLijnTemplateData {
  static MessageTemplate createDeLijnTemplate(String contactId) {
    return MessageTemplate(
      name: 'De Lijn Bus Ticket',
      description: 'Generates authentic De Lijn bus validation SMS',
      template: BelgianConstants.deLijnTemplateFormat,
      contactId: contactId,
      variables: [
        TemplateVariable(
          key: 'prefix_code',
          displayName: 'Prefix Code',
          type: VariableType.codeGenerator,
          config: {'pattern': 'prefix'}, // XX*XX format
        ),
        TemplateVariable(
          key: 'company',
          displayName: 'Transport Company',
          type: VariableType.static,
          defaultValue: BelgianConstants.deLijnCompany,
        ),
        TemplateVariable(
          key: 'expiry_time',
          displayName: 'Expiry Time',
          type: VariableType.timeCalculator,
        ),
        TemplateVariable(
          key: 'current_date',
          displayName: 'Current Date',
          type: VariableType.dateFormatter,
        ),
        TemplateVariable(
          key: 'price',
          displayName: 'Ticket Price (Euro)',
          type: VariableType.userInput,
          defaultValue: '2,50',
        ),
        TemplateVariable(
          key: 'validation_code',
          displayName: 'Validation Code',
          type: VariableType.codeGenerator,
          config: {'length': 23},
        ),
        TemplateVariable(
          key: 'footer',
          displayName: 'Footer Message',
          type: VariableType.static,
          defaultValue: BelgianConstants.deLijnFooter,
        ),
      ],
    );
  }
}
