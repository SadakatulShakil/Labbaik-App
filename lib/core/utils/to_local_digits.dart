const _bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

/// Converts ASCII digits 0-9 in [input] to Bangla numerals when
/// [langCode] is 'bn'; returns [input] unchanged otherwise.
String toLocalDigits(String input, String langCode) {
  if (langCode != 'bn') return input;

  final buffer = StringBuffer();
  for (final rune in input.runes) {
    final digit = rune - '0'.codeUnitAt(0);
    if (digit >= 0 && digit <= 9) {
      buffer.write(_bnDigits[digit]);
    } else {
      buffer.writeCharCode(rune);
    }
  }
  return buffer.toString();
}
