import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;
import 'package:lab_asg_2_homestay_raya/models/homestay.dart';
import 'package:lab_asg_2_homestay_raya/serverconfig.dart';
import 'package:lab_asg_2_homestay_raya/view/screens/custhomestaydetails.dart';
import 'package:lab_asg_2_homestay_raya/view/shared/mainmenuwidget.dart';
import 'package:lab_asg_2_homestay_raya/models/user.dart';

class CustomerScreen extends StatefulWidget {
  final User user;
  const CustomerScreen({super.key, required this.user});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Homestay> homestayList = <Homestay>[];
  String titlecenter = "Loading...";
  int rowcount = 2;
  String search = "all";
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  late double screenHeight, screenWidth, cardWidth;
  TextEditingController searchController = TextEditingController();
  var owner;
  var color;
  var numofpage, curpage = 1;
  int numberofresult = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadHomestays("all", 1);
    });
  }

  @override
  void dispose() {
    super.dispose();
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
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.brown[50],
          appBar: AppBar(title: const Text("All Homestays"), actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _loadSearchDialog();
              },
            ),
          ]),
          body: homestayList.isEmpty
              ? Center(
                  child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.all(8)),
                    Text(titlecenter,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 83, 67, 61),
                        )),
                  ],
                ))
              : Column(
                  children: [
                    const Padding(padding: EdgeInsets.all(4)),
                    const Text("Find your next stay!",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.brown)),
                    const SizedBox(height: 8),
                    Text(
                      "Homestays ($numberofresult found)",
                      style: const TextStyle(fontSize: 14, color: Colors.brown),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                        child: GridView.count(
                      crossAxisCount: rowcount,
                      padding: const EdgeInsets.all(5),
                      children: List.generate(
                        homestayList.length,
                        (index) {
                          return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 8,
                              margin: const EdgeInsets.all(10),
                              child: InkWell(
                                onTap: () {
                                  _showHomestayDetails(index);
                                },
                                child: Column(children: [
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Flexible(
                                    flex: 6,
                                    child: CachedNetworkImage(
                                      width: 110,
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          "${ServerConfig.SERVER}/homestayraya/assets/images/homestayImages/${homestayList[index].homestayId}.1.png",
                                      placeholder: (context, url) =>
                                          const LinearProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              truncateString(
                                                  homestayList[index]
                                                      .homestayName
                                                      .toString(),
                                                  15),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                "RM ${double.parse(homestayList[index].homestayPrice.toString()).toStringAsFixed(2)}"),
                                            Text(
                                                "${homestayList[index].homestayRoom} Rooms"),
                                          ],
                                        ),
                                      ))
                                ]),
                              ));
                        },
                      ),
                    )),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: numofpage,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if ((curpage - 1) == index) {
                            color = Colors.brown;
                          } else {
                            color = Colors.grey;
                          }
                          return TextButton(
                              onPressed: () =>
                                  {_loadHomestays(search, index + 1)},
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(color: color, fontSize: 15),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
          drawer: MainMenuWidget(user: widget.user),
        ));
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }

  void _loadHomestays(String search, int pageno) {
    curpage = pageno;
    numofpage ?? 1;

    http
        .get(
      Uri.parse(
          "${ServerConfig.SERVER}/homestayraya/php/load_allhomestay.php?search=$search&pageno=$pageno"),
    )
        .then((response) {
      ProgressDialog progressDialog = ProgressDialog(
        context,
        blur: 5,
        message: const Text("Loading..."),
        title: null,
      );
      progressDialog.show();
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];

          if (extractdata['homestay'] != null) {
            numofpage = int.parse(jsondata['numofpage']);
            numberofresult = int.parse(jsondata['numberofresult']);
            homestayList = <Homestay>[];
            extractdata['homestay'].forEach((v) {
              homestayList.add(Homestay.fromJson(v));
            });
            titlecenter = "Found";
          } else {
            titlecenter = "No Homestay Available";
            homestayList.clear();
          }
        }
      } else {
        titlecenter = "No Homestay Available";
        homestayList.clear();
      }

      setState(() {});
      progressDialog.dismiss();
    });
  }

  void _loadSearchDialog() {
    searchController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: const Text(
                  "Looking for homestay?",
                ),
                content: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Search here',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(18.0)))),
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadHomestays(search, 1);
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }

  _showHomestayDetails(int index) async {
    Homestay homestay = Homestay.fromJson(homestayList[index].toJson());
    loadSingleOwner(index);
    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 5,
      message: const Text("Loading..."),
      title: null,
    );
    progressDialog.show();
    Timer(const Duration(seconds: 1), () {
      if (owner != null) {
        progressDialog.dismiss();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => CustHomestayDetails(
                      homestay: homestay,
                      user: widget.user,
                      owner: owner,
                    )));
      }
      progressDialog.dismiss();
    });
  }

  loadSingleOwner(int index) {
    http.post(
        Uri.parse("${ServerConfig.SERVER}/homestayraya/php/load_owner.php"),
        body: {"ownerid": homestayList[index].userId}).then((response) {
      print(response.body);
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == "success") {
        owner = User.fromJson(jsonResponse['data']);
      }
    });
  }
}
