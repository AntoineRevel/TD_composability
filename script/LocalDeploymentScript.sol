// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import "forge-std/console.sol";
import {RewardToken} from "../src/RewardToken.sol";
import "../src/IEvaluator.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";


contract LocalDeploymentScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("LOCAL_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address rewardTokenLocalAddress = 0x8A791620dd6260079BF849Dc5567aDC3F2FdC318;
        address evaluatorLocalAddress = 0x610178dA211FEF7D417bC0e6FeD39F05609AD788;

        console.log("Script address: ", address(this));

        ERC20 rewardToken = ERC20(0x8A791620dd6260079BF849Dc5567aDC3F2FdC318);

        IEvaluator evaluator = IEvaluator(evaluatorLocalAddress);
        console.log("Evaluator address: ", address(evaluator));

        // Affichage du solde de RewardToken du déploieur (ce script).
        uint256 balance = rewardToken.balanceOf(address(this));
        console.log("RewardToken balance of deployer: ", balance);

        vm.stopBroadcast();
    }
}
