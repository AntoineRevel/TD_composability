// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "v3-periphery/contracts/interfaces/IQuoter.sol";
import "v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "v3-core/contracts/interfaces/IUniswapV3Factory.sol";

import "./interfaces/IEvaluator.sol";
import "./interfaces/IStudentToken.sol";
import "./interfaces/IStudentNft.sol";
import "./StudentToken.sol";
import "./RewardToken.sol";
import "./StudentNft.sol";

contract ComposabilitySolutionAntoineR {
    RewardToken private rewardToken;
    IEvaluator private evaluator;

    IStudentToken private studentToken;
    IStudentNft private studentNft;

    IUniswapV3Factory private uniswapFactory;
    IQuoter private uniswapQuoter;
    ISwapRouter private swapRouter;

    constructor(
        address _rewardTokenAddress,
        address _evaluatorAddress,
        address _uniswapFactoryAddress,
        address _uniswapQuoterAddress,
        address _uniswapV3RouterAddress
    ) {
        rewardToken = RewardToken(_rewardTokenAddress);
        evaluator = IEvaluator(_evaluatorAddress);

        studentToken = new StudentToken(_evaluatorAddress, address(this));
        studentNft = new StudentNft(_evaluatorAddress);

        uniswapFactory = IUniswapV3Factory(_uniswapFactoryAddress);
        uniswapQuoter = IQuoter(_uniswapQuoterAddress);
        swapRouter = ISwapRouter(_uniswapV3RouterAddress);
    }

    function initializeRegistrations() public {
        evaluator.registerStudentToken(address(studentToken));
        evaluator.registerStudentNft(address(studentNft));
    }

    function executeExercises() public {
        executeEx2();
        executeEx3();
        executeEx4();
        executeEx5();

        executeEx8();
        executeEx9();
    }

    function executeEx2() private {
        evaluator.ex2_mintStudentToken();
        require(evaluator.exerciceProgression(address(this), 0), "Exercise 2 failed");
    }

    function executeEx3() private {
        studentToken.transferFrom(
            address(studentToken), address(evaluator), studentToken.allowance(address(studentToken), address(this))
        );

        evaluator.ex3_mintEvaluatorToken();
        require(evaluator.exerciceProgression(address(this), 1), "Exercise 3 failed");
    }

    function executeEx4() private {
        uint256 amountIn = rewardTokenSwap(5);
        emit AmountInLog(amountIn);

        evaluator.ex4_checkRewardTokenBalance();
        require(evaluator.exerciceProgression(address(this), 2), "Exercise 4 failed");
    }

    function executeEx5() private {
        uint256 amountIn = rewardTokenSwap(10);
        rewardToken.approve(address(evaluator), amountIn);

        evaluator.ex5_checkRewardTokenBalance();
        require(evaluator.exerciceProgression(address(this), 3), "Exercise 5 failed");
    }

    function executeEx8() private {
        evaluator.ex8_mintNFT();
        require(evaluator.exerciceProgression(address(this), 4), "Exercise mint NFT failed");
    }

    function executeEx9() private {
        evaluator.ex9_burnNft();
        require(evaluator.exerciceProgression(address(this), 5), "Exercise burn Nft failed");
    }

    function rewardTokenSwap(uint256 rewardAmount) private returns (uint256) {
        address tokenIn = address(evaluator);
        address tokenOut = address(rewardToken);

        uint256 amountOut = 10 ** rewardToken.decimals() * rewardAmount;

        address poolAddress = uniswapFactory.getPool(tokenIn, tokenOut, 500);
        require(poolAddress != address(0), "Pool not found");

        IUniswapV3Pool pool = IUniswapV3Pool(poolAddress);
        uint24 fee = pool.fee();

        uint160 sqrtPriceLimitX96 = 0;
        uint256 amountInEstimate =
            uniswapQuoter.quoteExactOutputSingle(tokenIn, tokenOut, fee, amountOut, sqrtPriceLimitX96);
        uint256 amountInMaximum = amountInEstimate * 110 / 100;

        ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter.ExactOutputSingleParams({
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            fee: fee,
            recipient: address(this),
            deadline: block.timestamp + 120,
            amountOut: amountOut,
            amountInMaximum: amountInMaximum,
            sqrtPriceLimitX96: sqrtPriceLimitX96
        });

        evaluator.approve(address(swapRouter), amountInMaximum);

        return swapRouter.exactOutputSingle(params);
    }

    function getRewardTokenBalance() external view returns (uint256) {
        return rewardToken.balanceOf(address(this));
    }

    event AmountInLog(uint256 amountIn);
}
