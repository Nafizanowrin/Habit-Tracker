import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/quotes_repository.dart';
import '../domain/quote.dart';
import '../../auth/presentation/auth_provider.dart';

// Repository provider
final quotesRepositoryProvider = Provider<QuotesRepository>((ref) {
  return QuotesRepository();
});

// Favorite quotes stream provider
final favoriteQuotesStreamProvider = StreamProvider<List<Quote>>((ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return Stream.value([]);
  
  final repository = ref.read(quotesRepositoryProvider);
  return repository.getFavoriteQuotes(user.id);
});

// Quotes controller provider
final quotesControllerProvider = Provider<QuotesController>((ref) {
  final repository = ref.read(quotesRepositoryProvider);
  final user = ref.watch(currentUserProvider).value;
  return QuotesController(repository, user?.id);
});

class QuotesController {
  final QuotesRepository _repository;
  final String? _userId;

  QuotesController(this._repository, this._userId);

  Future<void> addToFavorites(Quote quote) async {
    if (_userId == null) throw Exception('User not authenticated');
    await _repository.addToFavorites(_userId, quote);
  }

  Future<void> removeFromFavorites(String quoteId) async {
    if (_userId == null) throw Exception('User not authenticated');
    await _repository.removeFromFavorites(_userId, quoteId);
  }

  Future<void> toggleFavorite(Quote quote) async {
    if (_userId == null) throw Exception('User not authenticated');
    await _repository.toggleFavorite(_userId, quote);
  }

  Future<bool> isFavorite(String quoteId) async {
    if (_userId == null) return false;
    return await _repository.isFavorite(_userId, quoteId);
  }
}
