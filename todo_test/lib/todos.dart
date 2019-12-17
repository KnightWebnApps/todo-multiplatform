import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Todos extends StatefulWidget {

  Todos({@required this.user});

  final FirebaseUser user;

  @override
  _TodosState createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  Firestore db = Firestore.instance;

  Stream<QuerySnapshot> getTodos() {
    return db.collection('todos')
      .where('uid', isEqualTo: widget.user.uid)
      .getDocuments().asStream(); 
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.user.uid),
        ),
        body: Column(
          children: <Widget>[
            AddTodo(
              database: db,
              user: widget.user,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: getTodos(),
                builder: (context, snap)
                  => snap.hasData 
                  ? ListView.builder(
                    itemCount: snap.data.documents.length,
                    itemBuilder: (context, i){
                      return snap.data.documents.length >= 0 ?
                      Card(
                        child: Text(snap.data.documents[i]['title'] as String)
                      )
                      : Text('No Todos');
                    },
                ) : ErrorWidget(snap.error)
              ),
            ),
          ],
        )
      ),
      
    );
  }
}

class AddTodo extends StatefulWidget {

  AddTodo({ @required this.database, @required this.user});

  final Firestore database;
  final FirebaseUser user;

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController todoController = TextEditingController();

  addTodo(){
    return widget.database.collection('todos').add({
      'title' : todoController.text,
      'createdAt' : DateTime.now().millisecondsSinceEpoch,
      'uid': widget.user.uid
    }).then((val) {
      print('added Todo ${val.documentID}');
      todoController.clear();
     
    }
    );
    
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
            controller: todoController,
          ),
        ),
        RaisedButton(
          child: Text('Add'),
          onPressed: ()=>addTodo(),
        )
      ],
    );
  }
}