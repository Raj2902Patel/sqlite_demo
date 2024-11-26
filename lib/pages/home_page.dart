import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite_demo/data/theme_provider.dart';
import 'package:sqlite_demo/pages/addData.dart';
import 'package:sqlite_demo/pages/setting_page.dart';

import '../data/db_helper.dart';
import '../data/db_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool data = false;

  @override
  void initState() {
    super.initState();
    getData();
    context.read<DBProvider>().getInitialNotes();
  }

  void showLoaderAndFetchNotes() async {
    await Future.delayed(const Duration(seconds: 3));
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      data = prefs.getBool('isDarkMode') ?? false;
      Future.microtask(() {
        context.read<ThemeProvider>().updateTheme(value: data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool themeDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<DBProvider>(
      builder: (context, value, child) {
        List<Map<String, dynamic>> allNotes = value.getNotes();

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            centerTitle: false,
            backgroundColor: Colors.blue.withOpacity(0.5),
            title: const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Text(
                "Notes",
                style: TextStyle(
                  fontSize: 26.0,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: PopupMenuButton(itemBuilder: (_) {
                  return [
                    PopupMenuItem(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingPage(),
                          ),
                        );
                      },
                      child: const Row(
                        children: [
                          Icon(CupertinoIcons.settings),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "Settings",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                }),
              )
            ],
          ),
          body: allNotes.isNotEmpty
              ? ListView.builder(
                  itemCount: allNotes.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        color: themeDark
                            ? Colors.grey
                            : Colors.blueGrey.withOpacity(0.1),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueGrey.withOpacity(0.5),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: themeDark ? Colors.black : Colors.black,
                              ),
                            ),
                          ),
                          title: Text(
                            overflow: TextOverflow.ellipsis,
                            allNotes[index][DBHelper.COLUMN_NOTE_TITLE],
                            style: TextStyle(
                                fontSize: 20.0,
                                color: themeDark ? Colors.black : Colors.black),
                          ),
                          subtitle: Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            allNotes[index][DBHelper.COLUMN_NOTE_DESC],
                            style: TextStyle(
                              color: themeDark ? Colors.black : Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                          trailing: SizedBox(
                            width: 90,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      Colors.greenAccent.withOpacity(0.5),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddData(
                                            isUpdate: true,
                                            sno: allNotes[index]
                                                [DBHelper.COLUMN_NOTE_SNO],
                                            title: allNotes[index]
                                                [DBHelper.COLUMN_NOTE_TITLE],
                                            desc: allNotes[index]
                                                [DBHelper.COLUMN_NOTE_DESC],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.edit_note_rounded,
                                      color: themeDark
                                          ? Colors.black
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  backgroundColor:
                                      Colors.redAccent.withOpacity(0.5),
                                  child: InkWell(
                                    onTap: () => showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        backgroundColor: themeDark
                                            ? Colors.white54
                                            : Colors.white54,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        title: Center(
                                          child: Text(
                                            "W A R N I N G",
                                            style: TextStyle(
                                              color: themeDark
                                                  ? Colors.red.shade900
                                                  : Colors.red.shade900,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        content: Text(
                                          textAlign: TextAlign.center,
                                          "Are You Sure You Want To Delete This Note?",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20.0,
                                            color: themeDark
                                                ? Colors.black
                                                : Colors.black,
                                          ),
                                        ),
                                        actions: [
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              backgroundColor: themeDark
                                                  ? Colors.white54
                                                  : Colors.blueGrey,
                                            ),
                                            onPressed: () async {
                                              context
                                                  .read<DBProvider>()
                                                  .deleteNote(
                                                    allNotes[index][DBHelper
                                                        .COLUMN_NOTE_SNO],
                                                  );
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "OK",
                                              style: TextStyle(
                                                color: themeDark
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              backgroundColor: themeDark
                                                  ? Colors.white54
                                                  : Colors.blueGrey,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "CANCEL",
                                              style: TextStyle(
                                                color: themeDark
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.delete,
                                      color: themeDark
                                          ? Colors.black
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    "No Notes Found!",
                    style: TextStyle(
                      fontSize: 22.0,
                      color: themeDark ? Colors.white70 : Colors.black,
                    ),
                  ),
                ),
          floatingActionButton: Theme(
            data: Theme.of(context).copyWith(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
            ),
            child: FloatingActionButton(
              backgroundColor: themeDark ? Colors.white54 : Colors.black,
              splashColor: Colors.transparent,
              highlightElevation: 0,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddData()));
              },
              child: Icon(
                Icons.add,
                color: themeDark ? Colors.black : Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
