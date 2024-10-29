// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract MyERC20Token is ERC20, AccessControl {
    bytes32 public constant STAKING_ROLE = keccak256("STAKING_ROLE");

    constructor() ERC20("MyERC20Token", "M20") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) external onlyRole(STAKING_ROLE) {
        _mint(to, amount);
    }

    function setMinter(address minter) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(STAKING_ROLE, minter);
    }
}
