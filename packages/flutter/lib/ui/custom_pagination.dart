import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomPagination extends StatefulWidget {
  VoidCallback? callBackNext;
  VoidCallback? callBackPrev;
  int? page, lastPage;
  CustomPagination({
    required this.callBackNext,
    required this.callBackPrev,
    required this.page,
    required this.lastPage
  });
  @override
  _PaginationCustomState createState() => _PaginationCustomState();
}

class _PaginationCustomState extends State<CustomPagination> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container( 
            child: TextButton(
              child: Icon(
                size: 50,
                Icons.arrow_left,
                color: widget.page == 1 ? Colors.grey : Colors.black,
              ),
              onPressed: widget.page == 1 ? null : widget.callBackPrev
            ),
          ),
          Container(
            child: Text("${widget.page.toString()}"),
          ),
          Container(
            child: TextButton(
              child: Icon(
                size: 50,
                Icons.arrow_right,
                color: widget.page == widget.lastPage ? Colors.grey : Colors.black,
              ),
              onPressed: widget.page == widget.lastPage ? null : widget.callBackNext
            ),
          )
        ],
      ),
    );
  }
}