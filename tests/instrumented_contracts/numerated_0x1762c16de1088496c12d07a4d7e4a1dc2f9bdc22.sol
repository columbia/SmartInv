1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.7.0;
3 
4 contract GeneralPurposeProxy {
5 
6     constructor(address source) payable {
7         assembly {
8             sstore(0xf7e3126f87228afb82c9b18537eed25aaeb8171a78814781c26ed2cfeff27e69, source)
9         }
10     }
11 
12     fallback() external payable {
13         assembly {
14             let _singleton := sload(0xf7e3126f87228afb82c9b18537eed25aaeb8171a78814781c26ed2cfeff27e69)
15             calldatacopy(0, 0, calldatasize())
16             let success := delegatecall(gas(), _singleton, 0, calldatasize(), 0, 0)
17             returndatacopy(0, 0, returndatasize())
18             switch success
19                 case 0 {revert(0, returndatasize())}
20                 default { return(0, returndatasize())}
21         }
22     }
23 }