// import 'dart:math';
//
// import 'package:crm/utils/utils.dart';
// import 'package:flutter/material.dart';
//
// class ContactInfo extends StatefulWidget {
//   @override
//   _ContactInfoState createState() => _ContactInfoState();
// }
//
// class _ContactInfoState extends State<ContactInfo> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     _tabController = TabController(
//       initialIndex: 0,
//       length: 2,
//       vsync: this,
//     );
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: NestedScrollView(
//           floatHeaderSlivers: true,
//           headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//             return [
//                SliverAppBar(
//                 title: Text("Contact name"),
//                 centerTitle: true,
//                 actions: [
//                   IconButton(icon: Icon(Icons.search),onPressed:() {
//
//                   },),
//                 ],
//                 pinned: false,
//                 floating: true,
//                 // bottom: const PreferredSize(
//                 //   preferredSize: Size.fromHeight(100.0), // here the desired height
//                 //   child: Text("AAAA")
//                 // ),
//               ),
//             ];
//           },
//           body: SingleChildScrollView(
//             child: Column(
//               children: const [
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),  Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),  Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),  Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//                 Text("AAAAAAAAAAAAAAAA"),
//               ],
//             ),
//           ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
// }
//
// class TabA extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scrollbar(
//       child: ListView.separated(
//         separatorBuilder: (context, child) => const Divider(
//           height: 1,
//         ),
//         padding: const EdgeInsets.all(0.0),
//         itemCount: 30,
//         itemBuilder: (context, i) {
//           return Container(
//             height: 100,
//             width: double.infinity,
//             color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
//           );
//         },
//       ),
//     );
//   }
//
//
// }