import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReceiveScreen extends StatelessWidget {
  const ReceiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color:Colors.purple.shade700 ,),
            
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
                  // Container(
                  //   padding: EdgeInsets.only(left: 80),
                  //   width: 60,
                  //   height: 60,
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.rectangle,
                  //     border: Border.all(
                        
                  //       color: Color.fromARGB(185, 154, 65, 65),
                  //       width: 2,
                  //     ),
                  //   ),
                  // ),
                  const Text(
                    
                    'File Details',
                    style: TextStyle(
                      
                      color: Color.fromARGB(255, 7, 133, 236),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      // alignment: LexicalFocusOrder,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 40,
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
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.insert_drive_file,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      'fileName 1',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 40,
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
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.insert_drive_file,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      'fileName 2',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 40,
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
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.insert_drive_file,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      'fileName 3',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 40,
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
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.insert_drive_file,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      'fileName 4',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      );
  }
}