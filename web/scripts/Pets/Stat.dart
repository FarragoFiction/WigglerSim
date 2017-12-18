import 'package:DollLibCorrect/DollRenderer.dart';

class Stat {
    static int highNormal = 20;
    static int lowNormal = -20;
    int value;
    String positiveName;
    String negativeName;

    Stat(this.value, this.positiveName, this.negativeName) {
        if(value == null) {
            Random rand = new Random();
            value = rand.nextIntRange(lowNormal, highNormal);
        }
    }

    @override
    String toString() {
        if(value >= 0) {
            return "$positiveName: $value";
        }else {
            return "$negativeName: ${value.abs()}";
        }
    }

}