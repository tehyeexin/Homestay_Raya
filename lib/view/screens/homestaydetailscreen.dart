import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lab_asg_2_homestay_raya/serverconfig.dart';
import 'package:lab_asg_2_homestay_raya/models/homestay.dart';
import 'package:lab_asg_2_homestay_raya/models/user.dart';

class HomestayDetailsScreen extends StatefulWidget {
  final Homestay homestay;
  final User user;
  const HomestayDetailsScreen({
    Key? key,
    required this.homestay,
    required this.user,
  }) : super(key: key);

  @override
  State<HomestayDetailsScreen> createState() => _HomestayDetailsScreenState();
}

class _HomestayDetailsScreenState extends State<HomestayDetailsScreen> {
  final TextEditingController _hsnameEditingController =
      TextEditingController();
  final TextEditingController _hsdescEditingController =
      TextEditingController();
  final TextEditingController _hspriceEditingController =
      TextEditingController();
  final TextEditingController _hsroomEditingController =
      TextEditingController();
  final TextEditingController _hsstateEditingController =
      TextEditingController();
  final TextEditingController _hslocalEditingController =
      TextEditingController();
  final TextEditingController _hscontactEditingController =
      TextEditingController();

  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();

  final _formKey = GlobalKey<FormState>();

  List<File> hsImageList = <File>[];

  var imgNo = 1;
  File? _image;
  var pathAsset = "assets/images/camera_icon.png";

  late double screenHeight, screenWidth, cardWidth;

  @override
  void initState() {
    super.initState();
    _hsnameEditingController.text = widget.homestay.homestayName.toString();
    _hsdescEditingController.text = widget.homestay.homestayDesc.toString();
    _hspriceEditingController.text = widget.homestay.homestayPrice.toString();
    _hsroomEditingController.text = widget.homestay.homestayRoom.toString();
    _hsstateEditingController.text = widget.homestay.homestayState.toString();
    _hslocalEditingController.text =
        widget.homestay.homestayLocality.toString();
    _hscontactEditingController.text =
        widget.homestay.homestayContact.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      cardWidth = screenWidth;
    } else {
      cardWidth = 400.00;
    }
    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(title: const Text("Edit Homestay")),
        body: SingleChildScrollView(
          child: SizedBox(
            width: cardWidth,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  margin: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: 150,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              SizedBox(
                                  width: 150,
                                  child: GestureDetector(
                                    onTap: _showImageUnableDialog,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      child: CachedNetworkImage(
                                        width: 110,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            "${ServerConfig.SERVER}/homestayraya/assets/images/homestayImages/${widget.homestay.homestayId}.1.png",
                                        placeholder: (context, url) =>
                                            const LinearProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                  width: 150,
                                  child: GestureDetector(
                                    onTap: _showImageUnableDialog,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      child: CachedNetworkImage(
                                        width: 110,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            "${ServerConfig.SERVER}/homestayraya/assets/images/homestayImages/${widget.homestay.homestayId}.2.png",
                                        placeholder: (context, url) =>
                                            const LinearProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                  width: 150,
                                  child: GestureDetector(
                                    onTap: _showImageUnableDialog,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      child: CachedNetworkImage(
                                        width: 110,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            "${ServerConfig.SERVER}/homestayraya/assets/images/homestayImages/${widget.homestay.homestayId}.3.png",
                                        placeholder: (context, url) =>
                                            const LinearProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter a name";
                              }
                              if (val.length < 3) {
                                return "Name must be at least 3 letters long";
                              }
                              return null;
                            },
                            focusNode: focus,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus1);
                            },
                            controller: _hsnameEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Homestay Name',
                                icon: Icon(Icons.home),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter a description";
                              }
                              if (val.length < 10) {
                                return "Description must be at least 10 letters long";
                              }
                              return null;
                            },
                            focusNode: focus1,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus2);
                            },
                            controller: _hsdescEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Describe your homestay',
                                icon: Icon(Icons.description_rounded),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        Row(
                          children: [
                            Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    validator: (val) => val!.isEmpty
                                        ? "Please enter the price of the homestay"
                                        : null,
                                    focusNode: focus2,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus3);
                                    },
                                    controller: _hspriceEditingController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Price',
                                        icon: Icon(Icons.price_change_rounded),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        )))),
                            Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    validator: (val) => val!.isEmpty
                                        ? "Please enter the quantity of rooms"
                                        : null,
                                    focusNode: focus3,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus4);
                                    },
                                    controller: _hsroomEditingController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Rooms',
                                        icon: Icon(Icons.bed_rounded),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ))))
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    validator: (val) =>
                                        val!.isEmpty || (val.length < 3)
                                            ? "Current State"
                                            : null,
                                    enabled: false,
                                    controller: _hsstateEditingController,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        labelText: 'Current States',
                                        labelStyle: TextStyle(),
                                        icon: Icon(Icons.flag),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        )))),
                            Flexible(
                              flex: 5,
                              child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  enabled: false,
                                  validator: (val) =>
                                      val!.isEmpty || (val.length < 3)
                                          ? "Current Locality"
                                          : null,
                                  controller: _hslocalEditingController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      labelText: 'Current Locality',
                                      labelStyle: TextStyle(),
                                      icon: Icon(Icons.location_on),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                      ))),
                            )
                          ],
                        ),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) =>
                                val!.isEmpty || (val.length < 10)
                                    ? "Please enter a valid contact number"
                                    : null,
                            focusNode: focus4,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus5);
                            },
                            controller: _hscontactEditingController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Contact Number',
                                icon: Icon(Icons.phone),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        const SizedBox(height: 20),
                        MaterialButton(
                          color: Colors.brown,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          minWidth: 110,
                          height: 40,
                          elevation: 8,
                          onPressed: () => {_updateHomestayDialog()},
                          child: const Text('Update',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ));
  }

  void _showImageUnableDialog() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Homestay pictures are not allowed to be changed")));
  }

  _updateHomestayDialog() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the form first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Update homestay details?",
          ),
          content: const Text("Are you sure to update?"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _updateHomestay();
              },
            ),
            TextButton(
              child: const Text(
                "No",
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateHomestay() {
    String hsname = _hsnameEditingController.text;
    String hsdesc = _hsdescEditingController.text;
    String hsprice = _hspriceEditingController.text;
    String hsroom = _hsroomEditingController.text;
    String hscontact = _hscontactEditingController.text;

    http.post(
        Uri.parse(
            "${ServerConfig.SERVER}/homestayraya/php/update_homestay.php"),
        body: {
          "hsid": widget.homestay.homestayId,
          "userid": widget.user.id,
          "hsname": hsname,
          "hsdesc": hsdesc,
          "hsprice": hsprice,
          "hsroom": hsroom,
          "hscontact": hscontact,
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == "success") {
        Fluttertoast.showToast(
            msg: "Homestay Updated Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Navigator.of(context).pop();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Homestay Updated Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        return;
      }
    });
  }
}
