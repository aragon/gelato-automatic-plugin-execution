// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.21;

abstract contract IExecutablePlugin {
    function canExecute(uint256 _proposalId) external view virtual returns (bool);

    function proposalCount() external view virtual returns (uint256);

    function execute(uint256 _proposalId) external virtual;
}
