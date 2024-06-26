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

  Future<void> updateTag(Tag tag) async {
    final index = _tags.indexWhere((t) => t.id == tag.id);
    if (index != -1) {
      _tags[index] = tag;
      await _repository.saveTags(_tags);
      notifyListeners();
    }
  }

  Future<void> deleteTag(Tag tag) async {
    _tags.removeWhere((t) => t.id == tag.id);
    await _repository.saveTags(_tags);
    notifyListeners();
  }
}