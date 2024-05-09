1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 // Import Local Solidity Modules
5 
6 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/transparent/TransparentUpgradeableProxy.sol)
7 
8 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
9 
10 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
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
94 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
95 
96 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
97 
98 /**
99  * @dev This is the interface that {BeaconProxy} expects of its beacon.
100  */
101 interface IBeacon {
102     /**
103      * @dev Must return an address that can be used as a delegate call target.
104      *
105      * {BeaconProxy} will check that this address is a contract.
106      */
107     function implementation() external view returns (address);
108 }
109 
110 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
111 
112 /**
113  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
114  * proxy whose upgrades are fully controlled by the current implementation.
115  */
116 interface IERC1822Proxiable {
117     /**
118      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
119      * address.
120      *
121      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
122      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
123      * function revert if invoked through a proxy.
124      */
125     function proxiableUUID() external view returns (bytes32);
126 }
127 
128 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
129 
130 /**
131  * @dev Collection of functions related to the address type
132  */
133 library Address {
134     /**
135      * @dev Returns true if `account` is a contract.
136      *
137      * [IMPORTANT]
138      * ====
139      * It is unsafe to assume that an address for which this function returns
140      * false is an externally-owned account (EOA) and not a contract.
141      *
142      * Among others, `isContract` will return false for the following
143      * types of addresses:
144      *
145      *  - an externally-owned account
146      *  - a contract in construction
147      *  - an address where a contract will be created
148      *  - an address where a contract lived, but was destroyed
149      * ====
150      *
151      * [IMPORTANT]
152      * ====
153      * You shouldn't rely on `isContract` to protect against flash loan attacks!
154      *
155      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
156      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
157      * constructor.
158      * ====
159      */
160     function isContract(address account) internal view returns (bool) {
161         // This method relies on extcodesize/address.code.length, which returns 0
162         // for contracts in construction, since the code is only stored at the end
163         // of the constructor execution.
164 
165         return account.code.length > 0;
166     }
167 
168     /**
169      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
170      * `recipient`, forwarding all available gas and reverting on errors.
171      *
172      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
173      * of certain opcodes, possibly making contracts go over the 2300 gas limit
174      * imposed by `transfer`, making them unable to receive funds via
175      * `transfer`. {sendValue} removes this limitation.
176      *
177      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
178      *
179      * IMPORTANT: because control is transferred to `recipient`, care must be
180      * taken to not create reentrancy vulnerabilities. Consider using
181      * {ReentrancyGuard} or the
182      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
183      */
184     function sendValue(address payable recipient, uint256 amount) internal {
185         require(address(this).balance >= amount, "Address: insufficient balance");
186 
187         (bool success, ) = recipient.call{value: amount}("");
188         require(success, "Address: unable to send value, recipient may have reverted");
189     }
190 
191     /**
192      * @dev Performs a Solidity function call using a low level `call`. A
193      * plain `call` is an unsafe replacement for a function call: use this
194      * function instead.
195      *
196      * If `target` reverts with a revert reason, it is bubbled up by this
197      * function (like regular Solidity function calls).
198      *
199      * Returns the raw returned data. To convert to the expected return value,
200      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
201      *
202      * Requirements:
203      *
204      * - `target` must be a contract.
205      * - calling `target` with `data` must not revert.
206      *
207      * _Available since v3.1._
208      */
209     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
210         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
215      * `errorMessage` as a fallback revert reason when `target` reverts.
216      *
217      * _Available since v3.1._
218      */
219     function functionCall(
220         address target,
221         bytes memory data,
222         string memory errorMessage
223     ) internal returns (bytes memory) {
224         return functionCallWithValue(target, data, 0, errorMessage);
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
229      * but also transferring `value` wei to `target`.
230      *
231      * Requirements:
232      *
233      * - the calling contract must have an ETH balance of at least `value`.
234      * - the called Solidity function must be `payable`.
235      *
236      * _Available since v3.1._
237      */
238     function functionCallWithValue(
239         address target,
240         bytes memory data,
241         uint256 value
242     ) internal returns (bytes memory) {
243         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
248      * with `errorMessage` as a fallback revert reason when `target` reverts.
249      *
250      * _Available since v3.1._
251      */
252     function functionCallWithValue(
253         address target,
254         bytes memory data,
255         uint256 value,
256         string memory errorMessage
257     ) internal returns (bytes memory) {
258         require(address(this).balance >= value, "Address: insufficient balance for call");
259         (bool success, bytes memory returndata) = target.call{value: value}(data);
260         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
265      * but performing a static call.
266      *
267      * _Available since v3.3._
268      */
269     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
270         return functionStaticCall(target, data, "Address: low-level static call failed");
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
275      * but performing a static call.
276      *
277      * _Available since v3.3._
278      */
279     function functionStaticCall(
280         address target,
281         bytes memory data,
282         string memory errorMessage
283     ) internal view returns (bytes memory) {
284         (bool success, bytes memory returndata) = target.staticcall(data);
285         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
290      * but performing a delegate call.
291      *
292      * _Available since v3.4._
293      */
294     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
295         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
300      * but performing a delegate call.
301      *
302      * _Available since v3.4._
303      */
304     function functionDelegateCall(
305         address target,
306         bytes memory data,
307         string memory errorMessage
308     ) internal returns (bytes memory) {
309         (bool success, bytes memory returndata) = target.delegatecall(data);
310         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
311     }
312 
313     /**
314      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
315      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
316      *
317      * _Available since v4.8._
318      */
319     function verifyCallResultFromTarget(
320         address target,
321         bool success,
322         bytes memory returndata,
323         string memory errorMessage
324     ) internal view returns (bytes memory) {
325         if (success) {
326             if (returndata.length == 0) {
327                 // only check isContract if the call was successful and the return data is empty
328                 // otherwise we already know that it was a contract
329                 require(isContract(target), "Address: call to non-contract");
330             }
331             return returndata;
332         } else {
333             _revert(returndata, errorMessage);
334         }
335     }
336 
337     /**
338      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
339      * revert reason or using the provided one.
340      *
341      * _Available since v4.3._
342      */
343     function verifyCallResult(
344         bool success,
345         bytes memory returndata,
346         string memory errorMessage
347     ) internal pure returns (bytes memory) {
348         if (success) {
349             return returndata;
350         } else {
351             _revert(returndata, errorMessage);
352         }
353     }
354 
355     function _revert(bytes memory returndata, string memory errorMessage) private pure {
356         // Look for revert reason and bubble it up if present
357         if (returndata.length > 0) {
358             // The easiest way to bubble the revert reason is using memory via assembly
359             /// @solidity memory-safe-assembly
360             assembly {
361                 let returndata_size := mload(returndata)
362                 revert(add(32, returndata), returndata_size)
363             }
364         } else {
365             revert(errorMessage);
366         }
367     }
368 }
369 
370 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
371 
372 /**
373  * @dev Library for reading and writing primitive types to specific storage slots.
374  *
375  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
376  * This library helps with reading and writing to such slots without the need for inline assembly.
377  *
378  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
379  *
380  * Example usage to set ERC1967 implementation slot:
381  * ```
382  * contract ERC1967 {
383  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
384  *
385  *     function _getImplementation() internal view returns (address) {
386  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
387  *     }
388  *
389  *     function _setImplementation(address newImplementation) internal {
390  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
391  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
392  *     }
393  * }
394  * ```
395  *
396  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
397  */
398 library StorageSlot {
399     struct AddressSlot {
400         address value;
401     }
402 
403     struct BooleanSlot {
404         bool value;
405     }
406 
407     struct Bytes32Slot {
408         bytes32 value;
409     }
410 
411     struct Uint256Slot {
412         uint256 value;
413     }
414 
415     /**
416      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
417      */
418     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
419         /// @solidity memory-safe-assembly
420         assembly {
421             r.slot := slot
422         }
423     }
424 
425     /**
426      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
427      */
428     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
429         /// @solidity memory-safe-assembly
430         assembly {
431             r.slot := slot
432         }
433     }
434 
435     /**
436      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
437      */
438     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
439         /// @solidity memory-safe-assembly
440         assembly {
441             r.slot := slot
442         }
443     }
444 
445     /**
446      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
447      */
448     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
449         /// @solidity memory-safe-assembly
450         assembly {
451             r.slot := slot
452         }
453     }
454 }
455 
456 /**
457  * @dev This abstract contract provides getters and event emitting update functions for
458  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
459  *
460  * _Available since v4.1._
461  *
462  * @custom:oz-upgrades-unsafe-allow delegatecall
463  */
464 abstract contract ERC1967Upgrade {
465     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
466     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
467 
468     /**
469      * @dev Storage slot with the address of the current implementation.
470      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
471      * validated in the constructor.
472      */
473     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
474 
475     /**
476      * @dev Emitted when the implementation is upgraded.
477      */
478     event Upgraded(address indexed implementation);
479 
480     /**
481      * @dev Returns the current implementation address.
482      */
483     function _getImplementation() internal view returns (address) {
484         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
485     }
486 
487     /**
488      * @dev Stores a new address in the EIP1967 implementation slot.
489      */
490     function _setImplementation(address newImplementation) private {
491         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
492         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
493     }
494 
495     /**
496      * @dev Perform implementation upgrade
497      *
498      * Emits an {Upgraded} event.
499      */
500     function _upgradeTo(address newImplementation) internal {
501         _setImplementation(newImplementation);
502         emit Upgraded(newImplementation);
503     }
504 
505     /**
506      * @dev Perform implementation upgrade with additional setup call.
507      *
508      * Emits an {Upgraded} event.
509      */
510     function _upgradeToAndCall(
511         address newImplementation,
512         bytes memory data,
513         bool forceCall
514     ) internal {
515         _upgradeTo(newImplementation);
516         if (data.length > 0 || forceCall) {
517             Address.functionDelegateCall(newImplementation, data);
518         }
519     }
520 
521     /**
522      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
523      *
524      * Emits an {Upgraded} event.
525      */
526     function _upgradeToAndCallUUPS(
527         address newImplementation,
528         bytes memory data,
529         bool forceCall
530     ) internal {
531         // Upgrades from old implementations will perform a rollback test. This test requires the new
532         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
533         // this special case will break upgrade paths from old UUPS implementation to new ones.
534         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
535             _setImplementation(newImplementation);
536         } else {
537             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
538                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
539             } catch {
540                 revert("ERC1967Upgrade: new implementation is not UUPS");
541             }
542             _upgradeToAndCall(newImplementation, data, forceCall);
543         }
544     }
545 
546     /**
547      * @dev Storage slot with the admin of the contract.
548      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
549      * validated in the constructor.
550      */
551     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
552 
553     /**
554      * @dev Emitted when the admin account has changed.
555      */
556     event AdminChanged(address previousAdmin, address newAdmin);
557 
558     /**
559      * @dev Returns the current admin.
560      */
561     function _getAdmin() internal view returns (address) {
562         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
563     }
564 
565     /**
566      * @dev Stores a new address in the EIP1967 admin slot.
567      */
568     function _setAdmin(address newAdmin) private {
569         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
570         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
571     }
572 
573     /**
574      * @dev Changes the admin of the proxy.
575      *
576      * Emits an {AdminChanged} event.
577      */
578     function _changeAdmin(address newAdmin) internal {
579         emit AdminChanged(_getAdmin(), newAdmin);
580         _setAdmin(newAdmin);
581     }
582 
583     /**
584      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
585      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
586      */
587     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
588 
589     /**
590      * @dev Emitted when the beacon is upgraded.
591      */
592     event BeaconUpgraded(address indexed beacon);
593 
594     /**
595      * @dev Returns the current beacon.
596      */
597     function _getBeacon() internal view returns (address) {
598         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
599     }
600 
601     /**
602      * @dev Stores a new beacon in the EIP1967 beacon slot.
603      */
604     function _setBeacon(address newBeacon) private {
605         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
606         require(
607             Address.isContract(IBeacon(newBeacon).implementation()),
608             "ERC1967: beacon implementation is not a contract"
609         );
610         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
611     }
612 
613     /**
614      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
615      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
616      *
617      * Emits a {BeaconUpgraded} event.
618      */
619     function _upgradeBeaconToAndCall(
620         address newBeacon,
621         bytes memory data,
622         bool forceCall
623     ) internal {
624         _setBeacon(newBeacon);
625         emit BeaconUpgraded(newBeacon);
626         if (data.length > 0 || forceCall) {
627             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
628         }
629     }
630 }
631 
632 /**
633  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
634  * implementation address that can be changed. This address is stored in storage in the location specified by
635  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
636  * implementation behind the proxy.
637  */
638 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
639     /**
640      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
641      *
642      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
643      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
644      */
645     constructor(address _logic, bytes memory _data) payable {
646         _upgradeToAndCall(_logic, _data, false);
647     }
648 
649     /**
650      * @dev Returns the current implementation address.
651      */
652     function _implementation() internal view virtual override returns (address impl) {
653         return ERC1967Upgrade._getImplementation();
654     }
655 }
656 
657 /**
658  * @dev This contract implements a proxy that is upgradeable by an admin.
659  *
660  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
661  * clashing], which can potentially be used in an attack, this contract uses the
662  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
663  * things that go hand in hand:
664  *
665  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
666  * that call matches one of the admin functions exposed by the proxy itself.
667  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
668  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
669  * "admin cannot fallback to proxy target".
670  *
671  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
672  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
673  * to sudden errors when trying to call a function from the proxy implementation.
674  *
675  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
676  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
677  */
678 contract TransparentUpgradeableProxy is ERC1967Proxy {
679     /**
680      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
681      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
682      */
683     constructor(
684         address _logic,
685         address admin_,
686         bytes memory _data
687     ) payable ERC1967Proxy(_logic, _data) {
688         _changeAdmin(admin_);
689     }
690 
691     /**
692      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
693      */
694     modifier ifAdmin() {
695         if (msg.sender == _getAdmin()) {
696             _;
697         } else {
698             _fallback();
699         }
700     }
701 
702     /**
703      * @dev Returns the current admin.
704      *
705      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
706      *
707      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
708      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
709      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
710      */
711     function admin() external ifAdmin returns (address admin_) {
712         admin_ = _getAdmin();
713     }
714 
715     /**
716      * @dev Returns the current implementation.
717      *
718      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
719      *
720      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
721      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
722      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
723      */
724     function implementation() external ifAdmin returns (address implementation_) {
725         implementation_ = _implementation();
726     }
727 
728     /**
729      * @dev Changes the admin of the proxy.
730      *
731      * Emits an {AdminChanged} event.
732      *
733      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
734      */
735     function changeAdmin(address newAdmin) external virtual ifAdmin {
736         _changeAdmin(newAdmin);
737     }
738 
739     /**
740      * @dev Upgrade the implementation of the proxy.
741      *
742      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
743      */
744     function upgradeTo(address newImplementation) external ifAdmin {
745         _upgradeToAndCall(newImplementation, bytes(""), false);
746     }
747 
748     /**
749      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
750      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
751      * proxied contract.
752      *
753      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
754      */
755     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
756         _upgradeToAndCall(newImplementation, data, true);
757     }
758 
759     /**
760      * @dev Returns the current admin.
761      */
762     function _admin() internal view virtual returns (address) {
763         return _getAdmin();
764     }
765 
766     /**
767      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
768      */
769     function _beforeFallback() internal virtual override {
770         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
771         super._beforeFallback();
772     }
773 }