1 // Sources flattened with hardhat v2.12.6 https://hardhat.org
2 
3 // File contracts/VZZNProxy.sol
4 
5 // SPDX-License-Identifier: Apache-2.0
6 pragma solidity ^0.8.0; 
7 
8 
9 /**
10  * @title VZZNProxy
11  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
12  */
13  
14 contract VZZNProxy {
15     /**
16      * @dev Event to show ownership has been transferred
17      * @param previousOwner representing the address of the previous owner
18      * @param newOwner representing the address of the new owner
19      */
20     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
21 
22     /**
23      * @dev This event will be emitted every time the implementation gets upgraded
24      * @param implementation representing the address of the upgraded implementation
25      */
26     event Upgraded(address indexed implementation);
27 
28     // Storage position of the address of the maintenance boolean
29     bytes32 private constant maintenancePosition = keccak256("com.proxy.maintenance");
30     // Storage position of the address of the current implementation
31     bytes32 private constant implementationPosition = keccak256("com.proxy.implementation");
32     // Storage position of the owner of the contract
33     bytes32 private constant proxyOwnerPosition = keccak256("com.proxy.owner");
34 
35     /**
36      * @dev the constructor sets the original owner of the contract to the sender account.
37      */
38     constructor() {
39         setUpgradeabilityOwner(msg.sender);
40     }
41 
42     /**
43      * @dev Tells if contract is on maintenance
44      * @return _maintenance if contract is on maintenance
45      */
46     function maintenance() public view returns (bool _maintenance) {
47         bytes32 position = maintenancePosition;
48         assembly {
49             _maintenance := sload(position)
50         }
51     }
52 
53     /**
54      * @dev Sets if contract is on maintenance
55      */
56     function setMaintenance(bool _maintenance) external onlyProxyOwner {
57         bytes32 position = maintenancePosition;
58         assembly {
59             sstore(position, _maintenance)
60         }
61     }
62 
63     /**
64      * @dev Tells the address of the owner
65      * @return owner the address of the owner
66      */
67     function proxyOwner() public view returns (address owner) {
68         bytes32 position = proxyOwnerPosition;
69         assembly {
70             owner := sload(position)
71         }
72     }
73 
74     /**
75      * @dev Sets the address of the owner
76      */
77     function setUpgradeabilityOwner(address newProxyOwner) internal {
78         bytes32 position = proxyOwnerPosition;
79         assembly {
80             sstore(position, newProxyOwner)
81         }
82     }
83 
84     /**
85      * @dev Allows the current owner to transfer control of the contract to a newOwner.
86      * @param newOwner The address to transfer ownership to.
87      */
88     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
89         require(newOwner != address(0), 'VZZNProxy: INVALID');
90         emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
91         setUpgradeabilityOwner(newOwner);
92     }
93 
94     /*
95      * @dev Allows the proxy owner to upgrade the current version of the proxy.
96      * @param implementation representing the address of the new implementation to be set.
97      */
98     function upgradeTo(address newImplementation) public onlyProxyOwner {
99         _upgradeTo(newImplementation);
100     }
101 
102     /*
103      * @dev Allows the proxy owner to upgrade the current version of the proxy and call the new implementation
104      * to initialize whatever is needed through a low level call.
105      * @param implementation representing the address of the new implementation to be set.
106      * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
107      * signature of the implementation to be called with the needed payload
108      */
109     function upgradeToAndCall(address newImplementation, bytes memory data) payable public onlyProxyOwner {
110         upgradeTo(newImplementation);
111         (bool success, ) = address(this).call{ value: msg.value }(data);
112         require(success, "VZZNProxy: INVALID");
113     }
114 
115     /**
116      * @dev Fallback function allowing to perform a delegatecall to the given implementation.
117      * This function will return whatever the implementation call returns
118      */
119     fallback() external payable {
120         _fallback();
121     }
122 
123     receive () external payable {
124         _fallback();
125     }
126 
127     /**
128      * @dev Tells the address of the current implementation
129      * @return impl address of the current implementation
130      */
131     function implementation() public view returns (address impl) {
132         bytes32 position = implementationPosition;
133         assembly {
134             impl := sload(position)
135         }
136     }
137 
138     /**
139      * @dev Sets the address of the current implementation
140      * @param newImplementation address representing the new implementation to be set
141      */
142     function setImplementation(address newImplementation) internal {
143         bytes32 position = implementationPosition;
144         assembly {
145             sstore(position, newImplementation)
146         }
147     }
148 
149     /**
150      * @dev Upgrades the implementation address
151      * @param newImplementation representing the address of the new implementation to be set
152      */
153     function _upgradeTo(address newImplementation) internal {
154         address currentImplementation = implementation();
155         require(currentImplementation != newImplementation, 'VZZNProxy: INVALID');
156         setImplementation(newImplementation);
157         emit Upgraded(newImplementation);
158     }
159 
160     function _fallback() internal {
161         if (maintenance()) {
162             require(msg.sender == proxyOwner(), 'VZZNProxy: FORBIDDEN');
163         }
164         address _impl = implementation();
165         require(_impl != address(0), 'VZZNProxy: INVALID');
166         assembly {
167             let ptr := mload(0x40)
168             calldatacopy(ptr, 0, calldatasize())
169             let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
170             let size := returndatasize()
171             returndatacopy(ptr, 0, size)
172 
173             switch result
174             case 0 { revert(ptr, size) }
175             default { return(ptr, size) }
176         }
177     }
178 
179     /**
180      * @dev Throws if called by any account other than the owner.
181      */
182     modifier onlyProxyOwner() {
183         require(msg.sender == proxyOwner(), 'VZZNProxy: FORBIDDEN');
184         _;
185     }
186 }