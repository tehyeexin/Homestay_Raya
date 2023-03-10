import 'dart:convert';
import 'package:ndialog/ndialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lab_asg_2_homestay_raya/serverconfig.dart';
import 'package:lab_asg_2_homestay_raya/models/user.dart';
import 'package:lab_asg_2_homestay_raya/view/screens/customerscreen.dart';
import 'package:lab_asg_2_homestay_raya/view/screens/registerscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();

  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();

  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  bool _passwordVisible = true;
  late double screenHeight, screenWidth, cardWidth;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      cardWidth = screenWidth;
    } else {
      cardWidth = 400.00;
    }
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: Center(
          child: SingleChildScrollView(
              child: SizedBox(
        width: cardWidth,
        child: Column(
          children: [
            const Text('Homestay Raya',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 83, 67, 61))),
            const SizedBox(height: 30),
            Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                margin: const EdgeInsets.all(8),
                child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 83, 67, 61)),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                              controller: _emailEditingController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) => val!.isEmpty ||
                                      !val.contains("@") ||
                                      !val.contains(".")
                                  ? "Please enter a valid email"
                                  : null,
                              focusNode: focus,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus1);
                              },
                              decoration: const InputDecoration(
                                  labelText: 'Email',
                                  icon: Icon(Icons.email),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.0),
                                  ))),
                          TextFormField(
                              textInputAction: TextInputAction.done,
                              validator: (val) =>
                                  val!.isEmpty ? "Please enter password" : null,
                              focusNode: focus1,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(focus2);
                              },
                              controller: _passEditingController,
                              obscureText: _passwordVisible,
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  icon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          const SizedBox(height: 15),
                          Row(children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                                saveremovepref(value!);
                              },
                            ),
                            const Flexible(
                              child: Text('Remember me',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MaterialButton(
                                color: Colors.brown,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                minWidth: 100,
                                height: 40,
                                elevation: 10,
                                onPressed: _loginUser,
                                child: const Text('Login',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ))),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Don't have an account? ",
                    style: TextStyle(fontSize: 15)),
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const RegisterScreen()))
                  },
                  child: const Text(
                    " Sign up here",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _goHome,
              child: const Text(
                "Back",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ))),
    );
  }

  void _loginUser() {
    FocusScope.of(context).requestFocus(FocusNode());

    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please fill in the login credentials first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    String _email = _emailEditingController.text;
    String _pass = _passEditingController.text;
    http.post(
        Uri.parse("${ServerConfig.SERVER}/homestayraya/php/login_user.php"),
        body: {"email": _email, "password": _pass}).then((response) {
      print(response.body);

      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == "success") {
        print(jsonResponse);
        User user = User.fromJson(jsonResponse['data']);

        ProgressDialog progressDialog = ProgressDialog(context,
            message: const Text("Logging in"), title: const Text("User Login"));
        progressDialog.show();

        Fluttertoast.showToast(
            msg: "Login Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);

        progressDialog.dismiss();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => CustomerScreen(user: user)));
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: const Text(
                "Invalid email or password",
              ),
              content: const Text(
                "Please try again",
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    "OK",
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );

        Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    });
  }

  void saveremovepref(bool value) async {
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (value) {
      if (!_formKey.currentState!.validate()) {
        Fluttertoast.showToast(
            msg: "Please fill in the login credentials first",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        _isChecked = false;
        return;
      }
      await pref.setString('email', email);
      await pref.setString('pass', password);
      Fluttertoast.showToast(
          msg: "Preference Stored",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    } else {
      await pref.setString('email', '');
      await pref.setString('pass', '');
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        _isChecked = false;
      });
      Fluttertoast.showToast(
          msg: "Preference Removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.isNotEmpty) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
        _isChecked = true;
      });
    }
  }

  void _goHome() {
    User user = User(
        id: "0",
        email: "unregistered",
        name: "unregistered",
        phone: "0",
        regdate: "0");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => CustomerScreen(
                  user: user,
                )));
  }
}
