import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTodo extends StatefulWidget {
  const MyTodo({super.key});

  @override
  State<MyTodo> createState() => _MyTodoState();
}

class _MyTodoState extends State<MyTodo> {
  final TextEditingController inputController = TextEditingController();
  String _savedText = '';
  @override
  void initState() {
    super.initState();
    _loadSavedText();
  }

  Future<void> _loadSavedText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedText = prefs.getString('my_text') ?? '';
    });
  }

  Future<void> _saveText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('my_text', inputController.text.trim());
    _loadSavedText(); // Refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            TextField(controller: inputController, autocorrect: true),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveText,
              child: Text('Save to Local Storage'),
            ),
            SizedBox(height: 20),
            Text(
              'Saved Text: $_savedText',
              style: TextStyle(fontFamily: 'Lexend'),
            ),
          ],
        ),
      ),
    );
  }
}
