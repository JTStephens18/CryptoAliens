pragma solidity >=0.5.0 <0.6.0;

import "./alienfactory.sol";

//@title A contract so aliens can feed off each other or from CryptoKitties
//@author Justin Stephens

//@notice KittyInterface contract to get the ID
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
    uint256 genes
  );
}
 
contract AlienFeeding is AlienFactory {
    
    KittyInterface kittyContract;

//@notice Modifier so only the sender (owner) can modify an alien 
    modifier onlyOwnerOf(uint _alienId) {
      require(msg.sender == alienToOwner[_alienId]);
      _;
    }

//@notice Just in case the address of the contract changes, I don't have to change it manually
    function setKittyContractAddress(address _address) external onlyOwner {
      kittyContract = KittyInterface(_address);
    }

//@notice Triggers the feeding cooldown from now + a day 
    function _triggerCooldown(Alien storage _alien) internal {
      _alien.readyTime = uint32(now + cooldownTime);
    }

//notice Bool check to see if alien can feed again (cooldown is over)
    function _isReady(Alien storage _alien) internal view returns (bool) {
      return (_alien.readyTime <= now);
    }
 
    function feedAndMultiply(uint _alienId, uint _targetDna, string memory _species) internal onlyOwnerOf(_alienId) {
  //@notice Local Alien (storage pointer) named myAlien
        Alien storage myAlien = aliens[_alienId];
        require(_isReady(myAlien));
  //@notice Ensures targetDna is not longer than 16 digita
        _targetDna = _targetDna % dnaModulus;
  //@notice Formula for creating newDna 
        uint newDna = (myAlien.dna + _targetDna) / 2;
  //@notice If statement which checks if we hav eaten a kitty. If true, we add 99 to the end of the Alien's Dna to signify it is special
        if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
            newDna = newDna - newDna % 100 + 99;
        }
        _createAlien("NoName", newDna);
        _triggerCooldown(myAlien);
    }

    function feedOnKitty(uint _alienId, uint _kittyId) public {
        uint kittyDna;
  //@notice the ',' are needed since we only want the kitty genes
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_alienId, kittyDna, "kitty");
    }
}