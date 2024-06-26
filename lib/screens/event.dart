import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:election_day/db/database.dart';
import 'package:election_day/helpers/datetime.dart';

class MyHomePage extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<MyHomePage> {
  String date = getCurrentDate();
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  File? _image;
  String? _imagePath;
  String? _audioPath;
  bool _isRecording = false;

  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microfone permission not granted';
    }

    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future<void> record() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio');
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> stop() async {
    if (!isRecorderReady) return;

    final path = await recorder.stopRecorder();
    print(path);
    setState(() {
      _isRecording = false;
      _audioPath = path;

    });
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        _imagePath = pickedImage.path; // Guardar la ruta del archivo
      }
    });
  }

  Future<void> _saveEvent() async {
    String titulo = tituloController.text;
    String descripcion = descripcionController.text;
    String foto = _imagePath ?? ''; // Validación para la imagen
    String audio = _audioPath ?? ''; // Validación para el audio

    try {
      if (titulo.isEmpty ||
          descripcion.isEmpty ||
          foto.isEmpty ||
          audio.isEmpty) {
        // Mostrar un SnackBar con un mensaje de error si algún campo está vacío
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Todos los campos son requeridos'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // Guardar el evento en la base de datos
        await DatabaseHelper().insertEvento({
          'fecha': date,
          'titulo': titulo,
          'descripcion': descripcion,
          'foto': foto,
          'audio': audio,
        });

        print('Data guardada satisfactoriamente');

        // Limpiar los campos del formulario después de guardar los datos
        tituloController.clear();
        descripcionController.clear();
        _image = null;
        _imagePath = null;
        _audioPath = null;

        // Navegar de regreso a la página principal
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error saving data: $e');
      // Mostrar un SnackBar con un mensaje de error en caso de excepción
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error al guardar los datos. Por favor, inténtalo de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Evento'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
              ),
              SizedBox(height: 15.0),
              TextField(
                  controller: descripcionController,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Ingrese una descripción',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction:
                      TextInputAction.done, // Configurar como finalizado
                  onEditingComplete: () => FocusScope.of(context).unfocus()),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _getImage(ImageSource.camera);
                    },
                    child: Icon(Icons.camera_alt),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _getImage(ImageSource.gallery);
                    },
                    child: Icon(Icons.image),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_isRecording) {
                        await stop();
                      } else {
                        await record();
                      }
                    },
                    child: Icon(_isRecording ? Icons.stop : Icons.mic),
                  ),
                ],
              ),
              if (_audioPath != null)
      ElevatedButton(
        onPressed: () {
          _playAudio(_audioPath!);
        },
        child: Icon(Icons.play_arrow),
      ),
              _image != null
                  ? Image.file(
                      _image!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveEvent,
        child: Icon(Icons.save),
      ),
    );
  }

  void _playAudio(String audioPath) async {
  final player = FlutterSoundPlayer();
  await player.startPlayer(
    fromURI: audioPath,
    codec: Codec.pcm16WAV,
  );
}


}
