1 pragma solidity 0.6.12;
2 
3 contract Proxy {
4     // Code position in storage is keccak256("PROXIABLE") = "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
5     uint256 constant PROXY_MEM_SLOT = 0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7;
6 
7     constructor(address contractLogic) public {
8         // Verify a valid address was passed in
9         require(contractLogic != address(0), "Contract Logic cannot be 0x0");
10 
11         // save the code address
12         assembly {
13             // solium-disable-line
14             sstore(PROXY_MEM_SLOT, contractLogic)
15         }
16     }
17 
18     fallback() external payable {
19         assembly {
20             // solium-disable-line
21             let contractLogic := sload(PROXY_MEM_SLOT)
22             let ptr := mload(0x40)
23             calldatacopy(ptr, 0x0, calldatasize())
24             let success := delegatecall(
25                 gas(),
26                 contractLogic,
27                 ptr,
28                 calldatasize(),
29                 0,
30                 0
31             )
32             let retSz := returndatasize()
33             returndatacopy(ptr, 0, retSz)
34             switch success
35                 case 0 {
36                     revert(ptr, retSz)
37                 }
38                 default {
39                     return(ptr, retSz)
40                 }
41         }
42     }
43 }