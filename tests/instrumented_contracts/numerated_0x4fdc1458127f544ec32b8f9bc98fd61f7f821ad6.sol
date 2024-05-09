1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 // File: contracts/access/Ownable.sol
25 
26 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 abstract contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(
46         address indexed previousOwner,
47         address indexed newOwner
48     );
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor() {
54         _transferOwnership(_msgSender());
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         _checkOwner();
62         _;
63     }
64 
65     /**
66      * @dev Returns the address of the current owner.
67      */
68     function owner() public view virtual returns (address) {
69         return _owner;
70     }
71 
72     /**
73      * @dev Throws if the sender is not the owner.
74      */
75     function _checkOwner() internal view virtual {
76         require(owner() == _msgSender(), "Ownable: caller is not the owner");
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         _transferOwnership(address(0));
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(
96             newOwner != address(0),
97             "Ownable: new owner is the zero address"
98         );
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
113 // File: contracts/utils/StorageSlot.sol
114 
115 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Library for reading and writing primitive types to specific storage slots.
121  *
122  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
123  * This library helps with reading and writing to such slots without the need for inline assembly.
124  *
125  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
126  *
127  * Example usage to set ERC1967 implementation slot:
128  * ```
129  * contract ERC1967 {
130  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
131  *
132  *     function _getImplementation() internal view returns (address) {
133  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
134  *     }
135  *
136  *     function _setImplementation(address newImplementation) internal {
137  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
138  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
139  *     }
140  * }
141  * ```
142  *
143  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
144  */
145 library StorageSlot {
146     struct AddressSlot {
147         address value;
148     }
149 
150     struct BooleanSlot {
151         bool value;
152     }
153 
154     struct Bytes32Slot {
155         bytes32 value;
156     }
157 
158     struct Uint256Slot {
159         uint256 value;
160     }
161 
162     /**
163      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
164      */
165     function getAddressSlot(bytes32 slot)
166         internal
167         pure
168         returns (AddressSlot storage r)
169     {
170         /// @solidity memory-safe-assembly
171         assembly {
172             r.slot := slot
173         }
174     }
175 
176     /**
177      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
178      */
179     function getBooleanSlot(bytes32 slot)
180         internal
181         pure
182         returns (BooleanSlot storage r)
183     {
184         /// @solidity memory-safe-assembly
185         assembly {
186             r.slot := slot
187         }
188     }
189 
190     /**
191      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
192      */
193     function getBytes32Slot(bytes32 slot)
194         internal
195         pure
196         returns (Bytes32Slot storage r)
197     {
198         /// @solidity memory-safe-assembly
199         assembly {
200             r.slot := slot
201         }
202     }
203 
204     /**
205      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
206      */
207     function getUint256Slot(bytes32 slot)
208         internal
209         pure
210         returns (Uint256Slot storage r)
211     {
212         /// @solidity memory-safe-assembly
213         assembly {
214             r.slot := slot
215         }
216     }
217 }
218 
219 // File: contracts/utils/Address.sol
220 
221 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
222 
223 pragma solidity ^0.8.1;
224 
225 /**
226  * @dev Collection of functions related to the address type
227  */
228 library Address {
229     /**
230      * @dev Returns true if `account` is a contract.
231      *
232      * [IMPORTANT]
233      * ====
234      * It is unsafe to assume that an address for which this function returns
235      * false is an externally-owned account (EOA) and not a contract.
236      *
237      * Among others, `isContract` will return false for the following
238      * types of addresses:
239      *
240      *  - an externally-owned account
241      *  - a contract in construction
242      *  - an address where a contract will be created
243      *  - an address where a contract lived, but was destroyed
244      * ====
245      *
246      * [IMPORTANT]
247      * ====
248      * You shouldn't rely on `isContract` to protect against flash loan attacks!
249      *
250      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
251      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
252      * constructor.
253      * ====
254      */
255     function isContract(address account) internal view returns (bool) {
256         // This method relies on extcodesize/address.code.length, which returns 0
257         // for contracts in construction, since the code is only stored at the end
258         // of the constructor execution.
259 
260         return account.code.length > 0;
261     }
262 
263     /**
264      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
265      * `recipient`, forwarding all available gas and reverting on errors.
266      *
267      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
268      * of certain opcodes, possibly making contracts go over the 2300 gas limit
269      * imposed by `transfer`, making them unable to receive funds via
270      * `transfer`. {sendValue} removes this limitation.
271      *
272      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
273      *
274      * IMPORTANT: because control is transferred to `recipient`, care must be
275      * taken to not create reentrancy vulnerabilities. Consider using
276      * {ReentrancyGuard} or the
277      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
278      */
279     function sendValue(address payable recipient, uint256 amount) internal {
280         require(
281             address(this).balance >= amount,
282             "Address: insufficient balance"
283         );
284 
285         (bool success, ) = recipient.call{value: amount}("");
286         require(
287             success,
288             "Address: unable to send value, recipient may have reverted"
289         );
290     }
291 
292     /**
293      * @dev Performs a Solidity function call using a low level `call`. A
294      * plain `call` is an unsafe replacement for a function call: use this
295      * function instead.
296      *
297      * If `target` reverts with a revert reason, it is bubbled up by this
298      * function (like regular Solidity function calls).
299      *
300      * Returns the raw returned data. To convert to the expected return value,
301      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
302      *
303      * Requirements:
304      *
305      * - `target` must be a contract.
306      * - calling `target` with `data` must not revert.
307      *
308      * _Available since v3.1._
309      */
310     function functionCall(address target, bytes memory data)
311         internal
312         returns (bytes memory)
313     {
314         return
315             functionCallWithValue(
316                 target,
317                 data,
318                 0,
319                 "Address: low-level call failed"
320             );
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325      * `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(
330         address target,
331         bytes memory data,
332         string memory errorMessage
333     ) internal returns (bytes memory) {
334         return functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(
349         address target,
350         bytes memory data,
351         uint256 value
352     ) internal returns (bytes memory) {
353         return
354             functionCallWithValue(
355                 target,
356                 data,
357                 value,
358                 "Address: low-level call with value failed"
359             );
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
364      * with `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(
369         address target,
370         bytes memory data,
371         uint256 value,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         require(
375             address(this).balance >= value,
376             "Address: insufficient balance for call"
377         );
378         (bool success, bytes memory returndata) = target.call{value: value}(
379             data
380         );
381         return
382             verifyCallResultFromTarget(
383                 target,
384                 success,
385                 returndata,
386                 errorMessage
387             );
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but performing a static call.
393      *
394      * _Available since v3.3._
395      */
396     function functionStaticCall(address target, bytes memory data)
397         internal
398         view
399         returns (bytes memory)
400     {
401         return
402             functionStaticCall(
403                 target,
404                 data,
405                 "Address: low-level static call failed"
406             );
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
411      * but performing a static call.
412      *
413      * _Available since v3.3._
414      */
415     function functionStaticCall(
416         address target,
417         bytes memory data,
418         string memory errorMessage
419     ) internal view returns (bytes memory) {
420         (bool success, bytes memory returndata) = target.staticcall(data);
421         return
422             verifyCallResultFromTarget(
423                 target,
424                 success,
425                 returndata,
426                 errorMessage
427             );
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but performing a delegate call.
433      *
434      * _Available since v3.4._
435      */
436     function functionDelegateCall(address target, bytes memory data)
437         internal
438         returns (bytes memory)
439     {
440         return
441             functionDelegateCall(
442                 target,
443                 data,
444                 "Address: low-level delegate call failed"
445             );
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
450      * but performing a delegate call.
451      *
452      * _Available since v3.4._
453      */
454     function functionDelegateCall(
455         address target,
456         bytes memory data,
457         string memory errorMessage
458     ) internal returns (bytes memory) {
459         (bool success, bytes memory returndata) = target.delegatecall(data);
460         return
461             verifyCallResultFromTarget(
462                 target,
463                 success,
464                 returndata,
465                 errorMessage
466             );
467     }
468 
469     /**
470      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
471      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
472      *
473      * _Available since v4.8._
474      */
475     function verifyCallResultFromTarget(
476         address target,
477         bool success,
478         bytes memory returndata,
479         string memory errorMessage
480     ) internal view returns (bytes memory) {
481         if (success) {
482             if (returndata.length == 0) {
483                 // only check isContract if the call was successful and the return data is empty
484                 // otherwise we already know that it was a contract
485                 require(isContract(target), "Address: call to non-contract");
486             }
487             return returndata;
488         } else {
489             _revert(returndata, errorMessage);
490         }
491     }
492 
493     /**
494      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
495      * revert reason or using the provided one.
496      *
497      * _Available since v4.3._
498      */
499     function verifyCallResult(
500         bool success,
501         bytes memory returndata,
502         string memory errorMessage
503     ) internal pure returns (bytes memory) {
504         if (success) {
505             return returndata;
506         } else {
507             _revert(returndata, errorMessage);
508         }
509     }
510 
511     function _revert(bytes memory returndata, string memory errorMessage)
512         private
513         pure
514     {
515         // Look for revert reason and bubble it up if present
516         if (returndata.length > 0) {
517             // The easiest way to bubble the revert reason is using memory via assembly
518             /// @solidity memory-safe-assembly
519             assembly {
520                 let returndata_size := mload(returndata)
521                 revert(add(32, returndata), returndata_size)
522             }
523         } else {
524             revert(errorMessage);
525         }
526     }
527 }
528 
529 // File: contracts/interfaces/draft-IERC1822.sol
530 
531 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 /**
536  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
537  * proxy whose upgrades are fully controlled by the current implementation.
538  */
539 interface IERC1822Proxiable {
540     /**
541      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
542      * address.
543      *
544      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
545      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
546      * function revert if invoked through a proxy.
547      */
548     function proxiableUUID() external view returns (bytes32);
549 }
550 
551 // File: contracts/proxy/beacon/IBeacon.sol
552 
553 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 /**
558  * @dev This is the interface that {BeaconProxy} expects of its beacon.
559  */
560 interface IBeacon {
561     /**
562      * @dev Must return an address that can be used as a delegate call target.
563      *
564      * {BeaconProxy} will check that this address is a contract.
565      */
566     function implementation() external view returns (address);
567 }
568 
569 // File: contracts/proxy/ERC1967/ERC1967Upgrade.sol
570 
571 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
572 
573 pragma solidity ^0.8.2;
574 
575 /**
576  * @dev This abstract contract provides getters and event emitting update functions for
577  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
578  *
579  * _Available since v4.1._
580  *
581  * @custom:oz-upgrades-unsafe-allow delegatecall
582  */
583 abstract contract ERC1967Upgrade {
584     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
585     bytes32 private constant _ROLLBACK_SLOT =
586         0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
587 
588     /**
589      * @dev Storage slot with the address of the current implementation.
590      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
591      * validated in the constructor.
592      */
593     bytes32 internal constant _IMPLEMENTATION_SLOT =
594         0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
595 
596     /**
597      * @dev Emitted when the implementation is upgraded.
598      */
599     event Upgraded(address indexed implementation);
600 
601     /**
602      * @dev Returns the current implementation address.
603      */
604     function _getImplementation() internal view returns (address) {
605         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
606     }
607 
608     /**
609      * @dev Stores a new address in the EIP1967 implementation slot.
610      */
611     function _setImplementation(address newImplementation) private {
612         require(
613             Address.isContract(newImplementation),
614             "ERC1967: new implementation is not a contract"
615         );
616         StorageSlot
617             .getAddressSlot(_IMPLEMENTATION_SLOT)
618             .value = newImplementation;
619     }
620 
621     /**
622      * @dev Perform implementation upgrade
623      *
624      * Emits an {Upgraded} event.
625      */
626     function _upgradeTo(address newImplementation) internal {
627         _setImplementation(newImplementation);
628         emit Upgraded(newImplementation);
629     }
630 
631     /**
632      * @dev Perform implementation upgrade with additional setup call.
633      *
634      * Emits an {Upgraded} event.
635      */
636     function _upgradeToAndCall(
637         address newImplementation,
638         bytes memory data,
639         bool forceCall
640     ) internal {
641         _upgradeTo(newImplementation);
642         if (data.length > 0 || forceCall) {
643             Address.functionDelegateCall(newImplementation, data);
644         }
645     }
646 
647     /**
648      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
649      *
650      * Emits an {Upgraded} event.
651      */
652     function _upgradeToAndCallUUPS(
653         address newImplementation,
654         bytes memory data,
655         bool forceCall
656     ) internal {
657         // Upgrades from old implementations will perform a rollback test. This test requires the new
658         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
659         // this special case will break upgrade paths from old UUPS implementation to new ones.
660         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
661             _setImplementation(newImplementation);
662         } else {
663             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (
664                 bytes32 slot
665             ) {
666                 require(
667                     slot == _IMPLEMENTATION_SLOT,
668                     "ERC1967Upgrade: unsupported proxiableUUID"
669                 );
670             } catch {
671                 revert("ERC1967Upgrade: new implementation is not UUPS");
672             }
673             _upgradeToAndCall(newImplementation, data, forceCall);
674         }
675     }
676 
677     /**
678      * @dev Storage slot with the admin of the contract.
679      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
680      * validated in the constructor.
681      */
682     bytes32 internal constant _ADMIN_SLOT =
683         0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
684 
685     /**
686      * @dev Emitted when the admin account has changed.
687      */
688     event AdminChanged(address previousAdmin, address newAdmin);
689 
690     /**
691      * @dev Returns the current admin.
692      */
693     function _getAdmin() internal view returns (address) {
694         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
695     }
696 
697     /**
698      * @dev Stores a new address in the EIP1967 admin slot.
699      */
700     function _setAdmin(address newAdmin) private {
701         require(
702             newAdmin != address(0),
703             "ERC1967: new admin is the zero address"
704         );
705         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
706     }
707 
708     /**
709      * @dev Changes the admin of the proxy.
710      *
711      * Emits an {AdminChanged} event.
712      */
713     function _changeAdmin(address newAdmin) internal {
714         emit AdminChanged(_getAdmin(), newAdmin);
715         _setAdmin(newAdmin);
716     }
717 
718     /**
719      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
720      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
721      */
722     bytes32 internal constant _BEACON_SLOT =
723         0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
724 
725     /**
726      * @dev Emitted when the beacon is upgraded.
727      */
728     event BeaconUpgraded(address indexed beacon);
729 
730     /**
731      * @dev Returns the current beacon.
732      */
733     function _getBeacon() internal view returns (address) {
734         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
735     }
736 
737     /**
738      * @dev Stores a new beacon in the EIP1967 beacon slot.
739      */
740     function _setBeacon(address newBeacon) private {
741         require(
742             Address.isContract(newBeacon),
743             "ERC1967: new beacon is not a contract"
744         );
745         require(
746             Address.isContract(IBeacon(newBeacon).implementation()),
747             "ERC1967: beacon implementation is not a contract"
748         );
749         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
750     }
751 
752     /**
753      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
754      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
755      *
756      * Emits a {BeaconUpgraded} event.
757      */
758     function _upgradeBeaconToAndCall(
759         address newBeacon,
760         bytes memory data,
761         bool forceCall
762     ) internal {
763         _setBeacon(newBeacon);
764         emit BeaconUpgraded(newBeacon);
765         if (data.length > 0 || forceCall) {
766             Address.functionDelegateCall(
767                 IBeacon(newBeacon).implementation(),
768                 data
769             );
770         }
771     }
772 }
773 
774 // File: contracts/proxy/utils/UUPSUpgradeable.sol
775 
776 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/utils/UUPSUpgradeable.sol)
777 
778 pragma solidity ^0.8.0;
779 
780 /**
781  * @dev An upgradeability mechanism designed for UUPS proxies. The functions included here can perform an upgrade of an
782  * {ERC1967Proxy}, when this contract is set as the implementation behind such a proxy.
783  *
784  * A security mechanism ensures that an upgrade does not turn off upgradeability accidentally, although this risk is
785  * reinstated if the upgrade retains upgradeability but removes the security mechanism, e.g. by replacing
786  * `UUPSUpgradeable` with a custom implementation of upgrades.
787  *
788  * The {_authorizeUpgrade} function must be overridden to include access restriction to the upgrade mechanism.
789  *
790  * _Available since v4.1._
791  */
792 abstract contract UUPSUpgradeable is IERC1822Proxiable, ERC1967Upgrade {
793     /// @custom:oz-upgrades-unsafe-allow state-variable-immutable state-variable-assignment
794     address private immutable __self = address(this);
795 
796     /**
797      * @dev Check that the execution is being performed through a delegatecall call and that the execution context is
798      * a proxy contract with an implementation (as defined in ERC1967) pointing to self. This should only be the case
799      * for UUPS and transparent proxies that are using the current contract as their implementation. Execution of a
800      * function through ERC1167 minimal proxies (clones) would not normally pass this test, but is not guaranteed to
801      * fail.
802      */
803     modifier onlyProxy() {
804         require(
805             address(this) != __self,
806             "Function must be called through delegatecall"
807         );
808         require(
809             _getImplementation() == __self,
810             "Function must be called through active proxy"
811         );
812         _;
813     }
814 
815     /**
816      * @dev Check that the execution is not being performed through a delegate call. This allows a function to be
817      * callable on the implementing contract but not through proxies.
818      */
819     modifier notDelegated() {
820         require(
821             address(this) == __self,
822             "UUPSUpgradeable: must not be called through delegatecall"
823         );
824         _;
825     }
826 
827     /**
828      * @dev Implementation of the ERC1822 {proxiableUUID} function. This returns the storage slot used by the
829      * implementation. It is used to validate that the this implementation remains valid after an upgrade.
830      *
831      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
832      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
833      * function revert if invoked through a proxy. This is guaranteed by the `notDelegated` modifier.
834      */
835     function proxiableUUID()
836         external
837         view
838         virtual
839         override
840         notDelegated
841         returns (bytes32)
842     {
843         return _IMPLEMENTATION_SLOT;
844     }
845 
846     /**
847      * @dev Upgrade the implementation of the proxy to `newImplementation`.
848      *
849      * Calls {_authorizeUpgrade}.
850      *
851      * Emits an {Upgraded} event.
852      */
853     function upgradeTo(address newImplementation) external virtual onlyProxy {
854         _authorizeUpgrade(newImplementation);
855         _upgradeToAndCallUUPS(newImplementation, new bytes(0), false);
856     }
857 
858     /**
859      * @dev Upgrade the implementation of the proxy to `newImplementation`, and subsequently execute the function call
860      * encoded in `data`.
861      *
862      * Calls {_authorizeUpgrade}.
863      *
864      * Emits an {Upgraded} event.
865      */
866     function upgradeToAndCall(address newImplementation, bytes memory data)
867         external
868         payable
869         virtual
870         onlyProxy
871     {
872         _authorizeUpgrade(newImplementation);
873         _upgradeToAndCallUUPS(newImplementation, data, true);
874     }
875 
876     /**
877      * @dev Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
878      * {upgradeTo} and {upgradeToAndCall}.
879      *
880      * Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.
881      *
882      * ```solidity
883      * function _authorizeUpgrade(address) internal override onlyOwner {}
884      * ```
885      */
886     function _authorizeUpgrade(address newImplementation) internal virtual;
887 }
888 
889 // File: contracts/proxy/Proxy.sol
890 
891 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
892 
893 pragma solidity ^0.8.0;
894 
895 /**
896  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
897  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
898  * be specified by overriding the virtual {_implementation} function.
899  *
900  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
901  * different contract through the {_delegate} function.
902  *
903  * The success and return data of the delegated call will be returned back to the caller of the proxy.
904  */
905 abstract contract Proxy {
906     /**
907      * @dev Delegates the current call to `implementation`.
908      *
909      * This function does not return to its internal call site, it will return directly to the external caller.
910      */
911     function _delegate(address implementation) internal virtual {
912         assembly {
913             // Copy msg.data. We take full control of memory in this inline assembly
914             // block because it will not return to Solidity code. We overwrite the
915             // Solidity scratch pad at memory position 0.
916             calldatacopy(0, 0, calldatasize())
917 
918             // Call the implementation.
919             // out and outsize are 0 because we don't know the size yet.
920             let result := delegatecall(
921                 gas(),
922                 implementation,
923                 0,
924                 calldatasize(),
925                 0,
926                 0
927             )
928 
929             // Copy the returned data.
930             returndatacopy(0, 0, returndatasize())
931 
932             switch result
933             // delegatecall returns 0 on error.
934             case 0 {
935                 revert(0, returndatasize())
936             }
937             default {
938                 return(0, returndatasize())
939             }
940         }
941     }
942 
943     /**
944      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
945      * and {_fallback} should delegate.
946      */
947     function _implementation() internal view virtual returns (address);
948 
949     /**
950      * @dev Delegates the current call to the address returned by `_implementation()`.
951      *
952      * This function does not return to its internal call site, it will return directly to the external caller.
953      */
954     function _fallback() internal virtual {
955         _beforeFallback();
956         _delegate(_implementation());
957     }
958 
959     /**
960      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
961      * function in the contract matches the call data.
962      */
963     fallback() external payable virtual {
964         _fallback();
965     }
966 
967     /**
968      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
969      * is empty.
970      */
971     receive() external payable virtual {
972         _fallback();
973     }
974 
975     /**
976      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
977      * call, or as part of the Solidity `fallback` or `receive` functions.
978      *
979      * If overridden should call `super._beforeFallback()`.
980      */
981     function _beforeFallback() internal virtual {}
982 }
983 
984 // File: contracts/proxy/ERC1967/ERC1967Proxy.sol
985 
986 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
987 
988 pragma solidity ^0.8.0;
989 
990 /**
991  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
992  * implementation address that can be changed. This address is stored in storage in the location specified by
993  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
994  * implementation behind the proxy.
995  */
996 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
997     /**
998      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
999      *
1000      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
1001      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
1002      */
1003     constructor(address _logic, bytes memory _data) payable {
1004         _upgradeToAndCall(_logic, _data, false);
1005     }
1006 
1007     /**
1008      * @dev Returns the current implementation address.
1009      */
1010     function _implementation()
1011         internal
1012         view
1013         virtual
1014         override
1015         returns (address impl)
1016     {
1017         return ERC1967Upgrade._getImplementation();
1018     }
1019 }
1020 
1021 // File: contracts/proxy/transparent/TransparentUpgradeableProxy.sol
1022 
1023 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/transparent/TransparentUpgradeableProxy.sol)
1024 
1025 pragma solidity ^0.8.0;
1026 
1027 /**
1028  * @dev This contract implements a proxy that is upgradeable by an admin.
1029  *
1030  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
1031  * clashing], which can potentially be used in an attack, this contract uses the
1032  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
1033  * things that go hand in hand:
1034  *
1035  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
1036  * that call matches one of the admin functions exposed by the proxy itself.
1037  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
1038  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
1039  * "admin cannot fallback to proxy target".
1040  *
1041  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
1042  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
1043  * to sudden errors when trying to call a function from the proxy implementation.
1044  *
1045  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
1046  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
1047  */
1048 contract TransparentUpgradeableProxy is ERC1967Proxy {
1049     /**
1050      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
1051      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
1052      */
1053     constructor(
1054         address _logic,
1055         address admin_,
1056         bytes memory _data
1057     ) payable ERC1967Proxy(_logic, _data) {
1058         _changeAdmin(admin_);
1059     }
1060 
1061     /**
1062      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
1063      */
1064     modifier ifAdmin() {
1065         if (msg.sender == _getAdmin()) {
1066             _;
1067         } else {
1068             _fallback();
1069         }
1070     }
1071 
1072     /**
1073      * @dev Returns the current admin.
1074      *
1075      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
1076      *
1077      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
1078      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
1079      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
1080      */
1081     function admin() external ifAdmin returns (address admin_) {
1082         admin_ = _getAdmin();
1083     }
1084 
1085     /**
1086      * @dev Returns the current implementation.
1087      *
1088      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
1089      *
1090      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
1091      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
1092      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
1093      */
1094     function implementation()
1095         external
1096         ifAdmin
1097         returns (address implementation_)
1098     {
1099         implementation_ = _implementation();
1100     }
1101 
1102     /**
1103      * @dev Changes the admin of the proxy.
1104      *
1105      * Emits an {AdminChanged} event.
1106      *
1107      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
1108      */
1109     function changeAdmin(address newAdmin) external virtual ifAdmin {
1110         _changeAdmin(newAdmin);
1111     }
1112 
1113     /**
1114      * @dev Upgrade the implementation of the proxy.
1115      *
1116      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
1117      */
1118     function upgradeTo(address newImplementation) external ifAdmin {
1119         _upgradeToAndCall(newImplementation, bytes(""), false);
1120     }
1121 
1122     /**
1123      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
1124      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
1125      * proxied contract.
1126      *
1127      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
1128      */
1129     function upgradeToAndCall(address newImplementation, bytes calldata data)
1130         external
1131         payable
1132         ifAdmin
1133     {
1134         _upgradeToAndCall(newImplementation, data, true);
1135     }
1136 
1137     /**
1138      * @dev Returns the current admin.
1139      */
1140     function _admin() internal view virtual returns (address) {
1141         return _getAdmin();
1142     }
1143 
1144     /**
1145      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
1146      */
1147     function _beforeFallback() internal virtual override {
1148         require(
1149             msg.sender != _getAdmin(),
1150             "TransparentUpgradeableProxy: admin cannot fallback to proxy target"
1151         );
1152         super._beforeFallback();
1153     }
1154 }
1155 
1156 // File: contracts/proxy/transparent/ProxyAdmin.sol
1157 
1158 // OpenZeppelin Contracts v4.4.1 (proxy/transparent/ProxyAdmin.sol)
1159 
1160 pragma solidity ^0.8.0;
1161 
1162 /**
1163  * @dev This is an auxiliary contract meant to be assigned as the admin of a {TransparentUpgradeableProxy}. For an
1164  * explanation of why you would want to use this see the documentation for {TransparentUpgradeableProxy}.
1165  */
1166 contract ProxyAdmin is Ownable {
1167     /**
1168      * @dev Returns the current implementation of `proxy`.
1169      *
1170      * Requirements:
1171      *
1172      * - This contract must be the admin of `proxy`.
1173      */
1174     function getProxyImplementation(TransparentUpgradeableProxy proxy)
1175         public
1176         view
1177         virtual
1178         returns (address)
1179     {
1180         // We need to manually run the static call since the getter cannot be flagged as view
1181         // bytes4(keccak256("implementation()")) == 0x5c60da1b
1182         (bool success, bytes memory returndata) = address(proxy).staticcall(
1183             hex"5c60da1b"
1184         );
1185         require(success);
1186         return abi.decode(returndata, (address));
1187     }
1188 
1189     /**
1190      * @dev Returns the current admin of `proxy`.
1191      *
1192      * Requirements:
1193      *
1194      * - This contract must be the admin of `proxy`.
1195      */
1196     function getProxyAdmin(TransparentUpgradeableProxy proxy)
1197         public
1198         view
1199         virtual
1200         returns (address)
1201     {
1202         // We need to manually run the static call since the getter cannot be flagged as view
1203         // bytes4(keccak256("admin()")) == 0xf851a440
1204         (bool success, bytes memory returndata) = address(proxy).staticcall(
1205             hex"f851a440"
1206         );
1207         require(success);
1208         return abi.decode(returndata, (address));
1209     }
1210 
1211     /**
1212      * @dev Changes the admin of `proxy` to `newAdmin`.
1213      *
1214      * Requirements:
1215      *
1216      * - This contract must be the current admin of `proxy`.
1217      */
1218     function changeProxyAdmin(
1219         TransparentUpgradeableProxy proxy,
1220         address newAdmin
1221     ) public virtual onlyOwner {
1222         proxy.changeAdmin(newAdmin);
1223     }
1224 
1225     /**
1226      * @dev Upgrades `proxy` to `implementation`. See {TransparentUpgradeableProxy-upgradeTo}.
1227      *
1228      * Requirements:
1229      *
1230      * - This contract must be the admin of `proxy`.
1231      */
1232     function upgrade(TransparentUpgradeableProxy proxy, address implementation)
1233         public
1234         virtual
1235         onlyOwner
1236     {
1237         proxy.upgradeTo(implementation);
1238     }
1239 
1240     /**
1241      * @dev Upgrades `proxy` to `implementation` and calls a function on the new implementation. See
1242      * {TransparentUpgradeableProxy-upgradeToAndCall}.
1243      *
1244      * Requirements:
1245      *
1246      * - This contract must be the admin of `proxy`.
1247      */
1248     function upgradeAndCall(
1249         TransparentUpgradeableProxy proxy,
1250         address implementation,
1251         bytes memory data
1252     ) public payable virtual onlyOwner {
1253         proxy.upgradeToAndCall{value: msg.value}(implementation, data);
1254     }
1255 }
1256 
1257 // File: token/erc19profxy.sol
1258 
1259 pragma solidity ^0.8.0;
1260 
1261 // Kept for backwards compatibility with older versions of Hardhat and Truffle plugins.
1262 contract AdminUpgradeabilityProxy1 is TransparentUpgradeableProxy {
1263     constructor(
1264         address logic,
1265         address admin,
1266         bytes memory data
1267     ) payable TransparentUpgradeableProxy(logic, admin, data) {}
1268 }