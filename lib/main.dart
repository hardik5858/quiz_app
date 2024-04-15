import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.red.shade50,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red.shade200
        )
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: Center(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(),
                    ),
                  );
                },
                child: Text('Start Quiz'),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Note :",style: TextStyle(color: Colors.red),),
                          Text("1 : After time Complete Automatic Swift next question",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15.0,color: Colors.white),
                          ),
                          Text("2 : One time option select",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15.0,color: Colors.white),
                          ),
                          Text("3 : Select wrong answered minus points",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15.0,color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40,)
                ],
              ),
            ),

          ],
        )
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool isAnswered = false;
  int secondsRemaining = 15;
  late Timer timer;
  int point=0;
  bool incorrectAnswered=false;

  List<Map<String, dynamic>> questions = [
    {
      'question': 'Which of the following is the capital of Arunachal Pradesh?',
      'options': ['A. Itanagar', 'B. Dispur', 'C. Imphal', 'D. Panaji'],
      'correctAnswer': 'A. Itanagar',
      'explanation': 'Itanagar is the capital of Arunachal Pradesh and is named after Ita fort which means fort of bricks, build around the 14 century AD.',
      'score': 100
    },
    {
      'question': 'What are the major languages spoken in Andhra Pradesh?',
      'options': ['A. Odia and Telugu', 'B. Telugu and Urdu', 'C. Telugu and Kannada', 'D. All of the above languages'],
      'correctAnswer': 'B. Telugu and Urdu',
      'explanation': 'Major languages spoken in Andhra Pradesh are Telugu, Urdu, Hindi, Banjara, and English followed by Tamil, Kannada, Marathi, and Odia.',
      'score': 100
    },
     {
      'question': 'What is the state flower of Haryana?',
      'options': ['A. Lotus', 'B. Rhododendron', 'C. Golden Shower', 'D. Not Declared'],
      'correctAnswer': 'A. Lotus',
      'explanation': ' Lotus or Water Lily is the state flower of Haryana. It is an aquatic plant with broad floating green leaves and bright fragrant flowers that grow only in shallow waters.',
      'score': 200
    },
     {
      'question': 'Which of the following states is not located in the North?',
      'options': ['A. Jharkhand', 'B. Jammu and Kashmir', 'C. Himachal Pradesh', 'D. Haryana'],
      'correctAnswer': 'A. Jharkhand',
      'explanation': 'Jharkhand state is not located in the North. It is located in the northeastern part of the country.',
      'score': 100
    },
    {
      'question': ' In which of the following state, the main language is Khasi?',
      'options': ['A. Mizoram', 'B. Nagaland', 'C. Meghalaya', 'D. Tripura'],
      'correctAnswer': 'C. Meghalaya',
      'explanation': 'Khasi language is primarily spoken in Meghalaya state in India by the Khasi people.',
      'score': 200
    },
    {
      'question': 'Which is the largest coffee-producing state of India?',
      'options': ['A. Kerala', 'B. Tamil Nadu', 'C. Karnataka', 'D. Arunachal Pradesh'],
      'correctAnswer': 'C. Karnataka',
      'explanation': ' Karnataka is the largest Coffee-producing state of India with 70.5% and is followed by Kerala, and Tamil Nadu.',
      'score': 100
    },
    {
      'question': 'Which state has the largest area?',
      'options': ['A. Maharashtra', 'B. Madhya Pradesh', 'C. Uttar Pradesh', 'D. Rajasthan'],
      'correctAnswer': 'D. Rajasthan',
      'explanation': 'In terms of area, Rajasthan is the largest state in India which covers 342,239 sq km and as per Census 2011, the total population of the state is about 68548437.',
      'score': 200
    },
    {
      'question': ' Which state has the largest population?',
      'options': ['A. Uttar Pradesh', 'B. Maharastra', 'C. Bihar', 'D. Andra Pradesh'],
      'correctAnswer': 'A. Uttar Pradesh',
      'explanation': 'Uttar Pradesh state has the largest population of more than 166 million. It is followed by Maharashtra and Bihar.',
      'score': 100
    },
    {
      'question': ' In what state is Elephant Falls located?',
      'options': ['A. Mizoram', 'B. Orissa', 'C. Manipur', 'D. Meghalaya'],
      'correctAnswer': 'D. Meghalaya',
      'explanation': 'It is amongst the most popular falls in the Northeast and is located on the outskirts of the capital city of Meghalaya.',
      'score': 200
    },
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          timer.cancel();
          nextQuestion();
        }
      });
    });
  }

  void answerQuestion(String selectedAnswer) {
    setState(() {
      isAnswered = true;
      timer.cancel();
      if (selectedAnswer == questions[currentQuestionIndex]['correctAnswer']) {
        score++;
        point=questions[currentQuestionIndex]['score'] + point;
        nextQuestion();
      }else{
        if(isAnswered){
          incorrectAnswered=true;
        }else{
          incorrectAnswered=false;
        }
      }
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        secondsRemaining = 15;
        isAnswered = false;
        startTimer();
        if(incorrectAnswered && !isAnswered){
          int s=questions[currentQuestionIndex-1]['score'] as int;
          point= (point - (s/2)) as int ;
        }
        incorrectAnswered=false;
      } else {
        timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(score: score, totalQuestions: questions.length, points: point,),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.blue.shade50,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: Text("Score ${point}",style: TextStyle(fontSize: 20),)
              ),
              SizedBox(height: 30,),
              Text(
                'Time Remaining: $secondsRemaining seconds',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.redAccent.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    questions[currentQuestionIndex]['question'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0,color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(
                    questions[currentQuestionIndex]['options'].length,
                        (index) {
                      String option = questions[currentQuestionIndex]['options'][index];
                      bool isCorrectAnswer = option == questions[currentQuestionIndex]['correctAnswer'];
        
                      return GestureDetector(
                        onTap: isAnswered ? null : () => answerQuestion(option),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isAnswered
                                ? (isCorrectAnswer ? Colors.green : Colors.red)
                                : Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              option,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: isAnswered ? nextQuestion : null,
                child: Text('Next'),
              ),
              if (isAnswered)
                Column(
                  children: [
                    SizedBox(height: 20.0),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Explanation: ${questions[currentQuestionIndex]['explanation']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.0),
                        )
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final int points;

  ResultScreen({required this.score, required this.totalQuestions,required this.points});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You scored $score out of $totalQuestions',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 10,),
            Text('You Points $points',
              style: TextStyle(fontSize: 20.0,),
            ),
            SizedBox(height: 10,),
            Text('You Currect Answere  $score',
              style: TextStyle(fontSize: 20.0),
            ),

            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text('Restart Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
