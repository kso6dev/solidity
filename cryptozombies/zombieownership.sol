pragma solidity ^0.4.17;

import "./zombieattack.sol";
import "./erc721.sol";

//mon armée:
//https://share.cryptozombies.io/fr/lesson/5/share/kaiser?id=YXV0aDB8NWI5N2QwZjU4ZWMyMjc0NjcxOGJiNjZi

/// @title Un contrat qui permet de gère le transfère de propriété d'un zombie
/// @author k.so.6.dev
/// @notice Conforme aux spécificités provisoires de l'implémentation ERC721 d'OpenZeppelin
/// @dev c'est ici que nous allons stocker la logique ERC721
contract ZombieOwnerShip is ZombieBattle, ERC721 {

    mapping (uint => address) zombieApprovals;//permet de stocker quelle adresse est approuvée pour prendre un token (tokenId)  
    
    /// @notice retourne le solde de zombies d'un utilisateur/d'une adresse
    /// @param _owner étant l'adresse de l'utilisateur dont on veut connaitre le solde.
    /// @return le nombre de zombies possédés par l'utilisateur
    /// @dev ça vient du tuto cryptozombies
    function balanceOf(address _owner) public view returns (uint256 _balance) {
        return ownerZombieCount[_owner];
    }   

    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        return zombieToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        //ownerZombieCount[_to]++;
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);//pour éviter les débordements on utilise la library SafeMath pour les opérations avec les uint
        //ownerZombieCount[_from]--;
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);//pour éviter les débordements on utilise la library SafeMath pour les opérations avec les uint
        zombieToOwner[_tokenId] = _to;
        Transfer(_from, _to, _tokenId);//event du contrat ERC721
    } 

    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        _transfer(msg.sender, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        zombieApprovals[_tokenId] = _to;
        Approval(msg.sender, _to, _tokenId);//event du contrat ERC721
    }

    function takeOwnership(uint256 _tokenId) public {
        require (zombieApprovals[_tokenId] == msg.sender);
        address owner = ownerOf(_tokenId);
        _transfer(owner, msg.sender, _tokenId);
    }

    /*
    Garder en tête que c'était une implémentation minimale. 
    Il y a d'autres fonctionnalités que nous voudrions ajouter à notre implémentation, 
    comme s'assurer que les utilisateurs ne transfèrent pas accidentellement leurs zombies à l'adresse 0 
    (on appelle ça brûler un token - l'envoyer à une adresse dont personne n'a la clé privée, le rendant irrécupérable). 
    Ou rajouter une logique d'enchère sur notre DApp. 
    Si vous voulez voir un exemple d'une implémentation plus détaillée, vous pouvez regarder le contrat ERC721 d'OpenZeppelin après ce tutoriel
    */
}