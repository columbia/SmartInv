1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.10;
3 
4 // OpenZeppelin Contracts v4.4.1 (proxy/ERC1967/ERC1967Proxy.sol)
5 
6 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/Proxy.sol)
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
50      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
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
85      * If overriden should call `super._beforeFallback()`.
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
124 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
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
206         return functionCall(target, data, "Address: low-level call failed");
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
255         require(isContract(target), "Address: call to non-contract");
256 
257         (bool success, bytes memory returndata) = target.call{value: value}(data);
258         return verifyCallResult(success, returndata, errorMessage);
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
263      * but performing a static call.
264      *
265      * _Available since v3.3._
266      */
267     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
268         return functionStaticCall(target, data, "Address: low-level static call failed");
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
273      * but performing a static call.
274      *
275      * _Available since v3.3._
276      */
277     function functionStaticCall(
278         address target,
279         bytes memory data,
280         string memory errorMessage
281     ) internal view returns (bytes memory) {
282         require(isContract(target), "Address: static call to non-contract");
283 
284         (bool success, bytes memory returndata) = target.staticcall(data);
285         return verifyCallResult(success, returndata, errorMessage);
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
309         require(isContract(target), "Address: delegate call to non-contract");
310 
311         (bool success, bytes memory returndata) = target.delegatecall(data);
312         return verifyCallResult(success, returndata, errorMessage);
313     }
314 
315     /**
316      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
317      * revert reason using the provided one.
318      *
319      * _Available since v4.3._
320      */
321     function verifyCallResult(
322         bool success,
323         bytes memory returndata,
324         string memory errorMessage
325     ) internal pure returns (bytes memory) {
326         if (success) {
327             return returndata;
328         } else {
329             // Look for revert reason and bubble it up if present
330             if (returndata.length > 0) {
331                 // The easiest way to bubble the revert reason is using memory via assembly
332 
333                 assembly {
334                     let returndata_size := mload(returndata)
335                     revert(add(32, returndata), returndata_size)
336                 }
337             } else {
338                 revert(errorMessage);
339             }
340         }
341     }
342 }
343 
344 // OpenZeppelin Contracts v4.4.1 (utils/StorageSlot.sol)
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
426 /**
427  * @dev This abstract contract provides getters and event emitting update functions for
428  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
429  *
430  * _Available since v4.1._
431  *
432  * @custom:oz-upgrades-unsafe-allow delegatecall
433  */
434 abstract contract ERC1967Upgrade {
435     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
436     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
437 
438     /**
439      * @dev Storage slot with the address of the current implementation.
440      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
441      * validated in the constructor.
442      */
443     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
444 
445     /**
446      * @dev Emitted when the implementation is upgraded.
447      */
448     event Upgraded(address indexed implementation);
449 
450     /**
451      * @dev Returns the current implementation address.
452      */
453     function _getImplementation() internal view returns (address) {
454         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
455     }
456 
457     /**
458      * @dev Stores a new address in the EIP1967 implementation slot.
459      */
460     function _setImplementation(address newImplementation) private {
461         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
462         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
463     }
464 
465     /**
466      * @dev Perform implementation upgrade
467      *
468      * Emits an {Upgraded} event.
469      */
470     function _upgradeTo(address newImplementation) internal {
471         _setImplementation(newImplementation);
472         emit Upgraded(newImplementation);
473     }
474 
475     /**
476      * @dev Perform implementation upgrade with additional setup call.
477      *
478      * Emits an {Upgraded} event.
479      */
480     function _upgradeToAndCall(
481         address newImplementation,
482         bytes memory data,
483         bool forceCall
484     ) internal {
485         _upgradeTo(newImplementation);
486         if (data.length > 0 || forceCall) {
487             Address.functionDelegateCall(newImplementation, data);
488         }
489     }
490 
491     /**
492      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
493      *
494      * Emits an {Upgraded} event.
495      */
496     function _upgradeToAndCallUUPS(
497         address newImplementation,
498         bytes memory data,
499         bool forceCall
500     ) internal {
501         // Upgrades from old implementations will perform a rollback test. This test requires the new
502         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
503         // this special case will break upgrade paths from old UUPS implementation to new ones.
504         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
505             _setImplementation(newImplementation);
506         } else {
507             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
508                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
509             } catch {
510                 revert("ERC1967Upgrade: new implementation is not UUPS");
511             }
512             _upgradeToAndCall(newImplementation, data, forceCall);
513         }
514     }
515 
516     /**
517      * @dev Storage slot with the admin of the contract.
518      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
519      * validated in the constructor.
520      */
521     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
522 
523     /**
524      * @dev Emitted when the admin account has changed.
525      */
526     event AdminChanged(address previousAdmin, address newAdmin);
527 
528     /**
529      * @dev Returns the current admin.
530      */
531     function _getAdmin() internal view returns (address) {
532         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
533     }
534 
535     /**
536      * @dev Stores a new address in the EIP1967 admin slot.
537      */
538     function _setAdmin(address newAdmin) private {
539         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
540         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
541     }
542 
543     /**
544      * @dev Changes the admin of the proxy.
545      *
546      * Emits an {AdminChanged} event.
547      */
548     function _changeAdmin(address newAdmin) internal {
549         emit AdminChanged(_getAdmin(), newAdmin);
550         _setAdmin(newAdmin);
551     }
552 
553     /**
554      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
555      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
556      */
557     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
558 
559     /**
560      * @dev Emitted when the beacon is upgraded.
561      */
562     event BeaconUpgraded(address indexed beacon);
563 
564     /**
565      * @dev Returns the current beacon.
566      */
567     function _getBeacon() internal view returns (address) {
568         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
569     }
570 
571     /**
572      * @dev Stores a new beacon in the EIP1967 beacon slot.
573      */
574     function _setBeacon(address newBeacon) private {
575         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
576         require(
577             Address.isContract(IBeacon(newBeacon).implementation()),
578             "ERC1967: beacon implementation is not a contract"
579         );
580         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
581     }
582 
583     /**
584      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
585      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
586      *
587      * Emits a {BeaconUpgraded} event.
588      */
589     function _upgradeBeaconToAndCall(
590         address newBeacon,
591         bytes memory data,
592         bool forceCall
593     ) internal {
594         _setBeacon(newBeacon);
595         emit BeaconUpgraded(newBeacon);
596         if (data.length > 0 || forceCall) {
597             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
598         }
599     }
600 }
601 
602 /**
603  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
604  * implementation address that can be changed. This address is stored in storage in the location specified by
605  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
606  * implementation behind the proxy.
607  */
608 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
609     /**
610      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
611      *
612      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
613      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
614      */
615     constructor(address _logic, bytes memory _data) payable {
616         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
617         _upgradeToAndCall(_logic, _data, false);
618     }
619 
620     /**
621      * @dev Returns the current implementation address.
622      */
623     function _implementation() internal view virtual override returns (address impl) {
624         return ERC1967Upgrade._getImplementation();
625     }
626 }
627 
628 /// @dev Zora NFT Creator Proxy Access Contract
629 contract ERC721DropProxy is ERC1967Proxy {
630     constructor(address _logic, bytes memory _data)
631         payable
632         ERC1967Proxy(_logic, _data)
633     {}
634 }