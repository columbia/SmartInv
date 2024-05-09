1 pragma solidity ^0.4.24;
2 
3 // File: contracts/upgradeability/Proxy.sol
4 
5 /**
6  * @title Proxy
7  * @dev Implements delegation of calls to other contracts, with proper
8  * forwarding of return values and bubbling of failures.
9  * It defines a fallback function that delegates all calls to the address
10  * returned by the abstract _implementation() internal function.
11  */
12 contract Proxy {
13   /**
14    * @dev Fallback function.
15    * Implemented entirely in `_fallback`.
16    */
17   function () payable external {
18     _fallback();
19   }
20 
21   /**
22    * @return The Address of the implementation.
23    */
24   function _implementation() internal view returns (address);
25 
26   /**
27    * @dev Delegates execution to an implementation contract.
28    * This is a low level function that doesn't return to its internal call site.
29    * It will return to the external caller whatever the implementation returns.
30    * @param implementation Address to delegate.
31    */
32   function _delegate(address implementation) internal {
33     assembly {
34       // Copy msg.data. We take full control of memory in this inline assembly
35       // block because it will not return to Solidity code. We overwrite the
36       // Solidity scratch pad at memory position 0.
37       calldatacopy(0, 0, calldatasize)
38 
39       // Call the implementation.
40       // out and outsize are 0 because we don't know the size yet.
41       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
42 
43       // Copy the returned data.
44       returndatacopy(0, 0, returndatasize)
45 
46       switch result
47       // delegatecall returns 0 on error.
48       case 0 { revert(0, returndatasize) }
49       default { return(0, returndatasize) }
50     }
51   }
52 
53   /**
54    * @dev Function that is run as the first thing in the fallback function.
55    * Can be redefined in derived contracts to add functionality.
56    * Redefinitions must call super._willFallback().
57    */
58   function _willFallback() internal {
59   }
60 
61   /**
62    * @dev fallback implementation.
63    * Extracted to enable manual triggering.
64    */
65   function _fallback() internal {
66     _willFallback();
67     _delegate(_implementation());
68   }
69 }
70 
71 // File: openzeppelin-solidity/contracts/AddressUtils.sol
72 
73 /**
74  * Utility library of inline functions on addresses
75  */
76 library AddressUtils {
77 
78   /**
79    * Returns whether the target address is a contract
80    * @dev This function will return false if invoked during the constructor of a contract,
81    *  as the code is not actually created until after the constructor finishes.
82    * @param addr address to check
83    * @return whether the target address is a contract
84    */
85   function isContract(address addr) internal view returns (bool) {
86     uint256 size;
87     // XXX Currently there is no better way to check if there is a contract in an address
88     // than to check the size of the code at that address.
89     // See https://ethereum.stackexchange.com/a/14016/36603
90     // for more details about how this works.
91     // TODO Check this again before the Serenity release, because all addresses will be
92     // contracts then.
93     // solium-disable-next-line security/no-inline-assembly
94     assembly { size := extcodesize(addr) }
95     return size > 0;
96   }
97 
98 }
99 
100 // File: contracts/upgradeability/UpgradeabilityProxy.sol
101 
102 /**
103  * @title UpgradeabilityProxy
104  * @dev This contract implements a proxy that allows to change the
105  * implementation address to which it will delegate.
106  * Such a change is called an implementation upgrade.
107  */
108 contract UpgradeabilityProxy is Proxy {
109   /**
110    * @dev Emitted when the implementation is upgraded.
111    * @param implementation Address of the new implementation.
112    */
113   event Upgraded(address indexed implementation);
114 
115   /**
116    * @dev Storage slot with the address of the current implementation.
117    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
118    * validated in the constructor.
119    */
120   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
121 
122   /**
123    * @dev Contract constructor.
124    * @param _implementation Address of the initial implementation.
125    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
126    * It should include the signature and the parameters of the function to be called, as described in
127    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
128    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
129    */
130   constructor(address _implementation, bytes _data) public payable {
131     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
132     _setImplementation(_implementation);
133     if(_data.length > 0) {
134       require(_implementation.delegatecall(_data));
135     }
136   }
137 
138   /**
139    * @dev Returns the current implementation.
140    * @return Address of the current implementation
141    */
142   function _implementation() internal view returns (address impl) {
143     bytes32 slot = IMPLEMENTATION_SLOT;
144     assembly {
145       impl := sload(slot)
146     }
147   }
148 
149   /**
150    * @dev Upgrades the proxy to a new implementation.
151    * @param newImplementation Address of the new implementation.
152    */
153   function _upgradeTo(address newImplementation) internal {
154     _setImplementation(newImplementation);
155     emit Upgraded(newImplementation);
156   }
157 
158   /**
159    * @dev Sets the implementation address of the proxy.
160    * @param newImplementation Address of the new implementation.
161    */
162   function _setImplementation(address newImplementation) private {
163     require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
164 
165     bytes32 slot = IMPLEMENTATION_SLOT;
166 
167     assembly {
168       sstore(slot, newImplementation)
169     }
170   }
171 }
172 
173 // File: contracts/upgradeability/AdminUpgradeabilityProxy.sol
174 
175 /**
176  * @title AdminUpgradeabilityProxy
177  * @dev This contract combines an upgradeability proxy with an authorization
178  * mechanism for administrative tasks.
179  * All external functions in this contract must be guarded by the
180  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
181  * feature proposal that would enable this to be done automatically.
182  */
183 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
184   /**
185    * @dev Emitted when the administration has been transferred.
186    * @param previousAdmin Address of the previous admin.
187    * @param newAdmin Address of the new admin.
188    */
189   event AdminChanged(address previousAdmin, address newAdmin);
190 
191   /**
192    * @dev Storage slot with the admin of the contract.
193    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
194    * validated in the constructor.
195    */
196   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
197 
198   /**
199    * @dev Modifier to check whether the `msg.sender` is the admin.
200    * If it is, it will run the function. Otherwise, it will delegate the call
201    * to the implementation.
202    */
203   modifier ifAdmin() {
204     if (msg.sender == _admin()) {
205       _;
206     } else {
207       _fallback();
208     }
209   }
210 
211   /**
212    * Contract constructor.
213    * It sets the `msg.sender` as the proxy administrator.
214    * @param _implementation address of the initial implementation.
215    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
216    * It should include the signature and the parameters of the function to be called, as described in
217    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
218    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
219    */
220   constructor(address _implementation, bytes _data) UpgradeabilityProxy(_implementation, _data) public payable {
221     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
222 
223     _setAdmin(msg.sender);
224   }
225 
226   /**
227    * @return The address of the proxy admin.
228    */
229   function admin() external view ifAdmin returns (address) {
230     return _admin();
231   }
232 
233   /**
234    * @return The address of the implementation.
235    */
236   function implementation() external view ifAdmin returns (address) {
237     return _implementation();
238   }
239 
240   /**
241    * @dev Changes the admin of the proxy.
242    * Only the current admin can call this function.
243    * @param newAdmin Address to transfer proxy administration to.
244    */
245   function changeAdmin(address newAdmin) external ifAdmin {
246     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
247     emit AdminChanged(_admin(), newAdmin);
248     _setAdmin(newAdmin);
249   }
250 
251   /**
252    * @dev Upgrade the backing implementation of the proxy.
253    * Only the admin can call this function.
254    * @param newImplementation Address of the new implementation.
255    */
256   function upgradeTo(address newImplementation) external ifAdmin {
257     _upgradeTo(newImplementation);
258   }
259 
260   /**
261    * @dev Upgrade the backing implementation of the proxy and call a function
262    * on the new implementation.
263    * This is useful to initialize the proxied contract.
264    * @param newImplementation Address of the new implementation.
265    * @param data Data to send as msg.data in the low level call.
266    * It should include the signature and the parameters of the function to be called, as described in
267    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
268    */
269   function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
270     _upgradeTo(newImplementation);
271     require(newImplementation.delegatecall(data));
272   }
273 
274   /**
275    * @return The admin slot.
276    */
277   function _admin() internal view returns (address adm) {
278     bytes32 slot = ADMIN_SLOT;
279     assembly {
280       adm := sload(slot)
281     }
282   }
283 
284   /**
285    * @dev Sets the address of the proxy admin.
286    * @param newAdmin Address of the new proxy admin.
287    */
288   function _setAdmin(address newAdmin) internal {
289     bytes32 slot = ADMIN_SLOT;
290 
291     assembly {
292       sstore(slot, newAdmin)
293     }
294   }
295 
296   /**
297    * @dev Only fall back when the sender is not the admin.
298    */
299   function _willFallback() internal {
300     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
301     super._willFallback();
302   }
303 }