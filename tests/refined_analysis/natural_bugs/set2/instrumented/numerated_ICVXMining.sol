1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 // solhint-disable func-name-mixedcase
5 interface ICVXMining {
6   function ConvertCrvToCvx(uint256 _amount) external view returns (uint256);
7 }