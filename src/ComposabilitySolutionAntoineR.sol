// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../src/IEvaluator.sol";
import "./IStudentToken.sol";
import "./StudentToken.sol";
import "./RewardToken.sol";

import "forge-std/console.sol";
import "lib/v3-periphery/contracts/interfaces/ISwapRouter.sol";

contract ComposabilitySolutionAntoineR {
    RewardToken private rewardToken;
    IEvaluator private evaluator;
    IStudentToken private studentToken;
    ISwapRouter private swapRouter;

    constructor(address _rewardTokenAddress, address _evaluatorAddress, address _uniswapV3RouterAddress){
        rewardToken = RewardToken(_rewardTokenAddress);
        evaluator = IEvaluator(_evaluatorAddress);
        studentToken = new StudentToken(_evaluatorAddress, address(this));
        swapRouter = ISwapRouter(_uniswapV3RouterAddress);
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
        uint256 amountOut = 10 ** rewardToken.decimals() * 5;
        uint256 amountInMaximum = 10 ** rewardToken.decimals() * 6;

        // Configurer les paramètres de l'échange
        ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter.ExactOutputSingleParams({
            tokenIn: address(evaluator),
            tokenOut: address(rewardToken),
            fee: 500, //comment obtenir cette info // comment obterni la UniswapV3Pool.fee() 0x9B46A5978E15C43E2a8f821605D5D5BA826114d8
            recipient: address(this),
            deadline: block.timestamp + 120,
            amountOut: amountOut,
            amountInMaximum: 0,
            sqrtPriceLimitX96: 0
        });

        evaluator.approve(address(swapRouter), amountInMaximum);

        uint256 amountIn = swapRouter.exactOutputSingle(params);

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
