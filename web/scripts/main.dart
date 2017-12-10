import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import 'Player/Player.dart';

Player player;
void main() {
  querySelector('#output').text = 'Your Dart app is running.';
  player = new Player(new HomestuckTrollDoll());
  drawDoll();
}

Future<Null>  drawDoll() async{
  CanvasElement canvas = await player.draw();
  print("going to append canvas $canvas");
  querySelector('#output').append(canvas);
}
