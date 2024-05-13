1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '../managers/Manager.sol';
10 
11 /// @notice this contract is used for testing to view all storage variables
12 contract ManagerTest is Manager {
13   function revertsIfNotCore() external onlySherlockCore {}
14 
15   function viewSherlockCore() external view returns (address) {
16     return address(sherlockCore);
17   }
18 
19   function sweep(address _receiver, IERC20[] memory _extraTokens) external {
20     _sweep(_receiver, _extraTokens);
21   }
22 }
