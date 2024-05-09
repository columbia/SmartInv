1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
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
90 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
91 
92 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
93 
94 /**
95  * @dev This is the interface that {BeaconProxy} expects of its beacon.
96  */
97 interface IBeacon {
98     /**
99      * @dev Must return an address that can be used as a delegate call target.
100      *
101      * {BeaconProxy} will check that this address is a contract.
102      */
103     function implementation() external view returns (address);
104 }
105 
106 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
107 
108 /**
109  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
110  * proxy whose upgrades are fully controlled by the current implementation.
111  */
112 interface IERC1822Proxiable {
113     /**
114      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
115      * address.
116      *
117      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
118      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
119      * function revert if invoked through a proxy.
120      */
121     function proxiableUUID() external view returns (bytes32);
122 }
123 
124 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
125 
126 /**
127  * @dev Collection of functions related to the address type
128  */
129 library Address {
130     /**
131      * @dev Returns true if `account` is a contract.
132      *
133      * [IMPORTANT]
134      * ====
135      * It is unsafe to assume that an address for which this function returns
136      * false is an externally-owned account (EOA) and not a contract.
137      *
138      * Among others, `isContract` will return false for the following
139      * types of addresses:
140      *
141      *  - an externally-owned account
142      *  - a contract in construction
143      *  - an address where a contract will be created
144      *  - an address where a contract lived, but was destroyed
145      * ====
146      *
147      * [IMPORTANT]
148      * ====
149      * You shouldn't rely on `isContract` to protect against flash loan attacks!
150      *
151      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
152      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
153      * constructor.
154      * ====
155      */
156     function isContract(address account) internal view returns (bool) {
157         // This method relies on extcodesize/address.code.length, which returns 0
158         // for contracts in construction, since the code is only stored at the end
159         // of the constructor execution.
160 
161         return account.code.length > 0;
162     }
163 
164     /**
165      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
166      * `recipient`, forwarding all available gas and reverting on errors.
167      *
168      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
169      * of certain opcodes, possibly making contracts go over the 2300 gas limit
170      * imposed by `transfer`, making them unable to receive funds via
171      * `transfer`. {sendValue} removes this limitation.
172      *
173      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
174      *
175      * IMPORTANT: because control is transferred to `recipient`, care must be
176      * taken to not create reentrancy vulnerabilities. Consider using
177      * {ReentrancyGuard} or the
178      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
179      */
180     function sendValue(address payable recipient, uint256 amount) internal {
181         require(address(this).balance >= amount, "Address: insufficient balance");
182 
183         (bool success, ) = recipient.call{value: amount}("");
184         require(success, "Address: unable to send value, recipient may have reverted");
185     }
186 
187     /**
188      * @dev Performs a Solidity function call using a low level `call`. A
189      * plain `call` is an unsafe replacement for a function call: use this
190      * function instead.
191      *
192      * If `target` reverts with a revert reason, it is bubbled up by this
193      * function (like regular Solidity function calls).
194      *
195      * Returns the raw returned data. To convert to the expected return value,
196      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
197      *
198      * Requirements:
199      *
200      * - `target` must be a contract.
201      * - calling `target` with `data` must not revert.
202      *
203      * _Available since v3.1._
204      */
205     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
206         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
211      * `errorMessage` as a fallback revert reason when `target` reverts.
212      *
213      * _Available since v3.1._
214      */
215     function functionCall(
216         address target,
217         bytes memory data,
218         string memory errorMessage
219     ) internal returns (bytes memory) {
220         return functionCallWithValue(target, data, 0, errorMessage);
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
225      * but also transferring `value` wei to `target`.
226      *
227      * Requirements:
228      *
229      * - the calling contract must have an ETH balance of at least `value`.
230      * - the called Solidity function must be `payable`.
231      *
232      * _Available since v3.1._
233      */
234     function functionCallWithValue(
235         address target,
236         bytes memory data,
237         uint256 value
238     ) internal returns (bytes memory) {
239         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
244      * with `errorMessage` as a fallback revert reason when `target` reverts.
245      *
246      * _Available since v3.1._
247      */
248     function functionCallWithValue(
249         address target,
250         bytes memory data,
251         uint256 value,
252         string memory errorMessage
253     ) internal returns (bytes memory) {
254         require(address(this).balance >= value, "Address: insufficient balance for call");
255         (bool success, bytes memory returndata) = target.call{value: value}(data);
256         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
261      * but performing a static call.
262      *
263      * _Available since v3.3._
264      */
265     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
266         return functionStaticCall(target, data, "Address: low-level static call failed");
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
271      * but performing a static call.
272      *
273      * _Available since v3.3._
274      */
275     function functionStaticCall(
276         address target,
277         bytes memory data,
278         string memory errorMessage
279     ) internal view returns (bytes memory) {
280         (bool success, bytes memory returndata) = target.staticcall(data);
281         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
286      * but performing a delegate call.
287      *
288      * _Available since v3.4._
289      */
290     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
291         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
296      * but performing a delegate call.
297      *
298      * _Available since v3.4._
299      */
300     function functionDelegateCall(
301         address target,
302         bytes memory data,
303         string memory errorMessage
304     ) internal returns (bytes memory) {
305         (bool success, bytes memory returndata) = target.delegatecall(data);
306         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
307     }
308 
309     /**
310      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
311      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
312      *
313      * _Available since v4.8._
314      */
315     function verifyCallResultFromTarget(
316         address target,
317         bool success,
318         bytes memory returndata,
319         string memory errorMessage
320     ) internal view returns (bytes memory) {
321         if (success) {
322             if (returndata.length == 0) {
323                 // only check isContract if the call was successful and the return data is empty
324                 // otherwise we already know that it was a contract
325                 require(isContract(target), "Address: call to non-contract");
326             }
327             return returndata;
328         } else {
329             _revert(returndata, errorMessage);
330         }
331     }
332 
333     /**
334      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
335      * revert reason or using the provided one.
336      *
337      * _Available since v4.3._
338      */
339     function verifyCallResult(
340         bool success,
341         bytes memory returndata,
342         string memory errorMessage
343     ) internal pure returns (bytes memory) {
344         if (success) {
345             return returndata;
346         } else {
347             _revert(returndata, errorMessage);
348         }
349     }
350 
351     function _revert(bytes memory returndata, string memory errorMessage) private pure {
352         // Look for revert reason and bubble it up if present
353         if (returndata.length > 0) {
354             // The easiest way to bubble the revert reason is using memory via assembly
355             /// @solidity memory-safe-assembly
356             assembly {
357                 let returndata_size := mload(returndata)
358                 revert(add(32, returndata), returndata_size)
359             }
360         } else {
361             revert(errorMessage);
362         }
363     }
364 }
365 
366 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
367 
368 /**
369  * @dev Library for reading and writing primitive types to specific storage slots.
370  *
371  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
372  * This library helps with reading and writing to such slots without the need for inline assembly.
373  *
374  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
375  *
376  * Example usage to set ERC1967 implementation slot:
377  * ```
378  * contract ERC1967 {
379  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
380  *
381  *     function _getImplementation() internal view returns (address) {
382  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
383  *     }
384  *
385  *     function _setImplementation(address newImplementation) internal {
386  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
387  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
388  *     }
389  * }
390  * ```
391  *
392  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
393  */
394 library StorageSlot {
395     struct AddressSlot {
396         address value;
397     }
398 
399     struct BooleanSlot {
400         bool value;
401     }
402 
403     struct Bytes32Slot {
404         bytes32 value;
405     }
406 
407     struct Uint256Slot {
408         uint256 value;
409     }
410 
411     /**
412      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
413      */
414     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
415         /// @solidity memory-safe-assembly
416         assembly {
417             r.slot := slot
418         }
419     }
420 
421     /**
422      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
423      */
424     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
425         /// @solidity memory-safe-assembly
426         assembly {
427             r.slot := slot
428         }
429     }
430 
431     /**
432      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
433      */
434     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
435         /// @solidity memory-safe-assembly
436         assembly {
437             r.slot := slot
438         }
439     }
440 
441     /**
442      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
443      */
444     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
445         /// @solidity memory-safe-assembly
446         assembly {
447             r.slot := slot
448         }
449     }
450 }
451 
452 /**
453  * @dev This abstract contract provides getters and event emitting update functions for
454  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
455  *
456  * _Available since v4.1._
457  *
458  * @custom:oz-upgrades-unsafe-allow delegatecall
459  */
460 abstract contract ERC1967Upgrade {
461     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
462     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
463 
464     /**
465      * @dev Storage slot with the address of the current implementation.
466      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
467      * validated in the constructor.
468      */
469     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
470 
471     /**
472      * @dev Emitted when the implementation is upgraded.
473      */
474     event Upgraded(address indexed implementation);
475 
476     /**
477      * @dev Returns the current implementation address.
478      */
479     function _getImplementation() internal view returns (address) {
480         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
481     }
482 
483     /**
484      * @dev Stores a new address in the EIP1967 implementation slot.
485      */
486     function _setImplementation(address newImplementation) private {
487         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
488         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
489     }
490 
491     /**
492      * @dev Perform implementation upgrade
493      *
494      * Emits an {Upgraded} event.
495      */
496     function _upgradeTo(address newImplementation) internal {
497         _setImplementation(newImplementation);
498         emit Upgraded(newImplementation);
499     }
500 
501     /**
502      * @dev Perform implementation upgrade with additional setup call.
503      *
504      * Emits an {Upgraded} event.
505      */
506     function _upgradeToAndCall(
507         address newImplementation,
508         bytes memory data,
509         bool forceCall
510     ) internal {
511         _upgradeTo(newImplementation);
512         if (data.length > 0 || forceCall) {
513             Address.functionDelegateCall(newImplementation, data);
514         }
515     }
516 
517     /**
518      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
519      *
520      * Emits an {Upgraded} event.
521      */
522     function _upgradeToAndCallUUPS(
523         address newImplementation,
524         bytes memory data,
525         bool forceCall
526     ) internal {
527         // Upgrades from old implementations will perform a rollback test. This test requires the new
528         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
529         // this special case will break upgrade paths from old UUPS implementation to new ones.
530         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
531             _setImplementation(newImplementation);
532         } else {
533             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
534                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
535             } catch {
536                 revert("ERC1967Upgrade: new implementation is not UUPS");
537             }
538             _upgradeToAndCall(newImplementation, data, forceCall);
539         }
540     }
541 
542     /**
543      * @dev Storage slot with the admin of the contract.
544      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
545      * validated in the constructor.
546      */
547     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
548 
549     /**
550      * @dev Emitted when the admin account has changed.
551      */
552     event AdminChanged(address previousAdmin, address newAdmin);
553 
554     /**
555      * @dev Returns the current admin.
556      */
557     function _getAdmin() internal view returns (address) {
558         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
559     }
560 
561     /**
562      * @dev Stores a new address in the EIP1967 admin slot.
563      */
564     function _setAdmin(address newAdmin) private {
565         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
566         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
567     }
568 
569     /**
570      * @dev Changes the admin of the proxy.
571      *
572      * Emits an {AdminChanged} event.
573      */
574     function _changeAdmin(address newAdmin) internal {
575         emit AdminChanged(_getAdmin(), newAdmin);
576         _setAdmin(newAdmin);
577     }
578 
579     /**
580      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
581      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
582      */
583     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
584 
585     /**
586      * @dev Emitted when the beacon is upgraded.
587      */
588     event BeaconUpgraded(address indexed beacon);
589 
590     /**
591      * @dev Returns the current beacon.
592      */
593     function _getBeacon() internal view returns (address) {
594         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
595     }
596 
597     /**
598      * @dev Stores a new beacon in the EIP1967 beacon slot.
599      */
600     function _setBeacon(address newBeacon) private {
601         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
602         require(
603             Address.isContract(IBeacon(newBeacon).implementation()),
604             "ERC1967: beacon implementation is not a contract"
605         );
606         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
607     }
608 
609     /**
610      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
611      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
612      *
613      * Emits a {BeaconUpgraded} event.
614      */
615     function _upgradeBeaconToAndCall(
616         address newBeacon,
617         bytes memory data,
618         bool forceCall
619     ) internal {
620         _setBeacon(newBeacon);
621         emit BeaconUpgraded(newBeacon);
622         if (data.length > 0 || forceCall) {
623             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
624         }
625     }
626 }
627 
628 /**
629  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
630  * implementation address that can be changed. This address is stored in storage in the location specified by
631  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
632  * implementation behind the proxy.
633  */
634 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
635     /**
636      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
637      *
638      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
639      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
640      */
641     constructor(address _logic, bytes memory _data) payable {
642         _upgradeToAndCall(_logic, _data, false);
643     }
644 
645     /**
646      * @dev Returns the current implementation address.
647      */
648     function _implementation() internal view virtual override returns (address impl) {
649         return ERC1967Upgrade._getImplementation();
650     }
651 }
