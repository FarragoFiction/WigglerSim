import 'package:DollLibCorrect/DollRenderer.dart';
import "Sign.dart";
import "package:CommonLib/Collection.dart";
import 'dart:math' as Math;


class Stat {
    static int HIGH = 50;
    static int LOW = 0;
    static int MEDIUM = 25;
    static int VERYFUCKINGHIGH = 112;
    
    int value;
    String positiveName;
    String negativeName;

    //all flavor arrays will have default so doesn't sum to zero
    static StatFlavor defaultFlavor;
    static StatFlavor patienceFlavor;
    static StatFlavor energeticFlavor;
    static StatFlavor idealisticFlavor;
    static StatFlavor curiousFlavor;
    static StatFlavor loyalFlavor;
    static StatFlavor externalFlavor;
    static StatFlavor impatienceFlavor;
    static StatFlavor calmFlavor;
    static StatFlavor realisticFlavor;
    static StatFlavor acceptingFlavor;
    static StatFlavor freeFlavor;
    static StatFlavor internalFlavor;

    //flavor will keep high, low, mediumm, very high, and caste shit and causes of death
    StatFlavor positiveFlavor;
    StatFlavor negativeFlavor;



    //expect the template to look like "They "resented their role as a wiggler caretaker" and "stayed under the radar".
    static void makeFlavors() {
        Random rand = new Random();
        //if a stat is VERY high, easter egg where it claims they played sburb?
        defaultFlavor = new StatFlavor(0,"NULL")
            ..death = <String>["of a mysterious illness","suddenly and with no warning"]
            ..jade = <String>["cared for wigglers in the Caverns","flourished in their role as a wiggler caregiver","discovered they were a Rainbow Drinker after a tragic accident"]
            ..fuchsia = <String>["helped the citizens of the empire as best they could","planned their rebellion against the Empress"]
            ..purple = <String>[ "excelled as a Laughsassin"]
            ..mutant = <String>["dodged culling drones","hid their blood color at all costs","were terrified and miserable"]
            ..veryHigh = <String>["revolutionized the entire field of politics","changed the way trolls view romance for generations","mastered the art of slam poetry "]
            ..high = <String>["were a Archeradicator commander","pursued interesting cases as a Legislacerator","lead a team of Doctorerrorists","published breakthrough SCIENCE as a Researchafer"]
            ..medium = <String>["learned to be a flexgrappler","played arena stickball professionally","were a prestegious Ruffiannihilator","made a name for themselves as a Cavalreaper"]
            ..low = <String>["stayed under the radar","were unremarkable","lived a normal life"];

        //these only have the fields that would be interesting to have
        patienceFlavor = new StatFlavor(-3, Sign.SPACE)
            ..medium = <String>["followed the philosophy that 'slow and steady wins the race'","never let failure make them frustrated","always listened to their friends' problems"]
            ..jade =<String>["helped out new jade bloods with their duties","always had time to help the young wigglers in the caverns","had infinite patience for the mistakes of the young wigglers"]
            ..high = <String>["gained a reputation for slow and steady excellence","never gave up or let anyone down","were a good Moirail"]
            ..veryHigh = <String>["were the Empress's moirail", "brought about real change to the Empire, one troll at a time."];
        energeticFlavor = new StatFlavor(0, Sign.LIFE)
            ..high = <String>["became an expert in multiple fields","became a rock star known for flamboyant performances"]
            ..jade = <String>["was never too tired to spend time with the grubs","channeled their never ending energy towards grub care"]
            ..purple = <String>["subjuggulated the lower bloods","drove fear into the hearts of the low bloods with their Chucklevoodoos"]
            ..high = <String>["manged to change the Empire through sheer force of personality","became the leading expert in dozens of different fields"]
            ..medium = <String>["never seemed to stop moving","brought a vibrant energy to everything they did","had ALL the goals"];
        idealisticFlavor = new StatFlavor(1,Sign.HOPE)
            ..death  = <String>["fighting for what they believed in","trying to change the world","trying to change the empire"]
            ..high = <String>["fought hard for the changes they believed in", "never compromised their ideals"]
            ..jade = <String>["reformed culling policies in the caverns","fought hard for each wiggler to be allowed to live"]
            ..purple = <String>["reformed the Church", "inspired the Church to be less bloodthirsty"]
            ..fuchsia = <String>["reformed ${rand.pickFrom(<String>["culling policies","education","warfare"])}","used their status to change the Empire for the better"]
            ..veryHigh = <String>["founded a cult of personality","changed the Empire forever with their ideals","convinced everyone to agree with them through a sweeping religious movement"]
            ..medium = <String>["inspired the trolls around them with their ideals","dreamed of a better life","never stopped dreaming"];
        curiousFlavor = new StatFlavor(1, Sign.LIGHT)
            ..high = <String>["became a respected scientist known for breakthrough discoveries","became a Papperterorrist and exposed all sorts of corruption in the Empire"]
            ..fuchsia = <String>["spent their vast wealth on a network of informants","focused their reign on exploring the universe's secrets"]
            ..veryHigh = <String>["revealed the secrets of the universe","figured out reality was actually a simulation"]
            ..death  = <String>["asking the wrong questions","probing into things better left alone","exposing the wrong Highblood's secrets"]
            ..medium = <String>["had to know all there was to know","never stopped asking questions","always kept searching for truth"];
        loyalFlavor = new StatFlavor(1,Sign.BLOOD)
            ..death  = <String>["fighting the Empire's enemies","protecting their friends","putting down rebels and traitors"]
            ..fuchsia = <String>["tried to carry out the work of their predecessor","made sure their wigglerhood friends were taken care of in the new Regime"]
            ..purple = <String>["learned how to be a devout member of the Dark Carnival","wholeheartedly commited themselves to the Juggalo Church"]
            ..high = <String>["stuck with their childhood dream and became a Firebrigand","had high ranking political allies"]
            ..veryHigh = <String>["became so friendly and helpful that they ended up having an entire faction of loyal supporters","convinced all trolls everywhere to stop fighting each other"]
            ..medium = <String>["were a good friend","were a staunch supporter of the Empire","never betrayed their friends"];
        externalFlavor = new StatFlavor(1,Sign.MIND)
            ..death  = <String>["getting into other troll's business too much","trying to manipulate the wrong Highblood","bugging and fussing and meddling with the wrong Highblood"]
            ..purple = <String>["evangelized the Wicked Noise to other trolls at every opportunity", "spread the Wicked Noise"]
            ..medium = <String>["investigated the world around them constantly"]
            ..fuchsia = <String>["expanded the Empire ever outwards","paid close attention to the lives of their subjects"]
            ..high = <String>["paid close attention to interplanetary politics","became adept at reading other trolls intentions"]
            ..veryHigh = <String>["manipulated the entire Empire for their own ends","outmaneuvered all opponents as a political chessmaster"];
        impatienceFlavor = new StatFlavor(1,Sign.TIME)
            ..death  = <String>["skipping critical steps in a dangerous procedure","failing to read the instructions","trying to gain power too quickly"]
            ..medium = <String>["always rushed ahead to the next big thing","never stopped to rest"]
            ..jade = <String>["often snapped at the mistakes of the cavern wigglers","had difficulty controlling their temper around the wigglers"]
            ..high = <String>["became a Legislacerator in record time","refused to slow down their dreams"]
            ..veryHigh = <String>["became the youngest commander in the Empire's history","refused to wait for real change in the Empire"];
        calmFlavor = new StatFlavor(-3,Sign.DOOM)
            ..medium = <String>["made sure not to get too excited about unlikely possibilities"]
            ..purple = <String>["didn't actually subjugulate very often","got along pretty well with the lower bloods"]
            ..high = <String>["never went without a Moiral","became a trophy Moiral to an up and coming Highblood"]
            ..veryHigh = <String>["turned an entire army away from bloodlust","convinced all Trolls that there was a better, less violent path"];
        realisticFlavor = new StatFlavor(0,Sign.RAGE)
            ..medium = <String>["always strove to see the world for how it truly was","was very practical"]
            ..high = <String>["never accepted pretty lies","combated the Empire's propaganda"]
            ..veryHigh = <String>["tore down the lies of the Empire","spread anarchy and chaos wherever they went"];
        acceptingFlavor = new StatFlavor(-3,Sign.VOID)
            ..medium = <String>["knew that they knew nothing","collected unsolved mysteries","censored unwanted bits of history for the Empire"]
            ..high = <String>["kept the Empire's secrets", "went around proving pseudoscience false"]
            ..veryHigh = <String>["founded an entire new field of study when the old ones proved to not be enough","took valuable secrets to their grave"];

        freeFlavor = new StatFlavor(1,Sign.BREATH)
            ..death  = <String>["rebelling against the Empire","without any friends beside them","betraying the wrong Highblood"]
            ..jade = <String>["resented their role as a wiggler caregiver", "attempted to avoid the Caverns entirely"]
            ..fuchsia = <String>["strove to be their own type of ruler, independant of those who came before","completely ignored the foundations their predecessor had left behind"]
            ..purple = <String>["ignored the Juggalo Church entirely","resented the Juggalo stereotypes about their caste"]
            ..medium = <String>["refused to conform","never stayed in any one place long","worked as avant garde artist"]
            ..high = <String>["worked as a Scout for the Empire","rebeled against the Empire","didn't get drawn into political drama","were free to live their life as they pleased"]
            ..veryHigh = <String>["wandered the galaxy","lived without ties as a hermit on the Homeworld"];

        internalFlavor = new StatFlavor(0,Sign.HEART)
            ..medium = <String>["tried to be true to themself","were the heart of their core of friends"]
            ..fuchsia = <String>["used their status to pursue their own goals","lived a life of hedonistic ${rand.pickFrom(<String>["cake baking","movie stardom","hilarious culling"])}"]
            ..purple = <String>["memorized scripture on the Mirthful Messiahs","quietly learned scripture"]
            ..high = <String>["learned to be their true self","reflected the world around them so others could understand it","helped other trolls through stories of their own lives"]
            ..veryHigh = <String>["went down in history as a master philosopher","discovered enlightenment through meditation"];
    }

    Stat(this.value, this.positiveName, this.negativeName, this.positiveFlavor, this.negativeFlavor) {
        if(value == null) {
            Random rand = new Random();
            value = rand.nextIntRange(-1* HIGH, HIGH); //won't go above medium normally except rarely
        }else if(value != 0) {
            int direction = (value/value.abs()).round();
            value =  (direction * Math.min(value.abs(), Stat.VERYFUCKINGHIGH+1)).round();
        }

        if(Stat.defaultFlavor == null) {
            makeFlavors();
        }
    }

    StatFlavor get flavor {
        if(value >=0) {
            return positiveFlavor;
        }else {
            return negativeFlavor;
        }
    }

    WeightedList<String> getPossibleFlavors(WeightedList<String> output, String colorWorld) {
       // print("~~~~positive flavor is ${positiveFlavor} for ${positiveName} and negative is ${negativeFlavor} for ${negativeName}");
        return flavor.addWeightedFlavor(output, value, colorWorld);
    }

    WeightedList<String> getPossibleDeathFlavors(WeightedList<String> output) {
        return flavor.addDeathFlavor(output, value);
    }



    int get normalizedValue => value.abs();

    //useful to know how 'big' this stat is
    double get percentOfHighValue => (normalizedValue/Stat.HIGH);

    String get stringValue {
        if(normalizedValue > VERYFUCKINGHIGH) return "V High";
        if(normalizedValue > HIGH) return "High";
        if(normalizedValue > MEDIUM) return "Medium";
        if(normalizedValue >= LOW) return "Low";
        return "GLITCHED??? $normalizedValue";
    }

    @override
    String toString() {
        if(value >= 0) {
            return "$positiveName: $stringValue ($normalizedValue)";
        }else {
            return "$negativeName: $stringValue ($normalizedValue)";
        }
    }

}

/*
    Jumbled thoughts:

    Make some static premade vars of this for each stat type to have, one for pos, one for neg.

    when it's time to get middle, have a method that takes all stats and figures out
    which arrays to pick from.

 */
class StatFlavor {

    static double HIGHWEIGHT = 2.0;
    static double LOWWEIGHT = 0.5;
    static double MEDIUMWEIGHT = 1.0;
    static double VERYFUCKINGHIGHWEIGHT = 10.0;
    //any of these can be empty. it's okay. don't worry about it.
    List<String> high = new List<String>();
    List<String> medium = new List<String>();
    List<String> low = new List<String>();
    List<String> veryHigh = new List<String>();
    List<String> jade = new List<String>();
    List<String> fuchsia = new List<String>();
    List<String> purple = new List<String>();
    List<String> mutant = new List<String>();

    //they died X "fighting the empire" "of a mysterious illness" etc.
    List<String> death = new List<String>();

    //if you're patient, reduces, if you're impatient,increases, etc
    int oddsOfViolentDeath = 0;
    String aspect; //this should match up to a Sign.ASPECT thingy

    StatFlavor(this.oddsOfViolentDeath, this.aspect) {

    }

    static double getWeightByValue(int value) {
        if(value >= Stat.VERYFUCKINGHIGH) return VERYFUCKINGHIGHWEIGHT;
        if(value >= Stat.HIGH) return HIGHWEIGHT;
        if(value >= Stat.MEDIUM) return MEDIUMWEIGHT;
        if(value >= Stat.LOW) return LOWWEIGHT;
        return 0.01;
    }

    WeightedList<String> addDeathFlavor(WeightedList<String> output, int value,[bool isDefault = false]) {
        double multiplier = 1.0;
        if(isDefault) multiplier = 0.01; //don't go for default if you have any better options
        double weight = 0.0;
        //start low, end high
        if(value >= Stat.LOW) weight = LOWWEIGHT;
        if(value >= Stat.MEDIUM) weight = MEDIUMWEIGHT;
        if(value >= Stat.HIGH) weight = HIGHWEIGHT;
        if(value >= Stat.VERYFUCKINGHIGH) weight = VERYFUCKINGHIGHWEIGHT;

        //will always add any death at the correct weight, with a possible default multiplier
        output = processTier(output, value, 0, death, weight,multiplier);

        return output;
    }

    WeightedList<String> addWeightedFlavor(WeightedList<String> output, int value, String colorWord, [bool isDefault = false]) {
        double multiplier = 1.0;
        if(isDefault) multiplier = 0.01; //don't go for default if you have any better options
        output = processTier(output, value, Stat.LOW, low, LOWWEIGHT,multiplier);
        output = processTier(output, value, Stat.MEDIUM, medium, MEDIUMWEIGHT,multiplier);
        output = processTier(output, value, Stat.HIGH, high, HIGHWEIGHT,multiplier);
        output = processTier(output, value, Stat.VERYFUCKINGHIGH, veryHigh, VERYFUCKINGHIGHWEIGHT,multiplier);

        output =  processColor(output, colorWord, HomestuckTrollDoll.JADE, jade, multiplier);
        output = processColor(output, colorWord, HomestuckTrollDoll.PURPLE, purple, multiplier);
        output = processColor(output, colorWord, HomestuckTrollDoll.FUCHSIA, fuchsia, multiplier);
        return output;
    }

    //if you are bigger or equal to the threshold, add yourself at the right weight.
    //so if you have high skills, you might only get a low tier event, don't always live up to potential. but mostly you will.
    WeightedList<String> processTier(WeightedList<String> output, int value, int thresholdComparator, List<String> results, double weight, double multiplier) {
        if(value >= thresholdComparator) {
            for(String s in results) {
                output.add(s, weight*multiplier);
            }
        }
        return output;
    }

    //if you are the right color, add the color shit.
    WeightedList<String> processColor(WeightedList<String> output, String colorWord, String targetWord, List<String> results,double multiplier) {
        double weight = HIGHWEIGHT; //your blood color matters as much as any skills you have up to medium.
        if(colorWord == targetWord) {
            for (String s in results) {
                output.add(s, weight * multiplier);
            }
        }
        return output;
    }




}


class StatWithDirection {
    Stat stat;
    int direction;

    StatWithDirection(Stat this.stat, int this.direction);
}