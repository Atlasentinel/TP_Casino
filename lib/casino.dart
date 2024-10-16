import 'dart:math'; 
import 'package:flutter/material.dart';

class Casino extends StatefulWidget {
  const Casino({super.key, required this.title});

  final String title;

  @override
  State<Casino> createState() => _CasinoState();
}

class _CasinoState extends State<Casino> with TickerProviderStateMixin {
  List<String> images = ["", "", ""];
  List<String> victoryMessages = [
    "TU ES RICHES !!!", "Bien joué mec", "Las Vegaaaaaaaas",
  ];
  List<String> looseMessages = [
    "Oooh non t'a perdue", "C'est pas grâve, recommence", "Ton argent = mon argent", "REMBOURSE L'ARGENT"
  ];
  String randomVictoryMessage = '';
  String randomLooseMessage = '';
  bool isBigWin = false;
  bool isWin = false;
  final List<AnimationController> _animationControllers = [];

  void getRandomImages() {
    setState(() {
      _animationControllers.forEach((controller) => controller.dispose());
      _animationControllers.clear();
      
      for (int i = 0; i < images.length; i++) {
        int randomNumber = Random().nextInt(7) + 1;
        images[i] = 'images/image$randomNumber.png';

        AnimationController controller = AnimationController(
          duration: const Duration(milliseconds: 500),
          vsync: this,
        );
        _animationControllers.add(controller);
        controller.forward();
      }
      checkWinCondition();
    });
  }

  void checkWinCondition() {
    if (images[0] == images[1] && images[0] == images[2]) {
      isBigWin = true;
      isWin = true;
      randomVictoryMessage = getRandomVictoryMessage();
    } else {
      isBigWin = false;
      isWin = false;
      randomLooseMessage = getRandomLooseMessage();
    }
  }

  String getRandomVictoryMessage() {
    int randomIndex = Random().nextInt(victoryMessages.length);
    return victoryMessages[randomIndex];
  }

  String getRandomLooseMessage() {
    int randomIndex = Random().nextInt(looseMessages.length);
    return looseMessages[randomIndex];
  }

  String getVictoryMessage() {
    if (isWin) {
      if (images[0] == "images/image7.png") {
        return "💲💲💲💲💲💲💲💲💲";
      } else if (images[0] == "images/image6.png") {
        return "🍒🍒🍒🍒🍒🍒";
      } else {
        return "Jackpot !";
      }
    }
    return 'Loose !';
  }

  @override
  void initState() {
    super.initState();
    getRandomImages();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isBigWin ? Colors.green : Colors.yellow,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        foregroundColor: isBigWin ? Colors.red : Colors.white,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i < images.length; i++)
                    FadeTransition(
                      opacity: _animationControllers[i].drive(
                        CurveTween(curve: Curves.easeIn),
                      ),
                      child: Image.asset(images[i], width: 200, height: 200),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                isWin ? randomVictoryMessage : randomLooseMessage,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                getVictoryMessage(),
                style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getRandomImages();
        },
        tooltip: 'Rejouer',
        child: const Icon(Icons.restart_alt),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        mini: true,
      ),
    );
  }
}
