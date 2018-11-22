import 'JSONObject.dart';
import 'Pet.dart';

class CapsuleTIMEHOLE {
    Pet pet;
    String breederName = "UNIMPORTANT";
    CapsuleTIMEHOLE(Pet this.pet, String this.breederName){

    }

    JSONObject toJson() {
        JSONObject json = new JSONObject();
        json["pet"] = pet.toJson().toString();
        json["breeder"] = breederName;
        return json;
    }
}