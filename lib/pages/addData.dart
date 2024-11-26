import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/db_provider.dart';

class AddData extends StatelessWidget {
  final bool isUpdate;
  final String title;
  final String desc;
  final int sno;

  AddData({
    super.key,
    this.isUpdate = false,
    this.sno = 0,
    this.title = "",
    this.desc = "",
  });

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool themeDark = Theme.of(context).brightness == Brightness.dark;

    if (isUpdate) {
      titleController.text = title;
      descController.text = desc;
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: false,
        backgroundColor: Colors.blue.withOpacity(0.5),
        title: Text(
          isUpdate ? "UPDATE NOTE" : "ADD NOTE",
          style: const TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    style: TextStyle(
                      color: themeDark ? Colors.white : Colors.black,
                    ),
                    maxLength: 10,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: titleController,
                    decoration: InputDecoration(
                      errorMaxLines: 2,
                      errorStyle: TextStyle(
                        color: Colors.red.shade900,
                        fontSize: 15.0,
                      ),
                      labelText: "TITLE",
                      labelStyle: TextStyle(
                        fontSize: 20.0,
                        color: themeDark ? Colors.white : Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color:
                              themeDark ? Colors.yellowAccent : Colors.blueGrey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: themeDark ? Colors.white54 : Colors.black,
                          )),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter A Title!";
                      } else if (value.length <= 3) {
                        return "Title Must Be At Least 4 Characters Long.";
                      } else if (value.length > 15) {
                        return "Title Must Be 15 Characters or Less";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    style: TextStyle(
                      color: themeDark ? Colors.white : Colors.black,
                    ),
                    maxLength: 50,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: descController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      errorMaxLines: 2,
                      errorStyle: TextStyle(
                        color: Colors.red.shade900,
                        fontSize: 15.0,
                      ),
                      labelText: "DESCRIPTION",
                      labelStyle: TextStyle(
                        fontSize: 20.0,
                        color: themeDark ? Colors.white : Colors.black,
                      ),
                      hintStyle: const TextStyle(
                        fontSize: 16.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color:
                              themeDark ? Colors.yellowAccent : Colors.blueGrey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                            color: themeDark ? Colors.white54 : Colors.black),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter A Description!";
                      } else if (value.length <= 7) {
                        return "Description Must Be At Least 8 Characters Long.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          splashFactory: InkRipple.splashFactory,
                          overlayColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          side: BorderSide(
                            width: 2,
                            color: Colors.blue.withOpacity(0.5),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            print("Form validated successfully");

                            _formKey.currentState!.save();
                            var title = titleController.text;
                            var desc = descController.text;

                            if (isUpdate) {
                              context
                                  .read<DBProvider>()
                                  .updateNote(title, desc, sno);
                            } else {
                              context.read<DBProvider>().addNote(title, desc);
                            }

                            Navigator.pop(context);
                          } else {
                            print("Form validation failed");
                          }
                        },
                        child: Text(
                          isUpdate ? "UPDATE NOTE" : "ADD NOTE",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: themeDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          splashFactory: InkRipple.splashFactory,
                          overlayColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          side: BorderSide(
                            width: 2,
                            color: Colors.red.withOpacity(0.5),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          await Future.delayed(const Duration(seconds: 1));
                          titleController.clear();
                          descController.clear();
                        },
                        child: Text(
                          "CANCEL",
                          style: TextStyle(
                            color: themeDark ? Colors.white : Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
