// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "forge-std/src/Script.sol";
import "forge-std/src/console.sol";

import "../src/ComposabilitySolutionAntoineR.sol";
import "../src/StudentToken.sol";
import "../src/Evaluator.sol";

contract BaseDeploymentScript is Script {
    function deploy(
        uint256 deployerPrivateKey,
        address rewardTokenAddress,
        address evaluatorAddress
    ) internal {
        address uniswapV3FactoryAddress = 0x1F98431c8aD98523631AE4a59f267346ea31F984;
        address uniswapV3QuoterAddress = 0xb27308f9F90D607463bb33eA1BeBb41C27CE5AB6;
        address uniswapV3RouterAddress = 0xE592427A0AEce92De3Edee1F18E0157C05861564;

        IEvaluator evaluator = IEvaluator(evaluatorAddress);

        vm.startBroadcast(deployerPrivateKey);
        console.log("Script address: ", address(this));

        ComposabilitySolutionAntoineR solution = new ComposabilitySolutionAntoineR(
            rewardTokenAddress, evaluatorAddress, uniswapV3FactoryAddress, uniswapV3QuoterAddress, uniswapV3RouterAddress);
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
        uint256 deployerPrivateKey = vm.envUint("GOERLI_PRIVATE_KEY");
        address rewardTokenAddress = 0x56822085cf7C15219f6dC404Ba24749f08f34173;
        address evaluatorAddress = 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE;

        deploy(deployerPrivateKey, rewardTokenAddress, evaluatorAddress);
    }
}
//last Solution address:  0x7613F2c18Da470486Dee09160B221E11D506b9B2
