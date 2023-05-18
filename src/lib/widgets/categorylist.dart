import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  final List<String> categories;

  CategoryList({required this.categories});

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<bool> toggles = [];

  @override
  void initState() {
    super.initState();
    toggles = List<bool>.generate(widget.categories.length, (index) => false);
  }

  @override
  void didUpdateWidget(CategoryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.categories.length != toggles.length) {
      setState(() {
        toggles = List<bool>.generate(widget.categories.length, (index) => false);
      });
    }
  }

  void _removeCategory(int index) {
    setState(() {
      widget.categories.removeAt(index);
      toggles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.categories.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            setState(() {
              toggles[index] = !toggles[index];
            });
          },
          title: Row(
            children: [
              Container(
                width: 48,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: toggles[index] ? Colors.blue.withOpacity(0.5) : Colors.grey.withOpacity(0.5),
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      toggles[index] = !toggles[index];
                    });
                  },
                  child: AnimatedAlign(
                    duration: Duration(milliseconds: 200),
                    alignment: toggles[index] ? Alignment.centerRight : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: toggles[index] ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.categories[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  _removeCategory(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

