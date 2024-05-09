1 // SPDX-License-Identifier: MIT
2 // File: .deps/github/OpenZeppelin/openzeppelin-contracts/contracts/utils/StorageSlot.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Library for reading and writing primitive types to specific storage slots.
11  *
12  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
13  * This library helps with reading and writing to such slots without the need for inline assembly.
14  *
15  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
16  *
17  * Example usage to set ERC1967 implementation slot:
18  * ```
19  * contract ERC1967 {
20  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
21  *
22  *     function _getImplementation() internal view returns (address) {
23  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
24  *     }
25  *
26  *     function _setImplementation(address newImplementation) internal {
27  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
28  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
29  *     }
30  * }
31  * ```
32  *
33  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
34  */
35 library StorageSlot {
36     struct AddressSlot {
37         address value;
38     }
39 
40     struct BooleanSlot {
41         bool value;
42     }
43 
44     struct Bytes32Slot {
45         bytes32 value;
46     }
47 
48     struct Uint256Slot {
49         uint256 value;
50     }
51 
52     /**
53      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
54      */
55     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
56         /// @solidity memory-safe-assembly
57         assembly {
58             r.slot := slot
59         }
60     }
61 
62     /**
63      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
64      */
65     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
66         /// @solidity memory-safe-assembly
67         assembly {
68             r.slot := slot
69         }
70     }
71 
72     /**
73      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
74      */
75     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
76         /// @solidity memory-safe-assembly
77         assembly {
78             r.slot := slot
79         }
80     }
81 
82     /**
83      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
84      */
85     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
86         /// @solidity memory-safe-assembly
87         assembly {
88             r.slot := slot
89         }
90     }
91 }
92 
93 // File: .deps/github/OpenZeppelin/openzeppelin-contracts/contracts/utils/Address.sol
94 
95 
96 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
97 
98 pragma solidity ^0.8.1;
99 
100 /**
101  * @dev Collection of functions related to the address type
102  */
103 library Address {
104     /**
105      * @dev Returns true if `account` is a contract.
106      *
107      * [IMPORTANT]
108      * ====
109      * It is unsafe to assume that an address for which this function returns
110      * false is an externally-owned account (EOA) and not a contract.
111      *
112      * Among others, `isContract` will return false for the following
113      * types of addresses:
114      *
115      *  - an externally-owned account
116      *  - a contract in construction
117      *  - an address where a contract will be created
118      *  - an address where a contract lived, but was destroyed
119      * ====
120      *
121      * [IMPORTANT]
122      * ====
123      * You shouldn't rely on `isContract` to protect against flash loan attacks!
124      *
125      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
126      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
127      * constructor.
128      * ====
129      */
130     function isContract(address account) internal view returns (bool) {
131         // This method relies on extcodesize/address.code.length, which returns 0
132         // for contracts in construction, since the code is only stored at the end
133         // of the constructor execution.
134 
135         return account.code.length > 0;
136     }
137 
138     /**
139      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
140      * `recipient`, forwarding all available gas and reverting on errors.
141      *
142      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
143      * of certain opcodes, possibly making contracts go over the 2300 gas limit
144      * imposed by `transfer`, making them unable to receive funds via
145      * `transfer`. {sendValue} removes this limitation.
146      *
147      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
148      *
149      * IMPORTANT: because control is transferred to `recipient`, care must be
150      * taken to not create reentrancy vulnerabilities. Consider using
151      * {ReentrancyGuard} or the
152      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
153      */
154     function sendValue(address payable recipient, uint256 amount) internal {
155         require(address(this).balance >= amount, "Address: insufficient balance");
156 
157         (bool success, ) = recipient.call{value: amount}("");
158         require(success, "Address: unable to send value, recipient may have reverted");
159     }
160 
161     /**
162      * @dev Performs a Solidity function call using a low level `call`. A
163      * plain `call` is an unsafe replacement for a function call: use this
164      * function instead.
165      *
166      * If `target` reverts with a revert reason, it is bubbled up by this
167      * function (like regular Solidity function calls).
168      *
169      * Returns the raw returned data. To convert to the expected return value,
170      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
171      *
172      * Requirements:
173      *
174      * - `target` must be a contract.
175      * - calling `target` with `data` must not revert.
176      *
177      * _Available since v3.1._
178      */
179     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
185      * `errorMessage` as a fallback revert reason when `target` reverts.
186      *
187      * _Available since v3.1._
188      */
189     function functionCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         return functionCallWithValue(target, data, 0, errorMessage);
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
199      * but also transferring `value` wei to `target`.
200      *
201      * Requirements:
202      *
203      * - the calling contract must have an ETH balance of at least `value`.
204      * - the called Solidity function must be `payable`.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value
212     ) internal returns (bytes memory) {
213         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
218      * with `errorMessage` as a fallback revert reason when `target` reverts.
219      *
220      * _Available since v3.1._
221      */
222     function functionCallWithValue(
223         address target,
224         bytes memory data,
225         uint256 value,
226         string memory errorMessage
227     ) internal returns (bytes memory) {
228         require(address(this).balance >= value, "Address: insufficient balance for call");
229         (bool success, bytes memory returndata) = target.call{value: value}(data);
230         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
235      * but performing a static call.
236      *
237      * _Available since v3.3._
238      */
239     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
240         return functionStaticCall(target, data, "Address: low-level static call failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
245      * but performing a static call.
246      *
247      * _Available since v3.3._
248      */
249     function functionStaticCall(
250         address target,
251         bytes memory data,
252         string memory errorMessage
253     ) internal view returns (bytes memory) {
254         (bool success, bytes memory returndata) = target.staticcall(data);
255         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
265         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
270      * but performing a delegate call.
271      *
272      * _Available since v3.4._
273      */
274     function functionDelegateCall(
275         address target,
276         bytes memory data,
277         string memory errorMessage
278     ) internal returns (bytes memory) {
279         (bool success, bytes memory returndata) = target.delegatecall(data);
280         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
281     }
282 
283     /**
284      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
285      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
286      *
287      * _Available since v4.8._
288      */
289     function verifyCallResultFromTarget(
290         address target,
291         bool success,
292         bytes memory returndata,
293         string memory errorMessage
294     ) internal view returns (bytes memory) {
295         if (success) {
296             if (returndata.length == 0) {
297                 // only check isContract if the call was successful and the return data is empty
298                 // otherwise we already know that it was a contract
299                 require(isContract(target), "Address: call to non-contract");
300             }
301             return returndata;
302         } else {
303             _revert(returndata, errorMessage);
304         }
305     }
306 
307     /**
308      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
309      * revert reason or using the provided one.
310      *
311      * _Available since v4.3._
312      */
313     function verifyCallResult(
314         bool success,
315         bytes memory returndata,
316         string memory errorMessage
317     ) internal pure returns (bytes memory) {
318         if (success) {
319             return returndata;
320         } else {
321             _revert(returndata, errorMessage);
322         }
323     }
324 
325     function _revert(bytes memory returndata, string memory errorMessage) private pure {
326         // Look for revert reason and bubble it up if present
327         if (returndata.length > 0) {
328             // The easiest way to bubble the revert reason is using memory via assembly
329             /// @solidity memory-safe-assembly
330             assembly {
331                 let returndata_size := mload(returndata)
332                 revert(add(32, returndata), returndata_size)
333             }
334         } else {
335             revert(errorMessage);
336         }
337     }
338 }
339 
340 // File: .deps/github/OpenZeppelin/openzeppelin-contracts/contracts/interfaces/draft-IERC1822.sol
341 
342 
343 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
344 
345 pragma solidity ^0.8.0;
346 
347 /**
348  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
349  * proxy whose upgrades are fully controlled by the current implementation.
350  */
351 interface IERC1822Proxiable {
352     /**
353      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
354      * address.
355      *
356      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
357      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
358      * function revert if invoked through a proxy.
359      */
360     function proxiableUUID() external view returns (bytes32);
361 }
362 
363 // File: .deps/github/OpenZeppelin/openzeppelin-contracts/contracts/proxy/beacon/IBeacon.sol
364 
365 
366 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 /**
371  * @dev This is the interface that {BeaconProxy} expects of its beacon.
372  */
373 interface IBeacon {
374     /**
375      * @dev Must return an address that can be used as a delegate call target.
376      *
377      * {BeaconProxy} will check that this address is a contract.
378      */
379     function implementation() external view returns (address);
380 }
381 
382 // File: .deps/github/OpenZeppelin/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Upgrade.sol
383 
384 
385 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
386 
387 pragma solidity ^0.8.2;
388 
389 
390 
391 
392 
393 /**
394  * @dev This abstract contract provides getters and event emitting update functions for
395  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
396  *
397  * _Available since v4.1._
398  *
399  * @custom:oz-upgrades-unsafe-allow delegatecall
400  */
401 abstract contract ERC1967Upgrade {
402     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
403     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
404 
405     /**
406      * @dev Storage slot with the address of the current implementation.
407      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
408      * validated in the constructor.
409      */
410     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
411 
412     /**
413      * @dev Emitted when the implementation is upgraded.
414      */
415     event Upgraded(address indexed implementation);
416 
417     /**
418      * @dev Returns the current implementation address.
419      */
420     function _getImplementation() internal view returns (address) {
421         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
422     }
423 
424     /**
425      * @dev Stores a new address in the EIP1967 implementation slot.
426      */
427     function _setImplementation(address newImplementation) private {
428         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
429         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
430     }
431 
432     /**
433      * @dev Perform implementation upgrade
434      *
435      * Emits an {Upgraded} event.
436      */
437     function _upgradeTo(address newImplementation) internal {
438         _setImplementation(newImplementation);
439         emit Upgraded(newImplementation);
440     }
441 
442     /**
443      * @dev Perform implementation upgrade with additional setup call.
444      *
445      * Emits an {Upgraded} event.
446      */
447     function _upgradeToAndCall(
448         address newImplementation,
449         bytes memory data,
450         bool forceCall
451     ) internal {
452         _upgradeTo(newImplementation);
453         if (data.length > 0 || forceCall) {
454             Address.functionDelegateCall(newImplementation, data);
455         }
456     }
457 
458     /**
459      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
460      *
461      * Emits an {Upgraded} event.
462      */
463     function _upgradeToAndCallUUPS(
464         address newImplementation,
465         bytes memory data,
466         bool forceCall
467     ) internal {
468         // Upgrades from old implementations will perform a rollback test. This test requires the new
469         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
470         // this special case will break upgrade paths from old UUPS implementation to new ones.
471         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
472             _setImplementation(newImplementation);
473         } else {
474             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
475                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
476             } catch {
477                 revert("ERC1967Upgrade: new implementation is not UUPS");
478             }
479             _upgradeToAndCall(newImplementation, data, forceCall);
480         }
481     }
482 
483     /**
484      * @dev Storage slot with the admin of the contract.
485      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
486      * validated in the constructor.
487      */
488     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
489 
490     /**
491      * @dev Emitted when the admin account has changed.
492      */
493     event AdminChanged(address previousAdmin, address newAdmin);
494 
495     /**
496      * @dev Returns the current admin.
497      */
498     function _getAdmin() internal view returns (address) {
499         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
500     }
501 
502     /**
503      * @dev Stores a new address in the EIP1967 admin slot.
504      */
505     function _setAdmin(address newAdmin) private {
506         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
507         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
508     }
509 
510     /**
511      * @dev Changes the admin of the proxy.
512      *
513      * Emits an {AdminChanged} event.
514      */
515     function _changeAdmin(address newAdmin) internal {
516         emit AdminChanged(_getAdmin(), newAdmin);
517         _setAdmin(newAdmin);
518     }
519 
520     /**
521      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
522      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
523      */
524     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
525 
526     /**
527      * @dev Emitted when the beacon is upgraded.
528      */
529     event BeaconUpgraded(address indexed beacon);
530 
531     /**
532      * @dev Returns the current beacon.
533      */
534     function _getBeacon() internal view returns (address) {
535         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
536     }
537 
538     /**
539      * @dev Stores a new beacon in the EIP1967 beacon slot.
540      */
541     function _setBeacon(address newBeacon) private {
542         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
543         require(
544             Address.isContract(IBeacon(newBeacon).implementation()),
545             "ERC1967: beacon implementation is not a contract"
546         );
547         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
548     }
549 
550     /**
551      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
552      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
553      *
554      * Emits a {BeaconUpgraded} event.
555      */
556     function _upgradeBeaconToAndCall(
557         address newBeacon,
558         bytes memory data,
559         bool forceCall
560     ) internal {
561         _setBeacon(newBeacon);
562         emit BeaconUpgraded(newBeacon);
563         if (data.length > 0 || forceCall) {
564             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
565         }
566     }
567 }
568 
569 // File: .deps/github/OpenZeppelin/openzeppelin-contracts/contracts/proxy/Proxy.sol
570 
571 
572 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
573 
574 pragma solidity ^0.8.0;
575 
576 /**
577  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
578  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
579  * be specified by overriding the virtual {_implementation} function.
580  *
581  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
582  * different contract through the {_delegate} function.
583  *
584  * The success and return data of the delegated call will be returned back to the caller of the proxy.
585  */
586 abstract contract Proxy {
587     /**
588      * @dev Delegates the current call to `implementation`.
589      *
590      * This function does not return to its internal call site, it will return directly to the external caller.
591      */
592     function _delegate(address implementation) internal virtual {
593         assembly {
594             // Copy msg.data. We take full control of memory in this inline assembly
595             // block because it will not return to Solidity code. We overwrite the
596             // Solidity scratch pad at memory position 0.
597             calldatacopy(0, 0, calldatasize())
598 
599             // Call the implementation.
600             // out and outsize are 0 because we don't know the size yet.
601             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
602 
603             // Copy the returned data.
604             returndatacopy(0, 0, returndatasize())
605 
606             switch result
607             // delegatecall returns 0 on error.
608             case 0 {
609                 revert(0, returndatasize())
610             }
611             default {
612                 return(0, returndatasize())
613             }
614         }
615     }
616 
617     /**
618      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
619      * and {_fallback} should delegate.
620      */
621     function _implementation() internal view virtual returns (address);
622 
623     /**
624      * @dev Delegates the current call to the address returned by `_implementation()`.
625      *
626      * This function does not return to its internal call site, it will return directly to the external caller.
627      */
628     function _fallback() internal virtual {
629         _beforeFallback();
630         _delegate(_implementation());
631     }
632 
633     /**
634      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
635      * function in the contract matches the call data.
636      */
637     fallback() external payable virtual {
638         _fallback();
639     }
640 
641     /**
642      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
643      * is empty.
644      */
645     receive() external payable virtual {
646         _fallback();
647     }
648 
649     /**
650      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
651      * call, or as part of the Solidity `fallback` or `receive` functions.
652      *
653      * If overridden should call `super._beforeFallback()`.
654      */
655     function _beforeFallback() internal virtual {}
656 }
657 
658 // File: .deps/github/OpenZeppelin/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol
659 
660 
661 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
662 
663 pragma solidity ^0.8.0;
664 
665 
666 
667 /**
668  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
669  * implementation address that can be changed. This address is stored in storage in the location specified by
670  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
671  * implementation behind the proxy.
672  */
673 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
674     /**
675      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
676      *
677      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
678      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
679      */
680     constructor(address _logic, bytes memory _data) payable {
681         _upgradeToAndCall(_logic, _data, false);
682     }
683 
684     /**
685      * @dev Returns the current implementation address.
686      */
687     function _implementation() internal view virtual override returns (address impl) {
688         return ERC1967Upgrade._getImplementation();
689     }
690 }