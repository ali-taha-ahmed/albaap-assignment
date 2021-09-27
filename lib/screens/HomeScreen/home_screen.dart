import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quotes_app/providers/quote_provider.dart';
import 'package:share/share.dart';
import 'widgets/quote_widget.dart';
import 'widgets/favorite_quote_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  bool _online = false;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isFavoriteList = false;
  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    loadInitialData();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        setState(() => _online = true);
        break;
      case ConnectivityResult.none:
      default:
        setState(() => _online = false);
        break;
    }
  }

  loadInitialData() async {
    setState(() {
      _isLoading = true;
    });
    await context.read<QuoteProvider>().loadQuotes();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<QuoteProvider>();
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade200,
      appBar: _online
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(30),
              child: AppBar(
                backgroundColor: Colors.grey,
                title: const Text("No Internet Connection"),
                centerTitle: true,
              ),
            ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(children: [
                _isFavoriteList
                    ? provider.favoriteQuoteList.isEmpty
                        ? const Center(
                            child: Text("No Favorite Quotes",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18)),
                          )
                        : Swiper(
                            itemCount: provider.favoriteQuoteList.length,
                            loop: false,
                            duration: 700,
                            autoplay: false,
                            itemBuilder: (BuildContext context, int index) {
                              return FavoriteQuoteWidget(
                                quote: provider.favoriteQuoteList[index].quote,
                                author:
                                    provider.favoriteQuoteList[index].author,
                                onShareTap: () {
                                  Share.share(
                                      '\n"${provider.favoriteQuoteList[index].quote}"\n\t\t\t\t ${provider.favoriteQuoteList[index].author}');
                                },
                              );
                            },
                            scrollDirection: Axis.vertical,
                          )
                    : provider.quoteList.isEmpty
                        ? Center(
                            child: _online
                                ? TextButton(
                                    onPressed: () {
                                      provider.loadQuotes();
                                      provider.loadQuotes();
                                    },
                                    child: const Text("Tab to Load more Quotes",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18)),
                                  )
                                : const Text(
                                    "Try later when you have internet connection",
                                    style: TextStyle(color: Colors.black),
                                  ),
                          )
                        : Swiper(
                            itemCount: provider.quoteList.length,
                            loop: false,
                            duration: 700,
                            autoplay: false,
                            onIndexChanged: (i) {
                              if (i == provider.quoteList.length - 2 ||
                                  i == provider.quoteList.length - 1) {
                                provider.loadQuotes();
                              }
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return QuoteWidget(
                                quote: provider.quoteList.getAt(index)!.quote,
                                author: provider.quoteList.getAt(index)!.author,
                                isLiked:
                                    provider.quoteList.getAt(index)!.isLiked,
                                onDeleteTab: () {
                                  provider.deleteQuote(index);
                                },
                                onLikeTab: () {
                                  if (provider.quoteList
                                      .getAt(index)!
                                      .isLiked) {
                                    provider.dislikeQuote(index);
                                  } else {
                                    provider.likeQuote(index);
                                  }
                                },
                                onDoubleTab: () {
                                  provider.likeQuote(index);
                                },
                                onShareTap: () {
                                  provider.share(index);
                                },
                              );
                            },
                            scrollDirection: Axis.vertical,
                          ),
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("All"),
                            Switch(
                                value: _isFavoriteList,
                                onChanged: (newValue) {
                                  setState(() {
                                    _isFavoriteList = newValue;
                                  });
                                }),
                            const Icon(FontAwesomeIcons.solidHeart),
                          ],
                        )))
              ]),
      ),
    );
  }
}
