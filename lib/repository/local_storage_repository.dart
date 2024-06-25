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


import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beekeeping_management/models/hive.dart';
import 'package:beekeeping_management/models/task.dart';
import 'package:beekeeping_management/models/tag.dart';

class LocalStorageRepository {
  static const String _hivesKey = 'hives';
  static const String _tasksKey = 'tasks';
  static const String _tagsKey = 'tags';

  Future<List<Hive>> getHives() async {
    final prefs = await SharedPreferences.getInstance();
    final hivesJson = prefs.getString(_hivesKey) ?? '[]';
    final List<dynamic> hivesList = json.decode(hivesJson);
    return hivesList.map((json) => Hive.fromJson(json)).toList();
  }

  Future<void> saveHives(List<Hive> hives) async {
    final prefs = await SharedPreferences.getInstance();
    final hivesJson = json.encode(hives.map((hive) => hive.toJson()).toList());
    await prefs.setString(_hivesKey, hivesJson);
  }

  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString(_tasksKey) ?? '[]';
    final List<dynamic> tasksList = json.decode(tasksJson);
    return tasksList.map((json) => Task.fromJson(json)).toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString(_tasksKey, tasksJson);
  }

  Future<List<Tag>> getTags() async {
    final prefs = await SharedPreferences.getInstance();
    final tagsJson = prefs.getString(_tagsKey) ?? '[]';
    final List<dynamic> tagsList = json.decode(tagsJson);
    return tagsList.map((json) => Tag.fromJson(json)).toList();
  }

  Future<void> saveTags(List<Tag> tags) async {
    final prefs = await SharedPreferences.getInstance();
    final tagsJson = json.encode(tags.map((tag) => tag.toJson()).toList());
    await prefs.setString(_tagsKey, tagsJson);
  }
}
