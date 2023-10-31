// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../src/IEvaluator.sol";
import "./IStudentToken.sol";

contract ComposabilitySolutionAntoineR {

    IERC20 private rewardToken;
    IEvaluator private evaluator;
    IStudentToken private studentToken;

    constructor(address _rewardTokenAddress, address _evaluatorAddress, IStudentToken _studentToken) {
        rewardToken = IERC20(_rewardTokenAddress);
        evaluator = IEvaluator(_evaluatorAddress);
        studentToken = _studentToken;
    }

    function initializeRegistrations() public {
        evaluator.registerStudentToken(address(studentToken));
    }

    function executeExercise() public {
        evaluator.ex2_mintStudentToken();
    }

    function getRewardTokenBalance() external view returns (uint256) {
        return rewardToken.balanceOf(address(this));
    }

    receive() external payable {}

}
