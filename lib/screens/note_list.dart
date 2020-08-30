import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notezoo/screens/note_page.dart';
import 'dart:async';
import 'package:notezoo/models/note.dart';
import 'package:notezoo/screens/note_page.dart';
import 'package:notezoo/utilities/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notezoo/classes/language.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count=0;

  void _changeLanguage(Language language){
    print();
  }

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
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton(
              icon: Icon(Icons.language,color: Colors.white,),
              onChanged:(Language language){
                _changeLanguage(language);
                },
                items: Language.languageList()
                    .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
                    child: Row(
                      children: <Widget>[
                        Text(lang.nameEnglish),Text(lang.nameNative)],
                    )
                )).toList(),
                ),
          )
        ]),
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
        var bodyText=this.noteList[position].description;
        var titleText=this.noteList[position].title;
        var dateText=this.noteList[position].date;
        return Dismissible(
          key: UniqueKey(),
          background: Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              alignment: AlignmentDirectional.centerEnd,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color:Colors.red,
                  border: Border.all(width: 2, color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0)),
              child:Icon(Icons.delete,color: Colors.white,),
            ),
          ),
          onDismissed: (DismissDirection direction){
                  _delete(context,noteList[position]);
                },
          direction: DismissDirection.endToStart,
          child: GestureDetector(
            onTap: (){
                navigateToNote(this.noteList[position],'Edit Note');
                },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color:Colors.amberAccent,
                    border: Border.all(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0)),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(titleText.length<30?titleText:'${titleText.substring(0,30)}...',
                          style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(bodyText==null?' ':(bodyText.length<44?bodyText:'${bodyText.substring(0,44)}...'),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16),
                        )
                      ],
                    ),
                    SizedBox(height: 12.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(dateText,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14),)
                      ],
                    )
                  ],
                ),
              ),
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

