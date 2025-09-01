import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/quote.dart';

class QuotesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user's favorite quotes
  Stream<List<Quote>> getFavoriteQuotes(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc('quotes')
        .collection('items')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Quote.fromMap({
          'id': doc.id,
          ...data,
        });
      }).toList();
    });
  }

  // Add quote to favorites
  Future<void> addToFavorites(String userId, Quote quote) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc('quotes')
        .collection('items')
        .doc(quote.id)
        .set({
      ...quote.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Remove quote from favorites
  Future<void> removeFromFavorites(String userId, String quoteId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc('quotes')
        .collection('items')
        .doc(quoteId)
        .delete();
  }

  // Check if quote is in favorites
  Future<bool> isFavorite(String userId, String quoteId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc('quotes')
        .collection('items')
        .doc(quoteId)
        .get();
    
    return doc.exists;
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String userId, Quote quote) async {
    final isFav = await isFavorite(userId, quote.id);
    
    if (isFav) {
      await removeFromFavorites(userId, quote.id);
    } else {
      await addToFavorites(userId, quote);
    }
  }
}
