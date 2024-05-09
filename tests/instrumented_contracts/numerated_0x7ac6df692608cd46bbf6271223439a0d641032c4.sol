1 contract OwnedUpgradeabilityStorage {
2 
3   // Current implementation
4   address internal _implementation;
5 
6   // Owner of the contract
7   address private _upgradeabilityOwner;
8 
9   /**
10    * @dev Tells the address of the owner
11    * @return the address of the owner
12    */
13   function upgradeabilityOwner() public view returns (address) {
14     return _upgradeabilityOwner;
15   }
16 
17   /**
18    * @dev Sets the address of the owner
19    */
20   function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
21     _upgradeabilityOwner = newUpgradeabilityOwner;
22   }
23 
24   /**
25   * @dev Tells the address of the current implementation
26   * @return address of the current implementation
27   */
28   function implementation() public view returns (address) {
29     return _implementation;
30   }
31 
32   /**
33   * @dev Tells the proxy type (EIP 897)
34   * @return Proxy type, 2 for forwarding proxy
35   */
36   function proxyType() public pure returns (uint256 proxyTypeId) {
37     return 2;
38   }
39 }
40 
41 
42 
43 contract Proxy {
44 
45   /**
46   * @dev Tells the address of the implementation where every call will be delegated.
47   * @return address of the implementation to which it will be delegated
48   */
49   function implementation() public view returns (address);
50 
51   /**
52   * @dev Tells the type of proxy (EIP 897)
53   * @return Type of proxy, 2 for upgradeable proxy
54   */
55   function proxyType() public pure returns (uint256 proxyTypeId);
56 
57   /**
58   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
59   * This function will return whatever the implementation call returns
60   */
61   function () payable public {
62     address _impl = implementation();
63     require(_impl != address(0));
64 
65     assembly {
66       let ptr := mload(0x40)
67       calldatacopy(ptr, 0, calldatasize)
68       let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
69       let size := returndatasize
70       returndatacopy(ptr, 0, size)
71 
72       switch result
73       case 0 { revert(ptr, size) }
74       default { return(ptr, size) }
75     }
76   }
77 }
78 
79 contract OwnedUpgradeabilityProxy is Proxy, OwnedUpgradeabilityStorage {
80   /**
81   * @dev Event to show ownership has been transferred
82   * @param previousOwner representing the address of the previous owner
83   * @param newOwner representing the address of the new owner
84   */
85   event ProxyOwnershipTransferred(address previousOwner, address newOwner);
86 
87   /**
88   * @dev This event will be emitted every time the implementation gets upgraded
89   * @param implementation representing the address of the upgraded implementation
90   */
91   event Upgraded(address indexed implementation);
92 
93   /**
94   * @dev Upgrades the implementation address
95   * @param implementation representing the address of the new implementation to be set
96   */
97   function _upgradeTo(address implementation) internal {
98     require(_implementation != implementation);
99     _implementation = implementation;
100     emit Upgraded(implementation);
101   }
102 
103   /**
104   * @dev Throws if called by any account other than the owner.
105   */
106   modifier onlyProxyOwner() {
107     require(msg.sender == proxyOwner());
108     _;
109   }
110 
111   /**
112    * @dev Tells the address of the proxy owner
113    * @return the address of the proxy owner
114    */
115   function proxyOwner() public view returns (address) {
116     return upgradeabilityOwner();
117   }
118 
119   /**
120    * @dev Allows the current owner to transfer control of the contract to a newOwner.
121    * @param newOwner The address to transfer ownership to.
122    */
123   function transferProxyOwnership(address newOwner) public onlyProxyOwner {
124     require(newOwner != address(0));
125     emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
126     setUpgradeabilityOwner(newOwner);
127   }
128 
129   /**
130    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy.
131    * @param implementation representing the address of the new implementation to be set.
132    */
133   function upgradeTo(address implementation) public onlyProxyOwner {
134     _upgradeTo(implementation);
135   }
136 
137   /**
138    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy
139    * and delegatecall the new implementation for initialization.
140    * @param implementation representing the address of the new implementation to be set.
141    * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
142    * signature of the implementation to be called with the needed payload
143    */
144   function upgradeToAndCall(address implementation, bytes data) payable public onlyProxyOwner {
145     upgradeTo(implementation);
146     require(address(this).delegatecall(data));
147   }
148 }
149 
150 
151 contract OwnableDelegateProxy is OwnedUpgradeabilityProxy {
152 
153     constructor(address owner, address initialImplementation, bytes calldata)
154         public
155     {
156         setUpgradeabilityOwner(owner);
157         _upgradeTo(initialImplementation);
158         require(initialImplementation.delegatecall(calldata));
159     }
160 
161 }