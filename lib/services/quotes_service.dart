class QuotesService {
  static final List<String> quotes = [
    "May your days be merry and bright!",
    "The magic of Christmas never ends.",
    "Christmas waves a magic wand over this world.",
    "Peace on Earth will come to all.",
    "It's the most wonderful time of the year.",
    "Believe in the magic of Christmas.",
    "Christmas is not a time, it's a feeling.",
    "May your heart be light and your spirits bright.",
    "The best way to spread Christmas cheer is singing loud for all to hear.",
    "Christmas isn't a season, it's a feeling.",
    "Have yourself a merry little Christmas.",
    "Joy to the world, the Lord has come.",
    "May the spirit of Christmas bring you peace.",
    "Wishing you a season full of light and laughter.",
    "Christmas magic is in the air.",
    "Let it snow, let it snow, let it snow!",
    "All I want for Christmas is you.",
    "Tis the season to be jolly.",
    "May your Christmas be filled with moments of love.",
    "Blessed is the season which engages the whole world in a conspiracy of love.",
    "Christmas is a day of meaning and traditions.",
    "May you find peace and joy this Christmas season.",
    "The gift of love, the gift of peace, the gift of happiness.",
    "Christmas is the spirit of giving without a thought of getting.",
    "Merry everything and happy always!",
    "May your home be filled with the joy of the Christmas season.",
    "Christmas is doing a little something extra for someone.",
    "May the good times and treasures of the present become the golden memories of tomorrow.",
    "Wishing you a joyous Christmas filled with love.",
    "The joy of brightening other lives becomes for us the magic of the holidays.",
    "Christmas is a season not only of rejoicing but of reflection.",
    "May the beauty of Christmas fill your heart.",
    "Peace, love, and joy to you this Christmas.",
    "Christmas will always be as long as we stand heart to heart and hand in hand.",
    "Faith makes all things possible, love makes all things easy.",
    "Blessed is the season which brings joy to the world.",
    "May your world be filled with warmth and good cheer.",
    "Christmas isn't just a day, it's a frame of mind.",
    "The best of all gifts around any Christmas tree is the presence of family.",
    "Christmas is a bridge connecting people all around the world.",
    "May the Christmas season bring you closer to all those that you treasure in your heart.",
    "The joy of Christmas is the presence of family and friends.",
    "Every time a bell rings, an angel gets its wings.",
    "Christmas is a time to believe in things you cannot see.",
    "The perfect gift is love wrapped in kindness.",
    "May the light of Christmas shine bright in your life.",
    "Christmas time is here, happiness and cheer!",
    "The greatest gift is the gift of friendship.",
    "May your Christmas sparkle with moments of love and laughter.",
    "Christmas memories are precious treasures.",
  ];

  String getRandomQuote() {
    final now = DateTime.now();
    final index = (now.millisecondsSinceEpoch ~/ 8000) % quotes.length;
    return quotes[index];
  }

  static List<String> getAllQuotes() => quotes;
}
