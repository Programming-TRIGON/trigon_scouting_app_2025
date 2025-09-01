import 'package:flutter/material.dart';

class FolderToggleRow extends StatefulWidget {
  final Map<String, Widget> tabs;
  final String noDataTitle;
  final String noDataContainerText;

  const FolderToggleRow({
    super.key,
    required this.tabs,
    this.noDataTitle = "No Data",
    this.noDataContainerText = "No data available.",
  });

  @override
  State<FolderToggleRow> createState() => _FolderToggleRowState();
}

class _FolderToggleRowState extends State<FolderToggleRow> {
  static final Color selectedColor = Colors.grey[900]!;
  static final Color unselectedColor = Colors.grey[850]!;
  static final Color borderColor = Colors.grey[700]!;

  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final optionKeys = widget.tabs.keys.toList();
    return Flexible(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            createTabsRow(optionKeys),
            createFolderContainer(
              widget.tabs[optionKeys.elementAtOrNull(_selectedIndex)] ??
                  Center(
                    child: Text(
                      widget.noDataContainerText,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createTabsRow(List<String> optionKeys) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: false,
        trackVisibility: false,
        thickness: 4,
        radius: const Radius.circular(3),
        scrollbarOrientation: ScrollbarOrientation.top,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: optionKeys.isEmpty
                ? [buildTab(widget.noDataTitle, true, null)]
                : List.generate(optionKeys.length, (index) {
                    return buildTab(
                      optionKeys[index],
                      _selectedIndex == index,
                      () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    );
                  }),
          ),
        ),
      ),
    );
  }

  Widget buildTab(String text, bool selected, VoidCallback? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 80,
          maxWidth: 80,
          minHeight: 40,
          maxHeight: 40,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: borderColor, width: 1),
              left: BorderSide(color: borderColor, width: 1),
              right: BorderSide(color: borderColor, width: 1),
              bottom: selected
                  ? BorderSide.none
                  : BorderSide(color: borderColor, width: 1),
            ),
            color: selected ? selectedColor : unselectedColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white.withAlpha(100),
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget createFolderContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selectedColor,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(12),
        ),
        border: Border(
          top: BorderSide.none,
          left: BorderSide(color: borderColor, width: 1),
          right: BorderSide(color: borderColor, width: 1),
          bottom: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: child,
    );
  }
}
