import 'package:flutter/material.dart';
import 'screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import this if you need access to the Assets class for the image constants

class ScoreBoard extends StatefulWidget {
  const ScoreBoard({Key? key}) : super(key: key);

  @override
  ScoreBoardState createState() => ScoreBoardState();
}

class ScoreBoardState extends State<ScoreBoard> {
  int _score = 0;
  

  Map<String, dynamic> rewards= {};
  List<Map<String, dynamic>> items = [];


  @override
  void initState() {
    super.initState();
    _fetchRewards();
  }


  Future<void> _fetchRewards() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Rewards').get();
      List<Map<String, dynamic>> fetchedItems = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          "name": data['name'] ?? "No Name",
          "value": data['value'] ?? 0,
          "image": data['image'] ?? "https://media.giphy.com/media/RAquh63pTB2PerLhud/giphy.gif?cid=790b7611j2jvza4jigug2tb539his7mp1nwrvnkq3lvpzrva&ep=v1_stickers_search&rid=giphy.gif&ct=s"
        };
      }).toList();

      if (fetchedItems.isEmpty) {
        // Provide some default rewards if none are found in Firestore
        fetchedItems = [
          {"name": "Better Luck next time", "value": 0, "image": "https://media.giphy.com/media/RAquh63pTB2PerLhud/giphy.gif?cid=790b7611j2jvza4jigug2tb539his7mp1nwrvnkq3lvpzrva&ep=v1_stickers_search&rid=giphy.gif&ct=s"},
          {"name": "10 Points", "value": 10, "image":"https://www.freepnglogos.com/images/flipkart-logo-39907.html"},
          {"name": "20 Points", "value": 20, "image":"https://www.freepnglogos.com/images/logo-myntra-41464.html"},
        ];
      }

      setState(() {
        items = fetchedItems;
      });
    } catch (e) {
      print('Failed to fetch rewards: $e');
      // Provide some default rewards in case of an error
      setState(() {
        items = [
           {"name": "Better Luck next time", "value": 0, "image": "https://media.giphy.com/media/RAquh63pTB2PerLhud/giphy.gif?cid=790b7611j2jvza4jigug2tb539his7mp1nwrvnkq3lvpzrva&ep=v1_stickers_search&rid=giphy.gif&ct=s"},
          {"name": "10 Points", "value": 10, "image":"https://www.freepnglogos.com/images/flipkart-logo-39907.html"},
          {"name": "20 Points", "value": 20, "image":"https://www.freepnglogos.com/images/logo-myntra-41464.html"},
        ];
      });
    }
  }





  void updateScore(List<String> images) {
    Map<String, int> imageCounts = {};
    for (String image in images) {
      imageCounts[image] = (imageCounts[image] ?? 0) + 1;
    }

    int points = 0;
    if (imageCounts.values.any((count) => count == 3)) {
      points = imageCounts.entries.any((entry) => entry.key == Assets.seventhIc && entry.value == 3) ? 20 : 10;
    } else {
      points = 0;
    }

    setState(() {
      _score += points;
      rewards = items[_score];
    });

    if (rewards['value'] == 0 || rewards['name'].toLowerCase().contains('better luck next time')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Better luck next time!"),
                            backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("You just won ${rewards['name']} worth of ${rewards['value']}!"),
                            backgroundColor: Colors.green,
                        ),
                      );
                    }

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(
                                  rewards['image'],
                                  width: 100,
                                  height: 100,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace)
                                    {
                                        return Image.network(
                                          "https://media.giphy.com/media/RAquh63pTB2PerLhud/giphy.gif?cid=790b7611j2jvza4jigug2tb539his7mp1nwrvnkq3lvpzrva&ep=v1_stickers_search&rid=giphy.gif&ct=s",
                                          width: 100,
                                          height: 100
                                        );
                                    },
                              ),
                              SizedBox(height: 10),
                              Text(rewards['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Close"),
                            ),
                          ],
                        );
                      },
                    );



  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 50,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(100.0),
          topRight: Radius.circular(100.0),
        ),
        border: Border(
          top: BorderSide(width: 5.0, color: Color.fromARGB(255, 255, 235, 119)),
          left: BorderSide(width: 5.0, color: Color.fromARGB(255, 255, 235, 119)),
          right: BorderSide(width: 5.0, color: Color.fromARGB(255, 255, 235, 119)),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 255, 217, 0),
            blurRadius:20.0,
            spreadRadius: 5.0,
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         /* Image.asset("assets/images/icon.png"),*/
         /* Text(
            'Spin',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ), 
          Text(
            '$_score',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 235, 119),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),*/
        ],
      ),
    );
  }
}
