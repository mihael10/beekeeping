import 'package:flutter/material.dart';
import 'package:beekeeping_management/models/hive.dart';
import 'package:beekeeping_management/repository/local_storage_repository.dart';

class HiveProvider with ChangeNotifier {
  final LocalStorageRepository _repository = LocalStorageRepository();
  List<Hive> _hives = [];

  List<Hive> get hives => _hives;

  HiveProvider() {
    fetchHives();
  }

  Future<void> fetchHives() async {
    _hives = await _repository.getHives();
    notifyListeners();
  }

  Future<void> addHive(Hive hive) async {
    _hives.add(hive);
    await _repository.saveHives(_hives);
    notifyListeners();
  }

  Future<void> updateHive(Hive hive) async {
    final index = _hives.indexWhere((h) => h.id == hive.id);
    if (index != -1) {
      _hives[index] = hive;
      await _repository.saveHives(_hives);
      notifyListeners();
    }
  }

  Future<void> deleteHive(Hive hive) async {
    _hives.removeWhere((h) => h.id == hive.id);
    await _repository.saveHives(_hives);
    notifyListeners();
  }
}
