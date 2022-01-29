pragma solidity >= 0.5.0 <0.6.0;

import "./ownable.sol";
import "./safemath.sol";

//@title A contract to create aliens 
//@author Justin Stephens

contract AlienFactory is Ownable {
        
        using SafeMath for uint256;
        using SafeMath32 for uint32;
        using SafeMath16 for uint16;
        
        event NewAlien(uint alienId, string name, uint dna);

        uint dnaDigits = 16;
        uint dnaModulus = 10 ** dnaDigits;
        uint cooldownTime = 1 days;

//@notice Make our aliens with this struct
        struct Alien {
            string name;
            uint dna;
            uint32 level;
            uint32 readyTime;
            uint16 winCount;
            uint16 lossCount;
        }

//@notice A dynamic array of struct to store the database of aliens
        Alien[] public aliens;

//@notice Mapping to store alien ownership
        mapping (uint => address) public alienToOwner;
//@notice Mapping to store number of aliens per account
        mapping (address =>  uint) ownerAlienCount;

//@notice Creates a new alien 
        function _createAlien(string memory _name, uint _dna) internal {
    //@notice Pushes new alien into 'aliens' array - Calls struct and assigns values 
            uint id = aliens.push(Alien(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) -1;
    //@notice Sets the owner of newly created alien to msg.sender
            alienToOwner[id] = msg.sender;
            ownerAlienCount[msg.sender] = ownerAlienCount[msg.sender].add(1);
            emit NewAlien(id, _name, _dna);
        }
//@notice Generates random 16 digit value based on a provided string by using keccak256
        function _generateRandomDna(string memory _str) private view returns (uint) {
            uint rand = uint(keccak256(abi.encodePacked(_str)));
            return rand % dnaModulus;
        }

//@notice Creates random alien 
        function createRandomAlien(string memory _name) public {
            require(ownerAlienCount[msg.sender] == 0);
            uint randDna = _generateRandomDna(_name);
            randDna = randDna - randDna % 100;
            _createAlien(_name, randDna);
        }
}