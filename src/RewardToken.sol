// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract RewardToken is ERC20 {
    constructor() ERC20("RewardToken", "RTK") {
        uint256 decimals = decimals();
        uint256 multiplicator = 10 ** decimals;
        uint256 valueToMint = 100000 * multiplicator;
        _mint(msg.sender, valueToMint);
    }
}
