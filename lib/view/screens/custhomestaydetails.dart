import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lab_asg_2_homestay_raya/models/homestay.dart';
import 'package:lab_asg_2_homestay_raya/models/user.dart';
import 'package:lab_asg_2_homestay_raya/serverconfig.dart';

class CustHomestayDetails extends StatefulWidget {
  final Homestay homestay;
  final User user;
  final User owner;
  const CustHomestayDetails(
      {super.key,
      required this.homestay,
      required this.user,
      required this.owner});

  @override
  State<CustHomestayDetails> createState() => _CustHomestayDetailsState();
}

class _CustHomestayDetailsState extends State<CustHomestayDetails> {
  late double screenHeight, screenWidth, resWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.90;
    }
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(title: const Text("Homestay Details")),
      body: Column(children: [
        const SizedBox(
          height: 15,
        ),
        Text(
          widget.homestay.homestayName.toString(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Card(
            elevation: 8,
            margin: const EdgeInsets.fromLTRB(12, 10, 12, 5),
            child: Column(
              children: [
                SizedBox(
                  height: 220,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        SizedBox(
                            height: screenHeight / 3,
                            width: resWidth,
                            child: CachedNetworkImage(
                              width: resWidth,
                              fit: BoxFit.cover,
                              imageUrl:
                                  "${ServerConfig.SERVER}/homestayraya/assets/images/homestayImages/${widget.homestay.homestayId}.1.png",
                              placeholder: (context, url) =>
                                  const LinearProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )),
                        SizedBox(
                            height: screenHeight / 3,
                            width: resWidth,
                            child: CachedNetworkImage(
                              width: resWidth,
                              fit: BoxFit.cover,
                              imageUrl:
                                  "${ServerConfig.SERVER}/homestayraya/assets/images/homestayImages/${widget.homestay.homestayId}.2.png",
                              placeholder: (context, url) =>
                                  const LinearProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )),
                        SizedBox(
                            height: screenHeight / 3,
                            width: resWidth,
                            child: CachedNetworkImage(
                              width: resWidth,
                              fit: BoxFit.cover,
                              imageUrl:
                                  "${ServerConfig.SERVER}/homestayraya/assets/images/homestayImages/${widget.homestay.homestayId}.3.png",
                              placeholder: (context, url) =>
                                  const LinearProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )),
                      ]),
                ),
              ],
            )),
        const SizedBox(
          height: 20,
        ),
        Text(widget.homestay.homestayDesc.toString(),
            style: const TextStyle(fontSize: 18)),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: screenWidth - 16,
          child: Table(
              border: TableBorder.all(
                  color: Colors.black, style: BorderStyle.none, width: 1),
              columnWidths: const {
                0: FixedColumnWidth(70),
                1: FixedColumnWidth(200),
              },
              children: [
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.price_change_rounded),
                            Text('Price', style: TextStyle(fontSize: 18))
                          ],
                        ),
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("RM ${widget.homestay.homestayPrice}",
                            style: const TextStyle(fontSize: 18))
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.bed_rounded),
                            Text('Rooms', style: TextStyle(fontSize: 18)),
                          ],
                        )
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.homestay.homestayRoom}",
                            style: const TextStyle(fontSize: 18))
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.location_on),
                            Text('Locality', style: TextStyle(fontSize: 18)),
                          ],
                        )
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.homestay.homestayLocality}",
                            style: const TextStyle(fontSize: 18))
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.flag),
                            Text('State', style: TextStyle(fontSize: 18)),
                          ],
                        )
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.homestay.homestayState}",
                            style: const TextStyle(fontSize: 18))
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.person),
                            Text('Owner', style: TextStyle(fontSize: 18)),
                          ],
                        )
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.owner.name}",
                            style: const TextStyle(fontSize: 18))
                      ]),
                ])
              ]),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Card(
              color: Colors.brown[50],
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        iconSize: 32,
                        onPressed: _makePhoneCall,
                        icon: const Icon(Icons.call)),
                    IconButton(
                        iconSize: 32,
                        onPressed: _makeSmS,
                        icon: const Icon(Icons.message_rounded)),
                    IconButton(
                        iconSize: 32,
                        onPressed: openwhatsapp,
                        icon: const Icon(Icons.whatsapp_rounded)),
                    IconButton(
                        iconSize: 32,
                        onPressed: _onRoute,
                        icon: const Icon(Icons.map_rounded)),
                    IconButton(
                        iconSize: 32,
                        onPressed: _onShowMap,
                        icon: const Icon(Icons.location_on))
                  ],
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }

  Future<void> _makePhoneCall() async {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please login or register an account",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    } else {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: widget.owner.phone,
      );
      await launchUrl(launchUri);
    }
  }

  Future<void> _makeSmS() async {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please login or register an account",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    } else {
      final Uri launchUri = Uri(
        scheme: 'sms',
        path: widget.owner.phone,
      );
      await launchUrl(launchUri);
    }
  }

  openwhatsapp() async {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please login or register an account",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    } else {
      var whatsapp = widget.owner.phone;
      var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=hello";
      var whatappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
      if (Platform.isIOS) {
        // for iOS phone only
        // ignore: deprecated_member_use
        if (await canLaunch(whatappURLIos)) {
          // ignore: deprecated_member_use
          await launch(whatappURLIos, forceSafariVC: false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("whatsapp not installed")));
        }
      } else {
        // android , web
        // ignore: deprecated_member_use
        if (await canLaunch(whatsappURlAndroid)) {
          // ignore: deprecated_member_use
          await launch(whatsappURlAndroid);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Whatsapp is not installed.")));
        }
      }
    }
  }

  Future<void> _onRoute() async {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please login or register an account",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    } else {
      final Uri launchUri = Uri(
          scheme: 'https',
          // ignore: prefer_interpolation_to_compose_strings
          path: "www.google.com/maps/@" +
              widget.homestay.homestayLat.toString() +
              "," +
              widget.homestay.homestayLng.toString() +
              "20z");
      await launchUrl(launchUri);
    }
  }

  int generateIds() {
    var rng = Random();
    int randomInt;
    randomInt = rng.nextInt(100);
    return randomInt;
  }

  void _onShowMap() {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please login or register an account",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    } else {
      double lat = double.parse(widget.homestay.homestayLat.toString());
      double lng = double.parse(widget.homestay.homestayLng.toString());
      Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
      int markerIdVal = generateIds();
      MarkerId markerId = MarkerId(markerIdVal.toString());
      final Marker marker = Marker(
        markerId: markerId,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: LatLng(
          lat,
          lng,
        ),
      );
      markers[markerId] = marker;

      CameraPosition campos = CameraPosition(
        target: LatLng(lat, lng),
        zoom: 16.4746,
      );
      Completer<GoogleMapController> ncontroller =
          Completer<GoogleMapController>();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: const Text(
              "Location",
            ),
            content: Container(
              height: screenHeight,
              width: screenWidth,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: campos,
                markers: Set<Marker>.of(markers.values),
                onMapCreated: (GoogleMapController controller) {
                  ncontroller.complete(controller);
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(),
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
  }
}
