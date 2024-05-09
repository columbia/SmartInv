1 // File: .deps/npm/@openzeppelin/contracts/utils/StorageSlot.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.9.0) (utils/StorageSlot.sol)
5 // This file was procedurally generated from scripts/generate/templates/StorageSlot.js.
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
18  * ```solidity
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
33  * _Available since v4.1 for `address`, `bool`, `bytes32`, `uint256`._
34  * _Available since v4.9 for `string`, `bytes`._
35  */
36 library StorageSlot {
37     struct AddressSlot {
38         address value;
39     }
40 
41     struct BooleanSlot {
42         bool value;
43     }
44 
45     struct Bytes32Slot {
46         bytes32 value;
47     }
48 
49     struct Uint256Slot {
50         uint256 value;
51     }
52 
53     struct StringSlot {
54         string value;
55     }
56 
57     struct BytesSlot {
58         bytes value;
59     }
60 
61     /**
62      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
63      */
64     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
65         /// @solidity memory-safe-assembly
66         assembly {
67             r.slot := slot
68         }
69     }
70 
71     /**
72      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
73      */
74     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
75         /// @solidity memory-safe-assembly
76         assembly {
77             r.slot := slot
78         }
79     }
80 
81     /**
82      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
83      */
84     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
85         /// @solidity memory-safe-assembly
86         assembly {
87             r.slot := slot
88         }
89     }
90 
91     /**
92      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
93      */
94     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
95         /// @solidity memory-safe-assembly
96         assembly {
97             r.slot := slot
98         }
99     }
100 
101     /**
102      * @dev Returns an `StringSlot` with member `value` located at `slot`.
103      */
104     function getStringSlot(bytes32 slot) internal pure returns (StringSlot storage r) {
105         /// @solidity memory-safe-assembly
106         assembly {
107             r.slot := slot
108         }
109     }
110 
111     /**
112      * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
113      */
114     function getStringSlot(string storage store) internal pure returns (StringSlot storage r) {
115         /// @solidity memory-safe-assembly
116         assembly {
117             r.slot := store.slot
118         }
119     }
120 
121     /**
122      * @dev Returns an `BytesSlot` with member `value` located at `slot`.
123      */
124     function getBytesSlot(bytes32 slot) internal pure returns (BytesSlot storage r) {
125         /// @solidity memory-safe-assembly
126         assembly {
127             r.slot := slot
128         }
129     }
130 
131     /**
132      * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
133      */
134     function getBytesSlot(bytes storage store) internal pure returns (BytesSlot storage r) {
135         /// @solidity memory-safe-assembly
136         assembly {
137             r.slot := store.slot
138         }
139     }
140 }
141 
142 // File: .deps/npm/@openzeppelin/contracts/utils/Address.sol
143 
144 
145 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
146 
147 pragma solidity ^0.8.1;
148 
149 /**
150  * @dev Collection of functions related to the address type
151  */
152 library Address {
153     /**
154      * @dev Returns true if `account` is a contract.
155      *
156      * [IMPORTANT]
157      * ====
158      * It is unsafe to assume that an address for which this function returns
159      * false is an externally-owned account (EOA) and not a contract.
160      *
161      * Among others, `isContract` will return false for the following
162      * types of addresses:
163      *
164      *  - an externally-owned account
165      *  - a contract in construction
166      *  - an address where a contract will be created
167      *  - an address where a contract lived, but was destroyed
168      *
169      * Furthermore, `isContract` will also return true if the target contract within
170      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
171      * which only has an effect at the end of a transaction.
172      * ====
173      *
174      * [IMPORTANT]
175      * ====
176      * You shouldn't rely on `isContract` to protect against flash loan attacks!
177      *
178      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
179      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
180      * constructor.
181      * ====
182      */
183     function isContract(address account) internal view returns (bool) {
184         // This method relies on extcodesize/address.code.length, which returns 0
185         // for contracts in construction, since the code is only stored at the end
186         // of the constructor execution.
187 
188         return account.code.length > 0;
189     }
190 
191     /**
192      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
193      * `recipient`, forwarding all available gas and reverting on errors.
194      *
195      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
196      * of certain opcodes, possibly making contracts go over the 2300 gas limit
197      * imposed by `transfer`, making them unable to receive funds via
198      * `transfer`. {sendValue} removes this limitation.
199      *
200      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
201      *
202      * IMPORTANT: because control is transferred to `recipient`, care must be
203      * taken to not create reentrancy vulnerabilities. Consider using
204      * {ReentrancyGuard} or the
205      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
206      */
207     function sendValue(address payable recipient, uint256 amount) internal {
208         require(address(this).balance >= amount, "Address: insufficient balance");
209 
210         (bool success, ) = recipient.call{value: amount}("");
211         require(success, "Address: unable to send value, recipient may have reverted");
212     }
213 
214     /**
215      * @dev Performs a Solidity function call using a low level `call`. A
216      * plain `call` is an unsafe replacement for a function call: use this
217      * function instead.
218      *
219      * If `target` reverts with a revert reason, it is bubbled up by this
220      * function (like regular Solidity function calls).
221      *
222      * Returns the raw returned data. To convert to the expected return value,
223      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
224      *
225      * Requirements:
226      *
227      * - `target` must be a contract.
228      * - calling `target` with `data` must not revert.
229      *
230      * _Available since v3.1._
231      */
232     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
233         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
238      * `errorMessage` as a fallback revert reason when `target` reverts.
239      *
240      * _Available since v3.1._
241      */
242     function functionCall(
243         address target,
244         bytes memory data,
245         string memory errorMessage
246     ) internal returns (bytes memory) {
247         return functionCallWithValue(target, data, 0, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but also transferring `value` wei to `target`.
253      *
254      * Requirements:
255      *
256      * - the calling contract must have an ETH balance of at least `value`.
257      * - the called Solidity function must be `payable`.
258      *
259      * _Available since v3.1._
260      */
261     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
262         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
267      * with `errorMessage` as a fallback revert reason when `target` reverts.
268      *
269      * _Available since v3.1._
270      */
271     function functionCallWithValue(
272         address target,
273         bytes memory data,
274         uint256 value,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         require(address(this).balance >= value, "Address: insufficient balance for call");
278         (bool success, bytes memory returndata) = target.call{value: value}(data);
279         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
284      * but performing a static call.
285      *
286      * _Available since v3.3._
287      */
288     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
289         return functionStaticCall(target, data, "Address: low-level static call failed");
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
294      * but performing a static call.
295      *
296      * _Available since v3.3._
297      */
298     function functionStaticCall(
299         address target,
300         bytes memory data,
301         string memory errorMessage
302     ) internal view returns (bytes memory) {
303         (bool success, bytes memory returndata) = target.staticcall(data);
304         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
309      * but performing a delegate call.
310      *
311      * _Available since v3.4._
312      */
313     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
314         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
319      * but performing a delegate call.
320      *
321      * _Available since v3.4._
322      */
323     function functionDelegateCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         (bool success, bytes memory returndata) = target.delegatecall(data);
329         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
330     }
331 
332     /**
333      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
334      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
335      *
336      * _Available since v4.8._
337      */
338     function verifyCallResultFromTarget(
339         address target,
340         bool success,
341         bytes memory returndata,
342         string memory errorMessage
343     ) internal view returns (bytes memory) {
344         if (success) {
345             if (returndata.length == 0) {
346                 // only check isContract if the call was successful and the return data is empty
347                 // otherwise we already know that it was a contract
348                 require(isContract(target), "Address: call to non-contract");
349             }
350             return returndata;
351         } else {
352             _revert(returndata, errorMessage);
353         }
354     }
355 
356     /**
357      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
358      * revert reason or using the provided one.
359      *
360      * _Available since v4.3._
361      */
362     function verifyCallResult(
363         bool success,
364         bytes memory returndata,
365         string memory errorMessage
366     ) internal pure returns (bytes memory) {
367         if (success) {
368             return returndata;
369         } else {
370             _revert(returndata, errorMessage);
371         }
372     }
373 
374     function _revert(bytes memory returndata, string memory errorMessage) private pure {
375         // Look for revert reason and bubble it up if present
376         if (returndata.length > 0) {
377             // The easiest way to bubble the revert reason is using memory via assembly
378             /// @solidity memory-safe-assembly
379             assembly {
380                 let returndata_size := mload(returndata)
381                 revert(add(32, returndata), returndata_size)
382             }
383         } else {
384             revert(errorMessage);
385         }
386     }
387 }
388 
389 // File: .deps/npm/@openzeppelin/contracts/interfaces/draft-IERC1822.sol
390 
391 
392 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
398  * proxy whose upgrades are fully controlled by the current implementation.
399  */
400 interface IERC1822Proxiable {
401     /**
402      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
403      * address.
404      *
405      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
406      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
407      * function revert if invoked through a proxy.
408      */
409     function proxiableUUID() external view returns (bytes32);
410 }
411 
412 // File: .deps/npm/@openzeppelin/contracts/interfaces/IERC1967.sol
413 
414 
415 // OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC1967.sol)
416 
417 pragma solidity ^0.8.0;
418 
419 /**
420  * @dev ERC-1967: Proxy Storage Slots. This interface contains the events defined in the ERC.
421  *
422  * _Available since v4.8.3._
423  */
424 interface IERC1967 {
425     /**
426      * @dev Emitted when the implementation is upgraded.
427      */
428     event Upgraded(address indexed implementation);
429 
430     /**
431      * @dev Emitted when the admin account has changed.
432      */
433     event AdminChanged(address previousAdmin, address newAdmin);
434 
435     /**
436      * @dev Emitted when the beacon is changed.
437      */
438     event BeaconUpgraded(address indexed beacon);
439 }
440 
441 // File: .deps/npm/@openzeppelin/contracts/proxy/beacon/IBeacon.sol
442 
443 
444 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
445 
446 pragma solidity ^0.8.0;
447 
448 /**
449  * @dev This is the interface that {BeaconProxy} expects of its beacon.
450  */
451 interface IBeacon {
452     /**
453      * @dev Must return an address that can be used as a delegate call target.
454      *
455      * {BeaconProxy} will check that this address is a contract.
456      */
457     function implementation() external view returns (address);
458 }
459 
460 // File: .deps/npm/@openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol
461 
462 
463 // OpenZeppelin Contracts (last updated v4.9.0) (proxy/ERC1967/ERC1967Upgrade.sol)
464 
465 pragma solidity ^0.8.2;
466 
467 
468 
469 
470 
471 
472 /**
473  * @dev This abstract contract provides getters and event emitting update functions for
474  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
475  *
476  * _Available since v4.1._
477  */
478 abstract contract ERC1967Upgrade is IERC1967 {
479     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
480     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
481 
482     /**
483      * @dev Storage slot with the address of the current implementation.
484      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
485      * validated in the constructor.
486      */
487     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
488 
489     /**
490      * @dev Returns the current implementation address.
491      */
492     function _getImplementation() internal view returns (address) {
493         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
494     }
495 
496     /**
497      * @dev Stores a new address in the EIP1967 implementation slot.
498      */
499     function _setImplementation(address newImplementation) private {
500         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
501         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
502     }
503 
504     /**
505      * @dev Perform implementation upgrade
506      *
507      * Emits an {Upgraded} event.
508      */
509     function _upgradeTo(address newImplementation) internal {
510         _setImplementation(newImplementation);
511         emit Upgraded(newImplementation);
512     }
513 
514     /**
515      * @dev Perform implementation upgrade with additional setup call.
516      *
517      * Emits an {Upgraded} event.
518      */
519     function _upgradeToAndCall(address newImplementation, bytes memory data, bool forceCall) internal {
520         _upgradeTo(newImplementation);
521         if (data.length > 0 || forceCall) {
522             Address.functionDelegateCall(newImplementation, data);
523         }
524     }
525 
526     /**
527      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
528      *
529      * Emits an {Upgraded} event.
530      */
531     function _upgradeToAndCallUUPS(address newImplementation, bytes memory data, bool forceCall) internal {
532         // Upgrades from old implementations will perform a rollback test. This test requires the new
533         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
534         // this special case will break upgrade paths from old UUPS implementation to new ones.
535         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
536             _setImplementation(newImplementation);
537         } else {
538             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
539                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
540             } catch {
541                 revert("ERC1967Upgrade: new implementation is not UUPS");
542             }
543             _upgradeToAndCall(newImplementation, data, forceCall);
544         }
545     }
546 
547     /**
548      * @dev Storage slot with the admin of the contract.
549      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
550      * validated in the constructor.
551      */
552     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
553 
554     /**
555      * @dev Returns the current admin.
556      */
557     function _getAdmin() internal view returns (address) {
558         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
559     }
560 
561     /**
562      * @dev Stores a new address in the EIP1967 admin slot.
563      */
564     function _setAdmin(address newAdmin) private {
565         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
566         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
567     }
568 
569     /**
570      * @dev Changes the admin of the proxy.
571      *
572      * Emits an {AdminChanged} event.
573      */
574     function _changeAdmin(address newAdmin) internal {
575         emit AdminChanged(_getAdmin(), newAdmin);
576         _setAdmin(newAdmin);
577     }
578 
579     /**
580      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
581      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
582      */
583     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
584 
585     /**
586      * @dev Returns the current beacon.
587      */
588     function _getBeacon() internal view returns (address) {
589         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
590     }
591 
592     /**
593      * @dev Stores a new beacon in the EIP1967 beacon slot.
594      */
595     function _setBeacon(address newBeacon) private {
596         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
597         require(
598             Address.isContract(IBeacon(newBeacon).implementation()),
599             "ERC1967: beacon implementation is not a contract"
600         );
601         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
602     }
603 
604     /**
605      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
606      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
607      *
608      * Emits a {BeaconUpgraded} event.
609      */
610     function _upgradeBeaconToAndCall(address newBeacon, bytes memory data, bool forceCall) internal {
611         _setBeacon(newBeacon);
612         emit BeaconUpgraded(newBeacon);
613         if (data.length > 0 || forceCall) {
614             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
615         }
616     }
617 }
618 
619 // File: .deps/npm/@openzeppelin/contracts/proxy/Proxy.sol
620 
621 
622 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
623 
624 pragma solidity ^0.8.0;
625 
626 /**
627  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
628  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
629  * be specified by overriding the virtual {_implementation} function.
630  *
631  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
632  * different contract through the {_delegate} function.
633  *
634  * The success and return data of the delegated call will be returned back to the caller of the proxy.
635  */
636 abstract contract Proxy {
637     /**
638      * @dev Delegates the current call to `implementation`.
639      *
640      * This function does not return to its internal call site, it will return directly to the external caller.
641      */
642     function _delegate(address implementation) internal virtual {
643         assembly {
644             // Copy msg.data. We take full control of memory in this inline assembly
645             // block because it will not return to Solidity code. We overwrite the
646             // Solidity scratch pad at memory position 0.
647             calldatacopy(0, 0, calldatasize())
648 
649             // Call the implementation.
650             // out and outsize are 0 because we don't know the size yet.
651             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
652 
653             // Copy the returned data.
654             returndatacopy(0, 0, returndatasize())
655 
656             switch result
657             // delegatecall returns 0 on error.
658             case 0 {
659                 revert(0, returndatasize())
660             }
661             default {
662                 return(0, returndatasize())
663             }
664         }
665     }
666 
667     /**
668      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
669      * and {_fallback} should delegate.
670      */
671     function _implementation() internal view virtual returns (address);
672 
673     /**
674      * @dev Delegates the current call to the address returned by `_implementation()`.
675      *
676      * This function does not return to its internal call site, it will return directly to the external caller.
677      */
678     function _fallback() internal virtual {
679         _beforeFallback();
680         _delegate(_implementation());
681     }
682 
683     /**
684      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
685      * function in the contract matches the call data.
686      */
687     fallback() external payable virtual {
688         _fallback();
689     }
690 
691     /**
692      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
693      * is empty.
694      */
695     receive() external payable virtual {
696         _fallback();
697     }
698 
699     /**
700      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
701      * call, or as part of the Solidity `fallback` or `receive` functions.
702      *
703      * If overridden should call `super._beforeFallback()`.
704      */
705     function _beforeFallback() internal virtual {}
706 }
707 
708 // File: .deps/npm/@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol
709 
710 
711 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 
716 
717 /**
718  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
719  * implementation address that can be changed. This address is stored in storage in the location specified by
720  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
721  * implementation behind the proxy.
722  */
723 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
724     /**
725      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
726      *
727      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
728      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
729      */
730     constructor(address _logic, bytes memory _data) payable {
731         _upgradeToAndCall(_logic, _data, false);
732     }
733 
734     /**
735      * @dev Returns the current implementation address.
736      */
737     function _implementation() internal view virtual override returns (address impl) {
738         return ERC1967Upgrade._getImplementation();
739     }
740 }
741 
742 // File: .deps/npm/@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol
743 
744 
745 // OpenZeppelin Contracts (last updated v4.9.0) (proxy/transparent/TransparentUpgradeableProxy.sol)
746 
747 pragma solidity ^0.8.0;
748 
749 
750 /**
751  * @dev Interface for {TransparentUpgradeableProxy}. In order to implement transparency, {TransparentUpgradeableProxy}
752  * does not implement this interface directly, and some of its functions are implemented by an internal dispatch
753  * mechanism. The compiler is unaware that these functions are implemented by {TransparentUpgradeableProxy} and will not
754  * include them in the ABI so this interface must be used to interact with it.
755  */
756 interface ITransparentUpgradeableProxy is IERC1967 {
757     function admin() external view returns (address);
758 
759     function implementation() external view returns (address);
760 
761     function changeAdmin(address) external;
762 
763     function upgradeTo(address) external;
764 
765     function upgradeToAndCall(address, bytes memory) external payable;
766 }
767 
768 /**
769  * @dev This contract implements a proxy that is upgradeable by an admin.
770  *
771  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
772  * clashing], which can potentially be used in an attack, this contract uses the
773  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
774  * things that go hand in hand:
775  *
776  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
777  * that call matches one of the admin functions exposed by the proxy itself.
778  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
779  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
780  * "admin cannot fallback to proxy target".
781  *
782  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
783  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
784  * to sudden errors when trying to call a function from the proxy implementation.
785  *
786  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
787  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
788  *
789  * NOTE: The real interface of this proxy is that defined in `ITransparentUpgradeableProxy`. This contract does not
790  * inherit from that interface, and instead the admin functions are implicitly implemented using a custom dispatch
791  * mechanism in `_fallback`. Consequently, the compiler will not produce an ABI for this contract. This is necessary to
792  * fully implement transparency without decoding reverts caused by selector clashes between the proxy and the
793  * implementation.
794  *
795  * WARNING: It is not recommended to extend this contract to add additional external functions. If you do so, the compiler
796  * will not check that there are no selector conflicts, due to the note above. A selector clash between any new function
797  * and the functions declared in {ITransparentUpgradeableProxy} will be resolved in favor of the new one. This could
798  * render the admin operations inaccessible, which could prevent upgradeability. Transparency may also be compromised.
799  */
800 contract TransparentUpgradeableProxy is ERC1967Proxy {
801     /**
802      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
803      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
804      */
805     constructor(address _logic, address admin_, bytes memory _data) payable ERC1967Proxy(_logic, _data) {
806         _changeAdmin(admin_);
807     }
808 
809     /**
810      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
811      *
812      * CAUTION: This modifier is deprecated, as it could cause issues if the modified function has arguments, and the
813      * implementation provides a function with the same selector.
814      */
815     modifier ifAdmin() {
816         if (msg.sender == _getAdmin()) {
817             _;
818         } else {
819             _fallback();
820         }
821     }
822 
823     /**
824      * @dev If caller is the admin process the call internally, otherwise transparently fallback to the proxy behavior
825      */
826     function _fallback() internal virtual override {
827         if (msg.sender == _getAdmin()) {
828             bytes memory ret;
829             bytes4 selector = msg.sig;
830             if (selector == ITransparentUpgradeableProxy.upgradeTo.selector) {
831                 ret = _dispatchUpgradeTo();
832             } else if (selector == ITransparentUpgradeableProxy.upgradeToAndCall.selector) {
833                 ret = _dispatchUpgradeToAndCall();
834             } else if (selector == ITransparentUpgradeableProxy.changeAdmin.selector) {
835                 ret = _dispatchChangeAdmin();
836             } else if (selector == ITransparentUpgradeableProxy.admin.selector) {
837                 ret = _dispatchAdmin();
838             } else if (selector == ITransparentUpgradeableProxy.implementation.selector) {
839                 ret = _dispatchImplementation();
840             } else {
841                 revert("TransparentUpgradeableProxy: admin cannot fallback to proxy target");
842             }
843             assembly {
844                 return(add(ret, 0x20), mload(ret))
845             }
846         } else {
847             super._fallback();
848         }
849     }
850 
851     /**
852      * @dev Returns the current admin.
853      *
854      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
855      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
856      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
857      */
858     function _dispatchAdmin() private returns (bytes memory) {
859         _requireZeroValue();
860 
861         address admin = _getAdmin();
862         return abi.encode(admin);
863     }
864 
865     /**
866      * @dev Returns the current implementation.
867      *
868      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
869      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
870      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
871      */
872     function _dispatchImplementation() private returns (bytes memory) {
873         _requireZeroValue();
874 
875         address implementation = _implementation();
876         return abi.encode(implementation);
877     }
878 
879     /**
880      * @dev Changes the admin of the proxy.
881      *
882      * Emits an {AdminChanged} event.
883      */
884     function _dispatchChangeAdmin() private returns (bytes memory) {
885         _requireZeroValue();
886 
887         address newAdmin = abi.decode(msg.data[4:], (address));
888         _changeAdmin(newAdmin);
889 
890         return "";
891     }
892 
893     /**
894      * @dev Upgrade the implementation of the proxy.
895      */
896     function _dispatchUpgradeTo() private returns (bytes memory) {
897         _requireZeroValue();
898 
899         address newImplementation = abi.decode(msg.data[4:], (address));
900         _upgradeToAndCall(newImplementation, bytes(""), false);
901 
902         return "";
903     }
904 
905     /**
906      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
907      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
908      * proxied contract.
909      */
910     function _dispatchUpgradeToAndCall() private returns (bytes memory) {
911         (address newImplementation, bytes memory data) = abi.decode(msg.data[4:], (address, bytes));
912         _upgradeToAndCall(newImplementation, data, true);
913 
914         return "";
915     }
916 
917     /**
918      * @dev Returns the current admin.
919      *
920      * CAUTION: This function is deprecated. Use {ERC1967Upgrade-_getAdmin} instead.
921      */
922     function _admin() internal view virtual returns (address) {
923         return _getAdmin();
924     }
925 
926     /**
927      * @dev To keep this contract fully transparent, all `ifAdmin` functions must be payable. This helper is here to
928      * emulate some proxy functions being non-payable while still allowing value to pass through.
929      */
930     function _requireZeroValue() private {
931         require(msg.value == 0);
932     }
933 }