1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title IRegistry
5  * @dev This contract represents the interface of a registry contract
6  */
7 interface IRegistry {
8     /**
9     * @dev This event will be emitted every time a new proxy is created
10     * @param proxy representing the address of the proxy created
11     */
12     event ProxyCreated(address proxy);
13 
14     /**
15     * @dev This event will be emitted every time a new implementation is registered
16     * @param version representing the version name of the registered implementation
17     * @param implementation representing the address of the registered implementation
18     */
19     event VersionAdded(string version, address implementation);
20 
21     /**
22     * @dev Registers a new version with its implementation address
23     * @param version representing the version name of the new implementation to be registered
24     * @param implementation representing the address of the new implementation to be registered
25     */
26     function addVersion(string version, address implementation) external;
27 
28     /**
29     * @dev Tells the address of the implementation for a given version
30     * @param version to query the implementation of
31     * @return address of the implementation registered for the given version
32     */
33     function getVersion(string version) external view returns (address);
34 }
35 
36 /**
37  * @title Proxy
38  * @dev Gives the possibility to delegate any call to a foreign implementation.
39  */
40 contract Proxy {
41 
42     /**
43     * @dev Tells the address of the implementation where every call will be delegated.
44     * @return address of the implementation to which it will be delegated
45     */
46     function implementation() public view returns (address);
47 
48     /**
49     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
50     * This function will return whatever the implementation call returns
51     */
52     function () payable public {
53         address _impl = implementation();
54         require(_impl != address(0));
55 
56         assembly {
57             let ptr := mload(0x40)
58             calldatacopy(ptr, 0, calldatasize)
59             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
60             let size := returndatasize
61             returndatacopy(ptr, 0, size)
62 
63             switch result
64             case 0 { revert(ptr, size) }
65             default { return(ptr, size) }
66         }
67     }
68 }
69 
70 
71 
72 /**
73  * @title UpgradeabilityStorage
74  * @dev This contract holds all the necessary state variables to support the upgrade functionality
75  */
76 contract UpgradeabilityStorage {
77     // Versions registry
78     IRegistry internal registry;
79 
80     // Address of the current implementation
81     address internal _implementation;
82 
83     /**
84     * @dev Tells the address of the current implementation
85     * @return address of the current implementation
86     */
87     function implementation() public view returns (address) {
88         return _implementation;
89     }
90 }
91 
92 
93 /**
94  * @title Ownable
95  * @dev The Ownable contract has an owner address, and provides basic authorization control
96  * functions, this simplifies the implementation of "user permissions".
97  */
98 contract Ownable {
99   address public owner;
100 
101 
102   event OwnershipRenounced(address indexed previousOwner);
103   event OwnershipTransferred(
104     address indexed previousOwner,
105     address indexed newOwner
106   );
107 
108 
109   /**
110    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
111    * account.
112    */
113   constructor() public {
114     owner = msg.sender;
115   }
116 
117   /**
118    * @dev Throws if called by any account other than the owner.
119    */
120   modifier onlyOwner() {
121     require(msg.sender == owner);
122     _;
123   }
124 
125   /**
126    * @dev Allows the current owner to relinquish control of the contract.
127    * @notice Renouncing to ownership will leave the contract without an owner.
128    * It will not be possible to call the functions with the `onlyOwner`
129    * modifier anymore.
130    */
131   function renounceOwnership() public onlyOwner {
132     emit OwnershipRenounced(owner);
133     owner = address(0);
134   }
135 
136   /**
137    * @dev Allows the current owner to transfer control of the contract to a newOwner.
138    * @param _newOwner The address to transfer ownership to.
139    */
140   function transferOwnership(address _newOwner) public onlyOwner {
141     _transferOwnership(_newOwner);
142   }
143 
144   /**
145    * @dev Transfers control of the contract to a newOwner.
146    * @param _newOwner The address to transfer ownership to.
147    */
148   function _transferOwnership(address _newOwner) internal {
149     require(_newOwner != address(0));
150     emit OwnershipTransferred(owner, _newOwner);
151     owner = _newOwner;
152   }
153 }
154 
155 
156 
157 
158 
159 
160 
161 /**
162  * @title Upgradeable
163  * @dev This contract holds all the minimum required functionality for a behavior to be upgradeable.
164  * This means, required state variables for owned upgradeability purpose and simple initialization validation.
165  */
166 contract Upgradeable is UpgradeabilityStorage {
167     /**
168     * @dev Validates the caller is the versions registry.
169     * THIS FUNCTION SHOULD BE OVERRIDDEN CALLING SUPER
170     * @param sender representing the address deploying the initial behavior of the contract
171     */
172     function initialize(address sender) public payable {
173         require(msg.sender == address(registry));
174     }
175 }
176 
177 
178 
179 
180 
181 
182 
183 /**
184  * @title UpgradeabilityProxy
185  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
186  */
187 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage, Ownable {
188 
189     /**
190     * @dev Constructor function
191     */
192     constructor(string _version) public {
193         registry = IRegistry(msg.sender);
194         upgradeTo(_version);
195     }
196 
197     /**
198     * @dev Upgrades the implementation to the requested version
199     * @param _version representing the version name of the new implementation to be set
200     */
201     function upgradeTo(string _version) public onlyOwner {
202         _implementation = registry.getVersion(_version);
203     }
204 
205 }
206 
207 
208 /**
209  * @title Registry
210  * @dev This contract works as a registry of versions, it holds the implementations for the registered versions.
211  */
212 contract Registry is IRegistry, Ownable {
213     // Mapping of versions to implementations of different functions
214     mapping (string => address) internal versions;
215 
216     /**
217     * @dev Registers a new version with its implementation address
218     * @param version representing the version name of the new implementation to be registered
219     * @param implementation representing the address of the new implementation to be registered
220     */
221     function addVersion(string version, address implementation) external onlyOwner {
222         require(versions[version] == 0x0);
223         versions[version] = implementation;
224         emit VersionAdded(version, implementation);
225     }
226 
227     /**
228     * @dev Tells the address of the implementation for a given version
229     * @param version to query the implementation of
230     * @return address of the implementation registered for the given version
231     */
232     function getVersion(string version) external view returns (address) {
233         return versions[version];
234     }
235 
236     /**
237     * @dev Creates an upgradeable proxy
238     * @param version representing the first version to be set for the proxy
239     * @return address of the new proxy created
240     */
241     function createProxy(string version) public payable onlyOwner returns (UpgradeabilityProxy) {
242         UpgradeabilityProxy proxy = new UpgradeabilityProxy(version);
243         Upgradeable(proxy).initialize.value(msg.value)(msg.sender);
244         emit ProxyCreated(proxy);
245         return proxy;
246     }
247 }