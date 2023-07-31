import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/utils/db_util.dart';

class GreatPlaces with ChangeNotifier{
  List<Place> _items = [];

  Future<void> loadPlaces() async { //carregar e setar os lugares cadastrados no banco de dados
    final dataList = await DbUtil.getData('places'); 
    _items = dataList.map((item) => Place(
      id: item['id'], 
      title: item['title'], 
      image: File(item['image']),
      location: null,
      ),
    ).toList();
    notifyListeners(); 
  }

  List<Place> get items {
    return [..._items]; //retorna um clone da lista
  }

  int get itemsCount {
    return _items.length;
  }

  Place itemByIndex(int index) {
    return _items[index];
  }

  void addPlace(String title, File image) {
    final newPlace = Place(
      id: Random().nextDouble().toString(), 
      title: title, 
      location: null,
      image: image,
      );

      _items.add(newPlace);

      DbUtil.insert('places', {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
      });

      notifyListeners(); //Call all the registered listeners. Call this method whenever the object changes, to notify any clients the object may have changed.
  }
}