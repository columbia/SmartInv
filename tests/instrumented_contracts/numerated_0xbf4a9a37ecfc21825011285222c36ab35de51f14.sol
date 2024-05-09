1 // File: browser/Proxy.sol
2 
3 pragma solidity ^0.6.6;
4 
5 contract NyanV2Proxy {
6     event myEvent(bytes);
7     
8     // Code position in storage is keccak256("PROXIABLE") = "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
9     constructor(bytes memory constructData, address contractLogic) public {
10         // save the code address
11         assembly { // solium-disable-line
12             sstore(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7, contractLogic)
13         }
14         (bool success, bytes memory _ ) = contractLogic.delegatecall(constructData); // solium-disable-line
15         emit myEvent(_);
16         require(success, "Construction failed");
17     }
18 
19     fallback() external payable {
20         assembly { // solium-disable-line
21             let contractLogic := sload(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7)
22             calldatacopy(0x0, 0x0, calldatasize())
23             let success := delegatecall(gas(), contractLogic, 0x0, calldatasize(), 0, 0)
24             
25             returndatacopy(0, 0, returndatasize())
26             switch success
27             case 0 {
28                 revert(0, returndatasize())
29             }
30             default {
31                 return(0, returndatasize())
32             }
33         }
34     }
35 }