import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:election_day/db/database.dart';
import 'package:election_day/screens/event.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({Key? key}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Registra un usuario'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  _showOptionsDialog(context);
                },
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.file(
                          _image!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/camera.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
              ),
              SizedBox(
                height: 18.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre:'),
                  TextField(
                    controller: nombreController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    textInputAction:
                        TextInputAction.next, // Configurar como siguiente
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text('Apellido:'),
                  TextField(
                    controller: apellidoController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    textInputAction:
                        TextInputAction.next, // Configurar como siguiente
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text('Matrícula:'),
                  TextField(
                    controller: matriculaController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    textInputAction:
                        TextInputAction.done, // Configurar como finalizado
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                  ),
                  SizedBox(
                    height: 14.0,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        String nombre = nombreController.text;
                        String apellido = apellidoController.text;
                        String matricula = matriculaController.text;

                        try {
                          if (nombre.isEmpty ||
                              apellido.isEmpty ||
                              matricula.isEmpty) {
                            throw
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Todos los campos son requeridos'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          }

                          String foto = _imagePath ?? '';

                          // Insertar en la base de datos
                          // await dbHelper.insertUsuario({
                          //   'nombre': nombre,
                          //   'apellido': apellido,
                          //   'matricula': matricula,
                          //   'foto': foto,
                          // });

                          print('Data guardada satisfactoriamente');

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(),
                            ),
                          );
                        } catch (e) {
                          print('Error saving data: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Error al guardar los datos. Por favor, inténtalo de nuevo.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text('Registrar'),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
                Padding(padding: EdgeInsets.all(8.0)),
                _image != null
                    ? GestureDetector(
                        child: Text("Eliminar Foto"),
                        onTap: () {
                          setState(() {
                            _image = null;
                            _imagePath = null; // Limpiar la ruta de la foto
                          });
                          Navigator.of(context).pop(null);
                        },
                      )
                    : SizedBox(),
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
