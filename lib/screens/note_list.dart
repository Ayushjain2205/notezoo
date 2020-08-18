import 'package:flutter/material.dart';
import 'package:notezoo/screens/note_page.dart';
import 'dart:async';
import 'package:notezoo/models/note.dart';
import 'package:notezoo/screens/note_page.dart';
import 'package:notezoo/utilities/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {



  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count=0;

  @override
  Widget build(BuildContext context) {

    if(noteList==null){
      noteList=List<Note>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('NoteZoo'),
        centerTitle: true,
      ),
      body: getNotesList(),
      floatingActionButton:FloatingActionButton(
          onPressed:(){
            navigateToNote(Note('',''),'Add Note');
          },
          tooltip: 'Add Note',
          child: Icon(Icons.add),
          ),
    );
  }
  ListView getNotesList(){

    return ListView.builder(
      itemCount:count,
      itemBuilder:(BuildContext context,int position){
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: Text(this.noteList[position].title),
            subtitle: Text(this.noteList[position].date),
            onTap:(){
              navigateToNote(this.noteList[position],'Edit Note');
              },
            trailing: GestureDetector(
                child: Icon(Icons.delete,color: Colors.grey,),
                onTap: (){
                  _delete(context,noteList[position]);
                }
            ),
          ),
        );
      },
    );
  }

  void navigateToNote(Note note,String header) async{
   bool result= await Navigator.push(context, MaterialPageRoute(builder: (context){
      return NoteScreen(note,appBarHeader: header);
    }));

   if(result==true){
     updateListView();
   }
  }

  void _delete(BuildContext context,Note note) async{
    int result=await databaseHelper.deleteNote(note.id);
    if(result!=0){
      _showSnackBar(context,'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context,String message){
    final snackBar=SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView(){
    final Future<Database> dbFuture=databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Note>> noteListFuture=databaseHelper.getNoteList();
      noteListFuture.then((noteList){
        setState(() {
          this.noteList=noteList;
          this.count=noteList.length;
        });
      });
    });

  }
}

