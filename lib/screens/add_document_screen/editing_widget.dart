import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditingWidget extends StatefulWidget {
  EditingWidget(
      {Key? key,
      required this.details,
      required this.detailKey,
      required this.saveData})
      : super(key: key);
  final Map<String, dynamic> details;
  final String detailKey;
  final Function saveData;

  @override
  State<EditingWidget> createState() => _EditingWidgetState();
}

class _EditingWidgetState extends State<EditingWidget> {
  DateTime? _selecteDate;

  @override
  Widget build(BuildContext context) {
    void _presentDatePicker() {
      showDatePicker(
        context: context,
        initialDate: _selecteDate ?? DateTime.now(),
        firstDate: DateTime(1947),
        lastDate: DateTime.now(),
      ).then((value) {
        if (value == null) {
          return;
        } else {
          setState(() {
            _selecteDate = value;
          });
          widget.saveData(
              widget.detailKey, DateFormat('dd-MM-yyyy').format(_selecteDate!));
        }
      });
    }

    final _detailType = widget.details[widget.detailKey];
    if (_detailType != 'Date') {
      return TextFormField(
        decoration: InputDecoration(
          hintText: widget.detailKey,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onChanged: (value) {
          widget.saveData(widget.detailKey, value);
        },
        keyboardType: _detailType == 'Number'
            ? TextInputType.number
            : _detailType == 'MString'
                ? TextInputType.multiline
                : TextInputType.name,
        maxLines: _detailType == 'MString' ? 3 : null,
        minLines: _detailType == 'MString' ? 3 : null,
        textInputAction: _detailType == 'MString' ? null : TextInputAction.next,
        validator: (value) {
          if (value.toString().isEmpty) {
            return 'Required';
          }
        },
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RaisedButton(
            elevation: 0,
              onPressed: _presentDatePicker,
              child: Text("Select ${widget.detailKey}"),
          ),
          SizedBox(
            width: 10,
          ),
          if (_selecteDate != null)
            Container(
              child: Text(DateFormat('dd-MM-yyyy').format(_selecteDate!)),
            )
        ],
      );
    }
  }
}
