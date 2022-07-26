class HiveConstants {
  static const String storedQuestionsBoxName = 'questions';

  static String storedQuestionskey({
    required String category,
    required String difficulty,
  }) {
    return '$category-$difficulty';
  }
}
