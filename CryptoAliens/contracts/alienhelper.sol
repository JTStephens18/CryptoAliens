pragma solidity >=0.5.0 <0.6.0;

import "./alienfeeding.sol";

//@title Helper contract for level up rewards and getting the list of aliens an owner has
//@author Justin Stephens

contract AlienHelper is AlienFeeding {

    uint levelUpFee = 0.001 ether;

//@notice Modifier which requires aliens to be above certain level (passed as first parameter)
    modifier aboveLevel(uint _level, uint _alienId) {
        require(aliens[_alienId].level >= _level);
        _;
    }

    function changeName(uint _alienId, string calldata _newName) external aboveLevel(2, _alienId) onlyOwnerOf(_alienId) {
        aliens[_alienId].name = _newName;
    }

    function changeDna(uint _alienId, uint _newDna) external aboveLevel(20, _alienId) onlyOwnerOf(_alienId) {
        aliens[_alienId].dna = _newDna;
    }

//@notice Function that uses for loop to return a uint[] of the _owner's aliens
    function getAliensByOwner(address _owner) external view returns(uint[] memory) {
    //@notice uint[] is in memory and not storage since we just need to view and not write to the blockchain
        uint[] memory result = new uint[](ownerAlienCount[_owner]);
        uint counter = 0;
        for(uint i = 0; i < aliens.length; i++) {
            if(alienToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}