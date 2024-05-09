1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 contract HokkaidoInu {
6 
7     // Code position in storage is keccak256("PROXIABLE") = "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
8     constructor(bytes memory constructData, address contractLogic) public {
9         // save the code address
10         assembly { // solium-disable-line
11             sstore(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7, contractLogic)
12         }
13         (bool success, bytes memory __ ) = contractLogic.delegatecall(constructData); // solium-disable-line
14 
15         require(success, "Construction failed");
16     }
17 
18     fallback() external payable {
19         assembly { // solium-disable-line
20             let contractLogic := sload(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7)
21             calldatacopy(0x0, 0x0, calldatasize())
22             let success := delegatecall(gas(), contractLogic, 0x0, calldatasize(), 0, 0)
23 
24             returndatacopy(0, 0, returndatasize())
25             switch success
26             case 0 {
27                 revert(0, returndatasize())
28             }
29             default {
30                 return(0, returndatasize())
31             }
32         }
33     }
34 }