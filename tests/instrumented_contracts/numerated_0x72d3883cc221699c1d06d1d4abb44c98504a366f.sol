1 pragma solidity ^0.4.21;
2 
3 // File: /Users/krogla/Projects/FiatToken/contracts/Proxy.sol
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
38 // File: /Users/krogla/Projects/FiatToken/contracts/UpgradeabilityProxy.sol
39 
40 /**
41  * @title UpgradeabilityProxy
42  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
43  */
44 contract UpgradeabilityProxy is Proxy {
45   /**
46    * @dev This event will be emitted every time the implementation gets upgraded
47    * @param implementation representing the address of the upgraded implementation
48    */
49   event Upgraded(address indexed implementation);
50 
51   // Storage position of the address of the current implementation
52   bytes32 private constant implementationPosition = keccak256("org.zeppelinos.proxy.implementation");
53 
54   /**
55    * @dev Constructor function
56    */
57   constructor() public {}
58 
59   /**
60    * @dev Tells the address of the current implementation
61    * @return address of the current implementation
62    */
63   function implementation() public view returns (address impl) {
64     bytes32 position = implementationPosition;
65     assembly {
66       impl := sload(position)
67     }
68   }
69 
70   /**
71    * @dev Sets the address of the current implementation
72    * @param newImplementation address representing the new implementation to be set
73    */
74   function setImplementation(address newImplementation) internal {
75     bytes32 position = implementationPosition;
76     assembly {
77       sstore(position, newImplementation)
78     }
79   }
80 
81   /**
82    * @dev Upgrades the implementation address
83    * @param newImplementation representing the address of the new implementation to be set
84    */
85   function _upgradeTo(address newImplementation) internal {
86     address currentImplementation = implementation();
87     require(currentImplementation != newImplementation);
88     setImplementation(newImplementation);
89     emit Upgraded(newImplementation);
90   }
91 }
92 
93 // File: contracts/OwnedUpgradeabilityProxy.sol
94 
95 /**
96  * @title OwnedUpgradeabilityProxy
97  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
98  */
99 contract OwnedUpgradeabilityProxy is UpgradeabilityProxy {
100   /**
101   * @dev Event to show ownership has been transferred
102   * @param previousOwner representing the address of the previous owner
103   * @param newOwner representing the address of the new owner
104   */
105   event ProxyOwnershipTransferred(address previousOwner, address newOwner);
106 
107   // Storage position of the owner of the contract
108   bytes32 private constant proxyOwnerPosition = keccak256("org.zeppelinos.proxy.owner");
109 
110   /**
111   * @dev the constructor sets the original owner of the contract to the sender account.
112   */
113   constructor() public {
114     setUpgradeabilityOwner(msg.sender);
115   }
116 
117   /**
118   * @dev Throws if called by any account other than the owner.
119   */
120   modifier onlyProxyOwner() {
121     require(msg.sender == proxyOwner());
122     _;
123   }
124 
125   /**
126    * @dev Tells the address of the owner
127    * @return the address of the owner
128    */
129   function proxyOwner() public view returns (address owner) {
130     bytes32 position = proxyOwnerPosition;
131     assembly {
132       owner := sload(position)
133     }
134   }
135 
136   /**
137    * @dev Sets the address of the owner
138    */
139   function setUpgradeabilityOwner(address newProxyOwner) internal {
140     bytes32 position = proxyOwnerPosition;
141     assembly {
142       sstore(position, newProxyOwner)
143     }
144   }
145 
146   /**
147    * @dev Allows the current owner to transfer control of the contract to a newOwner.
148    * @param newOwner The address to transfer ownership to.
149    */
150   function transferProxyOwnership(address newOwner) public onlyProxyOwner {
151     require(newOwner != address(0));
152     emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
153     setUpgradeabilityOwner(newOwner);
154   }
155 
156   /**
157    * @dev Allows the proxy owner to upgrade the current version of the proxy.
158    * @param implementation representing the address of the new implementation to be set.
159    */
160   function upgradeTo(address implementation) public onlyProxyOwner {
161     _upgradeTo(implementation);
162   }
163 
164   /**
165    * @dev Allows the proxy owner to upgrade the current version of the proxy and call the new implementation
166    * to initialize whatever is needed through a low level call.
167    * @param implementation representing the address of the new implementation to be set.
168    * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
169    * signature of the implementation to be called with the needed payload
170    */
171   function upgradeToAndCall(address implementation, bytes data) payable public onlyProxyOwner {
172     upgradeTo(implementation);
173     require(address(this).call.value(msg.value)(data));
174   }
175 }