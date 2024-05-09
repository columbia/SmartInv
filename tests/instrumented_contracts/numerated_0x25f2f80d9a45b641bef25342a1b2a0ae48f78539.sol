1 /**
2  *Submitted for verification at polygonscan.com on 2022-03-16
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 contract NFTExchangeProxy {
10 
11     bytes32 private constant implementationPosition = keccak256("implementation.contract:2021");
12     bytes32 private constant proxyOwnerPosition = keccak256("owner.contract:2021");
13     
14     event Upgraded(address indexed implementation);
15     event ProxyOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17     constructor() {
18         setUpgradeabilityOwner(msg.sender);
19     }
20     
21     modifier onlyProxyOwner() {
22         require(msg.sender == proxyOwner());
23         _;
24     }
25 
26     function proxyOwner() public view returns (address owner) {
27         bytes32 position = proxyOwnerPosition;
28         assembly {
29             owner := sload(position)
30         }
31     }
32 
33     function implementation() public view returns (address impl) {
34         bytes32 position = implementationPosition;
35         assembly {
36             impl := sload(position)
37         }
38     }
39 
40     function setImplementation(address newImplementation) internal {
41         bytes32 position = implementationPosition;
42         assembly {
43             sstore(position, newImplementation)
44         }
45     }
46 
47     function _upgradeTo(address newImplementation) internal {
48         address currentImplementation = implementation();
49         require(currentImplementation != newImplementation);
50         setImplementation(newImplementation);
51         emit Upgraded(newImplementation);
52     }
53     
54     function setUpgradeabilityOwner(address newProxyOwner) internal {
55         bytes32 position = proxyOwnerPosition;
56         assembly {
57             sstore(position, newProxyOwner)
58         }
59     }
60 
61     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
62         require(newOwner != address(0));
63         emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
64         setUpgradeabilityOwner(newOwner);
65     }
66 
67     function upgradeTo(address _implementation) public onlyProxyOwner {
68         _upgradeTo(_implementation);
69     }
70     
71     function setAdminList(address /*_address*/, bool /*value*/) public onlyProxyOwner {
72         address _impl = implementation();
73         require(_impl != address(0), "Impl address is 0");
74 
75         assembly {
76             let ptr := mload(0x40)
77             calldatacopy(ptr, 0, calldatasize())
78             let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
79             let size := returndatasize()
80             returndatacopy(ptr, 0, size)
81 
82             switch result
83             case 0 { revert(ptr, size) }
84             default { return(ptr, size) }
85         }
86     }
87     
88     fallback() external payable {
89         address _impl = implementation();
90         require(_impl != address(0));
91 
92         assembly {
93             let ptr := mload(0x40)
94             calldatacopy(ptr, 0, calldatasize())
95             let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
96             let size := returndatasize()
97             returndatacopy(ptr, 0, size)
98 
99             switch result
100             case 0 { revert(ptr, size) }
101             default { return(ptr, size) }
102         }
103     }
104 }