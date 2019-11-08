import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munchkin/models/dados_mocados.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munchkin/models/room.dart';
import 'package:munchkin/services/data_base.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  String textFieldValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contador de Munchkin'),),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: () {
        // return Navigator.pushNamed(context, '/pcRoom');
        _joinRoom();
      },),
      body: _buildScreen(),
    );
  }

  void _joinRoom()
  {
    final _nameController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)
      {
        return AlertDialog(
          // backgroundColor: Color(0xff352440),
          title: Text('Dê um nome para sua sala'),
          content: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Digite o nome da sala'),
            controller: _nameController,
            autofocus: true,
            validator: (text)
            {
              return text.isEmpty ? "Insira o nome" : null;
            }
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancelar"),
              onPressed: ()
              {
                Navigator.of(context).pop();
              }
            ),
            FlatButton(
              child: Text("Confirmar"),
              onPressed: ()
              {
                if(_nameController.text != ''){
                  DataBase.createRoom(new Room( name: _nameController.text, password: "senha")); 
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      }

    );
  }

  Widget _buildScreen(){
    
    return Column(children: <Widget>[
      Expanded(flex: 0, 
        child: Padding(
          padding: EdgeInsets.only(right: 25, left:25, top: 15, bottom: 30),
          child: TextField(
            onChanged: (text) {
                print(text);
                setState(() {
                 text; 
                });
                return textFieldValue = text;
              },
            decoration: InputDecoration(
              labelText: 'Buscar sala',
              suffixIcon: Icon(Icons.search)   
            ),
          ),
        )
      ),
      Expanded(flex: 1, child: _getAllRooms(textFieldValue),),    
    ],);
  }

  StreamBuilder<QuerySnapshot> _getAllRooms(String text){
    return StreamBuilder<QuerySnapshot>(
      stream: DataBase.getAllRooms(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError){
          return new Text('Error: ${snapshot.error}');
        }
        else if(snapshot.connectionState == ConnectionState.waiting){
          return  CircularProgressIndicator();
        }
        else{
          return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {

                final room = Room.fromMap(document.data);
                if (!room.name.toUpperCase().contains(text.toUpperCase())) // Caso o nome da sala não contenha o testo, retornar vazio (TEMPORÁRIO ATÉ APLICAR CONSULTA COM LIKE)
                  return Container();

                  //Exemplo de construção de card com nome e senha para cada sala
                 return _buildRoomList(document['name'], context);
              }).toList(),
            );
        }
      },
    );
  }

  Widget _buildRoomList(name, BuildContext context)
  {
      return  InkWell(
        onTap: (){}, 
        child: new Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 25, left:25, top: 30, bottom: 30),
            child: Icon(Icons.group),
          ),
          Text(name, style: Theme.of(context).textTheme.subtitle),
        ],
      ),);
  }
}