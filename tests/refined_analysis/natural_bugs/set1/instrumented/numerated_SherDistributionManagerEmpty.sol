1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '../interfaces/managers/ISherDistributionManager.sol';
10 import './Manager.sol';
11 
12 /// @dev dummy contract that doesn't distribute SHER
13 contract SherDistributionManagerEmpty is ISherDistributionManager, Manager {
14   constructor() {}
15 
16   function pullReward(
17     uint256 _amount,
18     uint256 _period,
19     uint256 _id,
20     address _receiver
21   ) external override returns (uint256 _sher) {
22     return 0;
23   }
24 
25   function calcReward(
26     uint256 _tvl,
27     uint256 _amount,
28     uint256 _period
29   ) external view returns (uint256 _sher) {
30     return 0;
31   }
32 
33   /// @notice Function used to check if this is the current active distribution manager
34   /// @return Boolean indicating it's active
35   /// @dev Will be checked by calling the sherlock contract
36   function isActive() public view override returns (bool) {
37     return address(sherlockCore.sherDistributionManager()) == address(this);
38   }
39 }
