class LetterData {
  static const String podcastBaseUrl = 'https://www.englishteacher.com.tw/ywgssj/';

  final String letter;
  final String word;
  final String imagePath;
  final String audioPath;
  final int podcastId;

  const LetterData({
    required this.letter,
    required this.word,
    required this.imagePath,
    required this.audioPath,
    required this.podcastId,
  });

  String get upperCase => letter.toUpperCase();
  String get lowerCase => letter.toLowerCase();
  String get capitalizedWord => word[0].toUpperCase() + word.substring(1);
  String get podcastUrl => '$podcastBaseUrl$podcastId.html';
}

const List<LetterData> alphabetData = [
  LetterData(letter: 'A', word: 'apple', imagePath: 'assets/images/a_apple.webp', audioPath: 'assets/audio/a.mp3', podcastId: 16),
  LetterData(letter: 'B', word: 'ball', imagePath: 'assets/images/b_ball.webp', audioPath: 'assets/audio/b.mp3', podcastId: 17),
  LetterData(letter: 'C', word: 'cat', imagePath: 'assets/images/c_cat.webp', audioPath: 'assets/audio/c.mp3', podcastId: 18),
  LetterData(letter: 'D', word: 'dog', imagePath: 'assets/images/d_dog.webp', audioPath: 'assets/audio/d.mp3', podcastId: 19),
  LetterData(letter: 'E', word: 'elephant', imagePath: 'assets/images/e_elephant.webp', audioPath: 'assets/audio/e.mp3', podcastId: 20),
  LetterData(letter: 'F', word: 'frog', imagePath: 'assets/images/f_frog.webp', audioPath: 'assets/audio/f.mp3', podcastId: 21),
  LetterData(letter: 'G', word: 'gorilla', imagePath: 'assets/images/g_gorilla.webp', audioPath: 'assets/audio/g.mp3', podcastId: 22),
  LetterData(letter: 'H', word: 'hat', imagePath: 'assets/images/h_hat.webp', audioPath: 'assets/audio/h.mp3', podcastId: 23),
  LetterData(letter: 'I', word: 'igloo', imagePath: 'assets/images/i_igloo.webp', audioPath: 'assets/audio/i.mp3', podcastId: 24),
  LetterData(letter: 'J', word: 'jam', imagePath: 'assets/images/j_jam.webp', audioPath: 'assets/audio/j.mp3', podcastId: 25),
  LetterData(letter: 'K', word: 'kite', imagePath: 'assets/images/k_kite.webp', audioPath: 'assets/audio/k.mp3', podcastId: 26),
  LetterData(letter: 'L', word: 'lion', imagePath: 'assets/images/l_lion.webp', audioPath: 'assets/audio/l.mp3', podcastId: 27),
  LetterData(letter: 'M', word: 'monkey', imagePath: 'assets/images/m_monkey.webp', audioPath: 'assets/audio/m.mp3', podcastId: 28),
  LetterData(letter: 'N', word: 'nurse', imagePath: 'assets/images/n_nurse.webp', audioPath: 'assets/audio/n.mp3', podcastId: 29),
  LetterData(letter: 'O', word: 'octopus', imagePath: 'assets/images/o_octopus.webp', audioPath: 'assets/audio/o.mp3', podcastId: 30),
  LetterData(letter: 'P', word: 'pig', imagePath: 'assets/images/p_pig.webp', audioPath: 'assets/audio/p.mp3', podcastId: 31),
  LetterData(letter: 'Q', word: 'queen', imagePath: 'assets/images/q_queen.webp', audioPath: 'assets/audio/q.mp3', podcastId: 10),
  LetterData(letter: 'R', word: 'rainbow', imagePath: 'assets/images/r_rainbow.webp', audioPath: 'assets/audio/r.mp3', podcastId: 36),
  LetterData(letter: 'S', word: 'sun', imagePath: 'assets/images/s_sun.webp', audioPath: 'assets/audio/s.mp3', podcastId: 37),
  LetterData(letter: 'T', word: 'turtle', imagePath: 'assets/images/t_turtle.webp', audioPath: 'assets/audio/t.mp3', podcastId: 38),
  LetterData(letter: 'U', word: 'umbrella', imagePath: 'assets/images/u_umbrella.webp', audioPath: 'assets/audio/u.mp3', podcastId: 39),
  LetterData(letter: 'V', word: 'violin', imagePath: 'assets/images/v_violin.webp', audioPath: 'assets/audio/v.mp3', podcastId: 40),
  LetterData(letter: 'W', word: 'window', imagePath: 'assets/images/w_window.webp', audioPath: 'assets/audio/w.mp3', podcastId: 43),
  LetterData(letter: 'X', word: 'fox', imagePath: 'assets/images/x_fox.webp', audioPath: 'assets/audio/x.mp3', podcastId: 42),
  LetterData(letter: 'Y', word: 'yellow', imagePath: 'assets/images/y_yellow.webp', audioPath: 'assets/audio/y.mp3', podcastId: 44),
  LetterData(letter: 'Z', word: 'zebra', imagePath: 'assets/images/z_zebra.webp', audioPath: 'assets/audio/z.mp3', podcastId: 45),
];
