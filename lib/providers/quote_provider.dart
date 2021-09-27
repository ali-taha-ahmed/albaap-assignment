import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:quotes_app/models/quote_model.dart';
import 'package:quotes_app/repositories/quote_repo.dart';
import 'package:share/share.dart';

class QuoteProvider extends ChangeNotifier {
  late final Box<QuoteModel> _quoteList;
  Box<QuoteModel> get quoteList => _quoteList;

  QuoteProvider(Box<QuoteModel> quotesBox) {
    _quoteList = quotesBox;
    loadQuotes();
  }
  List<QuoteModel> get favoriteQuoteList =>
      _quoteList.values.where((element) => element.isLiked == true).toList();

  Future<void> loadQuotes() async {
    try {
      var data = await QuoteRepository.fetchQuote();
      if (data.isSuccessful) {
        _quoteList.add(data.data!);
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  likeQuote(int index) {
    if (!_quoteList.getAt(index)!.isLiked) {
      _quoteList.getAt(index)!.isLiked = true;
      notifyListeners();
    }
  }

  dislikeQuote(int index) {
    if (_quoteList.getAt(index)!.isLiked) {
      _quoteList.getAt(index)!.isLiked = false;
      notifyListeners();
    }
  }

  deleteQuote(int index) {
    if (_quoteList.isNotEmpty) {
      loadQuotes();
      _quoteList.deleteAt(index);
      notifyListeners();
    }
  }

  share(int index) {
    Share.share(
        '\n"${_quoteList.getAt(index)!.quote}"\n\t\t\t\t ${_quoteList.getAt(index)!.author}');
  }
}
