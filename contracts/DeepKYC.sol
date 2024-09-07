// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DeepKYCToken is ERC20, Ownable {

    // Total supply is set during deployment (1 billion tokens in this case)
    constructor(address initialOwner, uint256 initialSupply) Ownable(initialOwner) ERC20("DeepKYC Token", "DeepKYC") {
        _mint(msg.sender, initialSupply); // Mint the initial supply to contract creator
    }

    // Mint new tokens - only the owner can mint
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function transferNFT(uint256 tokenId, address to) public {
        transferFrom(msg.sender, to, tokenId);
    }

    // Burn tokens to reduce supply
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
