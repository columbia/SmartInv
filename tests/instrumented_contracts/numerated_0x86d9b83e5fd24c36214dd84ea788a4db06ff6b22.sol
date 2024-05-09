1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/StorageSlot.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Library for reading and writing primitive types to specific storage slots.
11  *
12  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
13  * This library helps with reading and writing to such slots without the need for inline assembly.
14  *
15  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
16  *
17  * Example usage to set ERC1967 implementation slot:
18  * ```
19  * contract ERC1967 {
20  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
21  *
22  *     function _getImplementation() internal view returns (address) {
23  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
24  *     }
25  *
26  *     function _setImplementation(address newImplementation) internal {
27  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
28  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
29  *     }
30  * }
31  * ```
32  *
33  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
34  */
35 library StorageSlot {
36     struct AddressSlot {
37         address value;
38     }
39 
40     struct BooleanSlot {
41         bool value;
42     }
43 
44     struct Bytes32Slot {
45         bytes32 value;
46     }
47 
48     struct Uint256Slot {
49         uint256 value;
50     }
51 
52     /**
53      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
54      */
55     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
56         /// @solidity memory-safe-assembly
57         assembly {
58             r.slot := slot
59         }
60     }
61 
62     /**
63      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
64      */
65     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
66         /// @solidity memory-safe-assembly
67         assembly {
68             r.slot := slot
69         }
70     }
71 
72     /**
73      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
74      */
75     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
76         /// @solidity memory-safe-assembly
77         assembly {
78             r.slot := slot
79         }
80     }
81 
82     /**
83      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
84      */
85     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
86         /// @solidity memory-safe-assembly
87         assembly {
88             r.slot := slot
89         }
90     }
91 }
92 
93 // File: @openzeppelin/contracts/utils/Address.sol
94 
95 
96 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
97 
98 pragma solidity ^0.8.1;
99 
100 /**
101  * @dev Collection of functions related to the address type
102  */
103 library Address {
104     /**
105      * @dev Returns true if `account` is a contract.
106      *
107      * [IMPORTANT]
108      * ====
109      * It is unsafe to assume that an address for which this function returns
110      * false is an externally-owned account (EOA) and not a contract.
111      *
112      * Among others, `isContract` will return false for the following
113      * types of addresses:
114      *
115      *  - an externally-owned account
116      *  - a contract in construction
117      *  - an address where a contract will be created
118      *  - an address where a contract lived, but was destroyed
119      * ====
120      *
121      * [IMPORTANT]
122      * ====
123      * You shouldn't rely on `isContract` to protect against flash loan attacks!
124      *
125      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
126      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
127      * constructor.
128      * ====
129      */
130     function isContract(address account) internal view returns (bool) {
131         // This method relies on extcodesize/address.code.length, which returns 0
132         // for contracts in construction, since the code is only stored at the end
133         // of the constructor execution.
134 
135         return account.code.length > 0;
136     }
137 
138     /**
139      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
140      * `recipient`, forwarding all available gas and reverting on errors.
141      *
142      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
143      * of certain opcodes, possibly making contracts go over the 2300 gas limit
144      * imposed by `transfer`, making them unable to receive funds via
145      * `transfer`. {sendValue} removes this limitation.
146      *
147      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
148      *
149      * IMPORTANT: because control is transferred to `recipient`, care must be
150      * taken to not create reentrancy vulnerabilities. Consider using
151      * {ReentrancyGuard} or the
152      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
153      */
154     function sendValue(address payable recipient, uint256 amount) internal {
155         require(address(this).balance >= amount, "Address: insufficient balance");
156 
157         (bool success, ) = recipient.call{value: amount}("");
158         require(success, "Address: unable to send value, recipient may have reverted");
159     }
160 
161     /**
162      * @dev Performs a Solidity function call using a low level `call`. A
163      * plain `call` is an unsafe replacement for a function call: use this
164      * function instead.
165      *
166      * If `target` reverts with a revert reason, it is bubbled up by this
167      * function (like regular Solidity function calls).
168      *
169      * Returns the raw returned data. To convert to the expected return value,
170      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
171      *
172      * Requirements:
173      *
174      * - `target` must be a contract.
175      * - calling `target` with `data` must not revert.
176      *
177      * _Available since v3.1._
178      */
179     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
185      * `errorMessage` as a fallback revert reason when `target` reverts.
186      *
187      * _Available since v3.1._
188      */
189     function functionCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         return functionCallWithValue(target, data, 0, errorMessage);
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
199      * but also transferring `value` wei to `target`.
200      *
201      * Requirements:
202      *
203      * - the calling contract must have an ETH balance of at least `value`.
204      * - the called Solidity function must be `payable`.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value
212     ) internal returns (bytes memory) {
213         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
218      * with `errorMessage` as a fallback revert reason when `target` reverts.
219      *
220      * _Available since v3.1._
221      */
222     function functionCallWithValue(
223         address target,
224         bytes memory data,
225         uint256 value,
226         string memory errorMessage
227     ) internal returns (bytes memory) {
228         require(address(this).balance >= value, "Address: insufficient balance for call");
229         (bool success, bytes memory returndata) = target.call{value: value}(data);
230         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
235      * but performing a static call.
236      *
237      * _Available since v3.3._
238      */
239     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
240         return functionStaticCall(target, data, "Address: low-level static call failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
245      * but performing a static call.
246      *
247      * _Available since v3.3._
248      */
249     function functionStaticCall(
250         address target,
251         bytes memory data,
252         string memory errorMessage
253     ) internal view returns (bytes memory) {
254         (bool success, bytes memory returndata) = target.staticcall(data);
255         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
265         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
270      * but performing a delegate call.
271      *
272      * _Available since v3.4._
273      */
274     function functionDelegateCall(
275         address target,
276         bytes memory data,
277         string memory errorMessage
278     ) internal returns (bytes memory) {
279         (bool success, bytes memory returndata) = target.delegatecall(data);
280         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
281     }
282 
283     /**
284      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
285      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
286      *
287      * _Available since v4.8._
288      */
289     function verifyCallResultFromTarget(
290         address target,
291         bool success,
292         bytes memory returndata,
293         string memory errorMessage
294     ) internal view returns (bytes memory) {
295         if (success) {
296             if (returndata.length == 0) {
297                 // only check isContract if the call was successful and the return data is empty
298                 // otherwise we already know that it was a contract
299                 require(isContract(target), "Address: call to non-contract");
300             }
301             return returndata;
302         } else {
303             _revert(returndata, errorMessage);
304         }
305     }
306 
307     /**
308      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
309      * revert reason or using the provided one.
310      *
311      * _Available since v4.3._
312      */
313     function verifyCallResult(
314         bool success,
315         bytes memory returndata,
316         string memory errorMessage
317     ) internal pure returns (bytes memory) {
318         if (success) {
319             return returndata;
320         } else {
321             _revert(returndata, errorMessage);
322         }
323     }
324 
325     function _revert(bytes memory returndata, string memory errorMessage) private pure {
326         // Look for revert reason and bubble it up if present
327         if (returndata.length > 0) {
328             // The easiest way to bubble the revert reason is using memory via assembly
329             /// @solidity memory-safe-assembly
330             assembly {
331                 let returndata_size := mload(returndata)
332                 revert(add(32, returndata), returndata_size)
333             }
334         } else {
335             revert(errorMessage);
336         }
337     }
338 }
339 
340 // File: @openzeppelin/contracts/interfaces/draft-IERC1822.sol
341 
342 
343 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
344 
345 pragma solidity ^0.8.0;
346 
347 /**
348  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
349  * proxy whose upgrades are fully controlled by the current implementation.
350  */
351 interface IERC1822Proxiable {
352     /**
353      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
354      * address.
355      *
356      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
357      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
358      * function revert if invoked through a proxy.
359      */
360     function proxiableUUID() external view returns (bytes32);
361 }
362 
363 // File: @openzeppelin/contracts/interfaces/IERC1967.sol
364 
365 
366 // OpenZeppelin Contracts (last updated v4.8.3) (interfaces/IERC1967.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 /**
371  * @dev ERC-1967: Proxy Storage Slots. This interface contains the events defined in the ERC.
372  *
373  * _Available since v4.9._
374  */
375 interface IERC1967 {
376     /**
377      * @dev Emitted when the implementation is upgraded.
378      */
379     event Upgraded(address indexed implementation);
380 
381     /**
382      * @dev Emitted when the admin account has changed.
383      */
384     event AdminChanged(address previousAdmin, address newAdmin);
385 
386     /**
387      * @dev Emitted when the beacon is changed.
388      */
389     event BeaconUpgraded(address indexed beacon);
390 }
391 
392 // File: @openzeppelin/contracts/proxy/beacon/IBeacon.sol
393 
394 
395 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 /**
400  * @dev This is the interface that {BeaconProxy} expects of its beacon.
401  */
402 interface IBeacon {
403     /**
404      * @dev Must return an address that can be used as a delegate call target.
405      *
406      * {BeaconProxy} will check that this address is a contract.
407      */
408     function implementation() external view returns (address);
409 }
410 
411 // File: @openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol
412 
413 
414 // OpenZeppelin Contracts (last updated v4.8.3) (proxy/ERC1967/ERC1967Upgrade.sol)
415 
416 pragma solidity ^0.8.2;
417 
418 
419 
420 
421 
422 
423 /**
424  * @dev This abstract contract provides getters and event emitting update functions for
425  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
426  *
427  * _Available since v4.1._
428  *
429  * @custom:oz-upgrades-unsafe-allow delegatecall
430  */
431 abstract contract ERC1967Upgrade is IERC1967 {
432     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
433     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
434 
435     /**
436      * @dev Storage slot with the address of the current implementation.
437      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
438      * validated in the constructor.
439      */
440     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
441 
442     /**
443      * @dev Returns the current implementation address.
444      */
445     function _getImplementation() internal view returns (address) {
446         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
447     }
448 
449     /**
450      * @dev Stores a new address in the EIP1967 implementation slot.
451      */
452     function _setImplementation(address newImplementation) private {
453         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
454         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
455     }
456 
457     /**
458      * @dev Perform implementation upgrade
459      *
460      * Emits an {Upgraded} event.
461      */
462     function _upgradeTo(address newImplementation) internal {
463         _setImplementation(newImplementation);
464         emit Upgraded(newImplementation);
465     }
466 
467     /**
468      * @dev Perform implementation upgrade with additional setup call.
469      *
470      * Emits an {Upgraded} event.
471      */
472     function _upgradeToAndCall(
473         address newImplementation,
474         bytes memory data,
475         bool forceCall
476     ) internal {
477         _upgradeTo(newImplementation);
478         if (data.length > 0 || forceCall) {
479             Address.functionDelegateCall(newImplementation, data);
480         }
481     }
482 
483     /**
484      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
485      *
486      * Emits an {Upgraded} event.
487      */
488     function _upgradeToAndCallUUPS(
489         address newImplementation,
490         bytes memory data,
491         bool forceCall
492     ) internal {
493         // Upgrades from old implementations will perform a rollback test. This test requires the new
494         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
495         // this special case will break upgrade paths from old UUPS implementation to new ones.
496         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
497             _setImplementation(newImplementation);
498         } else {
499             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
500                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
501             } catch {
502                 revert("ERC1967Upgrade: new implementation is not UUPS");
503             }
504             _upgradeToAndCall(newImplementation, data, forceCall);
505         }
506     }
507 
508     /**
509      * @dev Storage slot with the admin of the contract.
510      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
511      * validated in the constructor.
512      */
513     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
514 
515     /**
516      * @dev Returns the current admin.
517      */
518     function _getAdmin() internal view returns (address) {
519         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
520     }
521 
522     /**
523      * @dev Stores a new address in the EIP1967 admin slot.
524      */
525     function _setAdmin(address newAdmin) private {
526         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
527         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
528     }
529 
530     /**
531      * @dev Changes the admin of the proxy.
532      *
533      * Emits an {AdminChanged} event.
534      */
535     function _changeAdmin(address newAdmin) internal {
536         emit AdminChanged(_getAdmin(), newAdmin);
537         _setAdmin(newAdmin);
538     }
539 
540     /**
541      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
542      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
543      */
544     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
545 
546     /**
547      * @dev Returns the current beacon.
548      */
549     function _getBeacon() internal view returns (address) {
550         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
551     }
552 
553     /**
554      * @dev Stores a new beacon in the EIP1967 beacon slot.
555      */
556     function _setBeacon(address newBeacon) private {
557         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
558         require(
559             Address.isContract(IBeacon(newBeacon).implementation()),
560             "ERC1967: beacon implementation is not a contract"
561         );
562         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
563     }
564 
565     /**
566      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
567      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
568      *
569      * Emits a {BeaconUpgraded} event.
570      */
571     function _upgradeBeaconToAndCall(
572         address newBeacon,
573         bytes memory data,
574         bool forceCall
575     ) internal {
576         _setBeacon(newBeacon);
577         emit BeaconUpgraded(newBeacon);
578         if (data.length > 0 || forceCall) {
579             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
580         }
581     }
582 }
583 
584 // File: @openzeppelin/contracts/proxy/Proxy.sol
585 
586 
587 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 /**
592  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
593  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
594  * be specified by overriding the virtual {_implementation} function.
595  *
596  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
597  * different contract through the {_delegate} function.
598  *
599  * The success and return data of the delegated call will be returned back to the caller of the proxy.
600  */
601 abstract contract Proxy {
602     /**
603      * @dev Delegates the current call to `implementation`.
604      *
605      * This function does not return to its internal call site, it will return directly to the external caller.
606      */
607     function _delegate(address implementation) internal virtual {
608         assembly {
609             // Copy msg.data. We take full control of memory in this inline assembly
610             // block because it will not return to Solidity code. We overwrite the
611             // Solidity scratch pad at memory position 0.
612             calldatacopy(0, 0, calldatasize())
613 
614             // Call the implementation.
615             // out and outsize are 0 because we don't know the size yet.
616             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
617 
618             // Copy the returned data.
619             returndatacopy(0, 0, returndatasize())
620 
621             switch result
622             // delegatecall returns 0 on error.
623             case 0 {
624                 revert(0, returndatasize())
625             }
626             default {
627                 return(0, returndatasize())
628             }
629         }
630     }
631 
632     /**
633      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
634      * and {_fallback} should delegate.
635      */
636     function _implementation() internal view virtual returns (address);
637 
638     /**
639      * @dev Delegates the current call to the address returned by `_implementation()`.
640      *
641      * This function does not return to its internal call site, it will return directly to the external caller.
642      */
643     function _fallback() internal virtual {
644         _beforeFallback();
645         _delegate(_implementation());
646     }
647 
648     /**
649      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
650      * function in the contract matches the call data.
651      */
652     fallback() external payable virtual {
653         _fallback();
654     }
655 
656     /**
657      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
658      * is empty.
659      */
660     receive() external payable virtual {
661         _fallback();
662     }
663 
664     /**
665      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
666      * call, or as part of the Solidity `fallback` or `receive` functions.
667      *
668      * If overridden should call `super._beforeFallback()`.
669      */
670     function _beforeFallback() internal virtual {}
671 }
672 
673 // File: @openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol
674 
675 
676 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
677 
678 pragma solidity ^0.8.0;
679 
680 
681 
682 /**
683  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
684  * implementation address that can be changed. This address is stored in storage in the location specified by
685  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
686  * implementation behind the proxy.
687  */
688 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
689     /**
690      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
691      *
692      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
693      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
694      */
695     constructor(address _logic, bytes memory _data) payable {
696         _upgradeToAndCall(_logic, _data, false);
697     }
698 
699     /**
700      * @dev Returns the current implementation address.
701      */
702     function _implementation() internal view virtual override returns (address impl) {
703         return ERC1967Upgrade._getImplementation();
704     }
705 }
706 
707 // File: contracts/TransparentUpgradeableProxy.sol
708 
709 
710 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/transparent/TransparentUpgradeableProxy.sol)
711 
712 pragma solidity ^0.8.0;
713 
714 
715 /**
716  * @dev This contract implements a proxy that is upgradeable by an admin.
717  *
718  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
719  * clashing], which can potentially be used in an attack, this contract uses the
720  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
721  * things that go hand in hand:
722  *
723  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
724  * that call matches one of the admin functions exposed by the proxy itself.
725  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
726  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
727  * "admin cannot fallback to proxy target".
728  *
729  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
730  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
731  * to sudden errors when trying to call a function from the proxy implementation.
732  *
733  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
734  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
735  */
736 contract TransparentUpgradeableProxy is ERC1967Proxy {
737     /**
738      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
739      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
740      */
741     constructor(
742         address _logic,
743         address admin_,
744         bytes memory _data
745     ) payable ERC1967Proxy(_logic, _data) {
746         _changeAdmin(admin_);
747     }
748 
749     /**
750      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
751      */
752     modifier ifAdmin() {
753         if (msg.sender == _getAdmin()) {
754             _;
755         } else {
756             _fallback();
757         }
758     }
759 
760     /**
761      * @dev Returns the current admin.
762      *
763      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
764      *
765      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
766      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
767      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
768      */
769     function admin() external ifAdmin returns (address admin_) {
770         admin_ = _getAdmin();
771     }
772 
773     /**
774      * @dev Returns the current implementation.
775      *
776      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
777      *
778      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
779      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
780      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
781      */
782     function implementation() external ifAdmin returns (address implementation_) {
783         implementation_ = _implementation();
784     }
785 
786     /**
787      * @dev Changes the admin of the proxy.
788      *
789      * Emits an {AdminChanged} event.
790      *
791      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
792      */
793     function changeAdmin(address newAdmin) external virtual ifAdmin {
794         _changeAdmin(newAdmin);
795     }
796 
797     /**
798      * @dev Upgrade the implementation of the proxy.
799      *
800      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
801      */
802     function upgradeTo(address newImplementation) external ifAdmin {
803         _upgradeToAndCall(newImplementation, bytes(""), false);
804     }
805 
806     /**
807      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
808      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
809      * proxied contract.
810      *
811      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
812      */
813     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
814         _upgradeToAndCall(newImplementation, data, true);
815     }
816 
817     /**
818      * @dev Returns the current admin.
819      */
820     function _admin() internal view virtual returns (address) {
821         return _getAdmin();
822     }
823 
824     /**
825      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
826      */
827     function _beforeFallback() internal virtual override {
828         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
829         super._beforeFallback();
830     }
831 }