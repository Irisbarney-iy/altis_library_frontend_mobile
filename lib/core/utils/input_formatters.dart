import 'package:flutter/services.dart';

class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final trimmed = digitsOnly.length > 11 ? digitsOnly.substring(0, 11) : digitsOnly;
    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < trimmed.length; i++) {
      if (i == 3 || i == 6) buffer.write('.');
      if (i == 9) buffer.write('-');
      buffer.write(trimmed[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final trimmed = digitsOnly.length > 11 ? digitsOnly.substring(0, 11) : digitsOnly;
    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < trimmed.length; i++) {
      if (i == 0) buffer.write('(');
      if (i == 2) buffer.write(') ');

      if (trimmed.length == 10 && i == 6) {
        buffer.write('-');
      } else if (trimmed.length != 10 && i == 7) {
        buffer.write('-');
      }

      buffer.write(trimmed[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}