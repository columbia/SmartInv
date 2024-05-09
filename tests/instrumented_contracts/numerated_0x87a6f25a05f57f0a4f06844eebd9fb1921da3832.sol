1 pragma solidity ^0.8.0;
2 
3 
4 // SPDX-License-Identifier: MIT
5 /**
6  * @dev This is the interface that {BeaconProxy} expects of its beacon.
7  */
8 interface IBeacon {
9     /**
10      * @dev Must return an address that can be used as a delegate call target.
11      *
12      * {BeaconProxy} will check that this address is a contract.
13      */
14     function implementation() external view returns (address);
15 }
16 
17 /**
18  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
19  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
20  * be specified by overriding the virtual {_implementation} function.
21  *
22  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
23  * different contract through the {_delegate} function.
24  *
25  * The success and return data of the delegated call will be returned back to the caller of the proxy.
26  */
27 abstract contract Proxy {
28     /**
29      * @dev Delegates the current call to `implementation`.
30      *
31      * This function does not return to its internall call site, it will return directly to the external caller.
32      */
33     function _delegate(address implementation) internal virtual {
34         assembly {
35             // Copy msg.data. We take full control of memory in this inline assembly
36             // block because it will not return to Solidity code. We overwrite the
37             // Solidity scratch pad at memory position 0.
38             calldatacopy(0, 0, calldatasize())
39 
40             // Call the implementation.
41             // out and outsize are 0 because we don't know the size yet.
42             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
43 
44             // Copy the returned data.
45             returndatacopy(0, 0, returndatasize())
46 
47             switch result
48             // delegatecall returns 0 on error.
49             case 0 {
50                 revert(0, returndatasize())
51             }
52             default {
53                 return(0, returndatasize())
54             }
55         }
56     }
57 
58     /**
59      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
60      * and {_fallback} should delegate.
61      */
62     function _implementation() internal view virtual returns (address);
63 
64     /**
65      * @dev Delegates the current call to the address returned by `_implementation()`.
66      *
67      * This function does not return to its internall call site, it will return directly to the external caller.
68      */
69     function _fallback() internal virtual {
70         _beforeFallback();
71         _delegate(_implementation());
72     }
73 
74     /**
75      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
76      * function in the contract matches the call data.
77      */
78     fallback() external payable virtual {
79         _fallback();
80     }
81 
82     /**
83      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
84      * is empty.
85      */
86     receive() external payable virtual {
87         _fallback();
88     }
89 
90     /**
91      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
92      * call, or as part of the Solidity `fallback` or `receive` functions.
93      *
94      * If overriden should call `super._beforeFallback()`.
95      */
96     function _beforeFallback() internal virtual {}
97 }
98 
99 /**
100  * @dev Collection of functions related to the address type
101  */
102 library Address {
103     /**
104      * @dev Returns true if `account` is a contract.
105      *
106      * [IMPORTANT]
107      * ====
108      * It is unsafe to assume that an address for which this function returns
109      * false is an externally-owned account (EOA) and not a contract.
110      *
111      * Among others, `isContract` will return false for the following
112      * types of addresses:
113      *
114      *  - an externally-owned account
115      *  - a contract in construction
116      *  - an address where a contract will be created
117      *  - an address where a contract lived, but was destroyed
118      * ====
119      */
120     function isContract(address account) internal view returns (bool) {
121         // This method relies on extcodesize, which returns 0 for contracts in
122         // construction, since the code is only stored at the end of the
123         // constructor execution.
124 
125         uint256 size;
126         assembly {
127             size := extcodesize(account)
128         }
129         return size > 0;
130     }
131 
132     /**
133      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
134      * `recipient`, forwarding all available gas and reverting on errors.
135      *
136      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
137      * of certain opcodes, possibly making contracts go over the 2300 gas limit
138      * imposed by `transfer`, making them unable to receive funds via
139      * `transfer`. {sendValue} removes this limitation.
140      *
141      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
142      *
143      * IMPORTANT: because control is transferred to `recipient`, care must be
144      * taken to not create reentrancy vulnerabilities. Consider using
145      * {ReentrancyGuard} or the
146      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
147      */
148     function sendValue(address payable recipient, uint256 amount) internal {
149         require(address(this).balance >= amount, "Address: insufficient balance");
150 
151         (bool success, ) = recipient.call{value: amount}("");
152         require(success, "Address: unable to send value, recipient may have reverted");
153     }
154 
155     /**
156      * @dev Performs a Solidity function call using a low level `call`. A
157      * plain `call` is an unsafe replacement for a function call: use this
158      * function instead.
159      *
160      * If `target` reverts with a revert reason, it is bubbled up by this
161      * function (like regular Solidity function calls).
162      *
163      * Returns the raw returned data. To convert to the expected return value,
164      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
165      *
166      * Requirements:
167      *
168      * - `target` must be a contract.
169      * - calling `target` with `data` must not revert.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionCall(target, data, "Address: low-level call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
179      * `errorMessage` as a fallback revert reason when `target` reverts.
180      *
181      * _Available since v3.1._
182      */
183     function functionCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, 0, errorMessage);
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
193      * but also transferring `value` wei to `target`.
194      *
195      * Requirements:
196      *
197      * - the calling contract must have an ETH balance of at least `value`.
198      * - the called Solidity function must be `payable`.
199      *
200      * _Available since v3.1._
201      */
202     function functionCallWithValue(
203         address target,
204         bytes memory data,
205         uint256 value
206     ) internal returns (bytes memory) {
207         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
212      * with `errorMessage` as a fallback revert reason when `target` reverts.
213      *
214      * _Available since v3.1._
215      */
216     function functionCallWithValue(
217         address target,
218         bytes memory data,
219         uint256 value,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         require(address(this).balance >= value, "Address: insufficient balance for call");
223         require(isContract(target), "Address: call to non-contract");
224 
225         (bool success, bytes memory returndata) = target.call{value: value}(data);
226         return verifyCallResult(success, returndata, errorMessage);
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
231      * but performing a static call.
232      *
233      * _Available since v3.3._
234      */
235     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
236         return functionStaticCall(target, data, "Address: low-level static call failed");
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
241      * but performing a static call.
242      *
243      * _Available since v3.3._
244      */
245     function functionStaticCall(
246         address target,
247         bytes memory data,
248         string memory errorMessage
249     ) internal view returns (bytes memory) {
250         require(isContract(target), "Address: static call to non-contract");
251 
252         (bool success, bytes memory returndata) = target.staticcall(data);
253         return verifyCallResult(success, returndata, errorMessage);
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
258      * but performing a delegate call.
259      *
260      * _Available since v3.4._
261      */
262     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
263         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
268      * but performing a delegate call.
269      *
270      * _Available since v3.4._
271      */
272     function functionDelegateCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         require(isContract(target), "Address: delegate call to non-contract");
278 
279         (bool success, bytes memory returndata) = target.delegatecall(data);
280         return verifyCallResult(success, returndata, errorMessage);
281     }
282 
283     /**
284      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
285      * revert reason using the provided one.
286      *
287      * _Available since v4.3._
288      */
289     function verifyCallResult(
290         bool success,
291         bytes memory returndata,
292         string memory errorMessage
293     ) internal pure returns (bytes memory) {
294         if (success) {
295             return returndata;
296         } else {
297             // Look for revert reason and bubble it up if present
298             if (returndata.length > 0) {
299                 // The easiest way to bubble the revert reason is using memory via assembly
300 
301                 assembly {
302                     let returndata_size := mload(returndata)
303                     revert(add(32, returndata), returndata_size)
304                 }
305             } else {
306                 revert(errorMessage);
307             }
308         }
309     }
310 }
311 
312 /**
313  * @dev Library for reading and writing primitive types to specific storage slots.
314  *
315  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
316  * This library helps with reading and writing to such slots without the need for inline assembly.
317  *
318  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
319  *
320  * Example usage to set ERC1967 implementation slot:
321  * ```
322  * contract ERC1967 {
323  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
324  *
325  *     function _getImplementation() internal view returns (address) {
326  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
327  *     }
328  *
329  *     function _setImplementation(address newImplementation) internal {
330  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
331  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
332  *     }
333  * }
334  * ```
335  *
336  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
337  */
338 library StorageSlot {
339     struct AddressSlot {
340         address value;
341     }
342 
343     struct BooleanSlot {
344         bool value;
345     }
346 
347     struct Bytes32Slot {
348         bytes32 value;
349     }
350 
351     struct Uint256Slot {
352         uint256 value;
353     }
354 
355     /**
356      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
357      */
358     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
359         assembly {
360             r.slot := slot
361         }
362     }
363 
364     /**
365      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
366      */
367     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
368         assembly {
369             r.slot := slot
370         }
371     }
372 
373     /**
374      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
375      */
376     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
377         assembly {
378             r.slot := slot
379         }
380     }
381 
382     /**
383      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
384      */
385     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
386         assembly {
387             r.slot := slot
388         }
389     }
390 }
391 
392 /**
393  * @dev This abstract contract provides getters and event emitting update functions for
394  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
395  *
396  * _Available since v4.1._
397  *
398  * @custom:oz-upgrades-unsafe-allow delegatecall
399  */
400 abstract contract ERC1967Upgrade {
401     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
402     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
403 
404     /**
405      * @dev Storage slot with the address of the current implementation.
406      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
407      * validated in the constructor.
408      */
409     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
410 
411     /**
412      * @dev Emitted when the implementation is upgraded.
413      */
414     event Upgraded(address indexed implementation);
415 
416     /**
417      * @dev Returns the current implementation address.
418      */
419     function _getImplementation() internal view returns (address) {
420         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
421     }
422 
423     /**
424      * @dev Stores a new address in the EIP1967 implementation slot.
425      */
426     function _setImplementation(address newImplementation) private {
427         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
428         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
429     }
430 
431     /**
432      * @dev Perform implementation upgrade
433      *
434      * Emits an {Upgraded} event.
435      */
436     function _upgradeTo(address newImplementation) internal {
437         _setImplementation(newImplementation);
438         emit Upgraded(newImplementation);
439     }
440 
441     /**
442      * @dev Perform implementation upgrade with additional setup call.
443      *
444      * Emits an {Upgraded} event.
445      */
446     function _upgradeToAndCall(
447         address newImplementation,
448         bytes memory data,
449         bool forceCall
450     ) internal {
451         _upgradeTo(newImplementation);
452         if (data.length > 0 || forceCall) {
453             Address.functionDelegateCall(newImplementation, data);
454         }
455     }
456 
457     /**
458      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
459      *
460      * Emits an {Upgraded} event.
461      */
462     function _upgradeToAndCallSecure(
463         address newImplementation,
464         bytes memory data,
465         bool forceCall
466     ) internal {
467         address oldImplementation = _getImplementation();
468 
469         // Initial upgrade and setup call
470         _setImplementation(newImplementation);
471         if (data.length > 0 || forceCall) {
472             Address.functionDelegateCall(newImplementation, data);
473         }
474 
475         // Perform rollback test if not already in progress
476         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
477         if (!rollbackTesting.value) {
478             // Trigger rollback using upgradeTo from the new implementation
479             rollbackTesting.value = true;
480             Address.functionDelegateCall(
481                 newImplementation,
482                 abi.encodeWithSignature("upgradeTo(address)", oldImplementation)
483             );
484             rollbackTesting.value = false;
485             // Check rollback was effective
486             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
487             // Finally reset to the new implementation and log the upgrade
488             _upgradeTo(newImplementation);
489         }
490     }
491 
492     /**
493      * @dev Storage slot with the admin of the contract.
494      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
495      * validated in the constructor.
496      */
497     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
498 
499     /**
500      * @dev Emitted when the admin account has changed.
501      */
502     event AdminChanged(address previousAdmin, address newAdmin);
503 
504     /**
505      * @dev Returns the current admin.
506      */
507     function _getAdmin() internal view returns (address) {
508         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
509     }
510 
511     /**
512      * @dev Stores a new address in the EIP1967 admin slot.
513      */
514     function _setAdmin(address newAdmin) private {
515         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
516         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
517     }
518 
519     /**
520      * @dev Changes the admin of the proxy.
521      *
522      * Emits an {AdminChanged} event.
523      */
524     function _changeAdmin(address newAdmin) internal {
525         emit AdminChanged(_getAdmin(), newAdmin);
526         _setAdmin(newAdmin);
527     }
528 
529     /**
530      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
531      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
532      */
533     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
534 
535     /**
536      * @dev Emitted when the beacon is upgraded.
537      */
538     event BeaconUpgraded(address indexed beacon);
539 
540     /**
541      * @dev Returns the current beacon.
542      */
543     function _getBeacon() internal view returns (address) {
544         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
545     }
546 
547     /**
548      * @dev Stores a new beacon in the EIP1967 beacon slot.
549      */
550     function _setBeacon(address newBeacon) private {
551         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
552         require(
553             Address.isContract(IBeacon(newBeacon).implementation()),
554             "ERC1967: beacon implementation is not a contract"
555         );
556         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
557     }
558 
559     /**
560      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
561      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
562      *
563      * Emits a {BeaconUpgraded} event.
564      */
565     function _upgradeBeaconToAndCall(
566         address newBeacon,
567         bytes memory data,
568         bool forceCall
569     ) internal {
570         _setBeacon(newBeacon);
571         emit BeaconUpgraded(newBeacon);
572         if (data.length > 0 || forceCall) {
573             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
574         }
575     }
576 }
577 
578 /**
579  * @dev This contract implements a proxy that gets the implementation address for each call from a {UpgradeableBeacon}.
580  *
581  * The beacon address is stored in storage slot `uint256(keccak256('eip1967.proxy.beacon')) - 1`, so that it doesn't
582  * conflict with the storage layout of the implementation behind the proxy.
583  *
584  * _Available since v3.4._
585  */
586 contract BeaconProxy is Proxy, ERC1967Upgrade {
587     /**
588      * @dev Initializes the proxy with `beacon`.
589      *
590      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon. This
591      * will typically be an encoded function call, and allows initializating the storage of the proxy like a Solidity
592      * constructor.
593      *
594      * Requirements:
595      *
596      * - `beacon` must be a contract with the interface {IBeacon}.
597      */
598     constructor(address beacon, bytes memory data) payable {
599         assert(_BEACON_SLOT == bytes32(uint256(keccak256("eip1967.proxy.beacon")) - 1));
600         _upgradeBeaconToAndCall(beacon, data, false);
601     }
602 
603     /**
604      * @dev Returns the current beacon address.
605      */
606     function _beacon() internal view virtual returns (address) {
607         return _getBeacon();
608     }
609 
610     /**
611      * @dev Returns the current implementation address of the associated beacon.
612      */
613     function _implementation() internal view virtual override returns (address) {
614         return IBeacon(_getBeacon()).implementation();
615     }
616 
617     /**
618      * @dev Changes the proxy to use a new beacon. Deprecated: see {_upgradeBeaconToAndCall}.
619      *
620      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon.
621      *
622      * Requirements:
623      *
624      * - `beacon` must be a contract.
625      * - The implementation returned by `beacon` must be a contract.
626      */
627     function _setBeacon(address beacon, bytes memory data) internal virtual {
628         _upgradeBeaconToAndCall(beacon, data, false);
629     }
630 }
631 
632 // contracts/Structs.sol
633 contract BridgeNFT is BeaconProxy {
634     constructor(address beacon, bytes memory data) BeaconProxy(beacon, data) {
635 
636     }
637 }