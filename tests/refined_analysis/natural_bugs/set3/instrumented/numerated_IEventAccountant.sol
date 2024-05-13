1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 interface IEventAccountant {
5     function record(
6         address _asset,
7         address _user,
8         uint256 _amount
9     ) external;
10 
11     function affectedAssets()
12         external
13         pure
14         returns (address payable[14] memory);
15 
16     function isAffectedAsset(address _asset) external view returns (bool);
17 }
