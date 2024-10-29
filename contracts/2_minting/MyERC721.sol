// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract MyERC721Token is ERC721, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    uint256 public tokenCounter;

    constructor() ERC721("MyERC721Token", "M721") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        tokenCounter = 0;
    }

    function mintNFT(address recipient) external onlyRole(MINTER_ROLE) {
        tokenCounter++;
        _safeMint(recipient, tokenCounter);
    }

    function setMinter(address minter) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(MINTER_ROLE, minter);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
