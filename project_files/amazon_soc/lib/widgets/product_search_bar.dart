import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ProductSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final bool autofocus;

  const ProductSearchBar({
    super.key,
    required this.controller,
    required this.onSubmitted,
    this.autofocus = false,
  });

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            setState(() => _isListening = false);
            _speech.stop();
          }
        },
        onError: (error) {
          setState(() => _isListening = false);
        },
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              widget.controller.text = result.recognizedWords;
            });
            if (result.finalResult) {
              widget.onSubmitted(result.recognizedWords.toLowerCase().trim());
            }
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: TextField(
        controller: widget.controller,
        onSubmitted: (value) => widget.onSubmitted(value.toLowerCase().trim()),
        autofocus: widget.autofocus,
        autocorrect: true,
        enableSuggestions: true,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search for products...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.controller.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onSubmitted('');
                  },
                ),
              IconButton(
                icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                onPressed: _listen,
              ),
            ],
          ),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
