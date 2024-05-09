1 pragma solidity 0.5.16;
2 
3 contract Proxy {
4     // Code position in storage is keccak256("PROXIABLE") = "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
5     // constructor(bytes memory constructData, address contractLogic) public {
6     constructor(address contractLogic) public {
7         // save the code address
8         assembly { // solium-disable-line
9             sstore(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7, contractLogic)
10         }
11     }
12 
13     function() external payable {
14         assembly { // solium-disable-line
15             let contractLogic := sload(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7)
16             let ptr := mload(0x40)
17             calldatacopy(ptr, 0x0, calldatasize)
18             let success := delegatecall(gas, contractLogic, ptr, calldatasize, 0, 0)
19             let retSz := returndatasize
20             returndatacopy(ptr, 0, retSz)
21             switch success
22             case 0 {
23                 revert(ptr, retSz)
24             }
25             default {
26                 return(ptr, retSz)
27             }
28         }
29     }
30 }