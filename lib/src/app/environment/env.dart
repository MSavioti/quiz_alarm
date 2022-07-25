class Env {
  static const String baseUrl = 'https://opentdb.com/api.php';

  static Map<String, dynamic> questionParameters({
    required int amount,
    required String category,
    required String difficulty,
  }) {
    return {
      'amount': amount,
      'category': category,
      'difficulty': difficulty,
      'type': 'multiple',
    };
  }
}
