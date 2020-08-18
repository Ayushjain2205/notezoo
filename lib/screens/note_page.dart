import 'package:flutter/material.dart';
import 'dart:async';
import 'package:notezoo/models/note.dart';
import 'package:notezoo/utilities/database_helper.dart';
import 'package:intl/intl.dart';

class NoteScreen extends StatefulWidget {

  final String appBarHeader;
  final Note note;

  NoteScreen(this.note,{this.appBarHeader});

  @override
  State<StatefulWidget> createState() {
    return NoteScreenState(this.note, this.appBarHeader);
  }
}

class NoteScreenState extends State<NoteScreen> {

  DatabaseHelper databaseHelper=DatabaseHelper();
  String appBarHeader;
  Note note;
  bool isEmpty=true;

  TextEditingController titleController=TextEditingController();
  TextEditingController bodyController=TextEditingController();

  NoteScreenState(this.note, this.appBarHeader);

  @override
  Widget build(BuildContext context) {

    titleController.text=note.title;
    bodyController.text=note.description;

    return WillPopScope(
      onWillPop: (){
        if(isEmpty==true){
          popNote();
        }
        else{
          _save();
        }
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                if(isEmpty==true){
                  popNote();
                }
                else{
                  _save();
                }
          }),
          title: Text(widget.appBarHeader),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.mode_edit), onPressed: () {}),
            IconButton(icon: Icon(Icons.share), onPressed: () {

            }),
          ],
        ),
        body: ListView(
          children: <Widget>[
            TextField(
              controller: titleController,
              onChanged: (value){
                updateTitle();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide:BorderSide.none),
                hintText: 'Title',
              ),
            ),
            TextField(
              controller: bodyController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value){
                updateBody();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide:BorderSide.none),
                hintText: 'Description',
              ),
            )
          ],
        ),
      ),
    );
  }
  void popNote(){
    Navigator.pop(context,true); //true is passed to updated listView in previous screen
  }

  void updateTitle(){
    note.title=titleController.text;
    isEmpty=false;
  }

  void updateBody(){
    note.description=bodyController.text;
    isEmpty=false;
  }

  void _showSnackBar(BuildContext context,String message){
    final snackBar=SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _save() async{

    popNote();
    note.date=DateFormat.MMMMd('en_US').format(new DateTime.now());
    int result;
    if(note.id!=null){ //Note exists and needs to UPDATED
      result=await databaseHelper.updateNote(note);
    }
    else{ //Note doesn't exist and needs to be INSERTED
      result=await databaseHelper.insertNote(note);
    }

    if(result!=0){ //Successfully saved
      _showSnackBar(context,'Note Saved Successfully');
    }
    else{
      _showSnackBar(context,'Error while saving note');
    }
  }

}
