import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:midtermstiw2044myshop/newproduct.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Material', home: MainScreen());
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  double screenHeight, screenWidth;
  List productImagList;
  String _titlecenter = "Click + to add new product";

  @override
  void initState() {
    super.initState();
    _loadNewProduct();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('My Shop'),
        ),
        body: Center(
          child: Container(
              child: Column(
            children: [
              productImagList == null
                  ? Flexible(child: Center(child: Text(_titlecenter)))
                  : Flexible(
                      child: Center(
                          child: GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio:
                                  (screenWidth / screenHeight) / 1.0,
                              children: List.generate(productImagList.length,
                                  (index) {
                                return Padding(
                                  padding: EdgeInsets.all(7),
                                  child: Card(
                                      elevation: 10,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: screenHeight / 4.5,
                                            width: screenWidth / 1.2,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "http://javathree99.com/s269926/myshop/images/product/${productImagList[index]['prid']}.png",
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              child: Text(
                                                  "ID: " +
                                                      productImagList[index]
                                                          ['prid'],
                                                  style:
                                                      TextStyle(fontSize: 15))),
                                          SizedBox(height: 5),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              child: Text(
                                                  "Name: " +
                                                      productImagList[index]
                                                          ['prname'],
                                                  style:
                                                      TextStyle(fontSize: 15))),
                                          SizedBox(height: 5),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              child: Text(
                                                  "Type: " +
                                                      productImagList[index]
                                                          ['prtype'],
                                                  style:
                                                      TextStyle(fontSize: 15))),
                                          SizedBox(height: 5),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              child: Text(
                                                  "Price:RM " +
                                                      productImagList[index]
                                                          ['prprice'],
                                                  style:
                                                      TextStyle(fontSize: 15))),
                                          SizedBox(height: 5),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              child: Text(
                                                  "Quantity: " +
                                                      productImagList[index]
                                                          ['prqty'],
                                                  style:
                                                      TextStyle(fontSize: 15))),
                                        ],
                                      )),
                                );
                              })))),
            ],
          )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: addNew,
        ));
  }

  void _loadNewProduct() {
    http.post(
        Uri.parse("http://javathree99.com/s269926/myshop/php/load_product.php"),
        body: {}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        _titlecenter = "Sorry no product";
        return;
      } else {
        var jsondata = json.decode(response.body);
        productImagList = jsondata["products"];
        setState(() {});
        print(productImagList);
      }
    });
  }

  void addNew() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => NewProduct()));
  }

}
