import express from 'express';
import { GoogleGenAI, Type } from '@google/genai';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
app.use(express.json());

// Initialize Gemini SDK
const ai = new GoogleGenAI({
  apiKey: process.env.GEMINI_API_KEY || '',
  httpOptions: {
    headers: {
      'User-Agent': 'aistudio-build',
    }
  }
});

// Endpoint for parents to generate custom learning cards via Cikgu AI
app.post('/api/ai/generate-kids-cards', async (req, res) => {
  const { topic } = req.body;
  
  if (!topic) {
    return res.status(400).json({ error: 'Sila masukkan topik pembentangan kad.' });
  }

  try {
    const systemInstruction = `Anda ialah Cikgu AI, pembimbing pembelajaran digital untuk kanak-kanak berumur 3-6 tahun.
Berdasarkan topik yang diberikan oleh ibu bapa, bina senarai 5 kad pembelajaran interaktif yang ringkas dan menyeronokkan dalam Bahasa Melayu.
Setiap kad mestilah berfokus kepada satu huruf atau perkataan mudah, disertakan terjemahan Bahasa Inggeris ringkas, emoji visual yang tepat, dan satu fakta komedi/menarik yang mudah difahami budak kecil 3-6 tahun.

Output MESTI dalam format JSON mentah mengikut skema berikut:
[
  {
    "letter": "Huruf permulaan kata (cth: A)",
    "word": "Perkataan Melayu ringkas (cth: Ayam)",
    "englishWord": "English translation (cth: Chicken)",
    "emoji": "Satu emoji visual yang sangat tepat (cth: 🐔)",
    "fact": "Fakta kelakar ringkas (cth: Ayam suka kokok pagi-pagi mengejutkan kita bangun tidur!)"
  }
]`;

    const response = await ai.models.generateContent({
      model: 'gemini-3.5-flash',
      contents: `Sila buat 5 kad pembelajaran anak untuk topik: "${topic}". Pastikan perkataan ringkas untuk anak 3-6 tahun.`,
      config: {
        systemInstruction: systemInstruction,
        responseMimeType: "application/json",
        responseSchema: {
          type: Type.ARRAY,
          items: {
            type: Type.OBJECT,
            properties: {
              letter: { type: Type.STRING },
              word: { type: Type.STRING },
              englishWord: { type: Type.STRING },
              emoji: { type: Type.STRING },
              fact: { type: Type.STRING }
            },
            required: ["letter", "word", "englishWord", "emoji", "fact"]
          }
        }
      }
    });

    const textOutput = response.text || '[]';
    const data = JSON.parse(textOutput);
    res.json({ success: true, cards: data });
  } catch (error: any) {
    console.error('Kids Cards AI Gen Error:', error);
    
    // Friendly fallback cards if Gemini key is missing or failed
    const fallbacks: Record<string, any[]> = {
      "haiwan": [
        { letter: "K", word: "Kucing", englishWord: "Cat", emoji: "🐱", fact: "Kucing suka buat bunyi 'Meow' dan suka kejar tikus comel!" },
        { letter: "A", word: "Arnab", englishWord: "Rabbit", emoji: "🐰", fact: "Arnab ada telinga panjang dan suka makan lobak oren manis!" },
        { letter: "G", word: "Gajah", englishWord: "Elephant", emoji: "🐘", fact: "Gajah ada belalai sangat panjang untuk sembur air mandi!" },
        { letter: "M", word: "Monyet", englishWord: "Monkey", emoji: "🐒", fact: "Monyet suka gayut dekat dahan pokok dan sangat gemar makan pisang!" },
        { letter: "S", word: "Singa", englishWord: "Lion", emoji: "🦁", fact: "Singa ialah raja rimba dengan rambut lebat yang gagah perkasa!" }
      ],
      "buahan": [
        { letter: "P", word: "Pisang", englishWord: "Banana", emoji: "🍌", fact: "Pisang berwarna kuning terang, manis dan membekalkan banyak tenaga!" },
        { letter: "E", word: "Epal", englishWord: "Apple", emoji: "🍎", fact: "Epal ada warna merah dan hijau, sangat rangup apabila digigit!" },
        { letter: "B", word: "Betik", englishWord: "Papaya", emoji: "🍊", fact: "Betik ada biji kecil hitam banyak-banyak di dalamnya!" },
        { letter: "T", word: "Tembikai", englishWord: "Watermelon", emoji: "🍉", fact: "Tembikai sangat besar, banyak air dan manis untuk musim panas!" },
        { letter: "O", word: "Oren", englishWord: "Orange", emoji: "🍊", fact: "Oren kaya dengan Vitamin C, ada rasa manis dan masam yang menyegarkan!" }
      ]
    };

    const lowercaseTopic = topic.toLowerCase();
    let selectedFallback = fallbacks.haiwan;
    if (lowercaseTopic.includes('buah') || lowercaseTopic.includes('makan') || lowercaseTopic.includes('sayur')) {
      selectedFallback = fallbacks.buahan;
    }
    
    res.json({ success: true, cards: selectedFallback, isFallback: true });
  }
});

const PORT = 3000;

if (process.env.NODE_ENV === 'production') {
  app.use(express.static(path.join(__dirname, 'dist')));
  app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'dist', 'index.html'));
  });
} else {
  const { createServer: createViteServer } = await import('vite');
  const viteServer = await createViteServer({
    server: { middlewareMode: true },
    appType: 'spa',
  });
  app.use(viteServer.middlewares);
}

app.listen(PORT, '0.0.0.0', () => {
  console.log(`[KIDS GAME BACKEND] Running on port ${PORT}`);
});
