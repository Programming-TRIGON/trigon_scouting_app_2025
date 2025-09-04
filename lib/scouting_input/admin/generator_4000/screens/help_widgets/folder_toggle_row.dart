import "package:flutter/material.dart";

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
  final ScrollController tabsScrollController = ScrollController();
  final PageController pageController = PageController();

  @override
  void dispose() {
    tabsScrollController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final optionKeys = widget.tabs.keys.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (optionKeys.length > 4)
              Flexible(child: createTabsRow(optionKeys))
            else
              createTabsRow(optionKeys),
            if (optionKeys.length <= 4)
              Flexible(child: Divider(color: borderColor, height: 1)),
          ],
        ),
        createFolderContainer(
          PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            physics: const NeverScrollableScrollPhysics(),
            children: buildPages(),
          ),
        ),
      ],
    );
  }

  List<Widget> buildPages() {
    if (widget.tabs.isEmpty) {
      return [
        Center(
          child: Text(
            widget.noDataContainerText,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ];
    }

    return widget.tabs.values.toList();
  }

  Widget createTabsRow(List<String> optionKeys) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: SizedBox(
        height: 40,
        child: Scrollbar(
          controller: tabsScrollController,
          thumbVisibility: true,
          trackVisibility: false,
          thickness: 4,
          radius: const Radius.circular(3),
          scrollbarOrientation: ScrollbarOrientation.top,
          child: ListView(
            scrollDirection: Axis.horizontal,
            controller: tabsScrollController,
            shrinkWrap: true,
            children: optionKeys.isEmpty
                ? [buildTab(widget.noDataTitle, true, null)]
                : List.generate(optionKeys.length, (index) {
                    return buildTab(
                      optionKeys[index],
                      _selectedIndex == index,
                      () {
                        setState(() {
                          pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
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
    return Container(
      width: 80,
      height: 40,
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
      child: Material(
        color: selected ? selectedColor : unselectedColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        child: InkWell(
          splashFactory: InkRipple.splashFactory,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          onTap: onPressed,
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
      height: 500,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selectedColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
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
