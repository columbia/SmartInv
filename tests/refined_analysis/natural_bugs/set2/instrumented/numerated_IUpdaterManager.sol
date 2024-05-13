1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 interface IUpdaterManager {
5     function slashUpdater(address payable _reporter) external;
6 
7     function updater() external view returns (address);
8 }
