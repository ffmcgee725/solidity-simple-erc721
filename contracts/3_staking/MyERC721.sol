// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyERC721Token is ERC721 {
    uint256 public nextTokenId = 1;

    constructor() ERC721("MyERC721Token", "M721") {}

    function mint(address to) external {
        _safeMint(to, nextTokenId);
        nextTokenId++;
    }
}
