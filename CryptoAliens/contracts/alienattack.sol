pragma solidity >=0.5.0 <0.6.0;

import "./alienhelper.sol";

//@title Contract for Aliens to fight one another and earn levels
//@author Justin Stephens

contract AlienAttack is AlienHelper {
    uint256 randNonce = 0;
    uint256 attackVictoryProbability = 70;

    //@notice Function that returns a random value between 0 and _modulus
    function randMod(uint256 _modulus) internal returns (uint256) {
        randNonce++;
        return
            uint256(keccak256(abi.encodePacked(now, msg.sender, randNonce))) %
            _modulus;
    }

    function attack(uint256 _alienId, uint256 _targetId)
        external
        onlyOwnerOf(_alienId)
    {
        //@notice Local storage pointers
        Alien storage myAlien = aliens[_alienId];
        Alien storage enemyAlien = aliens[_targetId];
        //@notice Returns random number which is used for victory probability
        uint256 rand = randMod(100);
        if (rand <= attackVictoryProbability) {
            myAlien.winCount = myAlien.winCount.add(1);
            myAlien.level = myAlien.level.add(1);
            enemyAlien.lossCount = enemyAlien.lossCount.add(1);
            feedAndMultiply(_alienId, enemyAlien.dna, "Alien");
        } else {
            myAlien.lossCount = myAlien.lossCount.add(1);
            enemyAlien.winCount = enemyAlien.winCount.add(1);
            _triggerCooldown(myAlien);
        }
    }
}
