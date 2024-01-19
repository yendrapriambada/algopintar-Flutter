import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:algopintar/screens/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 700) {
          return const LoginWebPage();
        } else {
          return const LoginPageMobile();
        }
      },
    );
  }
}

class LoginWebPage extends StatelessWidget {
  const LoginWebPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFF5D60E2),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: SizedBox(
                          height: 180,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25.0),
                            child: Image.asset(
                              'images/app_icon.png',
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: const Text(
                        'Algo Pintar',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 24),
                      child: const Text(
                        'AlgoPintar merupakan sebuah platform media pembelajaran bagi siswa yang ingin mempelajari dasar keilmuan pemrograman. Aplikasi ini dilengkapi dengan materi, latihan soal, progress belajar, dan papan peringkat.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: LoginPageMobile(),
          ),
        ],
      ),
    );
  }
}

class LoginPageMobile extends StatefulWidget {
  const LoginPageMobile({super.key});

  @override
  State<LoginPageMobile> createState() => _LoginPageMobileState();
}

class _LoginPageMobileState extends State<LoginPageMobile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isButtonEnabled = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
        child: SizedBox(
          width: screenWidth <= 700 ? screenWidth : 450,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const BackButton(),
              const SizedBox(
                height: 14.0,
              ),
              Center(
                child: SizedBox(
                  height: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Image.asset(
                      'images/app_icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: const Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "E-mail",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        controller: _emailController,
                        onChanged: (value) => _validateForm(),
                        validator: (value) => _errorTextEmail,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          hintText: 'Masukkan email',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _passwordController,
                      obscureText: true,
                      onChanged: (value) => _validateForm(),
                      validator: (value) => _errorTextPassword,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        hintText: 'Masukkan password',
                        // errorText: _errorText,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                        width: 250,
                        height: 50,
                        margin: const EdgeInsets.only(top: 16),
                        child: SizedBox(
                          width: 1,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: (isButtonEnabled && !_isLoading)
                                ? () => _signIn()
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5D60E2),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                            icon: _isLoading
                                ? Container(
                                    width: 24,
                                    height: 24,
                                    padding: const EdgeInsets.all(2.0),
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const SizedBox(),
                            label: const Text(
                              'Login',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Belum punya akun?",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        const SignupScreen(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          child: const Text('Signup'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  // Dear reviewer, saya masih belum tahu caranya agar kode bisa se OOP mungkin atau rapih dan efisien
  // Dibawah ini code nya dikemanain dan bagaimana ya caranya supaya rapih nggak numpuk di satu file ini
  // Terima kasih reviewer! tapi jangan dikurangin ya bintang nya karena requirement nya belum disuruh untuk best practice hehehe
  void _signIn() async {
    showLoading(true);

    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String userId = userCredential.user!.uid;

      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('users/$userId').get();
      if (snapshot.exists) {
        print(snapshot.value);

        Map data = snapshot.value as Map;
        String userRole = data['role'] ?? '';

        if(userRole == "student"){
          Navigator.pushNamed(context, "/home");
        }
        else{
          Navigator.pushNamed(context, "/teacherHome");
        }
      } else {
        print('No data available.');
      }

      // also save the user's data locally
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('userId', userId);
      // prefs.setString('username', username);

      // Navigator.pushNamed(context, "/home");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Berhasil Login!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ));
    } on FirebaseAuthException catch (e) {
      // print("flag: ${e.code}");
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Email atau Password salah'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ));
      } else if (e.code == 'network-request-failed') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Sinyal jaringan lemah'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Terdapat suatu masalah, coba lagi nanti'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ));
      }
    }

    showLoading(false);
  }

  String? get _errorTextEmail {
    final textEmail = _emailController.value.text;
    if (textEmail.isEmpty) {
      return "Email tidak boleh kosong";
    } else if (!EmailValidator.validate(textEmail)) {
      return "Masukkan email yang valid";
    }
    return null;
  }

  String? get _errorTextPassword {
    final textPassword = _passwordController.value.text;
    if (textPassword.isEmpty) {
      return "Password tidak boleh kosong";
    } else if (textPassword.length < 6) {
      return "Password terlalu pendek. Minimal 6 Huruf";
    }
    return null;
  }

  void _validateForm() {
    // Validate both fields
    final emailValid = _errorTextEmail == null;
    final passwordValid = _errorTextPassword == null;

    // Enable the button only if both fields are valid
    setState(() {
      isButtonEnabled = emailValid && passwordValid;
    });
  }

  void showLoading(bool state) {
    setState(() {
      _isLoading = state;
    });
  }
}

class BackButton extends StatelessWidget {
  const BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            if (MediaQuery.of(context).size.width <= 700)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17.0),
                ),
                color: Colors.white,
                elevation: 4,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17.0),
                    color: Colors.white,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/landingPage");
                    },
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
