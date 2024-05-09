1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @title S4fechainProxy
6  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
7  */
8 contract OwnedUpgradeabilityProxy {
9     /**
10      * @dev Event to show ownership has been transferred
11      * @param previousOwner representing the address of the previous owner
12      * @param newOwner representing the address of the new owner
13      */
14     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
15 
16     /**
17      * @dev This event will be emitted every time the implementation gets upgraded
18      * @param implementation representing the address of the upgraded implementation
19      */
20     event Upgraded(address indexed implementation);
21 
22     // Storage position of the address of the maintenance boolean
23     bytes32 private constant maintenancePosition = keccak256("com.s4fechain.proxy.maintenance");
24     // Storage position of the address of the current implementation
25     bytes32 private constant implementationPosition = keccak256("com.s4fechain.proxy.implementation");
26     // Storage position of the owner of the contract
27     bytes32 private constant proxyOwnerPosition = keccak256("com.s4fechain.proxy.owner");
28 
29     /**
30      * @dev the constructor sets the original owner of the contract to the sender account.
31      */
32     constructor() {
33         setUpgradeabilityOwner(msg.sender);
34     }
35 
36     /**
37      * @dev Tells if contract is on maintenance
38      * @return _maintenance if contract is on maintenance
39      */
40     function maintenance() public view returns (bool _maintenance) {
41         bytes32 position = maintenancePosition;
42         assembly {
43             _maintenance := sload(position)
44         }
45     }
46 
47     /**
48      * @dev Sets if contract is on maintenance
49      */
50     function setMaintenance(bool _maintenance) external onlyProxyOwner {
51         bytes32 position = maintenancePosition;
52         assembly {
53             sstore(position, _maintenance)
54         }
55     }
56 
57     /**
58      * @dev Tells the address of the owner
59      * @return owner the address of the owner
60      */
61     function proxyOwner() public view returns (address owner) {
62         bytes32 position = proxyOwnerPosition;
63         assembly {
64             owner := sload(position)
65         }
66     }
67 
68     /**
69      * @dev Sets the address of the owner
70      */
71     function setUpgradeabilityOwner(address newProxyOwner) internal {
72         bytes32 position = proxyOwnerPosition;
73         assembly {
74             sstore(position, newProxyOwner)
75         }
76     }
77 
78     /**
79      * @dev Allows the current owner to transfer control of the contract to a newOwner.
80      * @param newOwner The address to transfer ownership to.
81      */
82     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
83         require(newOwner != address(0), 'OwnedUpgradeabilityProxy: INVALID');
84         emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
85         setUpgradeabilityOwner(newOwner);
86     }
87 
88     /**
89      * @dev Allows the proxy owner to upgrade the current version of the proxy.
90      * @param _implementation representing the address of the new implementation to be set.
91      */
92     function upgradeTo(address _implementation) public onlyProxyOwner {
93         _upgradeTo(_implementation);
94     }
95 
96     /**
97      * @dev Allows the proxy owner to upgrade the current version of the proxy and call the new implementation
98      * to initialize whatever is needed through a low level call.
99      * @param _implementation representing the address of the new implementation to be set.
100      * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
101      * signature of the implementation to be called with the needed payload
102      */
103     function upgradeToAndCall(address _implementation, bytes memory data) payable public onlyProxyOwner {
104         upgradeTo(_implementation);
105         (bool success, ) = address(this).call{ value: msg.value }(data);
106         require(success, "OwnedUpgradeabilityProxy: INVALID");
107     }
108 
109     /**
110      * @dev Fallback function allowing to perform a delegatecall to the given implementation.
111      * This function will return whatever the implementation call returns
112      */
113     fallback() external payable {
114         _fallback();
115     }
116 
117     receive () external payable {
118         _fallback();
119     }
120 
121     /**
122      * @dev Tells the address of the current implementation
123      * @return impl address of the current implementation
124      */
125     function implementation() public view returns (address impl) {
126         bytes32 position = implementationPosition;
127         assembly {
128             impl := sload(position)
129         }
130     }
131 
132     /**
133      * @dev Sets the address of the current implementation
134      * @param newImplementation address representing the new implementation to be set
135      */
136     function setImplementation(address newImplementation) internal {
137         bytes32 position = implementationPosition;
138         assembly {
139             sstore(position, newImplementation)
140         }
141     }
142 
143     /**
144      * @dev Upgrades the implementation address
145      * @param newImplementation representing the address of the new implementation to be set
146      */
147     function _upgradeTo(address newImplementation) internal {
148         address currentImplementation = implementation();
149         require(currentImplementation != newImplementation, 'OwnedUpgradeabilityProxy: INVALID');
150         setImplementation(newImplementation);
151         emit Upgraded(newImplementation);
152     }
153 
154     function _fallback() internal {
155         if (maintenance()) {
156             require(msg.sender == proxyOwner(), 'OwnedUpgradeabilityProxy: FORBIDDEN');
157         }
158         address _impl = implementation();
159         require(_impl != address(0), 'OwnedUpgradeabilityProxy: INVALID');
160         assembly {
161             let ptr := mload(0x40)
162             calldatacopy(ptr, 0, calldatasize())
163             let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
164             let size := returndatasize()
165             returndatacopy(ptr, 0, size)
166 
167             switch result
168             case 0 { revert(ptr, size) }
169             default { return(ptr, size) }
170         }
171     }
172 
173     /**
174      * @dev Throws if called by any account other than the owner.
175      */
176     modifier onlyProxyOwner() {
177         require(msg.sender == proxyOwner(), 'OwnedUpgradeabilityProxy: FORBIDDEN');
178         _;
179     }
180 }