import "Pet.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
class Grub extends Pet{
  Grub(Doll doll, {health: 100, boredom: 0}) : super(doll, health: health, boredom: boredom);

  Grub.fromJSON(String json) : super(null){
    loadFromJSON(json);
  }

}