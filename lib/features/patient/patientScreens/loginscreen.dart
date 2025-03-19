import 'package:diaguard1/features/patient/patientScreens/patient_list.dart';
import 'package:flutter/material.dart';
import 'package:diaguard1/core/service/auth.dart';
import 'package:diaguard1/features/patient/patientScreens/questions.dart';
import 'package:diaguard1/widgets/gradientContainer.dart';
import 'package:diaguard1/widgets/logo_widget.dart';
import 'package:diaguard1/core/localization/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controllerFullName = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  final AuthService _authService = AuthService();

  bool newAccount = false;
  bool _isLoading = false;

  void _handleAuth() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String fullName = _controllerFullName.text.trim();
      String email = _controllerEmail.text.trim();
      String password = _controllerPassword.text.trim();
      dynamic response;

      if (newAccount) {
        response = await _authService.signup(
          fullName: fullName,
          email: email,
          password: password,
          role: widget.role,
        );
      } else {
        response = await _authService.login(
          email: email,
          password: password,
          role: widget.role,
        );
      }

      // Debug: Print the entire response
      print("Response from backend: $response");

      setState(() {
        _isLoading = false;
      });

      if (response['status'] == 'successful') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('successful'), backgroundColor: Colors.green),
        );

        // Debug: Print the user object from the response
        print("User object from response: ${response['user']}");

        // Extract the user's name from the response
        final String userName =
            response['user']['fullname'] ??
            'User'; // Use 'fullname' from the response
        print("Extracted user name: $userName");

        if (newAccount) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => QuestionScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => BarHome(userName: userName),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('failed'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print("error in _handleAuth fun: $e");
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 231, 229, 229),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const LogoWidget(),
          GradientContainer(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text(
                      LocaleKeys.login_patient.tr(),
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                  if (newAccount)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: TextField(
                        controller: _controllerFullName,
                        decoration: InputDecoration(
                          hintText: LocaleKeys.full_name.tr(),
                          hintStyle: const TextStyle(color: Colors.white70),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 10,
                    ),
                    child: TextField(
                      controller: _controllerEmail,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.email.tr(),
                        hintStyle: const TextStyle(color: Colors.white70),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: const TextStyle(fontSize: 22, color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 10,
                    ),
                    child: TextField(
                      controller: _controllerPassword,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.password.tr(),
                        hintStyle: const TextStyle(color: Colors.white70),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: const TextStyle(fontSize: 22, color: Colors.white),
                      obscureText: true,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => setState(() => newAccount = true),
                        child: Text(
                          LocaleKeys.new_account.tr(),
                          style: TextStyle(
                            color: newAccount ? Colors.white : Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => newAccount = false),
                        child: Text(
                          LocaleKeys.existing_account.tr(),
                          style: TextStyle(
                            color: !newAccount ? Colors.white : Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        minimumSize: const Size(274, 41),
                      ),
                      onPressed: _isLoading ? null : _handleAuth,
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                              : Text(
                                newAccount
                                    ? LocaleKeys.create_account.tr()
                                    : LocaleKeys.login.tr(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
