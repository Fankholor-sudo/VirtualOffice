import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:specno_client/Components/animated_navigation.dart';
import 'package:specno_client/Screens/add_office.dart';
import 'package:specno_client/Screens/edit_office.dart';
import 'package:specno_client/Screens/office_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final url = dotenv.env['LOCAL_URL'];

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool expanded = false;
  int expandedIndex = -1;

  late List<Map<String, dynamic>> officeDataList;

  Future<List<Map<String, dynamic>>> fetchOffice() async {
    final response = await http.get(
      Uri.parse('$url/office'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load office data');
    }
  }

  void getOfficesData() async {
    final data = await fetchOffice();
    
    setState(() {
      officeDataList = data.reversed.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    officeDataList = [];
    getOfficesData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(vertical: 10),
                width: screenWidth * 0.9,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'All Offices',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      fontSize: 28,
                      color: Color(0xFF484954),
                    ),
                  ),
                ),
              ),
            ),
            if (officeDataList.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(15),
                  itemCount: officeDataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final officeColorValue = officeDataList[index]['OfficeColor'];
                    Color officeColor = Color(int.parse(officeColorValue.substring(0,10)));
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          constraints: BoxConstraints(minHeight: 152),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                width: 12,
                                height: (expandedIndex == index && expanded)
                                    ? 322
                                    : 152,
                                duration: Duration(milliseconds: 100),
                                child: Column(
                                  children: [
                                    Flexible(
                                        flex: 3,
                                        child: Container(
                                          color: officeColor,
                                        )),
                                    Flexible(
                                        flex: 3,
                                        child: Container(
                                          color: officeColor.withAlpha(170),
                                        )),
                                    Flexible(
                                        flex: 4,
                                        child: Container(
                                          color: officeColor.withAlpha(85),
                                        ))
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  color: Color(0xFFFFFFFF),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                AnimatedNavigation(
                                                  page: OfficeView(
                                                    imageIndex: index,
                                                    officeData:
                                                        officeDataList[index],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: SizedBox(
                                              width: screenWidth * .65,
                                              child: Text(
                                                '${officeDataList[index]['OfficeName']}',
                                                style: TextStyle(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.w900,
                                                  color: Color(0xFF484954),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                AnimatedNavigation(
                                                  page: EditOffice(
                                                    officeData: officeDataList[index],
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: FaIcon(
                                              FontAwesomeIcons.pencil,
                                              size: 18,
                                              color: Color(0xFF0D4477),
                                            ),
                                            iconSize: 30,
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            AnimatedNavigation(
                                              page: OfficeView(
                                                imageIndex: index,
                                                officeData:
                                                    officeDataList[index],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Row(
                                            children: [
                                              FaIcon(
                                                FontAwesomeIcons.users,
                                                size: 18,
                                                color: Color(0xFF0D4477),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8),
                                                child: Text(
                                                  "See",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF484954),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: screenWidth * .50,
                                                child: Text(
                                                  " Staff Members in Office.",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xFF484954),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              expandedIndex = index;
                                              expanded = !expanded;
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric( horizontal: 8),
                                                child: Text(
                                                  "More info",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xFF484954),
                                                  ),
                                                ),
                                              ),
                                              (expanded &&
                                                      expandedIndex == index)
                                                  ? FaIcon(
                                                      FontAwesomeIcons
                                                          .chevronUp,
                                                      size: 20,
                                                      color: Color(0xFF0D4477),
                                                    )
                                                  : FaIcon(
                                                      FontAwesomeIcons
                                                          .chevronDown,
                                                      size: 20,
                                                      color: Color(0xFF0D4477),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (expandedIndex == index && expanded)
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.phone_outlined,
                                                    color: Color(0xFF0D4477),
                                                    size: 22,
                                                  ),
                                                  Container(
                                                    width: screenWidth * .65,
                                                    margin: EdgeInsets.only(
                                                        left: 8),
                                                    child: Text(
                                                      "${officeDataList[index]['PhoneNumber']}",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xFF484954),
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons.envelope,
                                                    size: 20,
                                                    color: Color(0xFF0D4477),
                                                  ),
                                                  Container(
                                                    width: screenWidth * .65,
                                                    margin: EdgeInsets.only(
                                                        left: 8),
                                                    child: Text(
                                                      " ${officeDataList[index]['Email']}",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xFF484954),
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons.users,
                                                    size: 18,
                                                    color: Color(0xFF0D4477),
                                                  ),
                                                  Container(
                                                    width: screenWidth * .65,
                                                    margin: EdgeInsets.only(
                                                        left: 8),
                                                    child: Text(
                                                      "Office Capacity: ${officeDataList[index]['MaxCapacity']}",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xFF484954),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on_outlined,
                                                    color: Color(0xFF0D4477),
                                                    size: 22,
                                                  ),
                                                  Container(
                                                    width: screenWidth * .65,
                                                    margin: EdgeInsets.only(
                                                        left: 8),
                                                    child: Text(
                                                      "${officeDataList[index]['Address']}",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xFF484954),
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, AnimatedNavigation(page: AddOffice()));
        },
        tooltip: 'Add Office',
        shape: CircleBorder(),
        backgroundColor: Color(0xFF0D4477),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
