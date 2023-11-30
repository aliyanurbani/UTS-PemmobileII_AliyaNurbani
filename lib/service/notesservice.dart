import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notes.dart';

class NotesService {
  final String key = 'notes';
  Future<List<Note>> getNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? notesString = prefs.getString(key);
    if (notesString != null) {
      List<dynamic> notesJson = jsonDecode(notesString);
      return notesJson.map((json) => Note.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<void> saveNote(Note note) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Note> notes = await getNotes();
    notes.add(note);
    String notesString =
        jsonEncode(notes.map((note) => note.toJson()).toList());
    prefs.setString(key, notesString);
  }

  Future<void> updateNote(int index, Note updatedNote) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Note> notes = await getNotes();
    notes[index] = updatedNote;
    String notesString =
        jsonEncode(notes.map((note) => note.toJson()).toList());
    prefs.setString(key, notesString);
  }

  Future<void> deleteNote(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Note> notes = await getNotes();
    notes.removeAt(index);
    String notesString =
        jsonEncode(notes.map((note) => note.toJson()).toList());
    prefs.setString(key, notesString);
  }

  Future<List<Note>> searchNotes(String query) async {
    List<Note> allNotes = await getNotes();
    return allNotes.where((note) {
      return note.judul.toLowerCase().contains(query.toLowerCase()) ||
          note.isi.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
