import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//nome da tabela
const String contactTable = 'contactTable';
//nome das colunas da tabela do banco
const String idColumn = 'idColumn';
const String nameColumn = 'nameColumn';
const String emailColumn = 'emailColumn';
const String phoneColumn = 'phoneColumn';
const String imgColumn = 'imgColumn';

//singleton - ou seja, só possui um objeto instanciado
class ContactHelper {
  //cria um objeto da própria classe    // chama o construtor interno
  static final ContactHelper _instance = ContactHelper.internal();
  //esse construtor só pode ser chamado de dentro da classe
  ContactHelper.internal();
  //retorna a única instância do objeto
  factory ContactHelper() => _instance;

  Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      //se for diferente de null, retorna o db, senão inicializa ele
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    //pega o local onde o banco de dados é armazenado
    final databasesPath = await getDatabasesPath();
    //pega o arquivo que vai estar armazenado o banco
    //pega o caminho da pasta e junta com o nome do banco, e retorna o caminho disso
    final path = join(databasesPath, "contactsnew.db");
    //abrir banco de dados  //onCreate - função responsavel por criar o banco  tabelas na primeira vez que for aberto
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          'CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)');
    });
  }

  Future<Contact> savedContact(Contact contact) async {
    //pega o banco
    Database? dbContact = await db;
    //salva na tabela //transforma o objeto em mapa para poder salvar
    contact.id = await dbContact?.insert(contactTable, contact.toMap()); //retorna o id da row criada
    return contact;
  }

  Future<Contact?> getContact(int id) async {
    Database? dbContact = await db;
    //fazendo um select
    List<Map> maps = await dbContact!.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: '$idColumn = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      //pega o contato atraves de um mapa // retorna o primeiro mapa, pois so vai ter um elemento
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database? dbContact = await db;
    //deleta e retorna o numero de linhas apagadas
    return await dbContact!.delete(
      contactTable,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateContact(Contact contact) async {
    Database? dbContact = await db;
    //atualiza e retorna o numero de linhas atualizadas
    return await dbContact!.update(
      contactTable,
      contact.toMap(),
      where: '$idColumn = ?',
      whereArgs: [contact.id],
    );
  }

  Future<List<Contact>> getAllContacts() async{
    Database? dbContact = await db;
    List listMap = await dbContact!.rawQuery('SELECT * FROM $contactTable');
    //cria lista de contatos vazia
    List<Contact> listContact = [];
    //para cada Map na listMap, tranforma em um contato e adiciona na listContact
    for(Map m in listMap){
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  Future<int?> getNumber() async {
    Database? dbContact = await db;
    //retornando a quantidade de elementos da tabela
    return Sqflite.firstIntValue(await dbContact!.rawQuery('SELECT COUNT(*) FROM $contactTable'));
  }

  Future<void> close()async {
    Database? dbContact = await db;
    dbContact!.close();

  }

}

class Contact {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? img;
  
  Contact();

  //pega os dados do contato e transforma em mapa
  Map<String, dynamic> toMap() {
    //string tem o nome e dynamic tem o dado
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img,
    };
    //não criaremos o contato com id, quem dará o id será o banco de dados
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  //pega o mapa e transforma em contato
  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  //printar todas as informações do contato
  @override
  String toString() {
    return 'Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)';
  }
}
