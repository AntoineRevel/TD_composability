// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../src/IEvaluator.sol";
import "./IStudentToken.sol";
import "./StudentToken.sol";

contract ComposabilitySolutionAntoineR {

    IERC20 private rewardToken;
    IEvaluator private evaluator;
    IStudentToken private studentToken;

    constructor(address _rewardTokenAddress, address _evaluatorAddress) {
        rewardToken = IERC20(_rewardTokenAddress);
        evaluator = IEvaluator(_evaluatorAddress);
        studentToken = new StudentToken(_evaluatorAddress, address(this));
    }

    function initializeRegistrations() public {
        evaluator.registerStudentToken(address(studentToken));
    }

    function executeExercise() public {
        evaluator.ex2_mintStudentToken();

        studentToken.transferFrom(address(studentToken),address(evaluator),studentToken.allowance(address(studentToken),address(this)));

        evaluator.ex3_mintEvaluatorToken();
    }

    function getRewardTokenBalance() external view returns (uint256) {
        return rewardToken.balanceOf(address(this));
    }

    receive() external payable {}

}
