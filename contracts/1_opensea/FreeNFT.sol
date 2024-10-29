// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract FreeMintNFT is ERC721 {
    uint256 public totalSupply = 0;
    uint256 public constant MAX_SUPPLY = 10;

    address immutable deployer;

    constructor() ERC721("FreeMintNFT", "FMNFT") {
        deployer = msg.sender;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://Qmchn622BijuoAsFveydzEik1RxY9aqfjzu4S42aatqJ6W/";
    }

    function viewBalances() external view returns (uint256) {
        return address(this).balance;
    }

    function withdraw() external {
        payable(deployer).transfer(address(this).balance);
    }

    function safeMint(address to) public {
        require(totalSupply < MAX_SUPPLY, "Supply used up");
        totalSupply++;
        _safeMint(to, totalSupply);
    }
}
