var cryptoZombies;
var userAccount;
     
function startApp()
{
  var cryptoZombiesAddress = "YOUR_CONTRACT_ADDRESS";
  cryptoZombies = new web3js.eth.Contract(cryptoZombiesABI, cryptoZombiesAddress);
  var accountInterval = setInterval(function() {
    // Vérifie si le compte a changé
    if (web3.eth.accounts[0] !== userAccount) {
      userAccount = web3.eth.accounts[0];
      // Appelle une fonction pour mettre à jour l'interface avec le nouveau compte
      getZombiesByOwner(userAccount).then(displayZombies);
    }
  }, 100);

  // On utilise `filter` pour seulement lancer ce code quand `_to` est égal à `userAccount`
  cryptoZombies.events.Transfer({ filter: { _to: userAccount } })//on s'abonne a l'event transfer = un zombie est transféré vers notre compte
  .on("data", function(event) {
    let data = event.returnValues;
    // L’utilisateur actuel a reçu un zombie !
    // Faire quelque chose pour mettre à jour l'interface
    getZombiesByOwner(userAccount).then(displayZombies);
  }).on("error", console.error);
}

}

function displayZombies(ids) {
  $("#zombies").empty();//suppr contenu du div zombies
  for (id of ids)
  {
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
  }
}

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

function feedOnKitty(zombieId, kittyId)
{
  $("#txStatus").text("En train de manger un chaton, cela peut prendre du temps...");
  return cryptoZombies.methods.feedOnKitty(zombieId, kittyId)
  .send({ from: userAccount })
  .on("receipt", function(receipt) {
    $("#txStatus").text("A mangé un chaton et a engendré un nouveau Zombie !");
    getZombiesByOwner(userAccount).then(displayZombies);
  })
  .on("error", function(error) {
    $("#txStatus").text(error);
  });
  
}

function levelUp(zombieId) //payante
{
  $("#txStatus").text("Votre zombie est en train de gagner un niveau...");
  return cryptoZombies.methods.levelUp(zombieId)
  .send({ from: userAccount, value: web3js.utils.toWei("0.001", "ether") })//précise le montant à payer, convertit en Wei!
  .on("receipt", function(receipt) {
    $("#txStatus").text("Quelle puissance écrasante ! Le zombie a bien gagné un niveau");
  })
  .on("error", function(error) {
    $("#txStatus").text(error);
  });
}

function getZombieDetails(id) {
  return cryptoZombies.methods.zombies(id).call()
}

function zombieToOwner(id) {
  return cryptoZombies.methods.zombieToOwner(id).call()
}

function getZombiesByOwner(owner) {
  return cryptoZombies.methods.getZombiesByOwner(owner).call()
}



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
  startApp();
})