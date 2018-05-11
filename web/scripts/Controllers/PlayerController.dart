import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import "navbar.dart";


GameObject game;
void main() {
  loadNavbar();
  game = new GameObject(false);
  GameObject.storeCard("N4Igzg9grgTgxgUxALhABQDYEMCeBLAOwHMACAdTyKIwRjDwFsQAaEArBpVAIQRIBcAFnwBSWACZ9uGCBHEsQ-BAA9+KECQgB3ArQTtOMEgDNC4sAOEMwCDADcEFwiSwktCPDHEk4WBzAJmEjBYGGgCSW8AIxwSDDx+fhoSIhgoKJiSKKwovEcAOhIAFUE8Jwt3T3FCkoRYsH4sGH4BLABrQlJfGD4IY0s+VPSwILx+iAIMWP4IEjaEBAAHAYYTMNWiBETOkgQsJQIs6eESBiwCWPPvOya8aAtFnvF9iDoSZyEytw8vHz8EQoKbJwNqpcLiAByHC4IAA4ltYWkMghxNwEnBBPlFsQFPwYJRNjAAMKCc6IdQABnyAE4AMwKMCIXRgIoQACqkwgIPUAG1gAAdcDQeAIQXIQX5SWC5iCgyilCCgBKWDKfHOJAAogxHo4wNLBUpVGLBQB5QRubQAQhIJt0mn6Qj4xigGPoWAsmh0ejlRhgKps3lSCC0JCgyxmWT4Wp1YDA1tqlx6JB6nAYUT03mME3EUxcETc+wxLgsjpSSIGsT9qu8GPOmxLJ2jngB+pAwNBYSgEShnGNcIRSPTqPRmOxRFbeIJtBJZPl4pAVIAjAB2VuM-SOVkcmQgvs8gC6rZ6IQw-DAAGVGme9wL+bLoXfjXeQBrz0UNRqALKPlg-m4YKBRWfcVn1pH8AF8glve9e2An80AAQUVDUISKRUAEkijZAARDUfxlZ9-0An8QMFRcKQgqCfzlEifwQ89zwACRNAAZDVFQATXwv8sAAoCn0FABaAAmCDD1-RR8SoWhL32MAWN1Wg93EmVJKnGBZLPRE9iUGBlInKTCU0sANQARygXj9JASCSAFIVYEQPtJXyVsaIVEBlVVEhEWGCcVH4PtPV0HofR8CZ+EIQCS1mKsbDLYYgmMBZxB2R0GCCIg8DsVKrAECAcBGAQYHwYg8rmBZw1y4x1lOWBJHxUq9iLCBHRgQp0P4AByCwQhgR4yk6XMwH2MpjBKogXIk9swS7SEH3c+F+B85Fh34DEsWIAz1JnAhHPcqll2pNcmU3dlOV3dyDyPRwoFPC8rz1S7oLYB84OfRDkNQjCsNw7jCN44i3rIsStukjSHoU2MlMulSDUMmSHu0-ZofnK6JMnMHjLMiyMCsmy7MgBy5wlKUJLc+ciVujASAQkhPygRoCAC9H-MC7Rgv0aEjAaJpHBIcR2ZcFpS10LRc1JNbhEDctnDgCZnXoCZ2q6iwoikwQWl8CJKxRGpSnKNwwmIPWo21ZsLQITqWhoFoEjiLKAWKYRYgFgZPH5hmcEm1Tps7bt5vnRblqHNFJY28d0fh4lSV24mF3yYTF2OjcWTOnc2is1Tj1us9jJvajXoE9AkJQtDMJwvDnwIwUiP4hVn0E8jKNsgvYKL7gWPotBGK-E0AA0uKrni+NohuADYJ+b56aKBkB6KY1j2MH-V-pH2em+fcDYbUzGIcUvSYdBozEZ6ZGD9R6fC-rwV5+YtjOL+muAbr0iQAAVhByP1Kx8zLMP6yqL2RFE5UmqlyZKn9HwWm9NGbM1UoaZm84grei5sERox5+aC32AMEgotxaFilvFKI7xDhywIArO4BBlbdSyOrTWVwdbVCdl8L4WgjYTSdqbRY5stATCtnELY7xrYOxNu7YQTQWhsP0BiPmHxhDuxkQ0IWOChDQCIBre0ODSSLEWDgIIEhXg5GSEMYh6YdgEBai4DAMh3DeAjPEBwJAABWUAlFZiMAkGhcsZBtU4bEUokghH6PzPMJYQirEOxIcEBAcAej8EKGQYQhxPEWFMOwaxsRFhhmRuIUYLQiAQD5tAW2TNZill4TADAdjZgOL4CkoK9skqFGQSFVBWtNCTH8RARYfBHSVkgd4O27hrG7AsVAdR3tBS+3BD2OOQdBwolDutMcR9pwxz2vOKkidk7Mi3OdDO-8s43TunnJ6rcX7wRLl9cuv0h6r0BkXDegp8bnNHoKDuXce6fn7svX89yLnPjHkdTe28MbHzkpDGw59BR8lebPW+i8H53KfmvIuYEQWrPBnJJGulM5w2-g9bGf9UbiS3gobOJyHq8jsuA4un0y4-TwhJWufYk7WX3LiKOxlIW0GpTBOOH1S7fQrq2Fl7k2VktYGChG2LT66V5ByqVXLCW-wwAq6yQA");
  start();
}

Future<Null> start() async {
  await game.preloadManifest();
  Element container = new DivElement();
  querySelector('#output').append(container);

  Element subContainer = new DivElement();
  querySelector('#output').append(subContainer);
  game.drawSaveLink(subContainer);

  Element canvasContainer = new DivElement();
  Element introContainer = new DivElement();
  container.append(canvasContainer);
  container.append(introContainer);
  game.drawPlayer(canvasContainer);
  game.drawPlayerIntroShit(introContainer);

  ButtonElement deleteButton = new ButtonElement();
  deleteButton.text = "Reset Game";
  container.append(deleteButton);
  deleteButton.onClick.listen((e) {
    if(window.confirm("Do you want to reset your game? If you don't have a back up, this is permanent.")) {
      game.reset();
    }
  });

}

