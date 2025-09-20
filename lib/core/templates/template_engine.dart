import '../utils/code_generator.dart';
import '../utils/belgian_formatter.dart';
import 'message_template.dart';

class TemplateEngine {
  /// Processes a template and replaces all variables with actual values
  static String processTemplate(
    MessageTemplate template,
    Map<String, String> userInputs,
  ) {
    String result = template.template;

    for (final variable in template.variables) {
      final placeholder = '{{${variable.key}}}';
      final value = _generateVariableValue(variable, userInputs);
      result = result.replaceAll(placeholder, value);
    }

    return result;
  }

  /// Generates the actual value for a template variable
  static String _generateVariableValue(
    TemplateVariable variable,
    Map<String, String> userInputs,
  ) {
    switch (variable.type) {
      case VariableType.userInput:
        return userInputs[variable.key] ?? variable.defaultValue ?? '';

      case VariableType.static:
        return variable.defaultValue ?? '';

      case VariableType.timeCalculator:
        return BelgianFormatter.getExpiryTime();

      case VariableType.dateFormatter:
        return BelgianFormatter.getCurrentDate();

      case VariableType.codeGenerator:
        final config = variable.config;
        if (config != null && config['pattern'] == 'prefix') {
          return CodeGenerator.generatePrefixCode();
        } else {
          final length = config?['length'] ?? 23;
          return CodeGenerator.generateValidationCode(length: length);
        }

      case VariableType.priceFormatter:
        final raw = userInputs[variable.key] ?? variable.defaultValue ?? '0';
        final normalized = raw.replaceAll(',', '.');
        final price = double.tryParse(normalized) ?? 0.0;
        return BelgianFormatter.formatPrice(price);
    }
  }

  /// Validates that all required user inputs are provided
  static Map<String, String> validateInputs(
    MessageTemplate template,
    Map<String, String> userInputs,
  ) {
    final errors = <String, String>{};

    for (final variable in template.variables) {
      if (variable.type == VariableType.userInput) {
        final value = userInputs[variable.key];
        if (value == null || value.trim().isEmpty) {
          errors[variable.key] = '${variable.displayName} is required';
        }
      }
    }

    return errors;
  }
}
