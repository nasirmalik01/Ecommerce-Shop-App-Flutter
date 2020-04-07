import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatefulWidget {
  // final String title;
  // final double price;
  static const routeName = '/product-detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {

  int i = 0;
  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    print(productId);
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).items.firstWhere((prod) {
      return prod.id == productId;
    });
    return Scaffold(
//      appBar: AppBar(
//        title: Text(loadedProduct.title),
//      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            // title: Text(loadedProduct.title,),
            expandedHeight: MediaQuery.of(context).size.height * 0.6,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                loadedProduct.title),
              background: Container(
                height: 300,
                width: double.infinity,
                child: Hero(
                  tag: loadedProduct.id,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(height: 10),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
                SizedBox(height: 1000,)
          ])),

        ],
//        child: Column(
//          children: <Widget>[
//            Container(
//              height: 300,
//              width: double.infinity,
//              child: Hero(
//                tag: loadedProduct.id,
//                child: Image.network(
//                  loadedProduct.imageUrl,
//                  fit: BoxFit.cover,
//                ),
//              ),
//            ),
//            SizedBox(height: 10),
//            Text(
//              '\$${loadedProduct.price}',
//              style: TextStyle(
//                color: Colors.grey,
//                fontSize: 20,
//              ),
//            ),
//            SizedBox(
//              height: 10,
//            ),
//            Container(
//              padding: EdgeInsets.symmetric(horizontal: 10),
//              width: double.infinity,
//              child: Text(
//                loadedProduct.description,
//                textAlign: TextAlign.center,
//                softWrap: true,
//              ),
//            )
//          ],
//        ),

      ),
    );
  }
}
