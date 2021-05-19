import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:midtermstiw2044myshop/main.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

class NewProduct extends StatefulWidget {
  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  ProgressDialog pr;
  double screenHeight, screenWidth;
  String pathAsset = 'assets/images/camera.PNG';
  File _image;
  bool _visible = true;
  TextEditingController _prname = new TextEditingController();
  TextEditingController _prtype = new TextEditingController();
  TextEditingController _prprice = new TextEditingController();
  TextEditingController _prqty = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: Visibility(
          visible: _visible,
          child: FloatingActionButton.extended(
            label: Text('New'),
            onPressed: () {
              _addNewProduct();
            },
            icon: Icon(Icons.add),
            backgroundColor: Colors.blue,
          )),
      body: Center(
        child: Container(
          child: Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Text("Add New Product",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => {_onPictureSelectionDialog()},
                    child: Container(
                        height: screenHeight / 3.5,
                        width: screenWidth / 1,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _image == null
                                ? AssetImage(pathAsset)
                                : FileImage(_image),
                            fit: BoxFit.scaleDown,
                          ),
                          border: Border.all(
                            width: 3.0,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) 
                              ),
                        )),
                  ),
                  SizedBox(height: 5),
                  Text(
                      "Click image to take your picture either camera or gallery",
                      style: TextStyle(fontSize: 10.0, color: Colors.black)),
                  SizedBox(height: 5),
                  
                  TextField(
                    controller: _prname,
                    decoration: InputDecoration(labelText: 'Product Name'),
                  ),
                  TextField(
                    controller: _prtype,
                    decoration: InputDecoration(labelText: 'Product Type'),
                  ),
                  TextField(
                    controller: _prprice,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      prefixText: "RM ",
                    ),
                  ),
                  TextField(
                    controller: _prqty,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Quantity'),
                  ),
                ],
              ))),
        ),
      ),
    );
  }

  void _addNewProduct() {
     if (_image == null || _prname.text.toString() == "" || _prtype.text.toString() == ""
    || _prprice.text.toString() == "" || _prqty.text.toString() == "") {
      Fluttertoast.showToast(
          msg: "Don't empty!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Add the new product??"),
            content: Text("Are your sure to add?"),
            actions: [
              TextButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _postnewProduct();
                },
              ),
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  _onPictureSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: new Container(
              height: screenHeight / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Take picture from:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Camera',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        //color: Color.fromRGBO(101, 255, 218, 50),
                        color: Theme.of(context).accentColor,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseCamera()},
                      )),
                      SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Gallery',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        //color: Color.fromRGBO(101, 255, 218, 50),
                        color: Theme.of(context).accentColor,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseGallery()},
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  Future _chooseCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    _cropImage();
  }

  _chooseGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    _cropImage();
  }

  _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  Future<void> _postnewProduct() async {
    pr = ProgressDialog(context);
    pr.style(
      message: 'Posting...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    await pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());
    String prname = _prname.text.toString();
    String prtype = _prtype.text.toString();
    String prprice = _prprice.text.toString();
    String prqty = _prqty.text.toString();
    print(prname);
    print(prtype);
    print(prprice);
    print(prqty);
    http.post(
        Uri.parse(
            "http://javathree99.com/s269926/myshop/php/newproduct.php"),
        body: {
          "prname": prname,
          "prtype": prtype,
          "prprice": prprice,
          "prqty": prqty,
          "encoded_string": base64Image
          }).then((response) {
      pr.hide().then((isHidden) {
        print(isHidden);
      });
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepOrange,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          _image = null;
          _prname.text = "";
          _prtype.text = "";
          _prprice.text = "";
          _prqty.text = "";
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => MainScreen()));
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepOrange,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}
