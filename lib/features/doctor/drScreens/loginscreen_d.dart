import 'package:flutter/material.dart';
import 'package:diaguard1/core/service/auth.dart';
import 'package:diaguard1/widgets/gradientContainer.dart';
import 'package:diaguard1/widgets/logo_widget.dart';

class loginscreenD extends StatefulWidget {
  const loginscreenD({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<loginscreenD> {
  final _controllerFullName = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  final AuthService _authService = AuthService();

  bool newAccount = false;
  bool _isLoading = false;

  void _handleAuth() async {
    setState(() => _isLoading = true);

    String email = _controllerEmail.text.trim();
    String password = _controllerPassword.text.trim();
    String name = _controllerFullName.text.trim();
    String responseMessage;

    if (newAccount) {
      responseMessage = await _authService.signup(email, password, name);
    } else {
      responseMessage = await _authService.login(email, password);
    }

    setState(() => _isLoading = false);

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
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
                  const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Text(
                      "تسجيل الدخول للطبيب",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                  if (newAccount)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: TextField(
                        controller: _controllerFullName,
                        decoration: const InputDecoration(
                          hintText: "الاسم كامل",
                          hintStyle: TextStyle(color: Colors.white70),
                          focusedBorder: UnderlineInputBorder(
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
                      decoration: const InputDecoration(
                        hintText: "حساب البريد",
                        hintStyle: TextStyle(color: Colors.white70),
                        focusedBorder: UnderlineInputBorder(
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
                      decoration: const InputDecoration(
                        hintText: "كلمة السر",
                        hintStyle: TextStyle(color: Colors.white70),
                        focusedBorder: UnderlineInputBorder(
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
                          "إنشاء حساب جديد",
                          style: TextStyle(
                            color: newAccount ? Colors.white : Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => newAccount = false),
                        child: Text(
                          "لدي حساب قديم",
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
                                newAccount ? 'إنشاء الحساب' : 'تسجيل الدخول',
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
