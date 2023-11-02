// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/ComposabilitySolutionAntoineR.sol";
import "../src/StudentToken.sol";
import "../src/Evaluator.sol";

contract BaseDeploymentScript is Script {
    function deploy(
        uint256 deployerPrivateKey,
        address rewardTokenAddress,
        address evaluatorAddress
    ) internal {
        address uniswapRouterAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
        IEvaluator evaluator = IEvaluator(evaluatorAddress);

        vm.startBroadcast(deployerPrivateKey);
        console.log("Script address: ", address(this));

        ComposabilitySolutionAntoineR solution = new ComposabilitySolutionAntoineR(rewardTokenAddress, evaluatorAddress, uniswapRouterAddress);
        address solutionAddress = address(solution);
        console.log("Solution address: ", solutionAddress);

        solution.initializeRegistrations();

        address studentTokenAddress = evaluator.studentToken(solutionAddress);
        console.log("StudentToken address: ", studentTokenAddress);

        solution.executeExercises();

        console.log("EvaluatorToken : ", evaluator.balanceOf(solutionAddress));

        vm.stopBroadcast();
    }
}

contract LocalDeploymentScript is BaseDeploymentScript {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("LOCAL_PRIVATE_KEY");
        address rewardTokenAddress = 0x8A791620dd6260079BF849Dc5567aDC3F2FdC318;
        address evaluatorAddress = 0x610178dA211FEF7D417bC0e6FeD39F05609AD788;

        deploy(deployerPrivateKey, rewardTokenAddress, evaluatorAddress);
    }
}

contract DeploymentScript is BaseDeploymentScript {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address rewardTokenAddress = 0x56822085cf7C15219f6dC404Ba24749f08f34173;
        address evaluatorAddress = 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE;

        deploy(deployerPrivateKey, rewardTokenAddress, evaluatorAddress);
    }
}
