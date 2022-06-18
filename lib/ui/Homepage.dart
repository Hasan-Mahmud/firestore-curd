// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  /*
      await _products.add({"name": name, "price": price});
      await _products.update({"name": name, "price": price});
      await _products.doc(productId).delete();
    */
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _priceController.text = documentSnapshot['price'].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final String name = _nameController.text;
                    final double? price =
                        double.tryParse(_priceController.text);
                    if (price != null) {
                      await _products
                          .doc(documentSnapshot!.id)
                          .update({"name": name, "price": price});
                      _nameController.text = '';
                      _priceController.text = '';
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _priceController.text = documentSnapshot['price'].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final String name = _nameController.text;
                    final double? price =
                        double.tryParse(_priceController.text);
                    if (price != null) {
                      await _products.add({"name": name, "price": price});
                      _nameController.text = '';
                      _priceController.text = '';
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _delete(String productID) async {
    await _products.doc(productID).delete();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: StreamBuilder(
          stream: _products.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return ProductCard(documentSnapshot);
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Card ProductCard(DocumentSnapshot<Object?> documentSnapshot) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(documentSnapshot['name']),
        subtitle: Text(documentSnapshot['price'].toString()),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                onPressed: () => _update(documentSnapshot),
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () => _delete(documentSnapshot.id),
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
