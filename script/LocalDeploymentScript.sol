// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/ComposabilitySolutionAntoineR.sol";
import "../src/StudentToken.sol";
import "../src/Evaluator.sol";


contract LocalDeploymentScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("LOCAL_PRIVATE_KEY");
        address rewardTokenAddress = 0x8A791620dd6260079BF849Dc5567aDC3F2FdC318;
        address evaluatorAddress = 0x610178dA211FEF7D417bC0e6FeD39F05609AD788;

        vm.startBroadcast(deployerPrivateKey);
        console.log("Script address: ", address(this));

        IStudentToken studentToken = new StudentToken(evaluatorAddress);

        console.log("StudentToken address: ", address(studentToken));

        ComposabilitySolutionAntoineR solution = new ComposabilitySolutionAntoineR(rewardTokenAddress, evaluatorAddress, studentToken);
        address solutionAddress = address(solution);
        console.log("Solution address: ", solutionAddress);

        solution.initializeRegistrations();

        solution.executeExercise();

        console.log("RewardToken Balance: ", solution.getRewardTokenBalance());

        vm.stopBroadcast();
    }
}
