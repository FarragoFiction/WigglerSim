import 'package:DollLibCorrect/DollRenderer.dart';
import '../Player/Player.dart';
import 'dart:async';
import 'dart:html';


//handles shit that my instincts want to put on a page controller.
class GameObject {
    Player player;

    static GameObject instance;

    GameObject() {
        instance = this;
        if(window.localStorage.containsKey(Player.DOLLSAVEID)) {
            player = new Player.fromJSON(window.localStorage[Player.DOLLSAVEID]);
            player.save();
            print("loading player ${player} from local storage");
        }else {
            player = new Player(new HomestuckTrollDoll());
            player.save();
            print("creating new player");
        }
    }

    void save() {
        print("saving game");
        player.save();
    }

    void load() {
        player.loadFromJSON(window.localStorage[Player.DOLLSAVEID]);
    }

    Future<Null> drawPlayer(Element container) async {
        CanvasElement canvas = await player.draw();
        container.append(canvas);
    }

    void drawPetInventory(Element container) {
        player.petInventory.drawInventory(container);
    }

    void drawStarters(Element container) {
        player.petInventory.drawStarters(container);
    }

    Future<Null> drawPlayerIntroShit(Element container) async {
        player.displayloadBoxAndText(container);
    }

}