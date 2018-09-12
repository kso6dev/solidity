pragma solidity ^0.4.17;

//mon armée:
//https://share.cryptozombies.io/fr/lesson/4/share/soseji?id=WyJhdXRoMHw1Yjk3ZDBmNThlYzIyNzQ2NzE4YmI2NmIiLDEsMTRd

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {

    uint randNonce = 0;//nbre unique qui sera incrémenté pour chaque random
    uint attackVictoryProbability = 70;//% de chance de réussir une attaque

    function randMod(uint _modulus) internal returns (uint) {
        randNonce++;//pour qu'on utilise toujours un nombre différent dans le calcul du random
        return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
        //on obtient un grand nombre qu'on divise par le modulus et notre nbre aléatoire est le restant
        //ex: 75611234559331 % 100 = 31 car 75611234559331 / 100 = 756112345593 reste 31
    }

    function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];//pointeur storage de notre zombie
        Zombie storage enemyZombie = zombies[_targetId];//pointeur storage du zombie ennemie
        uint rand = randMod(100);//entier aléatoire entre 0 et 99
        if (rand <=  attackVictoryProbability)
        {
            myZombie.winCount++;
            myZombie.level++;
            enemyZombie.lossCount++;
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        }
        else
        {
            myZombie.lossCount++;
            enemyZombie.winCount++;
        }
        _triggerCooldown(myZombie);
    }
}