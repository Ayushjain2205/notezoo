import 'package:flutter/material.dart';
import 'dart:async';
import 'package:notezoo/models/note.dart';
import 'package:notezoo/utilities/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:flushbar/flushbar.dart';

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
            IconButton(icon: Icon(Icons.share), onPressed: () {
              share(context,note);
            }),
          ],
        ),
        body: ListView(
          children: <Widget>[
            TextField(
              controller: titleController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value){
                updateTitle();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide:BorderSide.none),
                hintText: 'Title',
              ),
            ),TextField(
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
            ),

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

  void showSimpleFlushbar(BuildContext context,String message) {
    Flushbar(
      message: message,
      duration: Duration(seconds: 3),
    )..show(context);
  }

  void _save() async{

    popNote();
    note.date=DateFormat.MMMd('en_US').add_jm().format(new DateTime.now());
    int result;
    if(note.id!=null){ //Note exists and needs to UPDATED
      result=await databaseHelper.updateNote(note);
    }
    else{ //Note doesn't exist and needs to be INSERTED
      result=await databaseHelper.insertNote(note);
    }

    if(result!=0){ //Successfully saved
      showSimpleFlushbar(context,'Note Saved Successfully');
    }
    else{
      showSimpleFlushbar(context,'Error while saving Note');
    }
  }

  void share(BuildContext context,Note note){
    final String text="${note.title}\n\n${note.description}\n${note.date}\n\nCreated Using NoteZoo!!!";
    Share.share(text,subject: note.title);
  }

}
