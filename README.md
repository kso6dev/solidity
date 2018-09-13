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
