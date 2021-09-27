import 'package:animator/animator.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QuoteWidget extends StatefulWidget {
  final String quote;
  final String author;
  final bool isLiked;
  final VoidCallback onLikeTab;
  final VoidCallback onDeleteTab;
  final VoidCallback onShareTap;
  final VoidCallback onDoubleTab;

  const QuoteWidget({
    Key? key,
    required this.quote,
    required this.author,
    required this.isLiked,
    required this.onLikeTab,
    required this.onDeleteTab,
    required this.onDoubleTab,
    required this.onShareTap,
  }) : super(key: key);
  @override
  _QuoteWidgetState createState() => _QuoteWidgetState();
}

class _QuoteWidgetState extends State<QuoteWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onDoubleTap: widget.onDoubleTab,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(
                    alignment: Alignment.topLeft,
                    child: Icon(
                      FontAwesomeIcons.quoteLeft,
                      size: 30.0,
                      color: Colors.black,
                    )),
                Animator(
                  triggerOnInit: true,
                  curve: Curves.decelerate,
                  duration: const Duration(milliseconds: 500),
                  tween: Tween<double>(begin: -1, end: 0),
                  builder: (context, state, child) {
                    return FractionalTranslation(
                        translation: Offset(state.value as double, 0),
                        child: child);
                  },
                  child: AutoSizeText(
                    widget.quote,
                    maxFontSize: 35,
                    minFontSize: 18,
                    textAlign: TextAlign.start,
                    maxLines: 15,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Animator(
                  triggerOnInit: true,
                  tween: Tween<double>(begin: 1, end: 0),
                  builder: (context, state, child) {
                    return FractionalTranslation(
                      translation: Offset(state.value as double, 0),
                      child: child,
                    );
                  },
                  child: Text(
                    widget.author,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.grey.shade900,
                          fontSize: 20.0,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: widget.onLikeTab,
                    child: Icon(
                      widget.isLiked
                          ? Icons.favorite_sharp
                          : Icons.favorite_border,
                      size: 35,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onDeleteTab,
                    child: const Icon(
                      Icons.delete,
                      size: 35,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onShareTap,
                    child: const Icon(
                      Icons.share,
                      size: 35,
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
//Thanks for watching source code will be available on description
//Like share and Subscribe