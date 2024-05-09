1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: @openzeppelin/contracts/utils/StorageSlot.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Library for reading and writing primitive types to specific storage slots.
122  *
123  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
124  * This library helps with reading and writing to such slots without the need for inline assembly.
125  *
126  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
127  *
128  * Example usage to set ERC1967 implementation slot:
129  * ```
130  * contract ERC1967 {
131  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
132  *
133  *     function _getImplementation() internal view returns (address) {
134  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
135  *     }
136  *
137  *     function _setImplementation(address newImplementation) internal {
138  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
139  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
140  *     }
141  * }
142  * ```
143  *
144  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
145  */
146 library StorageSlot {
147     struct AddressSlot {
148         address value;
149     }
150 
151     struct BooleanSlot {
152         bool value;
153     }
154 
155     struct Bytes32Slot {
156         bytes32 value;
157     }
158 
159     struct Uint256Slot {
160         uint256 value;
161     }
162 
163     /**
164      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
165      */
166     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
167         /// @solidity memory-safe-assembly
168         assembly {
169             r.slot := slot
170         }
171     }
172 
173     /**
174      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
175      */
176     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
177         /// @solidity memory-safe-assembly
178         assembly {
179             r.slot := slot
180         }
181     }
182 
183     /**
184      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
185      */
186     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
187         /// @solidity memory-safe-assembly
188         assembly {
189             r.slot := slot
190         }
191     }
192 
193     /**
194      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
195      */
196     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
197         /// @solidity memory-safe-assembly
198         assembly {
199             r.slot := slot
200         }
201     }
202 }
203 
204 // File: @openzeppelin/contracts/utils/Address.sol
205 
206 
207 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
208 
209 pragma solidity ^0.8.1;
210 
211 /**
212  * @dev Collection of functions related to the address type
213  */
214 library Address {
215     /**
216      * @dev Returns true if `account` is a contract.
217      *
218      * [IMPORTANT]
219      * ====
220      * It is unsafe to assume that an address for which this function returns
221      * false is an externally-owned account (EOA) and not a contract.
222      *
223      * Among others, `isContract` will return false for the following
224      * types of addresses:
225      *
226      *  - an externally-owned account
227      *  - a contract in construction
228      *  - an address where a contract will be created
229      *  - an address where a contract lived, but was destroyed
230      * ====
231      *
232      * [IMPORTANT]
233      * ====
234      * You shouldn't rely on `isContract` to protect against flash loan attacks!
235      *
236      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
237      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
238      * constructor.
239      * ====
240      */
241     function isContract(address account) internal view returns (bool) {
242         // This method relies on extcodesize/address.code.length, which returns 0
243         // for contracts in construction, since the code is only stored at the end
244         // of the constructor execution.
245 
246         return account.code.length > 0;
247     }
248 
249     /**
250      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
251      * `recipient`, forwarding all available gas and reverting on errors.
252      *
253      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
254      * of certain opcodes, possibly making contracts go over the 2300 gas limit
255      * imposed by `transfer`, making them unable to receive funds via
256      * `transfer`. {sendValue} removes this limitation.
257      *
258      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
259      *
260      * IMPORTANT: because control is transferred to `recipient`, care must be
261      * taken to not create reentrancy vulnerabilities. Consider using
262      * {ReentrancyGuard} or the
263      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
264      */
265     function sendValue(address payable recipient, uint256 amount) internal {
266         require(address(this).balance >= amount, "Address: insufficient balance");
267 
268         (bool success, ) = recipient.call{value: amount}("");
269         require(success, "Address: unable to send value, recipient may have reverted");
270     }
271 
272     /**
273      * @dev Performs a Solidity function call using a low level `call`. A
274      * plain `call` is an unsafe replacement for a function call: use this
275      * function instead.
276      *
277      * If `target` reverts with a revert reason, it is bubbled up by this
278      * function (like regular Solidity function calls).
279      *
280      * Returns the raw returned data. To convert to the expected return value,
281      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
282      *
283      * Requirements:
284      *
285      * - `target` must be a contract.
286      * - calling `target` with `data` must not revert.
287      *
288      * _Available since v3.1._
289      */
290     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
291         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
296      * `errorMessage` as a fallback revert reason when `target` reverts.
297      *
298      * _Available since v3.1._
299      */
300     function functionCall(
301         address target,
302         bytes memory data,
303         string memory errorMessage
304     ) internal returns (bytes memory) {
305         return functionCallWithValue(target, data, 0, errorMessage);
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
310      * but also transferring `value` wei to `target`.
311      *
312      * Requirements:
313      *
314      * - the calling contract must have an ETH balance of at least `value`.
315      * - the called Solidity function must be `payable`.
316      *
317      * _Available since v3.1._
318      */
319     function functionCallWithValue(
320         address target,
321         bytes memory data,
322         uint256 value
323     ) internal returns (bytes memory) {
324         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
329      * with `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(
334         address target,
335         bytes memory data,
336         uint256 value,
337         string memory errorMessage
338     ) internal returns (bytes memory) {
339         require(address(this).balance >= value, "Address: insufficient balance for call");
340         (bool success, bytes memory returndata) = target.call{value: value}(data);
341         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but performing a static call.
347      *
348      * _Available since v3.3._
349      */
350     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
351         return functionStaticCall(target, data, "Address: low-level static call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
356      * but performing a static call.
357      *
358      * _Available since v3.3._
359      */
360     function functionStaticCall(
361         address target,
362         bytes memory data,
363         string memory errorMessage
364     ) internal view returns (bytes memory) {
365         (bool success, bytes memory returndata) = target.staticcall(data);
366         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but performing a delegate call.
372      *
373      * _Available since v3.4._
374      */
375     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
376         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
381      * but performing a delegate call.
382      *
383      * _Available since v3.4._
384      */
385     function functionDelegateCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         (bool success, bytes memory returndata) = target.delegatecall(data);
391         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
392     }
393 
394     /**
395      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
396      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
397      *
398      * _Available since v4.8._
399      */
400     function verifyCallResultFromTarget(
401         address target,
402         bool success,
403         bytes memory returndata,
404         string memory errorMessage
405     ) internal view returns (bytes memory) {
406         if (success) {
407             if (returndata.length == 0) {
408                 // only check isContract if the call was successful and the return data is empty
409                 // otherwise we already know that it was a contract
410                 require(isContract(target), "Address: call to non-contract");
411             }
412             return returndata;
413         } else {
414             _revert(returndata, errorMessage);
415         }
416     }
417 
418     /**
419      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
420      * revert reason or using the provided one.
421      *
422      * _Available since v4.3._
423      */
424     function verifyCallResult(
425         bool success,
426         bytes memory returndata,
427         string memory errorMessage
428     ) internal pure returns (bytes memory) {
429         if (success) {
430             return returndata;
431         } else {
432             _revert(returndata, errorMessage);
433         }
434     }
435 
436     function _revert(bytes memory returndata, string memory errorMessage) private pure {
437         // Look for revert reason and bubble it up if present
438         if (returndata.length > 0) {
439             // The easiest way to bubble the revert reason is using memory via assembly
440             /// @solidity memory-safe-assembly
441             assembly {
442                 let returndata_size := mload(returndata)
443                 revert(add(32, returndata), returndata_size)
444             }
445         } else {
446             revert(errorMessage);
447         }
448     }
449 }
450 
451 // File: @openzeppelin/contracts/interfaces/draft-IERC1822.sol
452 
453 
454 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
455 
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
460  * proxy whose upgrades are fully controlled by the current implementation.
461  */
462 interface IERC1822Proxiable {
463     /**
464      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
465      * address.
466      *
467      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
468      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
469      * function revert if invoked through a proxy.
470      */
471     function proxiableUUID() external view returns (bytes32);
472 }
473 
474 // File: @openzeppelin/contracts/proxy/beacon/IBeacon.sol
475 
476 
477 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
478 
479 pragma solidity ^0.8.0;
480 
481 /**
482  * @dev This is the interface that {BeaconProxy} expects of its beacon.
483  */
484 interface IBeacon {
485     /**
486      * @dev Must return an address that can be used as a delegate call target.
487      *
488      * {BeaconProxy} will check that this address is a contract.
489      */
490     function implementation() external view returns (address);
491 }
492 
493 // File: @openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol
494 
495 
496 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
497 
498 pragma solidity ^0.8.2;
499 
500 
501 
502 
503 
504 /**
505  * @dev This abstract contract provides getters and event emitting update functions for
506  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
507  *
508  * _Available since v4.1._
509  *
510  * @custom:oz-upgrades-unsafe-allow delegatecall
511  */
512 abstract contract ERC1967Upgrade {
513     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
514     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
515 
516     /**
517      * @dev Storage slot with the address of the current implementation.
518      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
519      * validated in the constructor.
520      */
521     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
522 
523     /**
524      * @dev Emitted when the implementation is upgraded.
525      */
526     event Upgraded(address indexed implementation);
527 
528     /**
529      * @dev Returns the current implementation address.
530      */
531     function _getImplementation() internal view returns (address) {
532         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
533     }
534 
535     /**
536      * @dev Stores a new address in the EIP1967 implementation slot.
537      */
538     function _setImplementation(address newImplementation) private {
539         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
540         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
541     }
542 
543     /**
544      * @dev Perform implementation upgrade
545      *
546      * Emits an {Upgraded} event.
547      */
548     function _upgradeTo(address newImplementation) internal {
549         _setImplementation(newImplementation);
550         emit Upgraded(newImplementation);
551     }
552 
553     /**
554      * @dev Perform implementation upgrade with additional setup call.
555      *
556      * Emits an {Upgraded} event.
557      */
558     function _upgradeToAndCall(
559         address newImplementation,
560         bytes memory data,
561         bool forceCall
562     ) internal {
563         _upgradeTo(newImplementation);
564         if (data.length > 0 || forceCall) {
565             Address.functionDelegateCall(newImplementation, data);
566         }
567     }
568 
569     /**
570      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
571      *
572      * Emits an {Upgraded} event.
573      */
574     function _upgradeToAndCallUUPS(
575         address newImplementation,
576         bytes memory data,
577         bool forceCall
578     ) internal {
579         // Upgrades from old implementations will perform a rollback test. This test requires the new
580         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
581         // this special case will break upgrade paths from old UUPS implementation to new ones.
582         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
583             _setImplementation(newImplementation);
584         } else {
585             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
586                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
587             } catch {
588                 revert("ERC1967Upgrade: new implementation is not UUPS");
589             }
590             _upgradeToAndCall(newImplementation, data, forceCall);
591         }
592     }
593 
594     /**
595      * @dev Storage slot with the admin of the contract.
596      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
597      * validated in the constructor.
598      */
599     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
600 
601     /**
602      * @dev Emitted when the admin account has changed.
603      */
604     event AdminChanged(address previousAdmin, address newAdmin);
605 
606     /**
607      * @dev Returns the current admin.
608      */
609     function _getAdmin() internal view returns (address) {
610         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
611     }
612 
613     /**
614      * @dev Stores a new address in the EIP1967 admin slot.
615      */
616     function _setAdmin(address newAdmin) private {
617         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
618         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
619     }
620 
621     /**
622      * @dev Changes the admin of the proxy.
623      *
624      * Emits an {AdminChanged} event.
625      */
626     function _changeAdmin(address newAdmin) internal {
627         emit AdminChanged(_getAdmin(), newAdmin);
628         _setAdmin(newAdmin);
629     }
630 
631     /**
632      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
633      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
634      */
635     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
636 
637     /**
638      * @dev Emitted when the beacon is upgraded.
639      */
640     event BeaconUpgraded(address indexed beacon);
641 
642     /**
643      * @dev Returns the current beacon.
644      */
645     function _getBeacon() internal view returns (address) {
646         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
647     }
648 
649     /**
650      * @dev Stores a new beacon in the EIP1967 beacon slot.
651      */
652     function _setBeacon(address newBeacon) private {
653         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
654         require(
655             Address.isContract(IBeacon(newBeacon).implementation()),
656             "ERC1967: beacon implementation is not a contract"
657         );
658         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
659     }
660 
661     /**
662      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
663      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
664      *
665      * Emits a {BeaconUpgraded} event.
666      */
667     function _upgradeBeaconToAndCall(
668         address newBeacon,
669         bytes memory data,
670         bool forceCall
671     ) internal {
672         _setBeacon(newBeacon);
673         emit BeaconUpgraded(newBeacon);
674         if (data.length > 0 || forceCall) {
675             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
676         }
677     }
678 }
679 
680 // File: @openzeppelin/contracts/proxy/Proxy.sol
681 
682 
683 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
684 
685 pragma solidity ^0.8.0;
686 
687 /**
688  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
689  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
690  * be specified by overriding the virtual {_implementation} function.
691  *
692  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
693  * different contract through the {_delegate} function.
694  *
695  * The success and return data of the delegated call will be returned back to the caller of the proxy.
696  */
697 abstract contract Proxy {
698     /**
699      * @dev Delegates the current call to `implementation`.
700      *
701      * This function does not return to its internal call site, it will return directly to the external caller.
702      */
703     function _delegate(address implementation) internal virtual {
704         assembly {
705             // Copy msg.data. We take full control of memory in this inline assembly
706             // block because it will not return to Solidity code. We overwrite the
707             // Solidity scratch pad at memory position 0.
708             calldatacopy(0, 0, calldatasize())
709 
710             // Call the implementation.
711             // out and outsize are 0 because we don't know the size yet.
712             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
713 
714             // Copy the returned data.
715             returndatacopy(0, 0, returndatasize())
716 
717             switch result
718             // delegatecall returns 0 on error.
719             case 0 {
720                 revert(0, returndatasize())
721             }
722             default {
723                 return(0, returndatasize())
724             }
725         }
726     }
727 
728     /**
729      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
730      * and {_fallback} should delegate.
731      */
732     function _implementation() internal view virtual returns (address);
733 
734     /**
735      * @dev Delegates the current call to the address returned by `_implementation()`.
736      *
737      * This function does not return to its internal call site, it will return directly to the external caller.
738      */
739     function _fallback() internal virtual {
740         _beforeFallback();
741         _delegate(_implementation());
742     }
743 
744     /**
745      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
746      * function in the contract matches the call data.
747      */
748     fallback() external payable virtual {
749         _fallback();
750     }
751 
752     /**
753      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
754      * is empty.
755      */
756     receive() external payable virtual {
757         _fallback();
758     }
759 
760     /**
761      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
762      * call, or as part of the Solidity `fallback` or `receive` functions.
763      *
764      * If overridden should call `super._beforeFallback()`.
765      */
766     function _beforeFallback() internal virtual {}
767 }
768 
769 // File: @openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol
770 
771 
772 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
773 
774 pragma solidity ^0.8.0;
775 
776 
777 
778 /**
779  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
780  * implementation address that can be changed. This address is stored in storage in the location specified by
781  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
782  * implementation behind the proxy.
783  */
784 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
785     /**
786      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
787      *
788      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
789      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
790      */
791     constructor(address _logic, bytes memory _data) payable {
792         _upgradeToAndCall(_logic, _data, false);
793     }
794 
795     /**
796      * @dev Returns the current implementation address.
797      */
798     function _implementation() internal view virtual override returns (address impl) {
799         return ERC1967Upgrade._getImplementation();
800     }
801 }
802 
803 // File: @openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol
804 
805 
806 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/transparent/TransparentUpgradeableProxy.sol)
807 
808 pragma solidity ^0.8.0;
809 
810 
811 /**
812  * @dev This contract implements a proxy that is upgradeable by an admin.
813  *
814  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
815  * clashing], which can potentially be used in an attack, this contract uses the
816  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
817  * things that go hand in hand:
818  *
819  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
820  * that call matches one of the admin functions exposed by the proxy itself.
821  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
822  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
823  * "admin cannot fallback to proxy target".
824  *
825  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
826  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
827  * to sudden errors when trying to call a function from the proxy implementation.
828  *
829  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
830  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
831  */
832 contract TransparentUpgradeableProxy is ERC1967Proxy {
833     /**
834      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
835      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
836      */
837     constructor(
838         address _logic,
839         address admin_,
840         bytes memory _data
841     ) payable ERC1967Proxy(_logic, _data) {
842         _changeAdmin(admin_);
843     }
844 
845     /**
846      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
847      */
848     modifier ifAdmin() {
849         if (msg.sender == _getAdmin()) {
850             _;
851         } else {
852             _fallback();
853         }
854     }
855 
856     /**
857      * @dev Returns the current admin.
858      *
859      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
860      *
861      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
862      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
863      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
864      */
865     function admin() external ifAdmin returns (address admin_) {
866         admin_ = _getAdmin();
867     }
868 
869     /**
870      * @dev Returns the current implementation.
871      *
872      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
873      *
874      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
875      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
876      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
877      */
878     function implementation() external ifAdmin returns (address implementation_) {
879         implementation_ = _implementation();
880     }
881 
882     /**
883      * @dev Changes the admin of the proxy.
884      *
885      * Emits an {AdminChanged} event.
886      *
887      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
888      */
889     function changeAdmin(address newAdmin) external virtual ifAdmin {
890         _changeAdmin(newAdmin);
891     }
892 
893     /**
894      * @dev Upgrade the implementation of the proxy.
895      *
896      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
897      */
898     function upgradeTo(address newImplementation) external ifAdmin {
899         _upgradeToAndCall(newImplementation, bytes(""), false);
900     }
901 
902     /**
903      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
904      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
905      * proxied contract.
906      *
907      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
908      */
909     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
910         _upgradeToAndCall(newImplementation, data, true);
911     }
912 
913     /**
914      * @dev Returns the current admin.
915      */
916     function _admin() internal view virtual returns (address) {
917         return _getAdmin();
918     }
919 
920     /**
921      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
922      */
923     function _beforeFallback() internal virtual override {
924         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
925         super._beforeFallback();
926     }
927 }
928 
929 // File: @openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol
930 
931 
932 // OpenZeppelin Contracts v4.4.1 (proxy/transparent/ProxyAdmin.sol)
933 
934 pragma solidity ^0.8.0;
935 
936 
937 
938 /**
939  * @dev This is an auxiliary contract meant to be assigned as the admin of a {TransparentUpgradeableProxy}. For an
940  * explanation of why you would want to use this see the documentation for {TransparentUpgradeableProxy}.
941  */
942 contract ProxyAdmin is Ownable {
943     /**
944      * @dev Returns the current implementation of `proxy`.
945      *
946      * Requirements:
947      *
948      * - This contract must be the admin of `proxy`.
949      */
950     function getProxyImplementation(TransparentUpgradeableProxy proxy) public view virtual returns (address) {
951         // We need to manually run the static call since the getter cannot be flagged as view
952         // bytes4(keccak256("implementation()")) == 0x5c60da1b
953         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"5c60da1b");
954         require(success);
955         return abi.decode(returndata, (address));
956     }
957 
958     /**
959      * @dev Returns the current admin of `proxy`.
960      *
961      * Requirements:
962      *
963      * - This contract must be the admin of `proxy`.
964      */
965     function getProxyAdmin(TransparentUpgradeableProxy proxy) public view virtual returns (address) {
966         // We need to manually run the static call since the getter cannot be flagged as view
967         // bytes4(keccak256("admin()")) == 0xf851a440
968         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"f851a440");
969         require(success);
970         return abi.decode(returndata, (address));
971     }
972 
973     /**
974      * @dev Changes the admin of `proxy` to `newAdmin`.
975      *
976      * Requirements:
977      *
978      * - This contract must be the current admin of `proxy`.
979      */
980     function changeProxyAdmin(TransparentUpgradeableProxy proxy, address newAdmin) public virtual onlyOwner {
981         proxy.changeAdmin(newAdmin);
982     }
983 
984     /**
985      * @dev Upgrades `proxy` to `implementation`. See {TransparentUpgradeableProxy-upgradeTo}.
986      *
987      * Requirements:
988      *
989      * - This contract must be the admin of `proxy`.
990      */
991     function upgrade(TransparentUpgradeableProxy proxy, address implementation) public virtual onlyOwner {
992         proxy.upgradeTo(implementation);
993     }
994 
995     /**
996      * @dev Upgrades `proxy` to `implementation` and calls a function on the new implementation. See
997      * {TransparentUpgradeableProxy-upgradeToAndCall}.
998      *
999      * Requirements:
1000      *
1001      * - This contract must be the admin of `proxy`.
1002      */
1003     function upgradeAndCall(
1004         TransparentUpgradeableProxy proxy,
1005         address implementation,
1006         bytes memory data
1007     ) public payable virtual onlyOwner {
1008         proxy.upgradeToAndCall{value: msg.value}(implementation, data);
1009     }
1010 }
1011 
1012 // File: BondPay_proxy.sol
1013 
1014 
1015 pragma solidity ^0.8.12;
1016 
1017 
1018 
1019 
1020 // Kept for backwards compatibility with older versions of Hardhat and Truffle plugins.
1021 contract AdminUpgradeabilityProxy is TransparentUpgradeableProxy {
1022     constructor(address logic, address admin, bytes memory data) payable TransparentUpgradeableProxy(logic, admin, data) {}
1023 }