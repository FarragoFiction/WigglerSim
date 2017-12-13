import "Pet.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
import 'package:json_object/json_object.dart';
import 'dart:async';
import 'dart:html';



class Grub extends Pet{
  @override
  String type = Pet.GRUB;
  Grub(Doll doll, {health: 100, boredom: 0}) : super(doll, health: health, boredom: boredom);

  Grub.fromJSON(String json, [JsonObject jsonObj]) : super(null){
    loadFromJSON(json, jsonObj);
    print ("loaded $name");
  }


  }