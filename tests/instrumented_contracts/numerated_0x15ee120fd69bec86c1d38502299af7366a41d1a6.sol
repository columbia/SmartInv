1 pragma solidity ^0.8.0;
2 
3 // SPDX-License-Identifier: MIT
4 
5 
6 
7 
8 
9 
10 
11 /**
12  * @dev This is the interface that {BeaconProxy} expects of its beacon.
13  */
14 interface IBeaconUpgradeable {
15     /**
16      * @dev Must return an address that can be used as a delegate call target.
17      *
18      * {BeaconProxy} will check that this address is a contract.
19      */
20     function implementation() external view returns (address);
21 }
22 
23 
24 
25 /**
26  * @dev Collection of functions related to the address type
27  */
28 library AddressUpgradeable {
29     /**
30      * @dev Returns true if `account` is a contract.
31      *
32      * [IMPORTANT]
33      * ====
34      * It is unsafe to assume that an address for which this function returns
35      * false is an externally-owned account (EOA) and not a contract.
36      *
37      * Among others, `isContract` will return false for the following
38      * types of addresses:
39      *
40      *  - an externally-owned account
41      *  - a contract in construction
42      *  - an address where a contract will be created
43      *  - an address where a contract lived, but was destroyed
44      * ====
45      */
46     function isContract(address account) internal view returns (bool) {
47         // This method relies on extcodesize, which returns 0 for contracts in
48         // construction, since the code is only stored at the end of the
49         // constructor execution.
50 
51         uint256 size;
52         assembly {
53             size := extcodesize(account)
54         }
55         return size > 0;
56     }
57 
58     /**
59      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
60      * `recipient`, forwarding all available gas and reverting on errors.
61      *
62      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
63      * of certain opcodes, possibly making contracts go over the 2300 gas limit
64      * imposed by `transfer`, making them unable to receive funds via
65      * `transfer`. {sendValue} removes this limitation.
66      *
67      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
68      *
69      * IMPORTANT: because control is transferred to `recipient`, care must be
70      * taken to not create reentrancy vulnerabilities. Consider using
71      * {ReentrancyGuard} or the
72      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
73      */
74     function sendValue(address payable recipient, uint256 amount) internal {
75         require(address(this).balance >= amount, "Address: insufficient balance");
76 
77         (bool success, ) = recipient.call{value: amount}("");
78         require(success, "Address: unable to send value, recipient may have reverted");
79     }
80 
81     /**
82      * @dev Performs a Solidity function call using a low level `call`. A
83      * plain `call` is an unsafe replacement for a function call: use this
84      * function instead.
85      *
86      * If `target` reverts with a revert reason, it is bubbled up by this
87      * function (like regular Solidity function calls).
88      *
89      * Returns the raw returned data. To convert to the expected return value,
90      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
91      *
92      * Requirements:
93      *
94      * - `target` must be a contract.
95      * - calling `target` with `data` must not revert.
96      *
97      * _Available since v3.1._
98      */
99     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
100         return functionCall(target, data, "Address: low-level call failed");
101     }
102 
103     /**
104      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
105      * `errorMessage` as a fallback revert reason when `target` reverts.
106      *
107      * _Available since v3.1._
108      */
109     function functionCall(
110         address target,
111         bytes memory data,
112         string memory errorMessage
113     ) internal returns (bytes memory) {
114         return functionCallWithValue(target, data, 0, errorMessage);
115     }
116 
117     /**
118      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
119      * but also transferring `value` wei to `target`.
120      *
121      * Requirements:
122      *
123      * - the calling contract must have an ETH balance of at least `value`.
124      * - the called Solidity function must be `payable`.
125      *
126      * _Available since v3.1._
127      */
128     function functionCallWithValue(
129         address target,
130         bytes memory data,
131         uint256 value
132     ) internal returns (bytes memory) {
133         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
134     }
135 
136     /**
137      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
138      * with `errorMessage` as a fallback revert reason when `target` reverts.
139      *
140      * _Available since v3.1._
141      */
142     function functionCallWithValue(
143         address target,
144         bytes memory data,
145         uint256 value,
146         string memory errorMessage
147     ) internal returns (bytes memory) {
148         require(address(this).balance >= value, "Address: insufficient balance for call");
149         require(isContract(target), "Address: call to non-contract");
150 
151         (bool success, bytes memory returndata) = target.call{value: value}(data);
152         return verifyCallResult(success, returndata, errorMessage);
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
157      * but performing a static call.
158      *
159      * _Available since v3.3._
160      */
161     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
162         return functionStaticCall(target, data, "Address: low-level static call failed");
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
167      * but performing a static call.
168      *
169      * _Available since v3.3._
170      */
171     function functionStaticCall(
172         address target,
173         bytes memory data,
174         string memory errorMessage
175     ) internal view returns (bytes memory) {
176         require(isContract(target), "Address: static call to non-contract");
177 
178         (bool success, bytes memory returndata) = target.staticcall(data);
179         return verifyCallResult(success, returndata, errorMessage);
180     }
181 
182     /**
183      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
184      * revert reason using the provided one.
185      *
186      * _Available since v4.3._
187      */
188     function verifyCallResult(
189         bool success,
190         bytes memory returndata,
191         string memory errorMessage
192     ) internal pure returns (bytes memory) {
193         if (success) {
194             return returndata;
195         } else {
196             // Look for revert reason and bubble it up if present
197             if (returndata.length > 0) {
198                 // The easiest way to bubble the revert reason is using memory via assembly
199 
200                 assembly {
201                     let returndata_size := mload(returndata)
202                     revert(add(32, returndata), returndata_size)
203                 }
204             } else {
205                 revert(errorMessage);
206             }
207         }
208     }
209 }
210 
211 
212 
213 /**
214  * @dev Library for reading and writing primitive types to specific storage slots.
215  *
216  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
217  * This library helps with reading and writing to such slots without the need for inline assembly.
218  *
219  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
220  *
221  * Example usage to set ERC1967 implementation slot:
222  * ```
223  * contract ERC1967 {
224  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
225  *
226  *     function _getImplementation() internal view returns (address) {
227  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
228  *     }
229  *
230  *     function _setImplementation(address newImplementation) internal {
231  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
232  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
233  *     }
234  * }
235  * ```
236  *
237  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
238  */
239 library StorageSlotUpgradeable {
240     struct AddressSlot {
241         address value;
242     }
243 
244     struct BooleanSlot {
245         bool value;
246     }
247 
248     struct Bytes32Slot {
249         bytes32 value;
250     }
251 
252     struct Uint256Slot {
253         uint256 value;
254     }
255 
256     /**
257      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
258      */
259     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
260         assembly {
261             r.slot := slot
262         }
263     }
264 
265     /**
266      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
267      */
268     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
269         assembly {
270             r.slot := slot
271         }
272     }
273 
274     /**
275      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
276      */
277     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
278         assembly {
279             r.slot := slot
280         }
281     }
282 
283     /**
284      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
285      */
286     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
287         assembly {
288             r.slot := slot
289         }
290     }
291 }
292 
293 
294 
295 /**
296  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
297  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
298  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
299  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
300  *
301  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
302  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
303  *
304  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
305  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
306  */
307 abstract contract Initializable {
308     /**
309      * @dev Indicates that the contract has been initialized.
310      */
311     bool private _initialized;
312 
313     /**
314      * @dev Indicates that the contract is in the process of being initialized.
315      */
316     bool private _initializing;
317 
318     /**
319      * @dev Modifier to protect an initializer function from being invoked twice.
320      */
321     modifier initializer() {
322         require(_initializing || !_initialized, "Initializable: contract is already initialized");
323 
324         bool isTopLevelCall = !_initializing;
325         if (isTopLevelCall) {
326             _initializing = true;
327             _initialized = true;
328         }
329 
330         _;
331 
332         if (isTopLevelCall) {
333             _initializing = false;
334         }
335     }
336 }
337 
338 /**
339  * @dev This abstract contract provides getters and event emitting update functions for
340  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
341  *
342  * _Available since v4.1._
343  *
344  * @custom:oz-upgrades-unsafe-allow delegatecall
345  */
346 abstract contract ERC1967UpgradeUpgradeable is Initializable {
347     function __ERC1967Upgrade_init() internal initializer {
348         __ERC1967Upgrade_init_unchained();
349     }
350 
351     function __ERC1967Upgrade_init_unchained() internal initializer {
352     }
353     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
354     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
355 
356     /**
357      * @dev Storage slot with the address of the current implementation.
358      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
359      * validated in the constructor.
360      */
361     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
362 
363     /**
364      * @dev Emitted when the implementation is upgraded.
365      */
366     event Upgraded(address indexed implementation);
367 
368     /**
369      * @dev Returns the current implementation address.
370      */
371     function _getImplementation() internal view returns (address) {
372         return StorageSlotUpgradeable.getAddressSlot(_IMPLEMENTATION_SLOT).value;
373     }
374 
375     /**
376      * @dev Stores a new address in the EIP1967 implementation slot.
377      */
378     function _setImplementation(address newImplementation) private {
379         require(AddressUpgradeable.isContract(newImplementation), "ERC1967: new implementation is not a contract");
380         StorageSlotUpgradeable.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
381     }
382 
383     /**
384      * @dev Perform implementation upgrade
385      *
386      * Emits an {Upgraded} event.
387      */
388     function _upgradeTo(address newImplementation) internal {
389         _setImplementation(newImplementation);
390         emit Upgraded(newImplementation);
391     }
392 
393     /**
394      * @dev Perform implementation upgrade with additional setup call.
395      *
396      * Emits an {Upgraded} event.
397      */
398     function _upgradeToAndCall(
399         address newImplementation,
400         bytes memory data,
401         bool forceCall
402     ) internal {
403         _upgradeTo(newImplementation);
404         if (data.length > 0 || forceCall) {
405             _functionDelegateCall(newImplementation, data);
406         }
407     }
408 
409     /**
410      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
411      *
412      * Emits an {Upgraded} event.
413      */
414     function _upgradeToAndCallSecure(
415         address newImplementation,
416         bytes memory data,
417         bool forceCall
418     ) internal {
419         address oldImplementation = _getImplementation();
420 
421         // Initial upgrade and setup call
422         _setImplementation(newImplementation);
423         if (data.length > 0 || forceCall) {
424             _functionDelegateCall(newImplementation, data);
425         }
426 
427         // Perform rollback test if not already in progress
428         StorageSlotUpgradeable.BooleanSlot storage rollbackTesting = StorageSlotUpgradeable.getBooleanSlot(_ROLLBACK_SLOT);
429         if (!rollbackTesting.value) {
430             // Trigger rollback using upgradeTo from the new implementation
431             rollbackTesting.value = true;
432             _functionDelegateCall(
433                 newImplementation,
434                 abi.encodeWithSignature("upgradeTo(address)", oldImplementation)
435             );
436             rollbackTesting.value = false;
437             // Check rollback was effective
438             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
439             // Finally reset to the new implementation and log the upgrade
440             _upgradeTo(newImplementation);
441         }
442     }
443 
444     /**
445      * @dev Storage slot with the admin of the contract.
446      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
447      * validated in the constructor.
448      */
449     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
450 
451     /**
452      * @dev Emitted when the admin account has changed.
453      */
454     event AdminChanged(address previousAdmin, address newAdmin);
455 
456     /**
457      * @dev Returns the current admin.
458      */
459     function _getAdmin() internal view returns (address) {
460         return StorageSlotUpgradeable.getAddressSlot(_ADMIN_SLOT).value;
461     }
462 
463     /**
464      * @dev Stores a new address in the EIP1967 admin slot.
465      */
466     function _setAdmin(address newAdmin) private {
467         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
468         StorageSlotUpgradeable.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
469     }
470 
471     /**
472      * @dev Changes the admin of the proxy.
473      *
474      * Emits an {AdminChanged} event.
475      */
476     function _changeAdmin(address newAdmin) internal {
477         emit AdminChanged(_getAdmin(), newAdmin);
478         _setAdmin(newAdmin);
479     }
480 
481     /**
482      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
483      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
484      */
485     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
486 
487     /**
488      * @dev Emitted when the beacon is upgraded.
489      */
490     event BeaconUpgraded(address indexed beacon);
491 
492     /**
493      * @dev Returns the current beacon.
494      */
495     function _getBeacon() internal view returns (address) {
496         return StorageSlotUpgradeable.getAddressSlot(_BEACON_SLOT).value;
497     }
498 
499     /**
500      * @dev Stores a new beacon in the EIP1967 beacon slot.
501      */
502     function _setBeacon(address newBeacon) private {
503         require(AddressUpgradeable.isContract(newBeacon), "ERC1967: new beacon is not a contract");
504         require(
505             AddressUpgradeable.isContract(IBeaconUpgradeable(newBeacon).implementation()),
506             "ERC1967: beacon implementation is not a contract"
507         );
508         StorageSlotUpgradeable.getAddressSlot(_BEACON_SLOT).value = newBeacon;
509     }
510 
511     /**
512      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
513      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
514      *
515      * Emits a {BeaconUpgraded} event.
516      */
517     function _upgradeBeaconToAndCall(
518         address newBeacon,
519         bytes memory data,
520         bool forceCall
521     ) internal {
522         _setBeacon(newBeacon);
523         emit BeaconUpgraded(newBeacon);
524         if (data.length > 0 || forceCall) {
525             _functionDelegateCall(IBeaconUpgradeable(newBeacon).implementation(), data);
526         }
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
531      * but performing a delegate call.
532      *
533      * _Available since v3.4._
534      */
535     function _functionDelegateCall(address target, bytes memory data) private returns (bytes memory) {
536         require(AddressUpgradeable.isContract(target), "Address: delegate call to non-contract");
537 
538         // solhint-disable-next-line avoid-low-level-calls
539         (bool success, bytes memory returndata) = target.delegatecall(data);
540         return AddressUpgradeable.verifyCallResult(success, returndata, "Address: low-level delegate call failed");
541     }
542     uint256[50] private __gap;
543 }
544 
545 /**
546  * @dev An upgradeability mechanism designed for UUPS proxies. The functions included here can perform an upgrade of an
547  * {ERC1967Proxy}, when this contract is set as the implementation behind such a proxy.
548  *
549  * A security mechanism ensures that an upgrade does not turn off upgradeability accidentally, although this risk is
550  * reinstated if the upgrade retains upgradeability but removes the security mechanism, e.g. by replacing
551  * `UUPSUpgradeable` with a custom implementation of upgrades.
552  *
553  * The {_authorizeUpgrade} function must be overridden to include access restriction to the upgrade mechanism.
554  *
555  * _Available since v4.1._
556  */
557 abstract contract UUPSUpgradeable is Initializable, ERC1967UpgradeUpgradeable {
558     function __UUPSUpgradeable_init() internal initializer {
559         __ERC1967Upgrade_init_unchained();
560         __UUPSUpgradeable_init_unchained();
561     }
562 
563     function __UUPSUpgradeable_init_unchained() internal initializer {
564     }
565     /// @custom:oz-upgrades-unsafe-allow state-variable-immutable state-variable-assignment
566     address private immutable __self = address(this);
567 
568     /**
569      * @dev Check that the execution is being performed through a delegatecall call and that the execution context is
570      * a proxy contract with an implementation (as defined in ERC1967) pointing to self. This should only be the case
571      * for UUPS and transparent proxies that are using the current contract as their implementation. Execution of a
572      * function through ERC1167 minimal proxies (clones) would not normally pass this test, but is not guaranteed to
573      * fail.
574      */
575     modifier onlyProxy() {
576         require(address(this) != __self, "Function must be called through delegatecall");
577         require(_getImplementation() == __self, "Function must be called through active proxy");
578         _;
579     }
580 
581     /**
582      * @dev Upgrade the implementation of the proxy to `newImplementation`.
583      *
584      * Calls {_authorizeUpgrade}.
585      *
586      * Emits an {Upgraded} event.
587      */
588     function upgradeTo(address newImplementation) external virtual onlyProxy {
589         _authorizeUpgrade(newImplementation);
590         _upgradeToAndCallSecure(newImplementation, new bytes(0), false);
591     }
592 
593     /**
594      * @dev Upgrade the implementation of the proxy to `newImplementation`, and subsequently execute the function call
595      * encoded in `data`.
596      *
597      * Calls {_authorizeUpgrade}.
598      *
599      * Emits an {Upgraded} event.
600      */
601     function upgradeToAndCall(address newImplementation, bytes memory data) external payable virtual onlyProxy {
602         _authorizeUpgrade(newImplementation);
603         _upgradeToAndCallSecure(newImplementation, data, true);
604     }
605 
606     /**
607      * @dev Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
608      * {upgradeTo} and {upgradeToAndCall}.
609      *
610      * Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.
611      *
612      * ```solidity
613      * function _authorizeUpgrade(address) internal override onlyOwner {}
614      * ```
615      */
616     function _authorizeUpgrade(address newImplementation) internal virtual;
617     uint256[50] private __gap;
618 }
619 
620 
621 
622 
623 
624 /**
625  * @dev Provides information about the current execution context, including the
626  * sender of the transaction and its data. While these are generally available
627  * via msg.sender and msg.data, they should not be accessed in such a direct
628  * manner, since when dealing with meta-transactions the account sending and
629  * paying for execution may not be the actual sender (as far as an application
630  * is concerned).
631  *
632  * This contract is only required for intermediate, library-like contracts.
633  */
634 abstract contract ContextUpgradeable is Initializable {
635     function __Context_init() internal initializer {
636         __Context_init_unchained();
637     }
638 
639     function __Context_init_unchained() internal initializer {
640     }
641     function _msgSender() internal view virtual returns (address) {
642         return msg.sender;
643     }
644 
645     function _msgData() internal view virtual returns (bytes calldata) {
646         return msg.data;
647     }
648     uint256[50] private __gap;
649 }
650 
651 /**
652  * @dev Contract module which provides a basic access control mechanism, where
653  * there is an account (an owner) that can be granted exclusive access to
654  * specific functions.
655  *
656  * By default, the owner account will be the one that deploys the contract. This
657  * can later be changed with {transferOwnership}.
658  *
659  * This module is used through inheritance. It will make available the modifier
660  * `onlyOwner`, which can be applied to your functions to restrict their use to
661  * the owner.
662  */
663 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
664     address private _owner;
665 
666     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
667 
668     /**
669      * @dev Initializes the contract setting the deployer as the initial owner.
670      */
671     function __Ownable_init() internal initializer {
672         __Context_init_unchained();
673         __Ownable_init_unchained();
674     }
675 
676     function __Ownable_init_unchained() internal initializer {
677         _setOwner(_msgSender());
678     }
679 
680     /**
681      * @dev Returns the address of the current owner.
682      */
683     function owner() public view virtual returns (address) {
684         return _owner;
685     }
686 
687     /**
688      * @dev Throws if called by any account other than the owner.
689      */
690     modifier onlyOwner() {
691         require(owner() == _msgSender(), "Ownable: caller is not the owner");
692         _;
693     }
694 
695     /**
696      * @dev Leaves the contract without owner. It will not be possible to call
697      * `onlyOwner` functions anymore. Can only be called by the current owner.
698      *
699      * NOTE: Renouncing ownership will leave the contract without an owner,
700      * thereby removing any functionality that is only available to the owner.
701      */
702     function renounceOwnership() public virtual onlyOwner {
703         _setOwner(address(0));
704     }
705 
706     /**
707      * @dev Transfers ownership of the contract to a new account (`newOwner`).
708      * Can only be called by the current owner.
709      */
710     function transferOwnership(address newOwner) public virtual onlyOwner {
711         require(newOwner != address(0), "Ownable: new owner is the zero address");
712         _setOwner(newOwner);
713     }
714 
715     function _setOwner(address newOwner) private {
716         address oldOwner = _owner;
717         _owner = newOwner;
718         emit OwnershipTransferred(oldOwner, newOwner);
719     }
720     uint256[49] private __gap;
721 }
722 
723 
724 
725 
726 
727 /**
728  * @dev Interface of the ERC20 standard as defined in the EIP.
729  */
730 interface IERC20Upgradeable {
731     /**
732      * @dev Returns the amount of tokens in existence.
733      */
734     function totalSupply() external view returns (uint256);
735 
736     /**
737      * @dev Returns the amount of tokens owned by `account`.
738      */
739     function balanceOf(address account) external view returns (uint256);
740 
741     /**
742      * @dev Moves `amount` tokens from the caller's account to `recipient`.
743      *
744      * Returns a boolean value indicating whether the operation succeeded.
745      *
746      * Emits a {Transfer} event.
747      */
748     function transfer(address recipient, uint256 amount) external returns (bool);
749 
750     /**
751      * @dev Returns the remaining number of tokens that `spender` will be
752      * allowed to spend on behalf of `owner` through {transferFrom}. This is
753      * zero by default.
754      *
755      * This value changes when {approve} or {transferFrom} are called.
756      */
757     function allowance(address owner, address spender) external view returns (uint256);
758 
759     /**
760      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
761      *
762      * Returns a boolean value indicating whether the operation succeeded.
763      *
764      * IMPORTANT: Beware that changing an allowance with this method brings the risk
765      * that someone may use both the old and the new allowance by unfortunate
766      * transaction ordering. One possible solution to mitigate this race
767      * condition is to first reduce the spender's allowance to 0 and set the
768      * desired value afterwards:
769      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
770      *
771      * Emits an {Approval} event.
772      */
773     function approve(address spender, uint256 amount) external returns (bool);
774 
775     /**
776      * @dev Moves `amount` tokens from `sender` to `recipient` using the
777      * allowance mechanism. `amount` is then deducted from the caller's
778      * allowance.
779      *
780      * Returns a boolean value indicating whether the operation succeeded.
781      *
782      * Emits a {Transfer} event.
783      */
784     function transferFrom(
785         address sender,
786         address recipient,
787         uint256 amount
788     ) external returns (bool);
789 
790     /**
791      * @dev Emitted when `value` tokens are moved from one account (`from`) to
792      * another (`to`).
793      *
794      * Note that `value` may be zero.
795      */
796     event Transfer(address indexed from, address indexed to, uint256 value);
797 
798     /**
799      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
800      * a call to {approve}. `value` is the new allowance.
801      */
802     event Approval(address indexed owner, address indexed spender, uint256 value);
803 }
804 
805 
806 
807 /**
808  * @dev Interface for the optional metadata functions from the ERC20 standard.
809  *
810  * _Available since v4.1._
811  */
812 interface IERC20MetadataUpgradeable is IERC20Upgradeable {
813     /**
814      * @dev Returns the name of the token.
815      */
816     function name() external view returns (string memory);
817 
818     /**
819      * @dev Returns the symbol of the token.
820      */
821     function symbol() external view returns (string memory);
822 
823     /**
824      * @dev Returns the decimals places of the token.
825      */
826     function decimals() external view returns (uint8);
827 }
828 
829 /**
830  * @dev Implementation of the {IERC20} interface.
831  *
832  * This implementation is agnostic to the way tokens are created. This means
833  * that a supply mechanism has to be added in a derived contract using {_mint}.
834  * For a generic mechanism see {ERC20PresetMinterPauser}.
835  *
836  * TIP: For a detailed writeup see our guide
837  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
838  * to implement supply mechanisms].
839  *
840  * We have followed general OpenZeppelin Contracts guidelines: functions revert
841  * instead returning `false` on failure. This behavior is nonetheless
842  * conventional and does not conflict with the expectations of ERC20
843  * applications.
844  *
845  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
846  * This allows applications to reconstruct the allowance for all accounts just
847  * by listening to said events. Other implementations of the EIP may not emit
848  * these events, as it isn't required by the specification.
849  *
850  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
851  * functions have been added to mitigate the well-known issues around setting
852  * allowances. See {IERC20-approve}.
853  */
854 contract ERC20Upgradeable is Initializable, ContextUpgradeable, IERC20Upgradeable, IERC20MetadataUpgradeable {
855     mapping(address => uint256) private _balances;
856 
857     mapping(address => mapping(address => uint256)) private _allowances;
858 
859     uint256 private _totalSupply;
860 
861     string private _name;
862     string private _symbol;
863 
864     /**
865      * @dev Sets the values for {name} and {symbol}.
866      *
867      * The default value of {decimals} is 18. To select a different value for
868      * {decimals} you should overload it.
869      *
870      * All two of these values are immutable: they can only be set once during
871      * construction.
872      */
873     function __ERC20_init(string memory name_, string memory symbol_) internal initializer {
874         __Context_init_unchained();
875         __ERC20_init_unchained(name_, symbol_);
876     }
877 
878     function __ERC20_init_unchained(string memory name_, string memory symbol_) internal initializer {
879         _name = name_;
880         _symbol = symbol_;
881     }
882 
883     /**
884      * @dev Returns the name of the token.
885      */
886     function name() public view virtual override returns (string memory) {
887         return _name;
888     }
889 
890     /**
891      * @dev Returns the symbol of the token, usually a shorter version of the
892      * name.
893      */
894     function symbol() public view virtual override returns (string memory) {
895         return _symbol;
896     }
897 
898     /**
899      * @dev Returns the number of decimals used to get its user representation.
900      * For example, if `decimals` equals `2`, a balance of `505` tokens should
901      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
902      *
903      * Tokens usually opt for a value of 18, imitating the relationship between
904      * Ether and Wei. This is the value {ERC20} uses, unless this function is
905      * overridden;
906      *
907      * NOTE: This information is only used for _display_ purposes: it in
908      * no way affects any of the arithmetic of the contract, including
909      * {IERC20-balanceOf} and {IERC20-transfer}.
910      */
911     function decimals() public view virtual override returns (uint8) {
912         return 18;
913     }
914 
915     /**
916      * @dev See {IERC20-totalSupply}.
917      */
918     function totalSupply() public view virtual override returns (uint256) {
919         return _totalSupply;
920     }
921 
922     /**
923      * @dev See {IERC20-balanceOf}.
924      */
925     function balanceOf(address account) public view virtual override returns (uint256) {
926         return _balances[account];
927     }
928 
929     /**
930      * @dev See {IERC20-transfer}.
931      *
932      * Requirements:
933      *
934      * - `recipient` cannot be the zero address.
935      * - the caller must have a balance of at least `amount`.
936      */
937     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
938         _transfer(_msgSender(), recipient, amount);
939         return true;
940     }
941 
942     /**
943      * @dev See {IERC20-allowance}.
944      */
945     function allowance(address owner, address spender) public view virtual override returns (uint256) {
946         return _allowances[owner][spender];
947     }
948 
949     /**
950      * @dev See {IERC20-approve}.
951      *
952      * Requirements:
953      *
954      * - `spender` cannot be the zero address.
955      */
956     function approve(address spender, uint256 amount) public virtual override returns (bool) {
957         _approve(_msgSender(), spender, amount);
958         return true;
959     }
960 
961     /**
962      * @dev See {IERC20-transferFrom}.
963      *
964      * Emits an {Approval} event indicating the updated allowance. This is not
965      * required by the EIP. See the note at the beginning of {ERC20}.
966      *
967      * Requirements:
968      *
969      * - `sender` and `recipient` cannot be the zero address.
970      * - `sender` must have a balance of at least `amount`.
971      * - the caller must have allowance for ``sender``'s tokens of at least
972      * `amount`.
973      */
974     function transferFrom(
975         address sender,
976         address recipient,
977         uint256 amount
978     ) public virtual override returns (bool) {
979         _transfer(sender, recipient, amount);
980 
981         uint256 currentAllowance = _allowances[sender][_msgSender()];
982         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
983         unchecked {
984             _approve(sender, _msgSender(), currentAllowance - amount);
985         }
986 
987         return true;
988     }
989 
990     /**
991      * @dev Atomically increases the allowance granted to `spender` by the caller.
992      *
993      * This is an alternative to {approve} that can be used as a mitigation for
994      * problems described in {IERC20-approve}.
995      *
996      * Emits an {Approval} event indicating the updated allowance.
997      *
998      * Requirements:
999      *
1000      * - `spender` cannot be the zero address.
1001      */
1002     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1003         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1004         return true;
1005     }
1006 
1007     /**
1008      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1009      *
1010      * This is an alternative to {approve} that can be used as a mitigation for
1011      * problems described in {IERC20-approve}.
1012      *
1013      * Emits an {Approval} event indicating the updated allowance.
1014      *
1015      * Requirements:
1016      *
1017      * - `spender` cannot be the zero address.
1018      * - `spender` must have allowance for the caller of at least
1019      * `subtractedValue`.
1020      */
1021     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1022         uint256 currentAllowance = _allowances[_msgSender()][spender];
1023         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1024         unchecked {
1025             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1026         }
1027 
1028         return true;
1029     }
1030 
1031     /**
1032      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1033      *
1034      * This internal function is equivalent to {transfer}, and can be used to
1035      * e.g. implement automatic token fees, slashing mechanisms, etc.
1036      *
1037      * Emits a {Transfer} event.
1038      *
1039      * Requirements:
1040      *
1041      * - `sender` cannot be the zero address.
1042      * - `recipient` cannot be the zero address.
1043      * - `sender` must have a balance of at least `amount`.
1044      */
1045     function _transfer(
1046         address sender,
1047         address recipient,
1048         uint256 amount
1049     ) internal virtual {
1050         require(sender != address(0), "ERC20: transfer from the zero address");
1051         require(recipient != address(0), "ERC20: transfer to the zero address");
1052 
1053         _beforeTokenTransfer(sender, recipient, amount);
1054 
1055         uint256 senderBalance = _balances[sender];
1056         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1057         unchecked {
1058             _balances[sender] = senderBalance - amount;
1059         }
1060         _balances[recipient] += amount;
1061 
1062         emit Transfer(sender, recipient, amount);
1063 
1064         _afterTokenTransfer(sender, recipient, amount);
1065     }
1066 
1067     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1068      * the total supply.
1069      *
1070      * Emits a {Transfer} event with `from` set to the zero address.
1071      *
1072      * Requirements:
1073      *
1074      * - `account` cannot be the zero address.
1075      */
1076     function _mint(address account, uint256 amount) internal virtual {
1077         require(account != address(0), "ERC20: mint to the zero address");
1078 
1079         _beforeTokenTransfer(address(0), account, amount);
1080 
1081         _totalSupply += amount;
1082         _balances[account] += amount;
1083         emit Transfer(address(0), account, amount);
1084 
1085         _afterTokenTransfer(address(0), account, amount);
1086     }
1087 
1088     /**
1089      * @dev Destroys `amount` tokens from `account`, reducing the
1090      * total supply.
1091      *
1092      * Emits a {Transfer} event with `to` set to the zero address.
1093      *
1094      * Requirements:
1095      *
1096      * - `account` cannot be the zero address.
1097      * - `account` must have at least `amount` tokens.
1098      */
1099     function _burn(address account, uint256 amount) internal virtual {
1100         require(account != address(0), "ERC20: burn from the zero address");
1101 
1102         _beforeTokenTransfer(account, address(0), amount);
1103 
1104         uint256 accountBalance = _balances[account];
1105         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1106         unchecked {
1107             _balances[account] = accountBalance - amount;
1108         }
1109         _totalSupply -= amount;
1110 
1111         emit Transfer(account, address(0), amount);
1112 
1113         _afterTokenTransfer(account, address(0), amount);
1114     }
1115 
1116     /**
1117      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1118      *
1119      * This internal function is equivalent to `approve`, and can be used to
1120      * e.g. set automatic allowances for certain subsystems, etc.
1121      *
1122      * Emits an {Approval} event.
1123      *
1124      * Requirements:
1125      *
1126      * - `owner` cannot be the zero address.
1127      * - `spender` cannot be the zero address.
1128      */
1129     function _approve(
1130         address owner,
1131         address spender,
1132         uint256 amount
1133     ) internal virtual {
1134         require(owner != address(0), "ERC20: approve from the zero address");
1135         require(spender != address(0), "ERC20: approve to the zero address");
1136 
1137         _allowances[owner][spender] = amount;
1138         emit Approval(owner, spender, amount);
1139     }
1140 
1141     /**
1142      * @dev Hook that is called before any transfer of tokens. This includes
1143      * minting and burning.
1144      *
1145      * Calling conditions:
1146      *
1147      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1148      * will be transferred to `to`.
1149      * - when `from` is zero, `amount` tokens will be minted for `to`.
1150      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1151      * - `from` and `to` are never both zero.
1152      *
1153      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1154      */
1155     function _beforeTokenTransfer(
1156         address from,
1157         address to,
1158         uint256 amount
1159     ) internal virtual {}
1160 
1161     /**
1162      * @dev Hook that is called after any transfer of tokens. This includes
1163      * minting and burning.
1164      *
1165      * Calling conditions:
1166      *
1167      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1168      * has been transferred to `to`.
1169      * - when `from` is zero, `amount` tokens have been minted for `to`.
1170      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1171      * - `from` and `to` are never both zero.
1172      *
1173      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1174      */
1175     function _afterTokenTransfer(
1176         address from,
1177         address to,
1178         uint256 amount
1179     ) internal virtual {}
1180     uint256[45] private __gap;
1181 }
1182 
1183 
1184 
1185 /**
1186  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1187  * tokens and those that they have an allowance for, in a way that can be
1188  * recognized off-chain (via event analysis).
1189  */
1190 abstract contract ERC20BurnableUpgradeable is Initializable, ContextUpgradeable, ERC20Upgradeable {
1191     function __ERC20Burnable_init() internal initializer {
1192         __Context_init_unchained();
1193         __ERC20Burnable_init_unchained();
1194     }
1195 
1196     function __ERC20Burnable_init_unchained() internal initializer {
1197     }
1198     /**
1199      * @dev Destroys `amount` tokens from the caller.
1200      *
1201      * See {ERC20-_burn}.
1202      */
1203     function burn(uint256 amount) public virtual {
1204         _burn(_msgSender(), amount);
1205     }
1206 
1207     /**
1208      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1209      * allowance.
1210      *
1211      * See {ERC20-_burn} and {ERC20-allowance}.
1212      *
1213      * Requirements:
1214      *
1215      * - the caller must have allowance for ``accounts``'s tokens of at least
1216      * `amount`.
1217      */
1218     function burnFrom(address account, uint256 amount) public virtual {
1219         uint256 currentAllowance = allowance(account, _msgSender());
1220         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
1221         unchecked {
1222             _approve(account, _msgSender(), currentAllowance - amount);
1223         }
1224         _burn(account, amount);
1225     }
1226     uint256[50] private __gap;
1227 }
1228 
1229 
1230 
1231 
1232 
1233 /**
1234  * @dev Contract module which allows children to implement an emergency stop
1235  * mechanism that can be triggered by an authorized account.
1236  *
1237  * This module is used through inheritance. It will make available the
1238  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1239  * the functions of your contract. Note that they will not be pausable by
1240  * simply including this module, only once the modifiers are put in place.
1241  */
1242 abstract contract PausableUpgradeable is Initializable, ContextUpgradeable {
1243     /**
1244      * @dev Emitted when the pause is triggered by `account`.
1245      */
1246     event Paused(address account);
1247 
1248     /**
1249      * @dev Emitted when the pause is lifted by `account`.
1250      */
1251     event Unpaused(address account);
1252 
1253     bool private _paused;
1254 
1255     /**
1256      * @dev Initializes the contract in unpaused state.
1257      */
1258     function __Pausable_init() internal initializer {
1259         __Context_init_unchained();
1260         __Pausable_init_unchained();
1261     }
1262 
1263     function __Pausable_init_unchained() internal initializer {
1264         _paused = false;
1265     }
1266 
1267     /**
1268      * @dev Returns true if the contract is paused, and false otherwise.
1269      */
1270     function paused() public view virtual returns (bool) {
1271         return _paused;
1272     }
1273 
1274     /**
1275      * @dev Modifier to make a function callable only when the contract is not paused.
1276      *
1277      * Requirements:
1278      *
1279      * - The contract must not be paused.
1280      */
1281     modifier whenNotPaused() {
1282         require(!paused(), "Pausable: paused");
1283         _;
1284     }
1285 
1286     /**
1287      * @dev Modifier to make a function callable only when the contract is paused.
1288      *
1289      * Requirements:
1290      *
1291      * - The contract must be paused.
1292      */
1293     modifier whenPaused() {
1294         require(paused(), "Pausable: not paused");
1295         _;
1296     }
1297 
1298     /**
1299      * @dev Triggers stopped state.
1300      *
1301      * Requirements:
1302      *
1303      * - The contract must not be paused.
1304      */
1305     function _pause() internal virtual whenNotPaused {
1306         _paused = true;
1307         emit Paused(_msgSender());
1308     }
1309 
1310     /**
1311      * @dev Returns to normal state.
1312      *
1313      * Requirements:
1314      *
1315      * - The contract must be paused.
1316      */
1317     function _unpause() internal virtual whenPaused {
1318         _paused = false;
1319         emit Unpaused(_msgSender());
1320     }
1321     uint256[49] private __gap;
1322 }
1323 
1324 /**
1325  * @dev ERC20 token with pausable token transfers, minting and burning.
1326  *
1327  * Useful for scenarios such as preventing trades until the end of an evaluation
1328  * period, or having an emergency switch for freezing all token transfers in the
1329  * event of a large bug.
1330  */
1331 abstract contract ERC20PausableUpgradeable is Initializable, ERC20Upgradeable, PausableUpgradeable {
1332     function __ERC20Pausable_init() internal initializer {
1333         __Context_init_unchained();
1334         __Pausable_init_unchained();
1335         __ERC20Pausable_init_unchained();
1336     }
1337 
1338     function __ERC20Pausable_init_unchained() internal initializer {
1339     }
1340     /**
1341      * @dev See {ERC20-_beforeTokenTransfer}.
1342      *
1343      * Requirements:
1344      *
1345      * - the contract must not be paused.
1346      */
1347     function _beforeTokenTransfer(
1348         address from,
1349         address to,
1350         uint256 amount
1351     ) internal virtual override {
1352         super._beforeTokenTransfer(from, to, amount);
1353 
1354         require(!paused(), "ERC20Pausable: token transfer while paused");
1355     }
1356     uint256[50] private __gap;
1357 }
1358 
1359 
1360 
1361 
1362 
1363 /**
1364  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1365  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1366  *
1367  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1368  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1369  * need to send a transaction, and thus is not required to hold Ether at all.
1370  */
1371 interface IERC20PermitUpgradeable {
1372     /**
1373      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1374      * given ``owner``'s signed approval.
1375      *
1376      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1377      * ordering also apply here.
1378      *
1379      * Emits an {Approval} event.
1380      *
1381      * Requirements:
1382      *
1383      * - `spender` cannot be the zero address.
1384      * - `deadline` must be a timestamp in the future.
1385      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1386      * over the EIP712-formatted function arguments.
1387      * - the signature must use ``owner``'s current nonce (see {nonces}).
1388      *
1389      * For more information on the signature format, see the
1390      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1391      * section].
1392      */
1393     function permit(
1394         address owner,
1395         address spender,
1396         uint256 value,
1397         uint256 deadline,
1398         uint8 v,
1399         bytes32 r,
1400         bytes32 s
1401     ) external;
1402 
1403     /**
1404      * @dev Returns the current nonce for `owner`. This value must be
1405      * included whenever a signature is generated for {permit}.
1406      *
1407      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1408      * prevents a signature from being used multiple times.
1409      */
1410     function nonces(address owner) external view returns (uint256);
1411 
1412     /**
1413      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1414      */
1415     // solhint-disable-next-line func-name-mixedcase
1416     function DOMAIN_SEPARATOR() external view returns (bytes32);
1417 }
1418 
1419 
1420 
1421 
1422 
1423 /**
1424  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1425  *
1426  * These functions can be used to verify that a message was signed by the holder
1427  * of the private keys of a given address.
1428  */
1429 library ECDSAUpgradeable {
1430     enum RecoverError {
1431         NoError,
1432         InvalidSignature,
1433         InvalidSignatureLength,
1434         InvalidSignatureS,
1435         InvalidSignatureV
1436     }
1437 
1438     function _throwError(RecoverError error) private pure {
1439         if (error == RecoverError.NoError) {
1440             return; // no error: do nothing
1441         } else if (error == RecoverError.InvalidSignature) {
1442             revert("ECDSA: invalid signature");
1443         } else if (error == RecoverError.InvalidSignatureLength) {
1444             revert("ECDSA: invalid signature length");
1445         } else if (error == RecoverError.InvalidSignatureS) {
1446             revert("ECDSA: invalid signature 's' value");
1447         } else if (error == RecoverError.InvalidSignatureV) {
1448             revert("ECDSA: invalid signature 'v' value");
1449         }
1450     }
1451 
1452     /**
1453      * @dev Returns the address that signed a hashed message (`hash`) with
1454      * `signature` or error string. This address can then be used for verification purposes.
1455      *
1456      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1457      * this function rejects them by requiring the `s` value to be in the lower
1458      * half order, and the `v` value to be either 27 or 28.
1459      *
1460      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1461      * verification to be secure: it is possible to craft signatures that
1462      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1463      * this is by receiving a hash of the original message (which may otherwise
1464      * be too long), and then calling {toEthSignedMessageHash} on it.
1465      *
1466      * Documentation for signature generation:
1467      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1468      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1469      *
1470      * _Available since v4.3._
1471      */
1472     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1473         // Check the signature length
1474         // - case 65: r,s,v signature (standard)
1475         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1476         if (signature.length == 65) {
1477             bytes32 r;
1478             bytes32 s;
1479             uint8 v;
1480             // ecrecover takes the signature parameters, and the only way to get them
1481             // currently is to use assembly.
1482             assembly {
1483                 r := mload(add(signature, 0x20))
1484                 s := mload(add(signature, 0x40))
1485                 v := byte(0, mload(add(signature, 0x60)))
1486             }
1487             return tryRecover(hash, v, r, s);
1488         } else if (signature.length == 64) {
1489             bytes32 r;
1490             bytes32 vs;
1491             // ecrecover takes the signature parameters, and the only way to get them
1492             // currently is to use assembly.
1493             assembly {
1494                 r := mload(add(signature, 0x20))
1495                 vs := mload(add(signature, 0x40))
1496             }
1497             return tryRecover(hash, r, vs);
1498         } else {
1499             return (address(0), RecoverError.InvalidSignatureLength);
1500         }
1501     }
1502 
1503     /**
1504      * @dev Returns the address that signed a hashed message (`hash`) with
1505      * `signature`. This address can then be used for verification purposes.
1506      *
1507      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1508      * this function rejects them by requiring the `s` value to be in the lower
1509      * half order, and the `v` value to be either 27 or 28.
1510      *
1511      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1512      * verification to be secure: it is possible to craft signatures that
1513      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1514      * this is by receiving a hash of the original message (which may otherwise
1515      * be too long), and then calling {toEthSignedMessageHash} on it.
1516      */
1517     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1518         (address recovered, RecoverError error) = tryRecover(hash, signature);
1519         _throwError(error);
1520         return recovered;
1521     }
1522 
1523     /**
1524      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1525      *
1526      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1527      *
1528      * _Available since v4.3._
1529      */
1530     function tryRecover(
1531         bytes32 hash,
1532         bytes32 r,
1533         bytes32 vs
1534     ) internal pure returns (address, RecoverError) {
1535         bytes32 s;
1536         uint8 v;
1537         assembly {
1538             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1539             v := add(shr(255, vs), 27)
1540         }
1541         return tryRecover(hash, v, r, s);
1542     }
1543 
1544     /**
1545      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1546      *
1547      * _Available since v4.2._
1548      */
1549     function recover(
1550         bytes32 hash,
1551         bytes32 r,
1552         bytes32 vs
1553     ) internal pure returns (address) {
1554         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1555         _throwError(error);
1556         return recovered;
1557     }
1558 
1559     /**
1560      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1561      * `r` and `s` signature fields separately.
1562      *
1563      * _Available since v4.3._
1564      */
1565     function tryRecover(
1566         bytes32 hash,
1567         uint8 v,
1568         bytes32 r,
1569         bytes32 s
1570     ) internal pure returns (address, RecoverError) {
1571         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1572         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1573         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1574         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1575         //
1576         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1577         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1578         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1579         // these malleable signatures as well.
1580         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1581             return (address(0), RecoverError.InvalidSignatureS);
1582         }
1583         if (v != 27 && v != 28) {
1584             return (address(0), RecoverError.InvalidSignatureV);
1585         }
1586 
1587         // If the signature is valid (and not malleable), return the signer address
1588         address signer = ecrecover(hash, v, r, s);
1589         if (signer == address(0)) {
1590             return (address(0), RecoverError.InvalidSignature);
1591         }
1592 
1593         return (signer, RecoverError.NoError);
1594     }
1595 
1596     /**
1597      * @dev Overload of {ECDSA-recover} that receives the `v`,
1598      * `r` and `s` signature fields separately.
1599      */
1600     function recover(
1601         bytes32 hash,
1602         uint8 v,
1603         bytes32 r,
1604         bytes32 s
1605     ) internal pure returns (address) {
1606         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1607         _throwError(error);
1608         return recovered;
1609     }
1610 
1611     /**
1612      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1613      * produces hash corresponding to the one signed with the
1614      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1615      * JSON-RPC method as part of EIP-191.
1616      *
1617      * See {recover}.
1618      */
1619     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1620         // 32 is the length in bytes of hash,
1621         // enforced by the type signature above
1622         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1623     }
1624 
1625     /**
1626      * @dev Returns an Ethereum Signed Typed Data, created from a
1627      * `domainSeparator` and a `structHash`. This produces hash corresponding
1628      * to the one signed with the
1629      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1630      * JSON-RPC method as part of EIP-712.
1631      *
1632      * See {recover}.
1633      */
1634     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1635         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1636     }
1637 }
1638 
1639 /**
1640  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1641  *
1642  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1643  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1644  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1645  *
1646  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1647  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1648  * ({_hashTypedDataV4}).
1649  *
1650  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1651  * the chain id to protect against replay attacks on an eventual fork of the chain.
1652  *
1653  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1654  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1655  *
1656  * _Available since v3.4._
1657  */
1658 abstract contract EIP712Upgradeable is Initializable {
1659     /* solhint-disable var-name-mixedcase */
1660     bytes32 private _HASHED_NAME;
1661     bytes32 private _HASHED_VERSION;
1662     bytes32 private constant _TYPE_HASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
1663 
1664     /* solhint-enable var-name-mixedcase */
1665 
1666     /**
1667      * @dev Initializes the domain separator and parameter caches.
1668      *
1669      * The meaning of `name` and `version` is specified in
1670      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1671      *
1672      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1673      * - `version`: the current major version of the signing domain.
1674      *
1675      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1676      * contract upgrade].
1677      */
1678     function __EIP712_init(string memory name, string memory version) internal initializer {
1679         __EIP712_init_unchained(name, version);
1680     }
1681 
1682     function __EIP712_init_unchained(string memory name, string memory version) internal initializer {
1683         bytes32 hashedName = keccak256(bytes(name));
1684         bytes32 hashedVersion = keccak256(bytes(version));
1685         _HASHED_NAME = hashedName;
1686         _HASHED_VERSION = hashedVersion;
1687     }
1688 
1689     /**
1690      * @dev Returns the domain separator for the current chain.
1691      */
1692     function _domainSeparatorV4() internal view returns (bytes32) {
1693         return _buildDomainSeparator(_TYPE_HASH, _EIP712NameHash(), _EIP712VersionHash());
1694     }
1695 
1696     function _buildDomainSeparator(
1697         bytes32 typeHash,
1698         bytes32 nameHash,
1699         bytes32 versionHash
1700     ) private view returns (bytes32) {
1701         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1702     }
1703 
1704     /**
1705      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1706      * function returns the hash of the fully encoded EIP712 message for this domain.
1707      *
1708      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1709      *
1710      * ```solidity
1711      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1712      *     keccak256("Mail(address to,string contents)"),
1713      *     mailTo,
1714      *     keccak256(bytes(mailContents))
1715      * )));
1716      * address signer = ECDSA.recover(digest, signature);
1717      * ```
1718      */
1719     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1720         return ECDSAUpgradeable.toTypedDataHash(_domainSeparatorV4(), structHash);
1721     }
1722 
1723     /**
1724      * @dev The hash of the name parameter for the EIP712 domain.
1725      *
1726      * NOTE: This function reads from storage by default, but can be redefined to return a constant value if gas costs
1727      * are a concern.
1728      */
1729     function _EIP712NameHash() internal virtual view returns (bytes32) {
1730         return _HASHED_NAME;
1731     }
1732 
1733     /**
1734      * @dev The hash of the version parameter for the EIP712 domain.
1735      *
1736      * NOTE: This function reads from storage by default, but can be redefined to return a constant value if gas costs
1737      * are a concern.
1738      */
1739     function _EIP712VersionHash() internal virtual view returns (bytes32) {
1740         return _HASHED_VERSION;
1741     }
1742     uint256[50] private __gap;
1743 }
1744 
1745 
1746 
1747 /**
1748  * @title Counters
1749  * @author Matt Condon (@shrugs)
1750  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1751  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1752  *
1753  * Include with `using Counters for Counters.Counter;`
1754  */
1755 library CountersUpgradeable {
1756     struct Counter {
1757         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1758         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1759         // this feature: see https://github.com/ethereum/solidity/issues/4637
1760         uint256 _value; // default: 0
1761     }
1762 
1763     function current(Counter storage counter) internal view returns (uint256) {
1764         return counter._value;
1765     }
1766 
1767     function increment(Counter storage counter) internal {
1768         unchecked {
1769             counter._value += 1;
1770         }
1771     }
1772 
1773     function decrement(Counter storage counter) internal {
1774         uint256 value = counter._value;
1775         require(value > 0, "Counter: decrement overflow");
1776         unchecked {
1777             counter._value = value - 1;
1778         }
1779     }
1780 
1781     function reset(Counter storage counter) internal {
1782         counter._value = 0;
1783     }
1784 }
1785 
1786 /**
1787  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1788  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1789  *
1790  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1791  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1792  * need to send a transaction, and thus is not required to hold Ether at all.
1793  *
1794  * _Available since v3.4._
1795  */
1796 abstract contract ERC20PermitUpgradeable is Initializable, ERC20Upgradeable, IERC20PermitUpgradeable, EIP712Upgradeable {
1797     using CountersUpgradeable for CountersUpgradeable.Counter;
1798 
1799     mapping(address => CountersUpgradeable.Counter) private _nonces;
1800 
1801     // solhint-disable-next-line var-name-mixedcase
1802     bytes32 private _PERMIT_TYPEHASH;
1803 
1804     /**
1805      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1806      *
1807      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1808      */
1809     function __ERC20Permit_init(string memory name) internal initializer {
1810         __Context_init_unchained();
1811         __EIP712_init_unchained(name, "1");
1812         __ERC20Permit_init_unchained(name);
1813     }
1814 
1815     function __ERC20Permit_init_unchained(string memory name) internal initializer {
1816         _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");}
1817 
1818     /**
1819      * @dev See {IERC20Permit-permit}.
1820      */
1821     function permit(
1822         address owner,
1823         address spender,
1824         uint256 value,
1825         uint256 deadline,
1826         uint8 v,
1827         bytes32 r,
1828         bytes32 s
1829     ) public virtual override {
1830         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1831 
1832         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1833 
1834         bytes32 hash = _hashTypedDataV4(structHash);
1835 
1836         address signer = ECDSAUpgradeable.recover(hash, v, r, s);
1837         require(signer == owner, "ERC20Permit: invalid signature");
1838 
1839         _approve(owner, spender, value);
1840     }
1841 
1842     /**
1843      * @dev See {IERC20Permit-nonces}.
1844      */
1845     function nonces(address owner) public view virtual override returns (uint256) {
1846         return _nonces[owner].current();
1847     }
1848 
1849     /**
1850      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1851      */
1852     // solhint-disable-next-line func-name-mixedcase
1853     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1854         return _domainSeparatorV4();
1855     }
1856 
1857     /**
1858      * @dev "Consume a nonce": return the current value and increment.
1859      *
1860      * _Available since v4.1._
1861      */
1862     function _useNonce(address owner) internal virtual returns (uint256 current) {
1863         CountersUpgradeable.Counter storage nonce = _nonces[owner];
1864         current = nonce.current();
1865         nonce.increment();
1866     }
1867     uint256[49] private __gap;
1868 }
1869 
1870 
1871 
1872 
1873 
1874 /**
1875  * @dev Standard math utilities missing in the Solidity language.
1876  */
1877 library MathUpgradeable {
1878     /**
1879      * @dev Returns the largest of two numbers.
1880      */
1881     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1882         return a >= b ? a : b;
1883     }
1884 
1885     /**
1886      * @dev Returns the smallest of two numbers.
1887      */
1888     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1889         return a < b ? a : b;
1890     }
1891 
1892     /**
1893      * @dev Returns the average of two numbers. The result is rounded towards
1894      * zero.
1895      */
1896     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1897         // (a + b) / 2 can overflow.
1898         return (a & b) + (a ^ b) / 2;
1899     }
1900 
1901     /**
1902      * @dev Returns the ceiling of the division of two numbers.
1903      *
1904      * This differs from standard division with `/` in that it rounds up instead
1905      * of rounding down.
1906      */
1907     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1908         // (a + b - 1) / b can overflow on addition, so we distribute.
1909         return a / b + (a % b == 0 ? 0 : 1);
1910     }
1911 }
1912 
1913 
1914 
1915 /**
1916  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
1917  * checks.
1918  *
1919  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
1920  * easily result in undesired exploitation or bugs, since developers usually
1921  * assume that overflows raise errors. `SafeCast` restores this intuition by
1922  * reverting the transaction when such an operation overflows.
1923  *
1924  * Using this library instead of the unchecked operations eliminates an entire
1925  * class of bugs, so it's recommended to use it always.
1926  *
1927  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1928  * all math on `uint256` and `int256` and then downcasting.
1929  */
1930 library SafeCastUpgradeable {
1931     /**
1932      * @dev Returns the downcasted uint224 from uint256, reverting on
1933      * overflow (when the input is greater than largest uint224).
1934      *
1935      * Counterpart to Solidity's `uint224` operator.
1936      *
1937      * Requirements:
1938      *
1939      * - input must fit into 224 bits
1940      */
1941     function toUint224(uint256 value) internal pure returns (uint224) {
1942         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
1943         return uint224(value);
1944     }
1945 
1946     /**
1947      * @dev Returns the downcasted uint128 from uint256, reverting on
1948      * overflow (when the input is greater than largest uint128).
1949      *
1950      * Counterpart to Solidity's `uint128` operator.
1951      *
1952      * Requirements:
1953      *
1954      * - input must fit into 128 bits
1955      */
1956     function toUint128(uint256 value) internal pure returns (uint128) {
1957         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
1958         return uint128(value);
1959     }
1960 
1961     /**
1962      * @dev Returns the downcasted uint96 from uint256, reverting on
1963      * overflow (when the input is greater than largest uint96).
1964      *
1965      * Counterpart to Solidity's `uint96` operator.
1966      *
1967      * Requirements:
1968      *
1969      * - input must fit into 96 bits
1970      */
1971     function toUint96(uint256 value) internal pure returns (uint96) {
1972         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
1973         return uint96(value);
1974     }
1975 
1976     /**
1977      * @dev Returns the downcasted uint64 from uint256, reverting on
1978      * overflow (when the input is greater than largest uint64).
1979      *
1980      * Counterpart to Solidity's `uint64` operator.
1981      *
1982      * Requirements:
1983      *
1984      * - input must fit into 64 bits
1985      */
1986     function toUint64(uint256 value) internal pure returns (uint64) {
1987         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
1988         return uint64(value);
1989     }
1990 
1991     /**
1992      * @dev Returns the downcasted uint32 from uint256, reverting on
1993      * overflow (when the input is greater than largest uint32).
1994      *
1995      * Counterpart to Solidity's `uint32` operator.
1996      *
1997      * Requirements:
1998      *
1999      * - input must fit into 32 bits
2000      */
2001     function toUint32(uint256 value) internal pure returns (uint32) {
2002         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
2003         return uint32(value);
2004     }
2005 
2006     /**
2007      * @dev Returns the downcasted uint16 from uint256, reverting on
2008      * overflow (when the input is greater than largest uint16).
2009      *
2010      * Counterpart to Solidity's `uint16` operator.
2011      *
2012      * Requirements:
2013      *
2014      * - input must fit into 16 bits
2015      */
2016     function toUint16(uint256 value) internal pure returns (uint16) {
2017         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
2018         return uint16(value);
2019     }
2020 
2021     /**
2022      * @dev Returns the downcasted uint8 from uint256, reverting on
2023      * overflow (when the input is greater than largest uint8).
2024      *
2025      * Counterpart to Solidity's `uint8` operator.
2026      *
2027      * Requirements:
2028      *
2029      * - input must fit into 8 bits.
2030      */
2031     function toUint8(uint256 value) internal pure returns (uint8) {
2032         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
2033         return uint8(value);
2034     }
2035 
2036     /**
2037      * @dev Converts a signed int256 into an unsigned uint256.
2038      *
2039      * Requirements:
2040      *
2041      * - input must be greater than or equal to 0.
2042      */
2043     function toUint256(int256 value) internal pure returns (uint256) {
2044         require(value >= 0, "SafeCast: value must be positive");
2045         return uint256(value);
2046     }
2047 
2048     /**
2049      * @dev Returns the downcasted int128 from int256, reverting on
2050      * overflow (when the input is less than smallest int128 or
2051      * greater than largest int128).
2052      *
2053      * Counterpart to Solidity's `int128` operator.
2054      *
2055      * Requirements:
2056      *
2057      * - input must fit into 128 bits
2058      *
2059      * _Available since v3.1._
2060      */
2061     function toInt128(int256 value) internal pure returns (int128) {
2062         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
2063         return int128(value);
2064     }
2065 
2066     /**
2067      * @dev Returns the downcasted int64 from int256, reverting on
2068      * overflow (when the input is less than smallest int64 or
2069      * greater than largest int64).
2070      *
2071      * Counterpart to Solidity's `int64` operator.
2072      *
2073      * Requirements:
2074      *
2075      * - input must fit into 64 bits
2076      *
2077      * _Available since v3.1._
2078      */
2079     function toInt64(int256 value) internal pure returns (int64) {
2080         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
2081         return int64(value);
2082     }
2083 
2084     /**
2085      * @dev Returns the downcasted int32 from int256, reverting on
2086      * overflow (when the input is less than smallest int32 or
2087      * greater than largest int32).
2088      *
2089      * Counterpart to Solidity's `int32` operator.
2090      *
2091      * Requirements:
2092      *
2093      * - input must fit into 32 bits
2094      *
2095      * _Available since v3.1._
2096      */
2097     function toInt32(int256 value) internal pure returns (int32) {
2098         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
2099         return int32(value);
2100     }
2101 
2102     /**
2103      * @dev Returns the downcasted int16 from int256, reverting on
2104      * overflow (when the input is less than smallest int16 or
2105      * greater than largest int16).
2106      *
2107      * Counterpart to Solidity's `int16` operator.
2108      *
2109      * Requirements:
2110      *
2111      * - input must fit into 16 bits
2112      *
2113      * _Available since v3.1._
2114      */
2115     function toInt16(int256 value) internal pure returns (int16) {
2116         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
2117         return int16(value);
2118     }
2119 
2120     /**
2121      * @dev Returns the downcasted int8 from int256, reverting on
2122      * overflow (when the input is less than smallest int8 or
2123      * greater than largest int8).
2124      *
2125      * Counterpart to Solidity's `int8` operator.
2126      *
2127      * Requirements:
2128      *
2129      * - input must fit into 8 bits.
2130      *
2131      * _Available since v3.1._
2132      */
2133     function toInt8(int256 value) internal pure returns (int8) {
2134         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
2135         return int8(value);
2136     }
2137 
2138     /**
2139      * @dev Converts an unsigned uint256 into a signed int256.
2140      *
2141      * Requirements:
2142      *
2143      * - input must be less than or equal to maxInt256.
2144      */
2145     function toInt256(uint256 value) internal pure returns (int256) {
2146         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
2147         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
2148         return int256(value);
2149     }
2150 }
2151 
2152 /**
2153  * @dev Extension of ERC20 to support Compound-like voting and delegation. This version is more generic than Compound's,
2154  * and supports token supply up to 2^224^ - 1, while COMP is limited to 2^96^ - 1.
2155  *
2156  * NOTE: If exact COMP compatibility is required, use the {ERC20VotesComp} variant of this module.
2157  *
2158  * This extension keeps a history (checkpoints) of each account's vote power. Vote power can be delegated either
2159  * by calling the {delegate} function directly, or by providing a signature to be used with {delegateBySig}. Voting
2160  * power can be queried through the public accessors {getVotes} and {getPastVotes}.
2161  *
2162  * By default, token balance does not account for voting power. This makes transfers cheaper. The downside is that it
2163  * requires users to delegate to themselves in order to activate checkpoints and have their voting power tracked.
2164  * Enabling self-delegation can easily be done by overriding the {delegates} function. Keep in mind however that this
2165  * will significantly increase the base gas cost of transfers.
2166  *
2167  * _Available since v4.2._
2168  */
2169 abstract contract ERC20VotesUpgradeable is Initializable, ERC20PermitUpgradeable {
2170     function __ERC20Votes_init_unchained() internal initializer {
2171     }
2172     struct Checkpoint {
2173         uint32 fromBlock;
2174         uint224 votes;
2175     }
2176 
2177     bytes32 private constant _DELEGATION_TYPEHASH =
2178         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
2179 
2180     mapping(address => address) private _delegates;
2181     mapping(address => Checkpoint[]) private _checkpoints;
2182     Checkpoint[] private _totalSupplyCheckpoints;
2183 
2184     /**
2185      * @dev Emitted when an account changes their delegate.
2186      */
2187     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
2188 
2189     /**
2190      * @dev Emitted when a token transfer or delegate change results in changes to an account's voting power.
2191      */
2192     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
2193 
2194     /**
2195      * @dev Get the `pos`-th checkpoint for `account`.
2196      */
2197     function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoint memory) {
2198         return _checkpoints[account][pos];
2199     }
2200 
2201     /**
2202      * @dev Get number of checkpoints for `account`.
2203      */
2204     function numCheckpoints(address account) public view virtual returns (uint32) {
2205         return SafeCastUpgradeable.toUint32(_checkpoints[account].length);
2206     }
2207 
2208     /**
2209      * @dev Get the address `account` is currently delegating to.
2210      */
2211     function delegates(address account) public view virtual returns (address) {
2212         return _delegates[account];
2213     }
2214 
2215     /**
2216      * @dev Gets the current votes balance for `account`
2217      */
2218     function getVotes(address account) public view returns (uint256) {
2219         uint256 pos = _checkpoints[account].length;
2220         return pos == 0 ? 0 : _checkpoints[account][pos - 1].votes;
2221     }
2222 
2223     /**
2224      * @dev Retrieve the number of votes for `account` at the end of `blockNumber`.
2225      *
2226      * Requirements:
2227      *
2228      * - `blockNumber` must have been already mined
2229      */
2230     function getPastVotes(address account, uint256 blockNumber) public view returns (uint256) {
2231         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
2232         return _checkpointsLookup(_checkpoints[account], blockNumber);
2233     }
2234 
2235     /**
2236      * @dev Retrieve the `totalSupply` at the end of `blockNumber`. Note, this value is the sum of all balances.
2237      * It is but NOT the sum of all the delegated votes!
2238      *
2239      * Requirements:
2240      *
2241      * - `blockNumber` must have been already mined
2242      */
2243     function getPastTotalSupply(uint256 blockNumber) public view returns (uint256) {
2244         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
2245         return _checkpointsLookup(_totalSupplyCheckpoints, blockNumber);
2246     }
2247 
2248     /**
2249      * @dev Lookup a value in a list of (sorted) checkpoints.
2250      */
2251     function _checkpointsLookup(Checkpoint[] storage ckpts, uint256 blockNumber) private view returns (uint256) {
2252         // We run a binary search to look for the earliest checkpoint taken after `blockNumber`.
2253         //
2254         // During the loop, the index of the wanted checkpoint remains in the range [low-1, high).
2255         // With each iteration, either `low` or `high` is moved towards the middle of the range to maintain the invariant.
2256         // - If the middle checkpoint is after `blockNumber`, we look in [low, mid)
2257         // - If the middle checkpoint is before or equal to `blockNumber`, we look in [mid+1, high)
2258         // Once we reach a single value (when low == high), we've found the right checkpoint at the index high-1, if not
2259         // out of bounds (in which case we're looking too far in the past and the result is 0).
2260         // Note that if the latest checkpoint available is exactly for `blockNumber`, we end up with an index that is
2261         // past the end of the array, so we technically don't find a checkpoint after `blockNumber`, but it works out
2262         // the same.
2263         uint256 high = ckpts.length;
2264         uint256 low = 0;
2265         while (low < high) {
2266             uint256 mid = MathUpgradeable.average(low, high);
2267             if (ckpts[mid].fromBlock > blockNumber) {
2268                 high = mid;
2269             } else {
2270                 low = mid + 1;
2271             }
2272         }
2273 
2274         return high == 0 ? 0 : ckpts[high - 1].votes;
2275     }
2276 
2277     /**
2278      * @dev Delegate votes from the sender to `delegatee`.
2279      */
2280     function delegate(address delegatee) public virtual {
2281         return _delegate(_msgSender(), delegatee);
2282     }
2283 
2284     /**
2285      * @dev Delegates votes from signer to `delegatee`
2286      */
2287     function delegateBySig(
2288         address delegatee,
2289         uint256 nonce,
2290         uint256 expiry,
2291         uint8 v,
2292         bytes32 r,
2293         bytes32 s
2294     ) public virtual {
2295         require(block.timestamp <= expiry, "ERC20Votes: signature expired");
2296         address signer = ECDSAUpgradeable.recover(
2297             _hashTypedDataV4(keccak256(abi.encode(_DELEGATION_TYPEHASH, delegatee, nonce, expiry))),
2298             v,
2299             r,
2300             s
2301         );
2302         require(nonce == _useNonce(signer), "ERC20Votes: invalid nonce");
2303         return _delegate(signer, delegatee);
2304     }
2305 
2306     /**
2307      * @dev Maximum token supply. Defaults to `type(uint224).max` (2^224^ - 1).
2308      */
2309     function _maxSupply() internal view virtual returns (uint224) {
2310         return type(uint224).max;
2311     }
2312 
2313     /**
2314      * @dev Snapshots the totalSupply after it has been increased.
2315      */
2316     function _mint(address account, uint256 amount) internal virtual override {
2317         super._mint(account, amount);
2318         require(totalSupply() <= _maxSupply(), "ERC20Votes: total supply risks overflowing votes");
2319 
2320         _writeCheckpoint(_totalSupplyCheckpoints, _add, amount);
2321     }
2322 
2323     /**
2324      * @dev Snapshots the totalSupply after it has been decreased.
2325      */
2326     function _burn(address account, uint256 amount) internal virtual override {
2327         super._burn(account, amount);
2328 
2329         _writeCheckpoint(_totalSupplyCheckpoints, _subtract, amount);
2330     }
2331 
2332     /**
2333      * @dev Move voting power when tokens are transferred.
2334      *
2335      * Emits a {DelegateVotesChanged} event.
2336      */
2337     function _afterTokenTransfer(
2338         address from,
2339         address to,
2340         uint256 amount
2341     ) internal virtual override {
2342         super._afterTokenTransfer(from, to, amount);
2343 
2344         _moveVotingPower(delegates(from), delegates(to), amount);
2345     }
2346 
2347     /**
2348      * @dev Change delegation for `delegator` to `delegatee`.
2349      *
2350      * Emits events {DelegateChanged} and {DelegateVotesChanged}.
2351      */
2352     function _delegate(address delegator, address delegatee) internal virtual {
2353         address currentDelegate = delegates(delegator);
2354         uint256 delegatorBalance = balanceOf(delegator);
2355         _delegates[delegator] = delegatee;
2356 
2357         emit DelegateChanged(delegator, currentDelegate, delegatee);
2358 
2359         _moveVotingPower(currentDelegate, delegatee, delegatorBalance);
2360     }
2361 
2362     function _moveVotingPower(
2363         address src,
2364         address dst,
2365         uint256 amount
2366     ) private {
2367         if (src != dst && amount > 0) {
2368             if (src != address(0)) {
2369                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[src], _subtract, amount);
2370                 emit DelegateVotesChanged(src, oldWeight, newWeight);
2371             }
2372 
2373             if (dst != address(0)) {
2374                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[dst], _add, amount);
2375                 emit DelegateVotesChanged(dst, oldWeight, newWeight);
2376             }
2377         }
2378     }
2379 
2380     function _writeCheckpoint(
2381         Checkpoint[] storage ckpts,
2382         function(uint256, uint256) view returns (uint256) op,
2383         uint256 delta
2384     ) private returns (uint256 oldWeight, uint256 newWeight) {
2385         uint256 pos = ckpts.length;
2386         oldWeight = pos == 0 ? 0 : ckpts[pos - 1].votes;
2387         newWeight = op(oldWeight, delta);
2388 
2389         if (pos > 0 && ckpts[pos - 1].fromBlock == block.number) {
2390             ckpts[pos - 1].votes = SafeCastUpgradeable.toUint224(newWeight);
2391         } else {
2392             ckpts.push(Checkpoint({fromBlock: SafeCastUpgradeable.toUint32(block.number), votes: SafeCastUpgradeable.toUint224(newWeight)}));
2393         }
2394     }
2395 
2396     function _add(uint256 a, uint256 b) private pure returns (uint256) {
2397         return a + b;
2398     }
2399 
2400     function _subtract(uint256 a, uint256 b) private pure returns (uint256) {
2401         return a - b;
2402     }
2403     uint256[47] private __gap;
2404 }
2405 
2406 
2407 
2408 interface IBridgeableToken {
2409   function gateway() external view returns (address);
2410   function bridgeMint(address account, uint256 amount) external;
2411   function bridgeBurn(address account, uint256 amount) external;
2412 }
2413 
2414 contract BitANT is UUPSUpgradeable, OwnableUpgradeable, ERC20Upgradeable, ERC20BurnableUpgradeable, ERC20PausableUpgradeable, ERC20VotesUpgradeable, IBridgeableToken {
2415   address private _gateway;
2416 
2417   bool private _feeOn;
2418   uint256 private _fee;
2419   address private _feeCollector;
2420   uint256 private constant FEE_RATIO = 1e4;
2421 
2422   mapping (address => bool) private _inWhiteList;
2423   mapping (address => bool) private _outWhiteList;
2424 
2425   modifier onlyBridge() virtual {
2426     require(_msgSender() == _gateway, "ONLY_BRIDGE");
2427     _;
2428   }
2429 
2430   function initialize() public virtual payable initializer {
2431     __UUPSUpgradeable_init();
2432     __Ownable_init();
2433     __ERC20_init("BitANT", "BitANT");
2434     __ERC20Burnable_init();
2435     __ERC20Pausable_init();
2436     __ERC20Permit_init("BitANT");
2437 
2438     _feeOn = true;
2439     _fee = 500;
2440 
2441     address sender = _msgSender();
2442     _inWhiteList[sender] = true;
2443     _outWhiteList[sender] = true;
2444 
2445     _mint(_msgSender(), 1e28);
2446   }
2447 
2448   function init(address gateway_) external virtual onlyOwner {
2449     _gateway = gateway_;
2450   }
2451 
2452   function pause() external virtual onlyOwner whenNotPaused {
2453     _pause();
2454   }
2455 
2456   function unpause() external virtual onlyOwner whenPaused {
2457     _unpause();
2458   }
2459 
2460   function setFee(uint256 fee_) external onlyOwner {
2461     _fee = fee_;
2462   }
2463 
2464   function setFeeOn(bool feeOn_) external onlyOwner {
2465     _feeOn = feeOn_;
2466   }
2467 
2468   function setFeeCollector(address feeCollector_) external onlyOwner {
2469     _feeCollector = feeCollector_;
2470   }
2471 
2472   function addInWhiteList(address account) external onlyOwner {
2473     _inWhiteList[account] = true;
2474   }
2475 
2476   function addOutWhiteList(address account) external onlyOwner {
2477     _outWhiteList[account] = true;
2478   }
2479 
2480   function removeInWhiteList(address account) external onlyOwner {
2481     _inWhiteList[account] = false;
2482   }
2483 
2484   function removeOutWhiteList(address account) external onlyOwner {
2485     _outWhiteList[account] = false;
2486   }
2487 
2488   function bridgeMint(address account, uint256 amount) external override onlyBridge {
2489     _mint(account, amount);
2490   }
2491 
2492   function bridgeBurn(address account, uint256 amount) external override onlyBridge {
2493     _burn(account, amount);
2494   }
2495 
2496   function gateway() external override view returns (address) {
2497     return _gateway;
2498   }
2499 
2500   function fee() external view returns (uint256) {
2501     return _fee;
2502   }
2503 
2504   function feeOn() external view returns (bool) {
2505     return _feeOn;
2506   }
2507 
2508   function feeCollector() external view returns (address) {
2509     return _feeCollector;
2510   }
2511 
2512   function isInWhiteList(address account) external view returns (bool) {
2513     return _inWhiteList[account];
2514   }
2515 
2516   function isOutWhiteList(address account) external view returns (bool) {
2517     return _outWhiteList[account];
2518   }
2519 
2520   function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
2521     if(!_feeOn || _feeCollector == address(0) || _inWhiteList[sender] || _outWhiteList[recipient]) {
2522       super._transfer(sender, recipient, amount);
2523     } else {
2524       super._transfer(sender, _feeCollector, amount * _fee / FEE_RATIO);
2525       super._transfer(sender, recipient, amount * (FEE_RATIO - _fee) / FEE_RATIO);
2526     }
2527   }
2528 
2529   function _burn(address account, uint256 amount) internal virtual override(ERC20Upgradeable, ERC20VotesUpgradeable) {
2530     super._burn(account, amount);
2531   }
2532 
2533   function _mint(address account, uint256 amount) internal virtual override(ERC20Upgradeable, ERC20VotesUpgradeable) {
2534     super._mint(account, amount);
2535   }
2536 
2537   function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20Upgradeable, ERC20PausableUpgradeable) {
2538     super._beforeTokenTransfer(from, to, amount);
2539   }
2540 
2541   function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20Upgradeable, ERC20VotesUpgradeable) {
2542     super._afterTokenTransfer(from, to, amount);
2543   }
2544 
2545   function _authorizeUpgrade(address) internal virtual override onlyOwner {}
2546 }