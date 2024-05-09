1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 contract Proxy {
6     // Code position in storage is keccak256("PROXIABLE") = "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
7     uint256 constant PROXIABLE_MEM_SLOT = 0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7;
8     // constructor(bytes memory constructData, address contractLogic) public {
9     constructor(address contractLogic) public {
10         // Verify a valid address was passed in
11         require(contractLogic != address(0), "Contract Logic cannot be 0x0");
12 
13         // save the code address
14         assembly { // solium-disable-line
15             sstore(PROXIABLE_MEM_SLOT, contractLogic)
16         }
17     }
18 
19     fallback() external payable {
20         assembly { // solium-disable-line
21             let contractLogic := sload(PROXIABLE_MEM_SLOT)
22             let ptr := mload(0x40)
23             calldatacopy(ptr, 0x0, calldatasize())
24             let success := delegatecall(gas(), contractLogic, ptr, calldatasize(), 0, 0)
25             let retSz := returndatasize()
26             returndatacopy(ptr, 0, retSz)
27             switch success
28             case 0 {
29                 revert(ptr, retSz)
30             }
31             default {
32                 return(ptr, retSz)
33             }
34         }
35     }
36 }