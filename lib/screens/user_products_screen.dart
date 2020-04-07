import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_again/widgets/user_product_items.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-products';


  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  var _isLoading = false;
  var isInit = true;
  Future<void> _refreshProducts(BuildContext context) async {
    try {
      await Provider.of<Products>(context,listen: false).fetchProducts(true);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  Future<void> didChangeDependencies() async {
    if(isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Products>(context).fetchProducts(true);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        throw error;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: _isLoading ? Center(
          child: CircularProgressIndicator(),
        ) : Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, i) =>
                Column(
                  children: [
                    UserProductItem(
                      productsData.items[i].id,
                      productsData.items[i].title,
                      productsData.items[i].imageUrl,
                    ),
                    Divider(),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
