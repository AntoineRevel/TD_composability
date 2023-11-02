// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

interface IStudentToken is IERC20 {

    function createLiquidityPool() external;

    function swapRewardToken() external;
}
