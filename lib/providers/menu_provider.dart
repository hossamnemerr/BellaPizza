// Dynamic menu widget that streams menu items from Firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Stateless widget for live menu updates
class DynamicMenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('menu_items').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('حدث خطأ في جلب البيانات');
        if (snapshot.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();

        final menuDocs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: menuDocs.length,
          itemBuilder: (context, index) {
            var item = menuDocs[index];
            return ListTile(
              title: Text(item['name']),
              subtitle: Text("${item['price']} EGP"),
              leading: Icon(Icons.fastfood),
            );
          },
        );
      },
     );
  }
}
