class Language{
  final int id;
  final String nameEnglish;
  final String nameNative;
  final String languageCode;

  Language(this.id, this.nameEnglish, this.nameNative, this.languageCode);

  static List<Language> languageList(){
    return<Language>[
      Language(1,"English","","en"),
      Language(2,"Hindi","हिन्दी","hi"),
      Language(3,"Marathi","मराठी","mr"),
      Language(4,"Gujarati","ગુજરાતી","gu"),
      Language(5,"Bengali","বাংলা","bn"),
      Language(6,"Punjabi","ਪੰਜਾਬੀ","pa"),
      Language(7,"Kannada","ಕನ್ನಡ","kn"),
      Language(8,"Tamil","தமிழ்","ta"),
      Language(9,"Telugu","తెలుగు","te"),
      Language(10,"Malayalam","മലയാളം","ml"),
      Language(11,"Urdu","اردو","ur"),
      Language(12,"Nepali","नेपाली","ne"),
    ];
  }
}

