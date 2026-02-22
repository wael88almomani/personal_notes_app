import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/database_helper.dart';
import '../models/note_model.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final DatabaseHelper _db = DatabaseHelper();
  bool _saving = false;
  String _selectedColor = 'default';
  double _selectedFontSize = 16.0;
  String _selectedFontFamily = 'default';
  String _selectedTextColor = 'black';

  static const Map<String, Color> noteColors = {
    'default': Color(0xFFFFFFFF),
    'red': Color(0xFFF28B82),
    'orange': Color(0xFFFBBC04),
    'yellow': Color(0xFFFFF475),
    'green': Color(0xFFCCFF90),
    'teal': Color(0xFFA7FFEB),
    'blue': Color(0xFFCBF0F8),
    'purple': Color(0xFFAECBFA),
    'pink': Color(0xFFFDCFE8),
  };

  static const Map<String, Color> textColors = {
    'black': Color(0xFF000000),
    'white': Color(0xFFFFFFFF),
    'red': Color(0xFFD32F2F),
    'blue': Color(0xFF1976D2),
    'green': Color(0xFF388E3C),
    'purple': Color(0xFF7B1FA2),
    'orange': Color(0xFFF57C00),
  };

  static const Map<String, String> arabicFonts = {
    'default': 'Default',
    'Scheherazade New': 'Scheherazade New (تشكيل)',
    'Harmattan': 'Harmattan (تشكيل)',
    'Amiri': 'Amiri',
    'Cairo': 'Cairo',
    'Tajawal': 'Tajawal',
    'ElMessiri': 'El Messiri',
    'Lateef': 'Lateef',
  };

  bool get _isEdit => widget.note != null;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedColor = widget.note!.colorCode;
      _selectedFontSize = widget.note!.fontSize;
      _selectedFontFamily = widget.note!.fontFamily;
      _selectedTextColor = widget.note!.textColor;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      if (_isEdit) {
        final updated = widget.note!.copyWith(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          lastModified: DateTime.now(),
          colorCode: _selectedColor,
          fontSize: _selectedFontSize,
          fontFamily: _selectedFontFamily,
          textColor: _selectedTextColor,
        );
        await _db.updateNote(updated);
      } else {
        final created = Note(
          id: 0,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          createdDate: DateTime.now(),
          lastModified: DateTime.now(),
          colorCode: _selectedColor,
          fontSize: _selectedFontSize,
          fontFamily: _selectedFontFamily,
          textColor: _selectedTextColor,
        );
        await _db.insertNote(created);
      }
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
    }
  }

  TextStyle _getTextStyle() {
    final baseStyle = TextStyle(
      fontSize: _selectedFontSize,
      color: textColors[_selectedTextColor],
    );

    if (_selectedFontFamily == 'default') {
      return baseStyle;
    }

    try {
      return GoogleFonts.getFont(
        _selectedFontFamily.replaceAll(' ', ''),
        textStyle: baseStyle,
      );
    } catch (e) {
      return baseStyle.copyWith(fontFamily: _selectedFontFamily);
    }
  }

  void _shareNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nothing to share')));
      return;
    }

    final shareText = '${title.isNotEmpty ? "$title\n\n" : ""}$content';
    Share.share(shareText, subject: title.isNotEmpty ? title : 'Note');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit note' : 'Add note'),
        actions: [
          IconButton(
            onPressed: _shareNote,
            icon: const Icon(Icons.share),
            tooltip: 'Share',
          ),
          if (_saving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              onPressed: _save,
              icon: const Icon(Icons.check),
              tooltip: 'Save',
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Note title',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                hintText: 'Write your note…',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              style: _getTextStyle(),
              maxLines: null,
              minLines: 8,
              textCapitalization: TextCapitalization.sentences,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Enter some content';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text('Color', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: noteColors.entries.map((entry) {
                final isSelected = _selectedColor == entry.key;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = entry.key),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: entry.value,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        width: isSelected ? 3 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withAlpha(77),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color:
                                entry.key == 'default' || entry.key == 'yellow'
                                ? Colors.black54
                                : Colors.white,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text('Font Size', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _selectedFontSize,
                    min: 12.0,
                    max: 24.0,
                    divisions: 12,
                    label: _selectedFontSize.round().toString(),
                    onChanged: (value) =>
                        setState(() => _selectedFontSize = value),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${_selectedFontSize.round()}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Font Family', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: arabicFonts.entries.map((entry) {
                final isSelected = _selectedFontFamily == entry.key;
                TextStyle? chipStyle;
                if (entry.key != 'default') {
                  try {
                    chipStyle = GoogleFonts.getFont(
                      entry.key.replaceAll(' ', ''),
                    );
                  } catch (e) {
                    chipStyle = TextStyle(fontFamily: entry.key);
                  }
                }
                return ChoiceChip(
                  label: Text(entry.value, style: chipStyle),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedFontFamily = entry.key);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text('Text Color', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: textColors.entries.map((entry) {
                final isSelected = _selectedTextColor == entry.key;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTextColor = entry.key),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: entry.value,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        width: isSelected ? 3 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withAlpha(77),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: entry.key == 'white'
                                ? Colors.black54
                                : Colors.white,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
