// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract KYC is ERC721, Ownable {
    string[] public tokensList;
    uint256 private tokenCounter;
    mapping (address => uint256[]) NFTs;

    event NFTcreated(address user, uint256 tokenID);

    constructor(address initialOwner)
        ERC721("KYC", "NFT")
        Ownable(initialOwner)
    {
    }

    function createNFT(address user, string memory json) public onlyOwner returns (uint256) {
        bytes memory metadata = bytes(json);
        _safeMint(user, tokenCounter, metadata);
        NFTs[user].push(tokenCounter);
        emit NFTcreated(user, tokenCounter);
        tokenCounter++;
        return tokenCounter;
    }

    function retrieveNFTs(address user) public view onlyOwner returns (uint256[] memory) {
        return NFTs[user];
    }
}
