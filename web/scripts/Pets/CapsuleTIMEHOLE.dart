import 'package:CommonLib/Utility.dart';

import '../GameShit/GameObject.dart';
import 'LoginHandler.dart';
import 'Pet.dart';
import 'dart:convert';
import "dart:math" as Math;

class CapsuleTIMEHOLE {
    Pet pet;
    String breederName = "UNIMPORTANT";
    CapsuleTIMEHOLE(Pet this.pet, String this.breederName){

    }

    Map<String,String> makePostData() {
        Map<String,String> data = new Map<String,String>();
        LoginInfo info = LoginHandler.fetchLogin();
        data["wigglerJSON"] = toJson().toString();
        data["permanent"] = "false";
        data["login"] = info.login;
        data["password"] = info.password;
        //TODO add login and password to this and hope rails can easily be cahnged to take it
        return data;
    }

    JSONObject toJson() {
        JSONObject json = new JSONObject();
        json["pet"] = pet.toJson().toString();
        int nameLength = Math.max(0,Math.min(breederName.length,113));
        json["breeder"] = breederName.substring(0,nameLength);
        return json;
    }

    CapsuleTIMEHOLE.fromJson(JSONObject json){
        //print("parsing json $json into a capsule");
        pet = Pet.loadPetFromJSON(json["pet"]);
        print("pet is $pet");
        breederName = json['breeder'];
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
                ret.add(new CapsuleTIMEHOLE.fromJson(innerJSON));
            }catch(error) {
                print("error parsing $d,  $error");
            }
        }
        return ret;

    }


}


