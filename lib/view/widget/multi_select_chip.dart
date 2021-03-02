// import 'package:flutter/material.dart';

// class MultiSelectItem<SlotsGen> {
//   final SlotsGen value;
//   final String label;
//   MultiSelectItem(this.value, this.label);
// }

// class SlotsGen {
//   String day;
//   int startTime;
//   int endTime;
//   String status;

//   SlotsGen({this.day, this.startTime, this.endTime, this.status});
// }

// class MultiSelectDialog<SlotsGen> extends StatefulWidget
//     with MultiSelectActions<SlotsGen> {
//   final List<MultiSelectItem<SlotsGen>> items;

//   final List<SlotsGen> initialValue;

//   final void Function(List<SlotsGen>) onSelectionChanged;

//   final MultiSelectListType listType;

//   final Color selectedColor;

//   final double height;

//   final Color Function(SlotsGen) colorator;

//   final Color unselectedColor;

//   final TextStyle itemsTextStyle;

//   final TextStyle selectedItemsTextStyle;

//   final Color checkColor;

//   MultiSelectDialog({
//     @required this.items,
//     this.initialValue,
//     @required this.onSelectionChanged,
//     this.listType,
//     this.selectedColor,
//     this.height,
//     this.colorator,
//     this.unselectedColor,
//     this.itemsTextStyle,
//     this.selectedItemsTextStyle,
//     this.checkColor,
//   });

//   @override
//   State<StatefulWidget> createState() =>
//       _MultiSelectDialogState<SlotsGen>(items);
// }

// class _MultiSelectDialogState<SlotsGen>
//     extends State<MultiSelectDialog<SlotsGen>> {
//   List<SlotsGen> _selectedValues = [];
//   bool _showSearch = false;
//   List<MultiSelectItem<SlotsGen>> _items;

//   _MultiSelectDialogState(this._items);

//   void initState() {
//     super.initState();
//     if (widget.initialValue != null) {
//       _selectedValues.addAll(widget.initialValue);
//     }
//   }

//   Widget _buildListItem(MultiSelectItem<SlotsGen> item) {
//     return Theme(
//       data: ThemeData(
//         unselectedWidgetColor: widget.unselectedColor ?? Colors.black54,
//         accentColor: widget.selectedColor ?? Theme.of(context).primaryColor,
//       ),
//       child: CheckboxListTile(
//         checkColor: widget.checkColor,
//         value: _selectedValues.contains(item.value),
//         activeColor: widget.colorator != null
//             ? widget.selectedColor
//             : widget.selectedColor,
//         title: Text(
//           item.label,
//           style: _selectedValues.contains(item.value)
//               ? widget.selectedItemsTextStyle
//               : widget.itemsTextStyle,
//         ),
//         controlAffinity: ListTileControlAffinity.trailing,
//         onChanged: (checked) {
//           setState(() {
//             _selectedValues = widget.onItemCheckedChange(
//                 _selectedValues, item.value, checked);
//           });
//           if (widget.onSelectionChanged != null) {
//             widget.onSelectionChanged(_selectedValues);
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildChipItem(MultiSelectItem<SlotsGen> item) {
//     return Container(
//       padding: const EdgeInsets.all(2.0),
//       child: ChoiceChip(
//         backgroundColor: widget.unselectedColor,
//         selectedColor:
//             widget.colorator != null && widget.colorator(item.value) != null
//                 ? widget.colorator(item.value)
//                 : widget.selectedColor != null
//                     ? widget.selectedColor
//                     : Theme.of(context).primaryColor.withOpacity(0.35),
//         label: Text(
//           item.label,
//           style: _selectedValues.contains(item.value)
//               ? TextStyle(
//                   color: widget.colorator != null &&
//                           widget.colorator(item.value) != null
//                       ? widget.selectedItemsTextStyle != null
//                           ? widget.selectedItemsTextStyle.color ??
//                               widget.colorator(item.value).withOpacity(1)
//                           : widget.colorator(item.value).withOpacity(1)
//                       : widget.selectedItemsTextStyle != null
//                           ? widget.selectedItemsTextStyle.color ??
//                               (widget.selectedColor != null
//                                   ? widget.selectedColor.withOpacity(1)
//                                   : Theme.of(context).primaryColor)
//                           : widget.selectedColor != null
//                               ? widget.selectedColor.withOpacity(1)
//                               : null,
//                   fontSize: widget.selectedItemsTextStyle != null
//                       ? widget.selectedItemsTextStyle.fontSize
//                       : null,
//                 )
//               : widget.itemsTextStyle,
//         ),
//         selected: _selectedValues.contains(item.value),
//         onSelected: (checked) {
//           setState(() {
//             _selectedValues = widget.onItemCheckedChange(
//                 _selectedValues, item.value, checked);
//           });
//           if (widget.onSelectionChanged != null) {
//             widget.onSelectionChanged(_selectedValues);
//           }
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: widget.height,
//       width: MediaQuery.of(context).size.width * 0.92,
//       child:
//           widget.listType == null || widget.listType == MultiSelectListType.LIST
//               ? ListView.builder(
//                   itemCount: _items.length,
//                   itemBuilder: (context, index) {
//                     return _buildListItem(_items[index]);
//                   },
//                 )
//               : SingleChildScrollView(
//                   child: Wrap(
//                     children: _items.map(_buildChipItem).toList(),
//                   ),
//                 ),
//     );
//   }
// }

// class MultiSelectActions<SlotsGen> {
//   List<SlotsGen> onItemCheckedChange(
//       List<SlotsGen> selectedValues, SlotsGen itemValue, bool checked) {
//     if (checked) {
//       selectedValues.add(itemValue);
//     } else {
//       selectedValues.remove(itemValue);
//     }
//     return selectedValues;
//   }
// }

// enum MultiSelectListType { LIST, CHIP }
