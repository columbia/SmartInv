1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/transparent/TransparentUpgradeableProxy.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
7 
8 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
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
35             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
36 
37             // Copy the returned data.
38             returndatacopy(0, 0, returndatasize())
39 
40             switch result
41             // delegatecall returns 0 on error.
42             case 0 {
43                 revert(0, returndatasize())
44             }
45             default {
46                 return(0, returndatasize())
47             }
48         }
49     }
50 
51     /**
52      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
53      * and {_fallback} should delegate.
54      */
55     function _implementation() internal view virtual returns (address);
56 
57     /**
58      * @dev Delegates the current call to the address returned by `_implementation()`.
59      *
60      * This function does not return to its internal call site, it will return directly to the external caller.
61      */
62     function _fallback() internal virtual {
63         _beforeFallback();
64         _delegate(_implementation());
65     }
66 
67     /**
68      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
69      * function in the contract matches the call data.
70      */
71     fallback() external payable virtual {
72         _fallback();
73     }
74 
75     /**
76      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
77      * is empty.
78      */
79     receive() external payable virtual {
80         _fallback();
81     }
82 
83     /**
84      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
85      * call, or as part of the Solidity `fallback` or `receive` functions.
86      *
87      * If overridden should call `super._beforeFallback()`.
88      */
89     function _beforeFallback() internal virtual {}
90 }
91 
92 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
93 
94 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
95 
96 /**
97  * @dev This is the interface that {BeaconProxy} expects of its beacon.
98  */
99 interface IBeacon {
100     /**
101      * @dev Must return an address that can be used as a delegate call target.
102      *
103      * {BeaconProxy} will check that this address is a contract.
104      */
105     function implementation() external view returns (address);
106 }
107 
108 /**
109  * @dev ERC-1967: Proxy Storage Slots. This interface contains the events defined in the ERC.
110  *
111  * _Available since v4.9._
112  */
113 interface IERC1967 {
114     /**
115      * @dev Emitted when the implementation is upgraded.
116      */
117     event Upgraded(address indexed implementation);
118 
119     /**
120      * @dev Emitted when the admin account has changed.
121      */
122     event AdminChanged(address previousAdmin, address newAdmin);
123 
124     /**
125      * @dev Emitted when the beacon is changed.
126      */
127     event BeaconUpgraded(address indexed beacon);
128 }
129 
130 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
131 
132 /**
133  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
134  * proxy whose upgrades are fully controlled by the current implementation.
135  */
136 interface IERC1822Proxiable {
137     /**
138      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
139      * address.
140      *
141      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
142      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
143      * function revert if invoked through a proxy.
144      */
145     function proxiableUUID() external view returns (bytes32);
146 }
147 
148 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
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
206      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
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
390 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
391 // This file was procedurally generated from scripts/generate/templates/StorageSlot.js.
392 
393 /**
394  * @dev Library for reading and writing primitive types to specific storage slots.
395  *
396  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
397  * This library helps with reading and writing to such slots without the need for inline assembly.
398  *
399  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
400  *
401  * Example usage to set ERC1967 implementation slot:
402  * ```solidity
403  * contract ERC1967 {
404  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
405  *
406  *     function _getImplementation() internal view returns (address) {
407  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
408  *     }
409  *
410  *     function _setImplementation(address newImplementation) internal {
411  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
412  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
413  *     }
414  * }
415  * ```
416  *
417  * _Available since v4.1 for `address`, `bool`, `bytes32`, `uint256`._
418  * _Available since v4.9 for `string`, `bytes`._
419  */
420 library StorageSlot {
421     struct AddressSlot {
422         address value;
423     }
424 
425     struct BooleanSlot {
426         bool value;
427     }
428 
429     struct Bytes32Slot {
430         bytes32 value;
431     }
432 
433     struct Uint256Slot {
434         uint256 value;
435     }
436 
437     struct StringSlot {
438         string value;
439     }
440 
441     struct BytesSlot {
442         bytes value;
443     }
444 
445     /**
446      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
447      */
448     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
449         /// @solidity memory-safe-assembly
450         assembly {
451             r.slot := slot
452         }
453     }
454 
455     /**
456      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
457      */
458     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
459         /// @solidity memory-safe-assembly
460         assembly {
461             r.slot := slot
462         }
463     }
464 
465     /**
466      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
467      */
468     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
469         /// @solidity memory-safe-assembly
470         assembly {
471             r.slot := slot
472         }
473     }
474 
475     /**
476      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
477      */
478     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
479         /// @solidity memory-safe-assembly
480         assembly {
481             r.slot := slot
482         }
483     }
484 
485     /**
486      * @dev Returns an `StringSlot` with member `value` located at `slot`.
487      */
488     function getStringSlot(bytes32 slot) internal pure returns (StringSlot storage r) {
489         /// @solidity memory-safe-assembly
490         assembly {
491             r.slot := slot
492         }
493     }
494 
495     /**
496      * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
497      */
498     function getStringSlot(string storage store) internal pure returns (StringSlot storage r) {
499         /// @solidity memory-safe-assembly
500         assembly {
501             r.slot := store.slot
502         }
503     }
504 
505     /**
506      * @dev Returns an `BytesSlot` with member `value` located at `slot`.
507      */
508     function getBytesSlot(bytes32 slot) internal pure returns (BytesSlot storage r) {
509         /// @solidity memory-safe-assembly
510         assembly {
511             r.slot := slot
512         }
513     }
514 
515     /**
516      * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
517      */
518     function getBytesSlot(bytes storage store) internal pure returns (BytesSlot storage r) {
519         /// @solidity memory-safe-assembly
520         assembly {
521             r.slot := store.slot
522         }
523     }
524 }
525 
526 /**
527  * @dev This abstract contract provides getters and event emitting update functions for
528  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
529  *
530  * _Available since v4.1._
531  */
532 abstract contract ERC1967Upgrade is IERC1967 {
533     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
534     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
535 
536     /**
537      * @dev Storage slot with the address of the current implementation.
538      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
539      * validated in the constructor.
540      */
541     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
542 
543     /**
544      * @dev Returns the current implementation address.
545      */
546     function _getImplementation() internal view returns (address) {
547         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
548     }
549 
550     /**
551      * @dev Stores a new address in the EIP1967 implementation slot.
552      */
553     function _setImplementation(address newImplementation) private {
554         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
555         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
556     }
557 
558     /**
559      * @dev Perform implementation upgrade
560      *
561      * Emits an {Upgraded} event.
562      */
563     function _upgradeTo(address newImplementation) internal {
564         _setImplementation(newImplementation);
565         emit Upgraded(newImplementation);
566     }
567 
568     /**
569      * @dev Perform implementation upgrade with additional setup call.
570      *
571      * Emits an {Upgraded} event.
572      */
573     function _upgradeToAndCall(address newImplementation, bytes memory data, bool forceCall) internal {
574         _upgradeTo(newImplementation);
575         if (data.length > 0 || forceCall) {
576             Address.functionDelegateCall(newImplementation, data);
577         }
578     }
579 
580     /**
581      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
582      *
583      * Emits an {Upgraded} event.
584      */
585     function _upgradeToAndCallUUPS(address newImplementation, bytes memory data, bool forceCall) internal {
586         // Upgrades from old implementations will perform a rollback test. This test requires the new
587         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
588         // this special case will break upgrade paths from old UUPS implementation to new ones.
589         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
590             _setImplementation(newImplementation);
591         } else {
592             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
593                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
594             } catch {
595                 revert("ERC1967Upgrade: new implementation is not UUPS");
596             }
597             _upgradeToAndCall(newImplementation, data, forceCall);
598         }
599     }
600 
601     /**
602      * @dev Storage slot with the admin of the contract.
603      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
604      * validated in the constructor.
605      */
606     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
607 
608     /**
609      * @dev Returns the current admin.
610      */
611     function _getAdmin() internal view returns (address) {
612         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
613     }
614 
615     /**
616      * @dev Stores a new address in the EIP1967 admin slot.
617      */
618     function _setAdmin(address newAdmin) private {
619         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
620         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
621     }
622 
623     /**
624      * @dev Changes the admin of the proxy.
625      *
626      * Emits an {AdminChanged} event.
627      */
628     function _changeAdmin(address newAdmin) internal {
629         emit AdminChanged(_getAdmin(), newAdmin);
630         _setAdmin(newAdmin);
631     }
632 
633     /**
634      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
635      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
636      */
637     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
638 
639     /**
640      * @dev Returns the current beacon.
641      */
642     function _getBeacon() internal view returns (address) {
643         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
644     }
645 
646     /**
647      * @dev Stores a new beacon in the EIP1967 beacon slot.
648      */
649     function _setBeacon(address newBeacon) private {
650         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
651         require(
652             Address.isContract(IBeacon(newBeacon).implementation()),
653             "ERC1967: beacon implementation is not a contract"
654         );
655         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
656     }
657 
658     /**
659      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
660      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
661      *
662      * Emits a {BeaconUpgraded} event.
663      */
664     function _upgradeBeaconToAndCall(address newBeacon, bytes memory data, bool forceCall) internal {
665         _setBeacon(newBeacon);
666         emit BeaconUpgraded(newBeacon);
667         if (data.length > 0 || forceCall) {
668             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
669         }
670     }
671 }
672 
673 /**
674  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
675  * implementation address that can be changed. This address is stored in storage in the location specified by
676  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
677  * implementation behind the proxy.
678  */
679 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
680     /**
681      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
682      *
683      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
684      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
685      */
686     constructor(address _logic, bytes memory _data) payable {
687         _upgradeToAndCall(_logic, _data, false);
688     }
689 
690     /**
691      * @dev Returns the current implementation address.
692      */
693     function _implementation() internal view virtual override returns (address impl) {
694         return ERC1967Upgrade._getImplementation();
695     }
696 }
697 
698 /**
699  * @dev Interface for {TransparentUpgradeableProxy}. In order to implement transparency, {TransparentUpgradeableProxy}
700  * does not implement this interface directly, and some of its functions are implemented by an internal dispatch
701  * mechanism. The compiler is unaware that these functions are implemented by {TransparentUpgradeableProxy} and will not
702  * include them in the ABI so this interface must be used to interact with it.
703  */
704 interface ITransparentUpgradeableProxy is IERC1967 {
705     function admin() external view returns (address);
706 
707     function implementation() external view returns (address);
708 
709     function changeAdmin(address) external;
710 
711     function upgradeTo(address) external;
712 
713     function upgradeToAndCall(address, bytes memory) external payable;
714 }
715 
716 /**
717  * @dev This contract implements a proxy that is upgradeable by an admin.
718  *
719  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
720  * clashing], which can potentially be used in an attack, this contract uses the
721  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
722  * things that go hand in hand:
723  *
724  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
725  * that call matches one of the admin functions exposed by the proxy itself.
726  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
727  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
728  * "admin cannot fallback to proxy target".
729  *
730  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
731  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
732  * to sudden errors when trying to call a function from the proxy implementation.
733  *
734  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
735  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
736  *
737  * NOTE: The real interface of this proxy is that defined in `ITransparentUpgradeableProxy`. This contract does not
738  * inherit from that interface, and instead the admin functions are implicitly implemented using a custom dispatch
739  * mechanism in `_fallback`. Consequently, the compiler will not produce an ABI for this contract. This is necessary to
740  * fully implement transparency without decoding reverts caused by selector clashes between the proxy and the
741  * implementation.
742  *
743  * WARNING: It is not recommended to extend this contract to add additional external functions. If you do so, the compiler
744  * will not check that there are no selector conflicts, due to the note above. A selector clash between any new function
745  * and the functions declared in {ITransparentUpgradeableProxy} will be resolved in favor of the new one. This could
746  * render the admin operations inaccessible, which could prevent upgradeability. Transparency may also be compromised.
747  */
748 contract TransparentUpgradeableProxy is ERC1967Proxy {
749     /**
750      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
751      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
752      */
753     constructor(address _logic, address admin_, bytes memory _data) payable ERC1967Proxy(_logic, _data) {
754         _changeAdmin(admin_);
755     }
756 
757     /**
758      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
759      *
760      * CAUTION: This modifier is deprecated, as it could cause issues if the modified function has arguments, and the
761      * implementation provides a function with the same selector.
762      */
763     modifier ifAdmin() {
764         if (msg.sender == _getAdmin()) {
765             _;
766         } else {
767             _fallback();
768         }
769     }
770 
771     /**
772      * @dev If caller is the admin process the call internally, otherwise transparently fallback to the proxy behavior
773      */
774     function _fallback() internal virtual override {
775         if (msg.sender == _getAdmin()) {
776             bytes memory ret;
777             bytes4 selector = msg.sig;
778             if (selector == ITransparentUpgradeableProxy.upgradeTo.selector) {
779                 ret = _dispatchUpgradeTo();
780             } else if (selector == ITransparentUpgradeableProxy.upgradeToAndCall.selector) {
781                 ret = _dispatchUpgradeToAndCall();
782             } else if (selector == ITransparentUpgradeableProxy.changeAdmin.selector) {
783                 ret = _dispatchChangeAdmin();
784             } else if (selector == ITransparentUpgradeableProxy.admin.selector) {
785                 ret = _dispatchAdmin();
786             } else if (selector == ITransparentUpgradeableProxy.implementation.selector) {
787                 ret = _dispatchImplementation();
788             } else {
789                 revert("TransparentUpgradeableProxy: admin cannot fallback to proxy target");
790             }
791             assembly {
792                 return(add(ret, 0x20), mload(ret))
793             }
794         } else {
795             super._fallback();
796         }
797     }
798 
799     /**
800      * @dev Returns the current admin.
801      *
802      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
803      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
804      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
805      */
806     function _dispatchAdmin() private returns (bytes memory) {
807         _requireZeroValue();
808 
809         address admin = _getAdmin();
810         return abi.encode(admin);
811     }
812 
813     /**
814      * @dev Returns the current implementation.
815      *
816      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
817      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
818      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
819      */
820     function _dispatchImplementation() private returns (bytes memory) {
821         _requireZeroValue();
822 
823         address implementation = _implementation();
824         return abi.encode(implementation);
825     }
826 
827     /**
828      * @dev Changes the admin of the proxy.
829      *
830      * Emits an {AdminChanged} event.
831      */
832     function _dispatchChangeAdmin() private returns (bytes memory) {
833         _requireZeroValue();
834 
835         address newAdmin = abi.decode(msg.data[4:], (address));
836         _changeAdmin(newAdmin);
837 
838         return "";
839     }
840 
841     /**
842      * @dev Upgrade the implementation of the proxy.
843      */
844     function _dispatchUpgradeTo() private returns (bytes memory) {
845         _requireZeroValue();
846 
847         address newImplementation = abi.decode(msg.data[4:], (address));
848         _upgradeToAndCall(newImplementation, bytes(""), false);
849 
850         return "";
851     }
852 
853     /**
854      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
855      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
856      * proxied contract.
857      */
858     function _dispatchUpgradeToAndCall() private returns (bytes memory) {
859         (address newImplementation, bytes memory data) = abi.decode(msg.data[4:], (address, bytes));
860         _upgradeToAndCall(newImplementation, data, true);
861 
862         return "";
863     }
864 
865     /**
866      * @dev Returns the current admin.
867      */
868     function _admin() internal view virtual returns (address) {
869         return _getAdmin();
870     }
871 
872     /**
873      * @dev To keep this contract fully transparent, all `ifAdmin` functions must be payable. This helper is here to
874      * emulate some proxy functions being non-payable while still allowing value to pass through.
875      */
876     function _requireZeroValue() private {
877         require(msg.value == 0);
878     }
879 }