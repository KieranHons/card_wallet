import 'dart:convert';

import 'package:card_wallet/model/card_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardState with ChangeNotifier {
  CardState() {
    _load();
  }
  static const _sharedPrefsKey = 'cardState';

  String _cardModel = '';

  String get cardModel => _cardModel;

  bool _isWaiting = true;
  bool _hasError = false;

  bool get isWaiting => _isWaiting;
  bool get hasError => _hasError;

  void add(newCard) => _setValue(newCard);
  void edit(newCard, currentCard) => _editValue(newCard, currentCard);
  void delete(currentCard) => _deleteValue(currentCard);
  void reset() => {_cardModel = '', _save(), notifyListeners()};

  void _setValue(CardModel newCard) {
    if (_cardModel == '') {
      List<CardModel> cardsObj = [newCard];
      _cardModel = json.encode(cardsObj);
      _save();
    } else {
      List<dynamic> cardsObj = json.decode(_cardModel);
      cardsObj.add(newCard);
      _cardModel = json.encode(cardsObj);
      _save();
    }
  }

  void _editValue(CardModel newCard, CardModel currentCard) {
    List<dynamic> cardsObj = json.decode(_cardModel);
    var cardIdx = cardsObj.indexWhere((element) {
      return element['title'] == currentCard.title;
    });
    cardsObj.removeAt(cardIdx);
    cardsObj.insert(cardIdx, newCard);
    _cardModel = json.encode(cardsObj);
    _save();
  }

  void _deleteValue(CardModel currentCard) {
    List<dynamic> cardsObj = json.decode(_cardModel);
    var cardIdx = cardsObj.indexWhere((element) {
      return element['title'] == currentCard.title;
    });
    cardsObj.removeAt(cardIdx);
    _cardModel = json.encode(cardsObj);
    _save();
  }

  void _load() => _store(load: true);
  void _save() => _store();

  void _store({bool load = false}) async {
    _hasError = false;
    _isWaiting = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      if (load) {
        _cardModel = prefs.getString(_sharedPrefsKey) ?? '';
      } else {
        await prefs.setString(_sharedPrefsKey, _cardModel);
      }
      _hasError = false;
    } catch (error) {
      _hasError = true;
    }
    _isWaiting = false;
    notifyListeners();
  }
}