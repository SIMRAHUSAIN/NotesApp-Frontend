import 'package:flutter/cupertino.dart';
import 'package:front_end/models/Note.dart';
import 'package:front_end/services/api_service.dart';

class NotesProvider with ChangeNotifier {
  
  bool isLoading = true;
  List<Note> notes = [];

  NotesProvider() {
    fetchNote();
  }

  void sortNotes() {
    notes.sort((a ,b) => a.dateAdded!.compareTo(b.dateAdded!));
  }

  void addNote(Note note) {
    notes.add(note);
    sortNotes();
    notifyListeners();
    ApiService.addNote(note); //to add notes to api
  }

  void updateNote(Note note) {
    int indexOfNote = notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes[indexOfNote] = note;
    sortNotes();
    notifyListeners();
  }

  void delNote(Note note) {
    int indexOfNote = notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes.removeAt(indexOfNote);
    sortNotes();
    notifyListeners();
    ApiService.delNote(note);
  }

  void fetchNote() async {
    notes = await ApiService.fetchNote("simsim");
    isLoading = false;
    sortNotes();
    notifyListeners();
  }

  List<Note> getFilteredNotes(String searchQuery) {
    return 
      notes.where((element) => element.title!
        .toLowerCase().contains(searchQuery.toLowerCase())
        || element.content!
        .toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }
}