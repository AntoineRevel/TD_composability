// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "v3-core/contracts/interfaces/IUniswapV3Factory.sol";

import "./interfaces/IStudentToken.sol";


contract StudentToken is IStudentToken, ERC20 {

    IERC20 private WETH;
    IUniswapV3Factory private uniswapFactory;

    constructor(address _evaluatorAddress, address _solutionAddress, address _wethAddress,
        address _uniswapFactoryAddress) ERC20("AntoineRevelToken", "ARVLT") {
        uint256 initialSupply = 3000000000 * 10 ** decimals();
        _mint(address(this), initialSupply);
        _approve(address(this), _evaluatorAddress, 10000000);
        _approve(address(this), _solutionAddress, 20000000);

        WETH = IERC20(_wethAddress);
        uniswapFactory = IUniswapV3Factory(_uniswapFactoryAddress);
    }

    function createLiquidityPool() external override {
        uniswapFactory.createPool(address(this),address(WETH),3000);
    }

    function swapRewardToken() external override {
// Implémentation de l'échange de tokens de récompense
    }
}
