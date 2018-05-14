import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import "navbar.dart";
import "package:BlackJack/BlackJack.dart";
import "../GameShit/Empress.dart";
import "../GameShit/MoneyHandler.dart";
import "dart:math" as Math;
BlackJackGame blackJackGame;
GameObject game;
Element div;
int bet = 113;
int minBet = 113;
CanvasElement dealerCanvas;
CanvasElement meCanvas;
Element newGame;

Quirk quirk;
void main() {
  loadNavbar();

  game = new GameObject(false);


  div = new DivElement();
  div.id = "GameDiv";
  querySelector("#output").append(div);
  if(Empress.instance.allowsGambling()) {
    quirk = Empress.instance.troll.doll.quirk;
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
  blackJackGame = new BlackJackGame(Card.getFreshDeck(),div, finishGame);
  blackJackGame.dealer.name = "Empress ${Empress.instance.troll.name}";
  blackJackGame.player.name = "${GameObject.instance.player.name}";
  blackJackGame.dealerLostQuips = empressLoseQuotes();
  blackJackGame.dealerWonQuips =  empressWinQuotes();
  blackJackGame.start();
  drawMe();
}

List<String> empressWinQuotes() {
  List<String> ret = <String>[quirk.translate("I win!")];
  if(Empress.instance.troll.isInternal) ret.addAll(<String>[quirk.translate("Oh? Did I win? I wasn't paying attention."),quirk.translate("Sorry, my mind was wandering. I was thinking of a grubhood memory."),quirk.translate("What's going on?")]);
  if(Empress.instance.troll.isFreeSprited) ret.addAll(<String>[quirk.translate("I won this all on my own!"),quirk.translate("The cards are on my side for now!"),quirk.translate("Things are finally blowing my way!")]);
  if(Empress.instance.troll.isRealistic) ret.addAll(<String>[quirk.translate("On average, the house wins, you know."),quirk.translate("It's not really any skill of mine that won me this."),quirk.translate("The house usually wins in these sorts of things, you know.")]);
  if(Empress.instance.troll.isImpatient) ret.addAll(<String>[quirk.translate("Hurry up, go again!"),quirk.translate("Let's speed run this, go again!"),quirk.translate("Let's keep my streak going!")]);
  if(Empress.instance.troll.isExternal) ret.addAll(<String>[quirk.translate("Of course, I predicted you would do that."),quirk.translate("You are so predictable."),quirk.translate("Fascinating that you made that mistake.")]);
  if(Empress.instance.troll.isLoyal) ret.addAll(<String>[quirk.translate("The cards won't fail me."),quirk.translate("The cards are on my side."),quirk.translate("The cards would never betray me.")]);
  if(Empress.instance.troll.isIdealistic) ret.addAll(<String>[quirk.translate("You can do it!"),quirk.translate("I believe in you!"),quirk.translate("Keep going!")]);
  if(Empress.instance.troll.isPatient) ret.addAll(<String>[quirk.translate("Keep going, you'll win eventually."),quirk.translate("Slow and steady wins the race."),quirk.translate("The long game wins.")]);
  if(Empress.instance.troll.isEnergetic) ret.addAll(<String>[quirk.translate("This is so great!"),quirk.translate("I can't believe I won!"),quirk.translate("Hell yes I win!")]);
  if(Empress.instance.troll.isCalm) ret.addAll(<String>[quirk.translate("You can't beat fate."),quirk.translate("Oh."),quirk.translate("Acceptable.")]);
  return ret;
}

List<String> empressLoseQuotes() {
  List<String> ret = <String>[quirk.translate("Huh, I lose.")];
  if(Empress.instance.troll.isInternal) ret.addAll(<String>[quirk.translate("Oh? Did I lose?"),quirk.translate("I lost because I forgot we were playing. Oh well."),quirk.translate("Oh, I lost.")]);
  if(Empress.instance.troll.isFreeSprited) ret.addAll(<String>[quirk.translate("The cards are fickle friends."),quirk.translate("Guess I just wasn't meant to keep that money!"),quirk.translate("The winds of fate can't always blow my way!")]);
  if(Empress.instance.troll.isRealistic) ret.addAll(<String>[quirk.translate("You'll lose, on average. It's how gambling works."),quirk.translate("It's not really any skill of yours that won you this."),quirk.translate("The house usually wins in these sorts of things, you know. Your best bet is to stop playing while you're winning.")]);
  if(Empress.instance.troll.isImpatient) ret.addAll(<String>[quirk.translate("Shit, I rushed too much."),quirk.translate("Shit, hurry up and let me win it back!"),quirk.translate("Go faster!")]);
  if(Empress.instance.troll.isExternal) ret.addAll(<String>[quirk.translate("Who would have thought you'd behave so unpredictably."),quirk.translate("Luck isn't even a real thing."),quirk.translate("I shouldn't have assumed you'd behave predictably.")]);
  if(Empress.instance.troll.isLoyal) ret.addAll(<String>[quirk.translate("Of course one of my chosen Caretakers would be good at gambling."),quirk.translate("I'm proud you are one of my minions."),quirk.translate("Your skill and luck helps the Empire.")]);
  if(Empress.instance.troll.isIdealistic) ret.addAll(<String>[quirk.translate("I knew you could do it!"),quirk.translate("I believed in you! Good job!"),quirk.translate("I'm so proud of you!")]);
  if(Empress.instance.troll.isPatient) ret.addAll(<String>[quirk.translate("I'll win in the wash."),quirk.translate("I'll win eventually."),quirk.translate("You may have won the battle, but I'll win the war.")]);
  if(Empress.instance.troll.isEnergetic) ret.addAll(<String>[quirk.translate("This is the worst!"),quirk.translate("You're such a meanie!"),quirk.translate("Nooooo!")]);
  if(Empress.instance.troll.isCalm) ret.addAll(<String>[quirk.translate("I guess I was fated to lose."),quirk.translate("I don't mind this."),quirk.translate("Okay.")]);

  return ret;
}


void finishGame() {
  String result = " You lost, thems the breaks.";
  if(blackJackGame.result == BlackJackGame.WON) {
    int winnings = 2* bet;
    result = (" You won ${winnings} Caegers!!!");
    GameObject.instance.player.caegers = GameObject.instance.player.caegers + winnings;
    GameObject.instance.save();
    MoneyHandler.instance.sync();
  }else if (blackJackGame.result == BlackJackGame.TIED) {
    int winnings =  bet;
    result = (" You got back ${winnings} Caegers.");
    GameObject.instance.player.caegers = GameObject.instance.player.caegers + winnings;
    GameObject.instance.save();
    MoneyHandler.instance.sync();
  }
  newGame.appendHtml(result);
  ButtonElement restartButton = new ButtonElement();
  restartButton.text = "New Deal?";
  newGame.append(restartButton);
  restartButton.onClick.listen((e) {
    drawBetButton();
  });
}
