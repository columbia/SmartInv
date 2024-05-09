1 // SPDX-License-Identifier: UNLICENSED
2 // This code is taken from https://github.com/OpenZeppelin/openzeppelin-labs
3 // with minor modifications.
4 pragma solidity ^0.7.0;
5 
6 
7 // This code is taken from https://github.com/OpenZeppelin/openzeppelin-labs
8 // with minor modifications.
9 
10 
11 
12 // This code is taken from https://github.com/OpenZeppelin/openzeppelin-labs
13 // with minor modifications.
14 
15 
16 /**
17  * @title Proxy
18  * @dev Gives the possibility to delegate any call to a foreign implementation.
19  */
20 abstract contract Proxy {
21   /**
22   * @dev Tells the address of the implementation where every call will be delegated.
23   * @return impl address of the implementation to which it will be delegated
24   */
25   function implementation() public view virtual returns (address impl);
26 
27   receive() payable external {
28     _fallback();
29   }
30 
31   fallback() payable external {
32     _fallback();
33   }
34 
35   function _fallback() private {
36     address _impl = implementation();
37     require(_impl != address(0));
38 
39     assembly {
40       let ptr := mload(0x40)
41       calldatacopy(ptr, 0, calldatasize())
42       let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
43       let size := returndatasize()
44       returndatacopy(ptr, 0, size)
45 
46       switch result
47       case 0 { revert(ptr, size) }
48       default { return(ptr, size) }
49     }
50   }
51 }
52 
53 
54 /**
55  * @title UpgradeabilityProxy
56  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
57  */
58 contract UpgradeabilityProxy is Proxy {
59   /**
60    * @dev This event will be emitted every time the implementation gets upgraded
61    * @param implementation representing the address of the upgraded implementation
62    */
63   event Upgraded(address indexed implementation);
64 
65   // Storage position of the address of the current implementation
66   bytes32 private constant implementationPosition = keccak256("org.zeppelinos.proxy.implementation");
67 
68   /**
69    * @dev Constructor function
70    */
71   constructor() {}
72 
73   /**
74    * @dev Tells the address of the current implementation
75    * @return impl address of the current implementation
76    */
77   function implementation() public view override returns (address impl) {
78     bytes32 position = implementationPosition;
79     assembly {
80       impl := sload(position)
81     }
82   }
83 
84   /**
85    * @dev Sets the address of the current implementation
86    * @param newImplementation address representing the new implementation to be set
87    */
88   function setImplementation(address newImplementation) internal {
89     bytes32 position = implementationPosition;
90     assembly {
91       sstore(position, newImplementation)
92     }
93   }
94 
95   /**
96    * @dev Upgrades the implementation address
97    * @param newImplementation representing the address of the new implementation to be set
98    */
99   function _upgradeTo(address newImplementation) internal {
100     address currentImplementation = implementation();
101     require(currentImplementation != newImplementation);
102     setImplementation(newImplementation);
103     emit Upgraded(newImplementation);
104   }
105 }
106 
107 
108 /**
109  * @title OwnedUpgradabilityProxy
110  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
111  */
112 contract OwnedUpgradabilityProxy is UpgradeabilityProxy {
113   /**
114   * @dev Event to show ownership has been transferred
115   * @param previousOwner representing the address of the previous owner
116   * @param newOwner representing the address of the new owner
117   */
118   event ProxyOwnershipTransferred(address previousOwner, address newOwner);
119 
120   // Storage position of the owner of the contract
121   bytes32 private constant proxyOwnerPosition = keccak256("org.zeppelinos.proxy.owner");
122 
123   /**
124   * @dev the constructor sets the original owner of the contract to the sender account.
125   */
126   constructor() {
127     setUpgradabilityOwner(msg.sender);
128   }
129 
130   /**
131   * @dev Throws if called by any account other than the owner.
132   */
133   modifier onlyProxyOwner() {
134     require(msg.sender == proxyOwner());
135     _;
136   }
137 
138   /**
139    * @dev Tells the address of the owner
140    * @return owner the address of the owner
141    */
142   function proxyOwner() public view returns (address owner) {
143     bytes32 position = proxyOwnerPosition;
144     assembly {
145       owner := sload(position)
146     }
147   }
148 
149   /**
150    * @dev Sets the address of the owner
151    */
152   function setUpgradabilityOwner(address newProxyOwner) internal {
153     bytes32 position = proxyOwnerPosition;
154     assembly {
155       sstore(position, newProxyOwner)
156     }
157   }
158 
159   /**
160    * @dev Allows the current owner to transfer control of the contract to a newOwner.
161    * @param newOwner The address to transfer ownership to.
162    */
163   function transferProxyOwnership(address newOwner) public onlyProxyOwner {
164     require(newOwner != address(0));
165     emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
166     setUpgradabilityOwner(newOwner);
167   }
168 
169   /**
170    * @dev Allows the proxy owner to upgrade the current version of the proxy.
171    * @param implementation representing the address of the new implementation to be set.
172    */
173   function upgradeTo(address implementation) public onlyProxyOwner {
174     _upgradeTo(implementation);
175   }
176 
177   /**
178    * @dev Allows the proxy owner to upgrade the current version of the proxy and call the new implementation
179    * to initialize whatever is needed through a low level call.
180    * @param implementation representing the address of the new implementation to be set.
181    * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
182    * signature of the implementation to be called with the needed payload
183    */
184   function upgradeToAndCall(address implementation, bytes memory data) payable public onlyProxyOwner {
185     upgradeTo(implementation);
186     (bool success, ) = address(this).call{value: msg.value}(data);
187     require(success);
188   }
189 }