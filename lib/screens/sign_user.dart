import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:election_day/db/database.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  DatabaseHelper dbHelper = DatabaseHelper();
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController matriculaController = TextEditingController();
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
    return Scaffold(appBar: AppBar(title: Text('Registra un usuario', style: TextStyle(fontSize: 15.0),),),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Column(
            children: [
              GestureDetector(
            onTap: () {
              _showOptionsDialog(context);
            },
            child: _image != null
                ? Image.file(
                    _image!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ):
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/pic.jpg',),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
              ),
              SizedBox(height: 18.0,),

              Container(child: Column( children: [
                Text('Nombre:'),
                TextField(
                controller: nombreController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(border: OutlineInputBorder()),
            ),SizedBox(height: 12.0,),
             Text('Apellido:'),
            TextField(
                controller: apellidoController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(border: OutlineInputBorder()),
            ),SizedBox(height: 12.0,),
             Text('Matricula:'),
            TextField(
                controller: matriculaController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(border: OutlineInputBorder()),
            )],),)
              
      ],
          ),
        ),
      ),);
  }

void _showOptionsDialog(BuildContext context) async {
  final pickedImage = await showDialog<ImageSource>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Seleccione una opción"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text("Abrir cámara"),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.camera);
                },
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text("Acceder a galería"),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      );
    },
  );

  if (pickedImage != null) {
    _getImage(pickedImage);
  }
}
}
