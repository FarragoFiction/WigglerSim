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
        return data;
    }

    JSONObject toJson() {
        JSONObject json = new JSONObject();
        json["pet"] = pet.toJson().toString();
        json["breeder"] = breederName;
        return json;
    }

    CapsuleTIMEHOLE.fromJson(JSONObject json){
        print("parsing json $json into a capsule");
        pet = Pet.loadPetFromJSON(json["pet"]);
        print("pet is $pet");
        breederName = json['breeder'];
    }

    void givePet() {
        GameObject.instance.addPet(pet);
    }


}