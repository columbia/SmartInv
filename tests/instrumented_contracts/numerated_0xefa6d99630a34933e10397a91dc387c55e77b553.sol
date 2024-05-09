1 // File: zos-lib/contracts/upgradeability/Proxy.sol
2 
3 pragma solidity ^0.4.24;
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
71 // File: zos-lib/contracts/utils/Address.sol
72 
73 pragma solidity ^0.4.24;
74 
75 /**
76  * Utility library of inline functions on addresses
77  *
78  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.0.0/contracts/utils/Address.sol
79  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
80  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
81  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
82  */
83 library ZOSLibAddress {
84 
85   /**
86    * Returns whether the target address is a contract
87    * @dev This function will return false if invoked during the constructor of a contract,
88    * as the code is not actually created until after the constructor finishes.
89    * @param account address of the account to check
90    * @return whether the target address is a contract
91    */
92   function isContract(address account) internal view returns (bool) {
93     uint256 size;
94     // XXX Currently there is no better way to check if there is a contract in an address
95     // than to check the size of the code at that address.
96     // See https://ethereum.stackexchange.com/a/14016/36603
97     // for more details about how this works.
98     // TODO Check this again before the Serenity release, because all addresses will be
99     // contracts then.
100     // solium-disable-next-line security/no-inline-assembly
101     assembly { size := extcodesize(account) }
102     return size > 0;
103   }
104 
105 }
106 
107 // File: zos-lib/contracts/upgradeability/UpgradeabilityProxy.sol
108 
109 pragma solidity ^0.4.24;
110 
111 
112 
113 /**
114  * @title UpgradeabilityProxy
115  * @dev This contract implements a proxy that allows to change the
116  * implementation address to which it will delegate.
117  * Such a change is called an implementation upgrade.
118  */
119 contract UpgradeabilityProxy is Proxy {
120   /**
121    * @dev Emitted when the implementation is upgraded.
122    * @param implementation Address of the new implementation.
123    */
124   event Upgraded(address indexed implementation);
125 
126   /**
127    * @dev Storage slot with the address of the current implementation.
128    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
129    * validated in the constructor.
130    */
131   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
132 
133   /**
134    * @dev Contract constructor.
135    * @param _implementation Address of the initial implementation.
136    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
137    * It should include the signature and the parameters of the function to be called, as described in
138    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
139    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
140    */
141   constructor(address _implementation, bytes _data) public payable {
142     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
143     _setImplementation(_implementation);
144     if(_data.length > 0) {
145       require(_implementation.delegatecall(_data));
146     }
147   }
148 
149   /**
150    * @dev Returns the current implementation.
151    * @return Address of the current implementation
152    */
153   function _implementation() internal view returns (address impl) {
154     bytes32 slot = IMPLEMENTATION_SLOT;
155     assembly {
156       impl := sload(slot)
157     }
158   }
159 
160   /**
161    * @dev Upgrades the proxy to a new implementation.
162    * @param newImplementation Address of the new implementation.
163    */
164   function _upgradeTo(address newImplementation) internal {
165     _setImplementation(newImplementation);
166     emit Upgraded(newImplementation);
167   }
168 
169   /**
170    * @dev Sets the implementation address of the proxy.
171    * @param newImplementation Address of the new implementation.
172    */
173   function _setImplementation(address newImplementation) private {
174     require(ZOSLibAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
175 
176     bytes32 slot = IMPLEMENTATION_SLOT;
177 
178     assembly {
179       sstore(slot, newImplementation)
180     }
181   }
182 }
183 
184 // File: zos-lib/contracts/upgradeability/AdminUpgradeabilityProxy.sol
185 
186 pragma solidity ^0.4.24;
187 
188 
189 /**
190  * @title AdminUpgradeabilityProxy
191  * @dev This contract combines an upgradeability proxy with an authorization
192  * mechanism for administrative tasks.
193  * All external functions in this contract must be guarded by the
194  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
195  * feature proposal that would enable this to be done automatically.
196  */
197 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
198   /**
199    * @dev Emitted when the administration has been transferred.
200    * @param previousAdmin Address of the previous admin.
201    * @param newAdmin Address of the new admin.
202    */
203   event AdminChanged(address previousAdmin, address newAdmin);
204 
205   /**
206    * @dev Storage slot with the admin of the contract.
207    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
208    * validated in the constructor.
209    */
210   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
211 
212   /**
213    * @dev Modifier to check whether the `msg.sender` is the admin.
214    * If it is, it will run the function. Otherwise, it will delegate the call
215    * to the implementation.
216    */
217   modifier ifAdmin() {
218     if (msg.sender == _admin()) {
219       _;
220     } else {
221       _fallback();
222     }
223   }
224 
225   /**
226    * Contract constructor.
227    * @param _implementation address of the initial implementation.
228    * @param _admin Address of the proxy administrator.
229    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
230    * It should include the signature and the parameters of the function to be called, as described in
231    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
232    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
233    */
234   constructor(address _implementation, address _admin, bytes _data) UpgradeabilityProxy(_implementation, _data) public payable {
235     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
236 
237     _setAdmin(_admin);
238   }
239 
240   /**
241    * @return The address of the proxy admin.
242    */
243   function admin() external view ifAdmin returns (address) {
244     return _admin();
245   }
246 
247   /**
248    * @return The address of the implementation.
249    */
250   function implementation() external view ifAdmin returns (address) {
251     return _implementation();
252   }
253 
254   /**
255    * @dev Changes the admin of the proxy.
256    * Only the current admin can call this function.
257    * @param newAdmin Address to transfer proxy administration to.
258    */
259   function changeAdmin(address newAdmin) external ifAdmin {
260     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
261     emit AdminChanged(_admin(), newAdmin);
262     _setAdmin(newAdmin);
263   }
264 
265   /**
266    * @dev Upgrade the backing implementation of the proxy.
267    * Only the admin can call this function.
268    * @param newImplementation Address of the new implementation.
269    */
270   function upgradeTo(address newImplementation) external ifAdmin {
271     _upgradeTo(newImplementation);
272   }
273 
274   /**
275    * @dev Upgrade the backing implementation of the proxy and call a function
276    * on the new implementation.
277    * This is useful to initialize the proxied contract.
278    * @param newImplementation Address of the new implementation.
279    * @param data Data to send as msg.data in the low level call.
280    * It should include the signature and the parameters of the function to be called, as described in
281    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
282    */
283   function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
284     _upgradeTo(newImplementation);
285     require(newImplementation.delegatecall(data));
286   }
287 
288   /**
289    * @return The admin slot.
290    */
291   function _admin() internal view returns (address adm) {
292     bytes32 slot = ADMIN_SLOT;
293     assembly {
294       adm := sload(slot)
295     }
296   }
297 
298   /**
299    * @dev Sets the address of the proxy admin.
300    * @param newAdmin Address of the new proxy admin.
301    */
302   function _setAdmin(address newAdmin) internal {
303     bytes32 slot = ADMIN_SLOT;
304 
305     assembly {
306       sstore(slot, newAdmin)
307     }
308   }
309 
310   /**
311    * @dev Only fall back when the sender is not the admin.
312    */
313   function _willFallback() internal {
314     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
315     super._willFallback();
316   }
317 }
318 
319 
320 
321 pragma solidity ^0.4.24;
322 
323 
324 contract EURXProxy is AdminUpgradeabilityProxy {
325   constructor(address _implementation, address _admin, bytes _data) public AdminUpgradeabilityProxy(_implementation, _admin, _data) {
326     
327     }
328 }