import 'package:eclipce_app/database/auth.dart';
import 'package:flutter/material.dart';

class RecoveryPasswordPage extends StatefulWidget {
  const RecoveryPasswordPage({super.key});

  @override
  State<RecoveryPasswordPage> createState() => _RecoveryPasswordPageState();
}

class _RecoveryPasswordPageState extends State<RecoveryPasswordPage> {
  TextEditingController emailController = TextEditingController();
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(156, 27, 12, 34),
              const Color.fromARGB(156, 39, 18, 48),
              const Color.fromARGB(218, 106, 57, 170),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/logo.png'),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.centerLeft,
              child: Text(
                'Электронная почта',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                controller: emailController,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'eclipse@mail.ru',
                  fillColor: Colors.white10,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.white10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.white10),
                  ),
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    const Color.fromRGBO(223, 213, 235, 100),
                  ),
                  foregroundColor: WidgetStatePropertyAll(
                    Color.fromARGB(156, 27, 12, 34),
                  ),
                ),
                onPressed: () async {
                  if (emailController.text.isNotEmpty) {
                    await authService.recoveryPassword(emailController.text);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Письмо отправлено на почту'),
                        backgroundColor: Color.fromARGB(156, 27, 12, 34),
                      ),
                    );

                    // Navigator.popAndPushNamed(context, '/auth');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Заполните поле email'),
                        backgroundColor: Color.fromARGB(156, 27, 12, 34),
                      ),
                    );
                  }
                },
                child: Text('Изменить пароль'),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.9,
                child: InkWell(child: Text('Назад'), onTap: () {
                  Navigator.popAndPushNamed(context, '/home');
                }),
              ),
          ],
        ),
      ),
    );
  }
}
