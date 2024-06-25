/*
 * This file is part of Beekeeping Management.
 *
 * Beekeeping Management is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Beekeeping Management is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Beekeeping Management. If not, see <http://www.gnu.org/licenses/>.
 *
 * Author: Mihael Josifovski
 * Copyright 2024 Mihael Josifovski
 */


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
