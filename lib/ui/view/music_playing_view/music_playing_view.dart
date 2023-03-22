import 'package:flutter/material.dart';

class MusicPlayingView extends StatelessWidget {
  const MusicPlayingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: const [SizedBox(width: 65, child: Icon(Icons.more_horiz))],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Color(0x33000000),
                      width: 1,
                    ),
                    color: Color(0xb2d9d9d9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Column(
                      children: [
                        const Text(
                          "Bad guy",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Billie eilish",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Slider(
                            value: 0.5,
                            onChanged: (value) {},
                            activeColor: Colors.red,
                            inactiveColor: Colors.grey.shade500,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              color: Colors.transparent,
                              child: GestureDetector(
                                onTap: () {},
                                child: Icon(
                                  Icons.skip_previous,
                                  size: 70,
                                  color: Colors.grey.shade100,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: SizedBox(
                                height: 70,
                                width: 70,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                  ),
                                  onPressed: () {},
                                  child: const Icon(
                                    true ? Icons.play_arrow : Icons.pause,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 70,
                              width: 70,
                              color: Colors.transparent,
                              child: GestureDetector(
                                onTap: () {},
                                child: Icon(
                                  Icons.skip_next,
                                  size: 70,
                                  color: Colors.grey.shade100,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
