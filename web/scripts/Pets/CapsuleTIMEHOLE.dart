import '../GameShit/GameObject.dart';
import 'JSONObject.dart';
import 'Pet.dart';

class CapsuleTIMEHOLE {
    Pet pet;
    String breederName = "UNIMPORTANT";
    CapsuleTIMEHOLE(Pet this.pet, String this.breederName){

    }

    Map<String,String> makePostData() {
        Map<String,String> data = new Map<String,String>();
        data["wigglerJSON"] = toJson().toString();
        data["permanent"] = "false";
        Map<String,String> ret = new Map<String,String>();
        ret["time_hole"] = data.toString();
        return ret;
    }

    JSONObject toJson() {
        JSONObject json = new JSONObject();
        json["pet"] = pet.toJson().toString();
        json["breeder"] = breederName;
        return json;
    }

    CapsuleTIMEHOLE.fromJson(JSONObject json){
        pet = Pet.loadPetFromJSON(json["pet"]);
        breederName = json['breeder'];
    }

    void givePet() {
        GameObject.instance.addPet(pet);
    }


}