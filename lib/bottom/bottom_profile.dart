import 'dart:io';

import 'package:eclipce_app/database/auth.dart';
import 'package:eclipce_app/database/users/user_table.dart';
import 'package:path/path.dart' as path;
import 'package:eclipce_app/database/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BottomProfilePage extends StatefulWidget {
  const BottomProfilePage({super.key});

  @override
  State<BottomProfilePage> createState() => _BottomProfilePageState();
}

class _BottomProfilePageState extends State<BottomProfilePage> {
  XFile? _file;
  File? _selectedFile;
  StorageCloud storageCloud = StorageCloud();
  String? url;
  final user_id = Supabase.instance.client.auth.currentUser!.id;
  dynamic docs;
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  UserTable userTable = UserTable();
  AuthService authService = AuthService();  

  Future<void> getUserById() async {
    try {
      final user = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', user_id)
          .single();

      setState(() {
        docs = user;
        emailController.text = user['email'].toString();
        fullnameController.text = user['fullname'].toString();
      });
    } catch (e) {
      return;
    }
  }

  Future<void> selectedImageGallery() async {
    final returnImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (returnImage == null) return;
    setState(() {
      _selectedFile = File(returnImage.path);
      _file = returnImage;
    });
  }

  Future<void> uploadImage() async {
    await storageCloud.addImageCloud(_file!);
  }

  Future<void> downloadUrl() async {
    try {
      final fileName = path.basename(_file!.path);
      final image = Supabase.instance.client.storage
          .from('eclipseApp')
          .getPublicUrl(fileName);

      setState(() {
        url = image;
      });
    } catch (e) {
      return;
    }
  }

  Future<void> updateImage() async {
    showDialog(
      context: context,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: Colors.white70)),
    );

    await uploadImage();

    await Future.delayed(Duration(seconds: 3));
    await downloadUrl();

    await userTable.updateImage(url!, user_id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Изменения сохранены!"),
        backgroundColor: Colors.white70,
      ),
    );
  }


  @override
  void initState() {
    getUserById();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerRight,
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.5,
                child: IconButton(
                  onPressed: () async {
                    await selectedImageGallery();
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.height * 0.4,
                child: CircleAvatar(
                  backgroundImage: _selectedFile != null
                      ? FileImage(_selectedFile!)
                      : (docs != null && (docs['avatar'] as String).isNotEmpty)
                      ? NetworkImage(docs['avatar'])
                      : null,
                  child:
                      _selectedFile == null &&
                          (docs == null || (docs['avatar'] as String).isEmpty)
                      ? Icon(Icons.person, size: 48, color: Colors.white70)
                      : null,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                alignment: Alignment.centerLeft,
                child: Text(
                  "ФИО",
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
                    hintText: 'ФИО',
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
                  enabled: false,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'eclipse@mail.ru',
                    fillColor: Colors.white10,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.white10),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.white10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Container(
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width * 0.9,
                child: InkWell(
                  child: Text('Сменить пароль'),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/recpass');
                  },
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
                    if (_selectedFile != null &&
                        fullnameController.text !=
                            docs['fullname'].toString()) {
                      await updateImage();
                      await userTable.updateFullname(
                        fullnameController.text,
                        user_id,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Изменения сохранены!"),
                          backgroundColor: Colors.white70,
                        ),
                      );
                    } else if (_selectedFile != null &&
                        docs['fullname'] == fullnameController.text) {
                      await updateImage();
                      Navigator.pop(context);
                    } else if (_selectedFile == null &&
                        fullnameController.text !=
                            docs['fullname'].toString()) {
                      await userTable.updateFullname(
                        fullnameController.text,
                        user_id,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Изменения сохранены!"),
                          backgroundColor: Colors.white70,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Проверьте правильность заполнения!"),
                          backgroundColor: Colors.white70,
                        ),
                      );
                    }
                  },

                  child: Text("Сохранить"),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  style: ButtonStyle(
                    
                    foregroundColor: WidgetStatePropertyAll(
                      Colors.deepPurple,
                    ),
                  ),
                  onPressed: () async {
                    await authService.logOut();

                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', false);

                    Navigator.popAndPushNamed(context, '/');
                  },
                  child: Text("Выйти"),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
