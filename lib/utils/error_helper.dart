class ErrorHelper {
  static String getReadableError(String error) {
    final lowerError = error.toLowerCase();

    if (lowerError.contains('socketexception') ||
        lowerError.contains('failed host lookup') ||
        lowerError.contains('no address associated') ||
        lowerError.contains('network is unreachable')) {
      return 'No internet connection. Please check your network and try again.';
    }

    if (lowerError.contains('timeout') || lowerError.contains('timed out')) {
      return 'Connection timed out. Please check your internet and try again.';
    }

    if (lowerError.contains('404') || lowerError.contains('not found')) {
      return 'Data not found. Please try again later.';
    }

    if (lowerError.contains('500') ||
        lowerError.contains('server error') ||
        lowerError.contains('internal server')) {
      return 'Server error occurred. Please try again later.';
    }

    if (lowerError.contains('failed to load')) {
      return 'Failed to load data. Please check your connection and try again.';
    }

    if (lowerError.contains('failed to search')) {
      return 'Search failed. Please try again.';
    }

    if (lowerError.contains('failed to add review')) {
      return 'Failed to submit review. Please try again.';
    }

    if (lowerError.contains('connection refused') ||
        lowerError.contains('connection reset')) {
      return 'Connection to server lost. Please try again.';
    }

    return 'Something went wrong. Please try again later.';
  }
}
