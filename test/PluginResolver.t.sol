// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.21 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";

import { PluginResolver } from "../src/PluginResolver.sol";
import { IExecutablePlugin } from "../src/interfaces/IExecutablePlugin.sol";

/// @dev If this is your first time with Forge, read this tutorial in the Foundry Book:
/// https://book.getfoundry.sh/forge/writing-tests
contract PluginResolverTest is PRBTest, StdCheats {
  PluginResolver internal pluginResolver;
  IExecutablePlugin internal plugin = IExecutablePlugin(0x899d49F22E105C2Be505FC6c19C36ABa285D437c);
  address automate = address(0xb0b);

  /// @dev A function invoked before each test case is run.
  function setUp() public virtual {
    // Instantiate the contract-under-test.
    pluginResolver = new PluginResolver(plugin, automate, msg.sender);
  }

  /// @dev Fork test that runs against an Ethereum Mainnet fork. For this to work, you need to set `API_KEY_ALCHEMY`
  /// in your environment You can get an API key for free at https://alchemy.com.
  function testFork_CheckerOnRealDAO() external {
    // Silently pass this test if there is no API key.
    string memory alchemyApiKey = vm.envOr("API_KEY_ALCHEMY", string(""));
    if (bytes(alchemyApiKey).length == 0) {
      return;
    }
    // Otherwise, run the test against the mainnet fork.
    vm.createSelectFork({ urlOrAlias: "mainnet", blockNumber: 16_775_852 });

    pluginResolver = new PluginResolver(plugin, automate, msg.sender);

    uint256 numProposals = plugin.proposalCount();
    assertEq(numProposals, 1, "Proposals counter failed");

    (bool canExec, bytes memory execPayload) = pluginResolver.checker();

    assertEq(canExec, true);
    assertEq(execPayload, abi.encodeCall(IExecutablePlugin.execute, 0));
  }
}
