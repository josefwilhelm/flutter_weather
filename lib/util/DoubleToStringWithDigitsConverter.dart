class DoubleToStringWithDigitsConverter {
  static String doubleToStringWithDigitsConverter(double value, {digits: 2}) {
    return value.toStringAsFixed(digits);
  }
}
