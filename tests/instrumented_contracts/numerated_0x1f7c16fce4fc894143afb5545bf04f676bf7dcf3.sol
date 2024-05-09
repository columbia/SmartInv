1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
3 
4 pragma solidity ^0.8.1;
5 
6 /**
7  * @dev Collection of functions related to the address type
8  */
9 library Address {
10     /**
11      * @dev Returns true if `account` is a contract.
12      *
13      * [IMPORTANT]
14      * ====
15      * It is unsafe to assume that an address for which this function returns
16      * false is an externally-owned account (EOA) and not a contract.
17      *
18      * Among others, `isContract` will return false for the following
19      * types of addresses:
20      *
21      *  - an externally-owned account
22      *  - a contract in construction
23      *  - an address where a contract will be created
24      *  - an address where a contract lived, but was destroyed
25      *
26      * Furthermore, `isContract` will also return true if the target contract within
27      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
28      * which only has an effect at the end of a transaction.
29      * ====
30      *
31      * [IMPORTANT]
32      * ====
33      * You shouldn't rely on `isContract` to protect against flash loan attacks!
34      *
35      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
36      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
37      * constructor.
38      * ====
39      */
40     function isContract(address account) internal view returns (bool) {
41         // This method relies on extcodesize/address.code.length, which returns 0
42         // for contracts in construction, since the code is only stored at the end
43         // of the constructor execution.
44 
45         return account.code.length > 0;
46     }
47 
48     /**
49      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
50      * `recipient`, forwarding all available gas and reverting on errors.
51      *
52      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
53      * of certain opcodes, possibly making contracts go over the 2300 gas limit
54      * imposed by `transfer`, making them unable to receive funds via
55      * `transfer`. {sendValue} removes this limitation.
56      *
57      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
58      *
59      * IMPORTANT: because control is transferred to `recipient`, care must be
60      * taken to not create reentrancy vulnerabilities. Consider using
61      * {ReentrancyGuard} or the
62      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
63      */
64     function sendValue(address payable recipient, uint256 amount) internal {
65         require(address(this).balance >= amount, "Address: insufficient balance");
66 
67         (bool success, ) = recipient.call{value: amount}("");
68         require(success, "Address: unable to send value, recipient may have reverted");
69     }
70 
71     /**
72      * @dev Performs a Solidity function call using a low level `call`. A
73      * plain `call` is an unsafe replacement for a function call: use this
74      * function instead.
75      *
76      * If `target` reverts with a revert reason, it is bubbled up by this
77      * function (like regular Solidity function calls).
78      *
79      * Returns the raw returned data. To convert to the expected return value,
80      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
81      *
82      * Requirements:
83      *
84      * - `target` must be a contract.
85      * - calling `target` with `data` must not revert.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
90         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
95      * `errorMessage` as a fallback revert reason when `target` reverts.
96      *
97      * _Available since v3.1._
98      */
99     function functionCall(
100         address target,
101         bytes memory data,
102         string memory errorMessage
103     ) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, 0, errorMessage);
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
109      * but also transferring `value` wei to `target`.
110      *
111      * Requirements:
112      *
113      * - the calling contract must have an ETH balance of at least `value`.
114      * - the called Solidity function must be `payable`.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
119         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
120     }
121 
122     /**
123      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
124      * with `errorMessage` as a fallback revert reason when `target` reverts.
125      *
126      * _Available since v3.1._
127      */
128     function functionCallWithValue(
129         address target,
130         bytes memory data,
131         uint256 value,
132         string memory errorMessage
133     ) internal returns (bytes memory) {
134         require(address(this).balance >= value, "Address: insufficient balance for call");
135         (bool success, bytes memory returndata) = target.call{value: value}(data);
136         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
141      * but performing a static call.
142      *
143      * _Available since v3.3._
144      */
145     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
146         return functionStaticCall(target, data, "Address: low-level static call failed");
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
151      * but performing a static call.
152      *
153      * _Available since v3.3._
154      */
155     function functionStaticCall(
156         address target,
157         bytes memory data,
158         string memory errorMessage
159     ) internal view returns (bytes memory) {
160         (bool success, bytes memory returndata) = target.staticcall(data);
161         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
166      * but performing a delegate call.
167      *
168      * _Available since v3.4._
169      */
170     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
171         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
176      * but performing a delegate call.
177      *
178      * _Available since v3.4._
179      */
180     function functionDelegateCall(
181         address target,
182         bytes memory data,
183         string memory errorMessage
184     ) internal returns (bytes memory) {
185         (bool success, bytes memory returndata) = target.delegatecall(data);
186         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
187     }
188 
189     /**
190      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
191      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
192      *
193      * _Available since v4.8._
194      */
195     function verifyCallResultFromTarget(
196         address target,
197         bool success,
198         bytes memory returndata,
199         string memory errorMessage
200     ) internal view returns (bytes memory) {
201         if (success) {
202             if (returndata.length == 0) {
203                 // only check isContract if the call was successful and the return data is empty
204                 // otherwise we already know that it was a contract
205                 require(isContract(target), "Address: call to non-contract");
206             }
207             return returndata;
208         } else {
209             _revert(returndata, errorMessage);
210         }
211     }
212 
213     /**
214      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
215      * revert reason or using the provided one.
216      *
217      * _Available since v4.3._
218      */
219     function verifyCallResult(
220         bool success,
221         bytes memory returndata,
222         string memory errorMessage
223     ) internal pure returns (bytes memory) {
224         if (success) {
225             return returndata;
226         } else {
227             _revert(returndata, errorMessage);
228         }
229     }
230 
231     function _revert(bytes memory returndata, string memory errorMessage) private pure {
232         // Look for revert reason and bubble it up if present
233         if (returndata.length > 0) {
234             // The easiest way to bubble the revert reason is using memory via assembly
235             /// @solidity memory-safe-assembly
236             assembly {
237                 let returndata_size := mload(returndata)
238                 revert(add(32, returndata), returndata_size)
239             }
240         } else {
241             revert(errorMessage);
242         }
243     }
244 }
245 
246 // OpenZeppelin Contracts (last updated v4.9.0) (utils/StorageSlot.sol)
247 // This file was procedurally generated from scripts/generate/templates/StorageSlot.js.
248 
249 pragma solidity ^0.8.0;
250 
251 /**
252  * @dev Library for reading and writing primitive types to specific storage slots.
253  *
254  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
255  * This library helps with reading and writing to such slots without the need for inline assembly.
256  *
257  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
258  *
259  * Example usage to set ERC1967 implementation slot:
260  * ```solidity
261  * contract ERC1967 {
262  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
263  *
264  *     function _getImplementation() internal view returns (address) {
265  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
266  *     }
267  *
268  *     function _setImplementation(address newImplementation) internal {
269  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
270  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
271  *     }
272  * }
273  * ```
274  *
275  * _Available since v4.1 for `address`, `bool`, `bytes32`, `uint256`._
276  * _Available since v4.9 for `string`, `bytes`._
277  */
278 library StorageSlot {
279     struct AddressSlot {
280         address value;
281     }
282 
283     struct BooleanSlot {
284         bool value;
285     }
286 
287     struct Bytes32Slot {
288         bytes32 value;
289     }
290 
291     struct Uint256Slot {
292         uint256 value;
293     }
294 
295     struct StringSlot {
296         string value;
297     }
298 
299     struct BytesSlot {
300         bytes value;
301     }
302 
303     /**
304      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
305      */
306     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
307         /// @solidity memory-safe-assembly
308         assembly {
309             r.slot := slot
310         }
311     }
312 
313     /**
314      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
315      */
316     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
317         /// @solidity memory-safe-assembly
318         assembly {
319             r.slot := slot
320         }
321     }
322 
323     /**
324      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
325      */
326     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
327         /// @solidity memory-safe-assembly
328         assembly {
329             r.slot := slot
330         }
331     }
332 
333     /**
334      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
335      */
336     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
337         /// @solidity memory-safe-assembly
338         assembly {
339             r.slot := slot
340         }
341     }
342 
343     /**
344      * @dev Returns an `StringSlot` with member `value` located at `slot`.
345      */
346     function getStringSlot(bytes32 slot) internal pure returns (StringSlot storage r) {
347         /// @solidity memory-safe-assembly
348         assembly {
349             r.slot := slot
350         }
351     }
352 
353     /**
354      * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
355      */
356     function getStringSlot(string storage store) internal pure returns (StringSlot storage r) {
357         /// @solidity memory-safe-assembly
358         assembly {
359             r.slot := store.slot
360         }
361     }
362 
363     /**
364      * @dev Returns an `BytesSlot` with member `value` located at `slot`.
365      */
366     function getBytesSlot(bytes32 slot) internal pure returns (BytesSlot storage r) {
367         /// @solidity memory-safe-assembly
368         assembly {
369             r.slot := slot
370         }
371     }
372 
373     /**
374      * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
375      */
376     function getBytesSlot(bytes storage store) internal pure returns (BytesSlot storage r) {
377         /// @solidity memory-safe-assembly
378         assembly {
379             r.slot := store.slot
380         }
381     }
382 }
383 
384 pragma solidity ^0.8.0;
385 
386 /**
387  * @dev This is the interface that {BeaconProxy} expects of its beacon.
388  */
389 interface IBeacon {
390     /**
391      * @dev Must return an address that can be used as a delegate call target.
392      *
393      * {BeaconProxy} will check that this address is a contract.
394      */
395     function implementation() external view returns (address);
396 }
397 
398 
399 // OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC1967.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 /**
404  * @dev ERC-1967: Proxy Storage Slots. This interface contains the events defined in the ERC.
405  *
406  * _Available since v4.8.3._
407  */
408 interface IERC1967 {
409     /**
410      * @dev Emitted when the implementation is upgraded.
411      */
412     event Upgraded(address indexed implementation);
413 
414     /**
415      * @dev Emitted when the admin account has changed.
416      */
417     event AdminChanged(address previousAdmin, address newAdmin);
418 
419     /**
420      * @dev Emitted when the beacon is changed.
421      */
422     event BeaconUpgraded(address indexed beacon);
423 }
424 
425 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
426 
427 pragma solidity ^0.8.0;
428 
429 /**
430  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
431  * proxy whose upgrades are fully controlled by the current implementation.
432  */
433 interface IERC1822Proxiable {
434     /**
435      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
436      * address.
437      *
438      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
439      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
440      * function revert if invoked through a proxy.
441      */
442     function proxiableUUID() external view returns (bytes32);
443 }
444 
445 
446 // OpenZeppelin Contracts (last updated v4.9.0) (proxy/transparent/TransparentUpgradeableProxy.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 /**
451  * @dev Interface for {TransparentUpgradeableProxy}. In order to implement transparency, {TransparentUpgradeableProxy}
452  * does not implement this interface directly, and some of its functions are implemented by an internal dispatch
453  * mechanism. The compiler is unaware that these functions are implemented by {TransparentUpgradeableProxy} and will not
454  * include them in the ABI so this interface must be used to interact with it.
455  */
456 interface ITransparentUpgradeableProxy is IERC1967 {
457     function admin() external view returns (address);
458 
459     function implementation() external view returns (address);
460 
461     function changeAdmin(address) external;
462 
463     function upgradeTo(address) external;
464 
465     function upgradeToAndCall(address, bytes memory) external payable;
466 }
467 
468 // OpenZeppelin Contracts (last updated v4.9.0) (proxy/ERC1967/ERC1967Upgrade.sol)
469 
470 pragma solidity ^0.8.2;
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
619 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
620 
621 pragma solidity ^0.8.0;
622 
623 /**
624  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
625  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
626  * be specified by overriding the virtual {_implementation} function.
627  *
628  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
629  * different contract through the {_delegate} function.
630  *
631  * The success and return data of the delegated call will be returned back to the caller of the proxy.
632  */
633 abstract contract Proxy {
634     /**
635      * @dev Delegates the current call to `implementation`.
636      *
637      * This function does not return to its internal call site, it will return directly to the external caller.
638      */
639     function _delegate(address implementation) internal virtual {
640         assembly {
641             // Copy msg.data. We take full control of memory in this inline assembly
642             // block because it will not return to Solidity code. We overwrite the
643             // Solidity scratch pad at memory position 0.
644             calldatacopy(0, 0, calldatasize())
645 
646             // Call the implementation.
647             // out and outsize are 0 because we don't know the size yet.
648             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
649 
650             // Copy the returned data.
651             returndatacopy(0, 0, returndatasize())
652 
653             switch result
654             // delegatecall returns 0 on error.
655             case 0 {
656                 revert(0, returndatasize())
657             }
658             default {
659                 return(0, returndatasize())
660             }
661         }
662     }
663 
664     /**
665      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
666      * and {_fallback} should delegate.
667      */
668     function _implementation() internal view virtual returns (address);
669 
670     /**
671      * @dev Delegates the current call to the address returned by `_implementation()`.
672      *
673      * This function does not return to its internal call site, it will return directly to the external caller.
674      */
675     function _fallback() internal virtual {
676         _beforeFallback();
677         _delegate(_implementation());
678     }
679 
680     /**
681      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
682      * function in the contract matches the call data.
683      */
684     fallback() external payable virtual {
685         _fallback();
686     }
687 
688     /**
689      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
690      * is empty.
691      */
692     receive() external payable virtual {
693         _fallback();
694     }
695 
696     /**
697      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
698      * call, or as part of the Solidity `fallback` or `receive` functions.
699      *
700      * If overridden should call `super._beforeFallback()`.
701      */
702     function _beforeFallback() internal virtual {}
703 }
704 
705 
706 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
707 
708 pragma solidity ^0.8.0;
709 
710 /**
711  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
712  * implementation address that can be changed. This address is stored in storage in the location specified by
713  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
714  * implementation behind the proxy.
715  */
716 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
717     /**
718      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
719      *
720      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
721      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
722      */
723     constructor(address _logic, bytes memory _data) payable {
724         _upgradeToAndCall(_logic, _data, false);
725     }
726 
727     /**
728      * @dev Returns the current implementation address.
729      */
730     function _implementation() internal view virtual override returns (address impl) {
731         return ERC1967Upgrade._getImplementation();
732     }
733 }
734 
735 /**
736  * @dev This contract implements a proxy that is upgradeable by an admin.
737  *
738  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
739  * clashing], which can potentially be used in an attack, this contract uses the
740  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
741  * things that go hand in hand:
742  *
743  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
744  * that call matches one of the admin functions exposed by the proxy itself.
745  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
746  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
747  * "admin cannot fallback to proxy target".
748  *
749  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
750  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
751  * to sudden errors when trying to call a function from the proxy implementation.
752  *
753  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
754  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
755  *
756  * NOTE: The real interface of this proxy is that defined in `ITransparentUpgradeableProxy`. This contract does not
757  * inherit from that interface, and instead the admin functions are implicitly implemented using a custom dispatch
758  * mechanism in `_fallback`. Consequently, the compiler will not produce an ABI for this contract. This is necessary to
759  * fully implement transparency without decoding reverts caused by selector clashes between the proxy and the
760  * implementation.
761  *
762  * WARNING: It is not recommended to extend this contract to add additional external functions. If you do so, the compiler
763  * will not check that there are no selector conflicts, due to the note above. A selector clash between any new function
764  * and the functions declared in {ITransparentUpgradeableProxy} will be resolved in favor of the new one. This could
765  * render the admin operations inaccessible, which could prevent upgradeability. Transparency may also be compromised.
766  */
767 contract TransparentUpgradeableProxy is ERC1967Proxy {
768     /**
769      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
770      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
771      */
772     constructor(address _logic, address admin_, bytes memory _data) payable ERC1967Proxy(_logic, _data) {
773         _changeAdmin(admin_);
774     }
775 
776     /**
777      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
778      *
779      * CAUTION: This modifier is deprecated, as it could cause issues if the modified function has arguments, and the
780      * implementation provides a function with the same selector.
781      */
782     modifier ifAdmin() {
783         if (msg.sender == _getAdmin()) {
784             _;
785         } else {
786             _fallback();
787         }
788     }
789 
790     /**
791      * @dev If caller is the admin process the call internally, otherwise transparently fallback to the proxy behavior
792      */
793     function _fallback() internal virtual override {
794         if (msg.sender == _getAdmin()) {
795             bytes memory ret;
796             bytes4 selector = msg.sig;
797             if (selector == ITransparentUpgradeableProxy.upgradeTo.selector) {
798                 ret = _dispatchUpgradeTo();
799             } else if (selector == ITransparentUpgradeableProxy.upgradeToAndCall.selector) {
800                 ret = _dispatchUpgradeToAndCall();
801             } else if (selector == ITransparentUpgradeableProxy.changeAdmin.selector) {
802                 ret = _dispatchChangeAdmin();
803             } else if (selector == ITransparentUpgradeableProxy.admin.selector) {
804                 ret = _dispatchAdmin();
805             } else if (selector == ITransparentUpgradeableProxy.implementation.selector) {
806                 ret = _dispatchImplementation();
807             } else {
808                 revert("TransparentUpgradeableProxy: admin cannot fallback to proxy target");
809             }
810             assembly {
811                 return(add(ret, 0x20), mload(ret))
812             }
813         } else {
814             super._fallback();
815         }
816     }
817 
818     /**
819      * @dev Returns the current admin.
820      *
821      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
822      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
823      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
824      */
825     function _dispatchAdmin() private returns (bytes memory) {
826         _requireZeroValue();
827 
828         address admin = _getAdmin();
829         return abi.encode(admin);
830     }
831 
832     /**
833      * @dev Returns the current implementation.
834      *
835      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
836      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
837      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
838      */
839     function _dispatchImplementation() private returns (bytes memory) {
840         _requireZeroValue();
841 
842         address implementation = _implementation();
843         return abi.encode(implementation);
844     }
845 
846     /**
847      * @dev Changes the admin of the proxy.
848      *
849      * Emits an {AdminChanged} event.
850      */
851     function _dispatchChangeAdmin() private returns (bytes memory) {
852         _requireZeroValue();
853 
854         address newAdmin = abi.decode(msg.data[4:], (address));
855         _changeAdmin(newAdmin);
856 
857         return "";
858     }
859 
860     /**
861      * @dev Upgrade the implementation of the proxy.
862      */
863     function _dispatchUpgradeTo() private returns (bytes memory) {
864         _requireZeroValue();
865 
866         address newImplementation = abi.decode(msg.data[4:], (address));
867         _upgradeToAndCall(newImplementation, bytes(""), false);
868 
869         return "";
870     }
871 
872     /**
873      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
874      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
875      * proxied contract.
876      */
877     function _dispatchUpgradeToAndCall() private returns (bytes memory) {
878         (address newImplementation, bytes memory data) = abi.decode(msg.data[4:], (address, bytes));
879         _upgradeToAndCall(newImplementation, data, true);
880 
881         return "";
882     }
883 
884     /**
885      * @dev Returns the current admin.
886      *
887      * CAUTION: This function is deprecated. Use {ERC1967Upgrade-_getAdmin} instead.
888      */
889     function _admin() internal view virtual returns (address) {
890         return _getAdmin();
891     }
892 
893     /**
894      * @dev To keep this contract fully transparent, all `ifAdmin` functions must be payable. This helper is here to
895      * emulate some proxy functions being non-payable while still allowing value to pass through.
896      */
897     function _requireZeroValue() private {
898         require(msg.value == 0);
899     }
900 }
901 
902 
903 pragma solidity ^0.8.17;
904 
905 
906 contract KongProxy is TransparentUpgradeableProxy {
907 	constructor(address _logic, address _admin, bytes memory _data) public  TransparentUpgradeableProxy(_logic, _admin, _data) {}
908 }