import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munchkin/models/Player.dart';
import 'package:munchkin/models/room.dart';

class DataBase{

  static Future<bool> _checkRoomExist(String roomId) async{
    try{
      bool exist = false;
      await Firestore.instance.document('rooms/$roomId').get().then((document){
        exist = document.exists;
      });
      return exist;
    }catch(ex){
      return false;
    }
  }
  
  static Future<String> createRoom(Room room) async{
    
    // Verificando se já existe uma sala com o mesmo nome (id)
    _checkRoomExist(room.name).then((value){
      if(!value){
        Firestore.instance.document("rooms/${room.name}").setData(room.toMap());
        return null;
      }else{
        return "Ops! Já existe uma sala chamada ${room.name}";
      }
    });
  }

  static Stream<QuerySnapshot> getAllRooms(){
    return Firestore.instance.collection('rooms').snapshots();
  }

  static Future<bool> _checkPlayerExist(String playerId) async{
    try{
      bool exist = false;
      await Firestore.instance.document('players/$playerId').get().then((document){
        exist = document.exists;
      });
      return exist;
    }catch(ex){
      return false;
    }
  }

  static Future<String> createPlayer(Player player) async{
    _checkPlayerExist(player.name).then((value){
      if(!value){
        Firestore.instance.document("players/${player.name}").setData(player.toMap());
        return null;
      }else{
        return "Ops! Já existe um player chamado ${player.name}";
      }
    });
  }

  static Stream<QuerySnapshot> getAllPlayers(){
    return Firestore.instance.collection('players').snapshots();
  }
}