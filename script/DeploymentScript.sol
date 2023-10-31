// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/RewardToken.sol";
import "../src/IEvaluator.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../src/ComposabilitySolutionAntoineR.sol";
import "../src/StudentToken.sol";
import "../src/Evaluator.sol";


contract DeploymentScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address rewardTokenAddress = 0x56822085cf7C15219f6dC404Ba24749f08f34173;
        address evaluatorAddress = 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE;

        IEvaluator evaluator = IEvaluator(evaluatorAddress);

        vm.startBroadcast(deployerPrivateKey);

        IStudentToken studentToken = new StudentToken(evaluatorAddress);

        studentToken.approve(evaluatorAddress,10000000);

        console.log("Script address: ", address(this));

        ComposabilitySolutionAntoineR solution = new ComposabilitySolutionAntoineR(rewardTokenAddress,evaluatorAddress,studentToken);

        address solutionAddress = address(solution);
        console.log("Solution address: ", solutionAddress);
        console.log("RewardToken Balance: ", solution.getRewardTokenBalance());

        solution.initializeRegistrations();

        console.log("ok save token address",evaluator.studentToken(solutionAddress));

        solution.executeExercise();

        vm.stopBroadcast();
    }
}
