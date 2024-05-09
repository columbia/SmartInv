1 // Dependency file: contracts/Proxy.sol
2 
3 // pragma solidity ^0.4.21;
4 
5 /**
6  * @title Proxy
7  * @dev Gives the possibility to delegate any call to a foreign implementation.
8  */
9 contract Proxy {
10   /**
11   * @dev Tells the address of the implementation where every call will be delegated.
12   * @return address of the implementation to which it will be delegated
13   */
14   function implementation() public view returns (address);
15 
16   /**
17   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
18   * This function will return whatever the implementation call returns
19   */
20   function () payable public {
21     address _impl = implementation();
22     require(_impl != address(0));
23 
24     assembly {
25       let ptr := mload(0x40)
26       calldatacopy(ptr, 0, calldatasize)
27       let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
28       let size := returndatasize
29       returndatacopy(ptr, 0, size)
30 
31       switch result
32       case 0 { revert(ptr, size) }
33       default { return(ptr, size) }
34     }
35   }
36 }
37 
38 
39 // Dependency file: contracts/UpgradeabilityProxy.sol
40 
41 // pragma solidity ^0.4.21;
42 
43 // import 'contracts/Proxy.sol';
44 
45 /**
46  * @title UpgradeabilityProxy
47  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
48  */
49 contract UpgradeabilityProxy is Proxy {
50   /**
51    * @dev This event will be emitted every time the implementation gets upgraded
52    * @param implementation representing the address of the upgraded implementation
53    */
54   event Upgraded(address indexed implementation);
55 
56   // Storage position of the address of the current implementation
57   bytes32 private constant implementationPosition = keccak256("org.zeppelinos.proxy.implementation");
58 
59   /**
60    * @dev Constructor function
61    */
62   function UpgradeabilityProxy() public {}
63 
64   /**
65    * @dev Tells the address of the current implementation
66    * @return address of the current implementation
67    */
68   function implementation() public view returns (address impl) {
69     bytes32 position = implementationPosition;
70     assembly {
71       impl := sload(position)
72     }
73   }
74 
75   /**
76    * @dev Sets the address of the current implementation
77    * @param newImplementation address representing the new implementation to be set
78    */
79   function setImplementation(address newImplementation) internal {
80     bytes32 position = implementationPosition;
81     assembly {
82       sstore(position, newImplementation)
83     }
84   }
85 
86   /**
87    * @dev Upgrades the implementation address
88    * @param newImplementation representing the address of the new implementation to be set
89    */
90   function _upgradeTo(address newImplementation) internal {
91     address currentImplementation = implementation();
92     require(currentImplementation != newImplementation);
93     setImplementation(newImplementation);
94     emit Upgraded(newImplementation);
95   }
96 }
97 
98 
99 // Root file: contracts/OwnedUpgradeabilityProxy.sol
100 
101 pragma solidity ^0.4.21;
102 
103 // import 'contracts/UpgradeabilityProxy.sol';
104 
105 /**
106  * @title OwnedUpgradeabilityProxy
107  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
108  */
109 contract OwnedUpgradeabilityProxy is UpgradeabilityProxy {
110   /**
111   * @dev Event to show ownership has been transferred
112   * @param previousOwner representing the address of the previous owner
113   * @param newOwner representing the address of the new owner
114   */
115   event ProxyOwnershipTransferred(address previousOwner, address newOwner);
116 
117   // Storage position of the owner of the contract
118   bytes32 private constant proxyOwnerPosition = keccak256("org.zeppelinos.proxy.owner");
119 
120   /**
121   * @dev the constructor sets the original owner of the contract to the sender account.
122   */
123   function OwnedUpgradeabilityProxy() public {
124     setUpgradeabilityOwner(msg.sender);
125   }
126 
127   /**
128   * @dev Throws if called by any account other than the owner.
129   */
130   modifier onlyProxyOwner() {
131     require(msg.sender == proxyOwner());
132     _;
133   }
134 
135   /**
136    * @dev Tells the address of the owner
137    * @return the address of the owner
138    */
139   function proxyOwner() public view returns (address owner) {
140     bytes32 position = proxyOwnerPosition;
141     assembly {
142       owner := sload(position)
143     }
144   }
145 
146   /**
147    * @dev Sets the address of the owner
148    */
149   function setUpgradeabilityOwner(address newProxyOwner) internal {
150     bytes32 position = proxyOwnerPosition;
151     assembly {
152       sstore(position, newProxyOwner)
153     }
154   }
155 
156   /**
157    * @dev Allows the current owner to transfer control of the contract to a newOwner.
158    * @param newOwner The address to transfer ownership to.
159    */
160   function transferProxyOwnership(address newOwner) public onlyProxyOwner {
161     require(newOwner != address(0));
162     emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
163     setUpgradeabilityOwner(newOwner);
164   }
165 
166   /**
167    * @dev Allows the proxy owner to upgrade the current version of the proxy.
168    * @param implementation representing the address of the new implementation to be set.
169    */
170   function upgradeTo(address implementation) public onlyProxyOwner {
171     _upgradeTo(implementation);
172   }
173 
174   /**
175    * @dev Allows the proxy owner to upgrade the current version of the proxy and call the new implementation
176    * to initialize whatever is needed through a low level call.
177    * @param implementation representing the address of the new implementation to be set.
178    * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
179    * signature of the implementation to be called with the needed payload
180    */
181   function upgradeToAndCall(address implementation, bytes data) payable public onlyProxyOwner {
182     upgradeTo(implementation);
183     require(this.call.value(msg.value)(data));
184   }
185 }