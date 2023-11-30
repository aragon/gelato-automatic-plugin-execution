// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.21 <0.9.0;

import { PluginResolver } from "../src/PluginResolver.sol";
import { PluginResolverFactory } from "../src/PluginResolverFactory.sol";
import { IExecutablePlugin } from "../src/interfaces/IExecutablePlugin.sol";

import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
  function run() public broadcast returns (PluginResolverFactory pluginResolverFactory) {
    address automate = vm.envAddress("GOERLI_AUTOMATE_ADDRES");

    pluginResolverFactory = new PluginResolverFactory(automate);
  }
}
