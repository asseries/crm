import 'dart:typed_data';

import 'package:crm/extensions/extensions.dart';
import 'package:crm/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';

import '../model/contact_model.dart';
import '../screen/sms/sms.dart';
import '../utils/app_colors.dart';
import '../utils/utils.dart';

class ContactItemView extends StatefulWidget {
  final int position;
  final Function favorite;
  final ContactModel item;

  const ContactItemView({Key? key, required this.position, required this.item, required this.favorite})
      : super(key: key);

  @override
  State<ContactItemView> createState() => _ContactItemViewState();
}

class _ContactItemViewState extends State<ContactItemView> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ContactProvider>(context, listen: false);

    if (provider.getActivePosition() != widget.position) {
      widget.item.isOpen = false;
    }
    return InkWell(onTap: () async {
      provider.setActivePostion(widget.position);
      widget.item.isOpen = !widget.item.isOpen;
    }, child: Consumer<ContactProvider>(
      builder: (context, providerM, child) {
        // print(widget.item.photoUri.toString());
        return AnimatedContainer(
          duration: 100.milliseconds,
          height: widget.item.isOpen ? 124 : 64,
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: widget.item.isOpen == true
              ? SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          //opened circle name[0]
                          // (widget.item.photoUri ?? []).isNotEmpty
                          //     ? Container(
                          //       margin: const EdgeInsets.only(right: 16,top: 10,left: 8),
                          //       child: CircleAvatar(
                          //         radius: 18,
                          //           backgroundImage:
                          //               MemoryImage(Uint8List.fromList(widget.item.photoUri ?? [])),
                          //         ),
                          //     )
                          //     :
                          Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(left: 8, right: 16),
                                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all()),
                                  child: Text(
                                    (widget.item.name).isNotEmpty ? (widget.item.name[0]) : "",
                                    style: const TextStyle(fontSize: 21),
                                  ),
                                ),
                          Text(widget.item.name, style: const TextStyle(fontFamily: "p_semi", fontSize: 16)),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: Text(widget.item.number, style: const TextStyle(fontFamily: "p_med")),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //call
                        InkResponse(
                          onTap: () {
                            FlutterPhoneDirectCaller.callNumber(widget.item.number);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                            child: Image.asset("assets/images/phone.png",
                                height: 24, width: 24, color: Colors.white),
                          ),
                        ),

                        //message
                        InkResponse(
                          onTap: () {
                            startScreen(context,
                                screen: SmsScreen(
                                  contact: widget.item,
                                ));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(left: 8),
                            decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                            child: Image.asset("assets/images/chat.png",
                                height: 20, width: 20, color: Colors.white),
                          ),
                        ),

                        //info
                        InkResponse(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            margin: const EdgeInsets.only(left: 8),
                            decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                            child: Image.asset("assets/images/info.png",
                                height: 23, width: 23, color: Colors.white),
                          ),
                        ),

                        //
                        //favorite
                        InkResponse(
                          onTap: () {
                            widget.favorite();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            margin: const EdgeInsets.only(left: 8),
                            decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                            child: Image.asset("assets/images/favorite.png",
                                height: 23,
                                width: 23,
                                color: widget.item.favorite ? AppColors.ACCENT : AppColors.COLOR_PRIMARY2),
                          ),
                        ),
                      ],
                    ),

                    //opened bottom divider
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      color: Colors.grey.shade300,
                      height: .5,
                      width: getScreenWidth(context),
                    )
                  ]),
                )
              : SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            //closed circle name[0]
                            // (widget.item.photoUri ?? []).isNotEmpty
                            //     ? Container(
                            //   margin: const EdgeInsets.only(right: 16,top: 10,left: 8),
                            //   child: CircleAvatar(
                            //     radius: 18,
                            //     backgroundImage:
                            //     MemoryImage(Uint8List.fromList(widget.item.photoUri ?? [])),
                            //   ),
                            // ):
                            Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 16),
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all()),
                              child: Text(
                                (widget.item.name).isNotEmpty ? (widget.item.name[0]) : "",
                                style: const TextStyle(fontSize: 21),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.item.name, style: asTextStyle(fontFamily: "p_semi", size: 16)),
                                Text(
                                  widget.item.number,
                                  style: asTextStyle(fontFamily: "p_reg"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      //closed bottom divider
                      Container(
                        margin: const EdgeInsets.only(left: 52),
                        color: Colors.grey.shade300,
                        height: .5,
                        width: getScreenWidth(context),
                      )
                    ],
                  ),
                ),
        );
      },
    ));
  }

// Widget avatar(ContactModel contact,
//     [double radius = 48.0, IconData defaultIcon = Icons.person]) {
//   if (contact.photoUri != null) {
//     return CircleAvatar(
//       backgroundImage: MemoryImage(Uint8List.fromList(contact.photoUri??[])),
//       radius: radius,
//     );
//   }
//   return CircleAvatar(
//     radius: radius,
//     child: Icon(defaultIcon),
//   );
// }
}
