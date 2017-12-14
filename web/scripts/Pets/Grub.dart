import "Pet.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
import 'package:json_object/json_object.dart';
import 'dart:async';
import 'dart:html';



class Grub extends Pet{
  @override
  String type = Pet.GRUB;
  Grub(Doll doll, {health: 100, boredom: 0}) : super(doll, health: health, boredom: boredom) {
    //at half way mark, eyes turn yellow like a trolls.
    if(percentToChange > 0.5) {
      HomestuckPalette p = doll.palette as HomestuckPalette;
      p.add(HomestuckPalette.EYE_WHITE_LEFT, ReferenceColours.TROLL_PALETTE.eye_white_left,true);
      p.add(HomestuckPalette.EYE_WHITE_RIGHT, ReferenceColours.TROLL_PALETTE.eye_white_right,true);
    }
  }

  Grub.fromJSON(String json, [JsonObject jsonObj]) : super(null){
    loadFromJSON(json, jsonObj);
    print ("loaded $name");
    //at half way mark, eyes turn yellow like a trolls.
    if(percentToChange > 0.5) {
      HomestuckPalette p = doll.palette as HomestuckPalette;
      p.add(HomestuckPalette.EYE_WHITE_LEFT, ReferenceColours.TROLL_PALETTE.eye_white_left,true);
      p.add(HomestuckPalette.EYE_WHITE_RIGHT, ReferenceColours.TROLL_PALETTE.eye_white_right,true);
    }
  }


  }