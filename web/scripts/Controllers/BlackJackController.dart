import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import "navbar.dart";
import "package:BlackJack/BlackJack.dart";
import "../GameShit/Empress.dart";
import "../GameShit/MoneyHandler.dart";
import "dart:math" as Math;
Game blackJackGame;
GameObject game;
Element div;
int bet = 113;
int minBet = 113;
CanvasElement dealerCanvas;
CanvasElement meCanvas;
Element newGame;
void main() {
  loadNavbar();
  game = new GameObject(false);

  div = new DivElement();
  div.id = "GameDiv";
  querySelector("#output").append(div);
  if(Empress.instance.allowsGambling()) {
    drawBetButton();
  }else {
    querySelector("#output").appendHtml("By order of the Empire, no Gambling allowed. All citizens should accept their lot in life.");
  }
}

void clearDiv() {
  List<Element> children = new List.from(div.children);
  children.forEach((f) {
    f.remove();
  });
}

Future<Null> drawMe() async{
  Doll doll = GameObject.instance.player.doll;
  CanvasElement canvas = new CanvasElement(width: doll.width, height: doll.height);
  DollRenderer.drawDoll(canvas, doll);
  div.append(canvas);
}

Future<Null> drawEmpress() async{
  Doll doll = Empress.instance.troll.doll;
  CanvasElement canvas = new CanvasElement(width: doll.width, height: doll.height);
  DollRenderer.drawDoll(canvas, doll);
  div.append(canvas);
  newGame = new DivElement();
  div.append(newGame);
}

void drawBetButton() {
  clearDiv();

  if(GameObject.instance.player.caegers < minBet) {
    div.setInnerHtml("Sorry, but you can't afford to bet. Wait for Empress ${Empress.instance.troll.name}'s next generous funding delivery.");
    return;
  }
  ButtonElement betButton = new ButtonElement();
  betButton.text = "Bet";
  InputElement value = new InputElement();
  value.value = "$bet";
  value.min = "$minBet";
  int max = Math.max(bet, GameObject.instance.player.caegers);
  value.max = "${max}";

  SpanElement valueMarker = new SpanElement();
  valueMarker.setInnerHtml("<img src = 'images/tinyMoney.png'>$bet");

  value.type = "range";
  div.append(valueMarker);
  div.append(value);
  div.append(betButton);

  value.onChange.listen((e) {
    valueMarker.text = value.value;
    bet = int.parse(value.value);
  });

  betButton.onClick.listen((e) {
    start();
  });

  newGame = new DivElement();
  div.append(newGame);
}

Future<Null> start() async{
  clearDiv();

  GameObject.instance.player.caegers = GameObject.instance.player.caegers + -1* bet;
  GameObject.instance.save();
  MoneyHandler.instance.sync();

  await Loader.preloadManifest();
  await drawEmpress();
  blackJackGame = new Game(Card.getFreshDeck(),div, finishGame);
  blackJackGame.dealer.name = "Empress ${Empress.instance.troll.name}";
  blackJackGame.player.name = "${GameObject.instance.player.name}";
  blackJackGame.dealerLostQuips = <String>["Oh no! I lost?","How could you beat me!?","That's not fair!"];
  blackJackGame.dealerWonQuips = <String>["Oh! You nearly won! You should try again!","You were so close, too!","No refunds."];
  blackJackGame.start();
  drawMe();
}

void finishGame() {
  String result = " You lost, thems the breaks.";
  if(!blackJackGame.lost) {
    int winnings = 2* bet;
    result = (" You won ${winnings} Life Bux!!!");
    GameObject.instance.player.caegers = GameObject.instance.player.caegers + winnings;
    GameObject.instance.save();
    MoneyHandler.instance.sync();
  }
  querySelector("#money").appendText(result);
  ButtonElement restartButton = new ButtonElement();
  restartButton.text = "New Deal?";
  newGame.append(restartButton);
  restartButton.onClick.listen((e) {
    drawBetButton();
  });
}
