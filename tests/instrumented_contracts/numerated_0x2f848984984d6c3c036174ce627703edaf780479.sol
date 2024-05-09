1 // SPDX-License-Identifier: MIT
2 /**
3  * https://mct.xyz - The all-in-one toolbox for your crypto adventure
4 
5 //  __  __   _____  _______      __   ____     __ ______
6 // |  \/  | / ____||__   __|     \ \ / /\ \   / /|___  /
7 // | \  / || |        | |         \ V /  \ \_/ /    / /
8 // | |\/| || |        | |          > <    \   /    / /
9 // | |  | || |____    | |    _    / . \    | |    / /__
10 // |_|  |_| \_____|   |_|   (_)  /_/ \_\   |_|   /_____|
11 
12 // XEN BATCH MINT - Deployed by Easy
13 // To Use this Dapp: https://mct.xyz/xen-batch-mint
14 */
15 
16 pragma solidity ^0.8.16;
17 
18 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
19 /**
20  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
21  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
22  * be specified by overriding the virtual {_implementation} function.
23  *
24  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
25  * different contract through the {_delegate} function.
26  *
27  * The success and return data of the delegated call will be returned back to the caller of the proxy.
28  */
29 abstract contract Proxy {
30     /**
31      * @dev Delegates the current call to `implementation`.
32      *
33      * This function does not return to its internal call site, it will return directly to the external caller.
34      */
35     function _delegate(address implementation) internal virtual {
36         assembly {
37             // Copy msg.data. We take full control of memory in this inline assembly
38             // block because it will not return to Solidity code. We overwrite the
39             // Solidity scratch pad at memory position 0.
40             calldatacopy(0, 0, calldatasize())
41 
42             // Call the implementation.
43             // out and outsize are 0 because we don't know the size yet.
44             let result := delegatecall(
45                 gas(),
46                 implementation,
47                 0,
48                 calldatasize(),
49                 0,
50                 0
51             )
52 
53             // Copy the returned data.
54             returndatacopy(0, 0, returndatasize())
55 
56             switch result
57             // delegatecall returns 0 on error.
58             case 0 {
59                 revert(0, returndatasize())
60             }
61             default {
62                 return(0, returndatasize())
63             }
64         }
65     }
66 
67     /**
68      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
69      * and {_fallback} should delegate.
70      */
71     function _implementation() internal view virtual returns (address);
72 
73     /**
74      * @dev Delegates the current call to the address returned by `_implementation()`.
75      *
76      * This function does not return to its internal call site, it will return directly to the external caller.
77      */
78     function _fallback() internal virtual {
79         _beforeFallback();
80         _delegate(_implementation());
81     }
82 
83     /**
84      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
85      * function in the contract matches the call data.
86      */
87     fallback() external payable virtual {
88         _fallback();
89     }
90 
91     /**
92      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
93      * is empty.
94      */
95     receive() external payable virtual {
96         _fallback();
97     }
98 
99     /**
100      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
101      * call, or as part of the Solidity `fallback` or `receive` functions.
102      *
103      * If overridden should call `super._beforeFallback()`.
104      */
105     function _beforeFallback() internal virtual {}
106 }
107 
108 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
109 /**
110  * @dev This is the interface that {BeaconProxy} expects of its beacon.
111  */
112 interface IBeacon {
113     /**
114      * @dev Must return an address that can be used as a delegate call target.
115      *
116      * {BeaconProxy} will check that this address is a contract.
117      */
118     function implementation() external view returns (address);
119 }
120 
121 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
122 /**
123  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
124  * proxy whose upgrades are fully controlled by the current implementation.
125  */
126 interface IERC1822Proxiable {
127     /**
128      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
129      * address.
130      *
131      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
132      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
133      * function revert if invoked through a proxy.
134      */
135     function proxiableUUID() external view returns (bytes32);
136 }
137 
138 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
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
194         require(
195             address(this).balance >= amount,
196             "Address: insufficient balance"
197         );
198 
199         (bool success, ) = recipient.call{value: amount}("");
200         require(
201             success,
202             "Address: unable to send value, recipient may have reverted"
203         );
204     }
205 
206     /**
207      * @dev Performs a Solidity function call using a low level `call`. A
208      * plain `call` is an unsafe replacement for a function call: use this
209      * function instead.
210      *
211      * If `target` reverts with a revert reason, it is bubbled up by this
212      * function (like regular Solidity function calls).
213      *
214      * Returns the raw returned data. To convert to the expected return value,
215      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
216      *
217      * Requirements:
218      *
219      * - `target` must be a contract.
220      * - calling `target` with `data` must not revert.
221      *
222      * _Available since v3.1._
223      */
224     function functionCall(address target, bytes memory data)
225         internal
226         returns (bytes memory)
227     {
228         return functionCall(target, data, "Address: low-level call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
233      * `errorMessage` as a fallback revert reason when `target` reverts.
234      *
235      * _Available since v3.1._
236      */
237     function functionCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal returns (bytes memory) {
242         return functionCallWithValue(target, data, 0, errorMessage);
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
247      * but also transferring `value` wei to `target`.
248      *
249      * Requirements:
250      *
251      * - the calling contract must have an ETH balance of at least `value`.
252      * - the called Solidity function must be `payable`.
253      *
254      * _Available since v3.1._
255      */
256     function functionCallWithValue(
257         address target,
258         bytes memory data,
259         uint256 value
260     ) internal returns (bytes memory) {
261         return
262             functionCallWithValue(
263                 target,
264                 data,
265                 value,
266                 "Address: low-level call with value failed"
267             );
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
272      * with `errorMessage` as a fallback revert reason when `target` reverts.
273      *
274      * _Available since v3.1._
275      */
276     function functionCallWithValue(
277         address target,
278         bytes memory data,
279         uint256 value,
280         string memory errorMessage
281     ) internal returns (bytes memory) {
282         require(
283             address(this).balance >= value,
284             "Address: insufficient balance for call"
285         );
286         require(isContract(target), "Address: call to non-contract");
287 
288         (bool success, bytes memory returndata) = target.call{value: value}(
289             data
290         );
291         return verifyCallResult(success, returndata, errorMessage);
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
296      * but performing a static call.
297      *
298      * _Available since v3.3._
299      */
300     function functionStaticCall(address target, bytes memory data)
301         internal
302         view
303         returns (bytes memory)
304     {
305         return
306             functionStaticCall(
307                 target,
308                 data,
309                 "Address: low-level static call failed"
310             );
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
315      * but performing a static call.
316      *
317      * _Available since v3.3._
318      */
319     function functionStaticCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal view returns (bytes memory) {
324         require(isContract(target), "Address: static call to non-contract");
325 
326         (bool success, bytes memory returndata) = target.staticcall(data);
327         return verifyCallResult(success, returndata, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but performing a delegate call.
333      *
334      * _Available since v3.4._
335      */
336     function functionDelegateCall(address target, bytes memory data)
337         internal
338         returns (bytes memory)
339     {
340         return
341             functionDelegateCall(
342                 target,
343                 data,
344                 "Address: low-level delegate call failed"
345             );
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
350      * but performing a delegate call.
351      *
352      * _Available since v3.4._
353      */
354     function functionDelegateCall(
355         address target,
356         bytes memory data,
357         string memory errorMessage
358     ) internal returns (bytes memory) {
359         require(isContract(target), "Address: delegate call to non-contract");
360 
361         (bool success, bytes memory returndata) = target.delegatecall(data);
362         return verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
367      * revert reason using the provided one.
368      *
369      * _Available since v4.3._
370      */
371     function verifyCallResult(
372         bool success,
373         bytes memory returndata,
374         string memory errorMessage
375     ) internal pure returns (bytes memory) {
376         if (success) {
377             return returndata;
378         } else {
379             // Look for revert reason and bubble it up if present
380             if (returndata.length > 0) {
381                 // The easiest way to bubble the revert reason is using memory via assembly
382                 /// @solidity memory-safe-assembly
383                 assembly {
384                     let returndata_size := mload(returndata)
385                     revert(add(32, returndata), returndata_size)
386                 }
387             } else {
388                 revert(errorMessage);
389             }
390         }
391     }
392 }
393 
394 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
395 /**
396  * @dev Library for reading and writing primitive types to specific storage slots.
397  *
398  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
399  * This library helps with reading and writing to such slots without the need for inline assembly.
400  *
401  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
402  *
403  * Example usage to set ERC1967 implementation slot:
404  * ```
405  * contract ERC1967 {
406  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
407  *
408  *     function _getImplementation() internal view returns (address) {
409  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
410  *     }
411  *
412  *     function _setImplementation(address newImplementation) internal {
413  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
414  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
415  *     }
416  * }
417  * ```
418  *
419  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
420  */
421 library StorageSlot {
422     struct AddressSlot {
423         address value;
424     }
425 
426     struct BooleanSlot {
427         bool value;
428     }
429 
430     struct Bytes32Slot {
431         bytes32 value;
432     }
433 
434     struct Uint256Slot {
435         uint256 value;
436     }
437 
438     /**
439      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
440      */
441     function getAddressSlot(bytes32 slot)
442         internal
443         pure
444         returns (AddressSlot storage r)
445     {
446         /// @solidity memory-safe-assembly
447         assembly {
448             r.slot := slot
449         }
450     }
451 
452     /**
453      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
454      */
455     function getBooleanSlot(bytes32 slot)
456         internal
457         pure
458         returns (BooleanSlot storage r)
459     {
460         /// @solidity memory-safe-assembly
461         assembly {
462             r.slot := slot
463         }
464     }
465 
466     /**
467      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
468      */
469     function getBytes32Slot(bytes32 slot)
470         internal
471         pure
472         returns (Bytes32Slot storage r)
473     {
474         /// @solidity memory-safe-assembly
475         assembly {
476             r.slot := slot
477         }
478     }
479 
480     /**
481      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
482      */
483     function getUint256Slot(bytes32 slot)
484         internal
485         pure
486         returns (Uint256Slot storage r)
487     {
488         /// @solidity memory-safe-assembly
489         assembly {
490             r.slot := slot
491         }
492     }
493 }
494 
495 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
496 /**
497  * @dev This abstract contract provides getters and event emitting update functions for
498  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
499  *
500  * _Available since v4.1._
501  *
502  * @custom:oz-upgrades-unsafe-allow delegatecall
503  */
504 abstract contract ERC1967Upgrade {
505     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
506     bytes32 private constant _ROLLBACK_SLOT =
507         0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
508 
509     /**
510      * @dev Storage slot with the address of the current implementation.
511      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
512      * validated in the constructor.
513      */
514     bytes32 internal constant _IMPLEMENTATION_SLOT =
515         0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
516 
517     /**
518      * @dev Emitted when the implementation is upgraded.
519      */
520     event Upgraded(address indexed implementation);
521 
522     /**
523      * @dev Returns the current implementation address.
524      */
525     function _getImplementation() internal view returns (address) {
526         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
527     }
528 
529     /**
530      * @dev Stores a new address in the EIP1967 implementation slot.
531      */
532     function _setImplementation(address newImplementation) private {
533         require(
534             Address.isContract(newImplementation),
535             "ERC1967: new implementation is not a contract"
536         );
537         StorageSlot
538             .getAddressSlot(_IMPLEMENTATION_SLOT)
539             .value = newImplementation;
540     }
541 
542     /**
543      * @dev Perform implementation upgrade
544      *
545      * Emits an {Upgraded} event.
546      */
547     function _upgradeTo(address newImplementation) internal {
548         _setImplementation(newImplementation);
549         emit Upgraded(newImplementation);
550     }
551 
552     /**
553      * @dev Perform implementation upgrade with additional setup call.
554      *
555      * Emits an {Upgraded} event.
556      */
557     function _upgradeToAndCall(
558         address newImplementation,
559         bytes memory data,
560         bool forceCall
561     ) internal {
562         _upgradeTo(newImplementation);
563         if (data.length > 0 || forceCall) {
564             Address.functionDelegateCall(newImplementation, data);
565         }
566     }
567 
568     /**
569      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
570      *
571      * Emits an {Upgraded} event.
572      */
573     function _upgradeToAndCallUUPS(
574         address newImplementation,
575         bytes memory data,
576         bool forceCall
577     ) internal {
578         // Upgrades from old implementations will perform a rollback test. This test requires the new
579         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
580         // this special case will break upgrade paths from old UUPS implementation to new ones.
581         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
582             _setImplementation(newImplementation);
583         } else {
584             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (
585                 bytes32 slot
586             ) {
587                 require(
588                     slot == _IMPLEMENTATION_SLOT,
589                     "ERC1967Upgrade: unsupported proxiableUUID"
590                 );
591             } catch {
592                 revert("ERC1967Upgrade: new implementation is not UUPS");
593             }
594             _upgradeToAndCall(newImplementation, data, forceCall);
595         }
596     }
597 
598     /**
599      * @dev Storage slot with the admin of the contract.
600      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
601      * validated in the constructor.
602      */
603     bytes32 internal constant _ADMIN_SLOT =
604         0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
605 
606     /**
607      * @dev Emitted when the admin account has changed.
608      */
609     event AdminChanged(address previousAdmin, address newAdmin);
610 
611     /**
612      * @dev Returns the current admin.
613      */
614     function _getAdmin() internal view returns (address) {
615         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
616     }
617 
618     /**
619      * @dev Stores a new address in the EIP1967 admin slot.
620      */
621     function _setAdmin(address newAdmin) private {
622         require(
623             newAdmin != address(0),
624             "ERC1967: new admin is the zero address"
625         );
626         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
627     }
628 
629     /**
630      * @dev Changes the admin of the proxy.
631      *
632      * Emits an {AdminChanged} event.
633      */
634     function _changeAdmin(address newAdmin) internal {
635         emit AdminChanged(_getAdmin(), newAdmin);
636         _setAdmin(newAdmin);
637     }
638 
639     /**
640      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
641      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
642      */
643     bytes32 internal constant _BEACON_SLOT =
644         0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
645 
646     /**
647      * @dev Emitted when the beacon is upgraded.
648      */
649     event BeaconUpgraded(address indexed beacon);
650 
651     /**
652      * @dev Returns the current beacon.
653      */
654     function _getBeacon() internal view returns (address) {
655         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
656     }
657 
658     /**
659      * @dev Stores a new beacon in the EIP1967 beacon slot.
660      */
661     function _setBeacon(address newBeacon) private {
662         require(
663             Address.isContract(newBeacon),
664             "ERC1967: new beacon is not a contract"
665         );
666         require(
667             Address.isContract(IBeacon(newBeacon).implementation()),
668             "ERC1967: beacon implementation is not a contract"
669         );
670         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
671     }
672 
673     /**
674      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
675      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
676      *
677      * Emits a {BeaconUpgraded} event.
678      */
679     function _upgradeBeaconToAndCall(
680         address newBeacon,
681         bytes memory data,
682         bool forceCall
683     ) internal {
684         _setBeacon(newBeacon);
685         emit BeaconUpgraded(newBeacon);
686         if (data.length > 0 || forceCall) {
687             Address.functionDelegateCall(
688                 IBeacon(newBeacon).implementation(),
689                 data
690             );
691         }
692     }
693 }
694 
695 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
696 /**
697  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
698  * implementation address that can be changed. This address is stored in storage in the location specified by
699  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
700  * implementation behind the proxy.
701  */
702 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
703     /**
704      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
705      *
706      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
707      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
708      */
709     constructor(address _logic, bytes memory _data) payable {
710         _upgradeToAndCall(_logic, _data, false);
711     }
712 
713     /**
714      * @dev Returns the current implementation address.
715      */
716     function _implementation()
717         internal
718         view
719         virtual
720         override
721         returns (address impl)
722     {
723         return ERC1967Upgrade._getImplementation();
724     }
725 }
726 
727 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/transparent/TransparentUpgradeableProxy.sol)
728 /**
729  * @dev This contract implements a proxy that is upgradeable by an admin.
730  *
731  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
732  * clashing], which can potentially be used in an attack, this contract uses the
733  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
734  * things that go hand in hand:
735  *
736  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
737  * that call matches one of the admin functions exposed by the proxy itself.
738  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
739  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
740  * "admin cannot fallback to proxy target".
741  *
742  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
743  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
744  * to sudden errors when trying to call a function from the proxy implementation.
745  *
746  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
747  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
748  */
749 contract TransparentUpgradeableProxy is ERC1967Proxy {
750     /**
751      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
752      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
753      */
754     constructor(
755         address _logic,
756         address admin_,
757         bytes memory _data
758     ) payable ERC1967Proxy(_logic, _data) {
759         _changeAdmin(admin_);
760     }
761 
762     /**
763      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
764      */
765     modifier ifAdmin() {
766         if (msg.sender == _getAdmin()) {
767             _;
768         } else {
769             _fallback();
770         }
771     }
772 
773     /**
774      * @dev Returns the current admin.
775      *
776      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
777      *
778      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
779      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
780      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
781      */
782     function admin() external ifAdmin returns (address admin_) {
783         admin_ = _getAdmin();
784     }
785 
786     /**
787      * @dev Returns the current implementation.
788      *
789      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
790      *
791      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
792      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
793      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
794      */
795     function implementation()
796         external
797         ifAdmin
798         returns (address implementation_)
799     {
800         implementation_ = _implementation();
801     }
802 
803     /**
804      * @dev Changes the admin of the proxy.
805      *
806      * Emits an {AdminChanged} event.
807      *
808      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
809      */
810     function changeAdmin(address newAdmin) external virtual ifAdmin {
811         _changeAdmin(newAdmin);
812     }
813 
814     /**
815      * @dev Upgrade the implementation of the proxy.
816      *
817      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
818      */
819     function upgradeTo(address newImplementation) external ifAdmin {
820         _upgradeToAndCall(newImplementation, bytes(""), false);
821     }
822 
823     /**
824      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
825      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
826      * proxied contract.
827      *
828      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
829      */
830     function upgradeToAndCall(address newImplementation, bytes calldata data)
831         external
832         payable
833         ifAdmin
834     {
835         _upgradeToAndCall(newImplementation, data, true);
836     }
837 
838     /**
839      * @dev Returns the current admin.
840      */
841     function _admin() internal view virtual returns (address) {
842         return _getAdmin();
843     }
844 
845     /**
846      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
847      */
848     function _beforeFallback() internal virtual override {
849         require(
850             msg.sender != _getAdmin(),
851             "TransparentUpgradeableProxy: admin cannot fallback to proxy target"
852         );
853         super._beforeFallback();
854     }
855 }
856 
857 /**
858  * @dev TransparentUpgradeableProxy where admin is allowed to call implementation methods.
859  */
860 contract XenProxy is TransparentUpgradeableProxy {
861     /**
862      * @dev Initializes an upgradeable proxy backed by the implementation at `_logic`.
863      */
864     constructor(address _logic, bytes memory _x)
865         TransparentUpgradeableProxy(_logic, tx.origin, _x)
866     {}
867 
868     /**
869      * @dev Override to allow admin access the fallback function.
870      */
871     function _beforeFallback() internal override {}
872 }