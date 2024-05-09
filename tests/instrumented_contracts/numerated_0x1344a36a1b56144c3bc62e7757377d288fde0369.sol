1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.6;
4 
5 
6 
7 // Part: OpenZeppelin/openzeppelin-contracts@3.4.2-solc-0.7/Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: value }(data);
124         return _verifyCallResult(success, returndata, errorMessage);
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
129      * but performing a static call.
130      *
131      * _Available since v3.3._
132      */
133     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
134         return functionStaticCall(target, data, "Address: low-level static call failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
144         require(isContract(target), "Address: static call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.staticcall(data);
148         return _verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
153      * but performing a delegate call.
154      *
155      * _Available since v3.4._
156      */
157     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
163      * but performing a delegate call.
164      *
165      * _Available since v3.4._
166      */
167     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
168         require(isContract(target), "Address: delegate call to non-contract");
169 
170         // solhint-disable-next-line avoid-low-level-calls
171         (bool success, bytes memory returndata) = target.delegatecall(data);
172         return _verifyCallResult(success, returndata, errorMessage);
173     }
174 
175     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
176         if (success) {
177             return returndata;
178         } else {
179             // Look for revert reason and bubble it up if present
180             if (returndata.length > 0) {
181                 // The easiest way to bubble the revert reason is using memory via assembly
182 
183                 // solhint-disable-next-line no-inline-assembly
184                 assembly {
185                     let returndata_size := mload(returndata)
186                     revert(add(32, returndata), returndata_size)
187                 }
188             } else {
189                 revert(errorMessage);
190             }
191         }
192     }
193 }
194 
195 // Part: Proxy
196 
197 /**
198  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
199  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
200  * be specified by overriding the virtual {_implementation} function.
201  *
202  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
203  * different contract through the {_delegate} function.
204  *
205  * The success and return data of the delegated call will be returned back to the caller of the proxy.
206  */
207 abstract contract Proxy {
208     /**
209      * @dev Delegates the current call to `implementation`.
210      *
211      * This function does not return to its internal call site, it will return directly to the external caller.
212      */
213     function _delegate(address implementation) internal virtual {
214         assembly {
215             // Copy msg.data. We take full control of memory in this inline assembly
216             // block because it will not return to Solidity code. We overwrite the
217             // Solidity scratch pad at memory position 0.
218             calldatacopy(0, 0, calldatasize())
219 
220             // Call the implementation.
221             // out and outsize are 0 because we don't know the size yet.
222             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
223 
224             // Copy the returned data.
225             returndatacopy(0, 0, returndatasize())
226 
227             switch result
228             // delegatecall returns 0 on error.
229             case 0 {
230                 revert(0, returndatasize())
231             }
232             default {
233                 return(0, returndatasize())
234             }
235         }
236     }
237 
238     /**
239      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
240      * and {_fallback} should delegate.
241      */
242     function _implementation() internal view virtual returns (address);
243 
244     /**
245      * @dev Delegates the current call to the address returned by `_implementation()`.
246      *
247      * This function does not return to its internall call site, it will return directly to the external caller.
248      */
249     function _fallback() internal virtual {
250         _beforeFallback();
251         _delegate(_implementation());
252     }
253 
254     /**
255      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
256      * function in the contract matches the call data.
257      */
258     fallback() external payable virtual {
259         _fallback();
260     }
261 
262     /**
263      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
264      * is empty.
265      */
266     receive() external payable virtual {
267         _fallback();
268     }
269 
270     /**
271      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
272      * call, or as part of the Solidity `fallback` or `receive` functions.
273      *
274      * If overriden should call `super._beforeFallback()`.
275      */
276     function _beforeFallback() internal virtual {}
277 }
278 
279 // Part: StorageSlot
280 
281 /**
282  * @dev Library for reading and writing primitive types to specific storage slots.
283  *
284  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
285  * This library helps with reading and writing to such slots without the need for inline assembly.
286  *
287  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
288  *
289  * Example usage to set ERC1967 implementation slot:
290  * ```
291  * contract ERC1967 {
292  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
293  *
294  *     function _getImplementation() internal view returns (address) {
295  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
296  *     }
297  *
298  *     function _setImplementation(address newImplementation) internal {
299  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
300  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
301  *     }
302  * }
303  * ```
304  *
305  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
306  */
307 library StorageSlot {
308     struct AddressSlot {
309         address value;
310     }
311 
312     struct BooleanSlot {
313         bool value;
314     }
315 
316     struct Bytes32Slot {
317         bytes32 value;
318     }
319 
320     struct Uint256Slot {
321         uint256 value;
322     }
323 
324     /**
325      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
326      */
327     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
328         assembly {
329             r.slot := slot
330         }
331     }
332 
333     /**
334      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
335      */
336     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
337         assembly {
338             r.slot := slot
339         }
340     }
341 
342     /**
343      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
344      */
345     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
346         assembly {
347             r.slot := slot
348         }
349     }
350 
351     /**
352      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
353      */
354     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
355         assembly {
356             r.slot := slot
357         }
358     }
359 }
360 
361 // Part: ERC1967Upgrade
362 
363 /**
364  * @dev This abstract contract provides getters and event emitting update functions for
365  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
366  *
367  * _Available since v4.1._
368  *
369  */
370 abstract contract ERC1967Upgrade {
371     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
372     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
373 
374     /**
375      * @dev Storage slot with the address of the current implementation.
376      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
377      * validated in the constructor.
378      */
379     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
380 
381     /**
382      * @dev Emitted when the implementation is upgraded.
383      */
384     event Upgraded(address indexed implementation);
385 
386     /**
387      * @dev Returns the current implementation address.
388      */
389     function _getImplementation() internal view returns (address) {
390         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
391     }
392 
393     /**
394      * @dev Stores a new address in the EIP1967 implementation slot.
395      */
396     function _setImplementation(address newImplementation) private {
397         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
398         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
399     }
400 
401     /**
402      * @dev Perform implementation upgrade
403      *
404      * Emits an {Upgraded} event.
405      */
406     function _upgradeTo(address newImplementation) internal {
407         _setImplementation(newImplementation);
408         emit Upgraded(newImplementation);
409     }
410 
411     /**
412      * @dev Perform implementation upgrade with additional setup call.
413      *
414      * Emits an {Upgraded} event.
415      */
416     function _upgradeToAndCall(
417         address newImplementation,
418         bytes memory data,
419         bool forceCall
420     ) internal {
421         _upgradeTo(newImplementation);
422         if (data.length > 0 || forceCall) {
423             Address.functionDelegateCall(newImplementation, data);
424         }
425     }
426 
427     /**
428      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
429      *
430      * Emits an {Upgraded} event.
431      */
432     function _upgradeToAndCallSecure(
433         address newImplementation,
434         bytes memory data,
435         bool forceCall
436     ) internal {
437         address oldImplementation = _getImplementation();
438 
439         // Initial upgrade and setup call
440         _setImplementation(newImplementation);
441         if (data.length > 0 || forceCall) {
442             Address.functionDelegateCall(newImplementation, data);
443         }
444 
445         // Perform rollback test if not already in progress
446         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
447         if (!rollbackTesting.value) {
448             // Trigger rollback using upgradeTo from the new implementation
449             rollbackTesting.value = true;
450             Address.functionDelegateCall(
451                 newImplementation,
452                 abi.encodeWithSignature("upgradeTo(address)", oldImplementation)
453             );
454             rollbackTesting.value = false;
455             // Check rollback was effective
456             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
457             // Finally reset to the new implementation and log the upgrade
458             _upgradeTo(newImplementation);
459         }
460     }
461 
462 }
463 
464 // Part: ERC1967Proxy
465 
466 /**
467  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
468  * implementation address that can be changed. This address is stored in storage in the location specified by
469  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
470  * implementation behind the proxy.
471  */
472 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
473     /**
474      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
475      *
476      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
477      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
478      */
479     constructor(address _logic, bytes memory _data) payable {
480         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
481         _upgradeToAndCall(_logic, _data, false);
482     }
483 
484     /**
485      * @dev Returns the current implementation address.
486      */
487     function _implementation() internal view virtual override returns (address impl) {
488         return ERC1967Upgrade._getImplementation();
489     }
490 }
491 
492 // File: nProxy.sol
493 
494 contract nProxy is ERC1967Proxy {
495     constructor(
496         address _logic,
497         bytes memory _data
498     ) ERC1967Proxy(_logic, _data) {}
499 
500     receive() external payable override {
501         // Allow ETH transfers to succeed
502     }
503 
504     function getImplementation() external view returns (address) {
505         return _getImplementation();
506     }
507 }
