1 // SPDX-License-Identifier: GPL-3.0
2 /**
3  *Submitted for verification at polygonscan.com on 2022-12-07
4 */
5 
6 // File: .deps/github/OpenZeppelin/openzeppelin-contracts/contracts/utils/StorageSlot.sol
7 
8 
9 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Library for reading and writing primitive types to specific storage slots.
15  *
16  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
17  * This library helps with reading and writing to such slots without the need for inline assembly.
18  *
19  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
20  *
21  * Example usage to set ERC1967 implementation slot:
22  * ```
23  * contract ERC1967 {
24  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
25  *
26  *     function _getImplementation() internal view returns (address) {
27  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
28  *     }
29  *
30  *     function _setImplementation(address newImplementation) internal {
31  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
32  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
33  *     }
34  * }
35  * ```
36  *
37  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
38  */
39 library StorageSlot {
40     struct AddressSlot {
41         address value;
42     }
43 
44     struct BooleanSlot {
45         bool value;
46     }
47 
48     struct Bytes32Slot {
49         bytes32 value;
50     }
51 
52     struct Uint256Slot {
53         uint256 value;
54     }
55 
56     /**
57      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
58      */
59     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
60         /// @solidity memory-safe-assembly
61         assembly {
62             r.slot := slot
63         }
64     }
65 
66     /**
67      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
68      */
69     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
70         /// @solidity memory-safe-assembly
71         assembly {
72             r.slot := slot
73         }
74     }
75 
76     /**
77      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
78      */
79     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
80         /// @solidity memory-safe-assembly
81         assembly {
82             r.slot := slot
83         }
84     }
85 
86     /**
87      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
88      */
89     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
90         /// @solidity memory-safe-assembly
91         assembly {
92             r.slot := slot
93         }
94     }
95 }
96 
97 // File: .deps/github/OpenZeppelin/openzeppelin-contracts/contracts/utils/Address.sol
98 
99 
100 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
101 
102 pragma solidity ^0.8.1;
103 
104 /**
105  * @dev Collection of functions related to the address type
106  */
107 library Address {
108     /**
109      * @dev Returns true if `account` is a contract.
110      *
111      * [IMPORTANT]
112      * ====
113      * It is unsafe to assume that an address for which this function returns
114      * false is an externally-owned account (EOA) and not a contract.
115      *
116      * Among others, `isContract` will return false for the following
117      * types of addresses:
118      *
119      *  - an externally-owned account
120      *  - a contract in construction
121      *  - an address where a contract will be created
122      *  - an address where a contract lived, but was destroyed
123      * ====
124      *
125      * [IMPORTANT]
126      * ====
127      * You shouldn't rely on `isContract` to protect against flash loan attacks!
128      *
129      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
130      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
131      * constructor.
132      * ====
133      */
134     function isContract(address account) internal view returns (bool) {
135         // This method relies on extcodesize/address.code.length, which returns 0
136         // for contracts in construction, since the code is only stored at the end
137         // of the constructor execution.
138 
139         return account.code.length > 0;
140     }
141 
142     /**
143      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
144      * `recipient`, forwarding all available gas and reverting on errors.
145      *
146      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
147      * of certain opcodes, possibly making contracts go over the 2300 gas limit
148      * imposed by `transfer`, making them unable to receive funds via
149      * `transfer`. {sendValue} removes this limitation.
150      *
151      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
152      *
153      * IMPORTANT: because control is transferred to `recipient`, care must be
154      * taken to not create reentrancy vulnerabilities. Consider using
155      * {ReentrancyGuard} or the
156      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
157      */
158     function sendValue(address payable recipient, uint256 amount) internal {
159         require(address(this).balance >= amount, "Address: insufficient balance");
160 
161         (bool success, ) = recipient.call{value: amount}("");
162         require(success, "Address: unable to send value, recipient may have reverted");
163     }
164 
165     /**
166      * @dev Performs a Solidity function call using a low level `call`. A
167      * plain `call` is an unsafe replacement for a function call: use this
168      * function instead.
169      *
170      * If `target` reverts with a revert reason, it is bubbled up by this
171      * function (like regular Solidity function calls).
172      *
173      * Returns the raw returned data. To convert to the expected return value,
174      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
175      *
176      * Requirements:
177      *
178      * - `target` must be a contract.
179      * - calling `target` with `data` must not revert.
180      *
181      * _Available since v3.1._
182      */
183     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
184         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
189      * `errorMessage` as a fallback revert reason when `target` reverts.
190      *
191      * _Available since v3.1._
192      */
193     function functionCall(
194         address target,
195         bytes memory data,
196         string memory errorMessage
197     ) internal returns (bytes memory) {
198         return functionCallWithValue(target, data, 0, errorMessage);
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
203      * but also transferring `value` wei to `target`.
204      *
205      * Requirements:
206      *
207      * - the calling contract must have an ETH balance of at least `value`.
208      * - the called Solidity function must be `payable`.
209      *
210      * _Available since v3.1._
211      */
212     function functionCallWithValue(
213         address target,
214         bytes memory data,
215         uint256 value
216     ) internal returns (bytes memory) {
217         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
222      * with `errorMessage` as a fallback revert reason when `target` reverts.
223      *
224      * _Available since v3.1._
225      */
226     function functionCallWithValue(
227         address target,
228         bytes memory data,
229         uint256 value,
230         string memory errorMessage
231     ) internal returns (bytes memory) {
232         require(address(this).balance >= value, "Address: insufficient balance for call");
233         (bool success, bytes memory returndata) = target.call{value: value}(data);
234         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
239      * but performing a static call.
240      *
241      * _Available since v3.3._
242      */
243     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
244         return functionStaticCall(target, data, "Address: low-level static call failed");
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
249      * but performing a static call.
250      *
251      * _Available since v3.3._
252      */
253     function functionStaticCall(
254         address target,
255         bytes memory data,
256         string memory errorMessage
257     ) internal view returns (bytes memory) {
258         (bool success, bytes memory returndata) = target.staticcall(data);
259         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
264      * but performing a delegate call.
265      *
266      * _Available since v3.4._
267      */
268     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
269         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
274      * but performing a delegate call.
275      *
276      * _Available since v3.4._
277      */
278     function functionDelegateCall(
279         address target,
280         bytes memory data,
281         string memory errorMessage
282     ) internal returns (bytes memory) {
283         (bool success, bytes memory returndata) = target.delegatecall(data);
284         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
285     }
286 
287     /**
288      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
289      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
290      *
291      * _Available since v4.8._
292      */
293     function verifyCallResultFromTarget(
294         address target,
295         bool success,
296         bytes memory returndata,
297         string memory errorMessage
298     ) internal view returns (bytes memory) {
299         if (success) {
300             if (returndata.length == 0) {
301                 // only check isContract if the call was successful and the return data is empty
302                 // otherwise we already know that it was a contract
303                 require(isContract(target), "Address: call to non-contract");
304             }
305             return returndata;
306         } else {
307             _revert(returndata, errorMessage);
308         }
309     }
310 
311     /**
312      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
313      * revert reason or using the provided one.
314      *
315      * _Available since v4.3._
316      */
317     function verifyCallResult(
318         bool success,
319         bytes memory returndata,
320         string memory errorMessage
321     ) internal pure returns (bytes memory) {
322         if (success) {
323             return returndata;
324         } else {
325             _revert(returndata, errorMessage);
326         }
327     }
328 
329     function _revert(bytes memory returndata, string memory errorMessage) private pure {
330         // Look for revert reason and bubble it up if present
331         if (returndata.length > 0) {
332             // The easiest way to bubble the revert reason is using memory via assembly
333             /// @solidity memory-safe-assembly
334             assembly {
335                 let returndata_size := mload(returndata)
336                 revert(add(32, returndata), returndata_size)
337             }
338         } else {
339             revert(errorMessage);
340         }
341     }
342 }
343 
344 // File: .deps/github/OpenZeppelin/openzeppelin-contracts/contracts/interfaces/draft-IERC1822.sol
345 
346 
347 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
348 
349 pragma solidity ^0.8.0;
350 
351 /**
352  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
353  * proxy whose upgrades are fully controlled by the current implementation.
354  */
355 interface IERC1822Proxiable {
356     /**
357      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
358      * address.
359      *
360      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
361      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
362      * function revert if invoked through a proxy.
363      */
364     function proxiableUUID() external view returns (bytes32);
365 }
366 
367 // File: .deps/github/OpenZeppelin/openzeppelin-contracts/contracts/proxy/beacon/IBeacon.sol
368 
369 
370 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
371 
372 pragma solidity ^0.8.0;
373 
374 /**
375  * @dev This is the interface that {BeaconProxy} expects of its beacon.
376  */
377 interface IBeacon {
378     /**
379      * @dev Must return an address that can be used as a delegate call target.
380      *
381      * {BeaconProxy} will check that this address is a contract.
382      */
383     function implementation() external view returns (address);
384 }
385 
386 // File: .deps/github/OpenZeppelin/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Upgrade.sol
387 
388 
389 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
390 
391 pragma solidity ^0.8.2;
392 
393 
394 
395 
396 
397 /**
398  * @dev This abstract contract provides getters and event emitting update functions for
399  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
400  *
401  * _Available since v4.1._
402  *
403  * @custom:oz-upgrades-unsafe-allow delegatecall
404  */
405 abstract contract ERC1967Upgrade {
406     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
407     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
408 
409     /**
410      * @dev Storage slot with the address of the current implementation.
411      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
412      * validated in the constructor.
413      */
414     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
415 
416     /**
417      * @dev Emitted when the implementation is upgraded.
418      */
419     event Upgraded(address indexed implementation);
420 
421     /**
422      * @dev Returns the current implementation address.
423      */
424     function _getImplementation() internal view returns (address) {
425         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
426     }
427 
428     /**
429      * @dev Stores a new address in the EIP1967 implementation slot.
430      */
431     function _setImplementation(address newImplementation) private {
432         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
433         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
434     }
435 
436     /**
437      * @dev Perform implementation upgrade
438      *
439      * Emits an {Upgraded} event.
440      */
441     function _upgradeTo(address newImplementation) internal {
442         _setImplementation(newImplementation);
443         emit Upgraded(newImplementation);
444     }
445 
446     /**
447      * @dev Perform implementation upgrade with additional setup call.
448      *
449      * Emits an {Upgraded} event.
450      */
451     function _upgradeToAndCall(
452         address newImplementation,
453         bytes memory data,
454         bool forceCall
455     ) internal {
456         _upgradeTo(newImplementation);
457         if (data.length > 0 || forceCall) {
458             Address.functionDelegateCall(newImplementation, data);
459         }
460     }
461 
462     /**
463      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
464      *
465      * Emits an {Upgraded} event.
466      */
467     function _upgradeToAndCallUUPS(
468         address newImplementation,
469         bytes memory data,
470         bool forceCall
471     ) internal {
472         // Upgrades from old implementations will perform a rollback test. This test requires the new
473         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
474         // this special case will break upgrade paths from old UUPS implementation to new ones.
475         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
476             _setImplementation(newImplementation);
477         } else {
478             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
479                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
480             } catch {
481                 revert("ERC1967Upgrade: new implementation is not UUPS");
482             }
483             _upgradeToAndCall(newImplementation, data, forceCall);
484         }
485     }
486 
487     /**
488      * @dev Storage slot with the admin of the contract.
489      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
490      * validated in the constructor.
491      */
492     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
493 
494     /**
495      * @dev Emitted when the admin account has changed.
496      */
497     event AdminChanged(address previousAdmin, address newAdmin);
498 
499     /**
500      * @dev Returns the current admin.
501      */
502     function _getAdmin() internal view returns (address) {
503         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
504     }
505 
506     /**
507      * @dev Stores a new address in the EIP1967 admin slot.
508      */
509     function _setAdmin(address newAdmin) private {
510         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
511         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
512     }
513 
514     /**
515      * @dev Changes the admin of the proxy.
516      *
517      * Emits an {AdminChanged} event.
518      */
519     function _changeAdmin(address newAdmin) internal {
520         emit AdminChanged(_getAdmin(), newAdmin);
521         _setAdmin(newAdmin);
522     }
523 
524     /**
525      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
526      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
527      */
528     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
529 
530     /**
531      * @dev Emitted when the beacon is upgraded.
532      */
533     event BeaconUpgraded(address indexed beacon);
534 
535     /**
536      * @dev Returns the current beacon.
537      */
538     function _getBeacon() internal view returns (address) {
539         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
540     }
541 
542     /**
543      * @dev Stores a new beacon in the EIP1967 beacon slot.
544      */
545     function _setBeacon(address newBeacon) private {
546         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
547         require(
548             Address.isContract(IBeacon(newBeacon).implementation()),
549             "ERC1967: beacon implementation is not a contract"
550         );
551         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
552     }
553 
554     /**
555      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
556      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
557      *
558      * Emits a {BeaconUpgraded} event.
559      */
560     function _upgradeBeaconToAndCall(
561         address newBeacon,
562         bytes memory data,
563         bool forceCall
564     ) internal {
565         _setBeacon(newBeacon);
566         emit BeaconUpgraded(newBeacon);
567         if (data.length > 0 || forceCall) {
568             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
569         }
570     }
571 }
572 
573 // File: .deps/github/OpenZeppelin/openzeppelin-contracts/contracts/proxy/Proxy.sol
574 
575 
576 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
577 
578 pragma solidity ^0.8.0;
579 
580 /**
581  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
582  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
583  * be specified by overriding the virtual {_implementation} function.
584  *
585  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
586  * different contract through the {_delegate} function.
587  *
588  * The success and return data of the delegated call will be returned back to the caller of the proxy.
589  */
590 abstract contract Proxy {
591     /**
592      * @dev Delegates the current call to `implementation`.
593      *
594      * This function does not return to its internal call site, it will return directly to the external caller.
595      */
596     function _delegate(address implementation) internal virtual {
597         assembly {
598             // Copy msg.data. We take full control of memory in this inline assembly
599             // block because it will not return to Solidity code. We overwrite the
600             // Solidity scratch pad at memory position 0.
601             calldatacopy(0, 0, calldatasize())
602 
603             // Call the implementation.
604             // out and outsize are 0 because we don't know the size yet.
605             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
606 
607             // Copy the returned data.
608             returndatacopy(0, 0, returndatasize())
609 
610             switch result
611             // delegatecall returns 0 on error.
612             case 0 {
613                 revert(0, returndatasize())
614             }
615             default {
616                 return(0, returndatasize())
617             }
618         }
619     }
620 
621     /**
622      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
623      * and {_fallback} should delegate.
624      */
625     function _implementation() internal view virtual returns (address);
626 
627     /**
628      * @dev Delegates the current call to the address returned by `_implementation()`.
629      *
630      * This function does not return to its internal call site, it will return directly to the external caller.
631      */
632     function _fallback() internal virtual {
633         _beforeFallback();
634         _delegate(_implementation());
635     }
636 
637     /**
638      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
639      * function in the contract matches the call data.
640      */
641     fallback() external payable virtual {
642         _fallback();
643     }
644 
645     /**
646      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
647      * is empty.
648      */
649     receive() external payable virtual {
650         _fallback();
651     }
652 
653     /**
654      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
655      * call, or as part of the Solidity `fallback` or `receive` functions.
656      *
657      * If overridden should call `super._beforeFallback()`.
658      */
659     function _beforeFallback() internal virtual {}
660 }
661 
662 // File: .deps/github/OpenZeppelin/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol
663 //
664 
665 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
666 
667 pragma solidity ^0.8.0;
668 
669 
670 
671 /**
672  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
673  * implementation address that can be changed. This address is stored in storage in the location specified by
674  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
675  * implementation behind the proxy.
676  */
677 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
678     /**
679      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
680      *
681      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
682      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
683      */
684     constructor(address _logic, bytes memory _data) payable {
685         _upgradeToAndCall(_logic, _data, false);
686     }
687 
688     /**
689      * @dev Returns the current implementation address.
690      */
691     function _implementation() internal view virtual override returns (address impl) {
692         return ERC1967Upgrade._getImplementation();
693     }
694 }