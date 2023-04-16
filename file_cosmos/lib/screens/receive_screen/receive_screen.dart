import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/file_model.dart';
// import 'package:../../models/file_model.dart';

class ReceiveScreen extends StatelessWidget {
  const ReceiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MyFile> Lis = [
      MyFile(
          id: "id",
          name: "Name",
          location: "location",
          coordinates: "coordinates")
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.purple.shade700,
          ),
          onPressed: () {},
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'File Transfer',
          style: GoogleFonts.lato(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 80),
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(255, 237, 144, 161),
                      width: 3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 56),
            Stack(
              alignment: Alignment.topLeft,
              children: [
                const Text(
                  'Recieved Files',
                  style: TextStyle(
                    color: Color.fromARGB(255, 7, 133, 236),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    // alignment: LexicalFocusOrder,
                  ),
                ),
              ],
            ),
            Container(
              height: 100,
              child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: Lis.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 60,
                      // width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color.fromARGB(255, 5, 157, 99),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.insert_drive_file,
                              color: Colors.purple,
                              size: 35,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(children: [
                              Text(
                                Lis[index].name,
                                style: GoogleFonts.lato(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                Lis[index].location,
                                style: GoogleFonts.lato(
                                  color: Color.fromARGB(125, 18, 17, 17),
                                  fontSize: 12,
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
