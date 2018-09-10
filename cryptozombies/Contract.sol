pragma solidity ^0.4.19

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);//event auquel on pourra s'abonner côté front end

    uint dnaDigits = 16; 
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        NewZombie(id, _name, _dna);
    }

    //une fonction view n'affiche que des var de notre contract sans les modifiers
    //une fonction pure n'interagit même pas avec des vars du contract, uniquement avec les param reçus
    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str)); //on créé un entier random à partir d'un string
        return rand % dnaModulus; //on retour un entier de 16 num X XXX XXX XXX XXX XXX 
    }

    function createRandomZombie(string _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}