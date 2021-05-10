import 'package:flutter/material.dart';
import 'package:todo_app/dbhelper.dart';

class todoui extends StatefulWidget {
  @override
  _todouiState createState() => _todouiState();
}

class _todouiState extends State<todoui> {
  final dbhelper = Databasehelper.instance;
  final texteditingcontroller = TextEditingController();
  bool validated = true;
  String errtxt = "";
  String todoedited = "";
  var myitems = [];
  List<Widget> children = [];

  void addtodo() async {
    Map<String, dynamic> row = {
      Databasehelper.columnName: todoedited,
    };
    final id = await dbhelper.insert(row);
    Navigator.pop(context);
    todoedited = "";
    setState(() {
      validated = true;
      errtxt = "";
    });
  }

  Future<bool> query() async {
    myitems = [];
    children = [];
    var allrows = await dbhelper.queryall();
    allrows.forEach((row) {
      myitems.add(row.toString());
      children.add(Card(
        elevation: 5.0,
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: ListTile(
            title: Text(
              row['todo'],
              style: TextStyle(
                fontFamily: "Raleway",
                fontSize: 18.0,
              ),
            ),
            onLongPress: () {
              // print("Should get deleted");
              dbhelper.deletedata(row['id']);
              setState(() {});
            },
          ),
        ),
      ));
    });
    return Future.value(true);
  }

  void showalertdialog() {
    texteditingcontroller.text = "";
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text(
              "Add Task",
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: texteditingcontroller,
                  autofocus: true,
                  onChanged: (_val) {
                    todoedited = _val;
                  },
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "Raleway",
                  ),
                  decoration: InputDecoration(
                    errorText: validated ? null : errtxt,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (texteditingcontroller.text.isEmpty) {
                            setState(() {
                              errtxt = "Task can't be empty";
                              validated = false;
                            });
                          } else if (texteditingcontroller.text.length > 512) {
                            setState(() {
                              errtxt = "To many characters";
                              validated = false;
                            });
                          } else {
                            addtodo();
                          }
                        },
                        child: Text(
                          "Add",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Raleway",
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }

  // Widget mycard(String task) {
  //   return Card(
  //     elevation: 5.0,
  //     margin: EdgeInsets.symmetric(
  //       horizontal: 10.0,
  //       vertical: 5.0,
  //     ),
  //     child: Container(
  //       padding: EdgeInsets.all(5.0),
  //       child: ListTile(
  //         title: Text(
  //           "$task",
  //           style: TextStyle(
  //             fontFamily: "Raleway",
  //             fontSize: 18.0,
  //           ),
  //         ),
  //         onLongPress: () {
  //           print("Should get deleted");
  //         },
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.hasData == null) {
          return Center(
            child: Text("No data"),
          );
        } else {
          if (myitems.length == 0) {
            return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: showalertdialog,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.purple,
                ),
                appBar: AppBar(
                  title: Text(
                    "Tasks",
                    style: TextStyle(
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.black,
                  centerTitle: true,
                ),
                body: Center(
                  child: Text(
                    "No Task avalible",
                    style: TextStyle(
                      fontFamily: "Cursive",
                      fontSize: 20.0,
                    ),
                  ),
                ));
          } else {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: showalertdialog,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.purple,
              ),
              appBar: AppBar(
                title: Text(
                  "Tasks",
                  style: TextStyle(
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.black,
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: children,
                ),
              ),
            );
          }
        }
      },
      future: query(),
    );
  }
}

// Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: showalertdialog,
//         child: Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//         backgroundColor: Colors.purple,
//       ),
//       appBar: AppBar(
//         title: Text(
//           "Tasks",
//           style: TextStyle(
//             fontFamily: "Raleway",
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.black,
//         centerTitle: true,
//       ),
//       backgroundColor: Colors.black,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             mycard(
//               "Record",
//             ),
//           ],
//         ),
//       ),
//     );
