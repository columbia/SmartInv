1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-27
3 */
4 
5 pragma solidity ^0.8.0;
6 
7 contract MasterChefProxy {
8     event myEvent(bytes);
9     
10     // Code position in storage is keccak256("PROXIABLE") = "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
11     constructor(bytes memory constructData, address contractLogic) public {
12         // save the code address
13         assembly { // solium-disable-line
14             sstore(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7, contractLogic)
15         }
16         (bool success, bytes memory __ ) = contractLogic.delegatecall(constructData); // solium-disable-line
17         emit myEvent(__);
18         require(success, "Construction failed");
19     }
20 
21     fallback() external payable {
22         assembly { // solium-disable-line
23             let contractLogic := sload(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7)
24             calldatacopy(0x0, 0x0, calldatasize())
25             let success := delegatecall(gas(), contractLogic, 0x0, calldatasize(), 0, 0)
26             
27             returndatacopy(0, 0, returndatasize())
28             switch success
29             case 0 {
30                 revert(0, returndatasize())
31             }
32             default {
33                 return(0, returndatasize())
34             }
35         }
36     }
37 }