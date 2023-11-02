// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';

import "../src/IEvaluator.sol";
import "./IStudentToken.sol";
import "./StudentToken.sol";

contract ComposabilitySolutionAntoineR {
    IERC20 private rewardToken;
    IEvaluator private evaluator;
    IStudentToken private studentToken;
    IUniswapV2Router02 private uniswapRouter;

    constructor(address _rewardTokenAddress, address _evaluatorAddress, address _uniswapRouter) {
        rewardToken = IERC20(_rewardTokenAddress);
        evaluator = IEvaluator(_evaluatorAddress);
        studentToken = new StudentToken(_evaluatorAddress, address(this));

    }

    function initializeRegistrations() public {
        evaluator.registerStudentToken(address(studentToken));
    }

    function executeEx2() private {
        evaluator.ex2_mintStudentToken();
    }

    function executeEx3() private {
        studentToken.transferFrom(address(studentToken), address(evaluator), studentToken.allowance(address(studentToken), address(this)));
        evaluator.ex3_mintEvaluatorToken();
    }

    function executeEx4() private {
        //anavnt d'apeler ex4_checkRewardTokenBalance je dois faire un swap en utilisan uniswap de EvaluatorToken (0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE) (que ce contrat detient) pour obtenir 5 RewardToken (0x56822085cf7C15219f6dC404Ba24749f08f34173)
        evaluator.ex4_checkRewardTokenBalance();
    }

    function executeExercises() public {
        executeEx2();
        executeEx3();
        //executeEx4();
    }
    function getRewardTokenBalance() external view returns (uint256) {
        return rewardToken.balanceOf(address(this));
    }

    receive() external payable {}

}
