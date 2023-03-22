import 'package:flutter/material.dart';
import 'package:music_prototype/ui/view/music_playing_view/music_playing_view.dart';

// 消す
const _images = [
  'assets/image_5.jpg',
  'assets/image_3.jpg',
  'assets/image_4.jpg',
];
var selectedValue = "orange";
final lists = <String>["orange", "apple", "strawberry", "banana", "grape"];

// 消す
class LikeHistoryView extends StatelessWidget {
  const LikeHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2.3,
              decoration: BoxDecoration(
                  color: Colors.white, //background color of dropdown button
                  borderRadius: BorderRadius.circular(15), //border raiuds of dropdown button
                  boxShadow: const <BoxShadow>[
                    //apply shadow on Dropdown button
                    BoxShadow(
                        color: Colors.black26, //shadow for button
                        blurRadius: 5) //blur radius of shadow
                  ]),
              child: Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedValue,
                    items: lists.map((String list) => DropdownMenuItem(value: list, child: Text(list))).toList(),
                    onChanged: (String? value) {
                      selectedValue = value!;
                    },
                    borderRadius: BorderRadius.circular(15),
                    dropdownColor: Colors.white,
                    elevation: 5,
                    isExpanded: true,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: 750,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (builder) => const MusicPlayingView()));
                      },
                      child: SizedBox(
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                color: Colors.red,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("fjlahlfahlfa"),
                                  Text("fjlahlfahlfa"),
                                ],
                              ),
                              Icon(Icons.more_vert)
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
