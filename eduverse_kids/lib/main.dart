import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const EduVerseKidsApp());
}

class EduVerseKidsApp extends StatelessWidget {
  const EduVerseKidsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduMiQa',
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
  String kidName = '';
  int kidAge = 4;

  bool isLoading = true;
  bool isRegistered = false;
  final TextEditingController nameController = TextEditingController();
  int tempAge = 4;

  // New Navigation and Profile Switching states
  int currentBottomNavIdx = 0;
  List<Map<String, dynamic>> savedProfiles = [];
  final FlutterTts flutterTts = FlutterTts();

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
    {'letter': 'L', 'word': 'Lion', 'malay': 'Singa', 'emoji': '🦁', 'desc': 'L is for Lion! Singa gagah raja rimba.'},
    {'letter': 'M', 'word': 'Monkey', 'malay': 'Monyet', 'emoji': '🐒', 'desc': 'M is for Monkey! Monyet suka makan pisang.'},
    {'letter': 'N', 'word': 'Net', 'malay': 'Jaring', 'emoji': '🕸️', 'desc': 'N is for Net! Jaring labah-labah yang halus.'},
    {'letter': 'O', 'word': 'Orange', 'malay': 'Oren', 'emoji': '🍊', 'desc': 'O is for Orange! Buah oren kaya dengan vitamin C.'},
    {'letter': 'P', 'word': 'Panda', 'malay': 'Panda', 'emoji': '🐼', 'desc': 'P is for Panda! Panda suka makan daun buluh.'},
    {'letter': 'Q', 'word': 'Queen', 'malay': 'Ratu', 'emoji': '👑', 'desc': 'Q is for Queen! Ratu memakai mahkota emas.'},
    {'letter': 'R', 'word': 'Rabbit', 'malay': 'Arnab', 'emoji': '🐰', 'desc': 'R is for Rabbit! Arnab melompat sangat laju.'},
    {'letter': 'S', 'word': 'Sun', 'malay': 'Matahari', 'emoji': '☀️', 'desc': 'S is for Sun! Matahari menyinari bumi yang indah.'},
    {'letter': 'T', 'word': 'Tiger', 'malay': 'Harimau', 'emoji': '🐯', 'desc': 'T is for Tiger! Harimau belang gagah berani.'},
    {'letter': 'U', 'word': 'Umbrella', 'malay': 'Payung', 'emoji': '☂️', 'desc': 'U is for Umbrella! Payung pelindung daripada hujan.'},
    {'letter': 'V', 'word': 'Violin', 'malay': 'Biola', 'emoji': '🎻', 'desc': 'V is for Violin! Gesekan biola menghasilkan muzik merdu.'},
    {'letter': 'W', 'word': 'Watch', 'malay': 'Jam Tangan', 'emoji': '⌚', 'desc': 'W is for Watch! Jam menunjukkan waktu belajar.'},
    {'letter': 'X', 'word': 'Xylophone', 'malay': 'Xilofon', 'emoji': '🎼', 'desc': 'X is for Xylophone! Ketuk alat muzik xilofon.'},
    {'letter': 'Y', 'word': 'Yo-Yo', 'malay': 'Yo-Yo', 'emoji': '🪀', 'desc': 'Y is for Yo-Yo! Main yo-yo turun dan naik.'},
    {'letter': 'Z', 'word': 'Zebra', 'malay': 'Kuda Belang', 'emoji': '🦓', 'desc': 'Z is for Zebra! Kuda belang berwarna hitam putih.'}
  ];

  final List<Map<String, String>> hijaiyahCards = [
    {'letter': 'ا', 'name': 'Alif', 'emoji': '🐰', 'word': 'Arnab', 'desc': 'Ah-lif! Bunyi huruf permulaan nama Arnab.'},
    {'letter': 'ب', 'name': 'Ba', 'emoji': '⚽', 'word': 'Bola', 'desc': 'Ba! Ada satu biji titik di bawah mangkuk.'},
    {'letter': 'ت', 'name': 'Ta', 'emoji': '✍️', 'word': 'Tangan', 'desc': 'Ta! Dua titis titik comel menghias di atas.'},
    {'letter': 'ث', 'name': 'Tsa', 'emoji': '👕', 'word': 'Thoub', 'desc': 'Tsa! Tiga butir mutiara berkumpul di atas.'},
    {'letter': 'ج', 'name': 'Jim', 'emoji': '⛰️', 'word': 'Jabal', 'desc': 'Jim! Satu permata terkunci di dalam perut.'},
    {'letter': 'ح', 'name': 'Ha', 'emoji': '🍬', 'word': 'Halwa', 'desc': 'Ha! Kosong, bersih tiada sebarang titik.'},
    {'letter': 'خ', 'name': 'Kho', 'emoji': '🐑', 'word': 'Kharuf', 'desc': 'Kho! Satu titik di atas kepala.'},
    {'letter': 'د', 'name': 'Dal', 'emoji': '🐓', 'word': 'Dik', 'desc': 'Dal! Badan melengkung comel berdiri tegak.'},
    {'letter': 'ذ', 'name': 'Dzal', 'emoji': '🐺', 'word': 'Dzi\'b', 'desc': 'Dzal! Seperti Dal tetapi ada satu permata di atas.'},
    {'letter': 'ر', 'name': 'Ro', 'emoji': '👨', 'word': 'Rajul', 'desc': 'Ro! Meluncur ke bawah seperti papan gelongsor.'},
    {'letter': 'ز', 'name': 'Zai', 'emoji': '🌸', 'word': 'Zahrah', 'desc': 'Zai! Macam Ro tapi ada satu titik di atas.'},
    {'letter': 'س', 'name': 'Sin', 'emoji': '🐟', 'word': 'Samakah', 'desc': 'Sin! Dua mangkuk kecil dan satu mangkuk besar.'},
    {'letter': 'ش', 'name': 'Syin', 'emoji': '☀️', 'word': 'Syams', 'desc': 'Syin! Sin yang memakai tiga mahkota titik.'},
    {'letter': 'ص', 'name': 'Shod', 'emoji': '📦', 'word': 'Shunduq', 'desc': 'Shod! Bermula dengan gelung bulat lalu mangkuk besar.'},
    {'letter': 'ض', 'name': 'Dhod', 'emoji': '🐸', 'word': 'Dhafda', 'desc': 'Dhod! Shod yang mempunyai sebutir titik di atas.'},
    {'letter': 'ط', 'name': 'Tho', 'emoji': '✈️', 'word': 'Thoerah', 'desc': 'Tho! Gelung bulat bersayap tiang tegak.'},
    {'letter': 'ظ', 'name': 'Zho', 'emoji': '✉️', 'word': 'Zharf', 'desc': 'Zho! Tho yang bersinar dengan satu titik di atas.'},
    {'letter': 'ع', 'name': 'Ain', 'emoji': '👁️', 'word': 'Ain', 'desc': 'Ain! Separuh bulatan kecil dan separuh bulatan besar.'},
    {'letter': 'غ', 'name': 'Ghoin', 'emoji': '🌲', 'word': 'Ghabah', 'desc': 'Ghoin! Ain yang memakai sebiji titik di atas.'},
    {'letter': 'ف', 'name': 'Fa', 'emoji': '🐘', 'word': 'Fil', 'desc': 'Fa! Kepala bulat kecil, badan rata berserta titik di atas.'},
    {'letter': 'ق', 'name': 'Qof', 'emoji': '🖊️', 'word': 'Qalam', 'desc': 'Qof! Mangkuk bulat dalam dengan dua titik di atas.'},
    {'letter': 'ك', 'name': 'Kaf', 'emoji': '🐕', 'word': 'Kalb', 'desc': 'Kaf! Kerusi panjang dengan hamzah kecil di tengah.'},
    {'letter': 'ل', 'name': 'Lam', 'emoji': '🍋', 'word': 'Laymun', 'desc': 'Lam! Pemegang payung yang melengkung panjang.'},
    {'letter': 'م', 'name': 'Mim', 'emoji': '🔑', 'word': 'Miftah', 'desc': 'Mim! Kepala bulat kecil tunduk ke bawah.'},
    {'letter': 'ن', 'name': 'Nun', 'emoji': '🌟', 'word': 'Najm', 'desc': 'Nun! Mangkuk bulat dalam dengan satu titik di tengah.'},
    {'letter': 'و', 'name': 'Wau', 'emoji': '🌹', 'word': 'Wardah', 'desc': 'Wau! Kepala bulat bergolek turun ke bawah.'},
    {'letter': 'هـ', 'name': 'Ha', 'emoji': '🐱', 'word': 'Hirrah', 'desc': 'Ha! Bulatan besar yang mengandungi bulatan kecil.'},
    {'letter': 'ء', 'name': 'Hamzah', 'emoji': '✨', 'word': 'Hawa\'', 'desc': 'Hamzah! Si kecil yang berdiri bebas.'},
    {'letter': 'ي', 'name': 'Ya', 'emoji': '🖐️', 'word': 'Yad', 'desc': 'Ya! Bentuk seperti itik berenang dengan dua titik di bawah.'}
  ];

  final List<Map<String, dynamic>> numberCards = [
    {'value': 0, 'text': 'Kosong', 'emoji': '🪄', 'desc': 'Kotak ajaib kosong!'},
    {'value': 1, 'text': 'Satu', 'emoji': '🦁', 'desc': 'Satu ekor singa yang comel!'},
    {'value': 2, 'text': 'Dua', 'emoji': '🐰', 'desc': 'Dua ekor kelinci ceria melompat!'},
    {'value': 3, 'text': 'Tiga', 'emoji': '🧁', 'desc': 'Tiga biji cupcake manis berkrim!'},
    {'value': 4, 'text': 'Empat', 'emoji': '🚂', 'desc': 'Empat gerabak kereta api bergerak!'},
    {'value': 5, 'text': 'Lima', 'emoji': '⭐', 'desc': 'Lima butir bintang berkerlipan di langit!'},
    {'value': 6, 'text': 'Enam', 'emoji': '🦀', 'desc': 'Enam ekor ketam berjalan mengiring!'},
    {'value': 7, 'text': 'Tujuh', 'emoji': '🌈', 'desc': 'Tujuh warna pelangi indah di langit!'},
    {'value': 8, 'text': 'Lapan', 'emoji': '🐙', 'desc': 'Lapan kaki sotong gurita melambai!'},
    {'value': 9, 'text': 'Sembilan', 'emoji': '🎈', 'desc': 'Sembilan biji belon warna-warni terbang tinggi!'}
  ];

  @override
  void initState() {
    super.initState();
    loadKidData();
    generateQuiz();
    generateMath();
  }

  Future<void> speakText(String text) async {
    await flutterTts.setLanguage('ms-MY');
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(text);
  }

  Future<void> loadKidData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load saved profiles list
    final String? profilesJson = prefs.getString('saved_profiles_list');
    if (profilesJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(profilesJson);
        savedProfiles = List<Map<String, dynamic>>.from(decoded);
      } catch (e) {
        savedProfiles = [];
      }
    }

    final String? savedName = prefs.getString('kid_name');
    final int? savedAge = prefs.getInt('kid_age');
    if (savedName != null && savedAge != null) {
      // Find matching profile or default
      final activeProfile = savedProfiles.firstWhere(
        (p) => p['name'] == savedName,
        orElse: () => <String, dynamic>{},
      );
      setState(() {
        kidName = savedName;
        kidAge = savedAge;
        stars = activeProfile['stars'] ?? 15;
        isRegistered = true;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveKidData(String name, int age) async {
    final prefs = await SharedPreferences.getInstance();
    
    int existingIdx = savedProfiles.indexWhere((p) => p['name'].toString().toLowerCase() == name.toLowerCase());
    int profileStars = 15;
    
    if (existingIdx != -1) {
      profileStars = savedProfiles[existingIdx]['stars'] ?? 15;
      savedProfiles[existingIdx]['age'] = age;
    } else {
      savedProfiles.add({
        'name': name,
        'age': age,
        'stars': 15,
      });
    }
    
    await prefs.setString('kid_name', name);
    await prefs.setInt('kid_age', age);
    await prefs.setString('saved_profiles_list', jsonEncode(savedProfiles));
    
    setState(() {
      kidName = name;
      kidAge = age;
      stars = profileStars;
      isRegistered = true;
      currentBottomNavIdx = 0;
    });
  }

  Future<void> addStars(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      stars += amount;
    });
    int idx = savedProfiles.indexWhere((p) => p['name'] == kidName);
    if (idx != -1) {
      savedProfiles[idx]['stars'] = stars;
      await prefs.setString('saved_profiles_list', jsonEncode(savedProfiles));
    }
  }

  Future<void> logoutKid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('kid_name');
    await prefs.remove('kid_age');
    setState(() {
      kidName = '';
      isRegistered = false;
      nameController.clear();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    flutterTts.stop();
    super.dispose();
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
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFF9E6),
        body: Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }

    if (!isRegistered) {
      return buildRegistrationScreen();
    }

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
          'EduMiQa 🧸 - $kidName',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Chip(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide.none,
              label: Text(
                '⭐ $stars Bintang',
                style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.black87),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: currentBottomNavIdx == 0
            ? Column(
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
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87),
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
                                mascotSpeech = 'Mula belajar abjad, Jawi, dan Nombor!';
                              });
                            },
                            child: const Text('📚 Belajar', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedTab == 'Teka Ria' ? Colors.pink : Colors.pink.shade100,
                              foregroundColor: selectedTab == 'Teka Ria' ? Colors.white : Colors.pink.shade900,
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
                            child: const Text('🎯 Teka Ria', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedTab == 'Math' ? Colors.teal : Colors.teal.shade100,
                              foregroundColor: selectedTab == 'Math' ? Colors.white : Colors.teal.shade900,
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
                            child: const Text('➕ Math Ria', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
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
              )
            : currentBottomNavIdx == 1
                ? SubwayMathGame(
                    kidName: kidName,
                    onStarsEarned: (earned) {
                      addStars(earned);
                    },
                  )
                : currentBottomNavIdx == 2
                    ? buildRankingTab()
                    : buildProfileTab(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentBottomNavIdx,
        onTap: (idx) {
          setState(() {
            currentBottomNavIdx = idx;
          });
        },
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Belajar & Main',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: 'Subway Math',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Ranking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
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
              label: const Text('🕌 Jawi', style: TextStyle(fontWeight: FontWeight.bold)),
              selected: activeSubCategory == 'AlifBaTa',
              selectedColor: Colors.pink.shade300,
              onSelected: (val) {
                setState(() => activeSubCategory = 'AlifBaTa');
              },
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('🔟 Nombor', style: TextStyle(fontWeight: FontWeight.bold)),
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
            colorGradient: [Colors.orange.shade100, Colors.orange.shade200!],
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
            colorGradient: [Colors.teal.shade100!, Colors.teal.shade200!],
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
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.black87),
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
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange.shade900,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
            ),
            onPressed: () {
              String speakVal = "";
              if (activeSubCategory == 'ABC') {
                speakVal = "$headerText. $title. $desc";
              } else if (activeSubCategory == 'AlifBaTa') {
                speakVal = "$title. $desc";
              } else {
                speakVal = "$title. $desc";
              }
              speakText(speakVal);
            },
            icon: const Icon(Icons.volume_up, size: 20),
            label: const Text('Dengar Sebutan 🔊', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
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
              foregroundColor: Colors.black87,
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
              backgroundColor: Colors.black87,
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
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.black87),
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
                                addStars(5);
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
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.pink),
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
                    fontWeight: FontWeight.w900, 
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
              // Show Emojis physically to help kid visualize addition/subtraction
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (mathOperator == '+') ...[
                    Wrap(
                      children: List.generate(mathNum1, (i) => const Text('🍓', style: TextStyle(fontSize: 26))),
                    ),
                    const SizedBox(width: 12),
                    const Text('+', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.teal)),
                    const SizedBox(width: 12),
                    Wrap(
                      children: List.generate(mathNum2, (i) => const Text('🍓', style: TextStyle(fontSize: 26))),
                    ),
                  ] else ...[
                    Wrap(
                      spacing: 4,
                      children: List.generate(mathNum1, (i) {
                        final isSubtracted = i >= (mathNum1 - mathNum2);
                        if (!isSubtracted) {
                          return const Text('🍓', style: TextStyle(fontSize: 26));
                        } else {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: 0.2,
                                child: const Text('🍓', style: TextStyle(fontSize: 26)),
                              ),
                              const Text('❌', style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),
                            ],
                          );
                        }
                      }),
                    ),
                  ]
                ],
              ),
              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$mathNum1 $mathOperator $mathNum2 = ?',
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.teal),
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

                  Color btnColors = Colors.teal.shade100!;
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
                                addStars(5);
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
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
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

  Widget buildRegistrationScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.orange.shade300, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.15),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo/Icon Game
                  Image.asset(
                    'assets/icon/icon.png',
                    width: 120,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) => const Text('🧸', style: TextStyle(fontSize: 80)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'EduMiQa 🧸',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Kembara Pembelajaran Kanak-Kanak Ceria!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Mascot speech
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Row(
                      children: [
                        Text('🦖', style: TextStyle(fontSize: 36)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Hai kawan baru! Masukkan nama panggilan dan umur anda di bawah untuk mula bermain!',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Name Input
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nama Panggilan Anda:',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Syakir, Alya, Adam...',
                      hintStyle: TextStyle(color: Colors.grey.shade300),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.face, color: Colors.orange),
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  
                  // Age Selector
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Umur Anda:',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [2, 3, 4, 5, 6, 7, 8].map((age) {
                      final isSelected = tempAge == age;
                      // Emojis based on age
                      final emojis = {2: '🐰', 3: '🦊', 4: '🦖', 5: '🦁', 6: '🐨', 7: '🐯', 8: '🐼'};
                      final emoji = emojis[age] ?? '🧸';
                      return InkWell(
                        onTap: () {
                          setState(() {
                            tempAge = age;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.orange : Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isSelected ? Colors.deepOrange : Colors.orange.shade100,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(emoji, style: const TextStyle(fontSize: 20)),
                              const SizedBox(height: 2),
                              Text(
                                '$age Tahun',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.orange.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                  
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        final enteredName = nameController.text.trim();
                        if (enteredName.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sila masukkan nama panggilan anda dahulu! 🧸'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else {
                          saveKidData(enteredName, tempAge);
                        }
                      },
                      child: const Text(
                        'Jom Mula Kembara! 🚀',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRankingTab() {
    // Merge actual player with mock players for presentation
    List<Map<String, dynamic>> ranks = List.from(savedProfiles);
    if (ranks.isEmpty) {
      ranks = [
        {'name': kidName, 'age': kidAge, 'stars': stars},
        {'name': 'Adik Haziq', 'age': 6, 'stars': 95},
        {'name': 'Adik Alya', 'age': 5, 'stars': 80},
        {'name': 'Adik Danish', 'age': 7, 'stars': 45},
      ];
    }
    
    // Ensure current kid is in list
    if (ranks.indexWhere((p) => p['name'] == kidName) == -1) {
      ranks.add({'name': kidName, 'age': kidAge, 'stars': stars});
    }

    ranks.sort((a, b) => (b['stars'] as int).compareTo(a['stars'] as int));

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            '🏆 Carta Juara EduMiQa',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ranks.length,
          itemBuilder: (context, index) {
            final player = ranks[index];
            final isCurrent = player['name'] == kidName;
            
            // Badges
            String badge = '🏅';
            if (index == 0) badge = '🥇';
            if (index == 1) badge = '🥈';
            if (index == 2) badge = '🥉';

            return Card(
              color: isCurrent ? Colors.orange.shade50 : Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: isCurrent ? Colors.orange : Colors.grey.shade200,
                  width: isCurrent ? 2 : 1,
                ),
              ),
              child: ListTile(
                leading: Text(badge, style: const TextStyle(fontSize: 28)),
                title: Text(
                  player['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCurrent ? Colors.orange.shade900 : Colors.black87,
                  ),
                ),
                subtitle: Text('${player['age']} Tahun'),
                trailing: Chip(
                  backgroundColor: Colors.orange.shade100,
                  label: Text(
                    '⭐ ${player['stars']} Bintang',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Current Profile Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade300, Colors.orange.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(color: Colors.orange.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
              ]
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Text('🦖', style: TextStyle(fontSize: 48)),
                ),
                const SizedBox(height: 12),
                Text(
                  kidName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                ),
                Text(
                  'Umur: $kidAge Tahun',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
                const SizedBox(height: 10),
                Chip(
                  backgroundColor: Colors.white,
                  label: Text(
                    '⭐ $stars Bintang Terkumpul',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Senarai profil sedia ada
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Tukar Profil (Adik-Adik Lain):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 8),
          if (savedProfiles.length <= 1)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'Tiada profil lain. Daftar adik baru untuk bertukar profil!',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: savedProfiles.length,
              itemBuilder: (context, index) {
                final p = savedProfiles[index];
                if (p['name'] == kidName) return const SizedBox();
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: const Text('👶', style: TextStyle(fontSize: 24)),
                    title: Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${p['age']} Tahun'),
                    trailing: const Icon(Icons.swap_horiz, color: Colors.orange),
                    onTap: () {
                      saveKidData(p['name'], p['age']);
                    },
                  ),
                );
              },
            ),
          const SizedBox(height: 20),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    setState(() {
                      isRegistered = false;
                      nameController.clear();
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Adik Baru 👶'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: logoutKid,
                  icon: const Icon(Icons.logout),
                  label: const Text('Log Keluar 🚪'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SubwayMathGame extends StatefulWidget {
  final String kidName;
  final Function(int) onStarsEarned;

  const SubwayMathGame({super.key, required this.kidName, required this.onStarsEarned});

  @override
  State<SubwayMathGame> createState() => _SubwayMathGameState();
}

class _SubwayMathGameState extends State<SubwayMathGame> {
  bool isPlaying = false;
  bool isGameOver = false;
  int gameScore = 0;
  int lives = 3;
  int dinoLane = 1; // 0: Top, 1: Middle, 2: Bottom

  int num1 = 1;
  int num2 = 1;
  String op = '+';
  int correctAns = 2;

  double gateX = 1.2;
  List<int> gateLanes = [0, 1, 2];
  List<int> gateOptions = [1, 2, 3];

  Timer? gameTimer;
  bool isHurt = false;
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
    generateNewQuestion();
  }

  void generateNewQuestion() {
    final random = Random();
    final isAdd = random.nextBool();
    op = isAdd ? '+' : '-';
    if (isAdd) {
      num1 = random.nextInt(5) + 1; // 1-5
      num2 = random.nextInt(4) + 1; // 1-4
      correctAns = num1 + num2;
    } else {
      num1 = random.nextInt(5) + 5; // 5-9
      num2 = random.nextInt(4) + 1; // 1-4
      correctAns = num1 - num2;
    }

    // Generate random options
    List<int> opts = [correctAns];
    while (opts.length < 3) {
      int o = correctAns + (random.nextBool() ? 1 : -1) * (random.nextInt(3) + 1);
      if (o >= 0 && !opts.contains(o)) {
        opts.add(o);
      }
    }
    opts.shuffle();

    setState(() {
      gateOptions = opts;
      gateLanes = [0, 1, 2]..shuffle();
      gateX = 1.2;
      isSuccess = false;
      isHurt = false;
    });
  }

  void startGame() {
    setState(() {
      isPlaying = true;
      isGameOver = false;
      gameScore = 0;
      lives = 3;
      dinoLane = 1;
      gateX = 1.2;
    });
    runGameLoop();
  }

  void runGameLoop() {
    gameTimer?.cancel();
    gameTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!isPlaying || isGameOver) {
        timer.cancel();
        return;
      }

      setState(() {
        gateX -= 0.025; // Move gates left
      });

      // Collision check when gates reach Dino's X position (approx x = 0.15)
      if (gateX <= 0.20 && gateX >= 0.10) {
        // Find which lane has the correct answer
        int correctLane = -1;
        for (int i = 0; i < 3; i++) {
          if (gateOptions[i] == correctAns) {
            correctLane = gateLanes[i];
            break;
          }
        }

        if (dinoLane == correctLane) {
          // HIT! Correct answer
          if (!isSuccess && !isHurt) {
            isSuccess = true;
            gameScore += 5;
            widget.onStarsEarned(5);
            // Trigger feedback and next question after a brief delay
            Future.delayed(const Duration(milliseconds: 400), () {
              if (mounted && isPlaying && !isGameOver) {
                generateNewQuestion();
              }
            });
          }
        } else {
          // WRONG! Hurt Dino
          if (!isHurt && !isSuccess) {
            setState(() {
              isHurt = true;
              lives -= 1;
              if (lives <= 0) {
                isGameOver = true;
                isPlaying = false;
              }
            });
            Future.delayed(const Duration(milliseconds: 600), () {
              if (mounted && isPlaying && !isGameOver) {
                generateNewQuestion();
              }
            });
          }
        }
      }

      // Reset if passed without collision
      if (gateX <= -0.1) {
        // Dino missed it completely
        if (!isSuccess && !isHurt) {
          setState(() {
            isHurt = true;
            lives -= 1;
            if (lives <= 0) {
              isGameOver = true;
              isPlaying = false;
            }
          });
        }
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted && isPlaying && !isGameOver) {
            generateNewQuestion();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isPlaying) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🏃 Subway Math Runner',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.orange),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Gerakkan Dino ke laluan dengan jawapan yang betul untuk kumpul Bintang! Elak langgar pagar salah.',
              style: TextStyle(fontSize: 14, color: Colors.blueGrey, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Tutorial graphic
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.shade200, width: 2),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 20,
                    top: 60,
                    child: const Text('🦖', style: TextStyle(fontSize: 40)),
                  ),
                  Positioned(
                    right: 40,
                    top: 20,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(10)),
                      child: const Text('4', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Positioned(
                    right: 40,
                    top: 60,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(10)),
                      child: const Text('5 (Betul! ✅)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Positioned(
                    right: 40,
                    top: 100,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(10)),
                      child: const Text('6', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                elevation: 4,
              ),
              onPressed: startGame,
              child: const Text(
                'Mula Bermain! 🚀',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      color: const Color(0xFFFFF9E6),
      child: Column(
        children: [
          // Top HUD
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(3, (i) {
                    return Icon(
                      i < lives ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                      size: 28,
                    );
                  }),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    'Skor: $gameScore',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                )
              ],
            ),
          ),

          // Math Question Bubble
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange, width: 2),
            ),
            child: Text(
              '$num1 $op $num2 = ?',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
          ),
          const SizedBox(height: 20),

          // Play Field (Lanes)
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final height = constraints.maxHeight;
                final width = constraints.maxWidth;

                return GestureDetector(
                  onTapDown: (details) {
                    final tapY = details.localPosition.dy;
                    if (tapY < height / 3) {
                      setState(() => dinoLane = 0);
                    } else if (tapY < 2 * height / 3) {
                      setState(() => dinoLane = 1);
                    } else {
                      setState(() => dinoLane = 2);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: height / 3,
                          left: 0,
                          right: 0,
                          child: Container(height: 2, color: Colors.grey.shade300),
                        ),
                        Positioned(
                          top: 2 * height / 3,
                          left: 0,
                          right: 0,
                          child: Container(height: 2, color: Colors.grey.shade300),
                        ),

                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 150),
                          left: 30,
                          top: (dinoLane * height / 3) + (height / 6) - 25,
                          child: Text(
                            isHurt
                                ? '💥'
                                : isSuccess
                                    ? '🦖✨'
                                    : '🦖',
                            style: const TextStyle(fontSize: 45),
                          ),
                        ),

                        ...List.generate(3, (idx) {
                          final lane = gateLanes[idx];
                          final val = gateOptions[idx];
                          final gateY = (lane * height / 3) + (height / 6) - 25;

                          return Positioned(
                            left: gateX * width,
                            top: gateY,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSuccess && val == correctAns
                                    ? Colors.green
                                    : isHurt && dinoLane == lane
                                        ? Colors.red
                                        : Colors.orange,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black26, blurRadius: 4)
                                ],
                              ),
                              child: Text(
                                val.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

