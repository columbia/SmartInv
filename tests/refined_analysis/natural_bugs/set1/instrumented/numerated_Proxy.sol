1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 contract Proxy {
6     address immutable creator;
7 
8     constructor() {
9         creator = msg.sender;
10     }
11 
12     // External interface
13 
14     fallback() external {
15         address creator_ = creator;
16 
17         if (msg.sender == creator_) {
18             assembly {
19                 mstore(0, 0)
20                 calldatacopy(31, 0, calldatasize())
21 
22                 switch mload(0) // numTopics
23                     case 0 { log0(32,  sub(calldatasize(), 1)) }
24                     case 1 { log1(64,  sub(calldatasize(), 33),  mload(32)) }
25                     case 2 { log2(96,  sub(calldatasize(), 65),  mload(32), mload(64)) }
26                     case 3 { log3(128, sub(calldatasize(), 97),  mload(32), mload(64), mload(96)) }
27                     case 4 { log4(160, sub(calldatasize(), 129), mload(32), mload(64), mload(96), mload(128)) }
28                     default { revert(0, 0) }
29 
30                 return(0, 0)
31             }
32         } else {
33             assembly {
34                 mstore(0, 0xe9c4a3ac00000000000000000000000000000000000000000000000000000000) // dispatch() selector
35                 calldatacopy(4, 0, calldatasize())
36                 mstore(add(4, calldatasize()), shl(96, caller()))
37 
38                 let result := call(gas(), creator_, 0, 0, add(24, calldatasize()), 0, 0)
39                 returndatacopy(0, 0, returndatasize())
40 
41                 switch result
42                     case 0 { revert(0, returndatasize()) }
43                     default { return(0, returndatasize()) }
44             }
45         }
46     }
47 }
