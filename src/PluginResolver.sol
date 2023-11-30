// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.21;

import { IExecutablePlugin } from "./interfaces/IExecutablePlugin.sol";
import { AutomateTaskCreator } from "@automate/integrations/AutomateTaskCreator.sol";

contract PluginResolver is AutomateTaskCreator {
  IExecutablePlugin public immutable plugin;

  constructor(
    IExecutablePlugin _plugin,
    address _automate,
    address _fundsOwner
  ) AutomateTaskCreator(_automate, _fundsOwner) {
    plugin = _plugin;

    ModuleData memory moduleData = ModuleData({ modules: new Module[](1), args: new bytes[](1) });

    moduleData.modules[0] = Module.RESOLVER;

    moduleData.args[0] = _resolverModuleArg(address(this), abi.encodeCall(this.checker, ()));

    _createTask(address(_plugin), "", moduleData, 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
  }

  // This only executes the last proposal
  function checker() external view returns (bool canExec, bytes memory execPayload) {
    uint256 lastProposal = plugin.proposalCount() - 1;
    canExec = plugin.canExecute(lastProposal);
    execPayload = abi.encodeCall(IExecutablePlugin.execute, lastProposal);
  }
}
