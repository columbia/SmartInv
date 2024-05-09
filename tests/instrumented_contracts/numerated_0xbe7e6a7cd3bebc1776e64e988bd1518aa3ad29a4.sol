1 // File: contracts\proxy\Proxy.sol
2 
3 // SPDX-License-Identifier: MIT
4 // https://github.com/OpenZeppelin/openzeppelin-upgrades/blob/master/packages/core/contracts/proxy/Proxy.sol
5 
6 pragma solidity 0.6.9;
7 
8 /**
9  * @title Proxy
10  * @dev Implements delegation of calls to other contracts, with proper
11  * forwarding of return values and bubbling of failures.
12  * It defines a fallback function that delegates all calls to the address
13  * returned by the abstract _implementation() internal function.
14  */
15 abstract contract Proxy {
16   /**
17    * @dev Fallback function.
18    * Implemented entirely in `_fallback`.
19    */
20   fallback () payable external {
21     _fallback();
22   }
23 
24   /**
25    * @dev Receive function.
26    * Implemented entirely in `_fallback`.
27    */
28   receive () payable external {
29     _fallback();
30   }
31 
32   /**
33    * @return The Address of the implementation.
34    */
35   function _implementation() internal virtual view returns (address);
36 
37   /**
38    * @dev Delegates execution to an implementation contract.
39    * This is a low level function that doesn't return to its internal call site.
40    * It will return to the external caller whatever the implementation returns.
41    * @param implementation Address to delegate.
42    */
43   function _delegate(address implementation) internal {
44     assembly {
45       // Copy msg.data. We take full control of memory in this inline assembly
46       // block because it will not return to Solidity code. We overwrite the
47       // Solidity scratch pad at memory position 0.
48       calldatacopy(0, 0, calldatasize())
49 
50       // Call the implementation.
51       // out and outsize are 0 because we don't know the size yet.
52       let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
53 
54       // Copy the returned data.
55       returndatacopy(0, 0, returndatasize())
56 
57       switch result
58       // delegatecall returns 0 on error.
59       case 0 { revert(0, returndatasize()) }
60       default { return(0, returndatasize()) }
61     }
62   }
63 
64   /**
65    * @dev Function that is run as the first thing in the fallback function.
66    * Can be redefined in derived contracts to add functionality.
67    * Redefinitions must call super._willFallback().
68    */
69   function _willFallback() internal virtual {
70   }
71 
72   /**
73    * @dev fallback implementation.
74    * Extracted to enable manual triggering.
75    */
76   function _fallback() internal {
77     _willFallback();
78     _delegate(_implementation());
79   }
80 }
81 
82 // File: @openzeppelin\contracts\utils\Address.sol
83 
84 
85 /**
86  * @dev Collection of functions related to the address type
87  */
88 library Address {
89     /**
90      * @dev Returns true if `account` is a contract.
91      *
92      * [IMPORTANT]
93      * ====
94      * It is unsafe to assume that an address for which this function returns
95      * false is an externally-owned account (EOA) and not a contract.
96      *
97      * Among others, `isContract` will return false for the following
98      * types of addresses:
99      *
100      *  - an externally-owned account
101      *  - a contract in construction
102      *  - an address where a contract will be created
103      *  - an address where a contract lived, but was destroyed
104      * ====
105      */
106     function isContract(address account) internal view returns (bool) {
107         // This method relies on extcodesize, which returns 0 for contracts in
108         // construction, since the code is only stored at the end of the
109         // constructor execution.
110 
111         uint256 size;
112         // solhint-disable-next-line no-inline-assembly
113         assembly { size := extcodesize(account) }
114         return size > 0;
115     }
116 
117     /**
118      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
119      * `recipient`, forwarding all available gas and reverting on errors.
120      *
121      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
122      * of certain opcodes, possibly making contracts go over the 2300 gas limit
123      * imposed by `transfer`, making them unable to receive funds via
124      * `transfer`. {sendValue} removes this limitation.
125      *
126      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
127      *
128      * IMPORTANT: because control is transferred to `recipient`, care must be
129      * taken to not create reentrancy vulnerabilities. Consider using
130      * {ReentrancyGuard} or the
131      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
132      */
133     function sendValue(address payable recipient, uint256 amount) internal {
134         require(address(this).balance >= amount, "Address: insufficient balance");
135 
136         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
137         (bool success, ) = recipient.call{ value: amount }("");
138         require(success, "Address: unable to send value, recipient may have reverted");
139     }
140 
141     /**
142      * @dev Performs a Solidity function call using a low level `call`. A
143      * plain`call` is an unsafe replacement for a function call: use this
144      * function instead.
145      *
146      * If `target` reverts with a revert reason, it is bubbled up by this
147      * function (like regular Solidity function calls).
148      *
149      * Returns the raw returned data. To convert to the expected return value,
150      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
151      *
152      * Requirements:
153      *
154      * - `target` must be a contract.
155      * - calling `target` with `data` must not revert.
156      *
157      * _Available since v3.1._
158      */
159     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
160       return functionCall(target, data, "Address: low-level call failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
165      * `errorMessage` as a fallback revert reason when `target` reverts.
166      *
167      * _Available since v3.1._
168      */
169     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
170         return functionCallWithValue(target, data, 0, errorMessage);
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
175      * but also transferring `value` wei to `target`.
176      *
177      * Requirements:
178      *
179      * - the calling contract must have an ETH balance of at least `value`.
180      * - the called Solidity function must be `payable`.
181      *
182      * _Available since v3.1._
183      */
184     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
185         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
190      * with `errorMessage` as a fallback revert reason when `target` reverts.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
195         require(address(this).balance >= value, "Address: insufficient balance for call");
196         require(isContract(target), "Address: call to non-contract");
197 
198         // solhint-disable-next-line avoid-low-level-calls
199         (bool success, bytes memory returndata) = target.call{ value: value }(data);
200         return _verifyCallResult(success, returndata, errorMessage);
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
205      * but performing a static call.
206      *
207      * _Available since v3.3._
208      */
209     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
210         return functionStaticCall(target, data, "Address: low-level static call failed");
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
215      * but performing a static call.
216      *
217      * _Available since v3.3._
218      */
219     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
220         require(isContract(target), "Address: static call to non-contract");
221 
222         // solhint-disable-next-line avoid-low-level-calls
223         (bool success, bytes memory returndata) = target.staticcall(data);
224         return _verifyCallResult(success, returndata, errorMessage);
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
229      * but performing a delegate call.
230      *
231      * _Available since v3.4._
232      */
233     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
234         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
239      * but performing a delegate call.
240      *
241      * _Available since v3.4._
242      */
243     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
244         require(isContract(target), "Address: delegate call to non-contract");
245 
246         // solhint-disable-next-line avoid-low-level-calls
247         (bool success, bytes memory returndata) = target.delegatecall(data);
248         return _verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
252         if (success) {
253             return returndata;
254         } else {
255             // Look for revert reason and bubble it up if present
256             if (returndata.length > 0) {
257                 // The easiest way to bubble the revert reason is using memory via assembly
258 
259                 // solhint-disable-next-line no-inline-assembly
260                 assembly {
261                     let returndata_size := mload(returndata)
262                     revert(add(32, returndata), returndata_size)
263                 }
264             } else {
265                 revert(errorMessage);
266             }
267         }
268     }
269 }
270 
271 // File: contracts\proxy\UpgradeabilityProxy.sol
272 
273 // https://github.com/OpenZeppelin/openzeppelin-upgrades/blob/master/packages/core/contracts/proxy/UpgradeabilityProxy.sol
274 
275 /**
276  * @title UpgradeabilityProxy
277  * @dev This contract implements a proxy that allows to change the
278  * implementation address to which it will delegate.
279  * Such a change is called an implementation upgrade.
280  */
281 contract UpgradeabilityProxy is Proxy {
282   /**
283    * @dev Contract constructor.
284    * @param _logic Address of the initial implementation.
285    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
286    * It should include the signature and the parameters of the function to be called, as described in
287    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
288    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
289    */
290   constructor(address _logic, bytes memory _data) public payable {
291     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
292     _setImplementation(_logic);
293     if(_data.length > 0) {
294       (bool success,) = _logic.delegatecall(_data);
295       require(success);
296     }
297   }  
298 
299   /**
300    * @dev Emitted when the implementation is upgraded.
301    * @param implementation Address of the new implementation.
302    */
303   event Upgraded(address indexed implementation);
304 
305   /**
306    * @dev Storage slot with the address of the current implementation.
307    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
308    * validated in the constructor.
309    */
310   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
311 
312   /**
313    * @dev Returns the current implementation.
314    * @return impl Address of the current implementation
315    */
316   function _implementation() internal override view returns (address impl) {
317     bytes32 slot = IMPLEMENTATION_SLOT;
318     assembly {
319       impl := sload(slot)
320     }
321   }
322 
323   /**
324    * @dev Upgrades the proxy to a new implementation.
325    * @param newImplementation Address of the new implementation.
326    */
327   function _upgradeTo(address newImplementation) internal {
328     _setImplementation(newImplementation);
329     emit Upgraded(newImplementation);
330   }
331 
332   /**
333    * @dev Sets the implementation address of the proxy.
334    * @param newImplementation Address of the new implementation.
335    */
336   function _setImplementation(address newImplementation) internal {
337     require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
338 
339     bytes32 slot = IMPLEMENTATION_SLOT;
340 
341     assembly {
342       sstore(slot, newImplementation)
343     }
344   }
345 }
346 
347 // File: contracts\proxy\AdminUpgradeabilityProxy.sol
348 
349 // https://github.com/OpenZeppelin/openzeppelin-upgrades/blob/master/packages/core/contracts/proxy/AdminUpgradeabilityProxy.sol
350 
351 /**
352  * @title AdminUpgradeabilityProxy
353  * @dev This contract combines an upgradeability proxy with an authorization
354  * mechanism for administrative tasks.
355  * All external functions in this contract must be guarded by the
356  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
357  * feature proposal that would enable this to be done automatically.
358  */
359 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
360   /**
361    * Contract constructor.
362    * @param _logic address of the initial implementation.
363    * @param _admin Address of the proxy administrator.
364    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
365    * It should include the signature and the parameters of the function to be called, as described in
366    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
367    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
368    */
369   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) public payable {
370     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
371     _setAdmin(_admin);
372   }
373 
374   /**
375    * @dev Emitted when the administration has been transferred.
376    * @param previousAdmin Address of the previous admin.
377    * @param newAdmin Address of the new admin.
378    */
379   event AdminChanged(address previousAdmin, address newAdmin);
380 
381   /**
382    * @dev Storage slot with the admin of the contract.
383    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
384    * validated in the constructor.
385    */
386 
387   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
388 
389   /**
390    * @dev Modifier to check whether the `msg.sender` is the admin.
391    * If it is, it will run the function. Otherwise, it will delegate the call
392    * to the implementation.
393    */
394   modifier ifAdmin() {
395     if (msg.sender == _admin()) {
396       _;
397     } else {
398       _fallback();
399     }
400   }
401 
402   /**
403    * @return The address of the proxy admin.
404    */
405   function admin() external ifAdmin returns (address) {
406     return _admin();
407   }
408 
409   /**
410    * @return The address of the implementation.
411    */
412   function implementation() external ifAdmin returns (address) {
413     return _implementation();
414   }
415 
416   /**
417    * @dev Changes the admin of the proxy.
418    * Only the current admin can call this function.
419    * @param newAdmin Address to transfer proxy administration to.
420    */
421   function changeAdmin(address newAdmin) external ifAdmin {
422     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
423     emit AdminChanged(_admin(), newAdmin);
424     _setAdmin(newAdmin);
425   }
426 
427   /**
428    * @dev Upgrade the backing implementation of the proxy.
429    * Only the admin can call this function.
430    * @param newImplementation Address of the new implementation.
431    */
432   function upgradeTo(address newImplementation) external ifAdmin {
433     _upgradeTo(newImplementation);
434   }
435 
436   /**
437    * @dev Upgrade the backing implementation of the proxy and call a function
438    * on the new implementation.
439    * This is useful to initialize the proxied contract.
440    * @param newImplementation Address of the new implementation.
441    * @param data Data to send as msg.data in the low level call.
442    * It should include the signature and the parameters of the function to be called, as described in
443    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
444    */
445   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
446     _upgradeTo(newImplementation);
447     (bool success,) = newImplementation.delegatecall(data);
448     require(success);
449   }
450 
451   /**
452    * @return adm The admin slot.
453    */
454   function _admin() internal view returns (address adm) {
455     bytes32 slot = ADMIN_SLOT;
456     assembly {
457       adm := sload(slot)
458     }
459   }
460 
461   /**
462    * @dev Sets the address of the proxy admin.
463    * @param newAdmin Address of the new proxy admin.
464    */
465   function _setAdmin(address newAdmin) internal {
466     bytes32 slot = ADMIN_SLOT;
467 
468     assembly {
469       sstore(slot, newAdmin)
470     }
471   }
472 
473   /**
474    * @dev Only fall back when the sender is not the admin.
475    */
476   function _willFallback() internal override virtual {
477     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
478     super._willFallback();
479   }
480 }