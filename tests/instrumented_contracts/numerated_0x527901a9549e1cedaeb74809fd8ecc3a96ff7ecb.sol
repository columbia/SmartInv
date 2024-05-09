1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/Proxy.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
8  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
9  * be specified by overriding the virtual {_implementation} function.
10  *
11  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
12  * different contract through the {_delegate} function.
13  *
14  * The success and return data of the delegated call will be returned back to the caller of the proxy.
15  */
16 abstract contract Proxy {
17     /**
18      * @dev Delegates the current call to `implementation`.
19      *
20      * This function does not return to its internal call site, it will return directly to the external caller.
21      */
22     function _delegate(address implementation) internal virtual {
23         assembly {
24             // Copy msg.data. We take full control of memory in this inline assembly
25             // block because it will not return to Solidity code. We overwrite the
26             // Solidity scratch pad at memory position 0.
27             calldatacopy(0, 0, calldatasize())
28 
29             // Call the implementation.
30             // out and outsize are 0 because we don't know the size yet.
31             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
32 
33             // Copy the returned data.
34             returndatacopy(0, 0, returndatasize())
35 
36             switch result
37             // delegatecall returns 0 on error.
38             case 0 {
39                 revert(0, returndatasize())
40             }
41             default {
42                 return(0, returndatasize())
43             }
44         }
45     }
46 
47     /**
48      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
49      * and {_fallback} should delegate.
50      */
51     function _implementation() internal view virtual returns (address);
52 
53     /**
54      * @dev Delegates the current call to the address returned by `_implementation()`.
55      *
56      * This function does not return to its internall call site, it will return directly to the external caller.
57      */
58     function _fallback() internal virtual {
59         _beforeFallback();
60         _delegate(_implementation());
61     }
62 
63     /**
64      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
65      * function in the contract matches the call data.
66      */
67     fallback() external payable virtual {
68         _fallback();
69     }
70 
71     /**
72      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
73      * is empty.
74      */
75     receive() external payable virtual {
76         _fallback();
77     }
78 
79     /**
80      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
81      * call, or as part of the Solidity `fallback` or `receive` functions.
82      *
83      * If overriden should call `super._beforeFallback()`.
84      */
85     function _beforeFallback() internal virtual {}
86 }
87 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev This is the interface that {BeaconProxy} expects of its beacon.
93  */
94 interface IBeacon {
95     /**
96      * @dev Must return an address that can be used as a delegate call target.
97      *
98      * {BeaconProxy} will check that this address is a contract.
99      */
100     function implementation() external view returns (address);
101 }
102 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
108  * proxy whose upgrades are fully controlled by the current implementation.
109  */
110 interface IERC1822Proxiable {
111     /**
112      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
113      * address.
114      *
115      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
116      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
117      * function revert if invoked through a proxy.
118      */
119     function proxiableUUID() external view returns (bytes32);
120 }
121 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
122 
123 pragma solidity ^0.8.1;
124 
125 /**
126  * @dev Collection of functions related to the address type
127  */
128 library Address {
129     /**
130      * @dev Returns true if `account` is a contract.
131      *
132      * [IMPORTANT]
133      * ====
134      * It is unsafe to assume that an address for which this function returns
135      * false is an externally-owned account (EOA) and not a contract.
136      *
137      * Among others, `isContract` will return false for the following
138      * types of addresses:
139      *
140      *  - an externally-owned account
141      *  - a contract in construction
142      *  - an address where a contract will be created
143      *  - an address where a contract lived, but was destroyed
144      * ====
145      *
146      * [IMPORTANT]
147      * ====
148      * You shouldn't rely on `isContract` to protect against flash loan attacks!
149      *
150      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
151      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
152      * constructor.
153      * ====
154      */
155     function isContract(address account) internal view returns (bool) {
156         // This method relies on extcodesize/address.code.length, which returns 0
157         // for contracts in construction, since the code is only stored at the end
158         // of the constructor execution.
159 
160         return account.code.length > 0;
161     }
162 
163     /**
164      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
165      * `recipient`, forwarding all available gas and reverting on errors.
166      *
167      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
168      * of certain opcodes, possibly making contracts go over the 2300 gas limit
169      * imposed by `transfer`, making them unable to receive funds via
170      * `transfer`. {sendValue} removes this limitation.
171      *
172      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
173      *
174      * IMPORTANT: because control is transferred to `recipient`, care must be
175      * taken to not create reentrancy vulnerabilities. Consider using
176      * {ReentrancyGuard} or the
177      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
178      */
179     function sendValue(address payable recipient, uint256 amount) internal {
180         require(address(this).balance >= amount, "Address: insufficient balance");
181 
182         (bool success, ) = recipient.call{value: amount}("");
183         require(success, "Address: unable to send value, recipient may have reverted");
184     }
185 
186     /**
187      * @dev Performs a Solidity function call using a low level `call`. A
188      * plain `call` is an unsafe replacement for a function call: use this
189      * function instead.
190      *
191      * If `target` reverts with a revert reason, it is bubbled up by this
192      * function (like regular Solidity function calls).
193      *
194      * Returns the raw returned data. To convert to the expected return value,
195      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
196      *
197      * Requirements:
198      *
199      * - `target` must be a contract.
200      * - calling `target` with `data` must not revert.
201      *
202      * _Available since v3.1._
203      */
204     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
205         return functionCall(target, data, "Address: low-level call failed");
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
210      * `errorMessage` as a fallback revert reason when `target` reverts.
211      *
212      * _Available since v3.1._
213      */
214     function functionCall(
215         address target,
216         bytes memory data,
217         string memory errorMessage
218     ) internal returns (bytes memory) {
219         return functionCallWithValue(target, data, 0, errorMessage);
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
224      * but also transferring `value` wei to `target`.
225      *
226      * Requirements:
227      *
228      * - the calling contract must have an ETH balance of at least `value`.
229      * - the called Solidity function must be `payable`.
230      *
231      * _Available since v3.1._
232      */
233     function functionCallWithValue(
234         address target,
235         bytes memory data,
236         uint256 value
237     ) internal returns (bytes memory) {
238         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
243      * with `errorMessage` as a fallback revert reason when `target` reverts.
244      *
245      * _Available since v3.1._
246      */
247     function functionCallWithValue(
248         address target,
249         bytes memory data,
250         uint256 value,
251         string memory errorMessage
252     ) internal returns (bytes memory) {
253         require(address(this).balance >= value, "Address: insufficient balance for call");
254         require(isContract(target), "Address: call to non-contract");
255 
256         (bool success, bytes memory returndata) = target.call{value: value}(data);
257         return verifyCallResult(success, returndata, errorMessage);
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
262      * but performing a static call.
263      *
264      * _Available since v3.3._
265      */
266     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
267         return functionStaticCall(target, data, "Address: low-level static call failed");
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
272      * but performing a static call.
273      *
274      * _Available since v3.3._
275      */
276     function functionStaticCall(
277         address target,
278         bytes memory data,
279         string memory errorMessage
280     ) internal view returns (bytes memory) {
281         require(isContract(target), "Address: static call to non-contract");
282 
283         (bool success, bytes memory returndata) = target.staticcall(data);
284         return verifyCallResult(success, returndata, errorMessage);
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
289      * but performing a delegate call.
290      *
291      * _Available since v3.4._
292      */
293     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
294         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
299      * but performing a delegate call.
300      *
301      * _Available since v3.4._
302      */
303     function functionDelegateCall(
304         address target,
305         bytes memory data,
306         string memory errorMessage
307     ) internal returns (bytes memory) {
308         require(isContract(target), "Address: delegate call to non-contract");
309 
310         (bool success, bytes memory returndata) = target.delegatecall(data);
311         return verifyCallResult(success, returndata, errorMessage);
312     }
313 
314     /**
315      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
316      * revert reason using the provided one.
317      *
318      * _Available since v4.3._
319      */
320     function verifyCallResult(
321         bool success,
322         bytes memory returndata,
323         string memory errorMessage
324     ) internal pure returns (bytes memory) {
325         if (success) {
326             return returndata;
327         } else {
328             // Look for revert reason and bubble it up if present
329             if (returndata.length > 0) {
330                 // The easiest way to bubble the revert reason is using memory via assembly
331 
332                 assembly {
333                     let returndata_size := mload(returndata)
334                     revert(add(32, returndata), returndata_size)
335                 }
336             } else {
337                 revert(errorMessage);
338             }
339         }
340     }
341 }
342 // OpenZeppelin Contracts v4.4.1 (utils/StorageSlot.sol)
343 
344 pragma solidity ^0.8.0;
345 
346 /**
347  * @dev Library for reading and writing primitive types to specific storage slots.
348  *
349  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
350  * This library helps with reading and writing to such slots without the need for inline assembly.
351  *
352  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
353  *
354  * Example usage to set ERC1967 implementation slot:
355  * ```
356  * contract ERC1967 {
357  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
358  *
359  *     function _getImplementation() internal view returns (address) {
360  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
361  *     }
362  *
363  *     function _setImplementation(address newImplementation) internal {
364  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
365  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
366  *     }
367  * }
368  * ```
369  *
370  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
371  */
372 library StorageSlot {
373     struct AddressSlot {
374         address value;
375     }
376 
377     struct BooleanSlot {
378         bool value;
379     }
380 
381     struct Bytes32Slot {
382         bytes32 value;
383     }
384 
385     struct Uint256Slot {
386         uint256 value;
387     }
388 
389     /**
390      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
391      */
392     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
393         assembly {
394             r.slot := slot
395         }
396     }
397 
398     /**
399      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
400      */
401     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
402         assembly {
403             r.slot := slot
404         }
405     }
406 
407     /**
408      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
409      */
410     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
411         assembly {
412             r.slot := slot
413         }
414     }
415 
416     /**
417      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
418      */
419     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
420         assembly {
421             r.slot := slot
422         }
423     }
424 }
425 
426 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
427 
428 pragma solidity ^0.8.2;
429 
430 
431 /**
432  * @dev This abstract contract provides getters and event emitting update functions for
433  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
434  *
435  * _Available since v4.1._
436  *
437  * @custom:oz-upgrades-unsafe-allow delegatecall
438  */
439 abstract contract ERC1967Upgrade {
440     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
441     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
442 
443     /**
444      * @dev Storage slot with the address of the current implementation.
445      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
446      * validated in the constructor.
447      */
448     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
449 
450     /**
451      * @dev Emitted when the implementation is upgraded.
452      */
453     event Upgraded(address indexed implementation);
454 
455     /**
456      * @dev Returns the current implementation address.
457      */
458     function _getImplementation() internal view returns (address) {
459         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
460     }
461 
462     /**
463      * @dev Stores a new address in the EIP1967 implementation slot.
464      */
465     function _setImplementation(address newImplementation) private {
466         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
467         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
468     }
469 
470     /**
471      * @dev Perform implementation upgrade
472      *
473      * Emits an {Upgraded} event.
474      */
475     function _upgradeTo(address newImplementation) internal {
476         _setImplementation(newImplementation);
477         emit Upgraded(newImplementation);
478     }
479 
480     /**
481      * @dev Perform implementation upgrade with additional setup call.
482      *
483      * Emits an {Upgraded} event.
484      */
485     function _upgradeToAndCall(
486         address newImplementation,
487         bytes memory data,
488         bool forceCall
489     ) internal {
490         _upgradeTo(newImplementation);
491         if (data.length > 0 || forceCall) {
492             Address.functionDelegateCall(newImplementation, data);
493         }
494     }
495 
496     /**
497      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
498      *
499      * Emits an {Upgraded} event.
500      */
501     function _upgradeToAndCallUUPS(
502         address newImplementation,
503         bytes memory data,
504         bool forceCall
505     ) internal {
506         // Upgrades from old implementations will perform a rollback test. This test requires the new
507         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
508         // this special case will break upgrade paths from old UUPS implementation to new ones.
509         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
510             _setImplementation(newImplementation);
511         } else {
512             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
513                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
514             } catch {
515                 revert("ERC1967Upgrade: new implementation is not UUPS");
516             }
517             _upgradeToAndCall(newImplementation, data, forceCall);
518         }
519     }
520 
521     /**
522      * @dev Storage slot with the admin of the contract.
523      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
524      * validated in the constructor.
525      */
526     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
527 
528     /**
529      * @dev Emitted when the admin account has changed.
530      */
531     event AdminChanged(address previousAdmin, address newAdmin);
532 
533     /**
534      * @dev Returns the current admin.
535      */
536     function _getAdmin() internal view returns (address) {
537         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
538     }
539 
540     /**
541      * @dev Stores a new address in the EIP1967 admin slot.
542      */
543     function _setAdmin(address newAdmin) private {
544         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
545         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
546     }
547 
548     /**
549      * @dev Changes the admin of the proxy.
550      *
551      * Emits an {AdminChanged} event.
552      */
553     function _changeAdmin(address newAdmin) internal {
554         emit AdminChanged(_getAdmin(), newAdmin);
555         _setAdmin(newAdmin);
556     }
557 
558     /**
559      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
560      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
561      */
562     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
563 
564     /**
565      * @dev Emitted when the beacon is upgraded.
566      */
567     event BeaconUpgraded(address indexed beacon);
568 
569     /**
570      * @dev Returns the current beacon.
571      */
572     function _getBeacon() internal view returns (address) {
573         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
574     }
575 
576     /**
577      * @dev Stores a new beacon in the EIP1967 beacon slot.
578      */
579     function _setBeacon(address newBeacon) private {
580         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
581         require(
582             Address.isContract(IBeacon(newBeacon).implementation()),
583             "ERC1967: beacon implementation is not a contract"
584         );
585         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
586     }
587 
588     /**
589      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
590      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
591      *
592      * Emits a {BeaconUpgraded} event.
593      */
594     function _upgradeBeaconToAndCall(
595         address newBeacon,
596         bytes memory data,
597         bool forceCall
598     ) internal {
599         _setBeacon(newBeacon);
600         emit BeaconUpgraded(newBeacon);
601         if (data.length > 0 || forceCall) {
602             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
603         }
604     }
605 }
606 // OpenZeppelin Contracts v4.4.1 (proxy/ERC1967/ERC1967Proxy.sol)
607 
608 pragma solidity ^0.8.0;
609 
610 
611 /**
612  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
613  * implementation address that can be changed. This address is stored in storage in the location specified by
614  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
615  * implementation behind the proxy.
616  */
617 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
618     /**
619      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
620      *
621      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
622      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
623      */
624     constructor(address _logic, bytes memory _data) payable {
625         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
626         _upgradeToAndCall(_logic, _data, false);
627     }
628 
629     /**
630      * @dev Returns the current implementation address.
631      */
632     function _implementation() internal view virtual override returns (address impl) {
633         return ERC1967Upgrade._getImplementation();
634     }
635 }
636 pragma solidity ^0.8.0;
637 
638 contract ImplDeployerProxy is ERC1967Proxy {
639 	constructor(address impl, bytes memory data) ERC1967Proxy(impl, data) {}
640 }