import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kioskplus/screens/home/home.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key, required this.userDocumentID});

  final String userDocumentID;
  @override
  State<Quiz> createState() => _QuizState();
}

List<Map> quizlist = [
  {
    'answer': 'Fashion',
  },
  {
    'answer': 'Food',
  },
  {
    'answer': 'Tegnology',
  },
  {
    'answer': 'Education',
  },
  {
    'answer': 'Sports',
  },
  {
    'answer': 'Automobile',
  },
];

class _QuizState extends State<Quiz> {
  int selectedIndex = 0;
  Future _sendInterest() async {
    await FirebaseFirestore.instance.collection('interests').add({
      'User Name': widget.userDocumentID,
      'Interest': quizlist[selectedIndex]['answer'],
      'Date': DateTime.now(),
    });
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final String message =
        DateTime.now().hour < 12 ? "Good Morning" : "Good Afternoon";
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            _sendInterest();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(
                  userDocumentID: widget.userDocumentID,
                ),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'For what do you like to have an offer today?',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'OpenSans',
                  ),
                ),
                const SizedBox(height: 10),
                for (int i = 0; i < 5; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = i;
                        });
                      },
                      child: Center(
                        child: AnimatedContainer(
                          width: i == selectedIndex
                              ? MediaQuery.of(context).size.width * 1
                              : i == selectedIndex
                                  ? 50
                                  : MediaQuery.of(context).size.width * 0.85,
                          height: i == selectedIndex ? 50 : 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: i == selectedIndex
                                ? const Color.fromARGB(255, 66, 103, 178)
                                : const Color.fromARGB(255, 238, 238, 238),
                          ),
                          duration: const Duration(seconds: 1),
                          curve: Curves.linear,
                          child: Center(
                            child: Text(quizlist[i]['answer'],
                                style: TextStyle(
                                  fontSize: i == selectedIndex ? 18 : 16,
                                  fontWeight: i == selectedIndex
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                  color: i == selectedIndex
                                      ? Colors.white
                                      : Colors.black,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ),
                const Text(
                  'These answres will help us to find the best offers for you',
                  style: TextStyle(color: Color.fromARGB(255, 175, 175, 175)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(7000, 50),
                    backgroundColor: const Color.fromARGB(255, 66, 103, 178),
                  ),
                  onPressed: () async {
                    _sendInterest();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(
                          userDocumentID: widget.userDocumentID,
                        ),
                      ),
                    );
                  },
                  child: const Text('Done!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
