import 'package:flutter/material.dart';

import '../models/notes.dart';
import '../service/notesservice.dart';

class InputPage extends StatefulWidget {
  final int noteIndex;

  const InputPage({Key? key, required this.noteIndex}) : super(key: key);

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final NotesService _notesService = NotesService();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.noteIndex != -1) {
      _loadNote();
    }
  }

  void _loadNote() async {
    List<Note> notes = await _notesService.getNotes();
    Note note = notes[widget.noteIndex];
    _titleController.text = note.judul;
    _contentController.text = note.isi;
  }

  void _saveNote() async {
    String title = _titleController.text;
    String content = _contentController.text;

    if (title.isEmpty) {
      title = 'Tanpa judul';
    }

    Note newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      judul: title,
      isi: content,
      tanggal: DateTime.now(),
    );

    if (widget.noteIndex == -1) {
      await _notesService.saveNote(newNote);
    } else {
      await _notesService.updateNote(widget.noteIndex, newNote);
    }
    Navigator.pop(context, true);
  }

  void _deleteNote() async {
    bool shouldDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Anda yakin ingin menghapus catatan ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );

    // Jika pengguna menekan "Hapus" pada dialog konfirmasi
    if (shouldDelete == true) {
      await _notesService.deleteNote(widget.noteIndex);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(250, 193, 48, 1),
        title: TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'Judul',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteNote();
            },
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveNote();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _contentController,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: 'Isi catatan...',
          ),
          textAlignVertical: TextAlignVertical.top,
        ),
      ),
      backgroundColor: Color.fromRGBO(250, 193, 48, 1),
    );
  }
}
