import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
const String _my_name = "You";
const String _bot_name = "Rasa";

class ChatMessage extends StatelessWidget {//todo:添加onTap事件播放录音，添加权限申请
  ChatMessage({required this.text,required this.animationController,required this.name,this.sound_path=''});
  final String text;
  final AnimationController animationController;
  final String name;
  final String sound_path;
  FlutterSoundPlayer? _myPlayer = FlutterSoundPlayer();


  @override
  Widget build(BuildContext context) {
    return new SizeTransition(                                    //new
        sizeFactor: new CurvedAnimation(                              //new
            parent: animationController,                                //new
            curve: Curves.easeOut                                       //new
        ),                                                          //new
        axisAlignment: 0.0,                                         //new
        child: new Container(                                  //modified
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(child: new Text(name[0])),
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(name, style: Theme.of(context).textTheme.subtitle1),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(text),
                  ),
                ],
              ),
            ],
          ),
        )                                                           //new
    );
  }
}