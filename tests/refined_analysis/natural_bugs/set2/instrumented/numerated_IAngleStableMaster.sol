1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./IAnglePoolManager.sol";
5 
6 // Angle StableMaster contract
7 interface IAngleStableMaster {
8     function agToken() external returns (address);
9 
10     function mint(
11         uint256 amount,
12         address user,
13         IAnglePoolManager poolManager,
14         uint256 minStableAmount
15     ) external;
16 
17     function burn(
18         uint256 amount,
19         address burner,
20         address dest,
21         IAnglePoolManager poolManager,
22         uint256 minCollatAmount
23     ) external;
24 
25     function unpause(bytes32 agent, IAnglePoolManager poolManager) external;
26 }
