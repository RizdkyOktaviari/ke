import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/app_localizations.dart';
import '../../helpers/providers/auth_provider.dart';
import '../../helpers/providers/note_provider.dart';
import '../../models/note_model.dart';

class NotesPage extends StatefulWidget {
  final Function(String) onNoteAdded;

  NotesPage({required this.onNoteAdded});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  Future<void> _submitNote() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final note = Note(
      title: _titleController.text,
      content: _contentController.text,
    );

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Not authenticated')),
      );
      return;
    }

    final provider = Provider.of<NoteProvider>(context, listen: false);
    final success = await provider.addNote(token, note);

    if (success) {
      widget.onNoteAdded(_contentController.text);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error ?? 'Failed to add note')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.notes),
        backgroundColor: Colors.blueAccent,
      ),
      body: !authProvider.isAuthenticated
          ? FutureBuilder(
        future: authProvider.handleUnauthorized(context),
        builder: (context, snapshot) => const SizedBox(),
      )
          :Consumer<NoteProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(localizations.noteTitle),
                  SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: localizations.enterNoteTitle,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(localizations.noteContent),
                  SizedBox(height: 8),
                  TextField(
                    controller: _contentController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: localizations.enterNoteContent,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitNote,
                      child: Text(localizations.addNote),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}