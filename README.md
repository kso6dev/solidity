# solidity
solidity and blockchain tests

 une fois que vous avez déployé un contrat Ethereum, il est immuable, ce qui veut dire qu'il ne pourra plus jamais être modifié ou mis à jour.

Le code que vous allez déployer initialement pour un contrat restera de manière permanente sur la blockchain. C'est pour cela que la sécurité est une préoccupation si importante en Solidity. S'il y a une faille dans le code de votre contrat, il n'y aucun moyen pour vous de le patcher plus tard. Vous devrez dire à vos utilisateurs d'utiliser une adresse de contrat différente qui a le correctif.

Mais c'est aussi une des fonctionnalités des smart contracts. Le code est immuable. Si vous lisez et vérifiez le code d'un smart contract, vous pouvez être sûr que chaque fois que vous appellerez une fonction, cela fera exactement ce que le code dit de faire. Personne ne pourra changer cette fonction plus tard et vous n'aurez pas de résultats inattendus.

 il y a une pratique courante qui consiste à rendre les contrats Ownable (avec propriétaire) - ce qui veut dire qu'ils ont un propriétaire (vous) avec des privilèges spéciaux.

Le contrat Ownable d'OpenZeppelin
Ci-dessous vous trouverez le contrat Ownable issue de la bibliothèque Solidity d'OpenZeppelin. OpenZeppelin est une bibliothèque de smart contracts sécurisés et approuvés par la communauté que vous pouvez utiliser dans vos propres DApps. 
VOIR https://openzeppelin.org/

/**
  * @title Ownable
  * @dev Le contrat Ownable a une adresse de propriétaire, et offre des fonctions de contrôle
  * d’autorisations basiques, pour simplifier l’implémentation des "permissions utilisateur".
  */
contract Ownable {
  address public owner;
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

   /**
    * @dev Le constructeur Ownable défini le `owner` (propriétaire) original du contrat égal
    * à l'adresse du compte expéditeur (msg.sender).
    */
  function Ownable() public {
    owner = msg.sender;
  }

  /**
   * @dev Abandonne si appelé par un compte autre que le `owner`.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

   /**
    * @dev Permet au propriétaire actuel de transférer le contrôle du contrat
    * à un `newOwner` (nouveau propriétaire).
    * @param newOwner C'est l'adresse du nouveau propriétaire
    */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}

Modificateurs de fonction : modifier onlyOwner(). Les modificateurs sont comme des demi-fonctions qui permettent de modifier d'autres fonctions, souvent pour vérifier des conditions avant l'exécution. Dans ce cas, onlyOwner peut être utilisé pour limiter l'accès pour que seulement (only) le propriétaire (owner) du contrat puisse exécuter cette fonction.

on pourra alors déclarer une fonction modifiée par onlyOwner
De cette manière, onlyOwner sera appelé avant cette fonction puis l'exécutera finalement au moment de l'exécution du _;
ex:
function screamIfYouAreOwner() external onlyOwner {
    scream("HAAAAAA");
}
ATTENTION:
Donner des privilèges spéciaux au propriétaire du contrat comme là est souvent nécessaire, cependant cela pourrait aussi être utilisé malicieusement. Par exemple, le propriétaire pourrait ajouter une fonction de porte dérobée qui lui permettrait de transférer n'importe quel zombie à lui-même !

C'est donc important de se rappeler que ce n'est pas parce qu'une DApp est sur Ethereum que cela veut dire qu'elle est décentralisée - vous devez lire le code source en entier pour vous assurez que le propriétaire n'a pas de privilèges qui pourraient vous inquiéter. En tant que développeur, il existe un équilibre entre garder le contrôle d'un DApp pour corriger de potentiels bugs, et construire une plateforme sans propriétaire en laquelle vos utilisateurs peuvent avoir confiance pour sécuriser leurs données.

Gas (gaz) - le carburant des DApps Ethereum
En Solidity, vos utilisateurs devront payer à chaque fois qu'ils exécutent une fonction de votre DApp avec une monnaie appelée gas. Les utilisateurs achètent du gas avec de l'Ether (la monnaie d'Ethereum), vos utilisateurs doivent donc dépenser de l'ETH pour exécuter des fonctions de votre DApp.

La quantité de gas requit pour exécuter une fonction dépend de la complexité de cette fonction. Chaque opération individuelle à un coût en gas basé approximativement sur la quantité de ressources informatiques nécessaires pour effectuer l'opération (ex: écrire dans le storage est beaucoup plus cher que d'ajouter deux entiers). Le coût en gas total de votre fonction est la somme du coût de chaque opération individuelle.

Parce qu'exécuter des fonctions coûte de l'argent réel pour les utilisateurs, l'optimisation de code est encore plus importante en Solidity que pour les autres langages de programmation. Si votre code est négligé, vos utilisateurs devront payer plus cher pour exécuter vos fonctions - et cela pourrait résulter en des millions de dollars de frais inutiles répartis sur des milliers d'utilisateurs.

Pourquoi le gas est nécessaire ?
Ethereum est comme un ordinateur gros et lent, mais extrêmement sécurisé. Quand vous exécuter une fonction, chaque nœud du réseau doit exécuter la même fonction pour vérifier le résultat - c'est ces milliers de nœuds vérifiant chaque exécution de fonction qui rendent Ethereum décentralisé et les données immuables et résistantes à la censure.

Les créateurs d'Ethereum ont voulu être sur que personne ne pourrait bloquer le réseau avec une boucle infinie, ou s'accaparer de toutes les ressources du réseau avec des calculs vraiment complexes. C'est pour cela que les transactions ne sont pas gratuites, et que les utilisateurs doivent payer pour faire des calculs et pour le stockage.

Remarque : Ce n'est pas forcément vrai pour des sidechains, comme celles que les auteurs de CryptoZombies construisent à Loom Network. Cela ne ferait pas de sens de faire tourner un jeu comme World of Warcraft directement sur le réseau principal Ethereum - le coût en gas serait excessivement cher. Mais il pourrait tourner sur une sidechain avec un algorithme de consensus différent.

nous avons dit qu'il existait d'autres types de uint : uint8, uint16, uint32, etc.

Normalement, il n'y a pas d’intérêt à utiliser ces sous-types car Solidity réserve 256 bits de stockage indépendamment de la taille du uint. Par exemple, utiliser un uint8 à la place d'un uint (uint256) ne vous fera pas gagner de gas.

Mais il y a une exception : dans les struct.

Si vous avez plusieurs uint dans une structure, utiliser des plus petits uint quand c'est possible permettra à Solidity d'emboîter ces variables ensemble pour qu'elles prennent moins de place. Par exemple :

struct NormalStruct {
  uint a;
  uint b;
  uint c;
}

struct MiniMe {
  uint32 a;
  uint32 b;
  uint c;
}

Pour cette raison, à l'intérieur d'une structure, il sera préférable d'utiliser le plus petit sous-type possible.

Il sera aussi important de grouper les types de données (c.-à.-d. les mettre à coté dans la structure) afin que Solidity puisse minimiser le stockage nécessaire. Par exemple, une structure avec des champs uint c; uint32 a; uint32 b; coûtera moins cher qu'une structure avec les champs uint32 a; uint c; uint32 b; car les champs uint32 seront regroupés ensemble.

Unités de temps
Solidity fourni nativement des unités pour gérer le temps.

La variable now (maintenant) va retourner l'horodatage actuel unix (le nombre seconde écoulées depuis le 1er janvier 1970). L'horodatage unix au moment où j'écris cette phrase est 1515527488.

Remarque : L'horodatage unix est traditionnellement stocké dans un nombre 32-bit. Cela mènera au problème "Année 2038", quand l'horodatage unix 32-bits aura débordé et cassera beaucoup de système existant. Si nous voulons que notre DApp continue de marcher dans 20 ans, nous pouvons utiliser un nombre 64-bit à la place - mais nos utilisateurs auront besoin de dépenser plus de gas pour utiliser notre DApp pendant ce temps. Décision de conception !

Solidity a aussi des unités de temps seconds (secondes), minutes, hours (heures), days (jours) et years (ans). Ils vont se convertir en un uint correspondant au nombre de seconde de ce temps. Donc 1 minutes est 60, 1 hours est 3600 (60 secondes x 60 minutes), 1 days est 86400 (24 heures x 60 minutes x 60 seconds), etc.

Voici un exemple montrant l'utilité de ces unités de temps :

uint lastUpdated;

// Défini `lastUpdated` à `now`
function updateTimestamp() public {
  lastUpdated = now;
}

// Retournera `true` si 5 minutes se sont écoulées
// depuis que `updateTimestamp` a été appelé, `false`
// si 5 minutes ne se sont pas passées
function fiveMinutesHavePassed() public view returns (bool) {
  return (now >= (lastUpdated + 5 minutes));
}


es modificateurs de fonction peuvent aussi prendre des arguments, par exemple :

// Un mappage pour stocker l'âge d'un utilisateur :
mapping (uint => uint) public age;

// Un modificateur qui nécessite que l'utilisateur soit plus âgé qu'un certain âge :
modifier olderThan(uint _age, uint _userId) {
  require (age[_userId] >= _age);
  _;
}

// Doit avoir plus de 16 ans pour conduire une voiture (du moins, aux US).
// Nous pouvons appeler le modificateur `olderThan` avec des arguments, comme :
function driveCar(uint _userId) public olderThan(16, _userId) {
  // Logique de la fonction
}

Les fonctions view ne coûtent pas de gas
Les fonctions view ne coûtent pas de gas quand elles sont appelées extérieurement par un utilisateur.

C'est parce que les fonctions view ne changent rien sur la blockchain - elles lisent seulement des données. Marquer une fonction avec view indique à web3.js qu'il a seulement besoin d'interroger votre nœud local d'Ethereum pour faire marcher la fonction, et il n'a pas besoin de créer une transaction sur la blockchain (qui devra être exécuter sur tous les nœuds et qui coûtera du gas).

Remarque : Si une fonction view est appelée intérieurement à partir d'une autre fonction du même contrat qui n'est pas une fonction view, elle coûtera du gas. C'est parce que l'autre fonction va créer une transaction sur Ethereum, et aura besoin d'être vérifiée par chaque nœud. Ainsi les fonctions view sont gratuites seulement quand elles sont appelées extérieurement.

Une des opérations les plus coûteuse en Solidity est d'utiliser storage - particulièrement quand on écrit.

C'est parce qu'à chaque fois que vous écrivez ou changez un bout d'information, c'est écrit de manière permanente sur la blockchain. Pour toujours ! Des milliers de nœuds à travers le monde vont stocker cette information sur leurs disques durs, et cette quantité d'information continue de grandir au fur et à mesure que la blockchain grandie. Et il y a un prix à cela.

Afin de réduire les coûts, vous voulez éviter d'écrire des données en stockage à part quand c'est absolument nécessaire. Par moment cela peut impliquer une logique de programmation qui à l'air inefficace - comme reconstruire un tableau dans la memory à chaque fois que la fonction est appelée au lieu de sauvegarder ce tableau comme une variable afin de le retrouver rapidement.

Dans la plupart des langages de programmation, faire une boucle sur un grand ensemble de données est coûteux. Mais en Solidity, c'est beaucoup moins cher que d'utiliser storage s'il y a une fonction external view, puisque view ne coûte aucun gas. (Et les gas coûte réellement de l'argent pour vos utilisateurs !).

Déclarer des tableaux dans la mémoire
Vous pouvez utiliser le mot clé memory avec des tableaux afin de créer un nouveau tableau dans une fonction sans avoir besoin de l'écrire dans le stockage. Le tableau existera seulement jusqu'à la fin de l'appel de la fonction, et cela sera beaucoup plus économique, d'un point de vue du gas, que de mettre à jour un tableau dans storage - c'est gratuit si c'est une fonction view appelée extérieurement.

Voici comment déclarer un tableau dans la mémoire :

function getArray() external pure returns(uint[]) {
  // Instancier un nouveau tableau d'une longueur 3 dans la mémoire
  uint[] memory values = new uint[](3);
  // Lui ajouter des valeurs
  values.push(1);
  values.push(2);
  values.push(3);
  // Renvoyer le tableau
  return values;
}

Remarque : Les tableaux mémoires doivent être créés avec un argument de longueur (dans cet exemple, 3). Ils ne peuvent pas encore être redimensionnés avec array.push(), mais cela pourrait changer dans les prochaines versions de Solidity.

