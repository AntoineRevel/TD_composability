// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import "../src/Counter.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() external {
        //uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY"); Je veux utilisier cette clé sur Goréli
        uint256 deployerPrivateKey = vm.envUint("LOCAL_PRIVATE_KEY"); //et celle ci en local

        vm.startBroadcast(deployerPrivateKey);
        new Counter();
        vm.stopBroadcast();
    }
}
