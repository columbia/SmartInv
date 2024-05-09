1 // File: @openzeppelin/contracts/utils/StorageSlot.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Library for reading and writing primitive types to specific storage slots.
10  *
11  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
12  * This library helps with reading and writing to such slots without the need for inline assembly.
13  *
14  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
15  *
16  * Example usage to set ERC1967 implementation slot:
17  * ```
18  * contract ERC1967 {
19  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
20  *
21  *     function _getImplementation() internal view returns (address) {
22  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
23  *     }
24  *
25  *     function _setImplementation(address newImplementation) internal {
26  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
27  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
28  *     }
29  * }
30  * ```
31  *
32  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
33  */
34 library StorageSlot {
35     struct AddressSlot {
36         address value;
37     }
38 
39     struct BooleanSlot {
40         bool value;
41     }
42 
43     struct Bytes32Slot {
44         bytes32 value;
45     }
46 
47     struct Uint256Slot {
48         uint256 value;
49     }
50 
51     /**
52      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
53      */
54     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
55         /// @solidity memory-safe-assembly
56         assembly {
57             r.slot := slot
58         }
59     }
60 
61     /**
62      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
63      */
64     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
65         /// @solidity memory-safe-assembly
66         assembly {
67             r.slot := slot
68         }
69     }
70 
71     /**
72      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
73      */
74     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
75         /// @solidity memory-safe-assembly
76         assembly {
77             r.slot := slot
78         }
79     }
80 
81     /**
82      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
83      */
84     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
85         /// @solidity memory-safe-assembly
86         assembly {
87             r.slot := slot
88         }
89     }
90 }
91 
92 // File: @openzeppelin/contracts/utils/Address.sol
93 
94 
95 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
96 
97 pragma solidity ^0.8.1;
98 
99 /**
100  * @dev Collection of functions related to the address type
101  */
102 library Address {
103     /**
104      * @dev Returns true if `account` is a contract.
105      *
106      * [IMPORTANT]
107      * ====
108      * It is unsafe to assume that an address for which this function returns
109      * false is an externally-owned account (EOA) and not a contract.
110      *
111      * Among others, `isContract` will return false for the following
112      * types of addresses:
113      *
114      *  - an externally-owned account
115      *  - a contract in construction
116      *  - an address where a contract will be created
117      *  - an address where a contract lived, but was destroyed
118      * ====
119      *
120      * [IMPORTANT]
121      * ====
122      * You shouldn't rely on `isContract` to protect against flash loan attacks!
123      *
124      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
125      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
126      * constructor.
127      * ====
128      */
129     function isContract(address account) internal view returns (bool) {
130         // This method relies on extcodesize/address.code.length, which returns 0
131         // for contracts in construction, since the code is only stored at the end
132         // of the constructor execution.
133 
134         return account.code.length > 0;
135     }
136 
137     /**
138      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
139      * `recipient`, forwarding all available gas and reverting on errors.
140      *
141      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
142      * of certain opcodes, possibly making contracts go over the 2300 gas limit
143      * imposed by `transfer`, making them unable to receive funds via
144      * `transfer`. {sendValue} removes this limitation.
145      *
146      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
147      *
148      * IMPORTANT: because control is transferred to `recipient`, care must be
149      * taken to not create reentrancy vulnerabilities. Consider using
150      * {ReentrancyGuard} or the
151      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
152      */
153     function sendValue(address payable recipient, uint256 amount) internal {
154         require(address(this).balance >= amount, "Address: insufficient balance");
155 
156         (bool success, ) = recipient.call{value: amount}("");
157         require(success, "Address: unable to send value, recipient may have reverted");
158     }
159 
160     /**
161      * @dev Performs a Solidity function call using a low level `call`. A
162      * plain `call` is an unsafe replacement for a function call: use this
163      * function instead.
164      *
165      * If `target` reverts with a revert reason, it is bubbled up by this
166      * function (like regular Solidity function calls).
167      *
168      * Returns the raw returned data. To convert to the expected return value,
169      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
170      *
171      * Requirements:
172      *
173      * - `target` must be a contract.
174      * - calling `target` with `data` must not revert.
175      *
176      * _Available since v3.1._
177      */
178     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
179         return functionCall(target, data, "Address: low-level call failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
184      * `errorMessage` as a fallback revert reason when `target` reverts.
185      *
186      * _Available since v3.1._
187      */
188     function functionCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         return functionCallWithValue(target, data, 0, errorMessage);
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
198      * but also transferring `value` wei to `target`.
199      *
200      * Requirements:
201      *
202      * - the calling contract must have an ETH balance of at least `value`.
203      * - the called Solidity function must be `payable`.
204      *
205      * _Available since v3.1._
206      */
207     function functionCallWithValue(
208         address target,
209         bytes memory data,
210         uint256 value
211     ) internal returns (bytes memory) {
212         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
217      * with `errorMessage` as a fallback revert reason when `target` reverts.
218      *
219      * _Available since v3.1._
220      */
221     function functionCallWithValue(
222         address target,
223         bytes memory data,
224         uint256 value,
225         string memory errorMessage
226     ) internal returns (bytes memory) {
227         require(address(this).balance >= value, "Address: insufficient balance for call");
228         require(isContract(target), "Address: call to non-contract");
229 
230         (bool success, bytes memory returndata) = target.call{value: value}(data);
231         return verifyCallResult(success, returndata, errorMessage);
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
236      * but performing a static call.
237      *
238      * _Available since v3.3._
239      */
240     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
241         return functionStaticCall(target, data, "Address: low-level static call failed");
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
246      * but performing a static call.
247      *
248      * _Available since v3.3._
249      */
250     function functionStaticCall(
251         address target,
252         bytes memory data,
253         string memory errorMessage
254     ) internal view returns (bytes memory) {
255         require(isContract(target), "Address: static call to non-contract");
256 
257         (bool success, bytes memory returndata) = target.staticcall(data);
258         return verifyCallResult(success, returndata, errorMessage);
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
263      * but performing a delegate call.
264      *
265      * _Available since v3.4._
266      */
267     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
268         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
273      * but performing a delegate call.
274      *
275      * _Available since v3.4._
276      */
277     function functionDelegateCall(
278         address target,
279         bytes memory data,
280         string memory errorMessage
281     ) internal returns (bytes memory) {
282         require(isContract(target), "Address: delegate call to non-contract");
283 
284         (bool success, bytes memory returndata) = target.delegatecall(data);
285         return verifyCallResult(success, returndata, errorMessage);
286     }
287 
288     /**
289      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
290      * revert reason using the provided one.
291      *
292      * _Available since v4.3._
293      */
294     function verifyCallResult(
295         bool success,
296         bytes memory returndata,
297         string memory errorMessage
298     ) internal pure returns (bytes memory) {
299         if (success) {
300             return returndata;
301         } else {
302             // Look for revert reason and bubble it up if present
303             if (returndata.length > 0) {
304                 // The easiest way to bubble the revert reason is using memory via assembly
305                 /// @solidity memory-safe-assembly
306                 assembly {
307                     let returndata_size := mload(returndata)
308                     revert(add(32, returndata), returndata_size)
309                 }
310             } else {
311                 revert(errorMessage);
312             }
313         }
314     }
315 }
316 
317 // File: @openzeppelin/contracts/interfaces/draft-IERC1822.sol
318 
319 
320 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
321 
322 pragma solidity ^0.8.0;
323 
324 /**
325  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
326  * proxy whose upgrades are fully controlled by the current implementation.
327  */
328 interface IERC1822Proxiable {
329     /**
330      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
331      * address.
332      *
333      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
334      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
335      * function revert if invoked through a proxy.
336      */
337     function proxiableUUID() external view returns (bytes32);
338 }
339 
340 // File: @openzeppelin/contracts/proxy/beacon/IBeacon.sol
341 
342 
343 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
344 
345 pragma solidity ^0.8.0;
346 
347 /**
348  * @dev This is the interface that {BeaconProxy} expects of its beacon.
349  */
350 interface IBeacon {
351     /**
352      * @dev Must return an address that can be used as a delegate call target.
353      *
354      * {BeaconProxy} will check that this address is a contract.
355      */
356     function implementation() external view returns (address);
357 }
358 
359 // File: @openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol
360 
361 
362 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
363 
364 pragma solidity ^0.8.2;
365 
366 
367 
368 
369 
370 /**
371  * @dev This abstract contract provides getters and event emitting update functions for
372  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
373  *
374  * _Available since v4.1._
375  *
376  * @custom:oz-upgrades-unsafe-allow delegatecall
377  */
378 abstract contract ERC1967Upgrade {
379     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
380     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
381 
382     /**
383      * @dev Storage slot with the address of the current implementation.
384      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
385      * validated in the constructor.
386      */
387     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
388 
389     /**
390      * @dev Emitted when the implementation is upgraded.
391      */
392     event Upgraded(address indexed implementation);
393 
394     /**
395      * @dev Returns the current implementation address.
396      */
397     function _getImplementation() internal view returns (address) {
398         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
399     }
400 
401     /**
402      * @dev Stores a new address in the EIP1967 implementation slot.
403      */
404     function _setImplementation(address newImplementation) private {
405         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
406         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
407     }
408 
409     /**
410      * @dev Perform implementation upgrade
411      *
412      * Emits an {Upgraded} event.
413      */
414     function _upgradeTo(address newImplementation) internal {
415         _setImplementation(newImplementation);
416         emit Upgraded(newImplementation);
417     }
418 
419     /**
420      * @dev Perform implementation upgrade with additional setup call.
421      *
422      * Emits an {Upgraded} event.
423      */
424     function _upgradeToAndCall(
425         address newImplementation,
426         bytes memory data,
427         bool forceCall
428     ) internal {
429         _upgradeTo(newImplementation);
430         if (data.length > 0 || forceCall) {
431             Address.functionDelegateCall(newImplementation, data);
432         }
433     }
434 
435     /**
436      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
437      *
438      * Emits an {Upgraded} event.
439      */
440     function _upgradeToAndCallUUPS(
441         address newImplementation,
442         bytes memory data,
443         bool forceCall
444     ) internal {
445         // Upgrades from old implementations will perform a rollback test. This test requires the new
446         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
447         // this special case will break upgrade paths from old UUPS implementation to new ones.
448         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
449             _setImplementation(newImplementation);
450         } else {
451             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
452                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
453             } catch {
454                 revert("ERC1967Upgrade: new implementation is not UUPS");
455             }
456             _upgradeToAndCall(newImplementation, data, forceCall);
457         }
458     }
459 
460     /**
461      * @dev Storage slot with the admin of the contract.
462      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
463      * validated in the constructor.
464      */
465     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
466 
467     /**
468      * @dev Emitted when the admin account has changed.
469      */
470     event AdminChanged(address previousAdmin, address newAdmin);
471 
472     /**
473      * @dev Returns the current admin.
474      */
475     function _getAdmin() internal view returns (address) {
476         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
477     }
478 
479     /**
480      * @dev Stores a new address in the EIP1967 admin slot.
481      */
482     function _setAdmin(address newAdmin) private {
483         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
484         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
485     }
486 
487     /**
488      * @dev Changes the admin of the proxy.
489      *
490      * Emits an {AdminChanged} event.
491      */
492     function _changeAdmin(address newAdmin) internal {
493         emit AdminChanged(_getAdmin(), newAdmin);
494         _setAdmin(newAdmin);
495     }
496 
497     /**
498      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
499      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
500      */
501     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
502 
503     /**
504      * @dev Emitted when the beacon is upgraded.
505      */
506     event BeaconUpgraded(address indexed beacon);
507 
508     /**
509      * @dev Returns the current beacon.
510      */
511     function _getBeacon() internal view returns (address) {
512         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
513     }
514 
515     /**
516      * @dev Stores a new beacon in the EIP1967 beacon slot.
517      */
518     function _setBeacon(address newBeacon) private {
519         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
520         require(
521             Address.isContract(IBeacon(newBeacon).implementation()),
522             "ERC1967: beacon implementation is not a contract"
523         );
524         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
525     }
526 
527     /**
528      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
529      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
530      *
531      * Emits a {BeaconUpgraded} event.
532      */
533     function _upgradeBeaconToAndCall(
534         address newBeacon,
535         bytes memory data,
536         bool forceCall
537     ) internal {
538         _setBeacon(newBeacon);
539         emit BeaconUpgraded(newBeacon);
540         if (data.length > 0 || forceCall) {
541             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
542         }
543     }
544 }
545 
546 // File: @openzeppelin/contracts/proxy/Proxy.sol
547 
548 
549 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 /**
554  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
555  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
556  * be specified by overriding the virtual {_implementation} function.
557  *
558  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
559  * different contract through the {_delegate} function.
560  *
561  * The success and return data of the delegated call will be returned back to the caller of the proxy.
562  */
563 abstract contract Proxy {
564     /**
565      * @dev Delegates the current call to `implementation`.
566      *
567      * This function does not return to its internal call site, it will return directly to the external caller.
568      */
569     function _delegate(address implementation) internal virtual {
570         assembly {
571             // Copy msg.data. We take full control of memory in this inline assembly
572             // block because it will not return to Solidity code. We overwrite the
573             // Solidity scratch pad at memory position 0.
574             calldatacopy(0, 0, calldatasize())
575 
576             // Call the implementation.
577             // out and outsize are 0 because we don't know the size yet.
578             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
579 
580             // Copy the returned data.
581             returndatacopy(0, 0, returndatasize())
582 
583             switch result
584             // delegatecall returns 0 on error.
585             case 0 {
586                 revert(0, returndatasize())
587             }
588             default {
589                 return(0, returndatasize())
590             }
591         }
592     }
593 
594     /**
595      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
596      * and {_fallback} should delegate.
597      */
598     function _implementation() internal view virtual returns (address);
599 
600     /**
601      * @dev Delegates the current call to the address returned by `_implementation()`.
602      *
603      * This function does not return to its internal call site, it will return directly to the external caller.
604      */
605     function _fallback() internal virtual {
606         _beforeFallback();
607         _delegate(_implementation());
608     }
609 
610     /**
611      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
612      * function in the contract matches the call data.
613      */
614     fallback() external payable virtual {
615         _fallback();
616     }
617 
618     /**
619      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
620      * is empty.
621      */
622     receive() external payable virtual {
623         _fallback();
624     }
625 
626     /**
627      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
628      * call, or as part of the Solidity `fallback` or `receive` functions.
629      *
630      * If overridden should call `super._beforeFallback()`.
631      */
632     function _beforeFallback() internal virtual {}
633 }
634 
635 // File: @openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol
636 
637 
638 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 
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
669 // File: default_workspace/TransparentUpgradeableProxy.sol
670 
671 
672 // OpenZeppelin Contracts v4.4.1 (proxy/transparent/TransparentUpgradeableProxy.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 
677 
678 contract TransparentUpgradeableProxy is ERC1967Proxy {
679     /**
680      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
681      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
682      */
683     constructor(
684         address _logic,
685         address admin_,
686         bytes memory _data //0x8129fc1c
687     ) payable ERC1967Proxy(_logic, _data) {
688         assert(
689             _ADMIN_SLOT ==
690                 bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1)
691         );
692         _changeAdmin(admin_);
693     }
694 
695     /**
696      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
697      */
698     modifier ifAdmin() {
699         if (msg.sender == _getAdmin()) {
700             _;
701         } else {
702             _fallback();
703         }
704     }
705 
706     /**
707      * @dev Returns the current admin.
708      *
709      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
710      *
711      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
712      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
713      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
714      */
715     function admin() external ifAdmin returns (address admin_) {
716         admin_ = _getAdmin();
717     }
718 
719     /**
720      * @dev Returns the current implementation.
721      *
722      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
723      *
724      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
725      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
726      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
727      */
728     function implementation()
729         external
730         ifAdmin
731         returns (address implementation_)
732     {
733         implementation_ = _implementation();
734     }
735 
736     /**
737      * @dev Changes the admin of the proxy.
738      *
739      * Emits an {AdminChanged} event.
740      *
741      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
742      */
743     function changeAdmin(address newAdmin) external virtual ifAdmin {
744         _changeAdmin(newAdmin);
745     }
746 
747     /**
748      * @dev Upgrade the implementation of the proxy.
749      *
750      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
751      */
752     function upgradeTo(address newImplementation) external ifAdmin {
753         _upgradeToAndCall(newImplementation, bytes(""), false);
754     }
755 
756     /**
757      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
758      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
759      * proxied contract.
760      *
761      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
762      */
763     function upgradeToAndCall(address newImplementation, bytes calldata data)
764         external
765         payable
766         ifAdmin
767     {
768         _upgradeToAndCall(newImplementation, data, true);
769     }
770 
771     /**
772      * @dev Returns the current admin.
773      */
774     function _admin() internal view virtual returns (address) {
775         return _getAdmin();
776     }
777 
778     /**
779      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
780      */
781     function _beforeFallback() internal virtual override {
782         require(
783             msg.sender != _getAdmin(),
784             "TransparentUpgradeableProxy: admin cannot fallback to proxy target"
785         );
786         super._beforeFallback();
787     }
788 }