import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import 'Player/Player.dart';

Player player;
void main() {
  //pass false once i'm loading from local storage.
  player = new Player(new HomestuckTrollDoll());
  if(!player.load())  player.save();
  drawDoll();
}



Future<Null>  drawDoll() async{
  CanvasElement canvas = await player.draw();
  print("going to append canvas $canvas");
  querySelector('#output').append(canvas);
  player.displayloadBoxAndText(querySelector('#output'));
}
