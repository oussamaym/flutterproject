import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project_ecom/models/product.dart';
import 'package:flutter_project_ecom/models/utilisateur.dart';
import 'package:flutter_project_ecom/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Utilisateur utilisateur = Utilisateur(nom: '', prenom: '', email: '', password: '');
  Set<Product> products = {};

  Future<void> getUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userData =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        setState(() {
          utilisateur = Utilisateur.fromMap(userData.data() as Map<String, dynamic>);
        });

        print('Authenticated User: ${utilisateur.nom}, Email: ${utilisateur.email}');
      } else {
        print('No authenticated user');
      }
    } catch (e) {
      print('Error retrieving user data: $e');
    }
  }

  Future<void> getProductData() async {
    try {
      if (products.isEmpty) {
        QuerySnapshot productSnapshot =
            await FirebaseFirestore.instance.collection('products').get();

        products.clear();
        productSnapshot.docs.forEach((DocumentSnapshot productDoc) {
          Product product = Product.fromMap(productDoc.data() as Map<String, dynamic>);
          setState(() {
            products.add(product);
          });
        });
      }
    } catch (e) {
      print('Error retrieving product data: $e');
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  void initState() {
    getUserData();
    getProductData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: (utilisateur.nom.isEmpty || products.isEmpty)
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${utilisateur.nom[0].toUpperCase()}${utilisateur.nom.substring(1)} ${utilisateur.prenom[0].toUpperCase()}${utilisateur.prenom.substring(1)}',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage('assets/images/user.png'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "Nos Produits",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: products.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var product = products.elementAt(index);
                        return Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                product.imageURL,
                                width: 70,
                                height: 70,
                              ),
                              Text(
                                product.libele,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                '\$${product.prix.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  Text(
                                    "5.7",
                                    style: TextStyle(
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          onPressed: logout,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                          ),
                          child: Text('Logout'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
