import 'package:eclipce_app/database/auth.dart';
import 'package:eclipce_app/database/users/user_table.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegPage extends StatefulWidget {
  const RegPage({super.key});

  @override
  State<RegPage> createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  TextEditingController birthDateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  AuthService authService = AuthService();
  UserTable userTable = UserTable();

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
          children: [
            Image.asset('images/logo.png'),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            // Почта
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.centerLeft,
              child: Text(
                "Электронная почта",
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

            // Пароль
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.centerLeft,
              child: Text(
                "Пароль:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                controller: passwordController,
                cursorColor: Colors.white,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  hintText: '********',
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

            // ФИО
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.centerLeft,
              child: Text(
                "ФИО:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                controller: fullnameController,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Иванов Иван Иванович',
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
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                children: [
                  // Дата
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Дата рождения:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        TextField(
                          controller: birthDateController,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: '19/01/2002',
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
                      ],
                    ),
                  ),

                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),

                  // Пол
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Пол:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        TextField(
                          controller: genderController,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'М/Ж',
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
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.04),

            // Кнопка
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
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty &&
                      fullnameController.text.isNotEmpty &&
                      birthDateController.text.isNotEmpty &&
                      genderController.text.isNotEmpty) {
                    var user = await authService.signUp(
                      emailController.text,
                      passwordController.text,
                    );
                    if (user != null) {
                      await userTable.addUserTable(
                        emailController.text,
                        fullnameController.text,
                        passwordController.text,
                        birthDateController.text,
                        genderController.text,
                        ''
                      );

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isLoggedIn', true);
                      Navigator.popAndPushNamed(context, '/');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Не удалось зарегестрировать"),
                          backgroundColor: Color.fromARGB(156, 27, 12, 34),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Заполните все поля"),
                        backgroundColor: Color.fromARGB(156, 27, 12, 34),
                      ),
                    );
                  }
                },
                child: Text("Зарегистрироваться"),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.03),

            // Ссылка вниз
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Есть аккаунт?"),
                TextButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/auth');
                  },
                  child: Text("Авторизоваться", style: TextStyle(fontSize: 15)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
