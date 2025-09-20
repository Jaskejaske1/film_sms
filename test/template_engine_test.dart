import 'package:flutter_test/flutter_test.dart';
import 'package:film_sms/core/templates/template_engine.dart';
import 'package:film_sms/core/templates/message_template.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('nl_BE', null);
    await initializeDateFormatting('nl', null);
  });
  group('TemplateEngine', () {
    test('replaces userInput and static variables', () {
      final tmpl = MessageTemplate(
        name: 'Test',
        description: 'desc',
        template: 'Hello {{name}}, today is {{day}}.',
        variables: [
          TemplateVariable(
            key: 'name',
            displayName: 'Name',
            type: VariableType.userInput,
          ),
          TemplateVariable(
            key: 'day',
            displayName: 'Day',
            type: VariableType.static,
            defaultValue: 'Monday',
          ),
        ],
        contactId: 'c1',
      );

      final result = TemplateEngine.processTemplate(tmpl, {'name': 'Alice'});
      expect(result, 'Hello Alice, today is Monday.');
    });

    test('generates codes for codeGenerator variables', () {
      final tmpl = MessageTemplate(
        name: 'Codes',
        description: 'desc',
        template: '{{prefix}} {{code}}',
        variables: [
          TemplateVariable(
            key: 'prefix',
            displayName: 'Prefix',
            type: VariableType.codeGenerator,
            config: {'pattern': 'prefix'},
          ),
          TemplateVariable(
            key: 'code',
            displayName: 'Code',
            type: VariableType.codeGenerator,
            config: {'length': 10},
          ),
        ],
        contactId: 'c1',
      );

      final result = TemplateEngine.processTemplate(tmpl, {});
      final parts = result.split(' ');
      expect(parts.length, 2);
      // Prefix should be of form XX*XX (length 5 with a '*')
      expect(parts.first.length, 5);
      expect(parts.first.contains('*'), true);
      expect(parts.last.length, 10);
    });

    test('time and date variables produce non-empty outputs', () {
      final tmpl = MessageTemplate(
        name: 'TimeDate',
        description: 'desc',
        template: 'exp: {{expiry}} date: {{date}}',
        variables: [
          TemplateVariable(
            key: 'expiry',
            displayName: 'Expiry',
            type: VariableType.timeCalculator,
          ),
          TemplateVariable(
            key: 'date',
            displayName: 'Date',
            type: VariableType.dateFormatter,
          ),
        ],
        contactId: 'c1',
      );

      final result = TemplateEngine.processTemplate(tmpl, {});
      expect(result.contains('exp: '), true);
      expect(result.contains('date: '), true);
      // contains 'u' for time format like 07u56
      expect(result.contains('u'), true);
    });

    test('priceFormatter handles comma and dot decimals', () {
      final tmpl = MessageTemplate(
        name: 'Price',
        description: 'desc',
        template: 'Prijs: {{price}} euro',
        variables: [
          TemplateVariable(
            key: 'price',
            displayName: 'Price',
            type: VariableType.priceFormatter,
            defaultValue: '2,50',
          ),
        ],
        contactId: 'c1',
      );

      final resultDefault = TemplateEngine.processTemplate(tmpl, {});
      expect(resultDefault, 'Prijs: 2,50 euro');

      final resultComma = TemplateEngine.processTemplate(tmpl, {
        'price': '3,2',
      });
      expect(resultComma, 'Prijs: 3,20 euro');

      final resultDot = TemplateEngine.processTemplate(tmpl, {'price': '4.5'});
      expect(resultDot, 'Prijs: 4,50 euro');
    });

    test('validateInputs returns errors for missing user input', () {
      final tmpl = MessageTemplate(
        name: 'Validate',
        description: 'desc',
        template: 'Hi {{name}}',
        variables: [
          TemplateVariable(
            key: 'name',
            displayName: 'Name',
            type: VariableType.userInput,
          ),
        ],
        contactId: 'c1',
      );

      final errors = TemplateEngine.validateInputs(tmpl, {});
      expect(errors.containsKey('name'), true);
    });
  });
}
