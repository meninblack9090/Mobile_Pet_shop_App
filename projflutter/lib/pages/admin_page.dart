import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:projflutter/data/app_data.dart';


// A dedicated StatefulWidget for the product dialog.
class _ProductDialog extends StatefulWidget {
  final Product? product;
  final int? index;

  const _ProductDialog({this.product, this.index});

  @override
  State<_ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<_ProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController priceController;
  late final TextEditingController stockController;
  String? _imagePath;


  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    nameController = TextEditingController(text: p?.name);
    descriptionController = TextEditingController(text: p?.description);
    priceController = TextEditingController(text: p?.price.toString());
    stockController = TextEditingController(text: p?.stock.toString());
    _imagePath = p?.imagePath;
  }

  Future<String?> _saveImage(File imageFile) async {
    try {
      if (!await imageFile.exists()) {
        return null;
      }
      final directory = await getApplicationDocumentsDirectory();
      // Create a unique filename to avoid conflicts
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final originalName = path.basename(imageFile.path);
      final extension = path.extension(originalName);
      final fileName = 'product_$timestamp$extension';
      final newPath = path.join(directory.path, fileName);
      
      // Copy the image file
      final newImage = await imageFile.copy(newPath);
      
      // Verify the file was created
      if (await newImage.exists()) {
        return newImage.path;
      }
      return null;
    } catch (e) {
      // Return null on error - error message will be shown by caller
      return null;
    }
  }

  Future<void> _pickImage() async {
    if (!mounted) return;

    final rootContext = Navigator.of(context, rootNavigator: true).context;
    final scaffoldMessenger = ScaffoldMessenger.of(rootContext);

    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result == null || result.files.single.path == null) {
      return;
    }

    final filePath = result.files.single.path!;
    final savedImagePath = await _saveImage(File(filePath));

    if (!mounted) return;

    if (savedImagePath != null) {
      setState(() {
        _imagePath = savedImagePath;
      });

      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Image uploaded successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to save image. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final newPrice = double.tryParse(priceController.text);
      final newStock = int.tryParse(stockController.text);

      if (newPrice == null || newStock == null) return;

      final product = Product(
        id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        description: descriptionController.text,
        price: newPrice,
        stock: newStock,
        imagePath: _imagePath,
      );

      if (isEditing) {
        appData.updateProduct(widget.index!, product);
      } else {
        appData.addProduct(product);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Product' : 'Add New Product'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: nameController, decoration: const InputDecoration(labelText: 'Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description'), maxLines: null, keyboardType: TextInputType.multiline, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(controller: stockController, decoration: const InputDecoration(labelText: 'Stock'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.upload),
                label: const Text('Upload Image'),
              ),
              if (_imagePath != null) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_imagePath!),
                    height: 100,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(onPressed: _submit, child: Text(isEditing ? 'Save' : 'Add')),
      ],
    );
  }
}



class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();
    // Listen to changes in AppData to rebuild the UI.
    appData.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    // Clean up the listener when the widget is removed.
    appData.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    setState(() {
      // This empty setState call is enough to trigger a rebuild.
    });
  }

  void _editService(BuildContext context, int index) {
    final service = appData.services[index];
    final priceController = TextEditingController(text: service.price.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${service.name} Price'),
        content: TextFormField(
          controller: priceController,
          decoration: const InputDecoration(labelText: 'Price'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final newPrice = double.tryParse(priceController.text);
              if (newPrice != null) {
                appData.updateServicePrice(index, newPrice);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editProduct(BuildContext context, int index) {
    showDialog(context: context, builder: (_) => _ProductDialog(product: appData.products[index], index: index));
  }

  void _addProduct(BuildContext context) {
    showDialog(context: context, builder: (_) => const _ProductDialog());
  }

  void _removeProduct(Product product) {
    // No need for setState here because the listener will handle it.
    appData.removeProduct(product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Manage Services', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          ...List.generate(appData.services.length, (index) {
            final service = appData.services[index];
            return ListTile(
              title: Text(service.name),
              trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () => _editService(context, index)),
            );
          }),
          const SizedBox(height: 24),
          Text('Manage Products', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          ...List.generate(appData.products.length, (index) {
            final product = appData.products[index];
            return ListTile(
              title: Text(product.name),
              subtitle: Text('Stock: ${product.stock}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.edit), onPressed: () => _editProduct(context, index)),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeProduct(product),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () => _addProduct(context), child: const Text('Add Product')),
        ],
      ),
    );
  }
}
