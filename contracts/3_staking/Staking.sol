// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./MyERC20.sol";

contract NFTStaking is IERC721Receiver, ReentrancyGuard {
    event RewardsClaimed(address indexed claimer, uint256 rewards);

    MyERC20Token public rewardsToken;
    IERC721 public nftToken;

    struct Staker {
        uint256 lastClaimTime;
        address owner;
    }

    mapping(uint256 => Staker) public stakers;

    constructor(MyERC20Token _rewardsToken, IERC721 _nftToken) {
        rewardsToken = _rewardsToken;
        nftToken = _nftToken;
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        require(msg.sender == address(nftToken), "Transfer should come from NFT token contract");
        stakers[tokenId] = Staker({lastClaimTime: block.timestamp, owner: from});
        return IERC721Receiver.onERC721Received.selector;
    }

    function claimRewards(uint256 tokenId) public nonReentrant {
        require(stakers[tokenId].owner == msg.sender, "You don't own this NFT");

        Staker storage staker = _getStaker(tokenId);
        uint256 elapsedTime = block.timestamp - staker.lastClaimTime;
        require(elapsedTime >= 24 hours, "Cannot claim yet");

        uint256 rewards = (elapsedTime / 24 hours) * 10 * 10 ** 18; // 10 tokens every 24 hours
        staker.lastClaimTime += (elapsedTime / 24 hours) * 24 hours;

        rewardsToken.mint(msg.sender, rewards);
        emit RewardsClaimed(msg.sender, rewards);
    }

    function withdrawNFT(uint256 tokenId) external nonReentrant {
        /**
         * {nonReentrant} function (withdrawNFT) cannot call another {nonReentrant} function (claimRewards),
         * so we make a separate private function call instead.
         * docs: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol#L52
         */
        _proceedNFTWithdrawal(tokenId);
    }

    function _proceedNFTWithdrawal(uint256 tokenId) private {
        require(stakers[tokenId].owner == msg.sender, "You don't own this NFT");

        Staker storage staker = _getStaker(tokenId);
        uint256 timeStaked = block.timestamp - staker.lastClaimTime;
        if (timeStaked >= 24 hours) {
            claimRewards(tokenId);
        }

        nftToken.safeTransferFrom(address(this), msg.sender, tokenId);
        delete stakers[tokenId];
    }

    function _getStaker(uint256 tokenId) private view returns (Staker storage) {
        return stakers[tokenId];
    }
}
