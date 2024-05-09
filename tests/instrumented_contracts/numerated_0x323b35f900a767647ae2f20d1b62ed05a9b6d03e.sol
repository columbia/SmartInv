1 // File: @openzeppelin\contracts\proxy\Proxy.sol
2 
3 // SPDX-License-Identifier: MIT
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
90 // File: @openzeppelin\contracts\proxy\beacon\IBeacon.sol
91 
92 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
93 
94 pragma solidity ^0.8.0;
95 
96 /**
97  * @dev This is the interface that {BeaconProxy} expects of its beacon.
98  */
99 interface IBeacon {
100     /**
101      * @dev Must return an address that can be used as a delegate call target.
102      *
103      * {BeaconProxy} will check that this address is a contract.
104      */
105     function implementation() external view returns (address);
106 }
107 
108 // File: @openzeppelin\contracts\interfaces\draft-IERC1822.sol
109 
110 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
116  * proxy whose upgrades are fully controlled by the current implementation.
117  */
118 interface IERC1822Proxiable {
119     /**
120      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
121      * address.
122      *
123      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
124      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
125      * function revert if invoked through a proxy.
126      */
127     function proxiableUUID() external view returns (bytes32);
128 }
129 
130 // File: @openzeppelin\contracts\utils\Address.sol
131 
132 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
133 
134 pragma solidity ^0.8.1;
135 
136 /**
137  * @dev Collection of functions related to the address type
138  */
139 library Address {
140     /**
141      * @dev Returns true if `account` is a contract.
142      *
143      * [IMPORTANT]
144      * ====
145      * It is unsafe to assume that an address for which this function returns
146      * false is an externally-owned account (EOA) and not a contract.
147      *
148      * Among others, `isContract` will return false for the following
149      * types of addresses:
150      *
151      *  - an externally-owned account
152      *  - a contract in construction
153      *  - an address where a contract will be created
154      *  - an address where a contract lived, but was destroyed
155      * ====
156      *
157      * [IMPORTANT]
158      * ====
159      * You shouldn't rely on `isContract` to protect against flash loan attacks!
160      *
161      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
162      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
163      * constructor.
164      * ====
165      */
166     function isContract(address account) internal view returns (bool) {
167         // This method relies on extcodesize/address.code.length, which returns 0
168         // for contracts in construction, since the code is only stored at the end
169         // of the constructor execution.
170 
171         return account.code.length > 0;
172     }
173 
174     /**
175      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
176      * `recipient`, forwarding all available gas and reverting on errors.
177      *
178      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
179      * of certain opcodes, possibly making contracts go over the 2300 gas limit
180      * imposed by `transfer`, making them unable to receive funds via
181      * `transfer`. {sendValue} removes this limitation.
182      *
183      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
184      *
185      * IMPORTANT: because control is transferred to `recipient`, care must be
186      * taken to not create reentrancy vulnerabilities. Consider using
187      * {ReentrancyGuard} or the
188      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
189      */
190     function sendValue(address payable recipient, uint256 amount) internal {
191         require(address(this).balance >= amount, "Address: insufficient balance");
192 
193         (bool success, ) = recipient.call{value: amount}("");
194         require(success, "Address: unable to send value, recipient may have reverted");
195     }
196 
197     /**
198      * @dev Performs a Solidity function call using a low level `call`. A
199      * plain `call` is an unsafe replacement for a function call: use this
200      * function instead.
201      *
202      * If `target` reverts with a revert reason, it is bubbled up by this
203      * function (like regular Solidity function calls).
204      *
205      * Returns the raw returned data. To convert to the expected return value,
206      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
207      *
208      * Requirements:
209      *
210      * - `target` must be a contract.
211      * - calling `target` with `data` must not revert.
212      *
213      * _Available since v3.1._
214      */
215     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
216         return functionCall(target, data, "Address: low-level call failed");
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
221      * `errorMessage` as a fallback revert reason when `target` reverts.
222      *
223      * _Available since v3.1._
224      */
225     function functionCall(
226         address target,
227         bytes memory data,
228         string memory errorMessage
229     ) internal returns (bytes memory) {
230         return functionCallWithValue(target, data, 0, errorMessage);
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
235      * but also transferring `value` wei to `target`.
236      *
237      * Requirements:
238      *
239      * - the calling contract must have an ETH balance of at least `value`.
240      * - the called Solidity function must be `payable`.
241      *
242      * _Available since v3.1._
243      */
244     function functionCallWithValue(
245         address target,
246         bytes memory data,
247         uint256 value
248     ) internal returns (bytes memory) {
249         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
254      * with `errorMessage` as a fallback revert reason when `target` reverts.
255      *
256      * _Available since v3.1._
257      */
258     function functionCallWithValue(
259         address target,
260         bytes memory data,
261         uint256 value,
262         string memory errorMessage
263     ) internal returns (bytes memory) {
264         require(address(this).balance >= value, "Address: insufficient balance for call");
265         require(isContract(target), "Address: call to non-contract");
266 
267         (bool success, bytes memory returndata) = target.call{value: value}(data);
268         return verifyCallResult(success, returndata, errorMessage);
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
273      * but performing a static call.
274      *
275      * _Available since v3.3._
276      */
277     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
278         return functionStaticCall(target, data, "Address: low-level static call failed");
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
283      * but performing a static call.
284      *
285      * _Available since v3.3._
286      */
287     function functionStaticCall(
288         address target,
289         bytes memory data,
290         string memory errorMessage
291     ) internal view returns (bytes memory) {
292         require(isContract(target), "Address: static call to non-contract");
293 
294         (bool success, bytes memory returndata) = target.staticcall(data);
295         return verifyCallResult(success, returndata, errorMessage);
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
300      * but performing a delegate call.
301      *
302      * _Available since v3.4._
303      */
304     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
305         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
310      * but performing a delegate call.
311      *
312      * _Available since v3.4._
313      */
314     function functionDelegateCall(
315         address target,
316         bytes memory data,
317         string memory errorMessage
318     ) internal returns (bytes memory) {
319         require(isContract(target), "Address: delegate call to non-contract");
320 
321         (bool success, bytes memory returndata) = target.delegatecall(data);
322         return verifyCallResult(success, returndata, errorMessage);
323     }
324 
325     /**
326      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
327      * revert reason using the provided one.
328      *
329      * _Available since v4.3._
330      */
331     function verifyCallResult(
332         bool success,
333         bytes memory returndata,
334         string memory errorMessage
335     ) internal pure returns (bytes memory) {
336         if (success) {
337             return returndata;
338         } else {
339             // Look for revert reason and bubble it up if present
340             if (returndata.length > 0) {
341                 // The easiest way to bubble the revert reason is using memory via assembly
342                 /// @solidity memory-safe-assembly
343                 assembly {
344                     let returndata_size := mload(returndata)
345                     revert(add(32, returndata), returndata_size)
346                 }
347             } else {
348                 revert(errorMessage);
349             }
350         }
351     }
352 }
353 
354 // File: @openzeppelin\contracts\utils\StorageSlot.sol
355 
356 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 /**
361  * @dev Library for reading and writing primitive types to specific storage slots.
362  *
363  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
364  * This library helps with reading and writing to such slots without the need for inline assembly.
365  *
366  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
367  *
368  * Example usage to set ERC1967 implementation slot:
369  * ```
370  * contract ERC1967 {
371  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
372  *
373  *     function _getImplementation() internal view returns (address) {
374  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
375  *     }
376  *
377  *     function _setImplementation(address newImplementation) internal {
378  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
379  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
380  *     }
381  * }
382  * ```
383  *
384  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
385  */
386 library StorageSlot {
387     struct AddressSlot {
388         address value;
389     }
390 
391     struct BooleanSlot {
392         bool value;
393     }
394 
395     struct Bytes32Slot {
396         bytes32 value;
397     }
398 
399     struct Uint256Slot {
400         uint256 value;
401     }
402 
403     /**
404      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
405      */
406     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
407         /// @solidity memory-safe-assembly
408         assembly {
409             r.slot := slot
410         }
411     }
412 
413     /**
414      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
415      */
416     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
417         /// @solidity memory-safe-assembly
418         assembly {
419             r.slot := slot
420         }
421     }
422 
423     /**
424      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
425      */
426     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
427         /// @solidity memory-safe-assembly
428         assembly {
429             r.slot := slot
430         }
431     }
432 
433     /**
434      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
435      */
436     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
437         /// @solidity memory-safe-assembly
438         assembly {
439             r.slot := slot
440         }
441     }
442 }
443 
444 // File: @openzeppelin\contracts\proxy\ERC1967\ERC1967Upgrade.sol
445 
446 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
447 
448 pragma solidity ^0.8.2;
449 
450 
451 
452 
453 /**
454  * @dev This abstract contract provides getters and event emitting update functions for
455  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
456  *
457  * _Available since v4.1._
458  *
459  * @custom:oz-upgrades-unsafe-allow delegatecall
460  */
461 abstract contract ERC1967Upgrade {
462     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
463     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
464 
465     /**
466      * @dev Storage slot with the address of the current implementation.
467      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
468      * validated in the constructor.
469      */
470     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
471 
472     /**
473      * @dev Emitted when the implementation is upgraded.
474      */
475     event Upgraded(address indexed implementation);
476 
477     /**
478      * @dev Returns the current implementation address.
479      */
480     function _getImplementation() internal view returns (address) {
481         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
482     }
483 
484     /**
485      * @dev Stores a new address in the EIP1967 implementation slot.
486      */
487     function _setImplementation(address newImplementation) private {
488         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
489         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
490     }
491 
492     /**
493      * @dev Perform implementation upgrade
494      *
495      * Emits an {Upgraded} event.
496      */
497     function _upgradeTo(address newImplementation) internal {
498         _setImplementation(newImplementation);
499         emit Upgraded(newImplementation);
500     }
501 
502     /**
503      * @dev Perform implementation upgrade with additional setup call.
504      *
505      * Emits an {Upgraded} event.
506      */
507     function _upgradeToAndCall(
508         address newImplementation,
509         bytes memory data,
510         bool forceCall
511     ) internal {
512         _upgradeTo(newImplementation);
513         if (data.length > 0 || forceCall) {
514             Address.functionDelegateCall(newImplementation, data);
515         }
516     }
517 
518     /**
519      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
520      *
521      * Emits an {Upgraded} event.
522      */
523     function _upgradeToAndCallUUPS(
524         address newImplementation,
525         bytes memory data,
526         bool forceCall
527     ) internal {
528         // Upgrades from old implementations will perform a rollback test. This test requires the new
529         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
530         // this special case will break upgrade paths from old UUPS implementation to new ones.
531         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
532             _setImplementation(newImplementation);
533         } else {
534             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
535                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
536             } catch {
537                 revert("ERC1967Upgrade: new implementation is not UUPS");
538             }
539             _upgradeToAndCall(newImplementation, data, forceCall);
540         }
541     }
542 
543     /**
544      * @dev Storage slot with the admin of the contract.
545      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
546      * validated in the constructor.
547      */
548     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
549 
550     /**
551      * @dev Emitted when the admin account has changed.
552      */
553     event AdminChanged(address previousAdmin, address newAdmin);
554 
555     /**
556      * @dev Returns the current admin.
557      */
558     function _getAdmin() internal view returns (address) {
559         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
560     }
561 
562     /**
563      * @dev Stores a new address in the EIP1967 admin slot.
564      */
565     function _setAdmin(address newAdmin) private {
566         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
567         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
568     }
569 
570     /**
571      * @dev Changes the admin of the proxy.
572      *
573      * Emits an {AdminChanged} event.
574      */
575     function _changeAdmin(address newAdmin) internal {
576         emit AdminChanged(_getAdmin(), newAdmin);
577         _setAdmin(newAdmin);
578     }
579 
580     /**
581      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
582      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
583      */
584     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
585 
586     /**
587      * @dev Emitted when the beacon is upgraded.
588      */
589     event BeaconUpgraded(address indexed beacon);
590 
591     /**
592      * @dev Returns the current beacon.
593      */
594     function _getBeacon() internal view returns (address) {
595         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
596     }
597 
598     /**
599      * @dev Stores a new beacon in the EIP1967 beacon slot.
600      */
601     function _setBeacon(address newBeacon) private {
602         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
603         require(
604             Address.isContract(IBeacon(newBeacon).implementation()),
605             "ERC1967: beacon implementation is not a contract"
606         );
607         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
608     }
609 
610     /**
611      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
612      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
613      *
614      * Emits a {BeaconUpgraded} event.
615      */
616     function _upgradeBeaconToAndCall(
617         address newBeacon,
618         bytes memory data,
619         bool forceCall
620     ) internal {
621         _setBeacon(newBeacon);
622         emit BeaconUpgraded(newBeacon);
623         if (data.length > 0 || forceCall) {
624             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
625         }
626     }
627 }
628 
629 // File: @openzeppelin\contracts\proxy\ERC1967\ERC1967Proxy.sol
630 
631 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
632 
633 pragma solidity ^0.8.0;
634 
635 
636 /**
637  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
638  * implementation address that can be changed. This address is stored in storage in the location specified by
639  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
640  * implementation behind the proxy.
641  */
642 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
643     /**
644      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
645      *
646      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
647      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
648      */
649     constructor(address _logic, bytes memory _data) payable {
650         _upgradeToAndCall(_logic, _data, false);
651     }
652 
653     /**
654      * @dev Returns the current implementation address.
655      */
656     function _implementation() internal view virtual override returns (address impl) {
657         return ERC1967Upgrade._getImplementation();
658     }
659 }
660 
661 // File: contracts\proxy\TransparentUpgradeableProxy.sol
662 
663 // OpenZeppelin Contracts v4.4.1 (proxy/transparent/TransparentUpgradeableProxy.sol)
664 
665 pragma solidity ^0.8.2;
666 /**
667  * @dev This contract implements a proxy that is upgradeable by an admin.
668  *
669  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
670  * clashing], which can potentially be used in an attack, this contract uses the
671  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
672  * things that go hand in hand:
673  *
674  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
675  * that call matches one of the admin functions exposed by the proxy itself.
676  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
677  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
678  * "admin cannot fallback to proxy target".
679  *
680  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
681  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
682  * to sudden errors when trying to call a function from the proxy implementation.
683  *
684  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
685  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
686  */
687 contract TransparentUpgradeableProxy is ERC1967Proxy {
688     /**
689      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
690      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
691      */
692     constructor(
693         address _logic,
694         address admin_,
695         bytes memory _data
696     ) payable ERC1967Proxy(_logic, _data) {
697         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
698         _changeAdmin(admin_);
699     }
700 
701     /**
702      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
703      */
704     modifier ifAdmin() {
705         if (msg.sender == _getAdmin()) {
706             _;
707         } else {
708             _fallback();
709         }
710     }
711 
712     /**
713      * @dev Returns the current admin.
714      *
715      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
716      *
717      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
718      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
719      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
720      */
721     function admin() external ifAdmin returns (address admin_) {
722         admin_ = _getAdmin();
723     }
724 
725     /**
726      * @dev Returns the current implementation.
727      *
728      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
729      *
730      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
731      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
732      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
733      */
734     function implementation() external ifAdmin returns (address implementation_) {
735         implementation_ = _implementation();
736     }
737 
738     /**
739      * @dev Changes the admin of the proxy.
740      *
741      * Emits an {AdminChanged} event.
742      *
743      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
744      */
745     function changeAdmin(address newAdmin) external virtual ifAdmin {
746         emit AdminChanged(_getAdmin(), newAdmin);
747         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
748     }
749 
750     /**
751      * @dev Upgrade the implementation of the proxy.
752      *
753      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
754      */
755     function upgradeTo(address newImplementation) external ifAdmin {
756         _upgradeToAndCall(newImplementation, bytes(""), false);
757     }
758 
759     /**
760      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
761      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
762      * proxied contract.
763      *
764      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
765      */
766     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
767         _upgradeToAndCall(newImplementation, data, true);
768     }
769 
770     /**
771      * @dev Returns the current admin.
772      */
773     function _admin() internal view virtual returns (address) {
774         return _getAdmin();
775     }
776 
777     /**
778      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
779      */
780     function _beforeFallback() internal virtual override {
781         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
782         super._beforeFallback();
783     }
784 }