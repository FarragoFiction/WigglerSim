import 'dart:async';
import 'dart:html';
import "GameObject.dart";
import "Empress.dart";

class MoneyHandler {
    static MoneyHandler instance;
    Element containerElement;
    Element moneyFactsElement;
    ButtonElement allowenceButton;
    Element countdownElement;

    //in milliseconds
    int syncFrequency = 1000;
    Duration timeTillAllowence;

    MoneyHandler(Element container) {
        instance = this;
        containerElement = new DivElement();
        container.append(containerElement);
        containerElement.style.textAlign = "left";
        makeMoneyFactsElement();
        makeAllowenceButton();
        makeCountdownElement();
        //fire off the syncing, which will happen once every syncFrequency
        sync();
    }

    void makeMoneyFactsElement() {
        moneyFactsElement = new SpanElement();
        moneyFactsElement.classes.add("moneyFacts");
        containerElement.append(moneyFactsElement);
    }

    void makeAllowenceButton() {
        allowenceButton = new ButtonElement();
        containerElement.append(allowenceButton);
        allowenceButton.text = "Receive Empire Funding";
        allowenceButton.onClick.listen((e) {
            if(timeTillAllowence.inSeconds >= Empress.instance.timeBetweenFunding) {
                //reset countdown.
                GameObject.instance.player.lastGotAllowence =  new DateTime.now();
                //give player money.
                GameObject.instance.player.caegers += Empress.instance.fundingAmount;
                print("caegers is now ${ GameObject.instance.player.caegers}");
            }else {
                GameObject.instance.infoElement.text = "Something has gone wrong. How can you click this button if time hasn't run out yet?";
            }
        });
    }

    void makeCountdownElement() {
        countdownElement = new SpanElement();
        countdownElement.classes.add("countdown");
        containerElement.append(countdownElement);
    }

    void sync() {
        moneyFactsElement.text = "Troll Caegers: ${GameObject.instance.player.caegers}";
        DateTime now = new DateTime.now();
        if(GameObject.instance.player.lastGotAllowence != null) {
            timeTillAllowence = now.difference(GameObject.instance.player.lastGotAllowence);
        }else {
            timeTillAllowence = now.difference(now);
        }
        countdownElement.text = "Time Till Next Empire Funding: ${timeTillAllowence}";
        showOrHideButtonAndCountdown();
        GameObject.instance.save();
        new Timer(new Duration(milliseconds: syncFrequency), () => sync());

    }

    void showOrHideButtonAndCountdown() {
        if(timeTillAllowence.inSeconds >= Empress.instance.timeBetweenFunding) {
            allowenceButton.disabled  = false;
            allowenceButton.style.display = "inline-block";
            countdownElement.style.display = "none";
        }else {
            allowenceButton.disabled  = true;
            allowenceButton.style.display = "none";
            countdownElement.style.display = "inline-block";
        }
    }


}