1 // SPDX-License-Identifier: MIT
2 pragma experimental ABIEncoderV2;
3 pragma solidity =0.7.6;
4 interface IProxyAdmin {
5     function upgrade(address proxy, address implementation) external;
6 }
