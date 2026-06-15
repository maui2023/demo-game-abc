import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { 
  Sparkles, 
  BookOpen, 
  Heart, 
  Star, 
  Volume2, 
  RotateCcw, 
  Smartphone, 
  Home, 
  ShieldAlert, 
  Smile, 
  Calendar, 
  CheckCircle2, 
  AlertCircle, 
  Activity, 
  Award, 
  ArrowRight, 
  Settings, 
  Search, 
  FileCode, 
  ChevronRight,
  UserCheck,
  Zap,
  Info
} from 'lucide-react';

// Sound Synthesis using Web Audio API for offline high performance
class SoundEffect {
  private static ctx: AudioContext | null = null;
  private static getCtx() {
    if (!this.ctx) {
      this.ctx = new (window.AudioContext || (window as any).webkitAudioContext)();
    }
    return this.ctx;
  }
  
  public static playBubble() {
    try {
      const ctx = this.getCtx();
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();
      osc.connect(gain);
      gain.connect(ctx.destination);
      osc.type = 'sine';
      osc.frequency.setValueAtTime(300, ctx.currentTime);
      osc.frequency.exponentialRampToValueAtTime(1000, ctx.currentTime + 0.12);
      gain.gain.setValueAtTime(0.15, ctx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + 0.12);
      osc.start();
      osc.stop(ctx.currentTime + 0.12);
    } catch (e) {}
  }

  public static playSuccess() {
    try {
      const ctx = this.getCtx();
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();
      osc.connect(gain);
      gain.connect(ctx.destination);
      osc.type = 'triangle';
      osc.frequency.setValueAtTime(523.25, ctx.currentTime); // C5
      osc.frequency.setValueAtTime(659.25, ctx.currentTime + 0.08); // E5
      osc.frequency.setValueAtTime(783.99, ctx.currentTime + 0.16); // G5
      osc.frequency.setValueAtTime(1046.50, ctx.currentTime + 0.24); // C6
      gain.gain.setValueAtTime(0.2, ctx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + 0.4);
      osc.start();
      osc.stop(ctx.currentTime + 0.4);
    } catch (e) {}
  }

  public static playWrong() {
    try {
      const ctx = this.getCtx();
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();
      osc.connect(gain);
      gain.connect(ctx.destination);
      osc.type = 'sawtooth';
      osc.frequency.setValueAtTime(180, ctx.currentTime);
      osc.frequency.linearRampToValueAtTime(90, ctx.currentTime + 0.25);
      gain.gain.setValueAtTime(0.2, ctx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + 0.3);
      osc.start();
      osc.stop(ctx.currentTime + 0.3);
    } catch (e) {}
  }

  public static playTada() {
    try {
      const ctx = this.getCtx();
      const now = ctx.currentTime;
      [
        { f: 523, t: 0 },
        { f: 659, t: 0.08 },
        { f: 783, t: 0.16 },
        { f: 987, t: 0.24 },
        { f: 1174, t: 0.32 }
      ].forEach(note => {
        const osc = ctx.createOscillator();
        const gain = ctx.createGain();
        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.type = 'sine';
        osc.frequency.setValueAtTime(note.f, now + note.t);
        gain.gain.setValueAtTime(0.12, now + note.t);
        gain.gain.exponentialRampToValueAtTime(0.01, now + note.t + 0.2);
        osc.start(now + note.t);
        osc.stop(now + note.t + 0.2);
      });
    } catch (e) {}
  }
}

// Speak text out loud using native browser speech synthesis
function speak(phrase: string, lang: 'ms-MY' | 'en-US' = 'ms-MY') {
  if ('speechSynthesis' in window) {
    window.speechSynthesis.cancel();
    const utterance = new SpeechSynthesisUtterance(phrase);
    
    // Attempt to set matching voice
    const voices = window.speechSynthesis.getVoices();
    let isSet = false;
    if (lang === 'ms-MY') {
      // Find Indonesian voice as fallback for Malay if Malay is unavailable
      const idVoice = voices.find(v => v.lang.startsWith('id') || v.lang.startsWith('ms'));
      if (idVoice) {
        utterance.voice = idVoice;
        utterance.lang = idVoice.lang;
        isSet = true;
      }
    }
    
    if (!isSet) {
      utterance.lang = lang;
    }
    
    // Slower speed for kids to understand easily
    utterance.rate = 0.85;
    utterance.pitch = 1.1; // Sightly higher pitch to sound cute/friendlier
    window.speechSynthesis.speak(utterance);
  }
}

// English ABC Kids Word Pool
const ABC_CARDS = [
  { letter: "A", word: "Apple", malayWord: "Epal", emoji: "🍎", audioText: "A is for Apple! Epal merah yang manis.", color: "from-rose-400 to-red-500" },
  { letter: "B", word: "Ball", malayWord: "Bola", emoji: "⚽", audioText: "B is for Ball! Bola bulat untuk main lompat-lompat.", color: "from-amber-400 to-orange-500" },
  { letter: "C", word: "Cat", malayWord: "Kucing", emoji: "🐱", audioText: "C is for Cat! Bunyi kucing meow meow comel.", color: "from-sky-400 to-blue-500" },
  { letter: "D", word: "Duck", malayWord: "Itik", emoji: "🦆", audioText: "D is for Duck! Itik berenang kuak kuak.", color: "from-amber-300 to-yellow-500" },
  { letter: "E", word: "Elephant", malayWord: "Gajah", emoji: "🐘", audioText: "E is for Elephant! Gajah berbelalai panjang.", color: "from-pink-400 to-rose-500" },
  { letter: "F", word: "Fish", malayWord: "Ikan", emoji: "🐟", audioText: "F is for Fish! Ikan berenang dalam tasik air.", color: "from-emerald-400 to-teal-500" },
  { letter: "G", word: "Giraffe", malayWord: "Zirafah", emoji: "🦒", audioText: "G is for Giraffe! Zirafah berleher tinggi.", color: "from-yellow-400 to-amber-500" },
  { letter: "H", word: "House", malayWord: "Rumah", emoji: "🏠", audioText: "H is for House! Tempat tinggal keluarga penyayang.", color: "from-indigo-400 to-purple-500" },
  { letter: "I", word: "Ice Cream", malayWord: "Aiskrim", emoji: "🍦", audioText: "I is for Ice Cream! Aiskrim sejuk rasa vanila.", color: "from-fuchsia-400 to-pink-500" },
  { letter: "J", word: "Jellyfish", malayWord: "Obor-obor", emoji: "🪼", audioText: "J is for Jellyfish! Obor-obor lembut dalam laut.", color: "from-violet-400 to-indigo-500" },
  { letter: "K", word: "Key", malayWord: "Kunci", emoji: "🔑", audioText: "K is for Key! Kunci emas untuk buka pintu.", color: "from-yellow-400 to-orange-500" },
  { letter: "L", word: "Lion", malayWord: "Singa", emoji: "🦁", audioText: "L is for Lion! Singa herois raja rimba auuuum.", color: "from-orange-400 to-amber-600" },
  { letter: "M", word: "Monkey", malayWord: "Monyet", emoji: "🐒", audioText: "M is for Monkey! Monyet nakal yang suka pisang.", color: "from-amber-500 to-yellow-600" },
  { letter: "N", word: "Nut", malayWord: "Kacang", emoji: "🥜", audioText: "N is for Nut! Kacang garing kegemaran tupai.", color: "from-emerald-500 to-teal-600" },
  { letter: "O", word: "Orange", malayWord: "Oren", emoji: "🍊", audioText: "O is for Orange! Buah oren penuh Vitamin C masam manis.", color: "from-orange-400 to-red-400" },
  { letter: "P", word: "Panda", malayWord: "Panda", emoji: "🐼", audioText: "P is for Panda! Beruang panda bulat berbulu comel.", color: "from-slate-400 to-slate-600" },
  { letter: "Q", word: "Queen", malayWord: "Ratu", emoji: "👸", audioText: "Q is for Queen! Ratu mahkota anggun berseri.", color: "from-purple-400 to-pink-600" },
  { letter: "R", word: "Rabbit", malayWord: "Arnab", emoji: "🐰", audioText: "R is for Rabbit! Arnab bertelinga panjang lompat laju.", color: "from-blue-400 to-sky-500" },
  { letter: "S", word: "Star", malayWord: "Bintang", emoji: "⭐", audioText: "S is for Star! Bintang berkerlip tinggi di langit malam.", color: "from-yellow-300 to-amber-400" },
  { letter: "T", word: "Train", malayWord: "Kereta Api", emoji: "🚂", audioText: "T is for Train! Kereta api bergerak tut tut tut.", color: "from-teal-400 to-green-500" },
  { letter: "U", word: "Umbrella", malayWord: "Payung", emoji: "☂️", audioText: "U is for Umbrella! Lindung anda dari hujan.", color: "from-indigo-400 to-fuchsia-400" },
  { letter: "V", word: "Violin", malayWord: "Biola", emoji: "🎻", audioText: "V is for Violin! Gesekan muzik indah menenangkan.", color: "from-orange-500 to-red-600" },
  { letter: "W", word: "Watermelon", malayWord: "Tembikai", emoji: "🍉", audioText: "W is for Watermelon! Tembikai besar berisi merah manis.", color: "from-green-500 to-red-500" },
  { letter: "X", word: "Xylophone", malayWord: "Xilofon", emoji: "🎼", audioText: "X is for Xylophone! Muzik ketukan warna-warni.", color: "from-pink-500 to-purple-600" },
  { letter: "Y", word: "Yogurt", malayWord: "Dadih", emoji: "🥛", audioText: "Y is for Yogurt! Minuman yogurt khasiat tinggi.", color: "from-cyan-400 to-blue-500" },
  { letter: "Z", word: "Zebra", malayWord: "Kuda Belang", emoji: "🦓", audioText: "Z is for Zebra! Kuda belang cantik berlari padang.", color: "from-zinc-500 to-slate-700" }
];

// Arabic/Hijaiyah Letter pool with kid cartoon guides
const HIJAIYAH_CARDS = [
  { letter: "ا", name: "Alif", emoji: "🐔", word: "Arnab", pronunciation: "Ah-lif! Macam huruf A jom sebut Alif.", color: "from-pink-400 to-rose-400" },
  { letter: "ب", name: "Ba", emoji: "⚽", word: "Bola", pronunciation: "Ba! Ada satu titik di bawah mangkuk.", color: "from-amber-400 to-orange-400" },
  { letter: "ت", name: "Ta", emoji: "✋", word: "Tangan", pronunciation: "Ta! Dua titik di atas mangkuk senyum.", color: "from-yellow-400 to-lime-500" },
  { letter: "ث", name: "Tsa", emoji: "👕", word: "Thoub", pronunciation: "Tsa! Mangkuk dengan tiga buah bintik ceria.", color: "from-emerald-400 to-teal-500" },
  { letter: "ج", name: "Jim", emoji: "⛰️", word: "Jabal", pronunciation: "Jim! Ada satu mutiara comel dalam perut buncit.", color: "from-cyan-400 to-blue-500" },
  { letter: "ح", name: "Ha", emoji: "🍬", word: "Halwa", pronunciation: "Ha! Bersih gembira tanpa ada sebarang titik.", color: "from-violet-400 to-indigo-500" },
  { letter: "خ", name: "Kha", emoji: "🍞", word: "Khubz", pronunciation: "Kha! Ada satu titik berteduh di atas bumbung.", color: "from-fuchsia-400 to-pink-500" },
  { letter: "د", name: "Dal", emoji: "🌳", word: "Dharah", pronunciation: "Dal! Seperti paruh burung kecil yang terbuka.", color: "from-rose-400 to-orange-500" },
  { letter: "ذ", name: "Dzal", emoji: "🐺", word: "Dzi'b", pronunciation: "Dzal! Sepupu Dal yang ada bintik bintang di atas kepala.", color: "from-amber-300 to-yellow-500" },
  { letter: "ر", name: "Ra", emoji: "🍉", word: "Rumman", pronunciation: "Ra! Meluncur laju seperti buaian taman.", color: "from-emerald-400 to-green-600" },
  { letter: "ز", name: "Zain", emoji: "🌸", word: "Zahrah", pronunciation: "Zain! Bersinar cantik dengan bintik di atas buaian.", color: "from-cyan-400 to-teal-500" },
  { letter: "س", name: "Sin", emoji: "🐟", word: "Samak", pronunciation: "Sin! Gigi kecil bergigi tiga yang comel meliuk.", color: "from-blue-400 to-sky-600" },
  { letter: "ش", name: "Syin", emoji: "☀️", word: "Syams", pronunciation: "Syin! Gigi berhias tiga butir buah anggur manis.", color: "from-indigo-500 to-purple-600" },
  { letter: "ص", name: "Shod", emoji: "📦", word: "Shunduq", pronunciation: "Shod! Perut berlipat tegap penuh keberanian.", color: "from-yellow-400 to-amber-500" },
  { letter: "ض", name: "Dhod", emoji: "💡", word: "Dhow'", pronunciation: "Dhod! Bersinar terang ada sekuntum cahaya hijau.", color: "from-pink-400 to-rose-600" },
  { letter: "ط", name: "Tho", emoji: "✈️", word: "Thoyyar", pronunciation: "Tho! Sedia terbang tinggi menggapai awan biru.", color: "from-emerald-500 to-emerald-700" },
  { letter: "ظ", name: "Zho", emoji: "💅", word: "Zhifr", pronunciation: "Zho! Bentuk Tho dengan sebutir permata istimewa.", color: "from-teal-400 to-blue-500" },
  { letter: "ع", name: "Ain", emoji: "🍇", word: "Inab", pronunciation: "Ain! Seperti mulut kecil yang sedang menyanyi asyik.", color: "from-sky-400 to-indigo-500" },
  { letter: "غ", name: "Ghoin", emoji: "🦌", word: "Ghozal", pronunciation: "Ghoin! Mulut menyanyi berserta hiasan titik comel.", color: "from-purple-400 to-fuchsia-500" },
  { letter: "ف", name: "Fa", emoji: "🐘", word: "Fil", pronunciation: "Fa! Mangkuk bersimpuh bulat satu permata.", color: "from-fuchsia-400 to-rose-500" },
  { letter: "ق", name: "Qof", emoji: "✏️", word: "Qalam", pronunciation: "Qof! Menulis ilmu bernas dengan dua bintik emas.", color: "from-slate-600 to-slate-800" },
  { letter: "ك", name: "Kaf", emoji: "📖", word: "Kitab", pronunciation: "Kaf! Ada bendera kecil melambai-lambai riang.", color: "from-blue-500 to-sky-700" },
  { letter: "ل", name: "Lam", emoji: "🥛", word: "Laban", pronunciation: "Lam! Lekukan sauh kapal sedia berlabuh pagi.", color: "from-indigo-400 to-cyan-500" },
  { letter: "م", name: "Mim", emoji: "🍌", word: "Mauz", pronunciation: "Mim! Ekor panjang melorot ke bawah mencuba.", color: "from-orange-400 to-yellow-500" },
  { letter: "ن", name: "Nun", emoji: "⭐", word: "Najm", pronunciation: "Nun! Mangkuk sup besar dengan sebiji bakso di tengah.", color: "from-teal-400 to-green-500" },
  { letter: "و", name: "Wau", emoji: "🌹", word: "Wardah", pronunciation: "Wau! Bulat comel menggelongsor turun pantas.", color: "from-pink-500 to-purple-500" },
  { letter: "ه", name: "Ha kecil", emoji: "🌙", word: "Hilal", pronunciation: "Haa! Lingkaran bulat berpusat gembira bersinar.", color: "from-red-400 to-orange-400" },
  { letter: "ي", name: "Ya", emoji: "👋", word: "Yad", pronunciation: "Ya! Seperti itik comel berenang riang di tasik.", color: "from-cyan-400 to-teal-500" }
];

// Numbers 0 - 10 Visual Database
const NUMBER_CARDS = [
  { value: 0, text: "Kosong", itemsEmoji: "🪄", count: 0, desc: "Tiada apa-apa di dalam kotak ajaib!", color: "from-slate-400 to-slate-500" },
  { value: 1, text: "Satu", itemsEmoji: "🦁", count: 1, desc: "Satu ekor singa gagah perkasa!", color: "from-red-400 to-rose-500" },
  { value: 2, text: "Dua", itemsEmoji: "🐰", count: 2, desc: "Kelinci melompat riang!", color: "from-orange-400 to-amber-500" },
  { value: 3, text: "Tiga", itemsEmoji: "🧁", count: 3, desc: "Cupcake berkrim ceri sedap!", color: "from-yellow-400 to-lime-500" },
  { value: 4, text: "Empat", itemsEmoji: "🚂", count: 4, desc: "Gerabak kereta api bersambung!", color: "from-emerald-400 to-teal-500" },
  { value: 5, text: "Lima", itemsEmoji: "⭐", count: 5, desc: "Bintang di langit tinggi melambai!", color: "from-cyan-400 to-blue-500" },
  { value: 6, text: "Enam", itemsEmoji: "🍎", count: 6, desc: "Epal manis merah rangup masak!", color: "from-indigo-400 to-purple-500" },
  { value: 7, text: "Tujuh", itemsEmoji: "🎈", count: 7, desc: "Belon terbang bebas ditiup angin!", color: "from-fuchsia-400 to-pink-500" },
  { value: 8, text: "Lapan", itemsEmoji: "🐟", count: 8, desc: "Ikan comel berenang gembira!", color: "from-pink-400 to-rose-500" },
  { value: 9, text: "Sembilan", itemsEmoji: "🐱", count: 9, desc: "Anak kucing berkejaran berbulu gebu!", color: "from-rose-500 to-rose-700" },
  { value: 10, text: "Sepuluh", itemsEmoji: "🍓", count: 10, desc: "Strawberi manis menyegarkan minda!", color: "from-teal-500 to-emerald-600" }
];

// Pre-defined Kids Characters / Mascots
const MASCOTS = [
  { id: 'dino', name: 'Cikgu Dino', emoji: '🦖', color: 'bg-emerald-150 border-emerald-400 text-emerald-800' },
  { id: 'panda', name: 'Cikgu Panda', emoji: '🐼', color: 'bg-slate-100 border-slate-300 text-slate-800' },
  { id: 'kitten', name: 'Adik Meow', emoji: '🐱', color: 'bg-pink-100 border-pink-300 text-pink-800' }
];

export default function App() {
  // Mobile Frame Device vs Fullscreen web toggle
  const [useDeviceFrame, setUseDeviceFrame] = useState(true);

  // App Core State
  const [activeTab, setActiveTab] = useState<'study' | 'quiz' | 'math' | 'cikguAi' | 'parents'>('study');
  const [subCategory, setSubCategory] = useState<'abc' | 'alifBaTa' | 'numbers'>('abc');
  const [selectedMascot, setSelectedMascot] = useState('dino');
  const [kidName, setKidName] = useState('Adik Syakir');
  const [kidAge, setKidAge] = useState(4);

  // Kid Score & Achievements System for game mechanics
  const [stars, setStars] = useState(15);
  const [correctCount, setCorrectCount] = useState(0);
  const [totalAttempted, setTotalAttempted] = useState(0);
  const [unlockedBadges, setUnlockedBadges] = useState<string[]>(['Murid Bijak']);

  // Current Card Viewer Indices
  const [abcIdx, setAbcIdx] = useState(0);
  const [hijaiyahIdx, setHijaiyahIdx] = useState(0);
  const [numberIdx, setNumberIdx] = useState(0);

  // Gamified interactive Quiz state (English / Arabic / Numbers)
  const [quizTask, setQuizTask] = useState<any>(null);
  const [quizType, setQuizType] = useState<'abc' | 'alif' | 'number_match'>('abc');
  const [quizScore, setQuizScore] = useState(0);
  const [answerStatus, setAnswerStatus] = useState<'idle' | 'right' | 'wrong'>('idle');
  const [selectedAns, setSelectedAns] = useState<any>(null);
  const [streak, setStreak] = useState(0);

  // Interactive Math Ria game values
  const [mathNum1, setMathNum1] = useState(2);
  const [mathNum2, setMathNum2] = useState(1);
  const [mathOperator, setMathOperator] = useState<'+' | '-'>('+');
  const [mathOptions, setMathOptions] = useState<number[]>([1, 2, 3]);
  const [mathChosenAns, setMathChosenAns] = useState<number | null>(null);
  const [mathStatus, setMathStatus] = useState<'idle' | 'right' | 'wrong'>('idle');

  // Parents AI Card Generator States (Full stack endpoint proxy)
  const [parentTopic, setParentTopic] = useState('Haiwan Laut');
  const [isGeneratingAi, setIsGeneratingAi] = useState(false);
  const [aiGeneratedCards, setAiGeneratedCards] = useState<any[]>([]);
  const [aiCurrentCardIdx, setAiCurrentCardIdx] = useState(0);
  const [aiError, setAiError] = useState<string | null>(null);
  const [aiIsFallback, setAiIsFallback] = useState(false);

  // Mascot Message Bubble helper
  const [mascotBubble, setMascotBubble] = useState('Hai kawan comel! Mari belajar bersenang-senang dengan cikgu hari ini! 🌟');

  // Parents View Sub tabs state
  const [parentSubTab, setParentSubTab] = useState<'profile' | 'flutter' | 'apk'>('profile');
  const [flutterCopied, setFlutterCopied] = useState(false);

  // Launch initial greetings and voices
  useEffect(() => {
    // Welcoming talk
    speak(`Hai ${kidName}! Selamat datang ke game belajar seronok. Hari ini kita nak belajar apa?`, 'ms-MY');
  }, []);

  const getMascotObj = () => {
    return MASCOTS.find(m => m.id === selectedMascot) || MASCOTS[0];
  };

  const handleMascotSpeech = (phrase: string, lang: 'ms-MY' | 'en-US' = 'ms-MY') => {
    setMascotBubble(phrase);
    speak(phrase, lang);
  };

  // Sound generator helpers
  const triggerTickSuccess = () => {
    SoundEffect.playSuccess();
    setStars(prev => prev + 5);
    setCorrectCount(prev => prev + 1);
    setTotalAttempted(prev => prev + 1);
    setAnswerStatus('right');
    const rewards = ['Wah! Bijaknya awak! 👍', 'Sangat tepat sekali! 🌟', 'Anda memang hebat! 🎉', 'Yey, jawapan ini betul! ❤️'];
    const text = rewards[Math.floor(Math.random() * rewards.length)];
    setMascotBubble(text);
    speak(text, 'ms-MY');

    setStreak(prev => {
      const nextStreak = prev + 1;
      if (nextStreak === 5 && !unlockedBadges.includes('Bintang Cemerlang')) {
        setUnlockedBadges(prevB => [...prevB, 'Bintang Cemerlang']);
        speak("Tahniah! Anda memenangi pingat Bintang Cemerlang kerana 5 jawapan berturut-turut!", 'ms-MY');
      }
      return nextStreak;
    });
  };

  const triggerTickWrong = () => {
    SoundEffect.playWrong();
    setTotalAttempted(prev => prev + 1);
    setAnswerStatus('wrong');
    setStreak(0);
    const retryPhrases = ['Alahai, cuba lagi ya kawan comel! 🦖', 'Kurang tepat, tapi anda sangat berani mencuba! 💪', 'Mari kita cuba pilihan jawapan yang lain! 🎈'];
    const text = retryPhrases[Math.floor(Math.random() * retryPhrases.length)];
    setMascotBubble(text);
    speak(text, 'ms-MY');
  };

  // Generate customized visual Quiz questions based on sub-demographics
  const generateNewQuiz = (typeOfQuiz?: 'abc' | 'alif' | 'number_match') => {
    const finalType = typeOfQuiz || quizType;
    setAnswerStatus('idle');
    setSelectedAns(null);

    if (finalType === 'abc') {
      // Pick random letter flashcard
      const randomCard = ABC_CARDS[Math.floor(Math.random() * ABC_CARDS.length)];
      // Grab 2 other random options
      const otherCards = ABC_CARDS.filter(c => c.letter !== randomCard.letter);
      const shuffledOthers = [...otherCards].sort(() => 0.5 - Math.random()).slice(0, 2);
      const choices = [randomCard.letter, shuffledOthers[0].letter, shuffledOthers[1].letter].sort(() => 0.5 - Math.random());
      
      setQuizTask({
        emoji: randomCard.emoji,
        prompt: `Apakah huruf awal bagi gambar: ${randomCard.emoji} (${randomCard.word})?`,
        correctAnswer: randomCard.letter,
        options: choices,
        hint: `Bunyi kata bermula dengan huruf '${randomCard.letter}'`
      });

      setMascotBubble(`Adik ${kidName}, nyatakan huruf yang betul untuk gambar ${randomCard.emoji} ini!`);
      speak(`Adik ${kidName}, nyatakan huruf yang betul untuk gambar ${randomCard.emoji}!`, 'ms-MY');
    } 
    else if (finalType === 'alif') {
      const randomCard = HIJAIYAH_CARDS[Math.floor(Math.random() * HIJAIYAH_CARDS.length)];
      const otherCards = HIJAIYAH_CARDS.filter(c => c.letter !== randomCard.letter);
      const shuffledOthers = [...otherCards].sort(() => 0.5 - Math.random()).slice(0, 2);
      const choices = [randomCard, shuffledOthers[0], shuffledOthers[1]].sort(() => 0.5 - Math.random());

      setQuizTask({
        audioPhrase: `Cari yang manakah huruf: ${randomCard.name}`,
        prompt: `Cari huruf Hijaiyah berwarna-warni bagi nama: "${randomCard.name}"`,
        correctAnswer: randomCard.letter,
        options: choices, // stores whole cards
        hint: `Huruf Alif Ba Ta bagi ${randomCard.name} bertulis ${randomCard.letter}`
      });

      setMascotBubble(`Sila cari dan tunjukkan kepada saya mana satu huruf "${randomCard.name}"... 🕌`);
      speak(`Sila cari mana satu huruf ${randomCard.name}`, 'ms-MY');
    } 
    else {
      // Number match
      const randomCard = NUMBER_CARDS.filter(n => n.value > 0)[Math.floor(Math.random() * (NUMBER_CARDS.length - 1))];
      const otherNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].filter(n => n !== randomCard.value);
      const shuffledOthers = [...otherNumbers].sort(() => 0.5 - Math.random()).slice(0, 2);
      const choices = [randomCard.value, shuffledOthers[0], shuffledOthers[1]].sort(() => 0.5 - Math.random());

      setQuizTask({
        value: randomCard.value,
        emojiCode: randomCard.itemsEmoji,
        prompt: `Kira dengan bertenang kemas. Berapakah bilangan item ini?`,
        correctAnswer: randomCard.value,
        options: choices,
        hint: `Jom kira bersama-sama dari satu ke atas.`
      });

      setMascotBubble(`Sila kira berapa objek ${randomCard.itemsEmoji} yang anda nampak di skrin! 🍰`);
      speak(`Kira berapa objek yang anda nampak di skrin!`, 'ms-MY');
    }
  };

  // Change quiz type from selection buttons
  const selectQuizTypeTab = (type: 'abc' | 'alif' | 'number_match') => {
    SoundEffect.playBubble();
    setQuizType(type);
    generateNewQuiz(type);
  };

  const checkQuizAnswer = (chosenOpt: any) => {
    if (answerStatus !== 'idle') return;
    setSelectedAns(chosenOpt);
    
    const isCorrect = chosenOpt === quizTask.correctAnswer;
    if (isCorrect) {
      triggerTickSuccess();
    } else {
      triggerTickWrong();
    }
  };

  // Simple kids math interactive generator
  const generateNewMathQuestion = () => {
    setMathChosenAns(null);
    setMathStatus('idle');

    // Simple values for kids 3-6 (never answer exceeding 10)
    const op = Math.random() > 0.5 ? '+' : '-';
    let n1 = 1;
    let n2 = 1;
    let ans = 2;

    if (op === '+') {
      n1 = Math.floor(Math.random() * 5) + 1; // 1-5
      n2 = Math.floor(Math.random() * 4) + 1; // 1-4
      ans = n1 + n2;
    } else {
      n1 = Math.floor(Math.random() * 5) + 5; // 5-9
      n2 = Math.floor(Math.random() * 4) + 1; // 1-4
      ans = n1 - n2;
    }

    setMathNum1(n1);
    setMathNum2(n2);
    setMathOperator(op);

    // Options generator
    const f1 = ans + 1;
    const f2 = ans - 1 >= 0 ? ans - 1 : ans + 2;
    const combinedOptions = Array.from(new Set([ans, f1, f2])).slice(0, 3).sort(() => 0.5 - Math.random());

    setMathOptions(combinedOptions);

    const spokenPrompt = `Berapakah ${n1} tambah ${n1} ?`;
    setMascotBubble(`Dua kumpulan buah! Jom kira: ${n1} ${op === '+' ? 'tambah' : 'tolak'} ${n2} jadi berapa?`);
    speak(`Kira bersama Cikgu, ${n1} ${op === '+' ? 'tambah' : 'tolak'} ${n2} sama dengan berapa adik manis?`, 'ms-MY');
  };

  const checkMathAnswer = (chosen: number) => {
    if (mathStatus !== 'idle') return;
    setMathChosenAns(chosen);

    const actualAns = mathOperator === '+' ? (mathNum1 + mathNum2) : (mathNum1 - mathNum2);
    if (chosen === actualAns) {
      triggerTickSuccess();
      setMathStatus('right');
      
      // Check for math champion badge
      if (stars >= 50 && !unlockedBadges.includes('Johan Matematik')) {
        setUnlockedBadges(prev => [...prev, 'Johan Matematik']);
        speak("Hebat! Anda membawa pulang pingat Johan Matematik Cilik!", 'ms-MY');
      }
    } else {
      triggerTickWrong();
      setMathStatus('wrong');
    }
  };

  // Parent AI custom card synthesis trigger
  const handleGenerateCustomCards = async () => {
    if (!parentTopic.trim()) {
      alert('Sila taipkan satu topik bermakna.');
      return;
    }
    
    setIsGeneratingAi(true);
    setAiError(null);
    setAiGeneratedCards([]);
    setAiIsFallback(false);
    SoundEffect.playBubble();

    try {
      const response = await fetch('/api/ai/generate-kids-cards', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ topic: parentTopic })
      });
      const data = await response.json();
      if (data.success && data.cards) {
        setAiGeneratedCards(data.cards);
        setAiCurrentCardIdx(0);
        if (data.isFallback) {
          setAiIsFallback(true);
        }
        SoundEffect.playTada();
        
        // Let Mascot Speak Out aloud about new custom topics
        handleMascotSpeech(`Wow, Cikgu AI berjaya membina kad baru mengena ${parentTopic}! Mari kita belajar bersama-sama. 🦖`, 'ms-MY');
      } else {
        setAiError(data.error || 'Server tidak dapat memproses maklumat.');
      }
    } catch (e) {
      setAiError('Mengalami isu rangkaian semasa menghubungi server Cikgu AI.');
    } finally {
      setIsGeneratingAi(false);
    }
  };

  // Fast switch category audio
  const handleCategorySwitch = (cat: 'abc' | 'alifBaTa' | 'numbers') => {
    SoundEffect.playBubble();
    setSubCategory(cat);
    if (cat === 'abc') {
      handleMascotSpeech(`Mari mulakan pengenalan huruf abjad inggeris A hingga Z kawan!`, 'ms-MY');
    } else if (cat === 'alifBaTa') {
      handleMascotSpeech(`Mari belajar melafaz huruf Hijaiyah bertema Alif Ba Ta dengan tartil murni.`, 'ms-MY');
    } else {
      handleMascotSpeech(`Jom kita belajar mengira nombor kosong sampai sepuluh!`, 'ms-MY');
    }
  };

  const getPercentageAccuracy = () => {
    if (totalAttempted === 0) return 100;
    return Math.round((correctCount / totalAttempted) * 100);
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-orange-50 via-yellow-50 to-amber-100 text-slate-800 font-sans antialiased selection:bg-pink-200">
      
      {/* Top Playful Ribbon Bar Header */}
      <header className="bg-gradient-to-r from-pink-500 via-orange-400 to-yellow-400 text-white shadow-md">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-3 flex flex-wrap items-center justify-between gap-4">
          
          <div className="flex items-center space-x-3 cursor-pointer" onClick={() => speak("Selamat Datang ke EduVerse Kid!", 'ms-MY')}>
            <span className="text-3xl animate-bounce">🎈</span>
            <div>
              <h1 className="text-xl sm:text-2xl font-extrabold tracking-tight drop-shadow-sm flex items-center gap-1.5 font-mono">
                EDUVERSE <span className="text-yellow-100 text-sm bg-black/20 px-2 py-0.5 rounded-full font-sans">KIDS APP 🧸</span>
              </h1>
              <p className="text-xs text-orange-50 font-medium">Syurga Pembelajaran Asas Anak Berumur 3-6 Tahun</p>
            </div>
          </div>

          {/* Kid Profile and Coin/Star Box */}
          <div className="flex items-center space-x-4">
            <div className="bg-white/20 backdrop-blur-sm px-3.5 py-1.5 rounded-full flex items-center space-x-2 border border-white/30">
              <span className="text-lg">⭐</span>
              <span className="font-mono font-black text-sm text-yellow-100">X {stars} Bintang</span>
            </div>

            <div className="bg-white/25 px-3 py-1 rounded-full text-xs font-bold font-sans flex items-center space-x-1.5">
              <span>👤</span>
              <span className="text-white">{kidName} ({kidAge} Thn)</span>
            </div>
          </div>

        </div>
      </header>

      {/* Main Container Container */}
      <main className="max-w-6xl mx-auto px-4 py-6">
        
        {/* Toggle between Web presentation & Tablet simulator Wrapper */}
        <div className="flex items-center justify-between mb-4 bg-white/60 p-2.5 rounded-xl border border-orange-100">
          <div className="flex items-center space-x-2 text-xs font-semibold text-orange-700">
            <Info className="h-4 w-4 text-orange-500 shrink-0" />
            <span>Mempunyai antaramuka adaptif untuk tablet & smartphone! Sedia dibina sebagai app Android/iOS asli.</span>
          </div>
          
          <button
            id="toggle_app_frame"
            onClick={() => {
              SoundEffect.playBubble();
              setUseDeviceFrame(!useDeviceFrame);
            }}
            className="flex items-center space-x-1.5 px-3 py-1.5 rounded-lg text-xs font-extrabold cursor-pointer transition-all bg-gradient-to-r from-orange-400 to-pink-500 hover:opacity-95 text-white shadow-sm"
          >
            <Smartphone className="h-3.5 w-3.5" />
            <span>{useDeviceFrame ? 'Lihat Skrin Penuh' : 'Lihat Simulasi App Mobile'}</span>
          </button>
        </div>

        {/* CORE APP WRAPPER: If useDeviceFrame is true, wrap in iPad frame, else keep responsive */}
        <div className={useDeviceFrame ? "flex items-center justify-center py-4" : ""}>
          
          <div className={useDeviceFrame ? "w-full max-w-[440px] aspect-[9/18] min-h-[820px] bg-slate-900 rounded-[48px] p-4.5 shadow-2xl border-[10px] border-slate-700 flex flex-col justify-between relative overflow-hidden" : "bg-white/80 backdrop-blur-md rounded-3xl p-6 shadow-xl border border-orange-100 flex flex-col justify-between"}>
            
            {/* SIMULATED DEVICE TOP HARDWARE BAR */}
            {useDeviceFrame && (
              <div className="absolute top-0 inset-x-0 h-8 bg-slate-900 rounded-t-[38px] flex items-center justify-between px-8 text-[11px] text-white/90 z-20 font-mono">
                <span>9:41 pagi</span>
                <div className="w-16 h-5 bg-black rounded-b-xl absolute left-1/2 transform -translate-x-1/2 z-30"></div>
                <div className="flex items-center space-x-1.5">
                  <span>📶</span>
                  <span>🔋 99%</span>
                </div>
              </div>
            )}

            {/* MAIN PORTABLE SMARTPHONE APP PANEL CANVAS */}
            <div className={`${useDeviceFrame ? "flex-1 mt-6 rounded-[32px] bg-white overflow-y-auto flex flex-col justify-between border-2 border-slate-950 p-4.5 custom-scroll pb-16" : "flex-1 flex flex-col justify-between"}`}>
              
              {/* Mascot Bubble guidance at the top of App screen */}
              <div className="bg-gradient-to-r from-amber-50 to-orange-50 border-2 border-amber-300 rounded-2xl p-3.5 mb-4 flex items-start space-x-2.5 relative">
                <span className="text-3xl animate-bounce transform origin-center shrink-0">
                  {getMascotObj().emoji}
                </span>
                
                <div className="flex-1">
                  <span className="block text-[10px] font-black uppercase text-amber-600 tracking-wider">
                    {getMascotObj().name}
                  </span>
                  <p className="text-xs sm:text-sm font-bold text-slate-700 leading-relaxed">
                    "{mascotBubble}"
                  </p>
                </div>

                <button
                  onClick={() => speak(mascotBubble, 'ms-MY')}
                  title="Main Audio Maskot"
                  className="rounded-full bg-orange-400 hover:bg-orange-500 text-white p-1.5 shrink-0 self-center shadow cursor-pointer transition-transform hover:scale-105"
                >
                  <Volume2 className="h-4.5 w-4.5" />
                </button>
              </div>

              {/* SECTION CONTROLLERS: TABS FOR SCREEN MODES */}
              <div className="grid grid-cols-5 gap-1 mb-5 bg-orange-100/60 p-1.5 rounded-2xl">
                <button
                  id="tab_study"
                  onClick={() => {
                    SoundEffect.playBubble();
                    setActiveTab('study');
                  }}
                  className={`flex flex-col items-center justify-center py-2.5 rounded-xl transition-all relative ${activeTab === 'study' ? 'bg-white text-orange-600 shadow-md scale-102 font-black' : 'text-slate-650 hover:bg-white/40'}`}
                >
                  <span className="text-xl">📚</span>
                  <span className="text-[10px] font-black tracking-tighter mt-1">Belajar</span>
                </button>

                <button
                  id="tab_quiz"
                  onClick={() => {
                    SoundEffect.playBubble();
                    setActiveTab('quiz');
                    generateNewQuiz();
                  }}
                  className={`flex flex-col items-center justify-center py-2.5 rounded-xl transition-all relative ${activeTab === 'quiz' ? 'bg-white text-pink-600 shadow-md scale-102 font-black' : 'text-slate-650 hover:bg-white/40'}`}
                >
                  <span className="text-xl">🎯</span>
                  <span className="text-[10px] font-black tracking-tighter mt-1">Teka Ria</span>
                </button>

                <button
                  id="tab_math"
                  onClick={() => {
                    SoundEffect.playBubble();
                    setActiveTab('math');
                    generateNewMathQuestion();
                  }}
                  className={`flex flex-col items-center justify-center py-2.5 rounded-xl transition-all relative ${activeTab === 'math' ? 'bg-white text-indigo-600 shadow-md scale-102 font-black' : 'text-slate-650 hover:bg-white/40'}`}
                >
                  <span className="text-xl">➕</span>
                  <span className="text-[10px] font-black tracking-tighter mt-1">Math Ria</span>
                </button>

                <button
                  id="tab_cikgu_ai"
                  onClick={() => {
                    SoundEffect.playBubble();
                    setActiveTab('cikguAi');
                  }}
                  className={`flex flex-col items-center justify-center py-2.5 rounded-xl transition-all relative ${activeTab === 'cikguAi' ? 'bg-white text-cyan-600 shadow-md scale-102 font-black' : 'text-slate-650 hover:bg-white/40'}`}
                >
                  <span className="text-xl">✨</span>
                  <span className="text-[10px] font-black tracking-tighter mt-1">Cikgu AI</span>
                </button>

                <button
                  id="tab_parents"
                  onClick={() => {
                    SoundEffect.playBubble();
                    setActiveTab('parents');
                  }}
                  className={`flex flex-col items-center justify-center py-2.5 rounded-xl transition-all relative ${activeTab === 'parents' ? 'bg-white text-emerald-600 shadow-md scale-102 font-black' : 'text-slate-650 hover:bg-white/40'}`}
                >
                  <span className="text-xl">🔑</span>
                  <span className="text-[10px] font-black tracking-tighter mt-1">MamaPapa</span>
                </button>
              </div>

              {/* TAB CONTENT SWITCHERS */}
              <div className="flex-1 min-h-[360px] flex flex-col justify-between">
                
                {/* SCREEN A: CHILDREN INTERACTIVE STUDY (FLASH CARDS) */}
                {activeTab === 'study' && (
                  <div className="flex-1 flex flex-col justify-between space-y-4">
                    
                    {/* Category pills */}
                    <div className="flex items-center justify-center space-x-1.5">
                      <button
                        onClick={() => handleCategorySwitch('abc')}
                        className={`flex-1 py-2 text-xs font-black rounded-lg transition-transform hover:scale-[1.03] ${subCategory === 'abc' ? 'bg-orange-400 text-white shadow' : 'bg-orange-100 text-orange-850'}`}
                      >
                        🆎 ABC
                      </button>
                      <button
                        onClick={() => handleCategorySwitch('alifBaTa')}
                        className={`flex-1 py-2 text-xs font-black rounded-lg transition-transform hover:scale-[1.03] ${subCategory === 'alifBaTa' ? 'bg-rose-400 text-white shadow' : 'bg-rose-100 text-rose-850'}`}
                      >
                        🕌 Alif Ba Ta
                      </button>
                      <button
                        onClick={() => handleCategorySwitch('numbers')}
                        className={`flex-1 py-2 text-xs font-black rounded-lg transition-transform hover:scale-[1.03] ${subCategory === 'numbers' ? 'bg-lime-500 text-white shadow' : 'bg-lime-100 text-lime-900'}`}
                      >
                        🔟 Nombor 1-0
                      </button>
                    </div>

                    {/* FLASH CARD VIEWER FRAME */}
                    <AnimatePresence mode="wait">
                      
                      {/* Sub-Category: ABC Abjad */}
                      {subCategory === 'abc' && (
                        <motion.div
                          key={`abc-${abcIdx}`}
                          initial={{ opacity: 0, scale: 0.92, rotateY: -10 }}
                          animate={{ opacity: 1, scale: 1, rotateY: 0 }}
                          exit={{ opacity: 0, scale: 0.92, rotateY: 10 }}
                          transition={{ duration: 0.25 }}
                          className="flex-1 flex flex-col justify-between bg-gradient-to-br from-indigo-50 to-sky-50 rounded-3xl p-5 border-4 border-sky-300 shadow-md"
                        >
                          {/* Card letter & illustration */}
                          <div className="text-center space-y-2">
                            <span className="block text-7xl select-none animate-pulse filter drop-shadow-sm">
                              {ABC_CARDS[abcIdx].emoji}
                            </span>
                            <div className="flex items-center justify-center space-x-2">
                              <span className="text-6xl font-black text-slate-800 tracking-tight font-mono">
                                {ABC_CARDS[abcIdx].letter}
                              </span>
                              <span className="text-3xl font-extrabold text-blue-500">
                                for
                              </span>
                            </div>
                            
                            <div>
                              <h3 className="text-2xl font-black text-indigo-700 tracking-wide mt-2">
                                {ABC_CARDS[abcIdx].word}
                              </h3>
                              <p className="text-xs font-bold text-indigo-500 uppercase">
                                Melayu: <span className="text-rose-500 font-extrabold">{ABC_CARDS[abcIdx].malayWord}</span>
                              </p>
                            </div>
                          </div>

                          {/* Sound speak trigger in card */}
                          <button
                            onClick={() => speak(ABC_CARDS[abcIdx].audioText, 'en-US')}
                            className="mt-4 mx-auto w-4/5 py-3 font-sans font-black bg-gradient-to-r from-blue-400 to-indigo-500 text-white rounded-full flex items-center justify-center space-x-2 cursor-pointer shadow-md active:scale-98 transition-transform"
                          >
                            <Volume2 className="h-5 w-5 animate-pulse" />
                            <span>SEBUT DAN LAFAZ 🔊</span>
                          </button>
                        </motion.div>
                      )}

                      {/* Sub-Category: Alif Ba Ta Hijaiyah */}
                      {subCategory === 'alifBaTa' && (
                        <motion.div
                          key={`alif-${hijaiyahIdx}`}
                          initial={{ opacity: 0, scale: 0.92, rotateY: -15 }}
                          animate={{ opacity: 1, scale: 1, rotateY: 0 }}
                          exit={{ opacity: 0, scale: 0.92, rotateY: 15 }}
                          transition={{ duration: 0.25 }}
                          className="flex-1 flex flex-col justify-between bg-gradient-to-br from-rose-50 to-pink-100 rounded-3xl p-5 border-4 border-pink-300 shadow-md"
                        >
                          <div className="text-center space-y-2">
                            <span className="block text-7xl select-none filter drop-shadow-sm animate-pulse">
                              {HIJAIYAH_CARDS[hijaiyahIdx].emoji}
                            </span>
                            <span className="block text-8xl font-black text-rose-600 font-mono tracking-wide leading-none py-1">
                              {HIJAIYAH_CARDS[hijaiyahIdx].letter}
                            </span>
                            
                            <div>
                              <h3 className="text-2xl font-black text-pink-700 tracking-wider">
                                Huruf {HIJAIYAH_CARDS[hijaiyahIdx].name}
                              </h3>
                              <p className="text-xs font-bold text-pink-500 uppercase tracking-widest mt-1">
                                Cth perkataan: <span className="font-black text-rose-600">{HIJAIYAH_CARDS[hijaiyahIdx].word}</span>
                              </p>
                            </div>
                          </div>

                          <button
                            onClick={() => speak(HIJAIYAH_CARDS[hijaiyahIdx].pronunciation, 'ms-MY')}
                            className="mt-4 mx-auto w-4/5 py-3 font-sans font-black bg-gradient-to-r from-pink-400 to-rose-500 text-white rounded-full flex items-center justify-center space-x-2 cursor-pointer shadow-md active:scale-98 transition-transform"
                          >
                            <Volume2 className="h-5 w-5 animate-pulse" />
                            <span>LAFAZ HIJAIYAH 🔊</span>
                          </button>
                        </motion.div>
                      )}

                      {/* Sub-Category: Nombor 1-0 */}
                      {subCategory === 'numbers' && (
                        <motion.div
                          key={`num-${numberIdx}`}
                          initial={{ opacity: 0, scale: 0.92, rotate: -2 }}
                          animate={{ opacity: 1, scale: 1, rotate: 0 }}
                          exit={{ opacity: 0, scale: 0.92, rotate: 2 }}
                          transition={{ duration: 0.25 }}
                          className="flex-1 flex flex-col justify-between bg-gradient-to-br from-lime-50 to-teal-50 rounded-3xl p-5 border-4 border-teal-300 shadow-md"
                        >
                          <div className="text-center space-y-3">
                            {/* Visual emojis for physical math feel */}
                            <div className="flex flex-wrap items-center justify-center gap-1.5 py-2.5 min-h-12 max-w-[280px] mx-auto bg-white/70 rounded-2xl p-2 border border-teal-100">
                              {NUMBER_CARDS[numberIdx].count === 0 ? (
                                <span className="text-sm font-semibold text-slate-500">🪄 Kotak kosong</span>
                              ) : (
                                Array.from({ length: NUMBER_CARDS[numberIdx].count }).map((_, i) => (
                                  <span key={i} className="text-3xl animate-bounce" style={{ animationDelay: `${i * 0.1}s` }}>
                                    {NUMBER_CARDS[numberIdx].itemsEmoji}
                                  </span>
                                ))
                              )}
                            </div>

                            <span className="block text-7xl font-mono font-black text-emerald-600">
                              {NUMBER_CARDS[numberIdx].value}
                            </span>
                            
                            <div>
                              <h3 className="text-xl font-bold text-teal-800">
                                Angka {NUMBER_CARDS[numberIdx].text}
                              </h3>
                              <p className="text-xs text-teal-600 font-extrabold font-serif italic max-w-[260px] mx-auto">
                                "{NUMBER_CARDS[numberIdx].desc}"
                              </p>
                            </div>
                          </div>

                          <button
                            onClick={() => speak(`Ini nombor ${NUMBER_CARDS[numberIdx].value}. ${NUMBER_CARDS[numberIdx].text}. ${NUMBER_CARDS[numberIdx].desc}`, 'ms-MY')}
                            className="mt-4 mx-auto w-4/5 py-3 font-sans font-black bg-gradient-to-r from-emerald-400 to-teal-500 text-white rounded-full flex items-center justify-center space-x-2 cursor-pointer shadow-md active:scale-98 transition-transform"
                          >
                            <Volume2 className="h-5 w-5 animate-pulse" />
                            <span>KIRA NOMBOR 🔊</span>
                          </button>
                        </motion.div>
                      )}

                    </AnimatePresence>

                    {/* Navigation controllers beneath flashcard */}
                    <div className="flex items-center justify-between space-x-4">
                      <button
                        onClick={() => {
                          SoundEffect.playBubble();
                          if (subCategory === 'abc') {
                            setAbcIdx(prev => (prev === 0 ? ABC_CARDS.length - 1 : prev - 1));
                          } else if (subCategory === 'alifBaTa') {
                            setHijaiyahIdx(prev => (prev === 0 ? HIJAIYAH_CARDS.length - 1 : prev - 1));
                          } else {
                            setNumberIdx(prev => (prev === 0 ? NUMBER_CARDS.length - 1 : prev - 1));
                          }
                        }}
                        className="flex-1 py-3 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold rounded-2xl border border-slate-200 transition-all cursor-pointer flex items-center justify-center space-x-1"
                      >
                        <span>◀️</span>
                        <span>Sebelum</span>
                      </button>

                      <button
                        onClick={() => {
                          SoundEffect.playBubble();
                          if (subCategory === 'abc') {
                            setAbcIdx(prev => (prev === ABC_CARDS.length - 1 ? 0 : prev + 1));
                          } else if (subCategory === 'alifBaTa') {
                            setHijaiyahIdx(prev => (prev === HIJAIYAH_CARDS.length - 1 ? 0 : prev + 1));
                          } else {
                            setNumberIdx(prev => (prev === NUMBER_CARDS.length - 1 ? 0 : prev + 1));
                          }
                        }}
                        className="flex-1 py-3 bg-slate-800 text-white font-extrabold rounded-2xl hover:bg-slate-900 transition-all cursor-pointer flex items-center justify-center space-x-1"
                      >
                        <span>Seterusnya</span>
                        <span>▶️</span>
                      </button>
                    </div>

                  </div>
                )}

                {/* SCREEN B: TEKA RIA QUIZ GAME */}
                {activeTab === 'quiz' && quizTask && (
                  <div className="flex-1 flex flex-col justify-between space-y-4">
                    
                    {/* Game Mode Pill Controllers */}
                    <div className="bg-pink-50 p-1.5 rounded-2xl flex items-center space-x-1.5 border border-pink-100">
                      <button
                        onClick={() => selectQuizTypeTab('abc')}
                        className={`flex-1 py-1.5 text-[10px] font-black rounded-lg transition-transform ${quizType === 'abc' ? 'bg-pink-500 text-white shadow-xs' : 'text-pink-900 bg-transparent'}`}
                      >
                        Abjad ABC
                      </button>
                      <button
                        onClick={() => selectQuizTypeTab('alif')}
                        className={`flex-1 py-1.5 text-[10px] font-black rounded-lg transition-transform ${quizType === 'alif' ? 'bg-pink-500 text-white shadow-xs' : 'text-pink-900 bg-transparent'}`}
                      >
                        Alif Ba Ta
                      </button>
                      <button
                        onClick={() => selectQuizTypeTab('number_match')}
                        className={`flex-1 py-1.5 text-[10px] font-black rounded-lg transition-transform ${quizType === 'number_match' ? 'bg-pink-500 text-white shadow-xs' : 'text-pink-900 bg-transparent'}`}
                      >
                        Kira Emojiku
                      </button>
                    </div>

                    {/* QUIZ TASK CENTER PANEL */}
                    <div className="bg-gradient-to-br from-pink-50 via-white to-pink-50 border-4 border-pink-200 rounded-3xl p-4 text-center flex-1 flex flex-col justify-center space-y-4 relative overflow-hidden">
                      {/* Active streak counter */}
                      {streak > 0 && (
                        <div className="absolute top-2 right-2 bg-gradient-to-r from-amber-400 to-orange-500 text-white px-2.5 py-0.5 rounded-full font-black text-[10px] uppercase animate-pulse flex items-center gap-1">
                          🔥 STREAK: {streak}
                        </div>
                      )}

                      {/* Display question graphic */}
                      <div className="mx-auto select-none">
                        {quizType === 'abc' && (
                          <span className="text-8xl filter drop-shadow-md animate-bounce transform origin-center block">
                            {quizTask.emoji}
                          </span>
                        )}

                        {quizType === 'alif' && (
                          <div className="flex flex-col items-center">
                            <span className="text-4xl">🕌</span>
                            <span className="text-2xl font-black mt-2 text-rose-500">
                              Cari Huruf: {quizTask.options.find((o: any) => o.letter === quizTask.correctAnswer)?.name}
                            </span>
                          </div>
                        )}

                        {quizType === 'number_match' && (
                          <div className="flex flex-wrap items-center justify-center gap-1.5 max-w-[280px] py-3.5 bg-white rounded-2xl border border-pink-100 shadow-inner px-2">
                            {Array.from({ length: quizTask.correctAnswer }).map((_, i) => (
                              <span key={i} className="text-3xl animate-pulse">
                                {quizTask.emojiCode}
                              </span>
                            ))}
                          </div>
                        )}
                      </div>

                      <p className="text-xs sm:text-sm font-black text-pink-950 leading-relaxed max-w-[300px] mx-auto">
                        {quizTask.prompt}
                      </p>

                      {/* Answer options container */}
                      <div className="grid grid-cols-3 gap-2 pt-2">
                        {quizTask.options.map((option: any, idx: number) => {
                          const optionValue = quizType === 'alif' ? option.letter : option;
                          const optionLabel = quizType === 'alif' ? option.letter : option;
                          
                          const isPicked = selectedAns === optionValue;
                          const isCorrectOpt = optionValue === quizTask.correctAnswer;
                          
                          let btnStyle = "bg-white text-slate-800 border-2 border-slate-200 font-extrabold";
                          if (answerStatus === 'right' && isCorrectOpt) {
                            btnStyle = "bg-green-500 text-white border-green-600 scale-102 font-black shadow";
                          } else if (answerStatus === 'wrong' && isPicked) {
                            btnStyle = "bg-red-400 text-white border-red-500 shrink-95";
                          } else if (answerStatus !== 'idle') {
                            btnStyle = "bg-slate-50 text-slate-400 opacity-60 border-slate-100";
                          }

                          return (
                            <button
                              key={idx}
                              onClick={() => checkQuizAnswer(optionValue)}
                              disabled={answerStatus !== 'idle'}
                              className={`py-3.5 rounded-2xl text-2xl transition-all cursor-pointer ${btnStyle}`}
                            >
                              {optionLabel}
                            </button>
                          );
                        })}
                      </div>

                    </div>

                    {/* Skip / Next question control button */}
                    <button
                      onClick={() => generateNewQuiz()}
                      className="w-full py-3 bg-pink-500 text-white font-extrabold rounded-2xl hover:bg-pink-600 transition-all cursor-pointer flex items-center justify-center space-x-1.5 shadow"
                    >
                      <span>Seterusnya 🍎</span>
                      <ArrowRight className="h-4.5 w-4.5" />
                    </button>

                  </div>
                )}

                {/* SCREEN C: MATH RIA (BASIC MATH) */}
                {activeTab === 'math' && (
                  <div className="flex-1 flex flex-col justify-between space-y-4">
                    
                    <div className="bg-indigo-50 border-4 border-indigo-200 rounded-3xl p-4 text-center flex-1 flex flex-col justify-center space-y-4">
                      
                      {/* Interactive Visual Counter Blocks for Kids 3-6 */}
                      <div className="flex items-center justify-center space-x-3.5 py-4 bg-white rounded-2xl border border-indigo-100 shadow-sm max-w-[325px] mx-auto w-full px-2">
                        {/* Num 1 visual group */}
                        <div className="flex flex-wrap items-center justify-center gap-1 max-w-[100px]">
                          {Array.from({ length: mathNum1 }).map((_, i) => (
                            <span key={i} className="text-2.5xl animate-bounce">🍎</span>
                          ))}
                        </div>

                        {/* Sign Indicator */}
                        <span className="text-3xl font-black text-rose-500 select-none">
                          {mathOperator === '+' ? '➕' : '➖'}
                        </span>

                        {/* Num 2 visual group */}
                        <div className="flex flex-wrap items-center justify-center gap-1 max-w-[100px]">
                          {Array.from({ length: mathNum2 }).map((_, i) => (
                            <span key={i} className="text-2.5xl animate-bounce">🍎</span>
                          ))}
                        </div>

                        {/* Equals Indicator */}
                        <span className="text-3xl font-black text-indigo-500 select-none">🟰</span>
                        
                        {/* Kid Question Box marker */}
                        <span className="text-3xl">❓</span>
                      </div>

                      {/* Display Question Equations in Large Fonts */}
                      <div>
                        <div className="text-5xl font-black text-indigo-900 tracking-wider font-mono">
                          {mathNum1} {mathOperator} {mathNum2} = ?
                        </div>
                        <p className="text-xs text-indigo-500 font-bold mt-1 uppercase tracking-wide">
                          Mari kita kira epal di atas bersama-sama!
                        </p>
                      </div>

                      {/* Math Choices Option layout */}
                      <div className="grid grid-cols-3 gap-2.5 pt-2">
                        {mathOptions.map((opt, id) => {
                          const isPicked = mathChosenAns === opt;
                          const actual = mathOperator === '+' ? (mathNum1 + mathNum2) : (mathNum1 - mathNum2);
                          const isCorrect = opt === actual;

                          let mathBtnStyle = "bg-white text-indigo-700 border-2 border-indigo-150 font-black text-2xl";
                          if (mathStatus === 'right' && isCorrect) {
                            mathBtnStyle = "bg-green-500 text-white border-green-600 scale-102 shadow-md";
                          } else if (mathStatus === 'wrong' && isPicked) {
                            mathBtnStyle = "bg-red-400 text-white border-red-500";
                          } else if (mathStatus !== 'idle') {
                            mathBtnStyle = "bg-indigo-50 text-indigo-300 opacity-60 border-transparent";
                          }

                          return (
                            <button
                              key={id}
                              onClick={() => checkMathAnswer(opt)}
                              disabled={mathStatus !== 'idle'}
                              className={`py-3.5 rounded-2xl cursor-pointer transition-all ${mathBtnStyle}`}
                            >
                              {opt}
                            </button>
                          );
                        })}
                      </div>

                    </div>

                    <button
                      onClick={() => generateNewMathQuestion()}
                      className="w-full py-3 bg-indigo-500 text-white font-extrabold rounded-2xl hover:bg-indigo-600 transition-all cursor-pointer flex items-center justify-center space-x-1.5 shadow"
                    >
                      <span>Matematik Baharu 🍰</span>
                      <ArrowRight className="h-4.5 w-4.5" />
                    </button>

                  </div>
                )}

                {/* SCREEN D: CIKGU AI CUSTOM CARDS (GENERATED DYNAMICALLY VIA GEMINI PORTAL) */}
                {activeTab === 'cikguAi' && (
                  <div className="flex-1 flex flex-col justify-between space-y-4">
                    
                    {/* Topic customization form for parents to interact */}
                    <div className="bg-cyan-50/70 p-3.5 rounded-2xl border border-cyan-150 space-y-3">
                      <div>
                        <label className="block text-[11px] font-black uppercase text-cyan-800 tracking-wide mb-1">
                          🎯 Cadang Topi Pelajaran Kustom (Cikgu AI)
                        </label>
                        <p className="text-[10px] text-cyan-600 font-medium mb-2">
                          Ibu bapa can type kids' favorite topic (e.g. Dinosaur, Kenderaan, Angkasa, Sayur) to generate custom learning sets!
                        </p>
                        
                        <div className="flex space-x-1">
                          <input
                            type="text"
                            value={parentTopic}
                            onChange={(e) => setParentTopic(e.target.value)}
                            placeholder="Cth: Haiwan Comel, Kereta maut..."
                            className="flex-1 text-xs px-3 py-2 border border-cyan-200 bg-white rounded-lg focus:outline-none focus:ring-1 focus:ring-cyan-400 font-bold"
                          />
                          <button
                            onClick={handleGenerateCustomCards}
                            disabled={isGeneratingAi}
                            className="bg-cyan-500 hover:bg-cyan-600 text-white text-xs font-black px-4 py-2 rounded-lg cursor-pointer transition-transform active:scale-95 disabled:opacity-50"
                          >
                            {isGeneratingAi ? 'Jana...' : 'Bina Kad'}
                          </button>
                        </div>
                      </div>
                    </div>

                    {/* GENERATED CONTENT RENDERER */}
                    <div className="flex-1 flex flex-col justify-center min-h-[220px]">
                      
                      {isGeneratingAi ? (
                        <div className="text-center space-y-3 py-10 bg-white border border-cyan-100 rounded-3xl p-5">
                          <span className="text-5xl inline-block animate-spin">🔮</span>
                          <h4 className="text-xs font-black text-cyan-800 uppercase tracking-widest animate-pulse">
                            Cikgu AI Sedang Berfikir...
                          </h4>
                          <p className="text-[10px] text-slate-500 max-w-[240px] mx-auto">
                            Menghubungi AI Studio Gemini 3.5 Flash untuk membina modul kad belajar bertema "{parentTopic}" khas untuk kognitif umur 3-6 tahun.
                          </p>
                        </div>
                      ) : aiError ? (
                        <div className="text-center py-6 bg-red-50 border border-red-100 rounded-3xl p-4 space-y-2">
                          <span className="text-3xl">⚠️</span>
                          <p className="text-[11px] text-red-700 font-bold">{aiError}</p>
                          <button
                            onClick={handleGenerateCustomCards}
                            className="text-[10px] font-black uppercase text-white bg-red-400 px-3 py-1.5 rounded-md cursor-pointer"
                          >
                            Cuba Semula
                          </button>
                        </div>
                      ) : aiGeneratedCards.length > 0 ? (
                        
                        <AnimatePresence mode="wait">
                          <motion.div
                            key={`ai-${aiCurrentCardIdx}`}
                            initial={{ opacity: 0, scale: 0.95 }}
                            animate={{ opacity: 1, scale: 1 }}
                            exit={{ opacity: 0, scale: 0.95 }}
                            className="bg-gradient-to-br from-cyan-50 via-white to-cyan-50 border-4 border-cyan-300 rounded-3xl p-4 flex-1 flex flex-col justify-between text-center space-y-3"
                          >
                            {aiIsFallback && (
                              <div className="bg-amber-100 text-amber-800 text-[9px] font-black uppercase py-0.5 px-2 rounded-full self-center">
                                Offline Demo Mode
                              </div>
                            )}

                            <div>
                              <span className="block text-6xl animate-bounce filter drop-shadow">
                                {aiGeneratedCards[aiCurrentCardIdx].emoji}
                              </span>
                              
                              <div className="flex items-center justify-center space-x-1.5 mt-1.5">
                                <span className="text-4xl font-extrabold text-cyan-800">
                                  {aiGeneratedCards[aiCurrentCardIdx].letter}
                                </span>
                                <span className="text-lg font-bold text-slate-400">untukk</span>
                              </div>

                              <h3 className="text-2xl font-black text-cyan-700 font-mono tracking-wide">
                                {aiGeneratedCards[aiCurrentCardIdx].word}
                              </h3>
                              
                              <div className="text-[11px] text-cyan-600 font-extrabold">
                                English: <span className="text-purple-600 italic">"{aiGeneratedCards[aiCurrentCardIdx].englishWord}"</span>
                              </div>

                              <p className="text-xs text-slate-600 font-bold mt-2 leading-relaxed bg-white/70 p-2 rounded-xl border border-cyan-100 max-w-[270px] mx-auto shadow-inner">
                                Fact: "{aiGeneratedCards[aiCurrentCardIdx].fact}"
                              </p>
                            </div>

                            <button
                              onClick={() => speak(`${aiGeneratedCards[aiCurrentCardIdx].word}. English. ${aiGeneratedCards[aiCurrentCardIdx].englishWord}. ${aiGeneratedCards[aiCurrentCardIdx].fact}`, 'ms-MY')}
                              className="mt-2 text-xs py-2 bg-gradient-to-r from-cyan-400 to-blue-500 text-white font-extrabold rounded-full flex items-center justify-center space-x-1.5 cursor-pointer shadow active:scale-98 transition-all"
                            >
                              <Volume2 className="h-4 w-4" />
                              <span>SEBUT SEKARANG 🔊</span>
                            </button>
                          </motion.div>
                        </AnimatePresence>

                      ) : (
                        <div className="text-center py-10 bg-white border border-dashed border-cyan-200 rounded-3xl p-5 space-y-2">
                          <span className="text-5xl">🎨</span>
                          <h4 className="text-xs font-black text-cyan-800 uppercase tracking-widest">
                            Belum Ada Kad Belajar Custom
                          </h4>
                          <p className="text-[10px] text-slate-500 max-w-[240px] mx-auto">
                            Taip satu topik menarik kegemaran anak anda di atas (contoh "Dinosaur Halus", "Space", dll) dan tekan 'Bina Kad' untuk mula menjana.
                          </p>
                        </div>
                      )}

                    </div>

                    {/* Pagination for AI generated cards */}
                    {aiGeneratedCards.length > 0 && (
                      <div className="flex items-center justify-between space-x-3">
                        <button
                          onClick={() => {
                            SoundEffect.playBubble();
                            setAiCurrentCardIdx(prev => (prev === 0 ? aiGeneratedCards.length - 1 : prev - 1));
                          }}
                          className="flex-1 py-2.5 bg-slate-100 text-slate-600 text-xs font-black rounded-xl border border-slate-200 cursor-pointer"
                        >
                          ◀️ Sebelum
                        </button>
                        <span className="text-xs font-black text-cyan-800">
                          {aiCurrentCardIdx + 1} / {aiGeneratedCards.length}
                        </span>
                        <button
                          onClick={() => {
                            SoundEffect.playBubble();
                            setAiCurrentCardIdx(prev => (prev === aiGeneratedCards.length - 1 ? 0 : prev + 1));
                          }}
                          className="flex-1 py-2.5 bg-cyan-600 text-white text-xs font-black rounded-xl cursor-pointer"
                        >
                          Seterusnya ▶️
                        </button>
                      </div>
                    )}

                  </div>
                )}

                {/* SCREEN E: PARENTS DASHBOARD & ANDROID DEPLOYMENT COMPILER GUIDE */}
                {activeTab === 'parents' && (
                  <div className="flex-1 flex flex-col justify-between space-y-4 text-left">
                    
                    {/* Sub-tabs inside Parents menu */}
                    <div className="grid grid-cols-3 gap-1 bg-amber-100/50 p-1 rounded-xl">
                      <button
                        onClick={() => { SoundEffect.playBubble(); setParentSubTab('profile'); }}
                        className={`py-1.5 text-[10px] font-black rounded-lg transition-all ${parentSubTab === 'profile' ? 'bg-orange-400 text-white shadow-xs' : 'text-slate-700 hover:bg-orange-50'}`}
                      >
                        ⚙️ Tetapan
                      </button>
                      <button
                        onClick={() => { SoundEffect.playBubble(); setParentSubTab('flutter'); }}
                        className={`py-1.5 text-[10px] font-black rounded-lg transition-all ${parentSubTab === 'flutter' ? 'bg-orange-400 text-white shadow-xs' : 'text-slate-700 hover:bg-orange-50'}`}
                      >
                        💙 Kod Flutter
                      </button>
                      <button
                        onClick={() => { SoundEffect.playBubble(); setParentSubTab('apk'); }}
                        className={`py-1.5 text-[10px] font-black rounded-lg transition-all ${parentSubTab === 'apk' ? 'bg-orange-400 text-white shadow-xs' : 'text-slate-700 hover:bg-orange-50'}`}
                      >
                        📱 Bina APK
                      </button>
                    </div>

                    {/* Sub-tab 1: PROFILE & STATISTICS COGNITIVE */}
                    {parentSubTab === 'profile' && (
                      <div className="space-y-4">
                        {/* Settings Profil Anak */}
                        <div className="bg-white border-2 border-orange-100 rounded-2xl p-4 space-y-3">
                          <div className="flex items-center space-x-2 text-orange-900 border-b border-orange-50 pb-2">
                            <UserCheck className="h-4 w-4 text-orange-500" />
                            <h4 className="text-xs font-black uppercase tracking-wide">Tetapan Pembelajaran Anak</h4>
                          </div>

                          <div className="grid grid-cols-2 gap-3">
                            <div>
                              <label className="block text-[9px] font-bold text-slate-500 uppercase">Nama Anak</label>
                              <input
                                type="text"
                                value={kidName}
                                onChange={(e) => setKidName(e.target.value)}
                                className="w-full text-xs px-2 py-1.5 border border-slate-200 rounded-md font-semibold bg-slate-50"
                              />
                            </div>
                            <div>
                              <label className="block text-[9px] font-bold text-slate-500 uppercase">Umur (3-6)</label>
                              <select
                                value={kidAge}
                                onChange={(e) => setKidAge(Number(e.target.value))}
                                className="w-full text-xs px-2 py-1.2 border border-slate-200 rounded-md font-semibold bg-slate-50"
                              >
                                <option value={3}>3 Tahun</option>
                                <option value={4}>4 Tahun</option>
                                <option value={5}>5 Tahun</option>
                                <option value={6}>6 Tahun</option>
                              </select>
                            </div>
                          </div>

                          <div className="space-y-1">
                            <label className="block text-[9px] font-bold text-slate-500 uppercase">Pilih Guru Pembimbing (Mascot)</label>
                            <div className="grid grid-cols-3 gap-1.5">
                              {MASCOTS.map(m => (
                                <button
                                  key={m.id}
                                  onClick={() => {
                                    SoundEffect.playBubble();
                                    setSelectedMascot(m.id);
                                    handleMascotSpeech(`Terima kasih ibu bapa! Sekarang, ${m.name} sedia bimbing adik ${kidName}! 🌟`, 'ms-MY');
                                  }}
                                  className={`py-1.5 px-1 rounded-xl text-xs font-black transition-all border ${selectedMascot === m.id ? 'bg-orange-400 text-white border-orange-500 shadow-xs scale-102' : 'bg-slate-50 border-slate-200 text-slate-700'}`}
                                >
                                  <span className="text-sm mr-1">{m.emoji}</span>
                                  <span className="text-[8px]">{m.name.split(' ')[1]}</span>
                                </button>
                              ))}
                            </div>
                          </div>
                        </div>

                        {/* Prestatif Stats - Kid Learning Tracker */}
                        <div className="bg-gradient-to-r from-emerald-500 to-green-600 rounded-2xl p-4 text-white space-y-3 shadow">
                          <div className="flex items-center justify-between border-b border-white/20 pb-2">
                            <div className="flex items-center space-x-1.5">
                              <Activity className="h-4 w-4" />
                              <h4 className="text-[10px] font-black uppercase tracking-wider">Laporan Kognitif (Anak Pintar)</h4>
                            </div>
                            <span className="text-[9px] font-bold bg-white/20 px-2 py-0.5 rounded-full uppercase">Real-Time</span>
                          </div>

                          <div className="grid grid-cols-2 gap-3 text-center">
                            <div className="bg-white/10 p-2 rounded-xl">
                              <span className="block text-[8px] text-emerald-100 font-bold uppercase">Jumlah Bintang</span>
                              <span className="text-xl font-black font-mono text-yellow-100">{stars} ⭐</span>
                            </div>
                            <div className="bg-white/10 p-2 rounded-xl">
                              <span className="block text-[8px] text-emerald-100 font-bold uppercase">Ketepatan Jawapan</span>
                              <span className="text-xl font-black font-mono text-cyan-100">{getPercentageAccuracy()}%</span>
                            </div>
                          </div>

                          {/* Display Badges Earned */}
                          <div>
                            <span className="block text-[8px] text-emerald-100 font-bold uppercase mb-1">Sijil Penghargaan:</span>
                            <div className="flex flex-wrap gap-1">
                              {unlockedBadges.map((badge, idx) => (
                                <span key={idx} className="bg-white text-emerald-900 text-[8px] font-black py-0.5 px-2 rounded-full flex items-center gap-0.5 shadow-xs uppercase">
                                  🏆 {badge}
                                </span>
                              ))}
                            </div>
                          </div>
                        </div>
                      </div>
                    )}

                    {/* Sub-tab 2: FLUTTER DART REVOLUTIONARY COPY-PASTER */}
                    {parentSubTab === 'flutter' && (
                      <div className="space-y-3 bg-slate-900/98 p-4 rounded-2xl border-2 border-slate-950 text-slate-200">
                        <div className="flex items-center justify-between border-b border-slate-700 pb-2">
                          <div className="flex items-center space-x-1.5">
                            <span className="text-cyan-400">⚡</span>
                            <span className="text-[11px] font-black uppercase text-cyan-400 tracking-wider">Sedia Dipasang (Flutter SDK)</span>
                          </div>
                          
                          <button
                            onClick={() => {
                              SoundEffect.playTada();
                              navigator.clipboard.writeText(`// Sila buka fail flutter_main.dart yang telah dicipta di direktori utama projek! Atau salin dari editor.
import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const EduVerseKidsApp());
// Kod penuh sedia disalin meluas...`);
                              setFlutterCopied(true);
                              setTimeout(() => setFlutterCopied(false), 2000);
                            }}
                            className="text-[9px] px-2 py-1 bg-cyan-500 hover:bg-cyan-600 text-white font-black rounded-lg cursor-pointer transition-all active:scale-95"
                          >
                            {flutterCopied ? '✓ Berjaya Disalin' : 'Salin Semua'}
                          </button>
                        </div>

                        <p className="text-[10px] text-slate-300 leading-relaxed font-sans">
                          Kami telah menulis fail <strong>/flutter_main.dart</strong> secara automatik di direktori utama projek anda! Kod ini menyokong senarai penuh ABC, Alif Ba Ta, Nombor 1-0 Visual, dan Matematik secara luar talian (offline).
                        </p>

                        <div className="bg-black/40 rounded-xl p-2.5 font-mono text-[9px] max-h-[160px] overflow-y-auto text-zinc-300 border border-slate-850">
                          <p className="text-green-400">// Flutter App Entry Point</p>
                          <p className="text-purple-400">import <span className="text-amber-400">'package:flutter/material.dart'</span>;</p>
                          <p className="text-purple-400">import <span className="text-amber-400">'dart:math'</span>;</p>
                          <br />
                          <p className="text-indigo-400">void <span className="text-yellow-400">main</span>() &#123;</p>
                          <p>&nbsp;&nbsp;<span className="text-yellow-400">runApp</span>(const <span className="text-blue-300">EduVerseKidsApp</span>());</p>
                          <p>&#125;</p>
                          <br />
                          <p className="text-slate-400">// Sila periksa fail lengkap di panel fail /flutter_main.dart</p>
                        </div>

                        <div className="flex items-center space-x-2 text-[9px] text-amber-300 bg-amber-500/10 p-2.5 rounded-lg border border-amber-500/20">
                          <span>💡</span>
                          <span>Buka terminal di peranti anda, jalankan perintah <strong>"flutter create eduverse"</strong>, gantikan <strong>lib/main.dart</strong> dengan isi fail ini untuk dipasang pada iOS/Android sekarang!</span>
                        </div>
                      </div>
                    )}

                    {/* Sub-tab 3: ANDROID APK MOBILE BUILD INSTRUCTIONS */}
                    {parentSubTab === 'apk' && (
                      <div className="space-y-3 bg-slate-50 border border-slate-200 rounded-2xl p-4 text-slate-700">
                        <div className="flex items-center space-x-1.5 border-b border-slate-200 pb-2 text-slate-900">
                          <FileCode className="h-4 w-4 text-slate-500" />
                          <h4 className="text-xs font-black uppercase tracking-wide">Pemasangan Android/iOS</h4>
                        </div>

                        <p className="text-[11px] text-slate-650 leading-relaxed font-sans">
                          Aplikasi kognitif EduVerse ini direka padat agar boleh juga dipakejkan secara terus menjadi installer Android (.apk) menggunakan <strong>Capacitor JS</strong>.
                        </p>

                        <div className="bg-slate-900 text-zinc-100 rounded-xl p-3 font-mono text-[9px] space-y-1">
                          <p className="text-cyan-400 font-extrabold">// Guna Capacitor (Web hybrid):</p>
                          <p>1. npm install @capacitor/core @capacitor/cli</p>
                          <p>2. npx cap init "Eduverse Kids" "com.eduverse.kids"</p>
                          <p>3. npm run build</p>
                          <p>4. npx cap add android</p>
                        </div>

                        <div className="bg-cyan-900 text-cyan-50 rounded-xl p-3 font-mono text-[9px] space-y-1">
                          <p className="text-amber-300 font-extrabold">// Guna Flutter (Native Dart):</p>
                          <p>1. Lengkapkan fail lib/main.dart dengan kod kami</p>
                          <p>2. Jalankan perintah: <strong className="text-white">flutter build apk</strong></p>
                          <p>3. Ambil hasil fail di <strong className="text-white">build/app/outputs/flutter-apk/app-release.apk</strong></p>
                        </div>
                      </div>
                    )}

                  </div>
                )}

              </div>

              {/* SIMULATED MOBILE DEVICE HOME BUTTON PLACED AT THE BASE */}
              {useDeviceFrame && (
                <div className="absolute bottom-2 inset-x-0 flex justify-center py-2.5 z-20 bg-white">
                  <button
                    onClick={() => {
                      SoundEffect.playTada();
                      setActiveTab('study');
                      handleMascotSpeech('Kembali ke menu halaman belajar utama kawan comelku! 🏡', 'ms-MY');
                    }}
                    title="Home Button Peranti"
                    className="w-24 h-1.5 bg-slate-300 hover:bg-slate-400 rounded-full cursor-pointer transition-colors"
                  ></button>
                </div>
              )}

            </div>

          </div>

        </div>

      </main>

      {/* Decorative balloon/cloud backdrop patterns */}
      <div className="fixed bottom-4 left-4 z-0 pointer-events-none opacity-20 text-7xl select-none animate-pulse">
        ☁️
      </div>
      <div className="fixed top-20 right-8 z-0 pointer-events-none opacity-20 text-7xl select-none animate-pulse">
        🧸
      </div>
      <div className="fixed bottom-12 right-12 z-0 pointer-events-none opacity-25 text-7xl select-none animate-bounce">
        🎈
      </div>

    </div>
  );
}
