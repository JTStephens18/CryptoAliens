pragma solidity >=0.5.0 <0.6.0;

import "./alienattack.sol";
import "./erc721.sol";
import "./safemath.sol";

//@title A contract to transfer ownership of an alien
//@author Justin Stephens

contract AlienOwnership is AlienAttack, ERC721 {

    using SafeMath for uint256;

    mapping (uint => address) alienApprovals;

//@notice calls the balanceOf function in erc721.sol 
//@return balance of _owner
    function balanceOf(address _owner) external view returns (uint256) {
        return ownerAlienCount[_owner];
    }

//@notice Checks who the owner of an alien (token) is 
//@return address of owner
    function ownerOf(uint256 _tokenId) external view returns (address) {
        alienToOwner[_tokenId];
    }

//@notice Transfers an alien from one address to another
//@dev Use SafeMath 'add' and 'sub' in place of ++ and --
    function _transfer(address _from, address _to, uint _tokenId) private {
        ownerAlienCount[_to] = ownerAlienCount[_to].add(1);
        ownerAlienCount[msg.sender] = ownerAlienCount[msg.sender].sub(1);
        alienToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

//@notice Calls the transfer function above and ensures that whoever is transferring owns the alien (tokenn)
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require(alienToOwner[_tokenId] == msg.sender || alienApprovals[_tokenId] == msg.sender);
        _transfer(_from, _to, _tokenId);
    }

//@notice approves that one actually owns the alien (token) 
    function approve (address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
        alienApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }
}