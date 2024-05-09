1 // SPDX-License-Identifier: MIT
2 
3 // File @openzeppelin/contracts/interfaces/draft-IERC1822.sol@v4.8.1
4 // License-Identifier: MIT
5 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
11  * proxy whose upgrades are fully controlled by the current implementation.
12  */
13 interface IERC1822Proxiable {
14     /**
15      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
16      * address.
17      *
18      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
19      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
20      * function revert if invoked through a proxy.
21      */
22     function proxiableUUID() external view returns (bytes32);
23 }
24 
25 // File @openzeppelin/contracts/utils/Address.sol@v4.8.1
26 // License-Identifier: MIT
27 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
28 
29 pragma solidity ^0.8.1;
30 
31 /**
32  * @dev Collection of functions related to the address type
33  */
34 library Address {
35     /**
36      * @dev Returns true if `account` is a contract.
37      *
38      * [IMPORTANT]
39      * ====
40      * It is unsafe to assume that an address for which this function returns
41      * false is an externally-owned account (EOA) and not a contract.
42      *
43      * Among others, `isContract` will return false for the following
44      * types of addresses:
45      *
46      *  - an externally-owned account
47      *  - a contract in construction
48      *  - an address where a contract will be created
49      *  - an address where a contract lived, but was destroyed
50      * ====
51      *
52      * [IMPORTANT]
53      * ====
54      * You shouldn't rely on `isContract` to protect against flash loan attacks!
55      *
56      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
57      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
58      * constructor.
59      * ====
60      */
61     function isContract(address account) internal view returns (bool) {
62         // This method relies on extcodesize/address.code.length, which returns 0
63         // for contracts in construction, since the code is only stored at the end
64         // of the constructor execution.
65 
66         return account.code.length > 0;
67     }
68 
69     /**
70      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
71      * `recipient`, forwarding all available gas and reverting on errors.
72      *
73      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
74      * of certain opcodes, possibly making contracts go over the 2300 gas limit
75      * imposed by `transfer`, making them unable to receive funds via
76      * `transfer`. {sendValue} removes this limitation.
77      *
78      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
79      *
80      * IMPORTANT: because control is transferred to `recipient`, care must be
81      * taken to not create reentrancy vulnerabilities. Consider using
82      * {ReentrancyGuard} or the
83      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
84      */
85     function sendValue(address payable recipient, uint256 amount) internal {
86         require(address(this).balance >= amount, "Address: insufficient balance");
87 
88         (bool success, ) = recipient.call{value: amount}("");
89         require(success, "Address: unable to send value, recipient may have reverted");
90     }
91 
92     /**
93      * @dev Performs a Solidity function call using a low level `call`. A
94      * plain `call` is an unsafe replacement for a function call: use this
95      * function instead.
96      *
97      * If `target` reverts with a revert reason, it is bubbled up by this
98      * function (like regular Solidity function calls).
99      *
100      * Returns the raw returned data. To convert to the expected return value,
101      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
102      *
103      * Requirements:
104      *
105      * - `target` must be a contract.
106      * - calling `target` with `data` must not revert.
107      *
108      * _Available since v3.1._
109      */
110     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
111         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
112     }
113 
114     /**
115      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
116      * `errorMessage` as a fallback revert reason when `target` reverts.
117      *
118      * _Available since v3.1._
119      */
120     function functionCall(
121         address target,
122         bytes memory data,
123         string memory errorMessage
124     ) internal returns (bytes memory) {
125         return functionCallWithValue(target, data, 0, errorMessage);
126     }
127 
128     /**
129      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
130      * but also transferring `value` wei to `target`.
131      *
132      * Requirements:
133      *
134      * - the calling contract must have an ETH balance of at least `value`.
135      * - the called Solidity function must be `payable`.
136      *
137      * _Available since v3.1._
138      */
139     function functionCallWithValue(
140         address target,
141         bytes memory data,
142         uint256 value
143     ) internal returns (bytes memory) {
144         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
145     }
146 
147     /**
148      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
149      * with `errorMessage` as a fallback revert reason when `target` reverts.
150      *
151      * _Available since v3.1._
152      */
153     function functionCallWithValue(
154         address target,
155         bytes memory data,
156         uint256 value,
157         string memory errorMessage
158     ) internal returns (bytes memory) {
159         require(address(this).balance >= value, "Address: insufficient balance for call");
160         (bool success, bytes memory returndata) = target.call{value: value}(data);
161         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
166      * but performing a static call.
167      *
168      * _Available since v3.3._
169      */
170     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
171         return functionStaticCall(target, data, "Address: low-level static call failed");
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
176      * but performing a static call.
177      *
178      * _Available since v3.3._
179      */
180     function functionStaticCall(
181         address target,
182         bytes memory data,
183         string memory errorMessage
184     ) internal view returns (bytes memory) {
185         (bool success, bytes memory returndata) = target.staticcall(data);
186         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
191      * but performing a delegate call.
192      *
193      * _Available since v3.4._
194      */
195     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
196         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
201      * but performing a delegate call.
202      *
203      * _Available since v3.4._
204      */
205     function functionDelegateCall(
206         address target,
207         bytes memory data,
208         string memory errorMessage
209     ) internal returns (bytes memory) {
210         (bool success, bytes memory returndata) = target.delegatecall(data);
211         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
212     }
213 
214     /**
215      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
216      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
217      *
218      * _Available since v4.8._
219      */
220     function verifyCallResultFromTarget(
221         address target,
222         bool success,
223         bytes memory returndata,
224         string memory errorMessage
225     ) internal view returns (bytes memory) {
226         if (success) {
227             if (returndata.length == 0) {
228                 // only check isContract if the call was successful and the return data is empty
229                 // otherwise we already know that it was a contract
230                 require(isContract(target), "Address: call to non-contract");
231             }
232             return returndata;
233         } else {
234             _revert(returndata, errorMessage);
235         }
236     }
237 
238     /**
239      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
240      * revert reason or using the provided one.
241      *
242      * _Available since v4.3._
243      */
244     function verifyCallResult(
245         bool success,
246         bytes memory returndata,
247         string memory errorMessage
248     ) internal pure returns (bytes memory) {
249         if (success) {
250             return returndata;
251         } else {
252             _revert(returndata, errorMessage);
253         }
254     }
255 
256     function _revert(bytes memory returndata, string memory errorMessage) private pure {
257         // Look for revert reason and bubble it up if present
258         if (returndata.length > 0) {
259             // The easiest way to bubble the revert reason is using memory via assembly
260             /// @solidity memory-safe-assembly
261             assembly {
262                 let returndata_size := mload(returndata)
263                 revert(add(32, returndata), returndata_size)
264             }
265         } else {
266             revert(errorMessage);
267         }
268     }
269 }
270 
271 // File @openzeppelin/contracts/utils/StorageSlot.sol@v4.8.1
272 // License-Identifier: MIT
273 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
274 
275 pragma solidity ^0.8.0;
276 
277 /**
278  * @dev Library for reading and writing primitive types to specific storage slots.
279  *
280  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
281  * This library helps with reading and writing to such slots without the need for inline assembly.
282  *
283  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
284  *
285  * Example usage to set ERC1967 implementation slot:
286  * ```
287  * contract ERC1967 {
288  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
289  *
290  *     function _getImplementation() internal view returns (address) {
291  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
292  *     }
293  *
294  *     function _setImplementation(address newImplementation) internal {
295  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
296  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
297  *     }
298  * }
299  * ```
300  *
301  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
302  */
303 library StorageSlot {
304     struct AddressSlot {
305         address value;
306     }
307 
308     struct BooleanSlot {
309         bool value;
310     }
311 
312     struct Bytes32Slot {
313         bytes32 value;
314     }
315 
316     struct Uint256Slot {
317         uint256 value;
318     }
319 
320     /**
321      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
322      */
323     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
324         /// @solidity memory-safe-assembly
325         assembly {
326             r.slot := slot
327         }
328     }
329 
330     /**
331      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
332      */
333     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
334         /// @solidity memory-safe-assembly
335         assembly {
336             r.slot := slot
337         }
338     }
339 
340     /**
341      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
342      */
343     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
344         /// @solidity memory-safe-assembly
345         assembly {
346             r.slot := slot
347         }
348     }
349 
350     /**
351      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
352      */
353     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
354         /// @solidity memory-safe-assembly
355         assembly {
356             r.slot := slot
357         }
358     }
359 }
360 
361 // File @openzeppelin/contracts/proxy/beacon/IBeacon.sol@v4.8.1
362 // License-Identifier: MIT
363 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 /**
368  * @dev This is the interface that {BeaconProxy} expects of its beacon.
369  */
370 interface IBeacon {
371     /**
372      * @dev Must return an address that can be used as a delegate call target.
373      *
374      * {BeaconProxy} will check that this address is a contract.
375      */
376     function implementation() external view returns (address);
377 }
378 
379 // File @openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol@v4.8.1
380 // License-Identifier: MIT
381 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
382 
383 pragma solidity ^0.8.2;
384 
385 
386 
387 
388 /**
389  * @dev This abstract contract provides getters and event emitting update functions for
390  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
391  *
392  * _Available since v4.1._
393  *
394  * @custom:oz-upgrades-unsafe-allow delegatecall
395  */
396 abstract contract ERC1967Upgrade {
397     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
398     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
399 
400     /**
401      * @dev Storage slot with the address of the current implementation.
402      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
403      * validated in the constructor.
404      */
405     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
406 
407     /**
408      * @dev Emitted when the implementation is upgraded.
409      */
410     event Upgraded(address indexed implementation);
411 
412     /**
413      * @dev Returns the current implementation address.
414      */
415     function _getImplementation() internal view returns (address) {
416         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
417     }
418 
419     /**
420      * @dev Stores a new address in the EIP1967 implementation slot.
421      */
422     function _setImplementation(address newImplementation) private {
423         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
424         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
425     }
426 
427     /**
428      * @dev Perform implementation upgrade
429      *
430      * Emits an {Upgraded} event.
431      */
432     function _upgradeTo(address newImplementation) internal {
433         _setImplementation(newImplementation);
434         emit Upgraded(newImplementation);
435     }
436 
437     /**
438      * @dev Perform implementation upgrade with additional setup call.
439      *
440      * Emits an {Upgraded} event.
441      */
442     function _upgradeToAndCall(
443         address newImplementation,
444         bytes memory data,
445         bool forceCall
446     ) internal {
447         _upgradeTo(newImplementation);
448         if (data.length > 0 || forceCall) {
449             Address.functionDelegateCall(newImplementation, data);
450         }
451     }
452 
453     /**
454      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
455      *
456      * Emits an {Upgraded} event.
457      */
458     function _upgradeToAndCallUUPS(
459         address newImplementation,
460         bytes memory data,
461         bool forceCall
462     ) internal {
463         // Upgrades from old implementations will perform a rollback test. This test requires the new
464         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
465         // this special case will break upgrade paths from old UUPS implementation to new ones.
466         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
467             _setImplementation(newImplementation);
468         } else {
469             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
470                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
471             } catch {
472                 revert("ERC1967Upgrade: new implementation is not UUPS");
473             }
474             _upgradeToAndCall(newImplementation, data, forceCall);
475         }
476     }
477 
478     /**
479      * @dev Storage slot with the admin of the contract.
480      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
481      * validated in the constructor.
482      */
483     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
484 
485     /**
486      * @dev Emitted when the admin account has changed.
487      */
488     event AdminChanged(address previousAdmin, address newAdmin);
489 
490     /**
491      * @dev Returns the current admin.
492      */
493     function _getAdmin() internal view returns (address) {
494         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
495     }
496 
497     /**
498      * @dev Stores a new address in the EIP1967 admin slot.
499      */
500     function _setAdmin(address newAdmin) private {
501         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
502         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
503     }
504 
505     /**
506      * @dev Changes the admin of the proxy.
507      *
508      * Emits an {AdminChanged} event.
509      */
510     function _changeAdmin(address newAdmin) internal {
511         emit AdminChanged(_getAdmin(), newAdmin);
512         _setAdmin(newAdmin);
513     }
514 
515     /**
516      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
517      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
518      */
519     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
520 
521     /**
522      * @dev Emitted when the beacon is upgraded.
523      */
524     event BeaconUpgraded(address indexed beacon);
525 
526     /**
527      * @dev Returns the current beacon.
528      */
529     function _getBeacon() internal view returns (address) {
530         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
531     }
532 
533     /**
534      * @dev Stores a new beacon in the EIP1967 beacon slot.
535      */
536     function _setBeacon(address newBeacon) private {
537         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
538         require(
539             Address.isContract(IBeacon(newBeacon).implementation()),
540             "ERC1967: beacon implementation is not a contract"
541         );
542         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
543     }
544 
545     /**
546      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
547      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
548      *
549      * Emits a {BeaconUpgraded} event.
550      */
551     function _upgradeBeaconToAndCall(
552         address newBeacon,
553         bytes memory data,
554         bool forceCall
555     ) internal {
556         _setBeacon(newBeacon);
557         emit BeaconUpgraded(newBeacon);
558         if (data.length > 0 || forceCall) {
559             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
560         }
561     }
562 }
563 
564 // File @openzeppelin/contracts/proxy/Proxy.sol@v4.8.1
565 // License-Identifier: MIT
566 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
567 
568 pragma solidity ^0.8.0;
569 
570 /**
571  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
572  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
573  * be specified by overriding the virtual {_implementation} function.
574  *
575  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
576  * different contract through the {_delegate} function.
577  *
578  * The success and return data of the delegated call will be returned back to the caller of the proxy.
579  */
580 abstract contract Proxy {
581     /**
582      * @dev Delegates the current call to `implementation`.
583      *
584      * This function does not return to its internal call site, it will return directly to the external caller.
585      */
586     function _delegate(address implementation) internal virtual {
587         assembly {
588             // Copy msg.data. We take full control of memory in this inline assembly
589             // block because it will not return to Solidity code. We overwrite the
590             // Solidity scratch pad at memory position 0.
591             calldatacopy(0, 0, calldatasize())
592 
593             // Call the implementation.
594             // out and outsize are 0 because we don't know the size yet.
595             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
596 
597             // Copy the returned data.
598             returndatacopy(0, 0, returndatasize())
599 
600             switch result
601             // delegatecall returns 0 on error.
602             case 0 {
603                 revert(0, returndatasize())
604             }
605             default {
606                 return(0, returndatasize())
607             }
608         }
609     }
610 
611     /**
612      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
613      * and {_fallback} should delegate.
614      */
615     function _implementation() internal view virtual returns (address);
616 
617     /**
618      * @dev Delegates the current call to the address returned by `_implementation()`.
619      *
620      * This function does not return to its internal call site, it will return directly to the external caller.
621      */
622     function _fallback() internal virtual {
623         _beforeFallback();
624         _delegate(_implementation());
625     }
626 
627     /**
628      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
629      * function in the contract matches the call data.
630      */
631     fallback() external payable virtual {
632         _fallback();
633     }
634 
635     /**
636      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
637      * is empty.
638      */
639     receive() external payable virtual {
640         _fallback();
641     }
642 
643     /**
644      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
645      * call, or as part of the Solidity `fallback` or `receive` functions.
646      *
647      * If overridden should call `super._beforeFallback()`.
648      */
649     function _beforeFallback() internal virtual {}
650 }
651 
652 // File @openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol@v4.8.1
653 // License-Identifier: MIT
654 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
655 
656 pragma solidity ^0.8.0;
657 
658 
659 /**
660  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
661  * implementation address that can be changed. This address is stored in storage in the location specified by
662  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
663  * implementation behind the proxy.
664  */
665 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
666     /**
667      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
668      *
669      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
670      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
671      */
672     constructor(address _logic, bytes memory _data) payable {
673         _upgradeToAndCall(_logic, _data, false);
674     }
675 
676     /**
677      * @dev Returns the current implementation address.
678      */
679     function _implementation() internal view virtual override returns (address impl) {
680         return ERC1967Upgrade._getImplementation();
681     }
682 }
683 
684 // File @openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol@v4.8.1
685 // License-Identifier: MIT
686 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/transparent/TransparentUpgradeableProxy.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 /**
691  * @dev This contract implements a proxy that is upgradeable by an admin.
692  *
693  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
694  * clashing], which can potentially be used in an attack, this contract uses the
695  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
696  * things that go hand in hand:
697  *
698  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
699  * that call matches one of the admin functions exposed by the proxy itself.
700  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
701  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
702  * "admin cannot fallback to proxy target".
703  *
704  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
705  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
706  * to sudden errors when trying to call a function from the proxy implementation.
707  *
708  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
709  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
710  */
711 contract TransparentUpgradeableProxy is ERC1967Proxy {
712     /**
713      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
714      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
715      */
716     constructor(
717         address _logic,
718         address admin_,
719         bytes memory _data
720     ) payable ERC1967Proxy(_logic, _data) {
721         _changeAdmin(admin_);
722     }
723 
724     /**
725      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
726      */
727     modifier ifAdmin() {
728         if (msg.sender == _getAdmin()) {
729             _;
730         } else {
731             _fallback();
732         }
733     }
734 
735     /**
736      * @dev Returns the current admin.
737      *
738      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
739      *
740      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
741      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
742      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
743      */
744     function admin() external ifAdmin returns (address admin_) {
745         admin_ = _getAdmin();
746     }
747 
748     /**
749      * @dev Returns the current implementation.
750      *
751      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
752      *
753      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
754      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
755      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
756      */
757     function implementation() external ifAdmin returns (address implementation_) {
758         implementation_ = _implementation();
759     }
760 
761     /**
762      * @dev Changes the admin of the proxy.
763      *
764      * Emits an {AdminChanged} event.
765      *
766      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
767      */
768     function changeAdmin(address newAdmin) external virtual ifAdmin {
769         _changeAdmin(newAdmin);
770     }
771 
772     /**
773      * @dev Upgrade the implementation of the proxy.
774      *
775      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
776      */
777     function upgradeTo(address newImplementation) external ifAdmin {
778         _upgradeToAndCall(newImplementation, bytes(""), false);
779     }
780 
781     /**
782      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
783      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
784      * proxied contract.
785      *
786      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
787      */
788     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
789         _upgradeToAndCall(newImplementation, data, true);
790     }
791 
792     /**
793      * @dev Returns the current admin.
794      */
795     function _admin() internal view virtual returns (address) {
796         return _getAdmin();
797     }
798 
799     /**
800      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
801      */
802     function _beforeFallback() internal virtual override {
803         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
804         super._beforeFallback();
805     }
806 }
807 
808 // File contracts/Proxy.sol
809 // License-Identifier: MIT
810 
811 pragma solidity 0.8.17;