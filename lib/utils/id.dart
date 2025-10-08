class Id {
  static int generate() => DateTime.now().millisecondsSinceEpoch;

  static String generateString() => generate().toString();
}
