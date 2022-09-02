// ignore_for_file: prefer_const_constructors, prefer_is_empty

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front_end/models/Note.dart';
import 'package:front_end/providers/notes_provider.dart';
import 'package:front_end/screens/newNote_page.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String searchQuery = '';
  @override
  Widget build(BuildContext context) {

    NotesProvider notesProvider = Provider.of<NotesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes App"),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: 
      //if it fetches data from api then true becomes false
      // notesProvider.isLoading == false ? 
      SafeArea(
        child: notesProvider.notes.length > 0 ? ListView(
          children: [ 
            
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search"
                ),
              ),
            ),
          notesProvider.getFilteredNotes(searchQuery).length > 0 ? 
            GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2
            ),
            itemCount: notesProvider.getFilteredNotes(searchQuery).length,
            itemBuilder: (BuildContext context, int index) {

              Note currentNote = notesProvider.getFilteredNotes(searchQuery)[index];
              return GestureDetector(
                onTap: () {
                  //tap to edit the note
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => AddNewNote(
                      isUpdate: true,
                      note: currentNote,
                    )),
                  );
                },
                onLongPress: () {
                  //long press to delete the note
                  notesProvider.delNote(currentNote);
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.pinkAccent,
                      width: 1.5
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        currentNote.title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20
                        )
                      ),
                      SizedBox(height: 7),
                      Text(
                        currentNote.content!,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } 
          ) : Center(
          child: Text(
            "No Notes Found",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.pinkAccent),
          ),
        )
        ]) 
        : Center(
          child: Text(
            "No New Notes Yet",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.pinkAccent),
          ),
        )
      ) ,
      // : 
      // Center(
      //   child: CircularProgressIndicator(),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, CupertinoPageRoute(
            builder: (context) => AddNewNote(
              isUpdate: false,
            )
          ));
        },
        backgroundColor: Colors.pinkAccent,
        child: Icon(Icons.add)
      ),
    );
  }
}
