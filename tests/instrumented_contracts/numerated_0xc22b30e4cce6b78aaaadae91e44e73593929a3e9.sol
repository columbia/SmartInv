1 pragma solidity ^0.6.8;
2 pragma experimental ABIEncoderV2;
3 
4 
5 contract ZoraProxyStorage {
6 
7     address public implementation;
8     address public admin;
9 
10     modifier onlyAdmin() {
11         require(
12             admin == msg.sender,
13             "ZoraProxyStorage: only admin"
14         );
15         _;
16     }
17 }
18 
19 // SPDX-License-Identifier: MIT
20 contract ZoraProxy is ZoraProxyStorage {
21 
22     /* ============ Constructor ============ */
23     constructor(
24         address _implementation,
25         address _admin
26     )
27         public
28     {
29         implementation = _implementation;
30         admin = _admin;
31     }
32 
33     function setAdmin(
34         address _admin
35     )
36         public
37         onlyAdmin
38     {
39         admin = _admin;
40     }
41 
42     function setImplementation(
43         address _implementation
44     )
45         public
46         onlyAdmin
47     {
48         implementation = _implementation;
49     }
50 
51     fallback() external payable {
52         // solium-disable-next-line security/no-inline-assembly
53         assembly {
54             let target := sload(0)
55             calldatacopy(0, 0, calldatasize())
56             let result := delegatecall(gas(), target, 0, calldatasize(), 0, 0)
57             returndatacopy(0, 0, returndatasize())
58             switch result
59             case 0 {revert(0, returndatasize())}
60             default {return (0, returndatasize())}
61         }
62     }
63 
64 }