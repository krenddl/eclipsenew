import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageCloud {
  final Supabase supabase = Supabase.instance;

  Future<void> addImageCloud(XFile imageFile) async {
    try {
      final fileName = path.basename(imageFile.path);

      await supabase.client.storage
          .from('eclipseApp')
          .upload(fileName, File(imageFile.path))
          .then((value) => print("Completed"));
    } catch (e) {
      return;
    }
  }
}
