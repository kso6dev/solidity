pragma solidity ^0.4.17;

//mon armée de zombies:
//https://share.cryptozombies.io/fr/lesson/3/share/soseji?id=YXV0aDB8NWI5N2QwZjU4ZWMyMjc0NjcxOGJiNjZi

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

    modifier aboveLevel(uint _level, uint _zombieId) {
        require (zombies[_zombieId].level >= _level);
        _;
    }

    //on peut changer le nom de notre zombie s'il est au moins au level 2
    function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) {
        require (msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].name = _newName;
    }
    //on peut changer l'adn de notre zombie s'il est au moins au level 20
    function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
        require (msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].dna = _newDna;
    }

    function getZombiesByOwner(address _owner) external view returns (uint[]) {
        uint[] memory result = new uint[](ownerZombieCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < zombies.length; i++)
        {
            if (zombieToOwner[i] == _owner)
            {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
