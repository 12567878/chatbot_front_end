// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:web_socket_channel/io.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/material.dart';
import 'ChatMessage.dart';
const String _my_name = "You";
const String _bot_name = "Rasa";

var options = BaseOptions(
  baseUrl: 'http://localhost:4563/',
  connectTimeout: 5000,
  receiveTimeout: 3000,
);
Dio dio = Dio(options);

void main() {
  runApp(new FriendlychatApp());
}

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Rasa Bot",
      home: new ChatScreen(),
    );
  }
}





class ChatScreen extends StatefulWidget {                     //modified
  @override                                                        //new
  State createState() => new ChatScreenState();                    //new
}


class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {                  //new
  final List<ChatMessage> _messages = <ChatMessage>[];             // new
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
  bool _is_text = true;
  @override
  void dispose() {                                                   //new
    for (ChatMessage message in _messages)                           //new
      message.animationController.dispose();                         //new
    super.dispose();                                                 //new
  }

  Widget _buildTextComposer() {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: _is_text ?
          new Row(
            children: <Widget>[
              new Container( //new
                margin: new EdgeInsets.symmetric(horizontal: 0.0), //new
                child: new IconButton( //new
                  icon: new Icon(Icons.record_voice_over),
                  onPressed: _changeInput
                ),
              ),
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  onChanged: (String text)  {                //new
                                setState(() {                            //new
                                _isComposing = text.length > 0;        //new
                                });                                      //new
                  },
                  decoration: new InputDecoration.collapsed(
                      hintText: "Send a message"),
                  ),
                ),
              new Container( //new
                margin: new EdgeInsets.symmetric(horizontal: 4.0), //new
                child: new IconButton( //new
                    icon: new Icon(Icons.send),
                    onPressed: _isComposing ?   () =>  _handleSubmitted(_textController.text) :// modified
                                  null, //new
                  ),
                )

              ],
            )



        :new Row(
          children: <Widget>[
            new Container( //new
              // margin: new EdgeInsets.symmetric(horizontal: 0.0), //new
              child: new IconButton( //new
                icon: new Icon(Icons.text_fields),
                onPressed: _changeInput
              ),
            ),
            new Flexible(
                  child: new Container(
                          child: new Center(
                              child:new IconButton(onPressed: null, icon: new Icon(Icons.keyboard_voice))
                          ),),
            ),
          ]
      ),
    );
  }

  void _changeInput(){
    setState((){
      _is_text = !_is_text;
    });
  }

  void  _handleSubmitted(String text) async{
    _textController.clear();
    setState(() {                                                    //new
      _isComposing = false;                                          //new
    });




    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(                  //new
        duration: new Duration(milliseconds: 700),                   //new
        vsync: this,                                                 //new
      ),
      name: _my_name,
    );
    Response response = await dio.post('/nlp', data: {'text':text});

    ChatMessage reply = new ChatMessage(

      text: "你好。",
      animationController: new AnimationController(                  //new
        duration: new Duration(milliseconds: 700),                   //new
        vsync: this,                                                 //new
      ),
      name: _bot_name,//new
    );
    setState(() {
      _messages.insert(0, message);
      _messages.insert(0, reply);
    });
    message.animationController.forward();
    reply.animationController.forward();


    // setState(() {
    //   _messages.insert(0, reply);
    // });
    // message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Rasa Bot")),
      body: new Column(                                        //modified
          children: <Widget>[                                         //new
            new Flexible(                                               //new
                child: new ListView.builder(                              //new
                  padding: new EdgeInsets.all(8.0),                       //new
                  reverse: true,                                          //new
                  itemBuilder: (_, int index) => _messages[index],        //new
                  itemCount: _messages.length,                            //new
                )                                                         //new
            ),                                                          //new
            new Divider(height: 1.0),                                   //new
            new Container(                                              //new
              decoration: new BoxDecoration(
                  color: Theme.of(context).cardColor),                   //new
              child: _buildTextComposer(),                         //modified
            ),                                                          //new
          ]                                                            //new
      ),                                                             //new
    );
  }

}