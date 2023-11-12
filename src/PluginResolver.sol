// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.21;

import { IExecutablePlugin } from "./interfaces/IExecutablePlugin.sol";

contract PluginResolver {
    IExecutablePlugin public immutable plugin;

    constructor(IExecutablePlugin _plugin) {
        plugin = _plugin;
    }

    // This only executes the last proposal
    function checker() external view returns (bool canExec, bytes memory execPayload) {
        uint256 lastProposal = plugin.proposalCount() - 1;
        canExec = plugin.canExecute(lastProposal);
        execPayload = abi.encodeCall(IExecutablePlugin.execute, lastProposal);
    }
}
