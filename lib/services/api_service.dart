import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/contact.dart';

class ApiService {
  final String apiUrl =
      'https://gvff6njg6kts-mock.migratech.cloud/api/contacts';

  Future<void> sendContact(Contact contact) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(contact.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao enviar contato!');
    }
  }
}
