1) Write a Solidity Smart Contract for a Non-Fungible Token (NFT) which can able to perform Identity Verification and Authentication as they can contain unique information about an individual that is 
Cryptographically secure.
Answer- 
NFT Identity Verification:
  NFTs can be used for identity verification and authentication, as they can contain unique information about an inidividual that is Cryptographically secure.
  This contract inherits from the OpenZeppen ERC721 contract and adds identity verification functionality.
  The "_verified" mapping keeps track of which addresses have been verified by the contract owner.
  The "verify" function allows the contract owner to verify an address, while the "revoke function" allows the contract owner to revoke a previously verified address.
  The "checkVerifiedOrNot" function allows any address to check if it has been verified by the contract owner.
  The "mint" function allows the contract owner to mint new NFTs and assign them to verified addresses.
  The "_beforeTokenTransfer" function is overrriden to add the identity verification check. It ensures that both the sender and the recipient addresses have been 
    verified before allowing the token transfer to proceed.

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol"
import "@openzeppelin/contracts/access/Ownable.sol"
import "@openzeppelin/contracts/utils/Counters.sol"

contract NFTIdentityToken is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping(address => bool) _verified;
    constructor() ERC721("NFT Identity Token", "NFTIT") {

    }

    function verifiy(address _address) external onlyOwner {
        _verified[_address] = true;
    
    }

    function revoke(address _address) external onlyOwner {
        _verified[_address] = false;
    }

    function safeMint(address to) public onlyOwner {
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();

        require(!_exists(tokenId));

        _safeMint(to, tokenId);
    }

    function beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize) internal override(ERC721) {

        super._beforeTokenTransfer(from, to, tokenId, batchSize);

        // For Transferring
        if(from != address(0) && to != address(0)) {

            require(_verified[from], " 'from' is not a verified address");
            require(_verified[to], " 'to' is not a verified address");
            
        }

        // For Minting
        else if(from == address(0) && to != address(0)) {
            require(_verified[to], " 'to' is not a verified address");
        }
    }
}
