// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:front_end/models/Note.dart';
import 'package:front_end/providers/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddNewNote extends StatefulWidget {
  final bool isUpdate;
  final Note? note;
  AddNewNote({ Key? key ,required this.isUpdate, this.note}) : super(key: key);

  @override
  State<AddNewNote> createState() => _AddNewNoteState();
}

class _AddNewNoteState extends State<AddNewNote> {
  FocusNode _noteF = FocusNode();
  TextEditingController _titleC = TextEditingController();
  TextEditingController _noteC = TextEditingController();

  void _addNewNote() {
    Note newNote = Note(
      id: Uuid().v1(),
      userid: "simsim",
      title: _titleC.text,
      content: _noteC.text,
      dateAdded: DateTime.now()
    );
    Provider.of<NotesProvider>(context, listen: false).addNote(newNote);
    Navigator.pop(context);
  }

  @override
  void initState() {
    if(widget.isUpdate) {
      _titleC.text = widget.note!.title!;
      _noteC.text = widget.note!.content!;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if(widget.isUpdate) {
                //update
                widget.note!.title = _titleC.text;
                widget.note!.content = _noteC.text;
                widget.note!.dateAdded = DateTime.now();
                Provider.of<NotesProvider>(context, listen: false).updateNote(widget.note!);
                Navigator.pop(context);
              }
              else{
                _addNewNote();
              }
            },
            icon: Icon(Icons.check),
          )
        ],
        backgroundColor: Colors.pinkAccent,
      ),
      body: SafeArea(
        child: _getBodyContent()
      )
    );
  }

  _getBodyContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10
      ),
      child: Column(
        children: [
          TextField(
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),
            onSubmitted: (val) {
              if(val != '') {
                _noteF.requestFocus();
              }
            },
            autofocus: (widget.isUpdate == true) ? false : true,
            controller: _titleC,
            decoration: InputDecoration(
              hintText: "Title",
              border: InputBorder.none
            ),
          ),
          Expanded(
            child: TextField(
              style: TextStyle(
              fontSize: 20
              ),
              focusNode: _noteF,
              controller: _noteC,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Note",
                border: InputBorder.none
              ),
            ),
          )
        ],
      ),
    );
  }
}