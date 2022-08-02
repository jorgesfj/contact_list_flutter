import 'package:contact_list/models/contact.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

class ContactHelper {
  
  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;
  ContactHelper.internal();
  
  Database? _db;

  //Verificando se o banco e nulo
  Future<Database?> get db async {
    if(_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }
  
  //inicia nosso banco de dados
  Future<Database> initDb() async{
    //busca o caminho do banco
    final databasesPath = await getDatabasesPath();
    //adiciona no caminho o /contacts.db
    final path = join(databasesPath, "contacts.db");

    //abre o banco
    return await openDatabase(path, version:1, onCreate: (Database db, int newerVersion) async {
      //cria tabela
      await db.execute(
        "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)"
      );
    });
  }

  //Salvar contato
  Future<Contact> saveContact(Contact contact) async{
    Database? dbContact = await db;
    contact.id = await dbContact?.insert(contactTable, contact.toMap());
    return contact;
  }

  //buscar 1 contato
  Future<Contact?> getContact(int id) async {
    Database? dbContact = await db;
    List<Map> maps = await dbContact!.query(contactTable, columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
      where: "$idColumn = ?",
      whereArgs: [id]);
    if(maps.isNotEmpty) {
      return Contact.fromMap(maps.first as Map<String, dynamic>);
    }else {
      return null;
    }
  }

  //apagar 1 contato
  Future<int> deleteContact(int id) async{
    Database? dbContact = await db;
    return await dbContact!.delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  //editar contato
  Future<int> updateContact(Contact contact) async{
    Database? dbContact = await db;
    return await dbContact!.update(contactTable, contact.toMap(), where: "$idColumn = ?", whereArgs: [contact.id]);
  }

  //buscar todos os contatos presentes
  Future<List<Contact>> getAllContacts() async{
    Database? dbContact = await db;
    List listMap = await dbContact!.rawQuery("SELECT * FROM $contactTable");
    List<Contact> list = [];

    for(Map m in listMap) {
      list.add(Contact.fromMap(m as Map<String, dynamic>));
    }

    return list;
  }

  //buscar quantidade de contatos salvos
  Future<int?> getNumber() async{
    Database? dbContact = await db;
    return Sqflite.firstIntValue(await dbContact!.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  //fechar banco
  Future close() async {
    Database? dbContact = await db;
    dbContact!.close();
  }
}