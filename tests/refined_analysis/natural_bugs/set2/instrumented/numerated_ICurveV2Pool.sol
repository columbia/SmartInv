1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface ICurveV2Pool {
5 
6     function get_virtual_price() external view returns (uint256 price);
7 }