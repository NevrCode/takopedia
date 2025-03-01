import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:takopedia/services/product_service.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  File? _productPic;
  final ImagePicker _picker = ImagePicker();
  final ProductService _productService = ProductService();
  final cleartxt = TextEditingController();

  Future<void> _pickProductPicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _productPic = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  void clearAll() {
    _nameController.clear();
    _priceController.clear();
    _descController.clear();
  }

  Future<void> _addProduct() async {
    final name = _nameController.text;
    final price = int.parse(_priceController.text);
    final desc = _descController.text;
    final type = _typeController.text;
    if (_productPic != null) {
      await _productService.addProduct(
          name, price, desc, _productPic!.path, type, 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'nama',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'price',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'desc',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _typeController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'type',
                  prefixIcon: const Icon(Icons.type_specimen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                ),
              ),
              const SizedBox(height: 16),

              // Foto dalam bentuk lingkaran
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    _productPic != null ? FileImage(_productPic!) : null,
                child: _productPic == null
                    ? const Icon(Icons.picture_in_picture, size: 50)
                    : null, // Tampilkan icon person jika belum ada foto
              ),
              const SizedBox(height: 16),

              // Hanya menampilkan nama file
              if (_productPic != null)
                Text(
                  'Nama file: ${_nameController.text.split(" ")[0]}.jpg',
                  style: const TextStyle(fontSize: 14),
                ),
              const SizedBox(height: 16),

              // Tombol Upload Foto
              ElevatedButton(
                onPressed: _pickProductPicture,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text('Upload Foto'),
              ),
              const SizedBox(height: 16),

              // Tombol Register
              ElevatedButton(
                onPressed: () {
                  _addProduct();
                  clearAll();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text('Submit'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
