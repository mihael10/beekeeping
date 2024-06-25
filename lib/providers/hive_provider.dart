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
}
