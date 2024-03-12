class LevelSystem {
  List<String> levels = ['1', '2', '3', '4', '5', '6'];
  List<int> levelExperience = [100, 500, 2000, 5000, 10000, 50000];

  String getLevel(int experiencePoint) {
    String lv = '0';
    for (var i = 0; i < levels.length; i++) {
      if (experiencePoint > levelExperience[i]) {
        lv = levels[i];
      }
    }
    return lv;
  }

  int getNextLevelExp(int experiencePoint) {
    int lv = int.parse(getLevel(experiencePoint));
    return levelExperience[lv];
  }

  double getPercent(int experiencePoint) {
    int nextLevelExp = getNextLevelExp(experiencePoint);
    return experiencePoint / nextLevelExp;
  }

  String getLvMsg(int experiencePoint) {
    String lv = getLevel(experiencePoint);
    return 'LV $lv';
  }

  String getExpMsg(int experiencePoint) {
    String lv = getLevel(experiencePoint);
    int nextLevelExp = getNextLevelExp(experiencePoint);
    return 'Exp: $experiencePoint/$nextLevelExp';
  }
}
