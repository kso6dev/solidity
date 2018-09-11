pragma solidity ^0.4.17;

//mon premier zombie:
//https://share.cryptozombies.io/fr/lesson/1/share/soseji

//un contrat est situé dans une blockchain et ses fonctions peuvent être appelées par un user qui possède une adresse (wallet)
contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);//event auquel on pourra s'abonner côté front end

    uint dnaDigits = 16; 
    uint dnaModulus = 10 ** dnaDigits;

    //une structure est l'équivalent d'une classe
    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;//on map un uint avec l'adresse d'un wallet, le uint sera l'id d'un zombie
    mapping (address => uint) ownerZombieCount;//on map une adresse avec un uint qui représentera le nombre de zombies possédés par l'adresse 

    /*
    Voici un exemple d'utilisation de msg.sender pour mettre à jour un mapping.

    mapping (address => uint) favoriteNumber;

    function setMyNumber(uint _myNumber) public {
    // Mettre à jour notre mappage `favoriteNumber` pour stocker `_myNumber` sous `msg.sender`
    favoriteNumber[msg.sender] = _myNumber;
    // ^ La syntaxe pour stocker des données dans un mappage est la même qu'avec les tableaux
    }

    function whatIsMyNumber() public view returns (uint) {
    // On récupère la valeur stockée à l'adresse de l'expéditeur
    // Qui sera `0` si l'expéditeur n'a pas encore appelé `setMyNumber`
    return favoriteNumber[msg.sender];
    }
    Utiliser msg.sender apporte de la sécurité à la blockchain Ethereum - 
    la seule manière pour quelqu'un de modifier les données d'un autre serait de lui voler sa clé privée associée à son adresse Ethereum.
    */
    //une fonction internal est accessbile par les filles (protected)
    function _createZombie(string _name, uint _dna) internal {
        require(ownerZombieCount[msg.sender] == 0);//pour pouvoir exécuter cette fonction, il faut que le user ait 0 zombie
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        zombieToOwner[id] = msg.sender;//on met à jour le mapping zombieToWoner pour associer l'adresse de celui qui créé le zombie à l'id du zombie créé
        ownerZombieCount[msg.sender]++;//on incrémente le nombre de zombies pour l'adresse de celui qui vient de créer un nouveau zombie
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
