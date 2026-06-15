import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const EduVerseKidsApp());
}

class EduVerseKidsApp extends StatelessWidget {
  const EduVerseKidsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduVerse Kids App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Comic Sans MS', // Kid friendly font style fallback
        useMaterial3: true,
      ),
      home: const MainKidsScreen(),
    );
  }
}

class MainKidsScreen extends StatefulWidget {
  const MainKidsScreen({super.key});

  @override
  State<MainKidsScreen> createState() => _MainKidsScreenState();
}

class _MainKidsScreenState extends State<MainKidsScreen> {
  // App states
  int stars = 15;
  String selectedTab = 'Belajar'; // 'Belajar' | 'Teka Ria' | 'Math'
  String activeSubCategory = 'ABC'; // 'ABC' | 'AlifBaTa' | '1-0'
  String kidName = 'Adik Syakir';
  int kidAge = 4;

  // Indices
  int abcIdx = 0;
  int alifIdx = 0;
  int numberIdx = 0;

  // Active Mascot
  String mascotEmoji = '🦖';
  String mascotName = 'Cikgu Dino';
  String mascotSpeech = 'Hai kawan comel! Mari belajar bersama Cikgu hari ini! 🌟';

  // Interactive Math Ria state
  int mathNum1 = 3;
  int mathNum2 = 2;
  String mathOperator = '+';
  List<int> mathOptions = [4, 5, 6];
  int? mathChosenAns;
  String mathFeedback = '';

  // Interactive Quiz state
  Map<String, dynamic>? activeQuiz;
  String? quizSelectedAns;
  String quizFeedback = '';

  // Datapools
  final List<Map<String, String>> abcCards = [
    {'letter': 'A', 'word': 'Apple', 'malay': 'Epal', 'emoji': '🍎', 'desc': 'A is for Apple! Epal merah harum manis.'},
    {'letter': 'B', 'word': 'Ball', 'malay': 'Bola', 'emoji': '⚽', 'desc': 'B is for Ball! Bola bulat untuk main lompat-lompat.'},
    {'letter': 'C', 'word': 'Cat', 'malay': 'Kucing', 'emoji': '🐱', 'desc': 'C is for Cat! Bunyi kucing meow meow comel.'},
    {'letter': 'D', 'word': 'Duck', 'malay': 'Itik', 'emoji': '🦆', 'desc': 'D is for Duck! Itik berenang kuak kuak.'},
    {'letter': 'E', 'word': 'Elephant', 'malay': 'Gajah', 'emoji': '🐘', 'desc': 'E is for Elephant! Gajah berbelalai panjang.'},
    {'letter': 'F', 'word': 'Fish', 'malay': 'Ikan', 'emoji': '🐟', 'desc': 'F is for Fish! Ikan berenang dalam tasik air.'},
    {'letter': 'G', 'word': 'Giraffe', 'malay': 'Zirafah', 'emoji': '🦒', 'desc': 'G is for Giraffe! Zirafah berleher tinggi.'},
    {'letter': 'H', 'word': 'House', 'malay': 'Rumah', 'emoji': '🏠', 'desc': 'H is for House! Tempat berpijak keluarga penyayang.'},
    {'letter': 'I', 'word': 'Ice Cream', 'malay': 'Aiskrim', 'emoji': '🍦', 'desc': 'I is for Ice Cream! Aiskrim sejuk rasa vanila.'},
    {'letter': 'J', 'word': 'Jellyfish', 'malay': 'Obor-obor', 'emoji': '🪼', 'desc': 'J is for Jellyfish! Obor-obor comel.'},
    {'letter': 'K', 'word': 'Key', 'malay': 'Kunci', 'emoji': '🔑', 'desc': 'K is for Key! Kunci emas pembuka pintu.'},
    {'letter': 'L', 'word': 'Lion', 'malay': 'Singa', 'emoji': '🦁', 'desc': 'L is for Lion! Singa gagah raja rimba.'}
  ];

  final List<Map<String, String>> hijaiyahCards = [
    {'letter': 'ا', 'name': 'Alif', 'emoji': '🐰', 'word': 'Arnab', 'desc': 'Ah-lif! Bunyi huruf permulaan nama Arnab.'},
    {'letter': 'ب', 'name': 'Ba', 'emoji': '⚽', 'word': 'Bola', 'desc': 'Ba! Ada satu biji titik di bawah mangkuk.'},
    {'letter': 'ت', 'name': 'Ta', 'emoji': '✍️', 'word': 'Tangan', 'desc': 'Ta! Dua titis titik comel menghias di atas.'},
    {'letter': 'ث', 'name': 'Tsa', 'emoji': '👕', 'word': 'Thoub', 'desc': 'Tsa! Tiga butir mutiara berkumpul di atas.'},
    {'letter': 'ج', 'name': 'Jim', 'emoji': '⛰️', 'word': 'Jabal', 'desc': 'Jim! Satu permata terkunci di dalam perut.'},
    {'letter': 'ح', 'name': 'Ha', 'emoji': '🍬', 'word': 'Halwa', 'desc': 'Ha! Kosong, bersih tiada sebarang titik.'}
  ];

  final List<Map<String, dynamic>> numberCards = [
    {'value': 0, 'text': 'Kosong', 'emoji': '🪄', 'desc': 'Kotak ajaib kosong!'},
    {'value': 1, 'text': 'Satu', 'emoji': '🦁', 'desc': 'Satu ekor singa yang comel!'},
    {'value': 2, 'text': 'Dua', 'emoji': '🐰', 'desc': 'Dua ekor kelinci ceria melompat!'},
    {'value': 3, 'text': 'Tiga', 'emoji': '🧁', 'desc': 'Tiga biji cupcake manis berkrim!'},
    {'value': 4, 'text': 'Empat', 'emoji': '🚂', 'desc': 'Empat gerabak kereta api bergerak!'},
    {'value': 5, 'text': 'Lima', 'emoji': '⭐', 'desc': 'Lima butir bintang berkerlipan di langit!'}
  ];

  @override
  void initState() {
    super.initState();
    generateQuiz();
    generateMath();
  }

  void generateQuiz() {
    final random = Random();
    final isABCQuiz = random.nextBool();
    
    if (isABCQuiz) {
      final target = abcCards[random.nextInt(abcCards.length)];
      List<String> options = [target['letter']!];
      while (options.length < 3) {
        final opt = abcCards[random.nextInt(abcCards.length)]['letter']!;
        if (!options.contains(opt)) options.add(opt);
      }
      options.shuffle();
      setState(() {
        activeQuiz = {
          'emoji': target['emoji'],
          'prompt': 'Huruf awalan untuk gambar ${target['emoji']} (${target['word']})?',
          'correct': target['letter'],
          'options': options,
        };
        quizSelectedAns = null;
        quizFeedback = '';
      });
    } else {
      final target = hijaiyahCards[random.nextInt(hijaiyahCards.length)];
      List<String> options = [target['letter']!];
      while (options.length < 3) {
        final opt = hijaiyahCards[random.nextInt(hijaiyahCards.length)]['letter']!;
        if (!options.contains(opt)) options.add(opt);
      }
      options.shuffle();
      setState(() {
        activeQuiz = {
          'emoji': target['emoji'],
          'prompt': 'Yang manakah huruf Hijaiyah "${target['name']}"?',
          'correct': target['letter'],
          'options': options,
        };
        quizSelectedAns = null;
        quizFeedback = '';
      });
    }
  }

  void generateMath() {
    final random = Random();
    final op = random.nextBool() ? '+' : '-';
    int n1 = 0;
    int n2 = 0;
    int ans = 0;

    if (op == '+') {
      n1 = random.nextInt(4) + 1; // 1-4
      n2 = random.nextInt(3) + 1; // 1-3
      ans = n1 + n2;
    } else {
      n1 = random.nextInt(3) + 4; // 4-6
      n2 = random.nextInt(3) + 1; // 1-3
      ans = n1 - n2;
    }

    List<int> opts = [ans];
    while (opts.length < 3) {
      final fallbackOpt = random.nextInt(7) + 1;
      if (!opts.contains(fallbackOpt)) opts.add(fallbackOpt);
    }
    opts.shuffle();

    setState(() {
      mathNum1 = n1;
      mathNum2 = n2;
      mathOperator = op;
      mathOptions = opts;
      mathChosenAns = null;
      mathFeedback = '';
    });
  }

  void playBubbleSound() {
    // In Flutter, we can call HapticFeedback or sound libraries like audioplayers
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E6), // Child eye friendly warm white
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.orangeAccent, Colors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'EDUVERSE KIDS 🧸 - $kidName',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Chip(
              backgroundColor: Colors.white.withOpacity(0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide.none,
              label: Text(
                '⭐ $stars Bintang',
                style: const TextStyle(fontWeight: FontWeight.black, color: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Mascot Coach Message Bubble
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orangeAccent, width: 2),
                boxShadow: [
                  BoxShadow(color: Colors.orange.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 3))
                ]
              ),
              child: Row(
                children: [
                  Text(
                    mascotEmoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mascotName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.orange),
                        ),
                        Text(
                          '"$mascotSpeech"',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black85),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            // Tab Buttons: Belajar | Teka Ria | Math Ria
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedTab == 'Belajar' ? Colors.orange : Colors.orange.shade100,
                        foregroundColor: selectedTab == 'Belajar' ? Colors.white : Colors.orange.shade900,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: selectedTab == 'Belajar' ? 4 : 0,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedTab = 'Belajar';
                          mascotSpeech = 'Mula belajar abjad, Alif Ba Ta, dan Nombor!';
                        });
                      },
                      child: const Text('📚 Belajar', style: TextStyle(fontWeight: FontWeight.black, fontSize: 11)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedTab == 'Teka Ria' ? Colors.pink : Colors.pink.shade100,
                        foregroundColor: selectedTab == 'Teka Ria' ? Colors.white : Colors.pink.shade950,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: selectedTab == 'Teka Ria' ? 4 : 0,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedTab = 'Teka Ria';
                          mascotSpeech = 'Mari uji kecekapan anak kognitif anda!';
                        });
                        generateQuiz();
                      },
                      child: const Text('🎯 Teka Ria', style: TextStyle(fontWeight: FontWeight.black, fontSize: 11)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedTab == 'Math' ? Colors.teal : Colors.teal.shade100,
                        foregroundColor: selectedTab == 'Math' ? Colors.white : Colors.teal.shade950,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: selectedTab == 'Math' ? 4 : 0,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedTab = 'Math';
                          mascotSpeech = 'Kira buah-buahan comel bersama Cikgu Dino!';
                        });
                        generateMath();
                      },
                      child: const Text('➕ Math Ria', style: TextStyle(fontWeight: FontWeight.black, fontSize: 11)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Dynamic view based on active tab
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                child: selectedTab == 'Belajar'
                    ? buildStudyTab()
                    : selectedTab == 'Teka Ria'
                        ? buildQuizTab()
                        : buildMathTab(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Study Flashcard build sub-component
  Widget buildStudyTab() {
    return Column(
      children: [
        // Sub-Category selectors
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceChip(
              label: const Text('🆎 ABC', style: TextStyle(fontWeight: FontWeight.bold)),
              selected: activeSubCategory == 'ABC',
              selectedColor: Colors.orange.shade300,
              onSelected: (val) {
                setState(() => activeSubCategory = 'ABC');
              },
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('🕌 Alif Ba Ta', style: TextStyle(fontWeight: FontWeight.bold)),
              selected: activeSubCategory == 'AlifBaTa',
              selectedColor: Colors.pink.shade300,
              onSelected: (val) {
                setState(() => activeSubCategory = 'AlifBaTa');
              },
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('🔟 Nombor 1-0', style: TextStyle(fontWeight: FontWeight.bold)),
              selected: activeSubCategory == '1-0',
              selectedColor: Colors.teal.shade300,
              onSelected: (val) {
                setState(() => activeSubCategory = '1-0');
              },
            ),
          ],
        ),
        const SizedBox(height: 15),

        // Flash Card Display Box
        if (activeSubCategory == 'ABC') ...[
          buildCardFrame(
            emoji: abcCards[abcIdx]['emoji']!,
            headerText: abcCards[abcIdx]['letter']!,
            subtitle: 'untuk',
            title: abcCards[abcIdx]['word']!,
            malayTrans: 'Melayu: ' + abcCards[abcIdx]['malay']!,
            desc: abcCards[abcIdx]['desc']!,
            colorGradient: [Colors.orange.shade100, Colors.orange.shade250!],
          ),
          const SizedBox(height: 15),
          buildCardNavigators(
            onPrev: () => setState(() => abcIdx = (abcIdx == 0) ? abcCards.length - 1 : abcIdx - 1),
            onNext: () => setState(() => abcIdx = (abcIdx == abcCards.length - 1) ? 0 : abcIdx + 1),
          )
        ] else if (activeSubCategory == 'AlifBaTa') ...[
          buildCardFrame(
            emoji: hijaiyahCards[alifIdx]['emoji']!,
            headerText: hijaiyahCards[alifIdx]['letter']!,
            subtitle: 'Huruf',
            title: hijaiyahCards[alifIdx]['name']!,
            malayTrans: 'Contoh: ' + hijaiyahCards[alifIdx]['word']!,
            desc: hijaiyahCards[alifIdx]['desc']!,
            colorGradient: [Colors.pink.shade100, Colors.pink.shade200],
          ),
          const SizedBox(height: 15),
          buildCardNavigators(
            onPrev: () => setState(() => alifIdx = (alifIdx == 0) ? hijaiyahCards.length - 1 : alifIdx - 1),
            onNext: () => setState(() => alifIdx = (alifIdx == hijaiyahCards.length - 1) ? 0 : alifIdx + 1),
          )
        ] else ...[
          // Number cards
          buildCardFrame(
            emoji: numberCards[numberIdx]['emoji']!,
            headerText: numberCards[numberIdx]['value'].toString(),
            subtitle: 'Angka',
            title: numberCards[numberIdx]['text']!,
            malayTrans: '',
            desc: numberCards[numberIdx]['desc']!,
            colorGradient: [Colors.teal.shade150!, Colors.teal.shade250!],
            itemCount: numberCards[numberIdx]['value'] as int,
          ),
          const SizedBox(height: 15),
          buildCardNavigators(
            onPrev: () => setState(() => numberIdx = (numberIdx == 0) ? numberCards.length - 1 : numberIdx - 1),
            onNext: () => setState(() => numberIdx = (numberIdx == numberCards.length - 1) ? 0 : numberIdx + 1),
          )
        ],
      ],
    );
  }

  Widget buildCardFrame({
    required String emoji,
    required String headerText,
    required String subtitle,
    required String title,
    required String malayTrans,
    required String desc,
    required List<Color> colorGradient,
    int itemCount = 0,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colorGradient, begin: Alignment.topCenter, end: Alignment.bottomCenter),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.15), spreadRadius: 3, blurRadius: 10)
        ]
      ),
      child: Column(
        children: [
          // If numbers count, render tiny visuals
          if (itemCount > 0) ...[
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: List.generate(
                itemCount, 
                (index) => Text(emoji, style: const TextStyle(fontSize: 24))
              ),
            ),
            const SizedBox(height: 10),
          ],

          Text(emoji, style: const TextStyle(fontSize: 64)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                headerText,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.black, color: Colors.black85),
              ),
              const SizedBox(width: 8),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 18, color: Colors.blueGrey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepOrange),
          ),
          if (malayTrans.isNotEmpty) ...[
            Text(
              malayTrans,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(15)),
            child: Text(
              desc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCardNavigators({required VoidCallback onPrev, required VoidCallback onNext}) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black85,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.black12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: onPrev,
            child: const Text('◀️ Sebelum', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black85,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: onNext,
            child: const Text('Seterusnya ▶️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ),
      ],
    );
  }

  // Quiz Screen Layout
  Widget buildQuizTab() {
    if (activeQuiz == null) return const SizedBox();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.pink.shade200, width: 3),
          ),
          child: Column(
            children: [
              Text(activeQuiz!['emoji'], style: const TextStyle(fontSize: 72)),
              const SizedBox(height: 10),
              Text(
                activeQuiz!['prompt'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.black, fontSize: 14, color: Colors.black85),
              ),
              const SizedBox(height: 20),

              // 3 Choices
              ...List.generate(activeQuiz!['options'].length, (index) {
                final String opt = activeQuiz!['options'][index];
                final isSelected = quizSelectedAns == opt;
                final isAnswered = quizSelectedAns != null;

                Color tileBg = Colors.pink.shade50;
                if (isSelected) {
                  tileBg = (opt == activeQuiz!['correct']) ? Colors.green.shade100 : Colors.red.shade100;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: InkWell(
                    onTap: isAnswered
                        ? null
                        : () {
                            setState(() {
                              quizSelectedAns = opt;
                              if (opt == activeQuiz!['correct']) {
                                stars += 5;
                                quizFeedback = 'BETUL! Hebat adik $kidName! 🎉';
                                mascotSpeech = 'Sangat bijak anak pandai! Teruskan ya.';
                              } else {
                                quizFeedback = 'SALAH. Cuba lagi sayang! 💪';
                                mascotSpeech = 'Emm, takpe! Jom cuba sikit lagi kawan.';
                              }
                            });
                          },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        color: tileBg,
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Colors.pink.shade100,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          opt,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.black, color: Colors.pink),
                        ),
                      ),
                    ),
                  ),
                );
              }),

              if (quizFeedback.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  quizFeedback,
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.black, 
                    color: quizFeedback.contains('BETUL') ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: generateQuiz,
                  child: const Text('Soalan Seterusnya 🧸'),
                )
              ]
            ],
          ),
        )
      ],
    );
  }

  // Math Kid Screen
  Widget buildMathTab() {
    final actualAns = mathOperator == '+' ? (mathNum1 + mathNum2) : (mathNum1 - mathNum2);

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.teal.shade200, width: 3),
          ),
          child: Column(
            children: [
              // Show Emojis physically to help kid visualize addition
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(
                    children: List.generate(mathNum1, (i) => const Text('🍓', style: TextStyle(fontSize: 22))),
                  ),
                  const SizedBox(width: 8),
                  Text(mathOperator, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Wrap(
                    children: List.generate(mathNum2, (i) => const Text('🍓', style: TextStyle(fontSize: 22))),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$mathNum1 $mathOperator $mathNum2 = ?',
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.black, color: Colors.teal),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Math list options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: mathOptions.map((opt) {
                  final isAnswered = mathChosenAns != null;
                  final isSelected = mathChosenAns == opt;

                  Color btnColors = Colors.teal.shade150!;
                  if (isSelected) {
                    btnColors = (opt == actualAns) ? Colors.green.shade200 : Colors.red.shade200;
                  }

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnColors,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                    onPressed: isAnswered
                        ? null
                        : () {
                            setState(() {
                              mathChosenAns = opt;
                              if (opt == actualAns) {
                                stars += 5;
                                mathFeedback = 'Syabas! Betul! 🍓';
                                mascotSpeech = 'Dua tambah tiga jadi lima! Anak bijak Matematik.';
                              } else {
                                mathFeedback = 'Belum betul lagi. Jom kira sama-sama! ✨';
                                mascotSpeech = 'Oh, cuba kira semula ulas strawberi itu sayang.';
                              }
                            });
                          },
                    child: Text(
                      opt.toString(),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black85),
                    ),
                  );
                }).toList(),
              ),

              if (mathFeedback.isNotEmpty) ...[
                const SizedBox(height: 15),
                Text(
                  mathFeedback,
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                    color: mathFeedback.contains('Syabas') ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: generateMath,
                  child: const Text('Kira Lagi! ➕'),
                )
              ]
            ],
          ),
        )
      ],
    );
  }
}
