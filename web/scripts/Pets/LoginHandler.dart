import 'dart:convert';
import 'dart:html';

abstract class LoginHandler {
    static String LOGINLOCATION = "WIGGLERSIMLOGIN";


    bool hasLogin() {
        window.localStorage.containsKey(LOGINLOCATION);
    }

    void storeLogin(String login, String password) {
        window.localStorage[LOGINLOCATION] = new LoginInfo(login, password).toJSON();
    }

    //either who you are currently logged in as and an option to log out
    //or a form for logging in.
    DivElement loginStatus() {

    }

    LoginInfo fetchLogin() {
        return LoginInfo.fromJSON(window.localStorage[LOGINLOCATION]);
    }
}

class LoginInfo{
    String login;
    String password;
    LoginInfo(String this.login, String this.password);

    @override
    String toJSON() {
        return jsonEncode({"login":login, "password":password});
    }

    LoginInfo.fromJSON(String json){
        var tmp = jsonDecode(json);
        login = tmp["login"];
        password = tmp["password"];
    }

}