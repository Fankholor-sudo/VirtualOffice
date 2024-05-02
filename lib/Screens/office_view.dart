import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:specno_client/Components/animated_navigation.dart';
import 'package:specno_client/Screens/edit_office.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final url = dotenv.env['LOCAL_URL'];

class OfficeView extends StatefulWidget {
  final int imageIndex;
  final Map<String, dynamic> officeData;
  const OfficeView({
    super.key,
    required this.imageIndex,
    required this.officeData,
  });

  @override
  State<OfficeView> createState() => _OfficeViewState();
}

class _OfficeViewState extends State<OfficeView> {
  bool expanded = false;
  String query = '';

  late List<Map<String, dynamic>> memberDataList;
  late List<Map<String, dynamic>> filteredMemberList;

  Future<List<Map<String, dynamic>>> fetchMembers() async {
    final response = await http.get(
      Uri.parse('$url/member/?OfficeID=${widget.officeData['OfficeID']}'),
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

  void getMembersData() async {
    final data = await fetchMembers();
    setState(() {
      memberDataList = data;
      filteredMemberList = data;
    });
  }

  void onQueryChanged(String newQuery) {
    setState(() {
      query = newQuery;
      if (newQuery.isEmpty) {
        filteredMemberList = memberDataList;
      }
      filteredMemberList = memberDataList
          .where((obj) =>
              obj['FirstName'].toLowerCase().contains(newQuery.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    memberDataList = [];
    filteredMemberList = [];
    getMembersData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final officeColorValue = widget.officeData['OfficeColor'];
    Color officeColor = Color(int.parse(officeColorValue.substring(0, 10)));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Office",
          style: TextStyle(
            color: Color(0xFF292D32),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
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
                        height: expanded ? 322 : 152,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: screenWidth * .65,
                                    child: Text(
                                      "${widget.officeData['OfficeName']}",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF484954),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        AnimatedNavigation(
                                          page: EditOffice(
                                              officeData: widget.officeData),
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.users,
                                      size: 18,
                                      color: Color(0xFF0D4477),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Text(
                                        "${memberDataList.length}",
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
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      expanded = !expanded;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text(
                                          "More info",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF484954),
                                          ),
                                        ),
                                      ),
                                      expanded
                                          ? FaIcon(
                                              FontAwesomeIcons.chevronUp,
                                              size: 20,
                                              color: Color(0xFF0D4477),
                                            )
                                          : FaIcon(
                                              FontAwesomeIcons.chevronDown,
                                              size: 20,
                                              color: Color(0xFF0D4477),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                              if (expanded)
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
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
                                            margin: EdgeInsets.only(left: 8),
                                            child: Text(
                                              "${widget.officeData['PhoneNumber']}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF484954),
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
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
                                            margin: EdgeInsets.only(left: 8),
                                            child: Text(
                                              "${widget.officeData['Email']}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF484954),
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
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
                                            margin: EdgeInsets.only(left: 8),
                                            child: Text(
                                              "Office Capacity: ${widget.officeData['MaxCapacity']}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF484954),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            color: Color(0xFF0D4477),
                                            size: 25,
                                          ),
                                          Container(
                                            width: screenWidth * .65,
                                            margin: EdgeInsets.only(left: 8),
                                            child: Text(
                                              "${widget.officeData['Address']}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF484954),
                                                overflow: TextOverflow.visible,
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
            ),
            Container(
              height: 85,
              padding: EdgeInsets.all(20),
              child: TextField(
                onChanged: onQueryChanged,
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Color(0xFFFFFFFF),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 25, top: 10, bottom: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: screenWidth * .8,
                    child: Text(
                      "Staff Members In Office",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Text(
                    '${memberDataList.length}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            ),
            if (filteredMemberList.isNotEmpty)
              for (var index = 0; index < filteredMemberList.length; index++)
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 10, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: 52,
                            width: 52,
                            child: ClipRect(
                              child: Image(
                                image: AssetImage(
                                    filteredMemberList[index]['Avatar']),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Container(
                            width: screenWidth * .65,
                            padding: EdgeInsets.only(left: 20, right: 10),
                            child: Text(
                              "${filteredMemberList[index]['FirstName']} ${filteredMemberList[index]['LastName']}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () =>
                            {_staffMenuDialog(filteredMemberList[index])},
                        icon: Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addStaffMemberDialog();
          print('Add a staff member clicked.');
        },
        tooltip: 'Add a staff member.',
        shape: CircleBorder(),
        backgroundColor: Color(0xFF0D4477),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _addStaffMemberDialog() {
    final formKey = GlobalKey<FormState>();

    final PageController pageController = PageController();
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();

    var images = <AssetImage>[
      AssetImage("assets/images/Mask-1.png"),
      AssetImage("assets/images/Mask-2.png"),
      AssetImage("assets/images/Mask-3.png"),
      AssetImage("assets/images/Mask-4.png"),
      AssetImage("assets/images/Mask-5.png"),
      AssetImage("assets/images/Mask-6.png"),
      AssetImage("assets/images/Mask-7.png"),
    ];

    void createMember({officeID, firstName, lastName, avatar}) async {
      const uuid = Uuid();
      final response = await http.post(
        Uri.parse('$url/member'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
        },
        body: jsonEncode(<dynamic, dynamic>{
          'MemberID': uuid.v1(),
          'OfficeID': officeID,
          'FirstName': firstName,
          'LastName': lastName,
          'Avatar': avatar,
        }),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body)['data'];
        print('Response: $res');
      } else {
        throw Exception('Failed to create a member.');
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        int selectedIndex = -1;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            backgroundColor: Color.fromARGB(255, 247, 255, 254),
            insetPadding: EdgeInsets.symmetric(horizontal: 10),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            content: SizedBox(
              height: 340,
              width: MediaQuery.of(context).size.width,
              child: PageView(
                controller: pageController,
                children: [
                  ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "New Staff Member",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.circleXmark,
                              color: Color(0xFF0D4477),
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: TextFormField(
                                  controller: firstNameController,
                                  decoration: InputDecoration(
                                    labelText: 'First Name',
                                    hintText: 'First Name',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFFFFFFFF),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'First name is required.';
                                    }
                                    return null;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),
                              ),
                              TextFormField(
                                controller: lastNameController,
                                decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  hintText: 'Last Name',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFFFFFFF),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Last name is required.';
                                  }
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.blue,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.blue,
                              child: CircleAvatar(
                                radius: 3,
                                backgroundColor: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 65,
                        width: 250,
                        padding: EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              pageController.nextPage(
                                duration: const Duration(milliseconds: 10),
                                curve: Curves.easeIn,
                              );
                            }
                            FocusScope.of(context).unfocus();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 87, 182, 250),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "NEXT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  pageController.previousPage(
                                      duration:
                                          const Duration(milliseconds: 10),
                                      curve: Curves.easeIn);
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.arrowLeft,
                                  size: 25,
                                ),
                              ),
                              Text(
                                "New Staff Member",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.circleXmark,
                              color: Color(0xFF0D4477),
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                      selectedIndex == -1
                          ? Text(
                              "Please select an avatar.",
                              style: TextStyle(color: Colors.grey),
                            )
                          : Text(""),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8, left: 12, right: 8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .8,
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: images.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                    ),
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = index;
                                          });
                                        },
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: selectedIndex == index
                                                    ? Color(0xFF475569)
                                                    : Colors.transparent,
                                                width:
                                                    5.0, // Adjust the border thickness here
                                              ),
                                            ),
                                            child: ClipOval(
                                              child: Image(
                                                image: images[index],
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.blue,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.blue,
                              child: CircleAvatar(
                                radius: 3,
                                backgroundColor: Colors.white,
                              ),
                            )
                          ].reversed.toList(),
                        ),
                      ),
                      Container(
                        height: 65,
                        width: 250,
                        padding: EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedIndex != -1) {
                              createMember(
                                officeID: widget.officeData['OfficeID'],
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                avatar: images[selectedIndex].assetName,
                              );
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                AnimatedNavigation(
                                  page: OfficeView(
                                    imageIndex: widget.imageIndex,
                                    officeData: widget.officeData,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 87, 182, 250),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "ADD STAFF MEMBER",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _editStaffMemberDialog(final Map<String, dynamic> member) {
    final formKey = GlobalKey<FormState>();

    final PageController pageController = PageController();
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    firstNameController.text = member['FirstName'];
    lastNameController.text = member['LastName'];

    var images = <AssetImage>[
      AssetImage("assets/images/Mask-1.png"),
      AssetImage("assets/images/Mask-2.png"),
      AssetImage("assets/images/Mask-3.png"),
      AssetImage("assets/images/Mask-4.png"),
      AssetImage("assets/images/Mask-5.png"),
      AssetImage("assets/images/Mask-6.png"),
      AssetImage("assets/images/Mask-7.png"),
    ];

    void editMember({memberID, firstName, lastName, avatar}) async {
      final response = await http.post(
        Uri.parse('$url/member/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
        },
        body: jsonEncode(<dynamic, dynamic>{
          'MemberID': memberID,
          'FirstName': firstName,
          'LastName': lastName,
          'Avatar': avatar,
        }),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body)['data'];
        print('Response: $res');
      } else {
        throw Exception('Failed to update new office.');
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        int selectedIndex = images.indexOf(AssetImage(member['Avatar']));
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            backgroundColor: Color.fromARGB(255, 247, 255, 254),
            insetPadding: EdgeInsets.symmetric(horizontal: 10),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            content: SizedBox(
              height: 340,
              width: MediaQuery.of(context).size.width,
              child: PageView(
                controller: pageController,
                children: [
                  ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Edit Staff Member",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.circleXmark,
                              color: Color(0xFF0D4477),
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: TextFormField(
                                  controller: firstNameController,
                                  decoration: InputDecoration(
                                    labelText: 'First Name',
                                    hintText: 'First Name',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFFFFFFFF),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'First name is required.';
                                    }
                                    return null;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),
                              ),
                              TextFormField(
                                controller: lastNameController,
                                decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  hintText: 'Last Name',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFFFFFFF),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Last name is required.';
                                  }
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.blue,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.blue,
                              child: CircleAvatar(
                                radius: 3,
                                backgroundColor: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 65,
                        width: 250,
                        padding: EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              pageController.nextPage(
                                duration: const Duration(milliseconds: 10),
                                curve: Curves.easeIn,
                              );
                            }
                            FocusScope.of(context).unfocus();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 87, 182, 250),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "NEXT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  pageController.previousPage(
                                      duration:
                                          const Duration(milliseconds: 10),
                                      curve: Curves.easeIn);
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.arrowLeft,
                                  size: 25,
                                ),
                              ),
                              Text(
                                "Edit Staff Member",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.circleXmark,
                              color: Color(0xFF0D4477),
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                      selectedIndex == -1
                          ? Text(
                              "Please select an avatar.",
                              style: TextStyle(color: Colors.grey),
                            )
                          : Text(""),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8, left: 12, right: 8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .8,
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: images.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                    ),
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = index;
                                          });
                                        },
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: selectedIndex == index
                                                    ? Color(0xFF475569)
                                                    : Colors.transparent,
                                                width:
                                                    5.0, // Adjust the border thickness here
                                              ),
                                            ),
                                            child: ClipOval(
                                              child: Image(
                                                image: images[index],
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.blue,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.blue,
                              child: CircleAvatar(
                                radius: 3,
                                backgroundColor: Colors.white,
                              ),
                            )
                          ].reversed.toList(),
                        ),
                      ),
                      Container(
                        height: 65,
                        width: 250,
                        padding: EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedIndex != -1) {
                              editMember(
                                memberID: member['MemberID'],
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                avatar: images[selectedIndex].assetName,
                              );
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                AnimatedNavigation(
                                  page: OfficeView(
                                    imageIndex: widget.imageIndex,
                                    officeData: widget.officeData,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 87, 182, 250),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "UPDATE STAFF MEMBER",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _staffMenuDialog(final Map<String, dynamic> member) {
    final PageController pageController = PageController();

    void deleteMember() async {
      final response = await http.delete(
        Uri.parse('$url/member/?MemberID=${member['MemberID']}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
        },
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body)['message'];
        print('Response: $res');
      } else {
        throw Exception('Failed to delete staff member.');
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          backgroundColor: Color.fromARGB(255, 247, 255, 254),
          insetPadding: EdgeInsets.symmetric(horizontal: 10),
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          content: SizedBox(
            height: 270,
            width: MediaQuery.of(context).size.width,
            child: PageView(
              controller: pageController,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 65,
                      width: 250,
                      padding: EdgeInsets.only(top: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          print("edit staff");
                          Navigator.pop(context);
                          _editStaffMemberDialog(member);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 87, 182, 250),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "EDIT STAFF MEMBER",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 65,
                      width: 250,
                      padding: EdgeInsets.only(top: 15),
                      child: TextButton(
                        onPressed: () {
                          print("DELETE STAFF");

                          pageController.nextPage(
                            duration: const Duration(milliseconds: 10),
                            curve: Curves.easeIn,
                          );
                        },
                        style: TextButton.styleFrom(
                          // backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "DELETE STAFF MEMBER",
                          style: TextStyle(
                            color: Color.fromARGB(255, 87, 182, 250),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              pageController.previousPage(
                                  duration: const Duration(milliseconds: 10),
                                  curve: Curves.easeIn);
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.arrowLeft,
                              size: 25,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .65,
                            child: Text(
                              "Are You Sure You Want To Delete Staff Member?",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 65,
                      width: 250,
                      padding: EdgeInsets.only(top: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          deleteMember();
                          Navigator.pushReplacement(
                            context,
                            AnimatedNavigation(
                              page: OfficeView(
                                imageIndex: widget.imageIndex,
                                officeData: widget.officeData,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF44336),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "DELETE MEMBER",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 65,
                      width: 250,
                      padding: EdgeInsets.only(top: 15),
                      child: TextButton(
                        onPressed: () {
                          print("KEEP MEMBER");
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 247, 255, 254),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "KEEP MEMBER",
                          style: TextStyle(
                            color: Color.fromARGB(255, 87, 182, 250),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
