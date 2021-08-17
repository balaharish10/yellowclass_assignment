import 'package:flutter/material.dart';
import 'package:movirbuff/model/note.dart';
import 'package:movirbuff/util/database_helper.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:movirbuff/util/Utility.dart';
class MovieDetail extends StatefulWidget {

  final String appBarTitle;
  final Note note;

  MovieDetail(this. note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {

    return MovieDetailState(this.note, this.appBarTitle);
  }
}

class MovieDetailState extends State<MovieDetail> {

  static var _priorities = ['New', 'Old'];
   Future<File> imagefile;
   Image image;
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;
  IconData ch=Icons.add;
var _formkey=GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  MovieDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(

        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },

        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(icon: Icon(
                Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }
            ),
          ),

          body: Form(
            key: _formkey,
            child: Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: ListView(
                children: <Widget>[

                  // First element
                  ListTile(
                    title: Row(
                      children: [
                        Text("ADD IMAGE :  "),
                        IconButton(icon:Icon(ch), onPressed:(){
                          pickImageFromGallery(ImageSource.gallery);
                          setState(() {
                            ch=Icons.done;
                          });
                        }),
                        SizedBox(
                          width:40.0
                        ),
                        // Text("TYPE :  "),
                        // DropdownButton(
                        //     items: _priorities.map((String dropDownStringItem) {
                        //       return DropdownMenuItem<String> (
                        //         value: dropDownStringItem,
                        //         child: Text(dropDownStringItem),
                        //       );
                        //     }).toList(),
                        //
                        //     style: textStyle,
                        //
                        //     value: getPriorityAsString(note.priority),
                        //
                        //     onChanged: (valueSelectedByUser) {
                        //       setState(() {
                        //         debugPrint('User selected $valueSelectedByUser');
                        //         updatePriorityAsInt(valueSelectedByUser);
                        //       });
                        //     }
                        // ),
                      ],
                    ),
                  ),

                  // Second Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextFormField(
                      validator: (String value) {
                  if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                  }
                  },
                      controller: titleController,
                      style: textStyle,
                      onChanged: (value) {
                        debugPrint('Something changed in Title Text Field');
                        updateTitle();
                      },
                      decoration: InputDecoration(
                          labelText: 'MOVIE NAME',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)
                          )
                      ),
                    ),
                  ),

                  // Third Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: descriptionController,
                      style: textStyle,
                      onChanged: (value) {
                        updateDescription();
                      },
                      decoration: InputDecoration(
                          labelText: 'DIRECTOR',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)
                          )
                      ),
                    ),
                  ),

                  // Fourth Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              'Save',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                if(_formkey.currentState.validate() && note.picture!=null)
                                _save();
                                else
                                  _showAlertDialog('status', 'fill everything');
                              }

                              );
                            },
                          ),
                        ),

                        Container(width: 5.0,),

                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              'Delete',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                _delete();
                              });
                            },
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),

        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to Database


  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];  // 'High'
        break;
      case 2:
        priority = _priorities[1];  // 'Low'
        break;
    }
    return priority;
  }

  // Update the title of Note object
  void updateTitle(){
    note.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    note.description = descriptionController.text;
  }
  // Save data to database
  void _save() async {

    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {  // Case 1: Update operation
      result = await helper.updateNote(note);
    } else { // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Movie Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }

  }

  void _delete() async {

    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'No Movie was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Movie Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

pickImageFromGallery(ImageSource source)
{
  setState(() {
    imagefile= ImagePicker.pickImage(source: source).then((imgfile) {
      String imgstring=Utility.base64String(imgfile.readAsBytesSync());
note.picture=imgstring;
    });
  });

}


// Widget imageFromGallery(){
//    return FutureBuilder<File>(
//      future: imagefile,
//      builder:(BuildContext context,AsyncSnapshot<File> snapshot){
// if(snapshot.connectionState==ConnectionState.done){
//   if(null==snapshot.data)
//     {
//       return const Text("error",textAlign: TextAlign.center,);
//     }
//   return Image.file(snapshot.data);
// }
// if(null!=snapshot.error){
//   return const Text('error picking image',textAlign:TextAlign.center );
// }
// return const Text('no image selected',textAlign: TextAlign.center,)
//      } ,
//    );
// }



}
