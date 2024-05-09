1 // File: @openzeppelin/contracts/proxy/Proxy.sol
2 // SPDX-License-Identifier: MIT
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
10  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
11  * be specified by overriding the virtual {_implementation} function.
12  *
13  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
14  * different contract through the {_delegate} function.
15  *
16  * The success and return data of the delegated call will be returned back to the caller of the proxy.
17  */
18 abstract contract Proxy {
19     /**
20      * @dev Delegates the current call to `implementation`.
21      *
22      * This function does not return to its internal call site, it will return directly to the external caller.
23      */
24     function _delegate(address implementation) internal virtual {
25         assembly {
26             // Copy msg.data. We take full control of memory in this inline assembly
27             // block because it will not return to Solidity code. We overwrite the
28             // Solidity scratch pad at memory position 0.
29             calldatacopy(0, 0, calldatasize())
30 
31             // Call the implementation.
32             // out and outsize are 0 because we don't know the size yet.
33             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
34 
35             // Copy the returned data.
36             returndatacopy(0, 0, returndatasize())
37 
38             switch result
39             // delegatecall returns 0 on error.
40             case 0 {
41                 revert(0, returndatasize())
42             }
43             default {
44                 return(0, returndatasize())
45             }
46         }
47     }
48 
49     /**
50      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
51      * and {_fallback} should delegate.
52      */
53     function _implementation() internal view virtual returns (address);
54 
55     /**
56      * @dev Delegates the current call to the address returned by `_implementation()`.
57      *
58      * This function does not return to its internal call site, it will return directly to the external caller.
59      */
60     function _fallback() internal virtual {
61         _beforeFallback();
62         _delegate(_implementation());
63     }
64 
65     /**
66      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
67      * function in the contract matches the call data.
68      */
69     fallback() external payable virtual {
70         _fallback();
71     }
72 
73     /**
74      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
75      * is empty.
76      */
77     receive() external payable virtual {
78         _fallback();
79     }
80 
81     /**
82      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
83      * call, or as part of the Solidity `fallback` or `receive` functions.
84      *
85      * If overridden should call `super._beforeFallback()`.
86      */
87     function _beforeFallback() internal virtual {}
88 }
89 
90 // File: @openzeppelin/contracts/proxy/beacon/IBeacon.sol
91 
92 
93 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev This is the interface that {BeaconProxy} expects of its beacon.
99  */
100 interface IBeacon {
101     /**
102      * @dev Must return an address that can be used as a delegate call target.
103      *
104      * {BeaconProxy} will check that this address is a contract.
105      */
106     function implementation() external view returns (address);
107 }
108 
109 // File: @openzeppelin/contracts/interfaces/draft-IERC1822.sol
110 
111 
112 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
113 
114 pragma solidity ^0.8.0;
115 
116 /**
117  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
118  * proxy whose upgrades are fully controlled by the current implementation.
119  */
120 interface IERC1822Proxiable {
121     /**
122      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
123      * address.
124      *
125      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
126      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
127      * function revert if invoked through a proxy.
128      */
129     function proxiableUUID() external view returns (bytes32);
130 }
131 
132 // File: @openzeppelin/contracts/utils/Address.sol
133 
134 
135 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
136 
137 pragma solidity ^0.8.1;
138 
139 /**
140  * @dev Collection of functions related to the address type
141  */
142 library Address {
143     /**
144      * @dev Returns true if `account` is a contract.
145      *
146      * [IMPORTANT]
147      * ====
148      * It is unsafe to assume that an address for which this function returns
149      * false is an externally-owned account (EOA) and not a contract.
150      *
151      * Among others, `isContract` will return false for the following
152      * types of addresses:
153      *
154      *  - an externally-owned account
155      *  - a contract in construction
156      *  - an address where a contract will be created
157      *  - an address where a contract lived, but was destroyed
158      * ====
159      *
160      * [IMPORTANT]
161      * ====
162      * You shouldn't rely on `isContract` to protect against flash loan attacks!
163      *
164      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
165      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
166      * constructor.
167      * ====
168      */
169     function isContract(address account) internal view returns (bool) {
170         // This method relies on extcodesize/address.code.length, which returns 0
171         // for contracts in construction, since the code is only stored at the end
172         // of the constructor execution.
173 
174         return account.code.length > 0;
175     }
176 
177     /**
178      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
179      * `recipient`, forwarding all available gas and reverting on errors.
180      *
181      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
182      * of certain opcodes, possibly making contracts go over the 2300 gas limit
183      * imposed by `transfer`, making them unable to receive funds via
184      * `transfer`. {sendValue} removes this limitation.
185      *
186      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
187      *
188      * IMPORTANT: because control is transferred to `recipient`, care must be
189      * taken to not create reentrancy vulnerabilities. Consider using
190      * {ReentrancyGuard} or the
191      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
192      */
193     function sendValue(address payable recipient, uint256 amount) internal {
194         require(address(this).balance >= amount, "Address: insufficient balance");
195 
196         (bool success, ) = recipient.call{value: amount}("");
197         require(success, "Address: unable to send value, recipient may have reverted");
198     }
199 
200     /**
201      * @dev Performs a Solidity function call using a low level `call`. A
202      * plain `call` is an unsafe replacement for a function call: use this
203      * function instead.
204      *
205      * If `target` reverts with a revert reason, it is bubbled up by this
206      * function (like regular Solidity function calls).
207      *
208      * Returns the raw returned data. To convert to the expected return value,
209      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
210      *
211      * Requirements:
212      *
213      * - `target` must be a contract.
214      * - calling `target` with `data` must not revert.
215      *
216      * _Available since v3.1._
217      */
218     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
219         return functionCall(target, data, "Address: low-level call failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
224      * `errorMessage` as a fallback revert reason when `target` reverts.
225      *
226      * _Available since v3.1._
227      */
228     function functionCall(
229         address target,
230         bytes memory data,
231         string memory errorMessage
232     ) internal returns (bytes memory) {
233         return functionCallWithValue(target, data, 0, errorMessage);
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
238      * but also transferring `value` wei to `target`.
239      *
240      * Requirements:
241      *
242      * - the calling contract must have an ETH balance of at least `value`.
243      * - the called Solidity function must be `payable`.
244      *
245      * _Available since v3.1._
246      */
247     function functionCallWithValue(
248         address target,
249         bytes memory data,
250         uint256 value
251     ) internal returns (bytes memory) {
252         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
257      * with `errorMessage` as a fallback revert reason when `target` reverts.
258      *
259      * _Available since v3.1._
260      */
261     function functionCallWithValue(
262         address target,
263         bytes memory data,
264         uint256 value,
265         string memory errorMessage
266     ) internal returns (bytes memory) {
267         require(address(this).balance >= value, "Address: insufficient balance for call");
268         require(isContract(target), "Address: call to non-contract");
269 
270         (bool success, bytes memory returndata) = target.call{value: value}(data);
271         return verifyCallResult(success, returndata, errorMessage);
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
276      * but performing a static call.
277      *
278      * _Available since v3.3._
279      */
280     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
281         return functionStaticCall(target, data, "Address: low-level static call failed");
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
286      * but performing a static call.
287      *
288      * _Available since v3.3._
289      */
290     function functionStaticCall(
291         address target,
292         bytes memory data,
293         string memory errorMessage
294     ) internal view returns (bytes memory) {
295         require(isContract(target), "Address: static call to non-contract");
296 
297         (bool success, bytes memory returndata) = target.staticcall(data);
298         return verifyCallResult(success, returndata, errorMessage);
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
303      * but performing a delegate call.
304      *
305      * _Available since v3.4._
306      */
307     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
308         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
313      * but performing a delegate call.
314      *
315      * _Available since v3.4._
316      */
317     function functionDelegateCall(
318         address target,
319         bytes memory data,
320         string memory errorMessage
321     ) internal returns (bytes memory) {
322         require(isContract(target), "Address: delegate call to non-contract");
323 
324         (bool success, bytes memory returndata) = target.delegatecall(data);
325         return verifyCallResult(success, returndata, errorMessage);
326     }
327 
328     /**
329      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
330      * revert reason using the provided one.
331      *
332      * _Available since v4.3._
333      */
334     function verifyCallResult(
335         bool success,
336         bytes memory returndata,
337         string memory errorMessage
338     ) internal pure returns (bytes memory) {
339         if (success) {
340             return returndata;
341         } else {
342             // Look for revert reason and bubble it up if present
343             if (returndata.length > 0) {
344                 // The easiest way to bubble the revert reason is using memory via assembly
345                 /// @solidity memory-safe-assembly
346                 assembly {
347                     let returndata_size := mload(returndata)
348                     revert(add(32, returndata), returndata_size)
349                 }
350             } else {
351                 revert(errorMessage);
352             }
353         }
354     }
355 }
356 
357 // File: @openzeppelin/contracts/utils/StorageSlot.sol
358 
359 
360 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
361 
362 pragma solidity ^0.8.0;
363 
364 /**
365  * @dev Library for reading and writing primitive types to specific storage slots.
366  *
367  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
368  * This library helps with reading and writing to such slots without the need for inline assembly.
369  *
370  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
371  *
372  * Example usage to set ERC1967 implementation slot:
373  * ```
374  * contract ERC1967 {
375  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
376  *
377  *     function _getImplementation() internal view returns (address) {
378  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
379  *     }
380  *
381  *     function _setImplementation(address newImplementation) internal {
382  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
383  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
384  *     }
385  * }
386  * ```
387  *
388  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
389  */
390 library StorageSlot {
391     struct AddressSlot {
392         address value;
393     }
394 
395     struct BooleanSlot {
396         bool value;
397     }
398 
399     struct Bytes32Slot {
400         bytes32 value;
401     }
402 
403     struct Uint256Slot {
404         uint256 value;
405     }
406 
407     /**
408      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
409      */
410     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
411         /// @solidity memory-safe-assembly
412         assembly {
413             r.slot := slot
414         }
415     }
416 
417     /**
418      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
419      */
420     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
421         /// @solidity memory-safe-assembly
422         assembly {
423             r.slot := slot
424         }
425     }
426 
427     /**
428      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
429      */
430     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
431         /// @solidity memory-safe-assembly
432         assembly {
433             r.slot := slot
434         }
435     }
436 
437     /**
438      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
439      */
440     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
441         /// @solidity memory-safe-assembly
442         assembly {
443             r.slot := slot
444         }
445     }
446 }
447 
448 // File: @openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol
449 
450 
451 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
452 
453 pragma solidity ^0.8.2;
454 
455 
456 
457 
458 /**
459  * @dev This abstract contract provides getters and event emitting update functions for
460  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
461  *
462  * _Available since v4.1._
463  *
464  * @custom:oz-upgrades-unsafe-allow delegatecall
465  */
466 abstract contract ERC1967Upgrade {
467     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
468     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
469 
470     /**
471      * @dev Storage slot with the address of the current implementation.
472      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
473      * validated in the constructor.
474      */
475     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
476 
477     /**
478      * @dev Emitted when the implementation is upgraded.
479      */
480     event Upgraded(address indexed implementation);
481 
482     /**
483      * @dev Returns the current implementation address.
484      */
485     function _getImplementation() internal view returns (address) {
486         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
487     }
488 
489     /**
490      * @dev Stores a new address in the EIP1967 implementation slot.
491      */
492     function _setImplementation(address newImplementation) private {
493         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
494         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
495     }
496 
497     /**
498      * @dev Perform implementation upgrade
499      *
500      * Emits an {Upgraded} event.
501      */
502     function _upgradeTo(address newImplementation) internal {
503         _setImplementation(newImplementation);
504         emit Upgraded(newImplementation);
505     }
506 
507     /**
508      * @dev Perform implementation upgrade with additional setup call.
509      *
510      * Emits an {Upgraded} event.
511      */
512     function _upgradeToAndCall(
513         address newImplementation,
514         bytes memory data,
515         bool forceCall
516     ) internal {
517         _upgradeTo(newImplementation);
518         if (data.length > 0 || forceCall) {
519             Address.functionDelegateCall(newImplementation, data);
520         }
521     }
522 
523     /**
524      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
525      *
526      * Emits an {Upgraded} event.
527      */
528     function _upgradeToAndCallUUPS(
529         address newImplementation,
530         bytes memory data,
531         bool forceCall
532     ) internal {
533         // Upgrades from old implementations will perform a rollback test. This test requires the new
534         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
535         // this special case will break upgrade paths from old UUPS implementation to new ones.
536         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
537             _setImplementation(newImplementation);
538         } else {
539             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
540                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
541             } catch {
542                 revert("ERC1967Upgrade: new implementation is not UUPS");
543             }
544             _upgradeToAndCall(newImplementation, data, forceCall);
545         }
546     }
547 
548     /**
549      * @dev Storage slot with the admin of the contract.
550      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
551      * validated in the constructor.
552      */
553     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
554 
555     /**
556      * @dev Emitted when the admin account has changed.
557      */
558     event AdminChanged(address previousAdmin, address newAdmin);
559 
560     /**
561      * @dev Returns the current admin.
562      */
563     function _getAdmin() internal view returns (address) {
564         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
565     }
566 
567     /**
568      * @dev Stores a new address in the EIP1967 admin slot.
569      */
570     function _setAdmin(address newAdmin) private {
571         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
572         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
573     }
574 
575     /**
576      * @dev Changes the admin of the proxy.
577      *
578      * Emits an {AdminChanged} event.
579      */
580     function _changeAdmin(address newAdmin) internal {
581         emit AdminChanged(_getAdmin(), newAdmin);
582         _setAdmin(newAdmin);
583     }
584 
585     /**
586      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
587      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
588      */
589     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
590 
591     /**
592      * @dev Emitted when the beacon is upgraded.
593      */
594     event BeaconUpgraded(address indexed beacon);
595 
596     /**
597      * @dev Returns the current beacon.
598      */
599     function _getBeacon() internal view returns (address) {
600         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
601     }
602 
603     /**
604      * @dev Stores a new beacon in the EIP1967 beacon slot.
605      */
606     function _setBeacon(address newBeacon) private {
607         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
608         require(
609             Address.isContract(IBeacon(newBeacon).implementation()),
610             "ERC1967: beacon implementation is not a contract"
611         );
612         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
613     }
614 
615     /**
616      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
617      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
618      *
619      * Emits a {BeaconUpgraded} event.
620      */
621     function _upgradeBeaconToAndCall(
622         address newBeacon,
623         bytes memory data,
624         bool forceCall
625     ) internal {
626         _setBeacon(newBeacon);
627         emit BeaconUpgraded(newBeacon);
628         if (data.length > 0 || forceCall) {
629             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
630         }
631     }
632 }
633 
634 // File: @openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol
635 
636 
637 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 
642 /**
643  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
644  * implementation address that can be changed. This address is stored in storage in the location specified by
645  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
646  * implementation behind the proxy.
647  */
648 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
649     /**
650      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
651      *
652      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
653      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
654      */
655     constructor(address _logic, bytes memory _data) payable {
656         _upgradeToAndCall(_logic, _data, false);
657     }
658 
659     /**
660      * @dev Returns the current implementation address.
661      */
662     function _implementation() internal view virtual override returns (address impl) {
663         return ERC1967Upgrade._getImplementation();
664     }
665 }
666 
667 // File: @openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol
668 
669 
670 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/transparent/TransparentUpgradeableProxy.sol)
671 
672 pragma solidity ^0.8.0;
673 
674 /**
675  * @dev This contract implements a proxy that is upgradeable by an admin.
676  *
677  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
678  * clashing], which can potentially be used in an attack, this contract uses the
679  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
680  * things that go hand in hand:
681  *
682  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
683  * that call matches one of the admin functions exposed by the proxy itself.
684  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
685  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
686  * "admin cannot fallback to proxy target".
687  *
688  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
689  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
690  * to sudden errors when trying to call a function from the proxy implementation.
691  *
692  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
693  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
694  */
695 contract TransparentUpgradeableProxy is ERC1967Proxy {
696     /**
697      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
698      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
699      */
700     constructor(
701         address _logic,
702         address admin_,
703         bytes memory _data
704     ) payable ERC1967Proxy(_logic, _data) {
705         _changeAdmin(admin_);
706     }
707 
708     /**
709      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
710      */
711     modifier ifAdmin() {
712         if (msg.sender == _getAdmin()) {
713             _;
714         } else {
715             _fallback();
716         }
717     }
718 
719     /**
720      * @dev Returns the current admin.
721      *
722      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
723      *
724      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
725      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
726      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
727      */
728     function admin() external ifAdmin returns (address admin_) {
729         admin_ = _getAdmin();
730     }
731 
732     /**
733      * @dev Returns the current implementation.
734      *
735      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
736      *
737      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
738      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
739      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
740      */
741     function implementation() external ifAdmin returns (address implementation_) {
742         implementation_ = _implementation();
743     }
744 
745     /**
746      * @dev Changes the admin of the proxy.
747      *
748      * Emits an {AdminChanged} event.
749      *
750      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
751      */
752     function changeAdmin(address newAdmin) external virtual ifAdmin {
753         _changeAdmin(newAdmin);
754     }
755 
756     /**
757      * @dev Upgrade the implementation of the proxy.
758      *
759      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
760      */
761     function upgradeTo(address newImplementation) external ifAdmin {
762         _upgradeToAndCall(newImplementation, bytes(""), false);
763     }
764 
765     /**
766      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
767      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
768      * proxied contract.
769      *
770      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
771      */
772     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
773         _upgradeToAndCall(newImplementation, data, true);
774     }
775 
776     /**
777      * @dev Returns the current admin.
778      */
779     function _admin() internal view virtual returns (address) {
780         return _getAdmin();
781     }
782 
783     /**
784      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
785      */
786     function _beforeFallback() internal virtual override {
787         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
788         super._beforeFallback();
789     }
790 }
791 
792 // File: contracts/TransparentUpgradeableProxy.sol
793 
794 
795 
796 pragma solidity ^0.8.0;