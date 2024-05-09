1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 contract Proxy {
6     // Code position in storage is keccak256("PROXIABLE") = "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
7     constructor(bytes memory constructData, address contractLogic) public {
8         // save the code address
9         assembly {
10             // solium-disable-line
11             sstore(
12                 0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7,
13                 contractLogic
14             )
15         }
16         (bool success, bytes memory _) = contractLogic.delegatecall(
17             constructData
18         ); // solium-disable-line
19         require(success, "Construction failed");
20     }
21 
22     fallback() external payable {
23         assembly { // solium-disable-line
24             let contractLogic := sload(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7)
25             calldatacopy(0x0, 0x0, calldatasize())
26             let success := delegatecall(sub(gas(), 10000), contractLogic, 0x0, calldatasize(), 0, 0)
27             let retSz := returndatasize()
28             returndatacopy(0, 0, retSz)
29             switch success
30             case 0 {
31                 revert(0, retSz)
32             }
33             default {
34                 return(0, retSz)
35             }
36         }
37     }
38 }