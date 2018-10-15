# solidity
solidity and blockchain tests

Je voudrais tous vous
remercier d'avoir pris le temps de faire ce cours de programmation.
Je sais que c'est accessible gratuitement, et ça le restera toujours,
mais nous avons quand même mis toute notre énergie pour que ce cours
soit le meilleur possible.

Nous en sommes simplement au début de la programmation sur Blockchain.
Nous avons déjà bien avancé, mais il y a tellement de façon de rendre
cette communauté meilleure. Si nous avons fait une erreur quelque part,
vous pouvez nous aider avec une pull request ici :
https://github.com/loomnetwork/cryptozombie-lessons

Ou si vous avez des idées, commentaires, ou si vous voulez
tout simplement dire bonjour - rejoignez-nous sur notre communauté
Telegram à https://t.me/loomnetwork


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

Rappels:
Il existent des modificateurs de visibilité qui contrôlent quand et depuis où la fonction peut être appelée : private veut dire que la fonction ne peut être appelée que par les autres fonctions à l'intérieur du contrat; internal est comme private mais en plus, elle peut être appelée par les contrats qui héritent de celui-ci; avec external, la fonction ne peut être appelée que depuis l'extérieur du contrat; et enfin avec public, elle peut être appelée depuis n'importe où, à l'intérieur et à l'extérieur.

Il existent aussi des modificateurs d'état, qui nous indiquent comment la fonction interagie avec la BlockChain : view nous indique qu'en exécutant cette fonction, aucune donnée ne saura sauvegardée/modifiée. pure nous indique que non seulement aucune donnée ne saura sauvée sur la BlockChain, mais qu'en plus aucune donnée de la BlockChain ne sera lue. Ces 2 fonctions ne coûtent pas de gas si elles sont appelées depuis l'extérieur du contrat (mais elle coûtent du gas si elles sont appelées intérieurement par une autre fonction).

Ensuite nous avons les modificateurs personnalisés: modifier
qui permettent de déterminer une logique personnalisée afin de choisir
de quelle manière le modifier va affecter une fonction

Le modificateur payable
Une des choses qui rend Solidity et Ethereum vraiment cool est le modificateur payable, une fonction payable est une fonction spéciale qui peut recevoir des Ether.

Réfléchissons une minute. Quand vous faC'est particulièrement une bonne habitude de commenter son code pour expliquer le comportement attendu de chaque fonction de votre contrat. De cette manière, un autre développeur (ou vous, après 6 mois loin de votre projet !) peut parcourir votre code pour avoir une compréhension rapide du fonctionnement sans avoir à lire le code en détail.

Le standard dans la communauté Solidity est d'utiliser un format appelé natspec, qui ressemble à ça :

/// @title Un contrat pour des opérations mathématiques basiques
/// @author H4XF13LD MORRIS 💯💯😎💯💯
/// @notice Pour l'instant, ce contrat rajouter simplement une fonction multiplication
contract Math {
  /// @notice Multiplie 2 nombres ensemble
  /// @param x le premier uint.
  /// @param y le deuxième uint.
  /// @return z le résultat de (x * y)
  /// @dev Cette fonction ne vérifie pas les débordement pour l'instant
  function multiply(uint x, uint y) returns (uint z) {
    // C'est un commentaire normal, qui ne sera pas pris en compte par natspec
    z = x * y;
  }
}
@title (titre) and @author (auteur) sont plutôt évidents.

@notice explique à un utilisateur ce que le contrat / fonction fait. @dev est pour donner plus de détails aux développeurs.

@param et @return servent à décrire chaque paramètres et ce que la fonction renvoie.

Vous n'avez pas tout le temps besoin d'utiliser tous ces tags pour chaque fonction — tous les tags sont optionnels. Au minimum, laissez une note @dev pour expliquer ce que chaque fonction fait.ites un appel à une fonction API sur un serveur normal, vous ne pouvez pas envoyer des dollars US en même temps - pas plus que des Bitcoin.

Mais en Ethereum, puisque la monnaie (Ether), les données (charge utile de la transaction) et le code du contrat lui-même sont directement sur Ethereum, il est possible pour vous d'appeler une fonction et de payer le contrat en même temps.

Cela permet un fonctionnement vraiment intéressant, comme demander un certain paiement au contrat pour pouvoir exécuter une fonction.

Prenons un exemple
contract OnlineStore {
  function buySomething() external payable {
    // Vérifie que 0.001 ether a bien été envoyé avec l'appel de la fonction :
    require(msg.value == 0.001 ether);
    // Si c'est le cas, transférer l'article digital au demandeur de la fonction :
    transferThing(msg.sender);
  }
}

Ici, msg.value est la façon de voir combien d'Ether ont été envoyés au contrat, et ether est une unité intégrée.
Quelqu'un va appeler la fonction depuis web3.js (depuis l'interface utilisateur JavaScript de la DApp) de cette manière là :

// En supposant que `OnlineStore` pointe vers le contrat Ethereum :
OnlineStore.buySomething({from: web3.eth.defaultAccount, value: web3.utils.toWei(0.001)})

On remarque le champs value (valeur), où l'appel de la fonction Javascript indique combien d'ether envoyer (0.001). Si vous imaginez la transaction comme une enveloppe, et les paramètres que vous envoyez à l'appel de la fonction comme étant la lettre que vous mettez à l'intérieur, alors ajouter value revient au même que d'ajouter du cash à l'intérieur de l'enveloppe - la lettre et l'argent vont être donné au même moment au destinataire.

Remarque : Si une fonction n'est pas marquée payable et que vous essayez de lui envoyer des Ether, la fonction rejettera votre transaction.


Après avoir envoyé des Ether à un contrat, ils sont stockés dans le compte Ethereum du contrat, et resteront ici - à part si vous ajoutez une fonction pour retirer les Ether du contrat.

Vous pouvez écrire une fonction pour retirer des Ether du contrat de cette manière :

contract GetPaid is Ownable {
  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }
}
Vous remarquerez que nous utilisons owner et onlyOwner du contrat Ownable, en supposant qu'il a été importé.

Vous pouvez transférer des Ether à une adresse en utilisant la fonction transfer, et this.balance retournera la balance totale stockée sur le contrat. Si 100 utilisateurs ont payé 1 Ether à votre contrat, this.balance sera égal à 100 Ether.

Vous pouvez utilisez transfer pour envoyer des fonds à n'importe quelle adresse Ethereum. Par exemple, vous pouvez avoir une fonction qui renvoie les Ether à msg.sender s'il paye trop cher pour un article :

uint itemFee = 0.001 ether;
msg.sender.transfer(msg.value - itemFee);
Ou dans un contrat avec un acheteur et un vendeur, vous pouvez stocker l'adresse du vendeur, et quand quelqu'un achète son article, lui envoyer le montant payés par l'acheteur : seller.transfer(msg.value).

Ce sont quelques exemples de ce qui rend la programmation Ethereum vraiment cool - vous pouvez avoir des marchés décentralisés qui ne sont contrôlés par personne.

La génération de nombre aléatoire avec keccak256
La meilleure source d'aléatoire que nous avons avec Solidity est la fonction de hachage keccak256.

Pour générer un nombre aléatoire, nous pourrions faire quelque chose qui ressemble à :

// Générer un nombre aléatoire entre 1 et 100 :
uint randNonce = 0;
uint random = uint(keccak256(now, msg.sender, randNonce)) % 100;
randNonce++;
uint random2 = uint(keccak256(now, msg.sender, randNonce)) % 100;
Cela prendrait l'horodatage de now, le msg.sender, et incrémenterait nonce (un nombre qui est utilisé seulement une fois, pour ne pas exécuter la même fonction avec les même paramètres plusieurs fois).

Ensuite, cela utilisera le keccak pour convertir ces paramètres en un hachage aléatoire, le convertir en un uint et utiliser % 100 pour prendre seulement les 2 derniers chiffres, afin d'avoir un nombre aléatoire entre 0 et 99.

Cette méthode est vulnérable aux attaques d'un nœud malhonnête.
En Ethereum, quand vous appelez la fonction d'un contrat, vous diffuser une transaction à un nœud ou à des nœuds du réseau. Les nœuds du réseau vont ensuite collecter plusieurs transactions, vont essayer d'être le premier à résoudre un problème mathématique qui demande un calcul intensif appelé "Proof of Work" (Preuve de Travail) ou PoW, et vont ensuite diffuser ce groupe de transactions avec leur PoW dans un bloc au reste du réseau.

Quand un nœud a résolu un PoW, les autres nœuds arrêtent d'essayer de résoudre le PoW, ils vérifient que la liste des transactions de l'autre nœud soit valide, acceptent le bloc et passent à la résolution du bloc suivant.

Cela rend notre fonction nombre aléatoire exploitable.

Imaginez que nous avons un contrat pile ou face - face vous doublez votre argent, pile vous perdez tout. Et qu'il utilise la fonction ci-dessus pour déterminer si c'est pile ou face. (random >= 50 c'est face, random < 50 c'est pile).

Si j'ai un nœud, je pourrais publier une transaction seulement à mon propre nœud et ne pas la partager. Je pourrais exécuter le code de la fonction pile ou face pour voir si j'ai gagné - et si je perds, choisir de ne pas ajouter cette transaction dans le prochain bloc que je résous. Je pourrais continuer indéfiniment jusqu'à ce que je gagne et résolve le bloc, et gagner de l'argent.

Comment faire pour générer des nombres aléatoires de manière sûre sur Ethereum ?
Parce que tout le contenu de la blockchain est visible de tous les participants, c'est un problème difficile, et la solution est au-delà du cadre de ce tutoriel. Vous pouvez lire Cette discussion https://ethereum.stackexchange.com/questions/191/how-can-i-securely-generate-a-random-number-in-my-smart-contract
 pour vous faire une idée. Une des possibilités serait d'avoir un oracle pour avoir accès à une fonction aléatoire en dehors de la blockchain Ethereum.

Bien sur, puisque des dizaine de milliers de nœuds Ethereum sur le réseau rivalisent pour résoudre le prochain bloc, mes chances de résoudre le prochain bloc sont vraiment faibles. Il me faudrait énormément de puissance de calcul et de temps pour réussir à l'exploiter - mais si la récompense est assez élevée (si je pouvais parier 100 000 000$ sur la fonction pile ou face), cela vaudrait la peine de l'attaquer.

Même si cette fonction aléatoire N'EST PAS sécurisée sur Ethereum, en pratique, à part si notre fonction aléatoire a beaucoup d'argent en jeu, les utilisateurs de votre jeu n'auront sûrement pas assez de ressources pour l'attaquer.

Puisque nous construisons simplement un jeu à des fin de démonstration dans ce tutoriel, et qu'il n'y a pas vraiment d'argent en jeu, nous allons accepter les compromis d'utiliser un générateur de nombre aléatoire simple à implémenter, sachant qu'il n'est pas totalement sûr.

Dans une prochaine leçon, il se peut que nous voyons comment utiliser des oracles (un moyen sécurisé de récupérer des données en dehors d'Ethereum) pour générer une fonction aléatoire depuis l'extérieur de la blockchain.


un token Ethereum est un smart contract qui suit un ensemble de règles - à savoir, il implémente un ensemble de fonctions standards que tous les autres contrats de token partagent, comme transfer(address _to, uint256 _value) et balanceOf(address _owner).

Le smart contract a habituellement un mappage interne, mapping(address => uint256) balances, qui permet de connaître la balance de chaque adresse.

Un token est simplement un contrat qui permet de connaître combien de ce token chaque personne possède, et qui a certaines fonctions pour permettre aux utilisateurs de transférer leurs tokens à d'autres adresses.

Puisque tous les tokens ERC20 partagent le même ensemble de fonctions avec les mêmes noms, ils peuvent tous être manipulés de la même manière.

Cela veut dire que si vous construisez une application qui est capable d'interagir avec un token ERC20, elle sera aussi capable d'interagir avec n'importe quel token ERC20. De cette manière, d'autres tokens pourrons facilement être ajoutés à votre application sans avoir besoin de personnaliser le code. Vous pourrez simplement rajouter la nouvelle adresse du contrat du token, et boom, votre application pourra utiliser un nouveau token.

On pourrait prendre comme exemple un échange. Quand un échange ajoute un nouveau token ERC20, en vérité il a juste besoin d'ajouter un nouveau smart contract. Les utilisateurs pourront utiliser ce contrat pour envoyer des tokens sur l'adresse de l'échange, et l'échange pourra utiliser ce contrat pour renvoyer des tokens aux utilisateurs quand ils voudront retirer.

L'échange a simplement besoin d'implémenter une fois la logique de transfert, et quand il veut ajouter un nouveau token ERC20, il suffit simplement d'ajouter l'adresse du nouveau contrat à sa base de donnée.

Les tokens ERC20 sont vraiment pratiques pour servir en temps que monnaies

Il existe un autre standard de token qui est beaucoup plus adapté pour les crypto-collectibles comme CryptoZombies — ce sont les tokens ERC721.
Les tokens ERC721 ne sont pas interchangeable puisqu'ils sont supposés être unique, et ne sont pas divisibles. Vous pouvez seulement les échanger en entier, et ils ont chacun un ID unique. C'est exactement cela que l'on veut pour rendre nos zombies échangeables.

Remarque : En utilisant un standard comme ERC721, nous n'avons pas besoin d'implémenter les logiques qui définissent comment les joueurs vont échanger / vendre les zombies. Si on respecter les spécifications, quelqu'un d'autre pourrait construire une plateforme d'échange pour les actifs crypto-échangeables, et nos zombies ERC721 seraient compatibles avec cette plateforme. C'est un avantage évident d'utiliser un standard de token au lieu d'implémenter sa propre logique d'échange.

Regardons de plus près le standard ERC721 :

contract ERC721 {
  event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
  event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);

  function balanceOf(address _owner) public view returns (uint256 _balance);
  function ownerOf(uint256 _tokenId) public view returns (address _owner);
  function transfer(address _to, uint256 _tokenId) public;
  function approve(address _to, uint256 _tokenId) public;
  function takeOwnership(uint256 _tokenId) public;
}

Remarque : Le standard ERC721 est actuellement une ébauche, et il n'y a pas d'implémentation officiellement convenue. Pour ce tutoriel nous allons utiliser la version actuelle de la bibliothèque OpenZeppelin, mais il est possible que cela change dans le futur avant une sortie officielle. C'est donc une implémentation possible, mais ce n'est pas le standard officiel pour les tokens ERC721.

Implémenter le contrat d'un token
Quand on implémente le contrat d'un token, la première chose à faire et de copier l'interface dans son propre fichier Solidity et d'importer avec import "./erc721.sol";. Ensuite notre contrat doit en hériter, et nous pouvons réécrire chaque méthode avec une définition de fonction.

Garder en tête que c'était une implémentation minimale. Il y a d'autres fonctionnalités que nous voudrions ajouter à notre implémentation, comme s'assurer que les utilisateurs ne transfèrent pas accidentellement leurs zombies à l'adresse 0 (on appelle ça brûler un token - l'envoyer à une adresse dont personne n'a la clé privée, le rendant irrécupérable). Ou rajouter une logique d'enchère sur notre DApp. 
Si vous voulez voir un exemple d'une implémentation plus détaillée, vous pouvez regarder le contrat ERC721 d'OpenZeppelin après ce tutoriel

Amélioration de la sécurité des contrats : débordements par le haut et par le bas
Nous allons voir une fonctionnalité de sécurité majeure à prendre en compte quand vous écrivez des smart contracts : Prévenir les débordements.

C'est quoi un débordement ?

Imaginez un uint8, qui peut seulement avoir 8 bits. Ce qui veut dire que le binaire du plus grand nombre que l'on peut stocker est 11111111 (ou en décimal, 2^8 -1 = 255).

Regardez le code suivant. A quoi est égal number à la fin ?

uint8 number = 255;
number++;
Dans ce cas, nous avons causé un débordement par le haut - number est contre-intuitivement égal à 0 maintenant, même si on l'a augmenté. (Si vous ajoutez 1 au binaire 1111111, il repart à 00000000, comme une horloge qui passe de 23:59 à 00:00).

Un débordement par le bas est similaire, si vous soustrayez 1 d'un uint8 égal 0, le résultat sera 255 (car les uint sont non signés et ne peuvent pas être négatifs).

Nous n'utilisons pas de uint8 ici, et il paraît peut probable qu'un uint256 débordera avec des incrémentations de 1 par 1 (2^256 est un nombre très grand), mais c'est toujours bon de protéger notre contrat afin que notre DApp n'est pas des comportements inattendus dans le futur.

Utiliser SafeMath
Pour prévenir cela, OpenZeppelin a créé une bibliothèque appelée SafeMath qui empêche ces problèmes.

Mais d'abord, c'est quoi une bibliothèque ?

Une bibliothèque est un type de contrat spécial en Solidity. Une de leurs fonctionnalités est que cela permet de rajouter des fonctions à un type de donnée native.

Par exemple. avec la bibliothèque SafeMath, nous allons utiliser la syntaxe using SafeMath for uint256. La bibliothèque SafeMath à 4 fonctions — add, sub, mul, et div. Et maintenant nous pouvons utiliser ces fonctions à partir d'un uint256 en faisant :

using SafeMath for uint256;

uint256 a = 5;
uint256 b = a.add(3); // 5 + 3 = 8
uint256 c = a.mul(2); // 5 * 2 = 10

 le mot-clé library (bibliothèque) - les bibliothèques sont similaires aux contrats avec quelques différences. Dans ce cas là, les bibliothèques nous permettent d'utiliser le mot-clé using (utiliser), qui va automatiquement rajouter toutes les méthodes de cette bibliothèque à un autre type de donnée 

 Vous remarquerez que mul et add ont chacune besoin de 2 arguments, mais quand on déclare using SafeMath for uint, le uint qui appelle la fonction (test) est automatiquement passé comme premier argument.

 add ajoute simplement 2 uint comme +, mais elle contient aussi une déclaration assert (affirme) pour vérifier que la somme est plus grande que a. Cela nous protège d'un débordement.

 assert est la même chose que require, et va renvoyer une erreur si ce n'est pas vérifié. La différence entre assert et require c'est que require va rembourser l'utilisateur du gas restant quand la fonction échoue, alors que assert non. La plupart du temps vous allez vouloir utiliser require dans votre code, assert est plutôt utilisé quand quelque chose a vraiment mal tourné avec le code (comme un débordement d'uint).


C'est particulièrement une bonne habitude de commenter son code pour expliquer le comportement attendu de chaque fonction de votre contrat. De cette manière, un autre développeur (ou vous, après 6 mois loin de votre projet !) peut parcourir votre code pour avoir une compréhension rapide du fonctionnement sans avoir à lire le code en détail.

Le standard dans la communauté Solidity est d'utiliser un format appelé natspec, qui ressemble à ça :

/// @title Un contrat pour des opérations mathématiques basiques
/// @author H4XF13LD MORRIS 💯💯😎💯💯
/// @notice Pour l'instant, ce contrat rajouter simplement une fonction multiplication
contract Math {
  /// @notice Multiplie 2 nombres ensemble
  /// @param x le premier uint.
  /// @param y le deuxième uint.
  /// @return z le résultat de (x * y)
  /// @dev Cette fonction ne vérifie pas les débordement pour l'instant
  function multiply(uint x, uint y) returns (uint z) {
    // C'est un commentaire normal, qui ne sera pas pris en compte par natspec
    z = x * y;
  }
}
@title (titre) and @author (auteur) sont plutôt évidents.

@notice explique à un utilisateur ce que le contrat / fonction fait. @dev est pour donner plus de détails aux développeurs.

@param et @return servent à décrire chaque paramètres et ce que la fonction renvoie.

Vous n'avez pas tout le temps besoin d'utiliser tous ces tags pour chaque fonction — tous les tags sont optionnels. Au minimum, laissez une note @dev pour expliquer ce que chaque fonction fait.


Maintenant, nous allons créer une page web basique où vos utilisateurs pourrons interagir avec.

Pour cela, nous allons utiliser une bibliothèque JavaScript de la fondation Ethereum appelée Web3.js.

Qu'est-ce Web3.js ?
Rappelez-vous, le réseau Ethereum est fait de nœuds, dont chacun contient une copie de la blockchain. Quand vous voulez appeler une fonction d'un smart contract, vous avez besoin de faire une demande à l'un de ces nœuds en lui indiquant :

L'adresse du smart contract
La fonction que vous voulez appeler, et
Les paramètres que vous voulez donner à la fonction.
Les nœuds Ethereum parlent seulement un langage appelé JSON-RPC, qui n'est pas vraiment lisible par l'homme. Une requête pour indiquer à un nœud que vous voulez appeler une fonction d'un contrat ressemble à ça :

// Oui... Bonne chance pour écrire toutes vos fonctions comme ça !
// Faire défiler vers la droite ==>
{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from":"0xb60e8dd61c5d32be8058bb8eb970870f07233155","to":"0xd46e8dd67c5d32be8058bb8eb970870f07244567","gas":"0x76c0","gasPrice":"0x9184e72a000","value":"0x9184e72a","data":"0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"}],"id":1}
Heureusement, Web3.js cache ces vilaines requêtes de notre vue, et vous avez seulement besoin d'interagir avec une interface JavaScript pratique et lisible.

Au lieu d'écrire la requête ci-dessus, appelez une fonction dans votre code ressemblera à ceci :

CryptoZombies.methods.createRandomZombie("Vitalik Nakamoto 🤔")
  .send({ from: "0xb60e8dd61c5d32be8058bb8eb970870f07233155", gas: "3000000" })
Nous vous expliquerons la syntaxe plus en détails dans les prochains chapitres, mais pour l'instant, configurons votre projet pour utiliser Web3.js.

Pour commencer
Dépendamment de votre environnement de travail, vous pouvez ajouter Web3.js en utilisant la plupart des gestionnaires de paquets :

// Avec NPM
npm install web3

// Avec Yarn
yarn add web3

// Avec Bower
bower install web3

// ...etc.
Ou vous pouvez simplement télécharger le fichier .js minifié à partir de github et l'inclure dans votre projet :

<script language="javascript" type="text/javascript" src="web3.min.js"></script>
Puisque nous ne voulons pas faire trop d'hypothèses quand à votre environnent de travail et quel gestionnaire de paquets vous utilisez, pour ce tutoriel nous allons simplement inclure Web3.js dans notre projet en utilisant la balise de script ci-dessus.


Bien ! Maintenant que nous avons Web3.js dans notre projet, nous allons pouvoir l'initialiser et communiquer avec la blockchain.

La première chose dont nous avons besoin, c'est d'un fournisseur (provider) Web3.

Rappelez-vous, Ethereum est fait de nœuds qui partagent une copie des mêmes données. Configurer un fournisseur Web3 indique à notre code avec quel nœud nous devrions communiquer pour traiter nos lectures et écritures. C'est un peu comme configurer l'URL d'un serveur web distant pour des appels API d'une application web classique.

Vous pourriez héberger votre propre nœud Ethereum comme fournisseur. Mais il existe un service tiers qui vous facilitera la vie pour que vous n'ayez pas besoin de vous occuper de votre propre nœud Ethereum pour fournir une DApp à vos utilisateurs - Infura.

Infura
Infura est un service qui a plusieurs nœuds Ethereum avec une fonctionnalité de cache pour des lectures plus rapides, que vous pouvez accéder gratuitement depuis leur API. En utilisant Infura comme fournisseur, vous pouvez envoyer et recevoir des messages de la blockchain Ethereum de manière fiable, sans avoir à vous occuper de votre propre nœud.

Vous pouvez configurer Web3 pour utiliser Infura comme fournisseur web3 de cette manière :

var web3 = new Web3(new Web3.providers.WebsocketProvider("wss://mainnet.infura.io/ws"));
Cependant, vu que notre DApp va avoir beaucoup d'utilisateurs - et que ces utilisateurs vont ÉCRIRE sur la blockchain et pas seulement lire - nous allons avoir besoin d'un moyen pour ces utilisateurs de signer les transactions avec leurs clés privées.

Remarque : Ethereum (et les blockchains en général) utilise une paire de clés publique / privée pour signer numériquement les transactions. C'est un peu comme un mot de passe extrêmement compliqué pour signer numériquement. Ainsi, si je change des données sur la blockchain, je peux prouver grâce à la clé publique que je suis celui qui les a signées - mais puisque personne ne connaît ma clé privée, personne ne peut créer une transaction à ma place.

La cryptographie est compliquée, et à part si vous êtes un expert en sécurité et que vous savez vraiment ce que vous faîtes, ce ne sera sûrement pas une bonne idée de vouloir gérer les clés privées vous-même.

Heureusement, vous n'avez pas besoin - il existe déjà des services qui s'en occupe pour vous. Le plus connu est MetaMask.

MetaMask
MetaMask est une extension Chrome et Firefox qui permet aux utilisateurs de gérer de manière sécurisée leurs comptes Ethereum et leurs clés privées, et d'utiliser ces comptes pour interagir avec les sites web qui utilisent Web3.js. (Si vous ne l'avez jamais utilisé, vous devriez vraiment l'installer - ainsi votre navigateur web sera compatible avec Web3, et vous allez pouvoir interagir avec tous les sites qui communiquent avec la blockchain Ethereum !).

Et en tant que développeur, si vous voulez que vos utilisateurs interagissent avec votre DApp grâce à un site web dans leur navigateur web (comme vous faîtes avec le jeu CryptoZombies), vous allez vouloir le rendre compatible avec MetaMask.

Remarque : MetaMask utilise les serveurs d'Infura comme fournisseur web3, comme nous avons fait ci-dessus - mais il offre aussi la possibilité à l'utilisateur d'utiliser son propre fournisseur web3. En utilisant le fournisseur web3 de MetaMask, vous donnez à votre utilisateur le choix, et c'est une chose de moins à gérer pour votre application.

Utiliser le fournisseur web3 de MetaMask
MetaMask injecte son fournisseur web3 dans le navigateur dans l'objet JavaScript global web3. Votre application peut vérifier si web3 existe et si c'est le cas, utiliser web3.currentProvider comme fournisseur.

Voici un modèle de code fourni par MetaMask pour détecter si l'utilisateur a MetaMask installé ou non, et sinon lui dire qu'il doit l'installer pour utiliser notre application :

window.addEventListener('load', function() {

  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    // Use Mist/MetaMask's provider
    web3js = new Web3(web3.currentProvider);
  } else {
    // Handle the case where the user doesn't have web3. Probably
    // show them a message telling them to install MetaMask in
    // order to use our app.
  }

  // Now you can start your app & access web3js freely:
  startApp()

})
Vous pouvez utiliser ce code standard dans toutes les applications que vous créez afin de demander à l'utilisateur d'avoir MetaMask pour utiliser votre DApp.

Remarque : Il existe d'autres gestionnaires de clés privées que vos utilisateurs pourraient utiliser, comme le navigateur web Mist. Cependant, ils implémentent tous la variable web3 d'une manière similaire, la méthode que nous avons utilisé ci-dessus pour détecter le fournisseur web3 de l'utilisateur marchera aussi.

aintenant que nous avons initialiser Web3.js avec le fournisseur Web3 de MetaMask, nous allons configurer la communication avec notre smart contract.

Web3.js va avoir besoin de 2 choses pour pouvoir communiquer avec notre contrat : son adresse et son ABI.

Adresse du contrat
Après avoir fini d'écrire votre smart contract, vous allez le compiler et le déployer sur Ethereum. Nous allons voir le déploiement dans la prochaine leçon, mais vu que c'est assez différent que d'écrire du code, nous avons décidé de ne pas faire dans l'ordre et de parler de Web3.js en premier.

Après avoir déployer votre contrat, il sera associé à une adresse Ethereum pour toujours. Si vous vous rappelez la leçon 2, l'adresse du contrat CryptoKitties sur Ethereum est 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d.

Vous allez avoir besoin de copier cette adresse après le déploiement afin de pouvoir communiquer avec le smart contract.

ABI du contrat
L'autre chose que Web3.js à besoin pour communiquer avec votre contrat et son ABI.

ABI veut dire "Application Binary Interface" (Interface Binaire d'Application). Fondamentalement, c'est une représentation des fonctions de votre contrat au format JSON qui indique à Web3.js comment formater les appels aux fonctions pour que votre contrat les comprenne.

Quand vous compilez votre contrat pour le déployer sur Ethereum (ce que nous verrons dans la Leçon 7), le compilateur Solidity vous donnera son ABI, vous aller devoir le copier et le sauvegarder en plus de l'adresse de votre contrat.

Puisque nous n'avons pas encore vu le déploiement, pour cette leçon nous avons déjà compilé l'ABI pour vous et nous l'avons mis dans le fichier appelé cryptozombies_abi.js, stocké dans une variable appelée cryptoZombiesABI.

Si nous incluons cryptozombies_abi.js dans notre projet, nous pourrons accéder à l'ABI de CryptoZombies en utilisant cette variable.

Instancier un contrat Web3.js
Une fois que vous avez l'adresse de votre contrat et son ABI, vous pouvez l'instancier avec Web3 comme ceci :

// Instanciation de myContract
var myContract = new web3js.eth.Contract(myABI, myContractAddress);
A votre tour
Dans le <head> de notre document, ajouter une autre balise de script pour cryptozombies_abi.js afin que nous puissions importer l'ABI à notre projet.

Au début de notre balise <script> dans le <body>, déclarez une var appelée cryptoZombies, mais ne lui attribuez pas de valeur. Nous allons nous servir de cet variable plus tard pour stocker notre contrat instancié.

Ensuite, créez une function appelée startApp(). Nous la compléterons dans les 2 prochaines étapes.

La première chose que startApp() doit faire est de déclarer une var appelée cryptoZombiesAddress égale à "YOUR_CONTRACT_ADDRESS" (c'est l'adresse du contrat sur le réseau principal).

Enfin, nous devons instancier notre contrat. Définissez cryptoZombies égal à un nouveau web3js.eth.Contract comme nous l'avons fait dans l'exemple ci-dessus. (En utilisant cryptoZombiesABI, qui est importé avec notre balise de script, et avec l'adresse cryptoZombiesAddress ci-dessus).

Chapitre 4: Appeler les fonctions d'un contrat
Notre contrat est prêt ! Nous pouvons maintenant utiliser Web3.js pour communiquer avec.

Web3.js a deux méthodes que nous allons utiliser pour appeler les fonctions de notre contrat : call (appeler) et send (envoyer).

Call
call est utilisé pour les fonctions view etpure. C'est exécuté seulement sur le nœud local, et cela ne va pas créer de transaction sur la blockchain.

Rappel : les fonctions view et pure sont des fonctions en lecture seule et ne changent pas l'état de la blockchain. Elles ne coûtent pas de gas et l'utilisateur n'aura pas besoin de signer de transaction avec MetaMask.

En utilisant Web3,js, vous allez appeler (call) une fonction nommée myMethod avec le paramètre 123 comme ceci :

myContract.methods.myMethod(123).call()
Send
send va créer une transaction et changer l'état des données sur la blockchain. Vous aurez besoin d'utiliser send pour toutes les fonctions qui ne sont pas view ou pure.

Remarque : Envoyer une transaction avec send demandera à l'utilisateur de payer du gas, en faisant apparaître MetaMask pour leur demander de signer une transaction. Quand on utilise MetaMask comme fournisseur web3, tout cela se fait automatiquement quand on appelle send(), et on n'a pas besoin de faire quoique ce soit de spécial dans notre code. Plutôt cool !

En utilisant Web3.js, vous allez envoyer (send) une transaction appelant une fonction myMethod avec le paramètre 123 comme ceci :

myContract.methods.myMethod(123).send()
La syntaxe est quasiment identique que pour call().

Récupérer les données zombies
Maintenant nous allons voir un vrai exemple de la fonction call pour accéder aux données de notre contrat.

Rappelez-vous que nous avions rendu notre tableau de zombies public :

Zombie[] public zombies;
En Solidity, quand vous déclarez une variable public, cela crée automatiquement une fonction "getter" (une fonction de récupération) public avec le même nom. Si vous voulez récupérer le zombie avec l'id 15, vous l’appellerez comme si c'était une fonction : zombies(15).

Voici comment nous écririons notre fonction JavaScript de notre front-end qui récupérerait un id zombie, interrogerait notre contrat pour ce zombie, et renverrai le résultat :

Remarque : Tous les exemples de code que nous utilisons dans cette leçon utilisent la version 1.0 de Web3.js, qui utilise les promesses au lieu des callbacks. Beaucoup de tutoriels que vous allez voir en ligne utilisent une ancienne version de Web3.js. La syntaxe a beaucoup changée avec la version 1.0, si vous copiez du code d'autres tutoriels, assurez-vous qu'ils utilisent la même version que vous !

function getZombieDetails(id) {
  return cryptoZombies.methods.zombies(id).call()
}

// Appelle la fonction et fait quelque chose avec le résultat :
getZombieDetails(15)
.then(function(result) {
  console.log("Zombie 15: " + JSON.stringify(result));
});
Regardons ce qui vient de se passer.

cryptoZombies.methods.zombies(id).call() va communiquer avec le fournisseur Web3 et lui dire de renvoyer le zombie avec l'id à partir de Zombie[] public zombies de notre contrat.

Vous remarquerez que c'est asynchrone, comme tout appel API à un serveur externe. C'est pour cela que Web3 renvoie une promesse. (Si vous n'êtes pas familier avec les promesses JavaScript... C'est le moment de faire des devoirs supplémentaires avant de continuer !)

Une fois que la promesse est résolue (ce qui veut dire que nous avons reçu une réponse du fournisseur web3), notre exemple de code continue avec la déclaration then (ensuite), qui affiche result dans le terminal.

result sera un objet JavaScript qui ressemblera à :

{
  "name": "LE GRAND FRÈRE D'H4XF13LD MORRIS LE PLUS COOL",
  "dna": "1337133713371337",
  "level": "9999",
  "readyTime": "1522498671",
  "winCount": "999999999",
  "lossCount": "0" // Évidemment.
}
Nous pouvons ensuite avoir du code front-end qui récupère cet objet et l'affiche d'une bonne manière à l'utilisateur.

A votre tour
Nous avons déjà copié getZombieDetails dans le code pour vous.

Créez une fonction similaire pour zombieToOwner. Si vous vous rappelez de ZombieFactory.sol, nous avions un mappage :

mapping (uint => address) public zombieToOwner;
Définissez une fonction JavaScript appelée zombieToOwner. De la même manière que pour getZombieDetails ci-dessus, elle aura comme paramètre un id, et retournera un call Web3.js à zombieToOwner de notre contrat.

Après cela, créez une troisième fonction pour getZombiesByOwner. Si vous vous rappelez de ZombieHelper.sol, la définition de la fonction était :

function getZombiesByOwner(address _owner)
Notre fonction getZombiesByOwner aura un owner comme paramètre, et renverra un call Web3.js à getZombiesByOwner.


disons que nous voulons que la page d'accueil de notre application montre toute l'armée de zombie d'un utilisateur.

Évidemment nous allons d'abord devoir utiliser notre fonction getZombiesByOwner(owner) pour récupérer tous les IDs des zombies que l'utilisateur possède.

Mais notre contrat Solidity s'attend que owner soit une address Solidity. Comment connaître l'adresse de l'utilisateur de notre application ?

Obtenir l'adresse de l'utilisateur avec MetaMask
MetaMask permet à l'utilisateur de gérer plusieurs comptes avec leur extension.

Nous pouvons connaître le compte actif via la variable injectée web3 :

var userAccount = web3.eth.accounts[0]
Puisque l’utilisateur peut changer de compte actif n'importe quand avec MetaMask, notre application a besoin de surveiller cette variable pour voir si elle change et mettre à jour l'interface en conséquence. Par exemple, si la page d'accueil montre l'armée de zombie d'un utilisateur, quand il change de compte dans MetaMask, nous allons vouloir mettre à jour la page pour montrer l'armée de zombie du nouveau compte sélectionné.

Nous pouvons faire ça avec une boucle setInterval comme ceci :

var accountInterval = setInterval(function() {
  // Vérifie si le compte a changé
  if (web3.eth.accounts[0] !== userAccount) {
    userAccount = web3.eth.accounts[0];
    // Appelle une fonction pour mettre à jour l'interface avec le nouveau compte
    updateInterface();
  }
}, 100);
Ce code vérifie toutes les 100 millisecondes que userAccount est toujours égal à web3.eth.accounts[0] (c.à.d. que l'utilisateur a toujours son compte actif). Sinon, userAccount est réassigné au compte actuellement actif, et appelle une fonction pour mettre à jour l'interface.

A votre tour
Faisons en sorte de notre application montre l'armée de zombie de notre utilisateur au chargement initial de la page, et surveille le compte MetaMask actif pour mettre à jour l'interface s'il change.

Déclarez une var appelée userAccount, mais ne lui attribuez pas de valeur

À la fin de startApp(), copiez/collez le code standard accountInterval ci-dessus

Remplacez la ligne updateInterface(); avec un appel à getZombiesByOwner, avec comme paramètre userAccount

Mettez à la chaîne une déclaration then après getZombiesByOwner et passez le résultat à une fonction appelée displayZombies. (La syntaxe est : .then(displayZombies);).

Nous n'avons pas encore de fonction appelée displayZombies, mais nous l'implémenterons dans le prochain chapitre.


Chapitre 6: Afficher notre armée de zombie
Ce tutoriel serait incomplet si nous ne vous montrions pas comment afficher les données que vous obtenez du contrat.

Cependant, de façon réaliste, vous allez vouloir utiliser un framework front-end comme React ou Vue.js pour votre application, car ils vous simplifient vraiment la vie en tant que développeur front-end.

Afin de rester concentrer sur Ethereum et les smart contracts, nous allons simplement vous montrer un exemple rapide en JQuery pour vous montrer comment analyser et afficher les données récupérées de votre smart contract.

Afficher les données zombie - un exemple primaire
Nous avons ajouter un <div id="zombies"></div> vide au corps de notre document, ainsi qu'une fonction displayZombies vide.

Rappelez-vous du précédent chapitre, nous avons appelé displayZombies à l'intérieur de startApp() avec le résultat obtenu de l'appel à getZombiesByOwner. Il recevra un tableau d'IDs zombie qui ressemblera à :

[0, 13, 47]
Donc nous voulons que notre fonction displayZombies fasse :

Premièrement, supprime le contenu du div #zombies, s'il y a quelque chose à l'intérieur. (De cette manière, si l'utilisateur change de compte actif dans MetaMask, cela supprimera l'ancienne armée de zombie avant de charger la nouvelle).

Itère pour chaque id, et pour chacun appelle getZombieDetails(id) pour récupérer toutes les informations de ce zombie à partir de notre smart contract, ensuite

Mettre ces informations dans un gabarit HTML pour qu'elles soient correctement formatées pour l'affichage, et les rajouter au div #zombies.

Pour rappel, nous utilisons simplement du JQuery ici, qui n'a pas de gabarit par défaut, le résultat ne sera pas beau. Voici un exemple simple de comment nous pourrions afficher les données pour chaque zombie :

// On récupère les informations des zombies à partir de notre contrat. On renvoie un objet `zombie`
getZombieDetails(id)
.then(function(zombie) {
  // En utilisant les "template literals" d'ES6 pour injecter les variables dans l'HTML.
  // On rajoute chaque zombie à notre div #zombies
  $("#zombies").append(`<div class="zombie">
    <ul>
      <li>Name: ${zombie.name}</li>
      <li>DNA: ${zombie.dna}</li>
      <li>Level: ${zombie.level}</li>
      <li>Wins: ${zombie.winCount}</li>
      <li>Losses: ${zombie.lossCount}</li>
      <li>Ready Time: ${zombie.readyTime}</li>
    </ul>
  </div>`);
});
Qu'en est-il de l'affichage des images zombie ?
Dans l'exemple ci-dessus, nous affichons simplement l'ADN comme une chaîne de caractères. Mais dans votre DApp, vous allez vouloir convertir cela en images pour afficher votre zombie.

Nous avons fait cela en divisant l'ADN en plusieurs chaîne de caractères, et en ayant chaque pair de chiffre qui correspond à une image. De cette manière là :

// On obtient un entier entre 1 et 7 qui représente la tête de notre zombie :
var head = parseInt(zombie.dna.substring(0, 2)) % 7 + 1

// On a 7 images de tête avec des noms de fichiers séquentiels :
var headSrc = "../assets/zombieparts/head-" + head + ".png"
Chaque composant est positionné avec du CSS en utilisant le positionnement absolu, afin de le superposer sur les autres images.

Si vous voulez voir exactement comment nous l'avons implémenté, nous avons rendu le code Open Source de notre composant Vue.js que nous utilisons pour l'apparence des zombies, vous pouvez le voir ici. https://github.com/loomnetwork/zombie-char-component

Cependant, puisqu'il y a beaucoup de code dans ce fichier, c'est en dehors du cadre de ce tutoriel. Pour cette leçon, nous resterons avec l'exemple basique de l'implémentation JQuery ci-dessus, et nous vous laissons l'opportunité de faire une implémentation plus belle comme entraînement 😉

A votre tour
Nous avons créé une fonction displayZombies vide pour vous. Nous allons la compléter.

La première chose que nous voulons faire et de supprimer le contenu du div #zombies. En JQuery, vous pouvez faire cela avec $("#zombies").empty();.

Ensuite, nous allons vouloir itérer tous les ids, en utilisant une boule "for": for (id of ids) {

À l'intérieur de cette boucle, copiez/collez le bloc de code ci-dessus qui appelle getZombieDetails(id) pour chaque id et ensuite utilisez $("#zombies").append(...) pour l'ajouter à notre HTML.

Chapitre 7: Envoyer des transactions
Génial ! Maintenant notre interface va détecter le compte MetaMask de l'utilisateur, et va automatiquement afficher son armée de zombie sur la page d'accueil.

Maintenant nous allons voir comment changer les données de notre smart contract avec les fonctions send.

Il y a quelques différences majeures avec les fonctions call :

Envoyer avec send une transaction nécessite une adresse from de celui qui appelle la fonction (qui devient msg.sender dans votre code Solidity). Nous allons vouloir que ce soit l'utilisateur de notre DApp, afin que MetaMask affiche une fenêtre pour lui demander de signer la transaction.

Envoyer avec send une transaction coûte du gas

Il y a un certain délais entre le moment où l'utilisateur envoie une transaction avec send et le moment où cette transaction prend effet sur la blockchain. C'est parce qu'il faut attendre que la transaction soit incluse dans un bloc, et un bloc est créé toutes les 15 sec environ avec Ethereum. S'il y a beaucoup de transactions en attente, ou si l'utilisateur paye un prix de gas trop bas, notre transaction pourrait attendre plusieurs blocs avant d'être incluse, et cela pourrait prendre plusieurs minutes.

C'est pour ça que nous avons besoin que notre application gère la nature asynchrone de ce code.

Créer de zombies
Nous allons voir un exemple avec la première fonction de notre contrat qu'un utilisateur appellera : createRandomZombie.

Pour rappel, voici le code Solidity de notre smart contract :

function createRandomZombie(string _name) public {
  require(ownerZombieCount[msg.sender] == 0);
  uint randDna = _generateRandomDna(_name);
  randDna = randDna - randDna % 100;
  _createZombie(_name, randDna);
}
Et voici un exemple de comment appeler cette fonction avec Web3.js en utilisant MetaMask :

function createRandomZombie(name) {
  // Cela va prendre du temps, nous mettons à jour l'interface pour
  // signaler à l'utilisateur que la transaction a été envoyée
  $("#txStatus").text("Creating new zombie on the blockchain. This may take a while...");
  // Nous envoyons la tx à notre contrat :
  return cryptoZombies.methods.createRandomZombie(name)
  .send({ from: userAccount })
  .on("receipt", function(receipt) {
    $("#txStatus").text("Successfully created " + name + "!");
    // La transaction a été acceptée sur la blokchain, il faut mettre à jour l'interface
    getZombiesByOwner(userAccount).then(displayZombies);
  })
  .on("error", function(error) {
    // Si la transaction a échouée, on en informe l'utilisateur
    $("#txStatus").text(error);
  });
}
Notre fonction envoie avec send une transaction à notre fournisseur Web3, et met à la chaîne un écouteur d'évènements :

receipt (reçu) va être émis quand la transaction est incluse dans un bloc Ethereum, ce qui veut dire que notre zombie a été créé et sauvegardé dans notre contrat.
error (erreur) va être émis s'il y a un problème qui empêche la transaction d'être incluse dans un bloc, tel qu'un envoie insuffisant de gas par l'utilisateur. Nous allons vouloir informer l'utilisateur que la transaction n'a pas marché pour qu'il puisse réessayer.
Remarque : Vous avec le choix de spécifier le gas et gasPrice quand vous appelez send, ex : .send({ from: userAccount, gas: 3000000 }). Si vous ne le spécifiez pas, MetaMask va laisser l'utilisateur choisir ces valeurs.

A votre tour
Nous avons ajouté un div avec l'ID txStatus - de cette manière, nous pouvons l'utiliser pour informer l'utilisateur du statut de nos transactions.

En dessous de displayZombies, copiez/collez le code à partir de createRandomZombie ci-dessus.

Nous allons implémenter une autre fonction : feedOnKitty.

La logique pour appeler feedOnKitty est pratiquement la même - nous allons envoyer une transaction qui appelle la fonction, si la transaction réussie, un nouveau zombie sera créé, et nous aurons donc besoin de rafraîchir l'interface juste après.

Faites une copie de createRandomZombie juste en dessous, avec les changements suivant :

a) Appelez la 2ème fonction feedOnKitty, avec 2 paramètres : zombieId et kittyId

b) Le texte de #txStatus devra être : "En train de manger un chaton, cela peut prendre du temps..."

c) Faites que ça appelle feedOnKitty de notre contrat, et passez lui les 2 mêmes paramètres

d) Le message de réussite de #txStatus devra être : "A mangé un chaton et a engendré un nouveau Zombie !"

Chapitre 8: Appeler des fonctions payantes
Les logiques pour attack, changeName, et changeDna seront extrêmement similaires, elles sont faciles à implémenter et nous ne passerons donc pas de temps à les écrire dans cette leçon.

En fait, il y a déjà beaucoup de logique qui se répète dans ces appels de fonction, il serait donc utile de les refactoriser et de mettre le code commun dans sa propre fonction. (et d'utiliser un système de modèle pour les messages txStatus - Nous voyons déjà comme ça serait beaucoup plus clair avec un framework comme Vue.js !)

Voyons un autre type de fonction qui demande un traitement spécial en Web3.js - les fonctions payable.

la fonction Level Up !
Rappelez-vous dans ZombieHelper, nous avons ajouté une fonction payable où l'utilisateur pouvait faire passer un niveau :

function levelUp(uint _zombieId) external payable {
  require(msg.value == levelUpFee);
  zombies[_zombieId].level++;
}
Il est facile d'indiquer combien d'Ether envoyer avec une fonction, en faisant attention à une chose : nous devons spécifier combien envoyer en wei, pas en Ether.

Qu'est ce qu'un Wei ?
Un wei est la plus petite sous-unité d'un Ether - il y a 10^18 wei dans un ether.

Cela fait beaucoup de zéros à compter - Heureusement, Web3.js a un outil de conversion qui le fait pour nous.

// Cela va convertir 1 ETH en Wei
web3js.utils.toWei("1", "ether");
Dans notre DApp, nous avons défini levelUpFee = 0.001 ether, ainsi quand nous appelons notre fonction levelUp, l'utilisateur devra s'assurer qu'il envoie 0.001 Ether avec le code suivant :

cryptoZombies.methods.levelUp(zombieId)
.send({ from: userAccount, value: web3js.utils.toWei("0.001", "ether") })
A votre tour
Nous allons ajouter une fonction levelUp en dessous de feedOnKitty. Le code sera vraiment similaire à feedOnKitty, mais :

La fonction prendra un seul paramètre, zombieId

Avant la transaction, le texte de txStatus devra être : "Votre zombie est en train de gagner un niveau..."

Quand levelUp est appelé, "0.001" ETH converti avec toWei devra être envoyé, comme dans l'exemple ci-dessus

Si cela réussi, le texte devra afficher "Quelle puissance écrasante ! Le zombie a bien gagné un niveau"

Nous n'avons pas besoin de rafraîchir l'interface en appelant notre smart contract avec getZombiesByOwner — car dans ce cas là, la seule chose qui a changé c'est le niveau du zombie.

Chapitre 9: S'abonner à des évènements
Comme vous pouvez le voir, c'est plutôt simple d'interagir avec votre contrat via Web3.js - une fois que vous avez votre environnement configuré, appeler des fonctions et envoyer des transactions n'est pas vraiment différent qu'avec une API web classique.

Il y a encore un aspect que nous voulons couvrir - s'abonner à des évènements de votre contrat.

Écouter pour de nouveaux zombies
Si vous vous rapplez de zombiefactory.sol, nous avions un évènement appelé NewZombie qui était émis chaque fois qu'un nouveau zombie était créé :

event NewZombie(uint zombieId, string name, uint dna);
Avec Web3.js, vous pouvez vous abonner à un évènement pour que votre fournisseur web3 exécute une certaine logique de votre code à chaque fois qu'il est émis :

cryptoZombies.events.NewZombie()
.on("data", function(event) {
  let zombie = event.returnValues;
  // Nous pouvons accéder aux 3 valeurs de retour de cet évènement avec l'objet `event.returnValues` :
  console.log("A new zombie was born!", zombie.zombieId, zombie.name, zombie.dna);
}).on("error", console.error);
Vous remarquerez que cela va déclencher une alerte pour N'IMPORTE quel zombie créé dans notre DApp - et pas seulement pour l'utilisateur actuel. Et si nous voulions seulement des alertes pour l'utilisateur actuel ?

Utiliser indexed (indexé)
Afin de filtrer les évènements et écouter seulement les changements liés à l'utilisateur actuel, notre contrat Solidity devra utiliser le mot clé indexed, c'est ce que nous avons fait avec l'évènement Transfer de notre implémentation ERC721 :

event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
Dans ce cas, puisque _from et _to sont indexed, cela veut dire que nous pouvons les utiliser comme filtre dans notre écouteur d'évènements de notre front-end :

// On utilise `filter` pour seulement lancer ce code quand `_to` est égal à `userAccount`
cryptoZombies.events.Transfer({ filter: { _to: userAccount } })
.on("data", function(event) {
  let data = event.returnValues;
  // L’utilisateur actuel a reçu un zombie !
  // Faire quelque chose pour mettre à jour l'interface
}).on("error", console.error);
Comme vous pouvez le voir, utiliser les champs event et indexed est une bonne habitude pour écouter les changements de votre contrat et les refléter dans le front-end de votre application.

Interroger les évènements passés
Nous pouvons interroger les évènements passés en utilisant getPastEvents, et utiliser les filtres fromBlock et toBlock pour indiquer à Solidity l'intervalle de temps pour récupérer nos évènements ("block" dans ce cas fait référence au numéro de bloc Ethereum) :

cryptoZombies.getPastEvents("NewZombie", { fromBlock: 0, toBlock: "latest" })
.then(function(events) {
  // `events` est un tableau d'objets `event` pour lequel nous pouvons itérer, comme nous l'avons fait ci-dessus
  // Ce code donnera une liste de tous les zombies créés
});
Puisque vous pouvez utiliser cette méthode pour récupérer tous les évènements depuis la nuit des temps, cela peut être un cas d'utilisation intéressant : Utiliser les évènements comme un moyen de stockage moins cher.

Si vous vous rappelez, enregistrer des données sur la blockchain est un des opérations les plus chères en Solidity. Utiliser des évènements est beaucoup moins cher en terme de gas.

En contrepartie, les évènements ne sont pas lisibles depuis le smart contract. Mais c'est cas d'utilisation important à retenir si vous voulez stocker de l'information avec un historique sur la blockchain afin de le lire depuis le front-end de votre application.

Par exemple, nous pourrions l'utiliser pour avoir un historique de nos combats de zombies - nous pourrions créer un évènement à chaque fois qu'un zombie attaque et gagne. Le smart contract n'a pas besoin de cette information pour calculer quoique ce soit, mais cela pourrait être une information utile pour le front-end de notre application.

A votre tour
Nous allons ajouter du code pour écouter l'évènement Transfer, et mettre à jour notre interface si l’utilisateur actuel reçoit un nouveau zombie.

Nous allons avoir besoin d'ajouter ce code à la fin de la fonction startApp, pour être sûr que le contrat cryptoZombies soit bien initialisé avant d'ajouter l'écouteur d'évènements.

À la fin de startApp(), copiez/collez le bloc de code ci-dessous qui écoute pour un cryptoZombies.events.Transfer

Pour la ligne qui met à jour l'interface, utilisez getZombiesByOwner(userAccount).then(displayZombies);


Prochaines Étapes
Cette leçon était volontairement basique. Nous voulions vous montrer la logique de base dont vous auriez besoin pour interagir avec votre smart contract, mais nous ne voulions pas prendre trop de temps en faisant une implémentation complète car la portion Web3.js est plutôt répétitive, et nous n'aurions pas introduit de nouveaux concepts en faisant cette leçon plus longue.

L'implémentation est donc minimale. Voici une liste d'idées de choses que l'on voudrait rajouter pour faire de notre front-end une implémentation complète pour notre jeu de zombie, si vous voulez construire votre propre jeu par vous-mêmes :

Implémenter des fonctions pour attack, changeName, changeDna, et les fonctions ERC721 transfer, ownerOf, balanceOf, etc. L'implémentation de ces fonctions sera identique aux autres transactions send que nous avons vu.

Implémenter une "page admin" où vous pouvez exécuter setKittyContractAddress, setLevelUpFee, et withdraw. À nouveau, il n'y a pas de logique spéciale coté front-end - ces implémentations seraient identiques aux fonctions que nous avons déjà vu. Vous devrez juste vous assurer que vous les appelez depuis la même adresse Ethereum que celle qui a déployé le contrat, puisqu'elles ont le modificateur onlyOwner.

Il y a plusieurs vues dans notre application que nous voudrions implémenter :

a. Une page zombie individuelle, où l'on peut voir les infos d'un zombie en particulier avec un lien permanent associé. Cette page devra afficher l'apparence du zombie, son nom, son propriétaire (avec un lien vers le profil de l'utilisateur), son compteur victoire/défaite, son historique de combats, etc.

b. Une page utilisateur, où on peut voir l'armée de zombie d'un utilisateur avec un lien permanent. On doit pouvoir cliquer sur un zombie pour voir sa page, et aussi cliquer sur un zombie pour l'attaquer si on est connecté avec MetaMask et qu'on a une armée.

c. Une page d'accueil, qui est une variation de la page utilisateur qui montre l'armée de zombie de l'utilisateur actuel. (C'est la page que nous avons commencé avec index.html).

Des fonctions dans l'interface, qui permettent à l'utilisateur de se nourrir de CryptoKitties. Il pourrait y avoir un bouton sur chaque zombie de la page d'accueil qui dit "Nourris moi", puis un champ de texte qui demande à l'utilisateur l'ID du chaton (ou l'URL de ce chaton, ex : https://www.cryptokitties.co/kitty/578397). Cela déclencherait la fonction feedOnKitty.

Une fonction dans l'interface pour que l'utilisateur puisse attaquer le zombie d'un autre utilisateur.

Une façon de faire ça serait quand l'utilisateur navigue sur la page d'un autre utilisateur, il pourrait y avoir un bouton qui dit "Attaquer ce zombie". Quand l'utilisateur clique dessus, cela afficher un modal qui contient l'armée de l'utilisateur actif et lui demanderait "Avec quel zombie voulez-vous attaquer ?"

La page d'accueil utilisateur pourrait aussi avoir un bouton pour chaque zombie "Attaquer un autre zombie". Une fois cliqué, cela pourrait afficher un modal avec un champ de recherche pour rentrer l'ID d'un zombie. Une option pourrait dire "Attaquer un zombie aléatoire", qui rechercherait un nombre aléatoire.

Il faudrait aussi griser les zombies de l'utilisateur dont la période d'attente n'est pas encore passée, afin que l'interface indique à l'utilisateur qu'il ne peut pas attaquer avec ce zombie, et combien de temps il doit attendre.

La page d'accueil utilisateur pourrait aussi avoir comme options pour chaque zombie de changer son nom, changer son ADN et gagner un niveau (avec un frais). Les options seraient grisées si l'utilisateur n'a pas encore le bon niveau.

Pour les nouveaux utilisateurs, on pourrait afficher un message de bienvenue avec un moyen pour créer son premier zombie, en appelant createRandomZombie().

On voudrait sûrement ajouter un évènement Attack à notre smart contract avec l'adresse de l'utilisateur comme propriété indexed comme vu dans le chapitre précédent. Cela permettrait d'avoir des notifications en temps réel - on pourrait afficher une alerte à un utilisateur quand un de ses zombies est attaqué, et il pourrait voir le zombie/utilisateur qui l'a attaqué et rendre la pareille.

On voudrait certainement implémenter une sorte de cache pour notre front-end afin que nous ne soyons pas constamment en train d'interroger Infura avec des requêtes pour les mêmes données. (Notre implémentation actuelle de displayZombies appelle getZombieDetails pour chaque zombie à chaque fois que nous rafraîchissons l'interface - mais normalement nous devrions l'appeler seulement pour les nouveaux zombies ajoutés à notre armée).

Un tchat en temps réel pour narguer les autres utilisateurs quand on écrase leur armée de zombie ? Oui svp.
C'est juste un début - Je suis sûr que vous avez encore pleins d'idées pour l'améliorer - et c'est déjà une bonne liste.

Puisqu'il y a beaucoup de code front-end dont nous aurions besoin pour créer une interface comme celle-là (HTML, CSS, JavaScript et un framework comme React ou Vue.js), construire tout cela serait sûrement un cours à part avec une dizaine leçons. Nous vous laissons donc le soin de l'implémenter vous-mêmes.

Remarque : Même si notre smart contract est décentralisé, cette interface pour interagir avec notre DApp est complètement centralisée sur un serveur quelque part.

Cependant, avec le SDK que nous sommes en train de développer à href="https://medium.com/loom-network/loom-network-is-live-scalable-ethereum-dapps-coming-soon-to-a-dappchain-near-you-29d26da00880" target=_blank>Loom Network, bientôt vous pourrez avoir des front-end comme celui-ci sur leur propre DAppChain au lieu d'un serveur centralisé. De cette manière, entre Ethereum et la DAppChain de Loom, l'ensemble de votre application sera à 100% sur la blockchain.

Conclusion
Cela termine la Leçon 6. Vous avez maintenant les compétences nécessaires pour coder un smart contrat et une application front-end pour que vos utilisateurs interagissent avec !

Dans la prochaine leçon, nous allons voir la pièce manquante du puzzle - déployer votre smart contract sur Ethereum.

Cliquez sur "Prochain Chapitre" pour obtenir vos récompenses !
