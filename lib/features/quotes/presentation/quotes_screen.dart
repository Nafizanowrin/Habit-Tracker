import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/quote.dart';

class QuotesScreen extends ConsumerStatefulWidget {
  const QuotesScreen({super.key});

  @override
  ConsumerState<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends ConsumerState<QuotesScreen> {
  bool _showFavoritesOnly = false;

  // Mock quotes data
  final List<Quote> _quotes = [
    const Quote(
      id: '1',
      text: 'The only way to do great work is to love what you do.',
      author: 'Steve Jobs',
      category: 'Motivation',
    ),
    const Quote(
      id: '2',
      text: 'Success is not final, failure is not fatal: it is the courage to continue that counts.',
      author: 'Winston Churchill',
      category: 'Success',
    ),
    const Quote(
      id: '3',
      text: 'The future belongs to those who believe in the beauty of their dreams.',
      author: 'Eleanor Roosevelt',
      category: 'Dreams',
    ),
    const Quote(
      id: '4',
      text: 'It does not matter how slowly you go as long as you do not stop.',
      author: 'Confucius',
      category: 'Persistence',
    ),
    const Quote(
      id: '5',
      text: 'The only limit to our realization of tomorrow will be our doubts of today.',
      author: 'Franklin D. Roosevelt',
      category: 'Optimism',
    ),
    const Quote(
      id: '6',
      text: 'What you get by achieving your goals is not as important as what you become by achieving your goals.',
      author: 'Zig Ziglar',
      category: 'Growth',
    ),
    const Quote(
      id: '7',
      text: 'The way to get started is to quit talking and begin doing.',
      author: 'Walt Disney',
      category: 'Action',
    ),
    const Quote(
      id: '8',
      text: 'Don\'t watch the clock; do what it does. Keep going.',
      author: 'Sam Levenson',
      category: 'Persistence',
    ),
  ];

  List<Quote> get _filteredQuotes {
    if (_showFavoritesOnly) {
      return _quotes.where((quote) => quote.isFavorite).toList();
    }
    return _quotes;
  }

  void _toggleFavorite(Quote quote) {
    setState(() {
      final index = _quotes.indexWhere((q) => q.id == quote.id);
      if (index != -1) {
        _quotes[index] = quote.copyWith(isFavorite: !quote.isFavorite);
      }
    });
  }

  void _copyToClipboard(Quote quote) {
    final text = '${quote.text} - ${quote.author}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quote copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _refreshQuotes() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quotes refreshed!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspirational Quotes'),
        actions: [
          IconButton(
            icon: Icon(
              _showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: () {
              setState(() {
                _showFavoritesOnly = !_showFavoritesOnly;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshQuotes,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshQuotes,
        child: _filteredQuotes.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _showFavoritesOnly ? Icons.favorite_border : Icons.format_quote,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _showFavoritesOnly 
                          ? 'No favorite quotes yet'
                          : 'No quotes available',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _showFavoritesOnly
                          ? 'Add quotes to your favorites to see them here'
                          : 'Pull to refresh for new quotes',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredQuotes.length,
                itemBuilder: (context, index) {
                  final quote = _filteredQuotes[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Quote text
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.format_quote_rounded,
                                  size: 20,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  quote.text,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    height: 1.6,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Author
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '- ${quote.author}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  // Copy button
                                  Container(
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.copy_rounded,
                                        color: theme.colorScheme.primary,
                                        size: 20,
                                      ),
                                      onPressed: () => _copyToClipboard(quote),
                                      tooltip: 'Copy quote',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Favorite button
                                  Container(
                                    decoration: BoxDecoration(
                                      color: quote.isFavorite 
                                          ? Colors.red.withOpacity(0.1)
                                          : Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        quote.isFavorite 
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_border_rounded,
                                        color: quote.isFavorite 
                                            ? Colors.red 
                                            : Colors.grey[600],
                                        size: 20,
                                      ),
                                      onPressed: () => _toggleFavorite(quote),
                                      tooltip: quote.isFavorite 
                                          ? 'Remove from favorites' 
                                          : 'Add to favorites',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          
                          // Category tag
                          if (quote.category != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.colorScheme.primary.withOpacity(0.2),
                                ),
                              ),
                              child: Text(
                                quote.category!,
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
