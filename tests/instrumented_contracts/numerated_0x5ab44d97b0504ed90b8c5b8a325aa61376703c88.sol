1 // SPDX-License-Identifier: Apache-2.0
2 
3 /// @title E30D by glitch gallery
4 /// @author transientlabs.xyz
5 
6 pragma solidity 0.8.17;
7 
8 /// @title TLCoreCreator.sol
9 /// @notice Transient Labs Core Creator Contract
10 /// @dev this works for either ERC721TL or ERC1155TL contracts, just need to change the implementation
11 /// @author transientlabs.xyz
12 
13 /*
14     ____        _ __    __   ____  _ ________                     __ 
15    / __ )__  __(_) /___/ /  / __ \(_) __/ __/__  ________  ____  / /_
16   / __  / / / / / / __  /  / / / / / /_/ /_/ _ \/ ___/ _ \/ __ \/ __/
17  / /_/ / /_/ / / / /_/ /  / /_/ / / __/ __/  __/ /  /  __/ / / / /__ 
18 /_____/\__,_/_/_/\__,_/  /_____/_/_/ /_/  \___/_/   \___/_/ /_/\__(_)*/
19 
20 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
21 
22 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
23 
24 /**
25  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
26  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
27  * be specified by overriding the virtual {_implementation} function.
28  *
29  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
30  * different contract through the {_delegate} function.
31  *
32  * The success and return data of the delegated call will be returned back to the caller of the proxy.
33  */
34 abstract contract Proxy {
35     /**
36      * @dev Delegates the current call to `implementation`.
37      *
38      * This function does not return to its internal call site, it will return directly to the external caller.
39      */
40     function _delegate(address implementation) internal virtual {
41         assembly {
42             // Copy msg.data. We take full control of memory in this inline assembly
43             // block because it will not return to Solidity code. We overwrite the
44             // Solidity scratch pad at memory position 0.
45             calldatacopy(0, 0, calldatasize())
46 
47             // Call the implementation.
48             // out and outsize are 0 because we don't know the size yet.
49             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
50 
51             // Copy the returned data.
52             returndatacopy(0, 0, returndatasize())
53 
54             switch result
55             // delegatecall returns 0 on error.
56             case 0 {
57                 revert(0, returndatasize())
58             }
59             default {
60                 return(0, returndatasize())
61             }
62         }
63     }
64 
65     /**
66      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
67      * and {_fallback} should delegate.
68      */
69     function _implementation() internal view virtual returns (address);
70 
71     /**
72      * @dev Delegates the current call to the address returned by `_implementation()`.
73      *
74      * This function does not return to its internal call site, it will return directly to the external caller.
75      */
76     function _fallback() internal virtual {
77         _beforeFallback();
78         _delegate(_implementation());
79     }
80 
81     /**
82      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
83      * function in the contract matches the call data.
84      */
85     fallback() external payable virtual {
86         _fallback();
87     }
88 
89     /**
90      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
91      * is empty.
92      */
93     receive() external payable virtual {
94         _fallback();
95     }
96 
97     /**
98      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
99      * call, or as part of the Solidity `fallback` or `receive` functions.
100      *
101      * If overridden should call `super._beforeFallback()`.
102      */
103     function _beforeFallback() internal virtual {}
104 }
105 
106 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
107 
108 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
109 
110 /**
111  * @dev This is the interface that {BeaconProxy} expects of its beacon.
112  */
113 interface IBeacon {
114     /**
115      * @dev Must return an address that can be used as a delegate call target.
116      *
117      * {BeaconProxy} will check that this address is a contract.
118      */
119     function implementation() external view returns (address);
120 }
121 
122 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
123 
124 /**
125  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
126  * proxy whose upgrades are fully controlled by the current implementation.
127  */
128 interface IERC1822Proxiable {
129     /**
130      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
131      * address.
132      *
133      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
134      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
135      * function revert if invoked through a proxy.
136      */
137     function proxiableUUID() external view returns (bytes32);
138 }
139 
140 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
141 
142 /**
143  * @dev Collection of functions related to the address type
144  */
145 library Address {
146     /**
147      * @dev Returns true if `account` is a contract.
148      *
149      * [IMPORTANT]
150      * ====
151      * It is unsafe to assume that an address for which this function returns
152      * false is an externally-owned account (EOA) and not a contract.
153      *
154      * Among others, `isContract` will return false for the following
155      * types of addresses:
156      *
157      *  - an externally-owned account
158      *  - a contract in construction
159      *  - an address where a contract will be created
160      *  - an address where a contract lived, but was destroyed
161      * ====
162      *
163      * [IMPORTANT]
164      * ====
165      * You shouldn't rely on `isContract` to protect against flash loan attacks!
166      *
167      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
168      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
169      * constructor.
170      * ====
171      */
172     function isContract(address account) internal view returns (bool) {
173         // This method relies on extcodesize/address.code.length, which returns 0
174         // for contracts in construction, since the code is only stored at the end
175         // of the constructor execution.
176 
177         return account.code.length > 0;
178     }
179 
180     /**
181      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
182      * `recipient`, forwarding all available gas and reverting on errors.
183      *
184      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
185      * of certain opcodes, possibly making contracts go over the 2300 gas limit
186      * imposed by `transfer`, making them unable to receive funds via
187      * `transfer`. {sendValue} removes this limitation.
188      *
189      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
190      *
191      * IMPORTANT: because control is transferred to `recipient`, care must be
192      * taken to not create reentrancy vulnerabilities. Consider using
193      * {ReentrancyGuard} or the
194      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
195      */
196     function sendValue(address payable recipient, uint256 amount) internal {
197         require(address(this).balance >= amount, "Address: insufficient balance");
198 
199         (bool success, ) = recipient.call{value: amount}("");
200         require(success, "Address: unable to send value, recipient may have reverted");
201     }
202 
203     /**
204      * @dev Performs a Solidity function call using a low level `call`. A
205      * plain `call` is an unsafe replacement for a function call: use this
206      * function instead.
207      *
208      * If `target` reverts with a revert reason, it is bubbled up by this
209      * function (like regular Solidity function calls).
210      *
211      * Returns the raw returned data. To convert to the expected return value,
212      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
213      *
214      * Requirements:
215      *
216      * - `target` must be a contract.
217      * - calling `target` with `data` must not revert.
218      *
219      * _Available since v3.1._
220      */
221     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
222         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
227      * `errorMessage` as a fallback revert reason when `target` reverts.
228      *
229      * _Available since v3.1._
230      */
231     function functionCall(
232         address target,
233         bytes memory data,
234         string memory errorMessage
235     ) internal returns (bytes memory) {
236         return functionCallWithValue(target, data, 0, errorMessage);
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
241      * but also transferring `value` wei to `target`.
242      *
243      * Requirements:
244      *
245      * - the calling contract must have an ETH balance of at least `value`.
246      * - the called Solidity function must be `payable`.
247      *
248      * _Available since v3.1._
249      */
250     function functionCallWithValue(
251         address target,
252         bytes memory data,
253         uint256 value
254     ) internal returns (bytes memory) {
255         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
260      * with `errorMessage` as a fallback revert reason when `target` reverts.
261      *
262      * _Available since v3.1._
263      */
264     function functionCallWithValue(
265         address target,
266         bytes memory data,
267         uint256 value,
268         string memory errorMessage
269     ) internal returns (bytes memory) {
270         require(address(this).balance >= value, "Address: insufficient balance for call");
271         (bool success, bytes memory returndata) = target.call{value: value}(data);
272         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
277      * but performing a static call.
278      *
279      * _Available since v3.3._
280      */
281     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
282         return functionStaticCall(target, data, "Address: low-level static call failed");
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
287      * but performing a static call.
288      *
289      * _Available since v3.3._
290      */
291     function functionStaticCall(
292         address target,
293         bytes memory data,
294         string memory errorMessage
295     ) internal view returns (bytes memory) {
296         (bool success, bytes memory returndata) = target.staticcall(data);
297         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
302      * but performing a delegate call.
303      *
304      * _Available since v3.4._
305      */
306     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
307         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
312      * but performing a delegate call.
313      *
314      * _Available since v3.4._
315      */
316     function functionDelegateCall(
317         address target,
318         bytes memory data,
319         string memory errorMessage
320     ) internal returns (bytes memory) {
321         (bool success, bytes memory returndata) = target.delegatecall(data);
322         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
323     }
324 
325     /**
326      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
327      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
328      *
329      * _Available since v4.8._
330      */
331     function verifyCallResultFromTarget(
332         address target,
333         bool success,
334         bytes memory returndata,
335         string memory errorMessage
336     ) internal view returns (bytes memory) {
337         if (success) {
338             if (returndata.length == 0) {
339                 // only check isContract if the call was successful and the return data is empty
340                 // otherwise we already know that it was a contract
341                 require(isContract(target), "Address: call to non-contract");
342             }
343             return returndata;
344         } else {
345             _revert(returndata, errorMessage);
346         }
347     }
348 
349     /**
350      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
351      * revert reason or using the provided one.
352      *
353      * _Available since v4.3._
354      */
355     function verifyCallResult(
356         bool success,
357         bytes memory returndata,
358         string memory errorMessage
359     ) internal pure returns (bytes memory) {
360         if (success) {
361             return returndata;
362         } else {
363             _revert(returndata, errorMessage);
364         }
365     }
366 
367     function _revert(bytes memory returndata, string memory errorMessage) private pure {
368         // Look for revert reason and bubble it up if present
369         if (returndata.length > 0) {
370             // The easiest way to bubble the revert reason is using memory via assembly
371             /// @solidity memory-safe-assembly
372             assembly {
373                 let returndata_size := mload(returndata)
374                 revert(add(32, returndata), returndata_size)
375             }
376         } else {
377             revert(errorMessage);
378         }
379     }
380 }
381 
382 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
383 
384 /**
385  * @dev Library for reading and writing primitive types to specific storage slots.
386  *
387  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
388  * This library helps with reading and writing to such slots without the need for inline assembly.
389  *
390  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
391  *
392  * Example usage to set ERC1967 implementation slot:
393  * ```
394  * contract ERC1967 {
395  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
396  *
397  *     function _getImplementation() internal view returns (address) {
398  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
399  *     }
400  *
401  *     function _setImplementation(address newImplementation) internal {
402  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
403  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
404  *     }
405  * }
406  * ```
407  *
408  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
409  */
410 library StorageSlot {
411     struct AddressSlot {
412         address value;
413     }
414 
415     struct BooleanSlot {
416         bool value;
417     }
418 
419     struct Bytes32Slot {
420         bytes32 value;
421     }
422 
423     struct Uint256Slot {
424         uint256 value;
425     }
426 
427     /**
428      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
429      */
430     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
431         /// @solidity memory-safe-assembly
432         assembly {
433             r.slot := slot
434         }
435     }
436 
437     /**
438      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
439      */
440     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
441         /// @solidity memory-safe-assembly
442         assembly {
443             r.slot := slot
444         }
445     }
446 
447     /**
448      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
449      */
450     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
451         /// @solidity memory-safe-assembly
452         assembly {
453             r.slot := slot
454         }
455     }
456 
457     /**
458      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
459      */
460     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
461         /// @solidity memory-safe-assembly
462         assembly {
463             r.slot := slot
464         }
465     }
466 }
467 
468 /**
469  * @dev This abstract contract provides getters and event emitting update functions for
470  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
471  *
472  * _Available since v4.1._
473  *
474  * @custom:oz-upgrades-unsafe-allow delegatecall
475  */
476 abstract contract ERC1967Upgrade {
477     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
478     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
479 
480     /**
481      * @dev Storage slot with the address of the current implementation.
482      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
483      * validated in the constructor.
484      */
485     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
486 
487     /**
488      * @dev Emitted when the implementation is upgraded.
489      */
490     event Upgraded(address indexed implementation);
491 
492     /**
493      * @dev Returns the current implementation address.
494      */
495     function _getImplementation() internal view returns (address) {
496         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
497     }
498 
499     /**
500      * @dev Stores a new address in the EIP1967 implementation slot.
501      */
502     function _setImplementation(address newImplementation) private {
503         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
504         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
505     }
506 
507     /**
508      * @dev Perform implementation upgrade
509      *
510      * Emits an {Upgraded} event.
511      */
512     function _upgradeTo(address newImplementation) internal {
513         _setImplementation(newImplementation);
514         emit Upgraded(newImplementation);
515     }
516 
517     /**
518      * @dev Perform implementation upgrade with additional setup call.
519      *
520      * Emits an {Upgraded} event.
521      */
522     function _upgradeToAndCall(
523         address newImplementation,
524         bytes memory data,
525         bool forceCall
526     ) internal {
527         _upgradeTo(newImplementation);
528         if (data.length > 0 || forceCall) {
529             Address.functionDelegateCall(newImplementation, data);
530         }
531     }
532 
533     /**
534      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
535      *
536      * Emits an {Upgraded} event.
537      */
538     function _upgradeToAndCallUUPS(
539         address newImplementation,
540         bytes memory data,
541         bool forceCall
542     ) internal {
543         // Upgrades from old implementations will perform a rollback test. This test requires the new
544         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
545         // this special case will break upgrade paths from old UUPS implementation to new ones.
546         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
547             _setImplementation(newImplementation);
548         } else {
549             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
550                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
551             } catch {
552                 revert("ERC1967Upgrade: new implementation is not UUPS");
553             }
554             _upgradeToAndCall(newImplementation, data, forceCall);
555         }
556     }
557 
558     /**
559      * @dev Storage slot with the admin of the contract.
560      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
561      * validated in the constructor.
562      */
563     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
564 
565     /**
566      * @dev Emitted when the admin account has changed.
567      */
568     event AdminChanged(address previousAdmin, address newAdmin);
569 
570     /**
571      * @dev Returns the current admin.
572      */
573     function _getAdmin() internal view returns (address) {
574         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
575     }
576 
577     /**
578      * @dev Stores a new address in the EIP1967 admin slot.
579      */
580     function _setAdmin(address newAdmin) private {
581         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
582         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
583     }
584 
585     /**
586      * @dev Changes the admin of the proxy.
587      *
588      * Emits an {AdminChanged} event.
589      */
590     function _changeAdmin(address newAdmin) internal {
591         emit AdminChanged(_getAdmin(), newAdmin);
592         _setAdmin(newAdmin);
593     }
594 
595     /**
596      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
597      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
598      */
599     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
600 
601     /**
602      * @dev Emitted when the beacon is upgraded.
603      */
604     event BeaconUpgraded(address indexed beacon);
605 
606     /**
607      * @dev Returns the current beacon.
608      */
609     function _getBeacon() internal view returns (address) {
610         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
611     }
612 
613     /**
614      * @dev Stores a new beacon in the EIP1967 beacon slot.
615      */
616     function _setBeacon(address newBeacon) private {
617         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
618         require(
619             Address.isContract(IBeacon(newBeacon).implementation()),
620             "ERC1967: beacon implementation is not a contract"
621         );
622         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
623     }
624 
625     /**
626      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
627      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
628      *
629      * Emits a {BeaconUpgraded} event.
630      */
631     function _upgradeBeaconToAndCall(
632         address newBeacon,
633         bytes memory data,
634         bool forceCall
635     ) internal {
636         _setBeacon(newBeacon);
637         emit BeaconUpgraded(newBeacon);
638         if (data.length > 0 || forceCall) {
639             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
640         }
641     }
642 }
643 
644 /**
645  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
646  * implementation address that can be changed. This address is stored in storage in the location specified by
647  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
648  * implementation behind the proxy.
649  */
650 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
651     /**
652      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
653      *
654      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
655      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
656      */
657     constructor(address _logic, bytes memory _data) payable {
658         _upgradeToAndCall(_logic, _data, false);
659     }
660 
661     /**
662      * @dev Returns the current implementation address.
663      */
664     function _implementation() internal view virtual override returns (address impl) {
665         return ERC1967Upgrade._getImplementation();
666     }
667 }
668 
669 /*//////////////////////////////////////////////////////////////////////////
670                             TLCoreCreator
671 //////////////////////////////////////////////////////////////////////////*/
672 
673 contract TLCreator is ERC1967Proxy {
674 
675     /// @param name: the name of the contract
676     /// @param symbol: the symbol of the contract
677     /// @param defaultRoyaltyRecipient: the default address for royalty payments
678     /// @param defaultRoyaltyPercentage: the default royalty percentage of basis points (out of 10,000)
679     /// @param initOwner: initial owner of the contract
680     /// @param admins: array of admin addresses to add to the contract
681     /// @param enableStory: a bool deciding whether to add story fuctionality or not
682     /// @param blockListRegistry: address of the blocklist registry to use
683     constructor(
684         address implementation,
685         string memory name,
686         string memory symbol,
687         address defaultRoyaltyRecipient,
688         uint256 defaultRoyaltyPercentage,
689         address initOwner,
690         address[] memory admins,
691         bool enableStory,
692         address blockListRegistry
693     )
694         ERC1967Proxy(
695             implementation,
696             abi.encodeWithSelector(
697                 0x1fbd2402, // selector for "initialize(string,string,address,uint256,address,address[],bool,address)"
698                 name,
699                 symbol,
700                 defaultRoyaltyRecipient,
701                 defaultRoyaltyPercentage,
702                 initOwner,
703                 admins,
704                 enableStory,
705                 blockListRegistry
706             )
707         )
708     {}
709 }
710 
711 contract E30DbyGLitchGallery is TLCreator {
712 
713     constructor(
714         string memory name,
715         string memory symbol,
716         address defaultRoyaltyRecipient,
717         uint256 defaultRoyaltyPercentage,
718         address initOwner,
719         address[] memory admins,
720         bool enableStory,
721         address blockListRegistry
722     ) TLCreator(
723         0xe6de8cCFE609aef6de78DC6C9F409C6762f58EC5,
724         name,
725         symbol,
726         defaultRoyaltyRecipient,
727         defaultRoyaltyPercentage,
728         initOwner,
729         admins,
730         enableStory,
731         blockListRegistry
732     ) {}
733 }
