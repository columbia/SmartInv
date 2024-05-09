1 // File: zos-lib/contracts/upgradeability/Proxy.sol
2 
3 pragma solidity ^0.5.0;
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
73 pragma solidity ^0.5.0;
74 
75 /**
76  * Utility library of inline functions on addresses
77  *
78  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
79  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
80  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
81  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
82  */
83 library ZOSLibAddress {
84     /**
85      * Returns whether the target address is a contract
86      * @dev This function will return false if invoked during the constructor of a contract,
87      * as the code is not actually created until after the constructor finishes.
88      * @param account address of the account to check
89      * @return whether the target address is a contract
90      */
91     function isContract(address account) internal view returns (bool) {
92         uint256 size;
93         // XXX Currently there is no better way to check if there is a contract in an address
94         // than to check the size of the code at that address.
95         // See https://ethereum.stackexchange.com/a/14016/36603
96         // for more details about how this works.
97         // TODO Check this again before the Serenity release, because all addresses will be
98         // contracts then.
99         // solhint-disable-next-line no-inline-assembly
100         assembly { size := extcodesize(account) }
101         return size > 0;
102     }
103 }
104 
105 // File: zos-lib/contracts/upgradeability/BaseUpgradeabilityProxy.sol
106 
107 pragma solidity ^0.5.0;
108 
109 
110 
111 /**
112  * @title BaseUpgradeabilityProxy
113  * @dev This contract implements a proxy that allows to change the
114  * implementation address to which it will delegate.
115  * Such a change is called an implementation upgrade.
116  */
117 contract BaseUpgradeabilityProxy is Proxy {
118   /**
119    * @dev Emitted when the implementation is upgraded.
120    * @param implementation Address of the new implementation.
121    */
122   event Upgraded(address indexed implementation);
123 
124   /**
125    * @dev Storage slot with the address of the current implementation.
126    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
127    * validated in the constructor.
128    */
129   bytes32 internal constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
130 
131   /**
132    * @dev Returns the current implementation.
133    * @return Address of the current implementation
134    */
135   function _implementation() internal view returns (address impl) {
136     bytes32 slot = IMPLEMENTATION_SLOT;
137     assembly {
138       impl := sload(slot)
139     }
140   }
141 
142   /**
143    * @dev Upgrades the proxy to a new implementation.
144    * @param newImplementation Address of the new implementation.
145    */
146   function _upgradeTo(address newImplementation) internal {
147     _setImplementation(newImplementation);
148     emit Upgraded(newImplementation);
149   }
150 
151   /**
152    * @dev Sets the implementation address of the proxy.
153    * @param newImplementation Address of the new implementation.
154    */
155   function _setImplementation(address newImplementation) internal {
156     require(ZOSLibAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
157 
158     bytes32 slot = IMPLEMENTATION_SLOT;
159 
160     assembly {
161       sstore(slot, newImplementation)
162     }
163   }
164 }
165 
166 // File: zos-lib/contracts/upgradeability/UpgradeabilityProxy.sol
167 
168 pragma solidity ^0.5.0;
169 
170 
171 /**
172  * @title UpgradeabilityProxy
173  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
174  * implementation and init data.
175  */
176 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
177   /**
178    * @dev Contract constructor.
179    * @param _logic Address of the initial implementation.
180    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
181    * It should include the signature and the parameters of the function to be called, as described in
182    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
183    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
184    */
185   constructor(address _logic, bytes memory _data) public payable {
186     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
187     _setImplementation(_logic);
188     if(_data.length > 0) {
189       (bool success,) = _logic.delegatecall(_data);
190       require(success);
191     }
192   }  
193 }
194 
195 // File: zos-lib/contracts/upgradeability/BaseAdminUpgradeabilityProxy.sol
196 
197 pragma solidity ^0.5.0;
198 
199 
200 /**
201  * @title BaseAdminUpgradeabilityProxy
202  * @dev This contract combines an upgradeability proxy with an authorization
203  * mechanism for administrative tasks.
204  * All external functions in this contract must be guarded by the
205  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
206  * feature proposal that would enable this to be done automatically.
207  */
208 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
209   /**
210    * @dev Emitted when the administration has been transferred.
211    * @param previousAdmin Address of the previous admin.
212    * @param newAdmin Address of the new admin.
213    */
214   event AdminChanged(address previousAdmin, address newAdmin);
215 
216   /**
217    * @dev Storage slot with the admin of the contract.
218    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
219    * validated in the constructor.
220    */
221   bytes32 internal constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
222 
223   /**
224    * @dev Modifier to check whether the `msg.sender` is the admin.
225    * If it is, it will run the function. Otherwise, it will delegate the call
226    * to the implementation.
227    */
228   modifier ifAdmin() {
229     if (msg.sender == _admin()) {
230       _;
231     } else {
232       _fallback();
233     }
234   }
235 
236   /**
237    * @return The address of the proxy admin.
238    */
239   function admin() external ifAdmin returns (address) {
240     return _admin();
241   }
242 
243   /**
244    * @return The address of the implementation.
245    */
246   function implementation() external ifAdmin returns (address) {
247     return _implementation();
248   }
249 
250   /**
251    * @dev Changes the admin of the proxy.
252    * Only the current admin can call this function.
253    * @param newAdmin Address to transfer proxy administration to.
254    */
255   function changeAdmin(address newAdmin) external ifAdmin {
256     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
257     emit AdminChanged(_admin(), newAdmin);
258     _setAdmin(newAdmin);
259   }
260 
261   /**
262    * @dev Upgrade the backing implementation of the proxy.
263    * Only the admin can call this function.
264    * @param newImplementation Address of the new implementation.
265    */
266   function upgradeTo(address newImplementation) external ifAdmin {
267     _upgradeTo(newImplementation);
268   }
269 
270   /**
271    * @dev Upgrade the backing implementation of the proxy and call a function
272    * on the new implementation.
273    * This is useful to initialize the proxied contract.
274    * @param newImplementation Address of the new implementation.
275    * @param data Data to send as msg.data in the low level call.
276    * It should include the signature and the parameters of the function to be called, as described in
277    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
278    */
279   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
280     _upgradeTo(newImplementation);
281     (bool success,) = newImplementation.delegatecall(data);
282     require(success);
283   }
284 
285   /**
286    * @return The admin slot.
287    */
288   function _admin() internal view returns (address adm) {
289     bytes32 slot = ADMIN_SLOT;
290     assembly {
291       adm := sload(slot)
292     }
293   }
294 
295   /**
296    * @dev Sets the address of the proxy admin.
297    * @param newAdmin Address of the new proxy admin.
298    */
299   function _setAdmin(address newAdmin) internal {
300     bytes32 slot = ADMIN_SLOT;
301 
302     assembly {
303       sstore(slot, newAdmin)
304     }
305   }
306 
307   /**
308    * @dev Only fall back when the sender is not the admin.
309    */
310   function _willFallback() internal {
311     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
312     super._willFallback();
313   }
314 }
315 
316 // File: zos-lib/contracts/upgradeability/AdminUpgradeabilityProxy.sol
317 
318 pragma solidity ^0.5.0;
319 
320 
321 /**
322  * @title AdminUpgradeabilityProxy
323  * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for 
324  * initializing the implementation, admin, and init data.
325  */
326 contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
327   /**
328    * Contract constructor.
329    * @param _logic address of the initial implementation.
330    * @param _admin Address of the proxy administrator.
331    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
332    * It should include the signature and the parameters of the function to be called, as described in
333    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
334    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
335    */
336   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
337     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
338     _setAdmin(_admin);
339   }
340 }
341 
342 // File: contracts/edge/EdgeTokenProxy.sol
343 
344 /**
345  * @title EdgeTokenProxy
346  * @author Connor Howe <connor.howe@sygnum.com>
347  * @dev Proxies EdgeToken calls and enables EdgeToken upgradability.
348 */
349 pragma solidity 0.5.0;
350 
351 
352 
353 contract EdgeTokenProxy is AdminUpgradeabilityProxy {
354     constructor(address implementation, address proxyOwnerAddr, bytes memory data) public AdminUpgradeabilityProxy(implementation, proxyOwnerAddr, data) {
355     }
356 }