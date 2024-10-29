// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./MyERC721.sol";

contract NFTMinter {
    IERC20 public erc20Token;
    MyERC721Token public erc721Token;
    uint256 public constant MINTING_PRICE = 10 * 10 ** 18;

    constructor(address _erc20TokenAddress, address _erc721TokenAddress) {
        erc20Token = IERC20(_erc20TokenAddress);
        erc721Token = MyERC721Token(_erc721TokenAddress);
    }

    function mint() external {
        require(erc20Token.balanceOf(msg.sender) >= MINTING_PRICE, "Not enough ERC20 tokens");
        require(erc20Token.allowance(msg.sender, address(this)) >= MINTING_PRICE, "Allowance too low");

        erc20Token.transferFrom(msg.sender, address(this), MINTING_PRICE);
        erc721Token.mintNFT(msg.sender);
    }
}
