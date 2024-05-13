1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "./Base.sol";
6 
7 
8 abstract contract BaseModule is Base {
9     // Construction
10 
11     // public accessors common to all modules
12 
13     uint immutable public moduleId;
14     bytes32 immutable public moduleGitCommit;
15 
16     constructor(uint moduleId_, bytes32 moduleGitCommit_) {
17         moduleId = moduleId_;
18         moduleGitCommit = moduleGitCommit_;
19     }
20 
21 
22     // Accessing parameters
23 
24     function unpackTrailingParamMsgSender() internal pure returns (address msgSender) {
25         assembly {
26             msgSender := shr(96, calldataload(sub(calldatasize(), 40)))
27         }
28     }
29 
30     function unpackTrailingParams() internal pure returns (address msgSender, address proxyAddr) {
31         assembly {
32             msgSender := shr(96, calldataload(sub(calldatasize(), 40)))
33             proxyAddr := shr(96, calldataload(sub(calldatasize(), 20)))
34         }
35     }
36 
37 
38     // Emit logs via proxies
39 
40     function emitViaProxy_Transfer(address proxyAddr, address from, address to, uint value) internal FREEMEM {
41         (bool success,) = proxyAddr.call(abi.encodePacked(
42                                uint8(3),
43                                keccak256(bytes('Transfer(address,address,uint256)')),
44                                bytes32(uint(uint160(from))),
45                                bytes32(uint(uint160(to))),
46                                value
47                           ));
48         require(success, "e/log-proxy-fail");
49     }
50 
51     function emitViaProxy_Approval(address proxyAddr, address owner, address spender, uint value) internal FREEMEM {
52         (bool success,) = proxyAddr.call(abi.encodePacked(
53                                uint8(3),
54                                keccak256(bytes('Approval(address,address,uint256)')),
55                                bytes32(uint(uint160(owner))),
56                                bytes32(uint(uint160(spender))),
57                                value
58                           ));
59         require(success, "e/log-proxy-fail");
60     }
61 }
