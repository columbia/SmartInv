1 // SPDX-License-Identifier: MIT
2 // File: node_modules/@openzeppelin/contracts/utils/StorageSlot.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.9.0) (utils/StorageSlot.sol)
6 // This file was procedurally generated from scripts/generate/templates/StorageSlot.js.
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Library for reading and writing primitive types to specific storage slots.
12  *
13  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
14  * This library helps with reading and writing to such slots without the need for inline assembly.
15  *
16  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
17  *
18  * Example usage to set ERC1967 implementation slot:
19  * ```solidity
20  * contract ERC1967 {
21  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
22  *
23  *     function _getImplementation() internal view returns (address) {
24  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
25  *     }
26  *
27  *     function _setImplementation(address newImplementation) internal {
28  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
29  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
30  *     }
31  * }
32  * ```
33  *
34  * _Available since v4.1 for `address`, `bool`, `bytes32`, `uint256`._
35  * _Available since v4.9 for `string`, `bytes`._
36  */
37 library StorageSlot {
38     struct AddressSlot {
39         address value;
40     }
41 
42     struct BooleanSlot {
43         bool value;
44     }
45 
46     struct Bytes32Slot {
47         bytes32 value;
48     }
49 
50     struct Uint256Slot {
51         uint256 value;
52     }
53 
54     struct StringSlot {
55         string value;
56     }
57 
58     struct BytesSlot {
59         bytes value;
60     }
61 
62     /**
63      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
64      */
65     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
66         /// @solidity memory-safe-assembly
67         assembly {
68             r.slot := slot
69         }
70     }
71 
72     /**
73      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
74      */
75     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
76         /// @solidity memory-safe-assembly
77         assembly {
78             r.slot := slot
79         }
80     }
81 
82     /**
83      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
84      */
85     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
86         /// @solidity memory-safe-assembly
87         assembly {
88             r.slot := slot
89         }
90     }
91 
92     /**
93      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
94      */
95     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
96         /// @solidity memory-safe-assembly
97         assembly {
98             r.slot := slot
99         }
100     }
101 
102     /**
103      * @dev Returns an `StringSlot` with member `value` located at `slot`.
104      */
105     function getStringSlot(bytes32 slot) internal pure returns (StringSlot storage r) {
106         /// @solidity memory-safe-assembly
107         assembly {
108             r.slot := slot
109         }
110     }
111 
112     /**
113      * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
114      */
115     function getStringSlot(string storage store) internal pure returns (StringSlot storage r) {
116         /// @solidity memory-safe-assembly
117         assembly {
118             r.slot := store.slot
119         }
120     }
121 
122     /**
123      * @dev Returns an `BytesSlot` with member `value` located at `slot`.
124      */
125     function getBytesSlot(bytes32 slot) internal pure returns (BytesSlot storage r) {
126         /// @solidity memory-safe-assembly
127         assembly {
128             r.slot := slot
129         }
130     }
131 
132     /**
133      * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
134      */
135     function getBytesSlot(bytes storage store) internal pure returns (BytesSlot storage r) {
136         /// @solidity memory-safe-assembly
137         assembly {
138             r.slot := store.slot
139         }
140     }
141 }
142 
143 // File: node_modules/@openzeppelin/contracts/utils/Address.sol
144 
145 
146 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
147 
148 pragma solidity ^0.8.1;
149 
150 /**
151  * @dev Collection of functions related to the address type
152  */
153 library Address {
154     /**
155      * @dev Returns true if `account` is a contract.
156      *
157      * [IMPORTANT]
158      * ====
159      * It is unsafe to assume that an address for which this function returns
160      * false is an externally-owned account (EOA) and not a contract.
161      *
162      * Among others, `isContract` will return false for the following
163      * types of addresses:
164      *
165      *  - an externally-owned account
166      *  - a contract in construction
167      *  - an address where a contract will be created
168      *  - an address where a contract lived, but was destroyed
169      *
170      * Furthermore, `isContract` will also return true if the target contract within
171      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
172      * which only has an effect at the end of a transaction.
173      * ====
174      *
175      * [IMPORTANT]
176      * ====
177      * You shouldn't rely on `isContract` to protect against flash loan attacks!
178      *
179      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
180      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
181      * constructor.
182      * ====
183      */
184     function isContract(address account) internal view returns (bool) {
185         // This method relies on extcodesize/address.code.length, which returns 0
186         // for contracts in construction, since the code is only stored at the end
187         // of the constructor execution.
188 
189         return account.code.length > 0;
190     }
191 
192     /**
193      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
194      * `recipient`, forwarding all available gas and reverting on errors.
195      *
196      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
197      * of certain opcodes, possibly making contracts go over the 2300 gas limit
198      * imposed by `transfer`, making them unable to receive funds via
199      * `transfer`. {sendValue} removes this limitation.
200      *
201      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
202      *
203      * IMPORTANT: because control is transferred to `recipient`, care must be
204      * taken to not create reentrancy vulnerabilities. Consider using
205      * {ReentrancyGuard} or the
206      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
207      */
208     function sendValue(address payable recipient, uint256 amount) internal {
209         require(address(this).balance >= amount, "Address: insufficient balance");
210 
211         (bool success, ) = recipient.call{value: amount}("");
212         require(success, "Address: unable to send value, recipient may have reverted");
213     }
214 
215     /**
216      * @dev Performs a Solidity function call using a low level `call`. A
217      * plain `call` is an unsafe replacement for a function call: use this
218      * function instead.
219      *
220      * If `target` reverts with a revert reason, it is bubbled up by this
221      * function (like regular Solidity function calls).
222      *
223      * Returns the raw returned data. To convert to the expected return value,
224      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
225      *
226      * Requirements:
227      *
228      * - `target` must be a contract.
229      * - calling `target` with `data` must not revert.
230      *
231      * _Available since v3.1._
232      */
233     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
234         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
239      * `errorMessage` as a fallback revert reason when `target` reverts.
240      *
241      * _Available since v3.1._
242      */
243     function functionCall(
244         address target,
245         bytes memory data,
246         string memory errorMessage
247     ) internal returns (bytes memory) {
248         return functionCallWithValue(target, data, 0, errorMessage);
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
253      * but also transferring `value` wei to `target`.
254      *
255      * Requirements:
256      *
257      * - the calling contract must have an ETH balance of at least `value`.
258      * - the called Solidity function must be `payable`.
259      *
260      * _Available since v3.1._
261      */
262     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
263         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
268      * with `errorMessage` as a fallback revert reason when `target` reverts.
269      *
270      * _Available since v3.1._
271      */
272     function functionCallWithValue(
273         address target,
274         bytes memory data,
275         uint256 value,
276         string memory errorMessage
277     ) internal returns (bytes memory) {
278         require(address(this).balance >= value, "Address: insufficient balance for call");
279         (bool success, bytes memory returndata) = target.call{value: value}(data);
280         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
285      * but performing a static call.
286      *
287      * _Available since v3.3._
288      */
289     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
290         return functionStaticCall(target, data, "Address: low-level static call failed");
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
295      * but performing a static call.
296      *
297      * _Available since v3.3._
298      */
299     function functionStaticCall(
300         address target,
301         bytes memory data,
302         string memory errorMessage
303     ) internal view returns (bytes memory) {
304         (bool success, bytes memory returndata) = target.staticcall(data);
305         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
310      * but performing a delegate call.
311      *
312      * _Available since v3.4._
313      */
314     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
315         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
320      * but performing a delegate call.
321      *
322      * _Available since v3.4._
323      */
324     function functionDelegateCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         (bool success, bytes memory returndata) = target.delegatecall(data);
330         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
331     }
332 
333     /**
334      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
335      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
336      *
337      * _Available since v4.8._
338      */
339     function verifyCallResultFromTarget(
340         address target,
341         bool success,
342         bytes memory returndata,
343         string memory errorMessage
344     ) internal view returns (bytes memory) {
345         if (success) {
346             if (returndata.length == 0) {
347                 // only check isContract if the call was successful and the return data is empty
348                 // otherwise we already know that it was a contract
349                 require(isContract(target), "Address: call to non-contract");
350             }
351             return returndata;
352         } else {
353             _revert(returndata, errorMessage);
354         }
355     }
356 
357     /**
358      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
359      * revert reason or using the provided one.
360      *
361      * _Available since v4.3._
362      */
363     function verifyCallResult(
364         bool success,
365         bytes memory returndata,
366         string memory errorMessage
367     ) internal pure returns (bytes memory) {
368         if (success) {
369             return returndata;
370         } else {
371             _revert(returndata, errorMessage);
372         }
373     }
374 
375     function _revert(bytes memory returndata, string memory errorMessage) private pure {
376         // Look for revert reason and bubble it up if present
377         if (returndata.length > 0) {
378             // The easiest way to bubble the revert reason is using memory via assembly
379             /// @solidity memory-safe-assembly
380             assembly {
381                 let returndata_size := mload(returndata)
382                 revert(add(32, returndata), returndata_size)
383             }
384         } else {
385             revert(errorMessage);
386         }
387     }
388 }
389 
390 // File: node_modules/@openzeppelin/contracts/interfaces/draft-IERC1822.sol
391 
392 
393 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 /**
398  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
399  * proxy whose upgrades are fully controlled by the current implementation.
400  */
401 interface IERC1822Proxiable {
402     /**
403      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
404      * address.
405      *
406      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
407      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
408      * function revert if invoked through a proxy.
409      */
410     function proxiableUUID() external view returns (bytes32);
411 }
412 
413 // File: node_modules/@openzeppelin/contracts/interfaces/IERC1967.sol
414 
415 
416 // OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC1967.sol)
417 
418 pragma solidity ^0.8.0;
419 
420 /**
421  * @dev ERC-1967: Proxy Storage Slots. This interface contains the events defined in the ERC.
422  *
423  * _Available since v4.8.3._
424  */
425 interface IERC1967 {
426     /**
427      * @dev Emitted when the implementation is upgraded.
428      */
429     event Upgraded(address indexed implementation);
430 
431     /**
432      * @dev Emitted when the admin account has changed.
433      */
434     event AdminChanged(address previousAdmin, address newAdmin);
435 
436     /**
437      * @dev Emitted when the beacon is changed.
438      */
439     event BeaconUpgraded(address indexed beacon);
440 }
441 
442 // File: node_modules/@openzeppelin/contracts/proxy/beacon/IBeacon.sol
443 
444 
445 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @dev This is the interface that {BeaconProxy} expects of its beacon.
451  */
452 interface IBeacon {
453     /**
454      * @dev Must return an address that can be used as a delegate call target.
455      *
456      * {BeaconProxy} will check that this address is a contract.
457      */
458     function implementation() external view returns (address);
459 }
460 
461 // File: node_modules/@openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol
462 
463 
464 // OpenZeppelin Contracts (last updated v4.9.0) (proxy/ERC1967/ERC1967Upgrade.sol)
465 
466 pragma solidity ^0.8.2;
467 
468 
469 
470 
471 
472 
473 /**
474  * @dev This abstract contract provides getters and event emitting update functions for
475  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
476  *
477  * _Available since v4.1._
478  */
479 abstract contract ERC1967Upgrade is IERC1967 {
480     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
481     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
482 
483     /**
484      * @dev Storage slot with the address of the current implementation.
485      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
486      * validated in the constructor.
487      */
488     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
489 
490     /**
491      * @dev Returns the current implementation address.
492      */
493     function _getImplementation() internal view returns (address) {
494         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
495     }
496 
497     /**
498      * @dev Stores a new address in the EIP1967 implementation slot.
499      */
500     function _setImplementation(address newImplementation) private {
501         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
502         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
503     }
504 
505     /**
506      * @dev Perform implementation upgrade
507      *
508      * Emits an {Upgraded} event.
509      */
510     function _upgradeTo(address newImplementation) internal {
511         _setImplementation(newImplementation);
512         emit Upgraded(newImplementation);
513     }
514 
515     /**
516      * @dev Perform implementation upgrade with additional setup call.
517      *
518      * Emits an {Upgraded} event.
519      */
520     function _upgradeToAndCall(address newImplementation, bytes memory data, bool forceCall) internal {
521         _upgradeTo(newImplementation);
522         if (data.length > 0 || forceCall) {
523             Address.functionDelegateCall(newImplementation, data);
524         }
525     }
526 
527     /**
528      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
529      *
530      * Emits an {Upgraded} event.
531      */
532     function _upgradeToAndCallUUPS(address newImplementation, bytes memory data, bool forceCall) internal {
533         // Upgrades from old implementations will perform a rollback test. This test requires the new
534         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
535         // this special case will break upgrade paths from old UUPS implementation to new ones.
536         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
537             _setImplementation(newImplementation);
538         } else {
539             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
540                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
541             } catch {
542                 revert("ERC1967Upgrade: new implementation is not UUPS");
543             }
544             _upgradeToAndCall(newImplementation, data, forceCall);
545         }
546     }
547 
548     /**
549      * @dev Storage slot with the admin of the contract.
550      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
551      * validated in the constructor.
552      */
553     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
554 
555     /**
556      * @dev Returns the current admin.
557      */
558     function _getAdmin() internal view returns (address) {
559         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
560     }
561 
562     /**
563      * @dev Stores a new address in the EIP1967 admin slot.
564      */
565     function _setAdmin(address newAdmin) private {
566         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
567         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
568     }
569 
570     /**
571      * @dev Changes the admin of the proxy.
572      *
573      * Emits an {AdminChanged} event.
574      */
575     function _changeAdmin(address newAdmin) internal {
576         emit AdminChanged(_getAdmin(), newAdmin);
577         _setAdmin(newAdmin);
578     }
579 
580     /**
581      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
582      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
583      */
584     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
585 
586     /**
587      * @dev Returns the current beacon.
588      */
589     function _getBeacon() internal view returns (address) {
590         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
591     }
592 
593     /**
594      * @dev Stores a new beacon in the EIP1967 beacon slot.
595      */
596     function _setBeacon(address newBeacon) private {
597         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
598         require(
599             Address.isContract(IBeacon(newBeacon).implementation()),
600             "ERC1967: beacon implementation is not a contract"
601         );
602         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
603     }
604 
605     /**
606      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
607      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
608      *
609      * Emits a {BeaconUpgraded} event.
610      */
611     function _upgradeBeaconToAndCall(address newBeacon, bytes memory data, bool forceCall) internal {
612         _setBeacon(newBeacon);
613         emit BeaconUpgraded(newBeacon);
614         if (data.length > 0 || forceCall) {
615             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
616         }
617     }
618 }
619 
620 // File: node_modules/@openzeppelin/contracts/proxy/Proxy.sol
621 
622 
623 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
624 
625 pragma solidity ^0.8.0;
626 
627 /**
628  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
629  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
630  * be specified by overriding the virtual {_implementation} function.
631  *
632  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
633  * different contract through the {_delegate} function.
634  *
635  * The success and return data of the delegated call will be returned back to the caller of the proxy.
636  */
637 abstract contract Proxy {
638     /**
639      * @dev Delegates the current call to `implementation`.
640      *
641      * This function does not return to its internal call site, it will return directly to the external caller.
642      */
643     function _delegate(address implementation) internal virtual {
644         assembly {
645             // Copy msg.data. We take full control of memory in this inline assembly
646             // block because it will not return to Solidity code. We overwrite the
647             // Solidity scratch pad at memory position 0.
648             calldatacopy(0, 0, calldatasize())
649 
650             // Call the implementation.
651             // out and outsize are 0 because we don't know the size yet.
652             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
653 
654             // Copy the returned data.
655             returndatacopy(0, 0, returndatasize())
656 
657             switch result
658             // delegatecall returns 0 on error.
659             case 0 {
660                 revert(0, returndatasize())
661             }
662             default {
663                 return(0, returndatasize())
664             }
665         }
666     }
667 
668     /**
669      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
670      * and {_fallback} should delegate.
671      */
672     function _implementation() internal view virtual returns (address);
673 
674     /**
675      * @dev Delegates the current call to the address returned by `_implementation()`.
676      *
677      * This function does not return to its internal call site, it will return directly to the external caller.
678      */
679     function _fallback() internal virtual {
680         _beforeFallback();
681         _delegate(_implementation());
682     }
683 
684     /**
685      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
686      * function in the contract matches the call data.
687      */
688     fallback() external payable virtual {
689         _fallback();
690     }
691 
692     /**
693      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
694      * is empty.
695      */
696     receive() external payable virtual {
697         _fallback();
698     }
699 
700     /**
701      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
702      * call, or as part of the Solidity `fallback` or `receive` functions.
703      *
704      * If overridden should call `super._beforeFallback()`.
705      */
706     function _beforeFallback() internal virtual {}
707 }
708 
709 // File: node_modules/@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol
710 
711 
712 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
713 
714 pragma solidity ^0.8.0;
715 
716 
717 
718 /**
719  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
720  * implementation address that can be changed. This address is stored in storage in the location specified by
721  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
722  * implementation behind the proxy.
723  */
724 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
725     /**
726      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
727      *
728      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
729      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
730      */
731     constructor(address _logic, bytes memory _data) payable {
732         _upgradeToAndCall(_logic, _data, false);
733     }
734 
735     /**
736      * @dev Returns the current implementation address.
737      */
738     function _implementation() internal view virtual override returns (address impl) {
739         return ERC1967Upgrade._getImplementation();
740     }
741 }