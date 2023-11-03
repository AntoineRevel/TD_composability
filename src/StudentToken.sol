// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

import "./interfaces/IStudentToken.sol";

contract StudentToken is IStudentToken, ERC20 {
    constructor(address _evaluatorAddress, address _solutionAddress) ERC20("AntoineRevelToken", "ARVLT"){
        uint256 initialSupply = 3000000000 * 10 ** decimals();
        _mint(address(this), initialSupply);
        _approve(address(this),_evaluatorAddress,10000000);
        _approve(address(this),_solutionAddress,20000000);
    }

    function createLiquidityPool() external override {

    }

    function swapRewardToken() external override {
        // Implémentation de l'échange de tokens de récompense
    }
}
