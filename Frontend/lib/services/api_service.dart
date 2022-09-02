// ignore_for_file: unused_field, prefer_final_fields

import 'dart:convert';
import 'dart:developer';
import 'package:front_end/models/Note.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String _baseUrl = 'https://tranquil-reaches-09630.herokuapp.com/notes';

  static Future<void> addNote(Note note) async {
    Uri requestUri = Uri.parse(_baseUrl + "/add");
    var response = await http.post(requestUri, body: note.toMap());
    var decoded = jsonDecode(response.body);
    log(decoded.toString());
  }

  static Future<void> delNote(Note note) async {
    Uri requestUri = Uri.parse(_baseUrl + "/delete");
    var response = await http.post(requestUri, body: note.toMap());
    var decoded = jsonDecode(response.body);
    log(decoded.toString());
  }

  static Future<List<Note>> fetchNote(String userid) async {
    Uri requestUri = Uri.parse(_baseUrl + "/list");
    var response = await http.post(requestUri, body: {'userid': userid});
    var decoded = jsonDecode(response.body);
    List<Note> notes = [];
    for(var noteMap in decoded) {
      Note newNote = Note.fromMap(noteMap);
      notes.add(newNote);
    }
    return notes;
  }
}