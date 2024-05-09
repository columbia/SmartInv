1 // SPDX-License-Identifier: Apache-2.0
2 pragma solidity =0.8.19; 
3 
4 
5 /**
6  * @title OwnedUpgradeabilityProxy
7  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
8  */
9  
10 contract StakingV3Proxy {
11     /**
12      * @dev Event to show ownership has been transferred
13      * @param previousOwner representing the address of the previous owner
14      * @param newOwner representing the address of the new owner
15      */
16     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
17 
18     /**
19      * @dev This event will be emitted every time the implementation gets upgraded
20      * @param implementation representing the address of the upgraded implementation
21      */
22     event Upgraded(address indexed implementation);
23 
24     // Storage position of the address of the maintenance boolean
25     bytes32 private constant maintenancePosition = keccak256("com.proxy.maintenance");
26     // Storage position of the address of the current implementation
27     bytes32 private constant implementationPosition = keccak256("com.proxy.implementation");
28     // Storage position of the owner of the contract
29     bytes32 private constant proxyOwnerPosition = keccak256("com.proxy.owner");
30 
31     /**
32      * @dev the constructor sets the original owner of the contract to the sender account.
33      */
34     constructor() {
35         setUpgradeabilityOwner(msg.sender);
36     }
37 
38     /**
39      * @dev Tells if contract is on maintenance
40      * @return _maintenance if contract is on maintenance
41      */
42     function maintenance() public view returns (bool _maintenance) {
43         bytes32 position = maintenancePosition;
44         assembly {
45             _maintenance := sload(position)
46         }
47     }
48 
49     /**
50      * @dev Sets if contract is on maintenance
51      */
52     function setMaintenance(bool _maintenance) external onlyProxyOwner {
53         bytes32 position = maintenancePosition;
54         assembly {
55             sstore(position, _maintenance)
56         }
57     }
58 
59     /**
60      * @dev Tells the address of the owner
61      * @return owner the address of the owner
62      */
63     function proxyOwner() public view returns (address owner) {
64         bytes32 position = proxyOwnerPosition;
65         assembly {
66             owner := sload(position)
67         }
68     }
69 
70     /**
71      * @dev Sets the address of the owner
72      */
73     function setUpgradeabilityOwner(address newProxyOwner) internal {
74         bytes32 position = proxyOwnerPosition;
75         assembly {
76             sstore(position, newProxyOwner)
77         }
78     }
79 
80     /**
81      * @dev Allows the current owner to transfer control of the contract to a newOwner.
82      * @param newOwner The address to transfer ownership to.
83      */
84     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
85         require(newOwner != address(0), 'OwnedUpgradeabilityProxy: INVALID');
86         emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
87         setUpgradeabilityOwner(newOwner);
88     }
89 
90     /*
91      * @dev Allows the proxy owner to upgrade the current version of the proxy.
92      * @param implementation representing the address of the new implementation to be set.
93      */
94     function upgradeTo(address newImplementation) public onlyProxyOwner {
95         _upgradeTo(newImplementation);
96     }
97 
98     /*
99      * @dev Allows the proxy owner to upgrade the current version of the proxy and call the new implementation
100      * to initialize whatever is needed through a low level call.
101      * @param implementation representing the address of the new implementation to be set.
102      * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
103      * signature of the implementation to be called with the needed payload
104      */
105     function upgradeToAndCall(address newImplementation, bytes memory data) payable public onlyProxyOwner {
106         upgradeTo(newImplementation);
107         (bool success, ) = address(this).call{ value: msg.value }(data);
108         require(success, "OwnedUpgradeabilityProxy: INVALID");
109     }
110 
111     /**
112      * @dev Fallback function allowing to perform a delegatecall to the given implementation.
113      * This function will return whatever the implementation call returns
114      */
115     fallback() external payable {
116         _fallback();
117     }
118 
119     receive () external payable {
120         _fallback();
121     }
122 
123     /**
124      * @dev Tells the address of the current implementation
125      * @return impl address of the current implementation
126      */
127     function implementation() public view returns (address impl) {
128         bytes32 position = implementationPosition;
129         assembly {
130             impl := sload(position)
131         }
132     }
133 
134     /**
135      * @dev Sets the address of the current implementation
136      * @param newImplementation address representing the new implementation to be set
137      */
138     function setImplementation(address newImplementation) internal {
139         bytes32 position = implementationPosition;
140         assembly {
141             sstore(position, newImplementation)
142         }
143     }
144 
145     /**
146      * @dev Upgrades the implementation address
147      * @param newImplementation representing the address of the new implementation to be set
148      */
149     function _upgradeTo(address newImplementation) internal {
150         address currentImplementation = implementation();
151         require(currentImplementation != newImplementation, 'OwnedUpgradeabilityProxy: INVALID');
152         setImplementation(newImplementation);
153         emit Upgraded(newImplementation);
154     }
155 
156     function _fallback() internal {
157         if (maintenance()) {
158             require(msg.sender == proxyOwner(), 'OwnedUpgradeabilityProxy: FORBIDDEN');
159         }
160         address _impl = implementation();
161         require(_impl != address(0), 'OwnedUpgradeabilityProxy: INVALID');
162         assembly {
163             let ptr := mload(0x40)
164             calldatacopy(ptr, 0, calldatasize())
165             let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
166             let size := returndatasize()
167             returndatacopy(ptr, 0, size)
168 
169             switch result
170             case 0 { revert(ptr, size) }
171             default { return(ptr, size) }
172         }
173     }
174 
175     /**
176      * @dev Throws if called by any account other than the owner.
177      */
178     modifier onlyProxyOwner() {
179         require(msg.sender == proxyOwner(), 'OwnedUpgradeabilityProxy: FORBIDDEN');
180         _;
181     }
182 }