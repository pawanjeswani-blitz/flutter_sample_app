// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:saloonwala_consumer/api/load_salons.dart';
// import 'package:saloonwala_consumer/model/paginated_salon_response.dart';
// import 'package:saloonwala_consumer/model/salon_data.dart';
// import 'package:saloonwala_consumer/utils/internet_util.dart';
// import 'package:saloonwala_consumer/view/widget/custom_card.dart';
// import 'package:saloonwala_consumer/view/widget/progress_dialog.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int pageNo = 1;
//   bool hasMore = false;
//   List arrayOfSalons;
//   PaginatedSalonResponse _salonresponse;
//   ScrollController scrollController;
//   Future<List<Map<String, dynamic>>> future;
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   // appendNewData() {
//   //   for (int index; index < _salonresponse.list.length; index++) {
//   //     arrayOfSalons.add(
//   //       SalonCard(
//   //           title: _salonresponse.list[index].name,
//   //           distance: _salonresponse.list[index].distance),
//   //     );
//   //   }
//   // }

//   @override
//   void initState() {
//     super.initState();
//     // initialData();
//     // scrollController.addListener(() {
//     //   if (scrollController.position.pixels ==
//     //       scrollController.position.maxScrollExtent) {
//     //     getMoreData();
//     //   }
//     // });
//     _getSalons();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       body: Container(
//           child: _salonresponse != null
//               ? ListView.builder(
//                   controller: scrollController,
//                   padding: EdgeInsets.all(8),
//                   // itemExtent: 80,
//                   itemBuilder: (BuildContext context, int index) {
//                     return arrayOfSalons[index];
//                   },
//                   itemCount: arrayOfSalons.length,
//                 )
//               : Center(child: CircularProgressIndicator())),
//     );
//   }

//   void _getSalons() async {
//     final isInternetConnected = await InternetUtil.isInternetConnected();
//     if (isInternetConnected) {
//       ProgressDialog.showProgressDialog(context);
//       try {
//         final response = await LoadSalons.getSalonFeed(pageNo);
//         //close the progress dialog
//         Navigator.of(context).pop();
//         if (response.error == null) {
//           //check the user is already register or not
//           if (response.data != null) {
//             print("Got Salons");
//             _salonresponse = response.data;
//           } else
//             showSnackBar("Something went wrong");
//         } else
//           showSnackBar(response.error);
//       } catch (ex) {
//         Navigator.of(context).pop();
//         showSnackBar("Be Patient.");
//       }
//     } else
//       showSnackBar("No internet connected");
//   }

//   void showSnackBar(String errorText) {
//     final snackBar = SnackBar(content: Text(errorText));
//     _scaffoldKey.currentState.showSnackBar(snackBar);
//   }
// }
