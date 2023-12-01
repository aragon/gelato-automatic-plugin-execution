// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.21 <0.9.0;

import { console2 } from "forge-std/console2.sol";
import { PluginResolver } from "../src/PluginResolver.sol";
import { PluginResolverFactory } from "../src/PluginResolverFactory.sol";
import { IExecutablePlugin } from "../src/interfaces/IExecutablePlugin.sol";

import { Script } from "forge-std/Script.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is Script {
  function run() public returns (PluginResolverFactory pluginResolverFactory) {
    vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
    address automate = vm.envAddress("AUTOMATE");

    console2.log(automate);
    pluginResolverFactory = new PluginResolverFactory(automate);
    vm.stopBroadcast();
  }
}
