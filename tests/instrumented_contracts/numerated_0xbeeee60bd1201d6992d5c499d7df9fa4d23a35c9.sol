1 pragma solidity ^0.8.4;
2 
3 contract BSCWinBulls {
4     event myEvent(bytes);
5     
6     // Code position in storage is keccak256("PROXIABLE") = "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
7     constructor(bytes memory constructData, address contractLogic) public {
8         // save the code address
9         assembly { // solium-disable-line
10             sstore(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7, contractLogic)
11         }
12         (bool success, bytes memory __ ) = contractLogic.delegatecall(constructData); // solium-disable-line
13         emit myEvent(__);
14         require(success, "Construction failed");
15     }
16 
17     fallback() external payable {
18         assembly { // solium-disable-line
19             let contractLogic := sload(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7)
20             calldatacopy(0x0, 0x0, calldatasize())
21             let success := delegatecall(gas(), contractLogic, 0x0, calldatasize(), 0, 0)
22             
23             returndatacopy(0, 0, returndatasize())
24             switch success
25             case 0 {
26                 revert(0, returndatasize())
27             }
28             default {
29                 return(0, returndatasize())
30             }
31         }
32     }
33 }