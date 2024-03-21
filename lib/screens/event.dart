import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:election_day/db/database.dart';
import 'package:election_day/helpers/datetime.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  String date = getCurrentDate();
  DatabaseHelper dbHelper = DatabaseHelper();
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  File? _image;
  String? _imagePath;

  Future<void> _getImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        _imagePath = pickedImage.path; // Guardar la ruta del archivo
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: tituloController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Ingrese un título',
              ),
            ),
            SizedBox(height: 15.0),
            TextField(
              controller: descripcionController,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Ingrese una descripción',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15.0),
            _image != null
                ? Image.file(
                    _image!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                : Container(),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _getImage(ImageSource.camera);
                  },
                  child: Text('Tomar foto'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _getImage(ImageSource.gallery);
                  },
                  child: Text('Seleccionar de galería'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String titulo = tituloController.text;
          String descripcion = descripcionController.text;

          await dbHelper.insertEvento({
            'fecha': date,
            'titulo': titulo,
            'descripcion': descripcion,
            'foto': _imagePath, // Guardar la ruta del archivo en la base de datos
          });
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
