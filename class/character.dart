import 'dart:math';

import 'monster.dart';

class Character {
  String name;
  int health;
  int attack;
  int defense;
  int lastDamageTaken = 0;

  Character(this.name, this.health, this.attack, this.defense);

  void attackMonster(Monster monster) {
    int damage = max(0, attack - monster.defense);
    monster.health -= damage;
    print('$name이(가) ${monster.name}에게 $damage 데미지를 입혔습니다.');
    monster.showStatus();
  }

  void defend() {
    health += lastDamageTaken;
    print('$name이(가) 방어 태세를 취했습니다.');
    print('마지막으로 입은 데미지($lastDamageTaken)만큼 체력이 회복되었습니다.');
  }

  void showStatus() {
    print('$name - 체력: $health, 공격력: $attack, 방어력: $defense');
  }
}