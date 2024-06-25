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
