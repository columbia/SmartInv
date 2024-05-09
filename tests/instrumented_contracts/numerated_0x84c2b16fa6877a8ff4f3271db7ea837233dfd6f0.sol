1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-27
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.8;
8 
9 
10 // 
11 /**
12  * @title Proxy
13  * @dev Implements delegation of calls to other contracts, with proper
14  * forwarding of return values and bubbling of failures.
15  * It defines a fallback function that delegates all calls to the address
16  * returned by the abstract _implementation() internal function.
17  */
18 abstract contract Proxy {
19   /**
20    * @dev Fallback function.
21    * Implemented entirely in `_fallback`.
22    */
23   fallback () payable external {
24     _fallback();
25   }
26 
27   /**
28    * @dev Receive function.
29    * Implemented entirely in `_fallback`.
30    */
31   receive () payable external {
32     // _fallback();
33   }
34 
35   /**
36    * @return The Address of the implementation.
37    */
38   function _implementation() internal virtual view returns (address);
39 
40   /**
41    * @dev Delegates execution to an implementation contract.
42    * This is a low level function that doesn't return to its internal call site.
43    * It will return to the external caller whatever the implementation returns.
44    * @param implementation Address to delegate.
45    */
46   function _delegate(address implementation) internal {
47     assembly {
48       // Copy msg.data. We take full control of memory in this inline assembly
49       // block because it will not return to Solidity code. We overwrite the
50       // Solidity scratch pad at memory position 0.
51       calldatacopy(0, 0, calldatasize())
52 
53       // Call the implementation.
54       // out and outsize are 0 because we don't know the size yet.
55       let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
56 
57       // Copy the returned data.
58       returndatacopy(0, 0, returndatasize())
59 
60       switch result
61       // delegatecall returns 0 on error.
62       case 0 { revert(0, returndatasize()) }
63       default { return(0, returndatasize()) }
64     }
65   }
66 
67   /**
68    * @dev Function that is run as the first thing in the fallback function.
69    * Can be redefined in derived contracts to add functionality.
70    * Redefinitions must call super._willFallback().
71    */
72   function _willFallback() internal virtual {
73   }
74 
75   /**
76    * @dev fallback implementation.
77    * Extracted to enable manual triggering.
78    */
79   function _fallback() internal {
80     _willFallback();
81     _delegate(_implementation());
82   }
83 }
84 
85 // 
86 /**
87  * @dev Collection of functions related to the address type
88  */
89 library Address {
90     /**
91      * @dev Returns true if `account` is a contract.
92      *
93      * [IMPORTANT]
94      * ====
95      * It is unsafe to assume that an address for which this function returns
96      * false is an externally-owned account (EOA) and not a contract.
97      *
98      * Among others, `isContract` will return false for the following
99      * types of addresses:
100      *
101      *  - an externally-owned account
102      *  - a contract in construction
103      *  - an address where a contract will be created
104      *  - an address where a contract lived, but was destroyed
105      * ====
106      */
107     function isContract(address account) internal view returns (bool) {
108         // This method relies on extcodesize, which returns 0 for contracts in
109         // construction, since the code is only stored at the end of the
110         // constructor execution.
111 
112         uint256 size;
113         // solhint-disable-next-line no-inline-assembly
114         assembly { size := extcodesize(account) }
115         return size > 0;
116     }
117 
118     /**
119      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
120      * `recipient`, forwarding all available gas and reverting on errors.
121      *
122      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
123      * of certain opcodes, possibly making contracts go over the 2300 gas limit
124      * imposed by `transfer`, making them unable to receive funds via
125      * `transfer`. {sendValue} removes this limitation.
126      *
127      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
128      *
129      * IMPORTANT: because control is transferred to `recipient`, care must be
130      * taken to not create reentrancy vulnerabilities. Consider using
131      * {ReentrancyGuard} or the
132      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
133      */
134     function sendValue(address payable recipient, uint256 amount) internal {
135         require(address(this).balance >= amount, "Address: insufficient balance");
136 
137         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
138         (bool success, ) = recipient.call{ value: amount }("");
139         require(success, "Address: unable to send value, recipient may have reverted");
140     }
141 
142     /**
143      * @dev Performs a Solidity function call using a low level `call`. A
144      * plain`call` is an unsafe replacement for a function call: use this
145      * function instead.
146      *
147      * If `target` reverts with a revert reason, it is bubbled up by this
148      * function (like regular Solidity function calls).
149      *
150      * Returns the raw returned data. To convert to the expected return value,
151      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
152      *
153      * Requirements:
154      *
155      * - `target` must be a contract.
156      * - calling `target` with `data` must not revert.
157      *
158      * _Available since v3.1._
159      */
160     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
161       return functionCall(target, data, "Address: low-level call failed");
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
166      * `errorMessage` as a fallback revert reason when `target` reverts.
167      *
168      * _Available since v3.1._
169      */
170     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
171         return functionCallWithValue(target, data, 0, errorMessage);
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
176      * but also transferring `value` wei to `target`.
177      *
178      * Requirements:
179      *
180      * - the calling contract must have an ETH balance of at least `value`.
181      * - the called Solidity function must be `payable`.
182      *
183      * _Available since v3.1._
184      */
185     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
191      * with `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
196         require(address(this).balance >= value, "Address: insufficient balance for call");
197         require(isContract(target), "Address: call to non-contract");
198 
199         // solhint-disable-next-line avoid-low-level-calls
200         (bool success, bytes memory returndata) = target.call{ value: value }(data);
201         return _verifyCallResult(success, returndata, errorMessage);
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
206      * but performing a static call.
207      *
208      * _Available since v3.3._
209      */
210     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
211         return functionStaticCall(target, data, "Address: low-level static call failed");
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
216      * but performing a static call.
217      *
218      * _Available since v3.3._
219      */
220     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
221         require(isContract(target), "Address: static call to non-contract");
222 
223         // solhint-disable-next-line avoid-low-level-calls
224         (bool success, bytes memory returndata) = target.staticcall(data);
225         return _verifyCallResult(success, returndata, errorMessage);
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
230      * but performing a delegate call.
231      *
232      * _Available since v3.4._
233      */
234     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
235         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
240      * but performing a delegate call.
241      *
242      * _Available since v3.4._
243      */
244     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
245         require(isContract(target), "Address: delegate call to non-contract");
246 
247         // solhint-disable-next-line avoid-low-level-calls
248         (bool success, bytes memory returndata) = target.delegatecall(data);
249         return _verifyCallResult(success, returndata, errorMessage);
250     }
251 
252     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
253         if (success) {
254             return returndata;
255         } else {
256             // Look for revert reason and bubble it up if present
257             if (returndata.length > 0) {
258                 // The easiest way to bubble the revert reason is using memory via assembly
259 
260                 // solhint-disable-next-line no-inline-assembly
261                 assembly {
262                     let returndata_size := mload(returndata)
263                     revert(add(32, returndata), returndata_size)
264                 }
265             } else {
266                 revert(errorMessage);
267             }
268         }
269     }
270 }
271 
272 // 
273 /**
274  * @title UpgradeabilityProxy
275  * @dev This contract implements a proxy that allows to change the
276  * implementation address to which it will delegate.
277  * Such a change is called an implementation upgrade.
278  */
279 contract UpgradeabilityProxy is Proxy {
280   /**
281    * @dev Contract constructor.
282    * @param _logic Address of the initial implementation.
283    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
284    * It should include the signature and the parameters of the function to be called, as described in
285    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
286    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
287    */
288   constructor(address _logic, bytes memory _data) payable {
289     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
290     _setImplementation(_logic);
291     if(_data.length > 0) {
292       (bool success,) = _logic.delegatecall(_data);
293       require(success);
294     }
295   }  
296 
297   /**
298    * @dev Emitted when the implementation is upgraded.
299    * @param implementation Address of the new implementation.
300    */
301   event Upgraded(address indexed implementation);
302 
303   /**
304    * @dev Storage slot with the address of the current implementation.
305    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
306    * validated in the constructor.
307    */
308   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
309 
310   /**
311    * @dev Returns the current implementation.
312    * @return impl Address of the current implementation
313    */
314   function _implementation() internal override view returns (address impl) {
315     bytes32 slot = IMPLEMENTATION_SLOT;
316     assembly {
317       impl := sload(slot)
318     }
319   }
320 
321   /**
322    * @dev Upgrades the proxy to a new implementation.
323    * @param newImplementation Address of the new implementation.
324    */
325   function _upgradeTo(address newImplementation) internal {
326     _setImplementation(newImplementation);
327     emit Upgraded(newImplementation);
328   }
329 
330   /**
331    * @dev Sets the implementation address of the proxy.
332    * @param newImplementation Address of the new implementation.
333    */
334   function _setImplementation(address newImplementation) internal {
335     require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
336 
337     bytes32 slot = IMPLEMENTATION_SLOT;
338 
339     assembly {
340       sstore(slot, newImplementation)
341     }
342   }
343 }
344 
345 // 
346 /**
347  * @title AdminUpgradeabilityProxy
348  * @dev This contract combines an upgradeability proxy with an authorization
349  * mechanism for administrative tasks.
350  * All external functions in this contract must be guarded by the
351  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
352  * feature proposal that would enable this to be done automatically.
353  */
354 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
355   /**
356    * Contract constructor.
357    * @param _logic address of the initial implementation.
358    * @param _admin Address of the proxy administrator.
359    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
360    * It should include the signature and the parameters of the function to be called, as described in
361    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
362    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
363    */
364   constructor(address _logic, address _admin, bytes memory _data) UpgradeabilityProxy(_logic, _data) payable {
365     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
366     _setAdmin(_admin);
367   }
368 
369   /**
370    * @dev Emitted when the administration has been transferred.
371    * @param previousAdmin Address of the previous admin.
372    * @param newAdmin Address of the new admin.
373    */
374   event AdminChanged(address previousAdmin, address newAdmin);
375 
376   /**
377    * @dev Storage slot with the admin of the contract.
378    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
379    * validated in the constructor.
380    */
381 
382   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
383 
384   /**
385    * @dev Modifier to check whether the `msg.sender` is the admin.
386    * If it is, it will run the function. Otherwise, it will delegate the call
387    * to the implementation.
388    */
389   modifier ifAdmin() {
390     if (msg.sender == _admin()) {
391       _;
392     } else {
393       _fallback();
394     }
395   }
396 
397   /**
398    * @return The address of the proxy admin.
399    */
400   function admin() external ifAdmin returns (address) {
401     return _admin();
402   }
403 
404   /**
405    * @return The address of the implementation.
406    */
407   function implementation() external ifAdmin returns (address) {
408     return _implementation();
409   }
410 
411   /**
412    * @dev Changes the admin of the proxy.
413    * Only the current admin can call this function.
414    * @param newAdmin Address to transfer proxy administration to.
415    */
416   function changeAdmin(address newAdmin) external ifAdmin {
417     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
418     emit AdminChanged(_admin(), newAdmin);
419     _setAdmin(newAdmin);
420   }
421 
422   /**
423    * @dev Upgrade the backing implementation of the proxy.
424    * Only the admin can call this function.
425    * @param newImplementation Address of the new implementation.
426    */
427   function upgradeTo(address newImplementation) external ifAdmin {
428     _upgradeTo(newImplementation);
429   }
430 
431   /**
432    * @dev Upgrade the backing implementation of the proxy and call a function
433    * on the new implementation.
434    * This is useful to initialize the proxied contract.
435    * @param newImplementation Address of the new implementation.
436    * @param data Data to send as msg.data in the low level call.
437    * It should include the signature and the parameters of the function to be called, as described in
438    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
439    */
440   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
441     _upgradeTo(newImplementation);
442     (bool success,) = newImplementation.delegatecall(data);
443     require(success);
444   }
445 
446   /**
447    * @return adm The admin slot.
448    */
449   function _admin() internal view returns (address adm) {
450     bytes32 slot = ADMIN_SLOT;
451     assembly {
452       adm := sload(slot)
453     }
454   }
455 
456   /**
457    * @dev Sets the address of the proxy admin.
458    * @param newAdmin Address of the new proxy admin.
459    */
460   function _setAdmin(address newAdmin) internal {
461     bytes32 slot = ADMIN_SLOT;
462 
463     assembly {
464       sstore(slot, newAdmin)
465     }
466   }
467 
468   /**
469    * @dev Only fall back when the sender is not the admin.
470    */
471   function _willFallback() internal override virtual {
472     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
473     super._willFallback();
474   }
475 }