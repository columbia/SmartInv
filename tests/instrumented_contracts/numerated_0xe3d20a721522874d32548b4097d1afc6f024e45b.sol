1 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/StorageSlot.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Library for reading and writing primitive types to specific storage slots.
8  *
9  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
10  * This library helps with reading and writing to such slots without the need for inline assembly.
11  *
12  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
13  *
14  * Example usage to set ERC1967 implementation slot:
15  * ```
16  * contract ERC1967 {
17  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
18  *
19  *     function _getImplementation() internal view returns (address) {
20  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
21  *     }
22  *
23  *     function _setImplementation(address newImplementation) internal {
24  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
25  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
26  *     }
27  * }
28  * ```
29  *
30  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
31  */
32 library StorageSlot {
33     struct AddressSlot {
34         address value;
35     }
36 
37     struct BooleanSlot {
38         bool value;
39     }
40 
41     struct Bytes32Slot {
42         bytes32 value;
43     }
44 
45     struct Uint256Slot {
46         uint256 value;
47     }
48 
49     /**
50      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
51      */
52     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
53         assembly {
54             r.slot := slot
55         }
56     }
57 
58     /**
59      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
60      */
61     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
62         assembly {
63             r.slot := slot
64         }
65     }
66 
67     /**
68      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
69      */
70     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
71         assembly {
72             r.slot := slot
73         }
74     }
75 
76     /**
77      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
78      */
79     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
80         assembly {
81             r.slot := slot
82         }
83     }
84 }
85 
86                 
87 
88          
89                 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
90 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
91 
92 pragma solidity ^0.8.1;
93 
94 /**
95  * @dev Collection of functions related to the address type
96  */
97 library Address {
98     /**
99      * @dev Returns true if `account` is a contract.
100      *
101      * [////IMPORTANT]
102      * ====
103      * It is unsafe to assume that an address for which this function returns
104      * false is an externally-owned account (EOA) and not a contract.
105      *
106      * Among others, `isContract` will return false for the following
107      * types of addresses:
108      *
109      *  - an externally-owned account
110      *  - a contract in construction
111      *  - an address where a contract will be created
112      *  - an address where a contract lived, but was destroyed
113      * ====
114      *
115      * [IMPORTANT]
116      * ====
117      * You shouldn't rely on `isContract` to protect against flash loan attacks!
118      *
119      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
120      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
121      * constructor.
122      * ====
123      */
124     function isContract(address account) internal view returns (bool) {
125         // This method relies on extcodesize/address.code.length, which returns 0
126         // for contracts in construction, since the code is only stored at the end
127         // of the constructor execution.
128 
129         return account.code.length > 0;
130     }
131 
132     /**
133      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
134      * `recipient`, forwarding all available gas and reverting on errors.
135      *
136      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
137      * of certain opcodes, possibly making contracts go over the 2300 gas limit
138      * imposed by `transfer`, making them unable to receive funds via
139      * `transfer`. {sendValue} removes this limitation.
140      *
141      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
142      *
143      * ////IMPORTANT: because control is transferred to `recipient`, care must be
144      * taken to not create reentrancy vulnerabilities. Consider using
145      * {ReentrancyGuard} or the
146      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
147      */
148     function sendValue(address payable recipient, uint256 amount) internal {
149         require(address(this).balance >= amount, "Address: insufficient balance");
150 
151         (bool success, ) = recipient.call{value: amount}("");
152         require(success, "Address: unable to send value, recipient may have reverted");
153     }
154 
155     /**
156      * @dev Performs a Solidity function call using a low level `call`. A
157      * plain `call` is an unsafe replacement for a function call: use this
158      * function instead.
159      *
160      * If `target` reverts with a revert reason, it is bubbled up by this
161      * function (like regular Solidity function calls).
162      *
163      * Returns the raw returned data. To convert to the expected return value,
164      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
165      *
166      * Requirements:
167      *
168      * - `target` must be a contract.
169      * - calling `target` with `data` must not revert.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionCall(target, data, "Address: low-level call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
179      * `errorMessage` as a fallback revert reason when `target` reverts.
180      *
181      * _Available since v3.1._
182      */
183     function functionCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, 0, errorMessage);
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
193      * but also transferring `value` wei to `target`.
194      *
195      * Requirements:
196      *
197      * - the calling contract must have an ETH balance of at least `value`.
198      * - the called Solidity function must be `payable`.
199      *
200      * _Available since v3.1._
201      */
202     function functionCallWithValue(
203         address target,
204         bytes memory data,
205         uint256 value
206     ) internal returns (bytes memory) {
207         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
212      * with `errorMessage` as a fallback revert reason when `target` reverts.
213      *
214      * _Available since v3.1._
215      */
216     function functionCallWithValue(
217         address target,
218         bytes memory data,
219         uint256 value,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         require(address(this).balance >= value, "Address: insufficient balance for call");
223         require(isContract(target), "Address: call to non-contract");
224 
225         (bool success, bytes memory returndata) = target.call{value: value}(data);
226         return verifyCallResult(success, returndata, errorMessage);
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
231      * but performing a static call.
232      *
233      * _Available since v3.3._
234      */
235     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
236         return functionStaticCall(target, data, "Address: low-level static call failed");
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
241      * but performing a static call.
242      *
243      * _Available since v3.3._
244      */
245     function functionStaticCall(
246         address target,
247         bytes memory data,
248         string memory errorMessage
249     ) internal view returns (bytes memory) {
250         require(isContract(target), "Address: static call to non-contract");
251 
252         (bool success, bytes memory returndata) = target.staticcall(data);
253         return verifyCallResult(success, returndata, errorMessage);
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
258      * but performing a delegate call.
259      *
260      * _Available since v3.4._
261      */
262     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
263         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
268      * but performing a delegate call.
269      *
270      * _Available since v3.4._
271      */
272     function functionDelegateCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         require(isContract(target), "Address: delegate call to non-contract");
278 
279         (bool success, bytes memory returndata) = target.delegatecall(data);
280         return verifyCallResult(success, returndata, errorMessage);
281     }
282 
283     /**
284      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
285      * revert reason using the provided one.
286      *
287      * _Available since v4.3._
288      */
289     function verifyCallResult(
290         bool success,
291         bytes memory returndata,
292         string memory errorMessage
293     ) internal pure returns (bytes memory) {
294         if (success) {
295             return returndata;
296         } else {
297             // Look for revert reason and bubble it up if present
298             if (returndata.length > 0) {
299                 // The easiest way to bubble the revert reason is using memory via assembly
300 
301                 assembly {
302                     let returndata_size := mload(returndata)
303                     revert(add(32, returndata), returndata_size)
304                 }
305             } else {
306                 revert(errorMessage);
307             }
308         }
309     }
310 }
311 
312                 
313 
314          
315                 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
316 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
317 
318 pragma solidity ^0.8.0;
319 
320 /**
321  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
322  * proxy whose upgrades are fully controlled by the current implementation.
323  */
324 interface IERC1822Proxiable {
325     /**
326      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
327      * address.
328      *
329      * ////IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
330      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
331      * function revert if invoked through a proxy.
332      */
333     function proxiableUUID() external view returns (bytes32);
334 }
335 
336                 
337 
338          
339                 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
340 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
341 
342 pragma solidity ^0.8.0;
343 
344 /**
345  * @dev This is the interface that {BeaconProxy} expects of its beacon.
346  */
347 interface IBeacon {
348     /**
349      * @dev Must return an address that can be used as a delegate call target.
350      *
351      * {BeaconProxy} will check that this address is a contract.
352      */
353     function implementation() external view returns (address);
354 }
355 
356                 
357 
358          
359                 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
360 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
361 
362 pragma solidity ^0.8.2;
363 
364 ////import "../beacon/IBeacon.sol";
365 ////import "../../interfaces/draft-IERC1822.sol";
366 ////import "../../utils/Address.sol";
367 ////import "../../utils/StorageSlot.sol";
368 
369 /**
370  * @dev This abstract contract provides getters and event emitting update functions for
371  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
372  *
373  * _Available since v4.1._
374  *
375  * @custom:oz-upgrades-unsafe-allow delegatecall
376  */
377 abstract contract ERC1967Upgrade {
378     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
379     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
380 
381     /**
382      * @dev Storage slot with the address of the current implementation.
383      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
384      * validated in the constructor.
385      */
386     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
387 
388     /**
389      * @dev Emitted when the implementation is upgraded.
390      */
391     event Upgraded(address indexed implementation);
392 
393     /**
394      * @dev Returns the current implementation address.
395      */
396     function _getImplementation() internal view returns (address) {
397         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
398     }
399 
400     /**
401      * @dev Stores a new address in the EIP1967 implementation slot.
402      */
403     function _setImplementation(address newImplementation) private {
404         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
405         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
406     }
407 
408     /**
409      * @dev Perform implementation upgrade
410      *
411      * Emits an {Upgraded} event.
412      */
413     function _upgradeTo(address newImplementation) internal {
414         _setImplementation(newImplementation);
415         emit Upgraded(newImplementation);
416     }
417 
418     /**
419      * @dev Perform implementation upgrade with additional setup call.
420      *
421      * Emits an {Upgraded} event.
422      */
423     function _upgradeToAndCall(
424         address newImplementation,
425         bytes memory data,
426         bool forceCall
427     ) internal {
428         _upgradeTo(newImplementation);
429         if (data.length > 0 || forceCall) {
430             Address.functionDelegateCall(newImplementation, data);
431         }
432     }
433 
434     /**
435      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
436      *
437      * Emits an {Upgraded} event.
438      */
439     function _upgradeToAndCallUUPS(
440         address newImplementation,
441         bytes memory data,
442         bool forceCall
443     ) internal {
444         // Upgrades from old implementations will perform a rollback test. This test requires the new
445         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
446         // this special case will break upgrade paths from old UUPS implementation to new ones.
447         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
448             _setImplementation(newImplementation);
449         } else {
450             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
451                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
452             } catch {
453                 revert("ERC1967Upgrade: new implementation is not UUPS");
454             }
455             _upgradeToAndCall(newImplementation, data, forceCall);
456         }
457     }
458 
459     /**
460      * @dev Storage slot with the admin of the contract.
461      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
462      * validated in the constructor.
463      */
464     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
465 
466     /**
467      * @dev Emitted when the admin account has changed.
468      */
469     event AdminChanged(address previousAdmin, address newAdmin);
470 
471     /**
472      * @dev Returns the current admin.
473      */
474     function _getAdmin() internal view returns (address) {
475         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
476     }
477 
478     /**
479      * @dev Stores a new address in the EIP1967 admin slot.
480      */
481     function _setAdmin(address newAdmin) private {
482         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
483         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
484     }
485 
486     /**
487      * @dev Changes the admin of the proxy.
488      *
489      * Emits an {AdminChanged} event.
490      */
491     function _changeAdmin(address newAdmin) internal {
492         emit AdminChanged(_getAdmin(), newAdmin);
493         _setAdmin(newAdmin);
494     }
495 
496     /**
497      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
498      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
499      */
500     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
501 
502     /**
503      * @dev Emitted when the beacon is upgraded.
504      */
505     event BeaconUpgraded(address indexed beacon);
506 
507     /**
508      * @dev Returns the current beacon.
509      */
510     function _getBeacon() internal view returns (address) {
511         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
512     }
513 
514     /**
515      * @dev Stores a new beacon in the EIP1967 beacon slot.
516      */
517     function _setBeacon(address newBeacon) private {
518         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
519         require(
520             Address.isContract(IBeacon(newBeacon).implementation()),
521             "ERC1967: beacon implementation is not a contract"
522         );
523         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
524     }
525 
526     /**
527      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
528      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
529      *
530      * Emits a {BeaconUpgraded} event.
531      */
532     function _upgradeBeaconToAndCall(
533         address newBeacon,
534         bytes memory data,
535         bool forceCall
536     ) internal {
537         _setBeacon(newBeacon);
538         emit BeaconUpgraded(newBeacon);
539         if (data.length > 0 || forceCall) {
540             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
541         }
542     }
543 }
544 
545                 
546 
547          
548                 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
549 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/Proxy.sol)
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
595      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
596      * and {_fallback} should delegate.
597      */
598     function _implementation() internal view virtual returns (address);
599 
600     /**
601      * @dev Delegates the current call to the address returned by `_implementation()`.
602      *
603      * This function does not return to its internall call site, it will return directly to the external caller.
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
630      * If overriden should call `super._beforeFallback()`.
631      */
632     function _beforeFallback() internal virtual {}
633 }
634 
635                 
636                 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
637 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/BeaconProxy.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 ////import "./IBeacon.sol";
642 ////import "../Proxy.sol";
643 ////import "../ERC1967/ERC1967Upgrade.sol";
644 
645 /**
646  * @dev This contract implements a proxy that gets the implementation address for each call from a {UpgradeableBeacon}.
647  *
648  * The beacon address is stored in storage slot `uint256(keccak256('eip1967.proxy.beacon')) - 1`, so that it doesn't
649  * conflict with the storage layout of the implementation behind the proxy.
650  *
651  * _Available since v3.4._
652  */
653 contract BeaconProxy is Proxy, ERC1967Upgrade {
654     /**
655      * @dev Initializes the proxy with `beacon`.
656      *
657      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon. This
658      * will typically be an encoded function call, and allows initializating the storage of the proxy like a Solidity
659      * constructor.
660      *
661      * Requirements:
662      *
663      * - `beacon` must be a contract with the interface {IBeacon}.
664      */
665     constructor(address beacon, bytes memory data) payable {
666         assert(_BEACON_SLOT == bytes32(uint256(keccak256("eip1967.proxy.beacon")) - 1));
667         _upgradeBeaconToAndCall(beacon, data, false);
668     }
669 
670     /**
671      * @dev Returns the current beacon address.
672      */
673     function _beacon() internal view virtual returns (address) {
674         return _getBeacon();
675     }
676 
677     /**
678      * @dev Returns the current implementation address of the associated beacon.
679      */
680     function _implementation() internal view virtual override returns (address) {
681         return IBeacon(_getBeacon()).implementation();
682     }
683 
684     /**
685      * @dev Changes the proxy to use a new beacon. Deprecated: see {_upgradeBeaconToAndCall}.
686      *
687      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon.
688      *
689      * Requirements:
690      *
691      * - `beacon` must be a contract.
692      * - The implementation returned by `beacon` must be a contract.
693      */
694     function _setBeacon(address beacon, bytes memory data) internal virtual {
695         _upgradeBeaconToAndCall(beacon, data, false);
696     }
697 }