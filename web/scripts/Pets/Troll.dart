import "Pet.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
import "JSONObject.dart";
import 'dart:async';
import 'dart:html';
import "../GameShit/GameObject.dart";
import "Stat.dart";
import "Sign.dart";
import "../GameShit/Empress.dart";




class Troll extends Pet{

    static String EPILOGUE = "epilogue";
    
    @override
    int millisecondsToChange = Pet.timeUnit;

    //what happened to the troll now that they go off on their own?
    String epilogue;

    @override
    String type = Pet.TROLL;
    Troll(Doll doll, {health: 100, boredom: 0}) : super(doll, health: health, boredom: boredom) {
        //turns grub into troll., later will calc sign
        this.doll = Doll.convertOneDollToAnother(doll, new HomestuckTrollDoll());
         assignSign();
    }

    Troll.fromJSON(String json, [JSONObject jsonObj]) : super(null){
        loadFromJSON(json, jsonObj);
        this.doll = Doll.convertOneDollToAnother(doll, new HomestuckTrollDoll());
        assignSign();
        //print("doll for troll is $doll");
       // print ("loaded $name");
    }

    //troll signgs are based on stats (which are low key the aspects)
    //and lunar sway (which is random for now)
    //and, obviously, caste.
    void assignSign() {

        HomestuckTrollDoll t = doll as HomestuckTrollDoll;
        if(t.canonSymbol.imgNumber != 0) return; //don't fucking re decide this.
        HomestuckTrollPalette p = t.palette as HomestuckTrollPalette;
        String colorWord = t.bloodColorToWord(p.aspect_light);
        String aspect = highestStatToAspectWord();
        Random rand = new Random();
        //TODO pick moon via some sane metric, not random
        String lunarSway = rand.pickFrom(<String>[Sign.PROSPIT, Sign.DERSE]);
        t.canonSymbol.imgNumber = Sign.getSignByCriteria(colorWord, aspect, lunarSway);
        print("Assigning a sign of ${t.canonSymbol.imgNumber} to troll with ${colorWord}, ${aspect} and ${lunarSway}.  ");


    }

    String highestStatToAspectWord() {
        //don't prefer either early OR late stats that are equal, allow it to be random if you fucking must
        List<Stat> validChoices =<Stat>[stats.first];
        for(Stat s in stats) {
            if(s.normalizedValue > validChoices.first.normalizedValue) {
                validChoices.clear();
                validChoices.add(s);
            }else if(s.normalizedValue == validChoices.first.normalizedValue) {
                validChoices.add(s);
            }
        }
        Random rand = new Random();
        return rand.pickFrom(validChoices).flavor.aspect;
    }

    @override
    void loadFromJSON(String json, [JSONObject jsonObj]) {
        super.loadFromJSON(json, jsonObj);
        if(jsonObj == null)  jsonObj = new JSONObject.fromJSONString(json);
        epilogue = jsonObj[EPILOGUE];
    }

        String getLusus() {
        HomestuckTrollDoll t = doll as HomestuckTrollDoll;
        HomestuckTrollPalette p = t.palette as HomestuckTrollPalette;
        Random rand = new Random();
        rand.nextInt(); //needed for next bool to work.
        //purple bloods have 50% chance of seadweller lusi
        if(t.bloodColorToWord(p.aspect_light) == HomestuckTrollDoll.VIOLET || t.bloodColorToWord(p.aspect_light) == HomestuckTrollDoll.FUCHSIA || (t.bloodColorToWord(p.aspect_light) == HomestuckTrollDoll.PURPLE && rand.nextBool())) {
            return seaTrollLusus();
        }else {
            return trollLusus();
        }
    }

    String getCaregiverPhrase() {
        Random rand = new Random();
        List<String> badThing = <String>["threats","danger","enemies","predators","drones","other trolls","other lusii"];
        List<String> goodThing = <String>["vegetables","food","safety","water","shelter","meat","friends","self-esteem"];
        List<String> lifeSkill = <String>["fight","scavenge","hide","forage","collect food","hoard resources","share","cooperate","hunt"];
        List<String> violentLifeSkill = <String>["fight","strife","kill","murder","hunt","assassinate"];


        List<String> actions1 = <String>["protected them from ${rand.pickFrom(badThing)}","made sure they got enough ${rand.pickFrom(goodThing)}","taught them how to ${rand.pickFrom(lifeSkill)}","made sure they knew how to ${rand.pickFrom(violentLifeSkill)}"];
        List<String> actions2 = <String>["trained them to ${rand.pickFrom(violentLifeSkill)} ${rand.pickFrom(badThing)}","supplied them with enough ${rand.pickFrom(goodThing)}","showed them how to avoid ${rand.pickFrom(badThing)} and find ${rand.pickFrom(goodThing)}"];

        String action1 = rand.pickFrom(actions1); //needed so that rand. next bool works
        String action2 = rand.pickFrom(actions2);
        if(rand.nextBool()) {
            return "${action2} and ${action1}";
        }else {
            return "${action1} and ${action2}";
        }
    }

    String trollLusus() {
        Random rand = new Random();
        List<String> firstNames = <String>["Scale","Ram","Nut","Thief","March","Feather","Slither","Claw","Tooth","Meow","Woof","Sand","Mud","Water","Hoof","Muscle","Rage","Dig","Waddle","Run"];
        List<String> lastNames = <String>["Creature","Beast","Bug"];
        return "${rand.pickFrom(firstNames)} ${rand.pickFrom(lastNames)}";
    }

    String seaTrollLusus() {
        Random rand = new Random();
        List<String> firstNames = <String>["Swim", "Zap","Cuttle","Fin","Sea","Tentacle","Mud","Waddle","Water","Lake","Ocean","River","Swamp","Waterfall","Horror","Depth"];
        List<String> optionalSecondNames = <String>["Scale","Ram","Nut","Thief","March","Feather","Slither","Claw","Tooth","Meow","Woof","Sand","Mud","Water","Hoof","Muscle","Rage","Dig","Waddle","Run"];

        List<String> lastNames = <String>["Creature","Beast","Bug","Terror"];
        String first = rand.pickFrom(firstNames); //needed for next bool to work
        if(rand.nextBool()) {
            return "${first} ${rand.pickFrom(optionalSecondNames)} ${rand.pickFrom(lastNames)}";
        }else {
            return "${first} ${rand.pickFrom(lastNames)}";
        }
    }

    String getBegining() {
        String lusus = getLusus();
        String lususCaregivingThing = getCaregiverPhrase();
        return "${name} was taken in by a ${lusus} Lusus, who ${lususCaregivingThing}. ";
    }

    String getEnding() {
        Random rand = new Random();
        HomestuckTrollDoll t = doll as HomestuckTrollDoll;
        HomestuckTrollPalette p = t.palette as HomestuckTrollPalette;
        String colorWord = t.bloodColorToWord(p.aspect_light);
        int min = getMinNumberOfSweepsExpected(colorWord);
        int max = getMaxNumberOfSweepsExpected(colorWord);
        int lifeSpan =  rand.nextInt(max - min) + min;
        if(colorWord == HomestuckTrollDoll.FUCHSIA) {
            return fuchsiaEnding(lifeSpan);
        }else if(colorWord == HomestuckTrollDoll.MUTANT) {
            return mutantEnding(lifeSpan);
        }else {
            return regularEnding(lifeSpan);
        }
    }

    //different because of how likely they are to die young of very specic causes
    String fuchsiaEnding(int maxLife) {
        Random rand = new Random();
        int maxAgeOfChallenge = 100;
        int numberOfSweeps = rand.nextIntRange(5, maxAgeOfChallenge*2);

        if(numberOfSweeps >= maxAgeOfChallenge) {
            return heiressBecameEmpress(maxLife);
        }else {
            return heiressDiedChallenging(numberOfSweeps);
        }
    }

    //mutants are likely to be culled.
    String mutantEnding(int maxLife) {
        int argumentsFor = 10; //mutants are REALLY likely to be culled.
        int argumentsAgainst = 0;
        for(Stat s in stats) {
            int odds = s.flavor.oddsOfViolentDeath;
            if(odds > 0.0) {
                argumentsFor += (odds * StatFlavor.getWeightByValue(s.normalizedValue)).ceil();
            }else {
                argumentsAgainst += odds;
            }
        }
        Random rand = new Random();
        if(rand.nextIntRange(argumentsAgainst, argumentsFor) > 0) {
            int lifespan = rand.nextIntRange(0, maxLife);
            if(lifespan <= 1) return deathString(lifespan, "being found by culling drones while still in the caverns");

            List<String> culling = <String>["fleeing the culling drones","for the crime of being a mutant","for the good of the species",getViolentCauseOfDeath()];
            return deathString(lifespan, rand.pickFrom(culling));
        }else {
            return deathString(maxLife, rand.pickFrom(<String>["of natural causes","of old age","after spending their entire life managing to avoid the culling drones", "of a mutant related illness","after beating the odds and surviving as a mutant"]));

        }

    }

    String heiressDiedChallenging(int deathAge) {
        Random rand = new Random();
        //just random, not stat based?
        List<String> templates = <String>["They died challenging the Empress at ${deathAge} sweeps old.","They challenged the Empress when they were $deathAge sweeps old. They lost, and were forgotten by history."];
        if(deathAge > 20) templates.add("They managed to put off challenging the Empress until they were $deathAge sweeps old, but still died despite the extra preparation.");
        return rand.pickFrom(templates);
    }

    String heiressBecameEmpress(int maxLifespan) {
        empress = true;
        GameObject.instance.player.petInventory.rulingEmpress = new Empress(this);
        Random rand = new Random();
        int numberOfSweeps = rand.nextIntRange(5, maxLifespan*2);
        if(numberOfSweeps >= maxLifespan) {
            List<String> templates = <String>["They died of old age after $maxLifespan sweeps.","They managed to reach the end of even an Empress' lifespan after $maxLifespan sweeps.","They died of natural causes after $maxLifespan sweeps."];
            return rand.pickFrom(templates);
        }else {
            if(rand.nextDouble() > .3) {
                List<String> templates = <String>["They died after ${numberOfSweeps} sweeps when an Heiress was too good for them to defeat.","They finally met an Heiress they couldn't defeat after ${numberOfSweeps} sweeps.","The circle of life continued when they were killed by an Heiress at ${numberOfSweeps} sweeps."];
                return rand.pickFrom(templates);
            }else {
                return deathString(numberOfSweeps,getViolentCauseOfDeath());
            }
        }
    }

    String deathString(int numberOfSweeps, String cod) {
        Random rand = new Random();
        List<String> templates = <String>["They died $cod after $numberOfSweeps solar sweeps.","They died $cod after $numberOfSweeps sweeps.","They died $cod after $numberOfSweeps sweeps."];
        return rand.pickFrom(templates);
    }

    //based on stats
    String getViolentCauseOfDeath() {
        Random rand = new Random();
        WeightedList<String> possibilities = new WeightedList<String>();
        int averageStat = 0;
        for(Stat s in stats) {
            averageStat += s.normalizedValue;
            possibilities = s.getPossibleDeathFlavors(possibilities);
        }
        possibilities = Stat.defaultFlavor.addDeathFlavor(possibilities, (averageStat/stats.length).round(),true);
        //addDeathFlavor
        return rand.pickFrom(possibilities);
    }

    String regularEnding(int maxLife) {
        int argumentsFor = Empress.instance.argumentsForViolentDeath;
        int argumentsAgainst = Empress.instance.argumentsAgainstViolentDeath;
        for(Stat s in stats) {
            int odds = s.flavor.oddsOfViolentDeath;
            if(odds > 0.0) {
                argumentsFor += (odds * StatFlavor.getWeightByValue(s.normalizedValue)).ceil();
            }else {
                argumentsAgainst += odds;
            }
        }
        Random rand = new Random();
        if(rand.nextIntRange(argumentsAgainst, argumentsFor) > 0) {
            //violent death
            return deathString(rand.nextIntRange(5, maxLife), getViolentCauseOfDeath());
        }else {
            return deathString(maxLife, rand.pickFrom(<String>["of natural causes","of old age"]));

        }
    }

    //http://zetasession.proboards.com/thread/270/blood-caste-lifespans
    int getMinNumberOfSweepsExpected(String colorWord) {
        if(colorWord == HomestuckTrollDoll.BURGUNDY) return 12;
        if(colorWord == HomestuckTrollDoll.BRONZE) return 14;
        if(colorWord == HomestuckTrollDoll.GOLD) return 20;
        if(colorWord == HomestuckTrollDoll.LIME) return 30;
        if(colorWord == HomestuckTrollDoll.OLIVE) return 50;
        if(colorWord == HomestuckTrollDoll.JADE) return 90;
        if(colorWord == HomestuckTrollDoll.TEAL) return 130;
        if(colorWord == HomestuckTrollDoll.CERULEAN) return 400;
        if(colorWord == HomestuckTrollDoll.INDIGO) return 600;
        if(colorWord == HomestuckTrollDoll.PURPLE) return 700;
        if(colorWord == HomestuckTrollDoll.VIOLET) return 4000;
        if(colorWord == HomestuckTrollDoll.FUCHSIA) return 6000;
        return 1;
    }

    //http://zetasession.proboards.com/thread/270/blood-caste-lifespans
    int getMaxNumberOfSweepsExpected(String colorWord) {
        if(colorWord == HomestuckTrollDoll.BURGUNDY) return 24;
        if(colorWord == HomestuckTrollDoll.BRONZE) return 34;
        if(colorWord == HomestuckTrollDoll.GOLD) return 40;
        if(colorWord == HomestuckTrollDoll.LIME) return 60;
        if(colorWord == HomestuckTrollDoll.OLIVE) return 70;
        if(colorWord == HomestuckTrollDoll.JADE) return 100;
        if(colorWord == HomestuckTrollDoll.TEAL) return 150;
        if(colorWord == HomestuckTrollDoll.CERULEAN) return 500;
        if(colorWord == HomestuckTrollDoll.INDIGO) return 800;
        if(colorWord == HomestuckTrollDoll.PURPLE) return 900;
        if(colorWord == HomestuckTrollDoll.VIOLET) return 5000;
        if(colorWord == HomestuckTrollDoll.FUCHSIA) return 8000;
        return 60;
    }



    String createMiddle() {
        //need to ask all my stats to populate a list of weighted strings
        //i need to do the same with the average of my stats abs given to default
        //need to pick 1 string, keep a reference to it, remove it from list.
        //need to pick a second string.
        //need to have a simple  template that puts 1 and 2 in it.
        //need to return one template.

        HomestuckTrollDoll t = doll as HomestuckTrollDoll;
        HomestuckTrollPalette p = t.palette as HomestuckTrollPalette;
        String colorWord = t.bloodColorToWord(p.aspect_light);
        Random rand = new Random();

        WeightedList<String> possibilities = new WeightedList<String>();
        int averageStat = 0;
        for(Stat s in stats) {
            averageStat += s.normalizedValue;
            possibilities = s.getPossibleFlavors(possibilities, colorWord);
        }
        possibilities = Stat.defaultFlavor.addWeightedFlavor(possibilities, (averageStat/stats.length).round(), colorWord,true);

        String first = rand.pickFrom(possibilities);
        possibilities.remove(first);
        String second = rand.pickFrom(possibilities);

        return "They $first and $second.";

    }



    void createEpilogue() {
        epilogue = "";

        String begining = getBegining();
        String middle = createMiddle();
        String end = getEnding();
        epilogue  += "${begining} \n\n${middle}\n\n ${end}";
        GameObject.instance.save();
    }

    @override
    JSONObject toJson() {
        JSONObject json = super.toJson();
        json[EPILOGUE] = epilogue;
        return json;
    }

        @override
    Future<CanvasElement> drawStats() async {
        if(epilogue == null) createEpilogue();
        //never cache
        CanvasElement textCanvas = new CanvasElement(width: textWidth, height: textHeight);
        if(empress) {
            textCanvas.context2D.fillStyle = "#d27cc9";
            textCanvas.context2D.strokeStyle = "#2c002a";
        }else {
            textCanvas.context2D.fillStyle = "#d2ac7c";
            textCanvas.context2D.strokeStyle = "#2c1900";
        }
        textCanvas.context2D.lineWidth = 3;


        textCanvas.context2D.fillRect(0, 0, width, textHeight);
        textCanvas.context2D.strokeRect(0, 0, width, textHeight);

        textCanvas.context2D.fillStyle = "#2c1900";

        int fontSize = 20;
        textCanvas.context2D.font = "${fontSize}px Strife";
        int y = 330;
        int x = 10;
        Renderer.wrap_text(textCanvas.context2D,name,x,y,fontSize,400,"center");

        y = y + fontSize*2;
        fontSize = 12;

        int buffer = 10;
        y = y + fontSize+buffer;
        Renderer.wrap_text(textCanvas.context2D,epilogue,x,y,fontSize+buffer,275,"left");

        return textCanvas;
    }
}