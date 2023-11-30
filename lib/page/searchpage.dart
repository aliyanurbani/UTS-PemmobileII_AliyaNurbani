import 'package:flutter/material.dart';
import 'package:utspemwebaliya/page/addpage.dart';

import '../models/notes.dart';
import '../service/notesservice.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Note> _notes = [];
  final NotesService _notesService = NotesService();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    List<Note> notes = await _notesService.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _searchController,
          onChanged: _onSearchTextChanged,
          decoration: InputDecoration(
            hintText: 'Search',
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          String judul = '${_notes[index].judul}';
          String isi = '${_notes[index].isi}';
          String tanggal = '${_notes[index].tanggal}';

          return GestureDetector(
            onTap: () {
              _navigateToInputPage(index);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(judul, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(isi),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(tanggal),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onSearchTextChanged(String value) async {
    List<Note> searchedNotes = await _notesService.searchNotes(value);
    setState(() {
      _notes = searchedNotes;
    });
  }

  void _navigateToInputPage(int id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InputPage(noteIndex: id),
      ),
    );
    _loadNotes();
  }
}
