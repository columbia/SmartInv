1 // File: contracts/Proxy.sol
2 
3 pragma solidity ^0.5.1;
4 
5 contract Proxy {
6     // Code position in storage is keccak256("PROXIABLE") = "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
7     constructor(bytes memory constructData, address contractLogic) public {
8         // save the code address
9         assembly { // solium-disable-line
10             sstore(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7, contractLogic)
11         }
12         (bool success, /* bytes memory _*/ ) = contractLogic.delegatecall(constructData); // solium-disable-line
13         require(success, "Construction failed");
14     }
15 
16     function() external payable {
17         assembly { // solium-disable-line
18             let contractLogic := sload(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7)
19             calldatacopy(0x0, 0x0, calldatasize)
20             let success := delegatecall(sub(gas, 10000), contractLogic, 0x0, calldatasize, 0, 0)
21             let retSz := returndatasize
22             returndatacopy(0, 0, retSz)
23             switch success
24             case 0 {
25                 revert(0, retSz)
26             }
27             default {
28                 return(0, retSz)
29             }
30         }
31     }
32 }