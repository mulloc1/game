import 'dart:io';
import 'dart:math';

import 'character.dart';
import 'monster.dart';

class Game {
  late Character character;
  late List<Monster> monsters = [];
  int defeatedMonsters = 0;
  Random random = Random();

  Game() {
    loadCharacterStats();
    loadMonsterStats();
  }

  void startGame() {
    print('게임을 시작합니다!');
    printCharacterStatus();

    while (character.health > 0 && defeatedMonsters < monsters.length) {
      Monster monster = getRandomMonster();
      battle(monster);

      if (character.health <= 0) {
        print('게임 오버! ${character.name}의 체력이 0이 되었습니다.');
        break;
      }

      if (monsters.isEmpty) {
        print('모든 몬스터를 물리쳤습니다! 게임 승리!');
        break;
      }

      print('다음 몬스터와 싸우시겠습니까? (y/n): ');
      String? choice = stdin.readLineSync();
      if (choice?.toLowerCase() != 'y') {
        print('게임을 종료합니다.');
        break;
      }
    }

    saveResult();
  }

  void battle(Monster monster) {
    print('새로운 몬스터가 나타났습니다!');
    monster.showStatus();

    while (character.health > 0 && monster.health > 0) {
      printCharacterStatus();
      print('${character.name}의 턴');
      print('행동을 선택하세요 (1: 공격, 2: 방어): ');

      String? choice = stdin.readLineSync();
      int action = int.tryParse(choice ?? '') ?? 1;

      if (action == 1) {
        character.attackMonster(monster);
      } else if (action == 2) {
        character.defend();
      } else {
        print('잘못된 입력입니다. 기본적으로 공격을 수행합니다.');
        character.attackMonster(monster);
      }

      if (monster.health <= 0) {
        print('${monster.name}을(를) 물리쳤습니다!');
        defeatedMonsters++;
        monsters.remove(monster);
        break;
      }

      print('${monster.name}의 턴');
      monster.attackCharacter(character);

      if (character.health <= 0) {
        print('${character.name}이(가) 패배했습니다!');
        break;
      }
    }
  }

  Monster getRandomMonster() {
    int index = random.nextInt(monsters.length);
    return monsters[index];
  }

  void loadCharacterStats() {
    try {
      final file = File('lib/files/characters.txt');
      final contents = file.readAsStringSync();
      final stats = contents.split(',');

      if (stats.length != 3) throw FormatException('Invalid character data');

      int health = int.parse(stats[0]);
      int attack = int.parse(stats[1]);
      int defense = int.parse(stats[2]);

      String name = getCharacterName();
      character = Character(name, health, attack, defense);
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
      // 기본값 설정
      String name = getCharacterName();
      character = Character(name, 50, 10, 5);
    }
  }

  void loadMonsterStats() {
    try {
      final file = File('lib/files/monsters.txt');
      final contents = file.readAsStringSync();
      final lines = contents.split('\n');

      for (var line in lines) {
        if (line.trim().isEmpty) continue;

        final stats = line.split(',');
        if (stats.length != 3) throw FormatException('Invalid monster data: $line');

        String name = stats[0].trim();
        int health = int.parse(stats[1].trim());
        int maxAttack = int.parse(stats[2].trim());

        monsters.add(Monster(name, health, maxAttack));
      }
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      // 기본 몬스터 추가
      monsters.add(Monster('Batman', 30, 20));
      monsters.add(Monster('Spiderman', 20, 30));
      monsters.add(Monster('Superman', 30, 10));
    }
  }

  String getCharacterName() {
    String name = '';
    bool isValidName = false;

    while (!isValidName) {
      print('캐릭터의 이름을 입력하세요: ');
      String? input = stdin.readLineSync();

      if (input != null && input.isNotEmpty) {
        // 한글, 영문 대소문자만 허용하는 정규표현식
        RegExp nameRegex = RegExp(r'^[a-zA-Z가-힣]+$');

        if (nameRegex.hasMatch(input)) {
          name = input;
          isValidName = true;
        } else {
          print('유효하지 않은 이름입니다. 한글과 영문 대소문자만 사용할 수 있습니다.');
        }
      } else {
        print('이름을 입력해주세요.');
      }
    }

    return name;
  }

  void printCharacterStatus() {
    print('${character.name} - 체력: ${character.health}, 공격력: ${character.attack}, 방어력: ${character.defense}');
  }

  void saveResult() {
    print('결과를 저장하시겠습니까? (y/n): ');
    String? choice = stdin.readLineSync();

    if (choice?.toLowerCase() == 'y') {
      try {
        final file = File('lib/files/result.txt');
        String result = character.health > 0 ? '승리' : '패배';
        String content = '${character.name}, ${character.health}, $result';

        file.writeAsStringSync(content);
        print('결과가 저장되었습니다.');
      } catch (e) {
        print('결과를 저장하는 데 실패했습니다: $e');
      }
    }
  }
}