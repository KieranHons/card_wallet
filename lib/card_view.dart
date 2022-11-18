import 'dart:convert';

import 'package:card_wallet/card/add_card.dart';
import 'package:card_wallet/card/show_card.dart';
import 'package:card_wallet/model/card_model.dart';
import 'package:card_wallet/util/card_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardView extends StatefulWidget {
  const CardView({super.key});

  @override
  State<CardView> createState() => _CardView();
}

class _CardView extends State<CardView> {
  Widget getCardWidgets(BuildContext context, CardModel card, cardState) {
    var media = MediaQuery.of(context);
    var size = media.size;
    double width = media.orientation == Orientation.portrait
        ? size.shortestSide * .9
        : size.longestSide * .5;
    double height = width / 1.59;
    return Column(
      children: [
        InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShowCard(card: card)),
            ).then((value) {
              if (value != null) {
                // cardState.edit(value, card);
                cardState.delete(card);
              }
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0.064*height),
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(0.064*height),
                  image: DecorationImage(
                      image: AssetImage(card.image!),
                      fit: BoxFit.fill)
              ),
            ),
          ),
        ),
        Container(height: 10,)
      ],
    );
  }

  Widget safetyWidget(cardState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
                !cardState.hasError && cardState.isWaiting
                    ? 'Loading...'
                    : ''
            ),
          ),
        ),
        cardState.hasError
            ? const Text("Oops, something's wrong!")
            : cardState.isWaiting
            ? const CircularProgressIndicator()
            : Container()
      ],
    );
  }

  getCardList(String cardJson) {
    List<CardModel> cardList = [];
    for (var card in json.decode(cardJson)) {
      cardList.add(CardModel.fromJson(card));
    }
    return cardList;
  }

  @override
  Widget build(BuildContext context) {
    final cardState = Provider.of<CardState>(context);
    List<CardModel> list = cardState.cardModel.isNotEmpty ? getCardList(cardState.cardModel) : [];
    return Scaffold(
      appBar: AppBar(
          title: const Text('Cards'),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddCard()),
                    ).then((value) => {
                      if (value != null) {
                        cardState.add(value)
                      }
                    });
                  },
                  child: const Icon(
                    Icons.add,
                    size: 26.0,
                  ),
                )
            ),
          ]
      ),
      body: SafeArea(
          child: cardState.hasError || cardState.isWaiting ?
          safetyWidget(cardState) :
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(height: 30),
                  for (var card in list) getCardWidgets(context, card, cardState),
                ],
              ),
            ),
          )
      ),
    );
  }
}