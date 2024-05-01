import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mnd_factory/model/store_item.dart';

final storeItemListProvider = StateNotifierProvider<StoreItemListNotifier,List<StoreItemModel>>((ref) => StoreItemListNotifier());

class StoreItemListNotifier extends StateNotifier<List<StoreItemModel>>{

  StoreItemListNotifier()
  :super([]);

  void addItem(StoreItemModel item){
    state = [...state, item];
  }
}