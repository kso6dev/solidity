contract ERC721 {
    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);

    function balanceOf(address _owner) public view returns (uint256 _balance);//renvoie combien de token une adresse possède
    function ownerOf(uint256 _tokenId) public view returns (address _owner);//renvoie l'adresse du propriétaire d'un token
    function transfer(address _to, uint256 _tokenId) public;//transfere un token vers une adresse
    function approve(address _to, uint256 _tokenId) public;//le propriétaire approuve un destinatataire pour qu'ensuite
    function takeOwnership(uint256 _tokenId) public;//le destinataire puisse prendre le token car son adresse a été approuvée au préalable
}
