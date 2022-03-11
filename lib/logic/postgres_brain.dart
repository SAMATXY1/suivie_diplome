import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class PostgresConnection {
  static PostgreSQLConnection getDBconnection (){
    return PostgreSQLConnection("10.0.2.2", 5432, "DiplomeDB",
        username: "postgres", password: "2002");
  }

  Future<void> setData(PostgreSQLConnection connection, String table,
      Map<String, dynamic> data) async {
    await connection.execute(
        'INSERT INTO $table (${data.keys.join(', ')}) VALUES (${data.keys.map((k) => '@$k').join(', ')})',
        substitutionValues: data);
  }
}
