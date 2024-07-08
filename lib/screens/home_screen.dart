import 'package:contactlink/screens/photo_capture_screen.dart';
import 'package:contactlink/theme_manager.dart';
import 'package:contactlink/widgets/contact_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/contact.dart';
import '../services/database_helper.dart';
import '../services/api_service.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _photoPath;
  late CameraController _cameraController;
  List<Contact> _contacts = [];

  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    List<Contact> contacts = await _dbHelper.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  void _navigateToPhotoCapture() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PhotoCaptureScreen()),
    );

    if (result != null) {
      setState(() {
        _photoPath = result;
      });
      _scrollToBottom();
    }
  }

  void _saveContact() async {
    String name = _nameController.text;
    String phone = _phoneController.text;
    String? photo = _photoPath;

    Contact newContact = Contact(name: name, phone: phone, photo: photo);
    // salva no banco de dados
    await _dbHelper.saveContact(newContact);
    // envia para o servidor
    await _apiService.sendContact(newContact);

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contato salvo com sucesso!')));
    _clearScreen();
    _loadContacts(); // Refresh contact list
  }

  void _clearScreen() {
    setState(() {
      _nameController.clear();
      _phoneController.clear();
      _photoPath = null;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _editContact(Contact contact) {
    _nameController.text = contact.name;
    _phoneController.text = contact.phone;
    _photoPath = contact.photo;
  }

  void _deleteContact(int id) async {
    await _dbHelper.deleteContact(id);
    _loadContacts(); // Refresh contact list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return Text('Home - Bem-vindo ${state.username}');
            }
            return const Text('Home');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_rounded),
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: () {
              Provider.of<ThemeManager>(context, listen: false).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(AuthLogoutRequested());
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
              ),
              const SizedBox(height: 20),
              _photoPath != null
                  ? Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Image.file(
                        File(_photoPath!),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(),
              ElevatedButton(
                  onPressed: _navigateToPhotoCapture,
                  child: const Text('Capturar Foto')),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveContact,
                //onPressed: _photoPath != null ? _saveContact : null,
                child: const Text('Salvar Contato'),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  Contact contact = _contacts[index];
                  return ContactItem(
                    contact: contact,
                    onEdit: () => _editContact(contact),
                    onDelete: () => _deleteContact(contact.id!),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
