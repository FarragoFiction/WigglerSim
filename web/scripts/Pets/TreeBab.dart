import 'Grub.dart';
import "Pet.dart";
import 'Stat.dart';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'package:CommonLib/Utility.dart';

import 'dart:async';
import 'dart:html';
import "../Controllers/navbar.dart";




class TreeBab extends Grub{

  @override
  int millisecondsToChange = 2 * Pet.timeUnit;

  @override
  String type = Pet.TREEBAB;
  TreeBab(Doll doll, {health: 100, boredom: 0}) : super(doll, health: health, boredom: boredom) {
    convertDoll();

    setEyes();
  }

  void convertDoll() {
    doll = Doll.convertOneDollToAnother(doll, new HomestuckTreeBab());
    (doll as HomestuckTreeBab).extendedBody.imgNumber = 1;
    (doll as HomestuckTreeBab).body.imgNumber = 1;
  }


  @override
  TreeBab.fromJSON(String json, [JSONObject jsonObj]) : super(null){
    print("loading tree bab from json");
    loadFromJSON(json, jsonObj);
    convertDoll();
    //print ("loaded $name");
    //at half way mark, eyes turn yellow like a trolls.
  }




  }