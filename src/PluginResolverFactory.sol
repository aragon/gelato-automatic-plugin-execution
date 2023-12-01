// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.21;

import "./PluginResolver.sol";

contract PluginResolverFactory {
  address public immutable automate;

  // Mapping to store addresses of PluginResolver instances against creator addresses
  mapping(address => address) public pluginResolvers;

  // Event to be emitted when a new PluginResolver is created
  event PluginResolverCreated(address indexed creator, address pluginResolver);

  constructor(address _automate) {
    automate = _automate;
  }

  /**
   * @dev Function to create a new PluginResolver instance
   * @param _plugin Address of the IExecutablePlugin
   * @return address of the newly created PluginResolver instance
   */
  function createPluginResolver(IExecutablePlugin _plugin, address _fundsOwner) external returns (address) {
    if (pluginResolvers[msg.sender] != address(0)) {
      return pluginResolvers[msg.sender];
    }

    PluginResolver newPluginResolver = new PluginResolver(_plugin, automate, _fundsOwner);
    pluginResolvers[msg.sender] = address(newPluginResolver);

    emit PluginResolverCreated(msg.sender, address(newPluginResolver));

    return address(newPluginResolver);
  }

  /**
   * @dev Function to get all PluginResolver instances created by a specific address
   * @param creator Address of the creator
   * @return List of addresses of PluginResolver instances
   */
  function getPluginResolversByCreator(address creator) external view returns (address) {
    return pluginResolvers[creator];
  }
}
