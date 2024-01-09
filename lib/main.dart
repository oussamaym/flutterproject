import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_project_ecom/firebase_options.dart';
import 'package:flutter_project_ecom/screens/login_screen.dart';
import 'package:flutter_project_ecom/screens/register_screen.dart';
import 'package:flutter_project_ecom/screens/home_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await addInitialProducts();

  runApp(const MyApp());
}

Future<void> addInitialProducts() async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference productsCollection = firestore.collection('products');

    QuerySnapshot querySnapshot = await productsCollection.get();

    if (querySnapshot.size == 0) {
      List<Map<String, dynamic>> products = [
        {
          'libele': 'TSHIRT 1',
          'prix': 19.99,
          'quantite': 100,
          'imageURL': 'assets/images/shirt1.png',
        },
        {
          'libele': 'TSHIRT 2',
          'prix': 29.99,
          'quantite': 50,
          'imageURL': 'assets/images/shirt2.png',
        },
        {
          'libele': 'TSHIRT 3',
          'prix': 39.99,
          'quantite': 75,
          'imageURL': 'assets/images/shirt3.png',
        },
        {
          'libele': 'TSHIRT 4',
          'prix': 49.99,
          'quantite': 120,
          'imageURL': 'assets/images/shirt4.png',
        },
      ];

      WriteBatch batch = firestore.batch();

      for (var productData in products) {
        DocumentReference documentReference = productsCollection.doc();
        batch.set(documentReference, productData);
      }

      await batch.commit();

      print('Initial products added to Firestore successfully!');
    } else {
      print('Products already exist in the Firestore collection. Skipping addition.');
    }
  } catch (e) {
    print('Error adding initial products: $e');
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(), 
      },
    );
  }
}
