// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import 'lib/v2-core/contracts/interfaces/IUniswapV2Factory.sol';
import "../src/IEvaluator.sol";
import "./IStudentToken.sol";
import "./StudentToken.sol";
import "./RewardToken.sol";

import "forge-std/console.sol";

contract ComposabilitySolutionAntoineR {
    RewardToken private rewardToken;
    IEvaluator private evaluator;
    IStudentToken private studentToken;
    IUniswapV2Router02 private uniswapRouter;

    constructor(address _rewardTokenAddress, address _evaluatorAddress, address _uniswapRouterAddress){
        rewardToken = RewardToken(_rewardTokenAddress);
        evaluator = IEvaluator(_evaluatorAddress);
        studentToken = new StudentToken(_evaluatorAddress, address(this));
        uniswapRouter = IUniswapV2Router02(_uniswapRouterAddress);
    }

    function initializeRegistrations() public {
        evaluator.registerStudentToken(address(studentToken));
    }

    function executeEx2() private {
        evaluator.ex2_mintStudentToken();
        require(evaluator.exerciceProgression(address(this), 0), "Exercise 2 failed");
    }

    function executeEx3() private {
        studentToken.transferFrom(address(studentToken), address(evaluator), studentToken.allowance(address(studentToken), address(this)));
        evaluator.ex3_mintEvaluatorToken();
        require(evaluator.exerciceProgression(address(this), 1), "Exercise 3 failed");
    }

    function executeEx4() public {
        address[] memory path = new address[](2);
        path[0] = address(evaluator);
        path[1] = address(rewardToken);

        uint256 amountOut = 10 ** rewardToken.decimals() * 5;

        uint[] memory amountsIn = uniswapRouter.getAmountsIn(amountOut, path);

        evaluator.approve(address(uniswapRouter), amountsIn[0]);

        uniswapRouter.swapTokensForExactTokens(amountOut, amountsIn[0], path, address(this), block.timestamp + 15);

        evaluator.ex4_checkRewardTokenBalance();
        require(evaluator.exerciceProgression(address(this), 2), "Exercise 4 failed");
    }

    function executeExercises() public {
        executeEx2();
        executeEx3();
        executeEx4();
    }

    function getRewardTokenBalance() external view returns (uint256) {
        return rewardToken.balanceOf(address(this));
    }

    receive() external payable {}
}
