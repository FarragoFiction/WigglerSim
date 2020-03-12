import 'dart:html';

import 'package:CommonLib/Utility.dart';

import '../GameShit/GameObject.dart';
import 'LoginHandler.dart';
import 'Pet.dart';
import 'dart:convert';
import "dart:math" as Math;

class CapsuleTIMEHOLE {
    Pet pet;
    String breederName = "UNIMPORTANT";
    int caretakerId;
    CapsuleTIMEHOLE(Pet this.pet, String this.breederName){

    }

    Map<String,String> makePostData([bool haxMode = false]) {
        Map<String, String> data = new Map<String, String>();
        if (haxMode) {
            data["wigglerJSON"] = toJson().toString();
            data["permanent"] = "false";
            data["login"] = "yggdrasilsYeoman";
            data["password"] = "nidhoggsFavorite"; //be nice plz
        } else{
            LoginInfo info = LoginHandler.fetchLogin();
            data["wigglerJSON"] = toJson().toString();
            data["permanent"] = "false";
            data["login"] = info.login;
            data["password"] = info.password;
        }
        return data;
    }

    Map<String, dynamic>  toJson() {
        Map<String, dynamic>  json = new Map<String, dynamic> ();
        json["pet"] = pet.toJSON();
        int nameLength = Math.max(0,Math.min(breederName.length,113));
        json["breeder"] = breederName.substring(0,nameLength);
        return json;
    }

    CapsuleTIMEHOLE.fromJson(Map<String,dynamic> json, int cid){
        //print("parsing json $json into a capsule");
        pet = Pet.loadPetFromJSON(json["pet"]);
        print("pet is $pet");
        breederName = json['breeder'];
        print("json was $json");
        if(cid != null) {
            caretakerId = cid;
        }
    }

    void givePet() {
        GameObject.instance.addPet(pet);
    }

    static List<CapsuleTIMEHOLE> getAllFromJSON(String json) {
        List<CapsuleTIMEHOLE> ret = new List<CapsuleTIMEHOLE>();
        List<dynamic> what = jsonDecode(json);
        //print("what json is $what");
        for(dynamic d in what) {
            try {
                //print("dynamic json thing is  $d");
                JSONObject j = new JSONObject();
                j.json = d;
                JSONObject innerJSON = new JSONObject.fromJSONString(
                    j["wigglerJSON"]);
                ret.add(new CapsuleTIMEHOLE.fromJson(innerJSON, null));
            }catch(error, trace) {
                window.console.error(error);
                window.console.error(trace);
                print("error parsing $d,  $error");
            }
        }
        return ret;

    }


}


