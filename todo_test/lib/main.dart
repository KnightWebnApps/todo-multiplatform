import 'package:flutter/material.dart';
import 'package:todo_test/todos.dart';
import 'auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TodoFire',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: MyHomePage(title: 'TodoFire'),
      
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final Auth auth = Auth();
 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('Sign In Anon'),
                onPressed: () {
                  auth.handleLoginAnon().then((val){
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context)=> Todos(user: val)
                    ));
                  });                
                },
              ),
              RaisedButton(
                child: Text('Sign In With Google'),
                onPressed: () {
                  auth.handleLogginWithGoogle().then((val){
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context)=> Todos(user: val,)
                    ));
                  });
                },
              )
            ],
          ),
        )
      ),
    );
  }
}
