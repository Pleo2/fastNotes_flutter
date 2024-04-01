import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_crud/constants/colors.dart';
import 'package:notes_crud/models/notes.dart';
import 'package:notes_crud/screens/edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> filteredNotes = [];

  void onSearchTextChange(String searchText) {
    setState(() {
      filteredNotes = sampleNotes
          .where((notes) =>
              notes.content.toLowerCase().contains(searchText.toLowerCase()) ||
              notes.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void deleteNote(int index) {
    setState(() {
      Note note = filteredNotes[index];
      sampleNotes.remove(note);
      if (filteredNotes.contains(note)) {
        filteredNotes.removeAt(index);
      }
    });
  }

  Color randomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  @override
  void initState() {
    super.initState();
    filteredNotes = sampleNotes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 50, 16, 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fast Notes',
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.grey.shade200,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade800),
                    child: IconButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {},
                        icon: Icon(
                          Icons.sort,
                          color: Colors.grey.shade200,
                        )),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: onSearchTextChange,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                    hintText: 'Search in notes...',
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade200,
                      size: 16,
                    ),
                    fillColor: Colors.grey.shade800,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Colors.transparent)),
                    focusColor: Colors.grey.shade200),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: filteredNotes.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 20),
                    color: randomColor(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        onTap: () async {
                          final EditData? editedData = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      EditScreen(note: filteredNotes[index])));
                          if (editedData != null) {
                            setState(() {
                              int originalIndex =
                                  sampleNotes.indexOf(filteredNotes[index]);

                              sampleNotes[originalIndex] = Note(
                                  id: originalIndex,
                                  title: editedData.title,
                                  content: editedData.content,
                                  modifiedTime: DateTime.now());

                              filteredNotes[index] = Note(
                                id: filteredNotes[index].id,
                                title: editedData.title,
                                content: editedData.content,
                                modifiedTime: DateTime.now()
                              );
                            });
                          }
                        },
                        title: RichText(
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                text: '${filteredNotes[index].title} \n',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    height: 1.5),
                                children: [
                                  TextSpan(
                                      text: filteredNotes[index].content,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          height: 1.5)),
                                ])),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Edited: ${DateFormat('EEE MMM d, yyyy h:m a').format(filteredNotes[index].modifiedTime)}',
                            style: TextStyle(
                                fontSize: 10,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey.shade800),
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            deleteNote(index);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    ),
                  );
                },
              ))
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final EditData? editedData = await Navigator.push<EditData>(context,
              MaterialPageRoute<EditData>(builder: (BuildContext context) {
            return const EditScreen();
          }));

          if (editedData != null) {
            setState(() {
              sampleNotes.add(Note(
                id: sampleNotes.length,
                title: editedData.title,
                content: editedData.content,
                modifiedTime: DateTime.now(),
              ));
              filteredNotes = sampleNotes;
            });
          }
        },
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        child: Icon(
          Icons.add,
          color: Colors.grey.shade200,
        ),
      ),
    );
  }
}
