import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

void _deleteItem(String id) async {
  await FirebaseFirestore.instance.collection('menu').doc(id).delete();
}

class _AdminPageState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPopular = false;

  void _addMenuItem() async {
    if (_formKey.currentState!.validate()) {
      final item = MenuItem(
        id: '',
        name: _nameController.text,
        category: _categoryController.text,
        imageUrl: _imageUrlController.text,
        price: double.parse(_priceController.text),
        isPopular: _isPopular,
        description: _descriptionController.text,
      );

      await FirebaseFirestore.instance.collection('menu').add(item.toMap());
      _clearForm();
    }
  }

  void _editItem(MenuItem item) {
    _nameController.text = item.name;
    _categoryController.text = item.category;
    _imageUrlController.text = item.imageUrl;
    _priceController.text = item.price.toString();
    _descriptionController.text = item.description;
    setState(() => _isPopular = item.isPopular);
  }

  void _clearForm() {
    _nameController.clear();
    _categoryController.clear();
    _imageUrlController.clear();
    _priceController.clear();
    _descriptionController.clear();
    setState(() => _isPopular = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Menu Management'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAddItemForm(),
            _buildMenuList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddItemForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Add form fields here
            // ...existing code...
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('menu').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text('Error loading menu');
        if (!snapshot.hasData) return const CircularProgressIndicator();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final item =
                MenuItem.fromMap(doc.id, doc.data() as Map<String, dynamic>);

            return ListTile(
              title: Text(item.name),
              subtitle: Text('${item.category} - \$${item.price}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editItem(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteItem(item.id),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
