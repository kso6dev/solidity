pragma solidity ^0.4.17;

//mon zombie mangeur de kitty:
//https://share.cryptozombies.io/fr/lesson/2/share/soseji?id=YXV0aDB8NWI5N2QwZjU4ZWMyMjc0NjcxOGJiNjZi

import "./zombiefactory.sol";

//Pour que notre contrat puisse parler avec un autre contrat que nous ne possédons pas sur la blockchain, 
//nous allons avoir besoin de définir une interface.
/*
Nous avons regardé le code source de CryptoKitties, 
et avons trouvé une fonction appelée getKitty 
qui retourne toutes les données des chatons, 
"gènes" inclus (c'est ce dont nous avons besoin pour créer un nouveau zombie !).
*/
contract KittyInterface {
    function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes);
}

//un contrat peut hériter d'un autre contrat et donc y accéder
contract ZombieFeeding is ZombieFactory {

    //address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;//c'est l'adresse du contrat CryptoKitties
    KittyInterface kittyContract;// = KittyInterface(ckAddress);//on instancie le contrat CryptoKitties à l'aide de son adresse et de son interface

    function setKittyContractAddress(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }
    /*
    En Solidity, il y a deux endroits pour stocker les variables - dans le storage (stockage) ou dans la memory (mémoire).
    Le stockage est utilisé pour les variables stockées de manière permanente dans la blockchain. 
    Les variables mémoires sont temporaires, et effacées entre les appels de fonction extérieure à votre contrat. 
    C'est un peu comme le disque dur et la mémoire vive de votre ordinateur.
    La plupart du temps, vous n'aurez pas besoin d'utiliser ces mots clés car Solidity gère ça tout seul.
    les variables d'état (déclarées en dehors des fonctions) sont par défaut storage et écrites de manière permanente dans la blockchain, 
    alors que les variables déclarées à l'intérieur des fonctions sont memory et disparaissent quand l'appel à la fonction est terminé.
    ex:
        struct Sandwich {
        string name;
        string status;
    }

    Sandwich[] sandwiches;

    function eatSandwich(uint _index) public {
        // Sandwich mySandwich = sandwiches[_index];

        // ^ Cela pourrait paraître simple, mais Solidity renverra un avertissement
        // vous indiquant que vous devriez déclarer explicitement `storage` ou `memory` ici.

        // Vous devriez donc déclarez avec le mot clé `storage`, comme ceci :
        Sandwich storage mySandwich = sandwiches[_index];
        // ...dans ce cas, `mySandwich` est un pointeur vers `sandwiches[_index]`
        // dans le stockage et...
        mySandwich.status = "Eaten!";
        // ... changera définitivement `sandwiches[_index]` sur la blockchain.

        // Si vous voulez juste une copie, vous pouvez utiliser `memory`:
        Sandwich memory anotherSandwich = sandwiches[_index + 1];
        // ...dans ce cas, `anotherSandwich` sera simplement une copie des
        // données dans la mémoire et...
        anotherSandwich.status = "Eaten!";
        // ... modifiera simplement la variable temporaire et n'aura pas
        // d'effet sur `sandwiches[_index + 1]`. Mais vous pouvez faire ceci :
        sandwiches[_index + 1] = anotherSandwich;
        // ...si vous voulez copier les modifications dans le stockage de la blockchain.
    }
    */

    //on peut passer un pointeur de stockage d'une structure en param d'une fonction:
    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(now + coolDownTime);
    }

    function _isReady(Zombie storage _zombie) internal view returns (bool) {
        return (_zombie.readyTime <= now);
    }
    
    function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal {
        require(zombieToOwner[_zombieId] == msg.sender);//on ne peut nourrir que son propre zombie
        Zombie storage myZombie = zombies[_zombieId];//on créé une instance du zombie à nourrir
        require(_isReady(myZombie));
        uint newTargetDna = _targetDna % dnaModulus;//on s'assure que l'adn de la cible ne fait pas plus de 16 chiffres
        uint newDna = (newTargetDna + myZombie.dna) / 2;//on fait la moyenne des 2 adn
        
        //si on mange un kitty, on change l'adn pour qu'il finisse par 99
        //ATTENTION pour comparer 2 strings on compare toujours leurs hachages keccak256
        if (keccak256(_species) == keccak256("kitty"))
        {
            newDna = newDna - newDna % 100 + 99;
            //en gros le calcul est le suivant: si dna = 1234567890123456
            //dna % 100 va donner 56 car dna / 100 = 12345678901234,56
            //donc on retire 56 à dna et on ajoute 99
        }
        _createZombie("NoName", newDna);
        _triggerCooldown(myZombie);
    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);//on récupère les gènes du kitty (c'est la 10è valeur retournée)
        feedAndMultiply(_zombieId, kittyDna, "kitty");//puis on nourrit notre zombie avec le kitty
    }
}