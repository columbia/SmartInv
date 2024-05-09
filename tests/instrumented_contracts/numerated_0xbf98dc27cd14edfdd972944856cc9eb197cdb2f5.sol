1 // Sources flattened with hardhat v2.9.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/proxy/Proxy.sol@v4.6.0
4 
5 //  : MIT
6 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
12  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
13  * be specified by overriding the virtual {_implementation} function.
14  *
15  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
16  * different contract through the {_delegate} function.
17  *
18  * The success and return data of the delegated call will be returned back to the caller of the proxy.
19  */
20 abstract contract Proxy {
21     /**
22      * @dev Delegates the current call to `implementation`.
23      *
24      * This function does not return to its internal call site, it will return directly to the external caller.
25      */
26     function _delegate(address implementation) internal virtual {
27         assembly {
28             // Copy msg.data. We take full control of memory in this inline assembly
29             // block because it will not return to Solidity code. We overwrite the
30             // Solidity scratch pad at memory position 0.
31             calldatacopy(0, 0, calldatasize())
32 
33             // Call the implementation.
34             // out and outsize are 0 because we don't know the size yet.
35             let result := delegatecall(
36                 gas(),
37                 implementation,
38                 0,
39                 calldatasize(),
40                 0,
41                 0
42             )
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
59      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
60      * and {_fallback} should delegate.
61      */
62     function _implementation() internal view virtual returns (address);
63 
64     /**
65      * @dev Delegates the current call to the address returned by `_implementation()`.
66      *
67      * This function does not return to its internal call site, it will return directly to the external caller.
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
94      * If overridden should call `super._beforeFallback()`.
95      */
96     function _beforeFallback() internal virtual {}
97 }
98 
99 // File @openzeppelin/contracts/proxy/beacon/IBeacon.sol@v4.6.0
100 
101 //  : MIT
102 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev This is the interface that {BeaconProxy} expects of its beacon.
108  */
109 interface IBeacon {
110     /**
111      * @dev Must return an address that can be used as a delegate call target.
112      *
113      * {BeaconProxy} will check that this address is a contract.
114      */
115     function implementation() external view returns (address);
116 }
117 
118 // File @openzeppelin/contracts/interfaces/draft-IERC1822.sol@v4.6.0
119 
120 //  : MIT
121 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 /**
126  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
127  * proxy whose upgrades are fully controlled by the current implementation.
128  */
129 interface IERC1822Proxiable {
130     /**
131      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
132      * address.
133      *
134      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
135      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
136      * function revert if invoked through a proxy.
137      */
138     function proxiableUUID() external view returns (bytes32);
139 }
140 
141 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
142 
143 // SPDX-License-Identifier: MIT
144 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
145 
146 pragma solidity ^0.8.1;
147 
148 /**
149  * @dev Collection of functions related to the address type
150  */
151 library Address {
152     /**
153      * @dev Returns true if `account` is a contract.
154      *
155      * [IMPORTANT]
156      * ====
157      * It is unsafe to assume that an address for which this function returns
158      * false is an externally-owned account (EOA) and not a contract.
159      *
160      * Among others, `isContract` will return false for the following
161      * types of addresses:
162      *
163      *  - an externally-owned account
164      *  - a contract in construction
165      *  - an address where a contract will be created
166      *  - an address where a contract lived, but was destroyed
167      * ====
168      *
169      * [IMPORTANT]
170      * ====
171      * You shouldn't rely on `isContract` to protect against flash loan attacks!
172      *
173      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
174      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
175      * constructor.
176      * ====
177      */
178     function isContract(address account) internal view returns (bool) {
179         // This method relies on extcodesize/address.code.length, which returns 0
180         // for contracts in construction, since the code is only stored at the end
181         // of the constructor execution.
182 
183         return account.code.length > 0;
184     }
185 
186     /**
187      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
188      * `recipient`, forwarding all available gas and reverting on errors.
189      *
190      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
191      * of certain opcodes, possibly making contracts go over the 2300 gas limit
192      * imposed by `transfer`, making them unable to receive funds via
193      * `transfer`. {sendValue} removes this limitation.
194      *
195      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
196      *
197      * IMPORTANT: because control is transferred to `recipient`, care must be
198      * taken to not create reentrancy vulnerabilities. Consider using
199      * {ReentrancyGuard} or the
200      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
201      */
202     function sendValue(address payable recipient, uint256 amount) internal {
203         require(
204             address(this).balance >= amount,
205             "Address: insufficient balance"
206         );
207 
208         (bool success, ) = recipient.call{value: amount}("");
209         require(
210             success,
211             "Address: unable to send value, recipient may have reverted"
212         );
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
233     function functionCall(address target, bytes memory data)
234         internal
235         returns (bytes memory)
236     {
237         return functionCall(target, data, "Address: low-level call failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
242      * `errorMessage` as a fallback revert reason when `target` reverts.
243      *
244      * _Available since v3.1._
245      */
246     function functionCall(
247         address target,
248         bytes memory data,
249         string memory errorMessage
250     ) internal returns (bytes memory) {
251         return functionCallWithValue(target, data, 0, errorMessage);
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
256      * but also transferring `value` wei to `target`.
257      *
258      * Requirements:
259      *
260      * - the calling contract must have an ETH balance of at least `value`.
261      * - the called Solidity function must be `payable`.
262      *
263      * _Available since v3.1._
264      */
265     function functionCallWithValue(
266         address target,
267         bytes memory data,
268         uint256 value
269     ) internal returns (bytes memory) {
270         return
271             functionCallWithValue(
272                 target,
273                 data,
274                 value,
275                 "Address: low-level call with value failed"
276             );
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
281      * with `errorMessage` as a fallback revert reason when `target` reverts.
282      *
283      * _Available since v3.1._
284      */
285     function functionCallWithValue(
286         address target,
287         bytes memory data,
288         uint256 value,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         require(
292             address(this).balance >= value,
293             "Address: insufficient balance for call"
294         );
295         require(isContract(target), "Address: call to non-contract");
296 
297         (bool success, bytes memory returndata) = target.call{value: value}(
298             data
299         );
300         return verifyCallResult(success, returndata, errorMessage);
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
305      * but performing a static call.
306      *
307      * _Available since v3.3._
308      */
309     function functionStaticCall(address target, bytes memory data)
310         internal
311         view
312         returns (bytes memory)
313     {
314         return
315             functionStaticCall(
316                 target,
317                 data,
318                 "Address: low-level static call failed"
319             );
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
324      * but performing a static call.
325      *
326      * _Available since v3.3._
327      */
328     function functionStaticCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal view returns (bytes memory) {
333         require(isContract(target), "Address: static call to non-contract");
334 
335         (bool success, bytes memory returndata) = target.staticcall(data);
336         return verifyCallResult(success, returndata, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but performing a delegate call.
342      *
343      * _Available since v3.4._
344      */
345     function functionDelegateCall(address target, bytes memory data)
346         internal
347         returns (bytes memory)
348     {
349         return
350             functionDelegateCall(
351                 target,
352                 data,
353                 "Address: low-level delegate call failed"
354             );
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
359      * but performing a delegate call.
360      *
361      * _Available since v3.4._
362      */
363     function functionDelegateCall(
364         address target,
365         bytes memory data,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         require(isContract(target), "Address: delegate call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.delegatecall(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
376      * revert reason using the provided one.
377      *
378      * _Available since v4.3._
379      */
380     function verifyCallResult(
381         bool success,
382         bytes memory returndata,
383         string memory errorMessage
384     ) internal pure returns (bytes memory) {
385         if (success) {
386             return returndata;
387         } else {
388             // Look for revert reason and bubble it up if present
389             if (returndata.length > 0) {
390                 // The easiest way to bubble the revert reason is using memory via assembly
391 
392                 assembly {
393                     let returndata_size := mload(returndata)
394                     revert(add(32, returndata), returndata_size)
395                 }
396             } else {
397                 revert(errorMessage);
398             }
399         }
400     }
401 }
402 
403 // File @openzeppelin/contracts/utils/StorageSlot.sol@v4.6.0
404 
405 //  : MIT
406 // OpenZeppelin Contracts v4.4.1 (utils/StorageSlot.sol)
407 
408 pragma solidity ^0.8.0;
409 
410 /**
411  * @dev Library for reading and writing primitive types to specific storage slots.
412  *
413  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
414  * This library helps with reading and writing to such slots without the need for inline assembly.
415  *
416  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
417  *
418  * Example usage to set ERC1967 implementation slot:
419  * ```
420  * contract ERC1967 {
421  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
422  *
423  *     function _getImplementation() internal view returns (address) {
424  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
425  *     }
426  *
427  *     function _setImplementation(address newImplementation) internal {
428  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
429  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
430  *     }
431  * }
432  * ```
433  *
434  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
435  */
436 library StorageSlot {
437     struct AddressSlot {
438         address value;
439     }
440 
441     struct BooleanSlot {
442         bool value;
443     }
444 
445     struct Bytes32Slot {
446         bytes32 value;
447     }
448 
449     struct Uint256Slot {
450         uint256 value;
451     }
452 
453     /**
454      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
455      */
456     function getAddressSlot(bytes32 slot)
457         internal
458         pure
459         returns (AddressSlot storage r)
460     {
461         assembly {
462             r.slot := slot
463         }
464     }
465 
466     /**
467      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
468      */
469     function getBooleanSlot(bytes32 slot)
470         internal
471         pure
472         returns (BooleanSlot storage r)
473     {
474         assembly {
475             r.slot := slot
476         }
477     }
478 
479     /**
480      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
481      */
482     function getBytes32Slot(bytes32 slot)
483         internal
484         pure
485         returns (Bytes32Slot storage r)
486     {
487         assembly {
488             r.slot := slot
489         }
490     }
491 
492     /**
493      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
494      */
495     function getUint256Slot(bytes32 slot)
496         internal
497         pure
498         returns (Uint256Slot storage r)
499     {
500         assembly {
501             r.slot := slot
502         }
503     }
504 }
505 
506 // File @openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol@v4.6.0
507 
508 //  : MIT
509 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
510 
511 pragma solidity ^0.8.2;
512 
513 /**
514  * @dev This abstract contract provides getters and event emitting update functions for
515  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
516  *
517  * _Available since v4.1._
518  *
519  * @custom:oz-upgrades-unsafe-allow delegatecall
520  */
521 abstract contract ERC1967Upgrade {
522     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
523     bytes32 private constant _ROLLBACK_SLOT =
524         0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
525 
526     /**
527      * @dev Storage slot with the address of the current implementation.
528      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
529      * validated in the constructor.
530      */
531     bytes32 internal constant _IMPLEMENTATION_SLOT =
532         0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
533 
534     /**
535      * @dev Emitted when the implementation is upgraded.
536      */
537     event Upgraded(address indexed implementation);
538 
539     /**
540      * @dev Returns the current implementation address.
541      */
542     function _getImplementation() internal view returns (address) {
543         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
544     }
545 
546     /**
547      * @dev Stores a new address in the EIP1967 implementation slot.
548      */
549     function _setImplementation(address newImplementation) private {
550         require(
551             Address.isContract(newImplementation),
552             "ERC1967: new implementation is not a contract"
553         );
554         StorageSlot
555             .getAddressSlot(_IMPLEMENTATION_SLOT)
556             .value = newImplementation;
557     }
558 
559     /**
560      * @dev Perform implementation upgrade
561      *
562      * Emits an {Upgraded} event.
563      */
564     function _upgradeTo(address newImplementation) internal {
565         _setImplementation(newImplementation);
566         emit Upgraded(newImplementation);
567     }
568 
569     /**
570      * @dev Perform implementation upgrade with additional setup call.
571      *
572      * Emits an {Upgraded} event.
573      */
574     function _upgradeToAndCall(
575         address newImplementation,
576         bytes memory data,
577         bool forceCall
578     ) internal {
579         _upgradeTo(newImplementation);
580         if (data.length > 0 || forceCall) {
581             Address.functionDelegateCall(newImplementation, data);
582         }
583     }
584 
585     /**
586      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
587      *
588      * Emits an {Upgraded} event.
589      */
590     function _upgradeToAndCallUUPS(
591         address newImplementation,
592         bytes memory data,
593         bool forceCall
594     ) internal {
595         // Upgrades from old implementations will perform a rollback test. This test requires the new
596         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
597         // this special case will break upgrade paths from old UUPS implementation to new ones.
598         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
599             _setImplementation(newImplementation);
600         } else {
601             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (
602                 bytes32 slot
603             ) {
604                 require(
605                     slot == _IMPLEMENTATION_SLOT,
606                     "ERC1967Upgrade: unsupported proxiableUUID"
607                 );
608             } catch {
609                 revert("ERC1967Upgrade: new implementation is not UUPS");
610             }
611             _upgradeToAndCall(newImplementation, data, forceCall);
612         }
613     }
614 
615     /**
616      * @dev Storage slot with the admin of the contract.
617      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
618      * validated in the constructor.
619      */
620     bytes32 internal constant _ADMIN_SLOT =
621         0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
622 
623     /**
624      * @dev Emitted when the admin account has changed.
625      */
626     event AdminChanged(address previousAdmin, address newAdmin);
627 
628     /**
629      * @dev Returns the current admin.
630      */
631     function _getAdmin() internal view returns (address) {
632         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
633     }
634 
635     /**
636      * @dev Stores a new address in the EIP1967 admin slot.
637      */
638     function _setAdmin(address newAdmin) private {
639         require(
640             newAdmin != address(0),
641             "ERC1967: new admin is the zero address"
642         );
643         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
644     }
645 
646     /**
647      * @dev Changes the admin of the proxy.
648      *
649      * Emits an {AdminChanged} event.
650      */
651     function _changeAdmin(address newAdmin) internal {
652         emit AdminChanged(_getAdmin(), newAdmin);
653         _setAdmin(newAdmin);
654     }
655 
656     /**
657      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
658      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
659      */
660     bytes32 internal constant _BEACON_SLOT =
661         0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
662 
663     /**
664      * @dev Emitted when the beacon is upgraded.
665      */
666     event BeaconUpgraded(address indexed beacon);
667 
668     /**
669      * @dev Returns the current beacon.
670      */
671     function _getBeacon() internal view returns (address) {
672         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
673     }
674 
675     /**
676      * @dev Stores a new beacon in the EIP1967 beacon slot.
677      */
678     function _setBeacon(address newBeacon) private {
679         require(
680             Address.isContract(newBeacon),
681             "ERC1967: new beacon is not a contract"
682         );
683         require(
684             Address.isContract(IBeacon(newBeacon).implementation()),
685             "ERC1967: beacon implementation is not a contract"
686         );
687         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
688     }
689 
690     /**
691      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
692      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
693      *
694      * Emits a {BeaconUpgraded} event.
695      */
696     function _upgradeBeaconToAndCall(
697         address newBeacon,
698         bytes memory data,
699         bool forceCall
700     ) internal {
701         _setBeacon(newBeacon);
702         emit BeaconUpgraded(newBeacon);
703         if (data.length > 0 || forceCall) {
704             Address.functionDelegateCall(
705                 IBeacon(newBeacon).implementation(),
706                 data
707             );
708         }
709     }
710 }
711 
712 // File @openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol@v4.6.0
713 
714 //  : MIT
715 // OpenZeppelin Contracts v4.4.1 (proxy/ERC1967/ERC1967Proxy.sol)
716 
717 pragma solidity ^0.8.0;
718 
719 /**
720  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
721  * implementation address that can be changed. This address is stored in storage in the location specified by
722  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
723  * implementation behind the proxy.
724  */
725 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
726     /**
727      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
728      *
729      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
730      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
731      */
732     constructor(address _logic, bytes memory _data) payable {
733         assert(
734             _IMPLEMENTATION_SLOT ==
735                 bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)
736         );
737         _upgradeToAndCall(_logic, _data, false);
738     }
739 
740     /**
741      * @dev Returns the current implementation address.
742      */
743     function _implementation()
744         internal
745         view
746         virtual
747         override
748         returns (address impl)
749     {
750         return ERC1967Upgrade._getImplementation();
751     }
752 }
753 
754 // File src/deployments/UUPSProxy.sol
755 
756 // SPDX-License-Identifier : BUSL-1.1
757 
758 pragma solidity ^0.8.0;
759 
760 // Kept for backwards compatibility with older versions of Hardhat and Truffle plugins.
761 contract UUPSProxy is ERC1967Proxy {
762     constructor(
763         address _logic,
764         address,
765         bytes memory _data
766     ) payable ERC1967Proxy(_logic, _data) {}
767 }