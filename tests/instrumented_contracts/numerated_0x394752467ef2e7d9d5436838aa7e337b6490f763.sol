1 // SPDX-License-Identifier: MIXED
2 
3 // Sources flattened with hardhat v2.12.2 https://hardhat.org
4 
5 // File contracts/tmp/contracts/proxy/Proxy.sol
6 
7 // License-Identifier: MIT
8 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
14  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
15  * be specified by overriding the virtual {_implementation} function.
16  *
17  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
18  * different contract through the {_delegate} function.
19  *
20  * The success and return data of the delegated call will be returned back to the caller of the proxy.
21  */
22 abstract contract Proxy {
23     /**
24      * @dev Delegates the current call to `implementation`.
25      *
26      * This function does not return to its internal call site, it will return directly to the external caller.
27      */
28     function _delegate(address implementation) internal virtual {
29         assembly {
30             // Copy msg.data. We take full control of memory in this inline assembly
31             // block because it will not return to Solidity code. We overwrite the
32             // Solidity scratch pad at memory position 0.
33             calldatacopy(0, 0, calldatasize())
34 
35             // Call the implementation.
36             // out and outsize are 0 because we don't know the size yet.
37             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
38 
39             // Copy the returned data.
40             returndatacopy(0, 0, returndatasize())
41 
42             switch result
43             // delegatecall returns 0 on error.
44             case 0 {
45                 revert(0, returndatasize())
46             }
47             default {
48                 return(0, returndatasize())
49             }
50         }
51     }
52 
53     /**
54      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
55      * and {_fallback} should delegate.
56      */
57     function _implementation() internal view virtual returns (address);
58 
59     /**
60      * @dev Delegates the current call to the address returned by `_implementation()`.
61      *
62      * This function does not return to its internal call site, it will return directly to the external caller.
63      */
64     function _fallback() internal virtual {
65         _beforeFallback();
66         _delegate(_implementation());
67     }
68 
69     /**
70      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
71      * function in the contract matches the call data.
72      */
73     fallback() external payable virtual {
74         _fallback();
75     }
76 
77     /**
78      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
79      * is empty.
80      */
81     receive() external payable virtual {
82         _fallback();
83     }
84 
85     /**
86      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
87      * call, or as part of the Solidity `fallback` or `receive` functions.
88      *
89      * If overridden should call `super._beforeFallback()`.
90      */
91     function _beforeFallback() internal virtual {}
92 }
93 
94 
95 // File contracts/tmp/contracts/interfaces/draft-IERC1822.sol
96 
97 // License-Identifier: MIT
98 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
104  * proxy whose upgrades are fully controlled by the current implementation.
105  */
106 interface IERC1822Proxiable {
107     /**
108      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
109      * address.
110      *
111      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
112      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
113      * function revert if invoked through a proxy.
114      */
115     function proxiableUUID() external view returns (bytes32);
116 }
117 
118 
119 // File contracts/tmp/contracts/proxy/beacon/IBeacon.sol
120 
121 // License-Identifier: MIT
122 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
123 
124 pragma solidity ^0.8.0;
125 
126 /**
127  * @dev This is the interface that {BeaconProxy} expects of its beacon.
128  */
129 interface IBeacon {
130     /**
131      * @dev Must return an address that can be used as a delegate call target.
132      *
133      * {BeaconProxy} will check that this address is a contract.
134      */
135     function implementation() external view returns (address);
136 }
137 
138 
139 // File contracts/tmp/contracts/utils/StorageSlot.sol
140 
141 // License-Identifier: MIT
142 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 /**
147  * @dev Library for reading and writing primitive types to specific storage slots.
148  *
149  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
150  * This library helps with reading and writing to such slots without the need for inline assembly.
151  *
152  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
153  *
154  * Example usage to set ERC1967 implementation slot:
155  * ```
156  * contract ERC1967 {
157  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
158  *
159  *     function _getImplementation() internal view returns (address) {
160  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
161  *     }
162  *
163  *     function _setImplementation(address newImplementation) internal {
164  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
165  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
166  *     }
167  * }
168  * ```
169  *
170  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
171  */
172 library StorageSlot {
173     struct AddressSlot {
174         address value;
175     }
176 
177     struct BooleanSlot {
178         bool value;
179     }
180 
181     struct Bytes32Slot {
182         bytes32 value;
183     }
184 
185     struct Uint256Slot {
186         uint256 value;
187     }
188 
189     /**
190      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
191      */
192     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
193         /// @solidity memory-safe-assembly
194         assembly {
195             r.slot := slot
196         }
197     }
198 
199     /**
200      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
201      */
202     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
203         /// @solidity memory-safe-assembly
204         assembly {
205             r.slot := slot
206         }
207     }
208 
209     /**
210      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
211      */
212     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
213         /// @solidity memory-safe-assembly
214         assembly {
215             r.slot := slot
216         }
217     }
218 
219     /**
220      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
221      */
222     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
223         /// @solidity memory-safe-assembly
224         assembly {
225             r.slot := slot
226         }
227     }
228 }
229 
230 
231 // File contracts/tmp/contracts/utils/Address.sol
232 
233 // License-Identifier: MIT
234 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
235 
236 pragma solidity ^0.8.1;
237 
238 /**
239  * @dev Collection of functions related to the address type
240  */
241 library Address {
242     /**
243      * @dev Returns true if `account` is a contract.
244      *
245      * [IMPORTANT]
246      * ====
247      * It is unsafe to assume that an address for which this function returns
248      * false is an externally-owned account (EOA) and not a contract.
249      *
250      * Among others, `isContract` will return false for the following
251      * types of addresses:
252      *
253      *  - an externally-owned account
254      *  - a contract in construction
255      *  - an address where a contract will be created
256      *  - an address where a contract lived, but was destroyed
257      * ====
258      *
259      * [IMPORTANT]
260      * ====
261      * You shouldn't rely on `isContract` to protect against flash loan attacks!
262      *
263      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
264      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
265      * constructor.
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // This method relies on extcodesize/address.code.length, which returns 0
270         // for contracts in construction, since the code is only stored at the end
271         // of the constructor execution.
272 
273         return account.code.length > 0;
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      */
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(address(this).balance >= amount, "Address: insufficient balance");
294 
295         (bool success, ) = recipient.call{value: amount}("");
296         require(success, "Address: unable to send value, recipient may have reverted");
297     }
298 
299     /**
300      * @dev Performs a Solidity function call using a low level `call`. A
301      * plain `call` is an unsafe replacement for a function call: use this
302      * function instead.
303      *
304      * If `target` reverts with a revert reason, it is bubbled up by this
305      * function (like regular Solidity function calls).
306      *
307      * Returns the raw returned data. To convert to the expected return value,
308      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
309      *
310      * Requirements:
311      *
312      * - `target` must be a contract.
313      * - calling `target` with `data` must not revert.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
323      * `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(
328         address target,
329         bytes memory data,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         return functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value
350     ) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
356      * with `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(
361         address target,
362         bytes memory data,
363         uint256 value,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         require(address(this).balance >= value, "Address: insufficient balance for call");
367         (bool success, bytes memory returndata) = target.call{value: value}(data);
368         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but performing a static call.
374      *
375      * _Available since v3.3._
376      */
377     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
378         return functionStaticCall(target, data, "Address: low-level static call failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
383      * but performing a static call.
384      *
385      * _Available since v3.3._
386      */
387     function functionStaticCall(
388         address target,
389         bytes memory data,
390         string memory errorMessage
391     ) internal view returns (bytes memory) {
392         (bool success, bytes memory returndata) = target.staticcall(data);
393         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
403         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal returns (bytes memory) {
417         (bool success, bytes memory returndata) = target.delegatecall(data);
418         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
419     }
420 
421     /**
422      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
423      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
424      *
425      * _Available since v4.8._
426      */
427     function verifyCallResultFromTarget(
428         address target,
429         bool success,
430         bytes memory returndata,
431         string memory errorMessage
432     ) internal view returns (bytes memory) {
433         if (success) {
434             if (returndata.length == 0) {
435                 // only check isContract if the call was successful and the return data is empty
436                 // otherwise we already know that it was a contract
437                 require(isContract(target), "Address: call to non-contract");
438             }
439             return returndata;
440         } else {
441             _revert(returndata, errorMessage);
442         }
443     }
444 
445     /**
446      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
447      * revert reason or using the provided one.
448      *
449      * _Available since v4.3._
450      */
451     function verifyCallResult(
452         bool success,
453         bytes memory returndata,
454         string memory errorMessage
455     ) internal pure returns (bytes memory) {
456         if (success) {
457             return returndata;
458         } else {
459             _revert(returndata, errorMessage);
460         }
461     }
462 
463     function _revert(bytes memory returndata, string memory errorMessage) private pure {
464         // Look for revert reason and bubble it up if present
465         if (returndata.length > 0) {
466             // The easiest way to bubble the revert reason is using memory via assembly
467             /// @solidity memory-safe-assembly
468             assembly {
469                 let returndata_size := mload(returndata)
470                 revert(add(32, returndata), returndata_size)
471             }
472         } else {
473             revert(errorMessage);
474         }
475     }
476 }
477 
478 
479 // File contracts/tmp/contracts/proxy/ERC1967/ERC1967Upgrade.sol
480 
481 // License-Identifier: MIT
482 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
483 
484 pragma solidity ^0.8.2;
485 
486 
487 
488 
489 /**
490  * @dev This abstract contract provides getters and event emitting update functions for
491  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
492  *
493  * _Available since v4.1._
494  *
495  * @custom:oz-upgrades-unsafe-allow delegatecall
496  */
497 abstract contract ERC1967Upgrade {
498     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
499     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
500 
501     /**
502      * @dev Storage slot with the address of the current implementation.
503      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
504      * validated in the constructor.
505      */
506     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
507 
508     /**
509      * @dev Emitted when the implementation is upgraded.
510      */
511     event Upgraded(address indexed implementation);
512 
513     /**
514      * @dev Returns the current implementation address.
515      */
516     function _getImplementation() internal view returns (address) {
517         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
518     }
519 
520     /**
521      * @dev Stores a new address in the EIP1967 implementation slot.
522      */
523     function _setImplementation(address newImplementation) private {
524         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
525         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
526     }
527 
528     /**
529      * @dev Perform implementation upgrade
530      *
531      * Emits an {Upgraded} event.
532      */
533     function _upgradeTo(address newImplementation) internal {
534         _setImplementation(newImplementation);
535         emit Upgraded(newImplementation);
536     }
537 
538     /**
539      * @dev Perform implementation upgrade with additional setup call.
540      *
541      * Emits an {Upgraded} event.
542      */
543     function _upgradeToAndCall(
544         address newImplementation,
545         bytes memory data,
546         bool forceCall
547     ) internal {
548         _upgradeTo(newImplementation);
549         if (data.length > 0 || forceCall) {
550             Address.functionDelegateCall(newImplementation, data);
551         }
552     }
553 
554     /**
555      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
556      *
557      * Emits an {Upgraded} event.
558      */
559     function _upgradeToAndCallUUPS(
560         address newImplementation,
561         bytes memory data,
562         bool forceCall
563     ) internal {
564         // Upgrades from old implementations will perform a rollback test. This test requires the new
565         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
566         // this special case will break upgrade paths from old UUPS implementation to new ones.
567         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
568             _setImplementation(newImplementation);
569         } else {
570             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
571                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
572             } catch {
573                 revert("ERC1967Upgrade: new implementation is not UUPS");
574             }
575             _upgradeToAndCall(newImplementation, data, forceCall);
576         }
577     }
578 
579     /**
580      * @dev Storage slot with the admin of the contract.
581      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
582      * validated in the constructor.
583      */
584     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
585 
586     /**
587      * @dev Emitted when the admin account has changed.
588      */
589     event AdminChanged(address previousAdmin, address newAdmin);
590 
591     /**
592      * @dev Returns the current admin.
593      */
594     function _getAdmin() internal view returns (address) {
595         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
596     }
597 
598     /**
599      * @dev Stores a new address in the EIP1967 admin slot.
600      */
601     function _setAdmin(address newAdmin) private {
602         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
603         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
604     }
605 
606     /**
607      * @dev Changes the admin of the proxy.
608      *
609      * Emits an {AdminChanged} event.
610      */
611     function _changeAdmin(address newAdmin) internal {
612         emit AdminChanged(_getAdmin(), newAdmin);
613         _setAdmin(newAdmin);
614     }
615 
616     /**
617      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
618      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
619      */
620     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
621 
622     /**
623      * @dev Emitted when the beacon is upgraded.
624      */
625     event BeaconUpgraded(address indexed beacon);
626 
627     /**
628      * @dev Returns the current beacon.
629      */
630     function _getBeacon() internal view returns (address) {
631         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
632     }
633 
634     /**
635      * @dev Stores a new beacon in the EIP1967 beacon slot.
636      */
637     function _setBeacon(address newBeacon) private {
638         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
639         require(
640             Address.isContract(IBeacon(newBeacon).implementation()),
641             "ERC1967: beacon implementation is not a contract"
642         );
643         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
644     }
645 
646     /**
647      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
648      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
649      *
650      * Emits a {BeaconUpgraded} event.
651      */
652     function _upgradeBeaconToAndCall(
653         address newBeacon,
654         bytes memory data,
655         bool forceCall
656     ) internal {
657         _setBeacon(newBeacon);
658         emit BeaconUpgraded(newBeacon);
659         if (data.length > 0 || forceCall) {
660             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
661         }
662     }
663 }
664 
665 
666 // File contracts/tmp/contracts/proxy/ERC1967/ERC1967Proxy.sol
667 
668 // License-Identifier: MIT
669 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 
674 /**
675  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
676  * implementation address that can be changed. This address is stored in storage in the location specified by
677  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
678  * implementation behind the proxy.
679  */
680 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
681     /**
682      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
683      *
684      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
685      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
686      */
687     constructor(address _logic, bytes memory _data) payable {
688         _upgradeToAndCall(_logic, _data, false);
689     }
690 
691     /**
692      * @dev Returns the current implementation address.
693      */
694     function _implementation() internal view virtual override returns (address impl) {
695         return ERC1967Upgrade._getImplementation();
696     }
697 }