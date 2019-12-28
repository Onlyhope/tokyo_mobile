class UnitConverter {

  static int lbsToGrams(int lbs) {
    return (lbs * 453.59237).round();
  }

  static int gramsToLbs(int grams) {
    return (grams / .0022046).round();
  }

  static int inchesToMillimeters(int inches) {
    return (inches * 25.4).round();
  }

  static int millimetersToInches(int millimeters) {
    return (millimeters / 0.03937007874).round();
  }

}