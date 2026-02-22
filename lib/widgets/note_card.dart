import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/note_model.dart';
import '../utils/date_formatter.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onTogglePin;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    this.onTogglePin,
  });

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

  String get _contentPreview {
    final text = note.content.trim();
    if (text.isEmpty) return 'No content';
    const maxLen = 100;
    final oneLine = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (oneLine.length <= maxLen) return oneLine;
    return '${oneLine.substring(0, maxLen)}…';
  }

  TextStyle _getPreviewTextStyle() {
    final baseStyle = TextStyle(
      fontSize: note.fontSize * 0.9, // Slightly smaller for preview
      color: textColors[note.textColor] ?? textColors['black'],
    );

    if (note.fontFamily == 'default') return baseStyle;

    try {
      // Try to load Google Font
      return GoogleFonts.getFont(
        note.fontFamily.replaceAll(' ', ''),
        textStyle: baseStyle,
      );
    } catch (e) {
      // Fallback to native font family
      return baseStyle.copyWith(fontFamily: note.fontFamily);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = noteColors[note.colorCode] ?? noteColors['default']!;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.1),
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.1),
        highlightColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (note.isPinned)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.push_pin,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      note.title.isEmpty ? 'Untitled' : note.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onTogglePin != null)
                    IconButton(
                      icon: Icon(
                        note.isPinned
                            ? Icons.push_pin
                            : Icons.push_pin_outlined,
                      ),
                      onPressed: onTogglePin,
                      tooltip: note.isPinned ? 'Unpin note' : 'Pin note',
                      style: IconButton.styleFrom(
                        foregroundColor: note.isPinned
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                    tooltip: 'Delete note',
                    style: IconButton.styleFrom(
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _contentPreview,
                style: _getPreviewTextStyle(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Text(
                DateFormatter.formatNoteDate(note.lastModified),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
