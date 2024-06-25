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
import 'package:beekeeping_management/models/tag.dart';
import 'package:beekeeping_management/repository/local_storage_repository.dart';

class TagProvider with ChangeNotifier {
  final LocalStorageRepository _repository = LocalStorageRepository();
  List<Tag> _tags = [];

  List<Tag> get tags => _tags;

  TagProvider() {
    fetchTags();
  }

  Future<void> fetchTags() async {
    _tags = await _repository.getTags();
    notifyListeners();
  }

  Future<void> addTag(Tag tag) async {
    _tags.add(tag);
    await _repository.saveTags(_tags);
    notifyListeners();
  }
}
