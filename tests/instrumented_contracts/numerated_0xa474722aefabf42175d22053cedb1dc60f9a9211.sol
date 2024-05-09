1 pragma solidity ^0.4.24;
2 
3 // File: contracts/eternal_storage/EternalStorage.sol
4 
5 /**
6  * @title EternalStorage
7  * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
8  */
9 contract EternalStorage {
10 
11   mapping(bytes32 => uint256) internal uintStorage;
12   mapping(bytes32 => string) internal stringStorage;
13   mapping(bytes32 => address) internal addressStorage;
14   mapping(bytes32 => bytes) internal bytesStorage;
15   mapping(bytes32 => bool) internal boolStorage;
16   mapping(bytes32 => int256) internal intStorage;
17 
18 }
19 
20 // File: contracts/eternal_storage/Proxy.sol
21 
22 /**
23  * @title Proxy
24  * @dev Gives the possibility to delegate any call to a foreign implementation.
25  */
26 contract Proxy {
27 
28   /**
29   * @dev Tells the address of the implementation where every call will be delegated.
30   * @return address of the implementation to which it will be delegated
31   */
32   function implementation() public view returns (address);
33 
34   /**
35   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
36   * This function will return whatever the implementation call returns
37   */
38   function () payable public {
39     address _impl = implementation();
40     require(_impl != address(0));
41 
42     assembly {
43       let ptr := mload(0x40)
44       calldatacopy(ptr, 0, calldatasize)
45       let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
46       let size := returndatasize
47       returndatacopy(ptr, 0, size)
48 
49       switch result
50       case 0 { revert(ptr, size) }
51       default { return(ptr, size) }
52     }
53   }
54 }
55 
56 // File: contracts/eternal_storage/UpgradeabilityStorage.sol
57 
58 /**
59  * @title UpgradeabilityStorage
60  * @dev This contract holds all the necessary state variables to support the upgrade functionality
61  */
62 contract UpgradeabilityStorage {
63   // Version name of the current implementation
64   string internal _version;
65 
66   // Address of the current implementation
67   address internal _implementation;
68 
69   /**
70   * @dev Tells the version name of the current implementation
71   * @return string representing the name of the current version
72   */
73   function version() public view returns (string) {
74     return _version;
75   }
76 
77   /**
78   * @dev Tells the address of the current implementation
79   * @return address of the current implementation
80   */
81   function implementation() public view returns (address) {
82     return _implementation;
83   }
84 }
85 
86 // File: contracts/eternal_storage/UpgradeabilityProxy.sol
87 
88 /**
89  * @title UpgradeabilityProxy
90  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
91  */
92 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
93   /**
94   * @dev This event will be emitted every time the implementation gets upgraded
95   * @param version representing the version name of the upgraded implementation
96   * @param implementation representing the address of the upgraded implementation
97   */
98   event Upgraded(string version, address indexed implementation);
99 
100   /**
101   * @dev Upgrades the implementation address
102   * @param version representing the version name of the new implementation to be set
103   * @param implementation representing the address of the new implementation to be set
104   */
105   function _upgradeTo(string version, address implementation) internal {
106     require(_implementation != implementation);
107     _version = version;
108     _implementation = implementation;
109     emit Upgraded(version, implementation);
110   }
111 }
112 
113 // File: contracts/eternal_storage/UpgradeabilityOwnerStorage.sol
114 
115 /**
116  * @title UpgradeabilityOwnerStorage
117  * @dev This contract keeps track of the upgradeability owner
118  */
119 contract UpgradeabilityOwnerStorage {
120   // Owner of the contract
121   address private _upgradeabilityOwner;
122 
123   /**
124    * @dev Tells the address of the owner
125    * @return the address of the owner
126    */
127   function upgradeabilityOwner() public view returns (address) {
128     return _upgradeabilityOwner;
129   }
130 
131   /**
132    * @dev Sets the address of the owner
133    */
134   function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
135     _upgradeabilityOwner = newUpgradeabilityOwner;
136   }
137 }
138 
139 // File: contracts/eternal_storage/OwnedUpgradeabilityProxy.sol
140 
141 /**
142  * @title OwnedUpgradeabilityProxy
143  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
144  */
145 contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
146   /**
147   * @dev Event to show ownership has been transferred
148   * @param previousOwner representing the address of the previous owner
149   * @param newOwner representing the address of the new owner
150   */
151   event ProxyOwnershipTransferred(address previousOwner, address newOwner);
152 
153   /**
154   * @dev the constructor sets the original owner of the contract to the sender account.
155   */
156   constructor() public {
157     setUpgradeabilityOwner(msg.sender);
158   }
159 
160   /**
161   * @dev Throws if called by any account other than the owner.
162   */
163   modifier onlyProxyOwner() {
164     require(msg.sender == proxyOwner());
165     _;
166   }
167 
168   /**
169    * @dev Tells the address of the proxy owner
170    * @return the address of the proxy owner
171    */
172   function proxyOwner() public view returns (address) {
173     return upgradeabilityOwner();
174   }
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param newOwner The address to transfer ownership to.
179    */
180   function transferProxyOwnership(address newOwner) public onlyProxyOwner {
181     require(newOwner != address(0));
182     emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
183     setUpgradeabilityOwner(newOwner);
184   }
185 
186   /**
187    * @dev Allows the upgradeability owner to upgrade the current version of the proxy.
188    * @param version representing the version name of the new implementation to be set.
189    * @param implementation representing the address of the new implementation to be set.
190    */
191   function upgradeTo(string version, address implementation) public onlyProxyOwner {
192     _upgradeTo(version, implementation);
193   }
194 
195   /**
196    * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation
197    * to initialize whatever is needed through a low level call.
198    * @param version representing the version name of the new implementation to be set.
199    * @param implementation representing the address of the new implementation to be set.
200    * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
201    * signature of the implementation to be called with the needed payload
202    */
203   function upgradeToAndCall(string version, address implementation, bytes data) payable public onlyProxyOwner {
204     upgradeTo(version, implementation);
205     require(address(this).call.value(msg.value)(data));
206   }
207 }
208 
209 // File: contracts/eternal_storage/EternalStorageProxy.sol
210 
211 /**
212  * @title EternalStorageProxy
213  * @dev This proxy holds the storage of the token contract and delegates every call to the current implementation set.
214  * Besides, it allows to upgrade the token's behaviour towards further implementations, and provides basic
215  * authorization control functionalities
216  */
217 contract EternalStorageProxy is EternalStorage, OwnedUpgradeabilityProxy {}
218 
219 // File: contracts/DetailedToken.sol
220 
221 contract DetailedToken{
222 	string public name;
223 	string public symbol;
224 	uint8 public decimals;
225 }
226 
227 // File: contracts/Ownable.sol
228 
229 /**
230  * @title Ownable
231  * @dev The Ownable contract has an owner address, and provides basic authorization control
232  * functions, this simplifies the implementation of "user permissions".
233  */
234 contract Ownable {
235   address public owner;
236 
237 
238   event OwnershipRenounced(address indexed previousOwner);
239   event OwnershipTransferred(
240     address indexed previousOwner,
241     address indexed newOwner
242   );
243 
244 
245   /**
246    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
247    * account.
248    */
249   constructor() public {
250     owner = msg.sender;
251   }
252 
253   /**
254    * @dev Throws if called by any account other than the owner.
255    */
256   modifier onlyOwner() {
257     require(msg.sender == owner);
258     _;
259   }
260 
261   /**
262    * @dev Allows the current owner to relinquish control of the contract.
263    * @notice Renouncing to ownership will leave the contract without an owner.
264    * It will not be possible to call the functions with the `onlyOwner`
265    * modifier anymore.
266    */
267   function renounceOwnership() public onlyOwner {
268     emit OwnershipRenounced(owner);
269     owner = address(0);
270   }
271 
272   /**
273    * @dev Allows the current owner to transfer control of the contract to a newOwner.
274    * @param _newOwner The address to transfer ownership to.
275    */
276   function transferOwnership(address _newOwner) public onlyOwner {
277     _transferOwnership(_newOwner);
278   }
279 
280   /**
281    * @dev Transfers control of the contract to a newOwner.
282    * @param _newOwner The address to transfer ownership to.
283    */
284   function _transferOwnership(address _newOwner) internal {
285     require(_newOwner != address(0));
286     emit OwnershipTransferred(owner, _newOwner);
287     owner = _newOwner;
288   }
289 }
290 
291 // File: contracts/IcoTokenUpgradeability.sol
292 
293 //import "./MintableToken.sol";
294 
295 
296 
297 contract IcoTokenUpgradeability is EternalStorageProxy,DetailedToken{
298 	    /*define SafeMath library for uint256*/
299 
300     constructor(string _name,string _symbol,uint8 _decimals)
301 			public{
302 				name=_name;
303 				symbol=_symbol;
304 				decimals=_decimals;
305 			}
306 }