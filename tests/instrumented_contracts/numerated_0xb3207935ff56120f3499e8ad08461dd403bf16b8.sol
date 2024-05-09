1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.13;
3 
4 contract DAMMProxy {
5     // Code position in storage is keccak256("eip1967.proxy.implementation") = "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc"
6     constructor(bytes memory constructData, address contractLogic) {
7         // save the code address
8         assembly { // solium-disable-line
9             sstore(0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc, contractLogic)
10         }
11         (bool success, ) = contractLogic.delegatecall(constructData); // solium-disable-line
12         require(success, "Construction failed");
13     }
14 
15     fallback() external payable {
16         assembly { // solium-disable-line
17             let contractLogic := sload(0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc)
18             calldatacopy(0x0, 0x0, calldatasize())
19             let success := delegatecall(sub(gas(), 10000), contractLogic, 0x0, calldatasize(), 0, 0)
20             let retSz := returndatasize()
21             returndatacopy(0, 0, retSz)
22             switch success
23             case 0 {
24                 revert(0, retSz)
25             }
26             default {
27                 return(0, retSz)
28             }
29         }
30     }
31 }