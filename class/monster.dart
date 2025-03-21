import 'dart:math';

import 'character.dart';

class Monster {
  String name;
  int health;
  int maxAttack;
  int attack = 0;
  int defense = 0;
  Random random = Random();

  Monster(this.name, this.health, this.maxAttack) {
    attack = max(maxAttack, 5); // 최소 공격력 설정
  }

  void attackCharacter(Character character) {
    int damage = max(0, attack - character.defense);
    character.health -= damage;
    character.lastDamageTaken = damage; // 마지막으로 받은 데미지 저장
    print('$name이(가) ${character.name}에게 $damage 데미지를 입혔습니다.');
  }

  void showStatus() {
    print('$name - 체력: $health, 공격력: $attack');
  }
}