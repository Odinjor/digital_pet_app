import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  late Timer _hungerTimer;
  late Timer _winlossTimer;
  late Timer _activityTimer;
  final List<String> selectActivities = ['Run', 'Sleep', 'Default'];
  String selectedActivity = 'Default';

  late final TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    // Any initialization code can go here
    _controller = TextEditingController(
      text: petName.toString(),
    ); 

    _hungerTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel += 5;
        if (hungerLevel > 100) {
          hungerLevel = 100;
          happinessLevel -= 20;
        }
      });
    });

    _winlossTimer = Timer.periodic(const Duration(minutes: 3), (timer) {
      if (happinessLevel > 80) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Congratulations! Your pet is very happy! 🎉'),
            duration: const Duration(seconds: 3),
          ),
        );
        timer.cancel();
      } else if (hungerLevel == 0 && happinessLevel < 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Game Over! 😢'),
            duration: const Duration(seconds: 3),
          ),
        );
        timer.cancel();
      }
    });

    _activityTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _activityEffect();
    });
  }
    @override
  void dispose() {
    _controller.dispose();
    _hungerTimer.cancel();
    super.dispose();
  }



  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
  
      if (happinessLevel > 70) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text('😊 Happy'),
        duration: const Duration(seconds: 2),
        ),
        );
    } else if (happinessLevel >= 30) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text('😐 Neutral'),
        duration: const Duration(seconds: 2),
        ),
        );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text('😢 Sad'),
        duration: const Duration(seconds: 2),
        ),
        );
    }

  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }
    });


      if (happinessLevel > 70) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text('😊 Happy'),
        duration: const Duration(seconds: 2),
        ),
        );
    } else if (happinessLevel >= 30) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text('😐 Neutral'),
        duration: const Duration(seconds: 2),
        ),
        );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text('😢 Sad'),
        duration: const Duration(seconds: 2),
        ),
        );
    }
  }

  void _activityEffect() {
      if (selectedActivity == 'Run') { Timer(Duration(seconds: 1), () {
        setState(() {
        happinessLevel += 15;
        hungerLevel += 10;
      });
      }); }
      else if (selectedActivity == 'Sleep') { Timer(Duration(seconds: 1), () {
        setState(() {
        happinessLevel += 5;
        hungerLevel -= 5;
      }); 
      }); }
      else {
        happinessLevel += 0;
        hungerLevel += 0;
      }
    }


  Color _moodColor(double happinessLevel) {
  if (happinessLevel > 70) {
    return Colors.green;
  } else if (happinessLevel >= 30) {
    return Colors.yellow;
  } else {
    return Colors.red;
  }
  }

  String _moodImage(double happinessLevel) {
  if (happinessLevel > 70) {
    return 'assets/pet_happy.jpg';
  } else if (happinessLevel >= 30) {
    return 'assets/pet_neutral.jpg';
  } else {
    return 'assets/pet_sad.jpg';
  }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Name: $petName', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: _moodColor(double.parse(happinessLevel.toString())), width: 5.0),
              ),
              child: Center(
                child: Image.asset(
                  _moodImage(double.parse(happinessLevel.toString())),
                  fit: BoxFit.cover,
                ),
              ), 
            ),
            Text('Happiness Level: $happinessLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 32.0),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Your Pet's Name",
              ),
              onChanged: (value) {
                setState(() {
                  petName = value;
                });
              },
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
            value: selectedActivity,
            items: selectActivities
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) => setState(() => selectedActivity = value ?? selectedActivity),
          ),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
            SizedBox(height: 16.0),

          ],
        ),
      ),
      
    );
  }
}
