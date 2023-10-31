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


contract LocalDeploymentScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("LOCAL_PRIVATE_KEY");
        address rewardTokenAddress = 0x8A791620dd6260079BF849Dc5567aDC3F2FdC318;
        //address evaluatorAddress = 0x610178dA211FEF7D417bC0e6FeD39F05609AD788;

        //IEvaluator evaluator = IEvaluator(evaluatorAddress);


        vm.startBroadcast(deployerPrivateKey);

        RewardToken rewardToken = new RewardToken();
        Evaluator evaluator = new Evaluator(rewardToken);
        address evaluatorAddress = address(evaluator);


        console.log("Script address: ", address(this));

        IStudentToken studentToken = new StudentToken(evaluatorAddress);

        console.log("studentToken address: ", address(studentToken));

        ComposabilitySolutionAntoineR solution = new ComposabilitySolutionAntoineR(rewardTokenAddress, evaluatorAddress, studentToken);

        address solutionAddress = address(solution);
        address payable payableSolutionAddress = payable(solutionAddress);

        console.log("Solution address: ", solutionAddress);
        console.log("RewardToken Balance: ", solution.getRewardTokenBalance());




        solution.initializeRegistrations();

        console.logAddress(address(evaluator.studentToken(solutionAddress)));

        vm.stopBroadcast();

        //------------------------

        vm.startBroadcast(deployerPrivateKey);

        studentToken.approve(evaluatorAddress,10000000);

        console.log("allowance: ", studentToken.allowance(address(studentToken),evaluatorAddress)); //je veux que cette allowance soit a 10000000 ou je dois ecrire la fonction approve ?

        solution.executeExercise();

        vm.stopBroadcast();
    }
}
