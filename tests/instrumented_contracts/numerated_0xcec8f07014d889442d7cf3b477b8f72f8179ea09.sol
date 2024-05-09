1 /**
2  * @title CoinTool, support ETH and ERC20 Tokens
3  * @dev To Use this Dapp: https://cointool.app
4 */
5 
6 pragma solidity 0.4.24;
7 
8 /**
9  * @title Proxy
10  * @dev Gives the possibility to delegate any call to a foreign implementation.
11  */
12 contract Proxy {
13   /**
14   * @dev Tells the address of the implementation where every call will be delegated.
15   * @return address of the implementation to which it will be delegated
16   */
17   function implementation() public view returns (address);
18   
19   /**
20   * @dev Tells the version of the current implementation
21   * @return version of the current implementation
22   */
23   function version() public view returns (string);
24 
25   /**
26   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
27   * This function will return whatever the implementation call returns
28   */
29   function () payable public {
30     address _impl = implementation();
31     require(_impl != address(0));
32 
33     assembly {
34       let ptr := mload(0x40)
35       calldatacopy(ptr, 0, calldatasize)
36       let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
37       let size := returndatasize
38       returndatacopy(ptr, 0, size)
39 
40       switch result
41       case 0 { revert(ptr, size) }
42       default { return(ptr, size) }
43     }
44   }
45 }
46 
47 pragma solidity 0.4.24;
48 
49 /**
50  * @title UpgradeabilityProxy
51  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
52  */
53 contract UpgradeabilityProxy is Proxy {
54   /**
55    * @dev This event will be emitted every time the implementation gets upgraded
56    * @param implementation representing the address of the upgraded implementation
57    */
58   event Upgraded(address indexed implementation, string version);
59 
60   // Storage position of the address of the current implementation
61   bytes32 private constant implementationPosition = keccak256("cointool.app.proxy.implementation");
62   
63    //Version name of the current implementation
64   string internal _version;
65 
66   /**
67    * @dev Constructor function
68    */
69   constructor() public {}
70   
71   
72   /**
73     * @dev Tells the version name of the current implementation
74     * @return string representing the name of the current version
75     */
76     function version() public view returns (string) {
77         return _version;
78     }
79 
80   /**
81    * @dev Tells the address of the current implementation
82    * @return address of the current implementation
83    */
84   function implementation() public view returns (address impl) {
85     bytes32 position = implementationPosition;
86     assembly {
87       impl := sload(position)
88     }
89   }
90 
91   /**
92    * @dev Sets the address of the current implementation
93    * @param _newImplementation address representing the new implementation to be set
94    */
95   function _setImplementation(address _newImplementation) internal {
96     bytes32 position = implementationPosition;
97     assembly {
98       sstore(position, _newImplementation)
99     }
100   }
101 
102   /**
103    * @dev Upgrades the implementation address
104    * @param _newImplementation representing the address of the new implementation to be set
105    */
106   function _upgradeTo(address _newImplementation, string _newVersion) internal {
107     address currentImplementation = implementation();
108     require(currentImplementation != _newImplementation);
109     _setImplementation(_newImplementation);
110     _version = _newVersion;
111     emit Upgraded( _newImplementation, _newVersion);
112   }
113 }
114 
115 
116 pragma solidity 0.4.24;
117 /**
118  * @title CoinToolProxy
119  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
120  */
121 contract CoinToolProxy is UpgradeabilityProxy {
122   /**
123   * @dev Event to show ownership has been transferred
124   * @param previousOwner representing the address of the previous owner
125   * @param newOwner representing the address of the new owner
126   */
127   event ProxyOwnershipTransferred(address previousOwner, address newOwner);
128 
129   // Storage position of the owner of the contract
130   bytes32 private constant proxyOwnerPosition = keccak256("cointool.app.proxy.owner");
131 
132   /**
133   * @dev the constructor sets the original owner of the contract to the sender account.
134   */
135   constructor(address _implementation, string _version) public {
136     _setUpgradeabilityOwner(msg.sender);
137     _upgradeTo(_implementation, _version);
138   }
139 
140   /**
141   * @dev Throws if called by any account other than the owner.
142   */
143   modifier onlyProxyOwner() {
144     require(msg.sender == proxyOwner());
145     _;
146   }
147 
148   /**
149    * @dev Tells the address of the owner
150    * @return the address of the owner
151    */
152   function proxyOwner() public view returns (address owner) {
153     bytes32 position = proxyOwnerPosition;
154     assembly {
155       owner := sload(position)
156     }
157   }
158 
159   /**
160    * @dev Allows the current owner to transfer control of the contract to a newOwner.
161    * @param _newOwner The address to transfer ownership to.
162    */
163   function transferProxyOwnership(address _newOwner) public onlyProxyOwner {
164     require(_newOwner != address(0));
165     _setUpgradeabilityOwner(_newOwner);
166     emit ProxyOwnershipTransferred(proxyOwner(), _newOwner);
167   }
168 
169   /**
170    * @dev Allows the proxy owner to upgrade the current version of the proxy.
171    * @param _implementation representing the address of the new implementation to be set.
172    */
173   function upgradeTo(address _implementation, string _newVersion) public onlyProxyOwner {
174     _upgradeTo(_implementation, _newVersion);
175   }
176 
177   /**
178    * @dev Allows the proxy owner to upgrade the current version of the proxy and call the new implementation
179    * to initialize whatever is needed through a low level call.
180    * @param _implementation representing the address of the new implementation to be set.
181    * @param _data represents the msg.data to bet sent in the low level call. This parameter may include the function
182    * signature of the implementation to be called with the needed payload
183    */
184   function upgradeToAndCall(address _implementation, string _newVersion, bytes _data) payable public onlyProxyOwner {
185     _upgradeTo(_implementation, _newVersion);
186     require(address(this).call.value(msg.value)(_data));
187   }
188 
189   /*
190    * @dev Sets the address of the owner
191    */
192   function _setUpgradeabilityOwner(address _newProxyOwner) internal {
193     bytes32 position = proxyOwnerPosition;
194     assembly {
195       sstore(position, _newProxyOwner)
196     }
197   }
198 }