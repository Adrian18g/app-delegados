import 'package:flutter/material.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController matriculaController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Registra un usuario', style: TextStyle(fontSize: 15.0),),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nombreController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(border: OutlineInputBorder()),
          ),SizedBox(height: 12.0,),TextField(
              controller: apellidoController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(border: OutlineInputBorder()),
          ),SizedBox(height: 12.0,),TextField(
              controller: matriculaController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(border: OutlineInputBorder()),
          )],
        ),
      ),);
  }
}