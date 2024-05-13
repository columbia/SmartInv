1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 interface IMasterOracle {
5     function add(address[] calldata underlyings, address[] calldata _oracles) external;
6 
7     function changeAdmin(address newAdmin) external;
8 
9     function admin() external view returns (address);
10 }
