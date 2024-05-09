1 // SPDX-License-Identifier: MIT
2 // =============== 0xRoMA ==================
3 // 0xTHULU Relic of Membership: Augmented //
4 //      Pausable | Burnable | Upgradable 
5 //
6 // =========Copyright Owner & Royalty Receiver=========== 
7 // 0xTHULU Inc., Columbus, Ohio - USA. https://0xthulu.io 
8 // ====================================================== 
9 // Non-Fungible token standard : ERC721a (Azuki v4)  
10 // Proxy contracts forked from : OpenZeppelin & Azuki - Chiru Labs 
11 // Smart contracts deployed by : www.BLAZE.ws
12 // Smart contracts security auditor: CONSENSYS MythX.io
13 
14 
15 
16 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
17 
18 pragma solidity 0.8.17;
19 
20 /**
21  * @dev Provides information about the current execution context, including the
22  * sender of the transaction and its data. While these are generally available
23  * via msg.sender and msg.data, they should not be accessed in such a direct
24  * manner, since when dealing with meta-transactions the account sending and
25  * paying for execution may not be the actual sender (as far as an application
26  * is concerned).
27  *
28  * This contract is only required for intermediate, library-like contracts.
29  */
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 
35     function _msgData() internal view virtual returns (bytes calldata) {
36         return msg.data;
37     }
38 }
39 
40 // File: @openzeppelin/contracts/access/Ownable.sol
41 
42 
43 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
44 
45 pragma solidity 0.8.17;
46 
47 
48 /**
49  * @dev Contract module which provides a basic access control mechanism, where
50  * there is an account (an owner) that can be granted exclusive access to
51  * specific functions.
52  *
53  * By default, the owner account will be the one that deploys the contract. This
54  * can later be changed with {transferOwnership}.
55  *
56  * This module is used through inheritance. It will make available the modifier
57  * `onlyOwner`, which can be applied to your functions to restrict their use to
58  * the owner.
59  */
60 abstract contract Ownable is Context {
61     address private _owner;
62 
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     /**
66      * @dev Initializes the contract setting the deployer as the initial owner.
67      */
68     constructor() {
69         _transferOwnership(_msgSender());
70     }
71 
72     /**
73      * @dev Throws if called by any account other than the owner.
74      */
75     modifier onlyOwner() {
76         _checkOwner();
77         _;
78     }
79 
80     /**
81      * @dev Returns the address of the current owner.
82      */
83     function owner() public view virtual returns (address) {
84         return _owner;
85     }
86 
87     /**
88      * @dev Throws if the sender is not the owner.
89      */
90     function _checkOwner() internal view virtual {
91         require(owner() == _msgSender(), "Ownable: caller is not the owner");
92     }
93 
94     /**
95      * @dev Leaves the contract without owner. It will not be possible to call
96      * `onlyOwner` functions anymore. Can only be called by the current owner.
97      *
98      * NOTE: Renouncing ownership will leave the contract without an owner,
99      * thereby removing any functionality that is only available to the owner.
100      */
101     function renounceOwnership() public virtual onlyOwner {
102         _transferOwnership(address(0));
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Can only be called by the current owner.
108      */
109     function transferOwnership(address newOwner) public virtual onlyOwner {
110         require(newOwner != address(0), "Ownable: new owner is the zero address");
111         _transferOwnership(newOwner);
112     }
113 
114     /**
115      * @dev Transfers ownership of the contract to a new account (`newOwner`).
116      * Internal function without access restriction.
117      */
118     function _transferOwnership(address newOwner) internal virtual {
119         address oldOwner = _owner;
120         _owner = newOwner;
121         emit OwnershipTransferred(oldOwner, newOwner);
122     }
123 }
124 
125 // File: @openzeppelin/contracts/utils/StorageSlot.sol
126 
127 
128 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
129 
130 pragma solidity 0.8.17;
131 
132 /**
133  * @dev Library for reading and writing primitive types to specific storage slots.
134  *
135  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
136  * This library helps with reading and writing to such slots without the need for inline assembly.
137  *
138  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
139  *
140  * Example usage to set ERC1967 implementation slot:
141  * ```
142  * contract ERC1967 {
143  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
144  *
145  *     function _getImplementation() internal view returns (address) {
146  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
147  *     }
148  *
149  *     function _setImplementation(address newImplementation) internal {
150  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
151  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
152  *     }
153  * }
154  * ```
155  *
156  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
157  */
158 library StorageSlot {
159     struct AddressSlot {
160         address value;
161     }
162 
163     struct BooleanSlot {
164         bool value;
165     }
166 
167     struct Bytes32Slot {
168         bytes32 value;
169     }
170 
171     struct Uint256Slot {
172         uint256 value;
173     }
174 
175     /**
176      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
177      */
178     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
179         /// @solidity memory-safe-assembly
180         assembly {
181             r.slot := slot
182         }
183     }
184 
185     /**
186      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
187      */
188     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
189         /// @solidity memory-safe-assembly
190         assembly {
191             r.slot := slot
192         }
193     }
194 
195     /**
196      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
197      */
198     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
199         /// @solidity memory-safe-assembly
200         assembly {
201             r.slot := slot
202         }
203     }
204 
205     /**
206      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
207      */
208     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
209         /// @solidity memory-safe-assembly
210         assembly {
211             r.slot := slot
212         }
213     }
214 }
215 
216 // File: @openzeppelin/contracts/utils/Address.sol
217 
218 
219 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
220 
221 pragma solidity 0.8.17;
222 
223 /**
224  * @dev Collection of functions related to the address type
225  */
226 library Address {
227     /**
228      * @dev Returns true if `account` is a contract.
229      *
230      * [IMPORTANT]
231      * ====
232      * It is unsafe to assume that an address for which this function returns
233      * false is an externally-owned account (EOA) and not a contract.
234      *
235      * Among others, `isContract` will return false for the following
236      * types of addresses:
237      *
238      *  - an externally-owned account
239      *  - a contract in construction
240      *  - an address where a contract will be created
241      *  - an address where a contract lived, but was destroyed
242      * ====
243      *
244      * [IMPORTANT]
245      * ====
246      * You shouldn't rely on `isContract` to protect against flash loan attacks!
247      *
248      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
249      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
250      * constructor.
251      * ====
252      */
253     function isContract(address account) internal view returns (bool) {
254         // This method relies on extcodesize/address.code.length, which returns 0
255         // for contracts in construction, since the code is only stored at the end
256         // of the constructor execution.
257 
258         return account.code.length > 0;
259     }
260 
261     /**
262      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
263      * `recipient`, forwarding all available gas and reverting on errors.
264      *
265      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
266      * of certain opcodes, possibly making contracts go over the 2300 gas limit
267      * imposed by `transfer`, making them unable to receive funds via
268      * `transfer`. {sendValue} removes this limitation.
269      *
270      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
271      *
272      * IMPORTANT: because control is transferred to `recipient`, care must be
273      * taken to not create reentrancy vulnerabilities. Consider using
274      * {ReentrancyGuard} or the
275      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
276      */
277     function sendValue(address payable recipient, uint256 amount) internal {
278         require(address(this).balance >= amount, "Address: insufficient balance");
279 
280         (bool success, ) = recipient.call{value: amount}("");
281         require(success, "Address: unable to send value, recipient may have reverted");
282     }
283 
284     /**
285      * @dev Performs a Solidity function call using a low level `call`. A
286      * plain `call` is an unsafe replacement for a function call: use this
287      * function instead.
288      *
289      * If `target` reverts with a revert reason, it is bubbled up by this
290      * function (like regular Solidity function calls).
291      *
292      * Returns the raw returned data. To convert to the expected return value,
293      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
294      *
295      * Requirements:
296      *
297      * - `target` must be a contract.
298      * - calling `target` with `data` must not revert.
299      *
300      * _Available since v3.1._
301      */
302     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
303         return functionCall(target, data, "Address: low-level call failed");
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
308      * `errorMessage` as a fallback revert reason when `target` reverts.
309      *
310      * _Available since v3.1._Events
311 
312      */
313     function functionCall(
314         address target,
315         bytes memory data,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, 0, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but also transferring `value` wei to `target`.
324      *
325      * Requirements:
326      *
327      * - the calling contract must have an ETH balance of at least `value`.
328      * - the called Solidity function must be `payable`.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(
333         address target,
334         bytes memory data,
335         uint256 value
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         require(address(this).balance >= value, "Address: insufficient balance for call");
353         require(isContract(target), "Address: call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.call{value: value}(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but performing a static call.
362      *
363      * _Available since v3.3._
364      */
365     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
366         return functionStaticCall(target, data, "Address: low-level static call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal view returns (bytes memory) {
380         require(isContract(target), "Address: static call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.staticcall(data);
383         return verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but performing a delegate call.
389      *
390      * _Available since v3.4._
391      */
392     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
393         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(
403         address target,
404         bytes memory data,
405         string memory errorMessage
406     ) internal returns (bytes memory) {
407         require(isContract(target), "Address: delegate call to non-contract");
408 
409         (bool success, bytes memory returndata) = target.delegatecall(data);
410         return verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     /**
414      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
415      * revert reason using the provided one.
416      *
417      * _Available since v4.3._
418      */
419     function verifyCallResult(
420         bool success,
421         bytes memory returndata,
422         string memory errorMessage
423     ) internal pure returns (bytes memory) {
424         if (success) {
425             return returndata;
426         } else {
427             // Look for revert reason and bubble it up if present
428             if (returndata.length > 0) {
429                 // The easiest way to bubble the revert reason is using memory via assembly
430                 /// @solidity memory-safe-assembly
431                 assembly {
432                     let returndata_size := mload(returndata)
433                     revert(add(32, returndata), returndata_size)
434                 }
435             } else {
436                 revert(errorMessage);
437             }
438         }
439     }
440 }
441 
442 // File: @openzeppelin/contracts/interfaces/draft-IERC1822.sol
443 
444 
445 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
446 
447 pragma solidity 0.8.17;
448 
449 /**
450  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
451  * proxy whose upgrades are fully controlled by the current implementation.
452  */
453 interface IERC1822Proxiable {
454     /**
455      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
456      * address.
457      *
458      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
459      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
460      * function revert if invoked through a proxy.
461      */
462     function proxiableUUID() external view returns (bytes32);
463 }
464 
465 // File: @openzeppelin/contracts/proxy/beacon/IBeacon.sol
466 
467 
468 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
469 
470 pragma solidity 0.8.17;
471 
472 /**
473  * @dev This is the interface that {BeaconProxy} expects of its beacon.
474  */
475 interface IBeacon {
476     /**
477      * @dev Must return an address that can be used as a delegate call target.
478      *
479      * {BeaconProxy} will check that this address is a contract.
480      */
481     function implementation() external view returns (address);
482 }
483 
484 // File: @openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol
485 
486 
487 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
488 
489 pragma solidity 0.8.17;
490 
491 
492 
493 
494 
495 /**
496  * @dev This abstract contract provides getters and event emitting update functions for
497  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
498  *
499  * _Available since v4.1._
500  *
501  * @custom:oz-upgrades-unsafe-allow delegatecall
502  */
503 abstract contract ERC1967Upgrade {
504     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
505     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
506 
507     /**
508      * @dev Storage slot with the address of the current implementation.
509      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
510      * validated in the constructor.
511      */
512     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
513 
514     /**
515      * @dev Emitted when the implementation is upgraded.
516      */
517     event Upgraded(address indexed implementation);
518 
519     /**
520      * @dev Returns the current implementation address.
521      */
522     function _getImplementation() internal view returns (address) {
523         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
524     }
525 
526     /**
527      * @dev Stores a new address in the EIP1967 implementation slot.
528      */
529     function _setImplementation(address newImplementation) private {
530         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
531         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
532     }
533 
534     /**
535      * @dev Perform implementation upgrade
536      *
537      * Emits an {Upgraded} event.
538      */
539     function _upgradeTo(address newImplementation) internal {
540         _setImplementation(newImplementation);
541         emit Upgraded(newImplementation);
542     }
543 
544     /**
545      * @dev Perform implementation upgrade with additional setup call.
546      *
547      * Emits an {Upgraded} event.
548      */
549     function _upgradeToAndCall(
550         address newImplementation,
551         bytes memory data,
552         bool forceCall
553     ) internal {
554         _upgradeTo(newImplementation);
555         if (data.length > 0 || forceCall) {
556             Address.functionDelegateCall(newImplementation, data);
557         }
558     }
559 
560     /**
561      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
562      *
563      * Emits an {Upgraded} event.
564      */
565     function _upgradeToAndCallUUPS(
566         address newImplementation,
567         bytes memory data,
568         bool forceCall
569     ) internal {
570         // Upgrades from old implementations will perform a rollback test. This test requires the new
571         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
572         // this special case will break upgrade paths from old UUPS implementation to new ones.
573         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
574             _setImplementation(newImplementation);
575         } else {
576             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
577                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
578             } catch {
579                 revert("ERC1967Upgrade: new implementation is not UUPS");
580             }
581             _upgradeToAndCall(newImplementation, data, forceCall);
582         }
583     }
584 
585     /**
586      * @dev Storage slot with the admin of the contract.
587      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
588      * validated in the constructor.
589      */
590     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
591 
592     /**
593      * @dev Emitted when the admin account has changed.
594      */
595     event AdminChanged(address previousAdmin, address newAdmin);
596 
597     /**
598      * @dev Returns the current admin.
599      */
600     function _getAdmin() internal view returns (address) {
601         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
602     }
603 
604     /**
605      * @dev Stores a new address in the EIP1967 admin slot.
606      */
607     function _setAdmin(address newAdmin) private {
608         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
609         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
610     }
611 
612     /**
613      * @dev Changes the admin of the proxy.
614      *
615      * Emits an {AdminChanged} event.
616      */
617     function _changeAdmin(address newAdmin) internal {
618         emit AdminChanged(_getAdmin(), newAdmin);
619         _setAdmin(newAdmin);
620     }
621 
622     /**
623      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
624      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
625      */
626     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
627 
628     /**
629      * @dev Emitted when the beacon is upgraded.
630      */
631     event BeaconUpgraded(address indexed beacon);
632 
633     /**
634      * @dev Returns the current beacon.
635      */
636     function _getBeacon() internal view returns (address) {
637         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
638     }
639 
640     /**
641      * @dev Stores a new beacon in the EIP1967 beacon slot.
642      */
643     function _setBeacon(address newBeacon) private {
644         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
645         require(
646             Address.isContract(IBeacon(newBeacon).implementation()),
647             "ERC1967: beacon implementation is not a contract"
648         );
649         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
650     }
651 
652     /**
653      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
654      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
655      *
656      * Emits a {BeaconUpgraded} event.
657      */
658     function _upgradeBeaconToAndCall(
659         address newBeacon,
660         bytes memory data,
661         bool forceCall
662     ) internal {
663         _setBeacon(newBeacon);
664         emit BeaconUpgraded(newBeacon);
665         if (data.length > 0 || forceCall) {
666             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
667         }
668     }
669 }
670 
671 // File: @openzeppelin/contracts/proxy/Proxy.sol
672 
673 
674 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
675 
676 pragma solidity 0.8.17;
677 
678 /**
679  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
680  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
681  * be specified by overriding the virtual {_implementation} function.
682  *
683  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
684  * different contract through the {_delegate} function.
685  *
686  * The success and return data of the delegated call will be returned back to the caller of the proxy.
687  */
688 abstract contract Proxy {
689     /**
690      * @dev Delegates the current call to `implementation`.
691      *
692      * This function does not return to its internal call site, it will return directly to the external caller.
693      */
694     function _delegate(address implementation) internal virtual {
695         assembly {
696             // Copy msg.data. We take full control of memory in this inline assembly
697             // block because it will not return to Solidity code. We overwrite the
698             // Solidity scratch pad at memory position 0.
699             calldatacopy(0, 0, calldatasize())
700 
701             // Call the implementation.
702             // out and outsize are 0 because we don't know the size yet.
703             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
704 
705             // Copy the returned data.
706             returndatacopy(0, 0, returndatasize())
707 
708             switch result
709             // delegatecall returns 0 on error.
710             case 0 {
711                 revert(0, returndatasize())
712             }
713             default {
714                 return(0, returndatasize())
715             }
716         }
717     }
718 
719     /**
720      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
721      * and {_fallback} should delegate.
722      */
723     function _implementation() internal view virtual returns (address);
724 
725     /**
726      * @dev Delegates the current call to the address returned by `_implementation()`.
727      *
728      * This function does not return to its internal call site, it will return directly to the external caller.
729      */
730     function _fallback() internal virtual {
731         _beforeFallback();
732         _delegate(_implementation());
733     }
734 
735     /**
736      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
737      * function in the contract matches the call data.
738      */
739     fallback() external payable virtual {
740         _fallback();
741     }
742 
743     /**
744      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
745      * is empty.
746      */
747     receive() external payable virtual {
748         _fallback();
749     }
750 
751     /**
752      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
753      * call, or as part of the Solidity `fallback` or `receive` functions.
754      *
755      * If overridden should call `super._beforeFallback()`.
756      */
757     function _beforeFallback() internal virtual {}
758 }
759 
760 // File: @openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol
761 
762 
763 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
764 
765 pragma solidity 0.8.17;
766 
767 
768 
769 /**
770  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
771  * implementation address that can be changed. This address is stored in storage in the location specified by
772  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
773  * implementation behind the proxy.
774  */
775 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
776     /**
777      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
778      *
779      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
780      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
781      */
782     constructor(address _logic, bytes memory _data) payable {
783         _upgradeToAndCall(_logic, _data, false);
784     }
785 
786     /**
787      * @dev Returns the current implementation address.
788      */
789     function _implementation() internal view virtual override returns (address impl) {
790         return ERC1967Upgrade._getImplementation();
791     }
792 }
793 
794 // File: @openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol
795 
796 
797 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/transparent/TransparentUpgradeableProxy.sol)
798 
799 pragma solidity 0.8.17;
800 
801 
802 /**
803  * @dev This contract implements a proxy that is upgradeable by an admin.
804  *
805  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
806  * clashing], which can potentially be used in an attack, this contract uses the
807  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
808  * things that go hand in hand:
809  *
810  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
811  * that call matches one of the admin functions exposed by the proxy itself.
812  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
813  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
814  * "admin cannot fallback to proxy target".
815  *
816  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
817  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
818  * to sudden errors when trying to call a function from the proxy implementation.
819  *
820  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
821  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
822  */
823 contract TransparentUpgradeableProxy is ERC1967Proxy {
824     /**
825      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
826      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
827      * TransparentUpgradeableProxy
828      */
829     constructor(
830         address _logic,
831         address admin_,
832         bytes memory _data
833     ) payable ERC1967Proxy(_logic, _data) {
834         _changeAdmin(admin_);
835     }
836 
837     /**
838      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
839      */
840     modifier ifAdmin() {
841         if (msg.sender == _getAdmin()) {
842             _;
843         } else {
844             _fallback();
845         }
846     }
847 
848     /**
849      * @dev Returns the current admin.
850      *
851      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
852      *
853      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
854      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
855      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
856      */
857     function admin() external ifAdmin returns (address admin_) {
858         admin_ = _getAdmin();
859     }
860 
861     /**
862      * @dev Returns the current implementation.
863      *
864      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
865      *
866      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
867      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
868      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
869      */
870     function implementation() external ifAdmin returns (address implementation_) {
871         implementation_ = _implementation();
872     }
873 
874     /**
875      * @dev Changes the admin of the proxy.
876      *
877      * Emits an {AdminChanged} event.
878      *
879      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
880      */
881     function changeAdmin(address newAdmin) external virtual ifAdmin {
882         _changeAdmin(newAdmin);
883     }
884 
885     /**
886      * @dev Upgrade the implementation of the proxy.
887      *
888      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
889      */
890     function upgradeTo(address newImplementation) external ifAdmin {
891         _upgradeToAndCall(newImplementation, bytes(""), false);
892     }
893 
894     /**
895      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
896      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
897      * proxied contract.
898      *
899      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
900      */
901     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
902         _upgradeToAndCall(newImplementation, data, true);
903     }
904 
905     /**
906      * @dev Returns the current admin.
907      */
908     function _admin() internal view virtual returns (address) {
909         return _getAdmin();
910     }
911 
912     /**
913      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
914      */
915     function _beforeFallback() internal virtual override {
916         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
917         super._beforeFallback();
918     }
919 }
920 
921 // File: @openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol
922 
923 
924 // OpenZeppelin Contracts v4.4.1 (proxy/transparent/ProxyAdmin.sol)
925 
926 pragma solidity 0.8.17;
927 
928 
929 
930 /**
931  * @dev This is an auxiliary contract meant to be assigned as the admin of a {TransparentUpgradeableProxy}. For an
932  * explanation of why you would want to use this see the documentation for {TransparentUpgradeableProxy}.
933  */
934 contract ProxyAdmin is Ownable {
935     /**
936      * @dev Returns the current implementation of `proxy`.
937      *
938      * Requirements:
939      *
940      * - This contract must be the admin of `proxy`.
941      */
942     function getProxyImplementation(TransparentUpgradeableProxy proxy) public view virtual returns (address) {
943         // We need to manually run the static call since the getter cannot be flagged as view
944         // bytes4(keccak256("implementation()")) == 0x5c60da1b
945         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"5c60da1b");
946         require(success);
947         return abi.decode(returndata, (address));
948     }
949 
950     /**
951      * @dev Returns the current admin of `proxy`.
952      *
953      * Requirements:
954      *
955      * - This contract must be the admin of `proxy`.
956      */
957     function getProxyAdmin(TransparentUpgradeableProxy proxy) public view virtual returns (address) {
958         // We need to manually run the static call since the getter cannot be flagged as view
959         // bytes4(keccak256("admin()")) == 0xf851a440
960         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"f851a440");
961         require(success);
962         return abi.decode(returndata, (address));
963     }
964 
965     /**
966      * @dev Changes the admin of `proxy` to `newAdmin`.
967      *
968      * Requirements:
969      *
970      * - This contract must be the current admin of `proxy`.
971      */
972     function changeProxyAdmin(TransparentUpgradeableProxy proxy, address newAdmin) public virtual onlyOwner {
973         proxy.changeAdmin(newAdmin);
974     }
975 
976     /**
977      * @dev Upgrades `proxy` to `implementation`. See {TransparentUpgradeableProxy-upgradeTo}.
978      *
979      * Requirements:
980      *
981      * - This contract must be the admin of `proxy`.
982      */
983     function upgrade(TransparentUpgradeableProxy proxy, address implementation) public virtual onlyOwner {
984         proxy.upgradeTo(implementation);
985     }
986 
987     /**
988      * @dev Upgrades `proxy` to `implementation` and calls a function on the new implementation. See
989      * {TransparentUpgradeableProxy-upgradeToAndCall}.
990      *
991      * Requirements:
992      *
993      * - This contract must be the admin of `proxy`.
994      */
995     function upgradeAndCall(
996         TransparentUpgradeableProxy proxy,
997         address implementation,
998         bytes memory data
999     ) public payable virtual onlyOwner {
1000         proxy.upgradeToAndCall{value: msg.value}(implementation, data);
1001     }
1002 }
1003 
1004 // File: contracts/TransperantUpgradebaleProxy.sol
1005 
1006 
1007 pragma solidity 0.8.17;
1008 
1009 
1010 
1011 
1012 // Kept for backwards compatibility with older versions of Hardhat and Truffle plugins.
1013 contract AdminUpgradeabilityProxy is TransparentUpgradeableProxy {
1014     constructor(address logic, address admin, bytes memory data) payable TransparentUpgradeableProxy(logic, admin, data) {}
1015 }