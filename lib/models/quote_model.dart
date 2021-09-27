import 'package:hive/hive.dart';

part 'quote_model.g.dart';

@HiveType(typeId: 0)
class QuoteModel {
  QuoteModel({
    required this.author,
    required this.id,
    required this.quote,
    required this.permalink,
  });
  @HiveField(0)
  late final String author;
  @HiveField(1)
  late final int id;
  @HiveField(2)
  late final String quote;
  @HiveField(3)
  late final String permalink;
  @HiveField(4)
  late bool isLiked;

  QuoteModel.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    id = json['id'];
    quote = json['quote'];
    permalink = json['permalink'];
    isLiked = false;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['author'] = author;
    _data['id'] = id;
    _data['quote'] = quote;
    _data['permalink'] = permalink;
    return _data;
  }
}
