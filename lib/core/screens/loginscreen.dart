import 'package:flutter/material.dart';
import 'package:diaguard1/core/service/auth.dart';

class LoginScreen extends StatefulWidget {
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

    String email = _controllerEmail.text.trim();
    String password = _controllerPassword.text.trim();
    String name = _controllerFullName.text.trim();
    String responseMessage;

    if (newAccount) {
      responseMessage = await _authService.signup(email, password, name);
    } else {
      responseMessage = await _authService.login(email, password);
    }

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(responseMessage),
        backgroundColor:
            responseMessage.contains('successful') ? Colors.green : Colors.red,
      ),
    );

    if (responseMessage.contains('successful') && !newAccount) {
      Navigator.pushReplacementNamed(context, '/homepatient');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 231, 229, 229),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(100.0, 60.0, 100.0, 70.0),
            child: Image.asset(
              "images/logo.jpg",
              width: 200,
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 330),
                  curve: Curves.linear,
                  width: double.infinity,
                  height: screenHeight * 0.75,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF126A71), Color(0xFF50D6D6)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: Text(
                            "تسجيل الدخول للمريض",
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ),

                        // Full Name Field Only for new accounts
                        newAccount
                            ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50.0,
                              ),
                              child: TextField(
                                controller: _controllerFullName,
                                decoration: InputDecoration(
                                  hintText: "الاسم كامل",
                                  hintStyle: TextStyle(color: Colors.white70),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                            )
                            : Container(),

                        // Email Field
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50.0,
                            vertical: 10,
                          ),
                          child: TextField(
                            controller: _controllerEmail,
                            decoration: InputDecoration(
                              hintText: "حساب البريد",
                              hintStyle: TextStyle(color: Colors.white70),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            style: TextStyle(fontSize: 22, color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),

                        // Password Field
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50.0,
                            vertical: 10,
                          ),
                          child: TextField(
                            controller: _controllerPassword,
                            decoration: InputDecoration(
                              hintText: "كلمة السر",
                              hintStyle: TextStyle(color: Colors.white70),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            style: TextStyle(fontSize: 22, color: Colors.white),
                            obscureText: true,
                          ),
                        ),

                        // Toggle Buttons
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    newAccount = true;
                                  });
                                },
                                child: Text(
                                  "إنشاء حساب جديد",
                                  style: TextStyle(
                                    color:
                                        newAccount
                                            ? Colors.white
                                            : Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    newAccount = false;
                                  });
                                },
                                child: Text(
                                  "لدي حساب قديم",
                                  style: TextStyle(
                                    color:
                                        !newAccount
                                            ? Colors.white
                                            : Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Submit Button
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              minimumSize: Size(274, 41),
                            ),
                            onPressed: _isLoading ? null : _handleAuth,
                            child:
                                _isLoading
                                    ? CircularProgressIndicator(
                                      color: Colors.black,
                                    )
                                    : Text(
                                      newAccount
                                          ? 'إنشاء الحساب'
                                          : 'تسجيل الدخول',
                                      style: TextStyle(
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
              ),
            ),
          ),
          Positioned(
            top: 40, // Adjust for spacing
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
