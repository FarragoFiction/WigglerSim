import 'package:DollLibCorrect/DollRenderer.dart';
import '../Player/Player.dart';
import 'dart:async';
import 'dart:html';


//handles shit that my instincts want to put on a page controller.
class GameObject {
    Player player;

    GameObject() {
        player = new Player(new HomestuckTrollDoll());
        if(!player.load())  player.save();
    }

    Future<Null> drawPlayer(Element container) async {
        CanvasElement canvas = await player.draw();
        container.append(canvas);
    }

    void drawPetInventory(Element container) {
        player.petInventory.drawInventory(container);
    }

    Future<Null> drawPlayerIntroShit(Element container) async {
        player.displayloadBoxAndText(container);
    }

}