1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 
68 
69 /**
70  * @title UpgradeabilityStorage
71  * @dev This contract holds all the necessary state variables to support the upgrade functionality
72  */
73 contract UpgradeabilityStorage {
74     // Versions registry
75     IRegistry internal registry;
76 
77     // Address of the current implementation
78     address internal _implementation;
79 
80     /**
81     * @dev Tells the address of the current implementation
82     * @return address of the current implementation
83     */
84     function implementation() public view returns (address) {
85         return _implementation;
86     }
87 }
88 
89 /**
90  * @title Proxy
91  * @dev Gives the possibility to delegate any call to a foreign implementation.
92  */
93 contract Proxy {
94 
95     /**
96     * @dev Tells the address of the implementation where every call will be delegated.
97     * @return address of the implementation to which it will be delegated
98     */
99     function implementation() public view returns (address);
100 
101     /**
102     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
103     * This function will return whatever the implementation call returns
104     */
105     function () payable public {
106         address _impl = implementation();
107         require(_impl != address(0));
108 
109         assembly {
110             let ptr := mload(0x40)
111             calldatacopy(ptr, 0, calldatasize)
112             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
113             let size := returndatasize
114             returndatacopy(ptr, 0, size)
115 
116             switch result
117             case 0 { revert(ptr, size) }
118             default { return(ptr, size) }
119         }
120     }
121 }
122 
123 
124 
125 
126 /**
127  * @title IRegistry
128  * @dev This contract represents the interface of a registry contract
129  */
130 interface IRegistry {
131     /**
132     * @dev This event will be emitted every time a new proxy is created
133     * @param proxy representing the address of the proxy created
134     */
135     event ProxyCreated(address proxy);
136 
137     /**
138     * @dev This event will be emitted every time a new implementation is registered
139     * @param version representing the version name of the registered implementation
140     * @param implementation representing the address of the registered implementation
141     */
142     event VersionAdded(string version, address implementation);
143 
144     /**
145     * @dev Registers a new version with its implementation address
146     * @param version representing the version name of the new implementation to be registered
147     * @param implementation representing the address of the new implementation to be registered
148     */
149     function addVersion(string version, address implementation) external;
150 
151     /**
152     * @dev Tells the address of the implementation for a given version
153     * @param version to query the implementation of
154     * @return address of the implementation registered for the given version
155     */
156     function getVersion(string version) external view returns (address);
157 }
158 
159 
160 
161 /**
162  * @title UpgradeabilityProxy
163  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
164  */
165 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage, Ownable {
166 
167     /**
168     * @dev Constructor function
169     */
170     constructor(string _version) public {
171         registry = IRegistry(msg.sender);
172         upgradeTo(_version);
173     }
174 
175     /**
176     * @dev Upgrades the implementation to the requested version
177     * @param _version representing the version name of the new implementation to be set
178     */
179     function upgradeTo(string _version) public onlyOwner {
180         _implementation = registry.getVersion(_version);
181     }
182 
183 }