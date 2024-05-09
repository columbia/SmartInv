1 pragma solidity ^0.8.0;
2 
3 
4 // SPDX-License-Identifier: MIT
5 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
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
48      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
49      * and {_fallback} should delegate.
50      */
51     function _implementation() internal view virtual returns (address);
52 
53     /**
54      * @dev Delegates the current call to the address returned by `_implementation()`.
55      *
56      * This function does not return to its internal call site, it will return directly to the external caller.
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
83      * If overridden should call `super._beforeFallback()`.
84      */
85     function _beforeFallback() internal virtual {}
86 }
87 
88 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
89 /**
90  * @dev This is the interface that {BeaconProxy} expects of its beacon.
91  */
92 interface IBeacon {
93     /**
94      * @dev Must return an address that can be used as a delegate call target.
95      *
96      * {BeaconProxy} will check that this address is a contract.
97      */
98     function implementation() external view returns (address);
99 }
100 
101 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
102 /**
103  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
104  * proxy whose upgrades are fully controlled by the current implementation.
105  */
106 interface IERC1822Proxiable {
107     /**
108      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
109      * address.
110      *
111      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
112      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
113      * function revert if invoked through a proxy.
114      */
115     function proxiableUUID() external view returns (bytes32);
116 }
117 
118 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
119 /**
120  * @dev Collection of functions related to the address type
121  */
122 library Address {
123     /**
124      * @dev Returns true if `account` is a contract.
125      *
126      * [IMPORTANT]
127      * ====
128      * It is unsafe to assume that an address for which this function returns
129      * false is an externally-owned account (EOA) and not a contract.
130      *
131      * Among others, `isContract` will return false for the following
132      * types of addresses:
133      *
134      *  - an externally-owned account
135      *  - a contract in construction
136      *  - an address where a contract will be created
137      *  - an address where a contract lived, but was destroyed
138      * ====
139      *
140      * [IMPORTANT]
141      * ====
142      * You shouldn't rely on `isContract` to protect against flash loan attacks!
143      *
144      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
145      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
146      * constructor.
147      * ====
148      */
149     function isContract(address account) internal view returns (bool) {
150         // This method relies on extcodesize/address.code.length, which returns 0
151         // for contracts in construction, since the code is only stored at the end
152         // of the constructor execution.
153 
154         return account.code.length > 0;
155     }
156 
157     /**
158      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
159      * `recipient`, forwarding all available gas and reverting on errors.
160      *
161      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
162      * of certain opcodes, possibly making contracts go over the 2300 gas limit
163      * imposed by `transfer`, making them unable to receive funds via
164      * `transfer`. {sendValue} removes this limitation.
165      *
166      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
167      *
168      * IMPORTANT: because control is transferred to `recipient`, care must be
169      * taken to not create reentrancy vulnerabilities. Consider using
170      * {ReentrancyGuard} or the
171      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
172      */
173     function sendValue(address payable recipient, uint256 amount) internal {
174         require(address(this).balance >= amount, "Address: insufficient balance");
175 
176         (bool success, ) = recipient.call{value: amount}("");
177         require(success, "Address: unable to send value, recipient may have reverted");
178     }
179 
180     /**
181      * @dev Performs a Solidity function call using a low level `call`. A
182      * plain `call` is an unsafe replacement for a function call: use this
183      * function instead.
184      *
185      * If `target` reverts with a revert reason, it is bubbled up by this
186      * function (like regular Solidity function calls).
187      *
188      * Returns the raw returned data. To convert to the expected return value,
189      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
190      *
191      * Requirements:
192      *
193      * - `target` must be a contract.
194      * - calling `target` with `data` must not revert.
195      *
196      * _Available since v3.1._
197      */
198     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
199         return functionCall(target, data, "Address: low-level call failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
204      * `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCall(
209         address target,
210         bytes memory data,
211         string memory errorMessage
212     ) internal returns (bytes memory) {
213         return functionCallWithValue(target, data, 0, errorMessage);
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
218      * but also transferring `value` wei to `target`.
219      *
220      * Requirements:
221      *
222      * - the calling contract must have an ETH balance of at least `value`.
223      * - the called Solidity function must be `payable`.
224      *
225      * _Available since v3.1._
226      */
227     function functionCallWithValue(
228         address target,
229         bytes memory data,
230         uint256 value
231     ) internal returns (bytes memory) {
232         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
237      * with `errorMessage` as a fallback revert reason when `target` reverts.
238      *
239      * _Available since v3.1._
240      */
241     function functionCallWithValue(
242         address target,
243         bytes memory data,
244         uint256 value,
245         string memory errorMessage
246     ) internal returns (bytes memory) {
247         require(address(this).balance >= value, "Address: insufficient balance for call");
248         require(isContract(target), "Address: call to non-contract");
249 
250         (bool success, bytes memory returndata) = target.call{value: value}(data);
251         return verifyCallResult(success, returndata, errorMessage);
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
256      * but performing a static call.
257      *
258      * _Available since v3.3._
259      */
260     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
261         return functionStaticCall(target, data, "Address: low-level static call failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
266      * but performing a static call.
267      *
268      * _Available since v3.3._
269      */
270     function functionStaticCall(
271         address target,
272         bytes memory data,
273         string memory errorMessage
274     ) internal view returns (bytes memory) {
275         require(isContract(target), "Address: static call to non-contract");
276 
277         (bool success, bytes memory returndata) = target.staticcall(data);
278         return verifyCallResult(success, returndata, errorMessage);
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
283      * but performing a delegate call.
284      *
285      * _Available since v3.4._
286      */
287     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
288         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
293      * but performing a delegate call.
294      *
295      * _Available since v3.4._
296      */
297     function functionDelegateCall(
298         address target,
299         bytes memory data,
300         string memory errorMessage
301     ) internal returns (bytes memory) {
302         require(isContract(target), "Address: delegate call to non-contract");
303 
304         (bool success, bytes memory returndata) = target.delegatecall(data);
305         return verifyCallResult(success, returndata, errorMessage);
306     }
307 
308     /**
309      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
310      * revert reason using the provided one.
311      *
312      * _Available since v4.3._
313      */
314     function verifyCallResult(
315         bool success,
316         bytes memory returndata,
317         string memory errorMessage
318     ) internal pure returns (bytes memory) {
319         if (success) {
320             return returndata;
321         } else {
322             // Look for revert reason and bubble it up if present
323             if (returndata.length > 0) {
324                 // The easiest way to bubble the revert reason is using memory via assembly
325 
326                 assembly {
327                     let returndata_size := mload(returndata)
328                     revert(add(32, returndata), returndata_size)
329                 }
330             } else {
331                 revert(errorMessage);
332             }
333         }
334     }
335 }
336 
337 // OpenZeppelin Contracts v4.4.1 (utils/StorageSlot.sol)
338 /**
339  * @dev Library for reading and writing primitive types to specific storage slots.
340  *
341  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
342  * This library helps with reading and writing to such slots without the need for inline assembly.
343  *
344  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
345  *
346  * Example usage to set ERC1967 implementation slot:
347  * ```
348  * contract ERC1967 {
349  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
350  *
351  *     function _getImplementation() internal view returns (address) {
352  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
353  *     }
354  *
355  *     function _setImplementation(address newImplementation) internal {
356  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
357  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
358  *     }
359  * }
360  * ```
361  *
362  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
363  */
364 library StorageSlot {
365     struct AddressSlot {
366         address value;
367     }
368 
369     struct BooleanSlot {
370         bool value;
371     }
372 
373     struct Bytes32Slot {
374         bytes32 value;
375     }
376 
377     struct Uint256Slot {
378         uint256 value;
379     }
380 
381     /**
382      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
383      */
384     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
385         assembly {
386             r.slot := slot
387         }
388     }
389 
390     /**
391      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
392      */
393     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
394         assembly {
395             r.slot := slot
396         }
397     }
398 
399     /**
400      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
401      */
402     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
403         assembly {
404             r.slot := slot
405         }
406     }
407 
408     /**
409      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
410      */
411     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
412         assembly {
413             r.slot := slot
414         }
415     }
416 }
417 
418 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
419 /**
420  * @dev This abstract contract provides getters and event emitting update functions for
421  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
422  *
423  * _Available since v4.1._
424  *
425  * @custom:oz-upgrades-unsafe-allow delegatecall
426  */
427 abstract contract ERC1967Upgrade {
428     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
429     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
430 
431     /**
432      * @dev Storage slot with the address of the current implementation.
433      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
434      * validated in the constructor.
435      */
436     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
437 
438     /**
439      * @dev Emitted when the implementation is upgraded.
440      */
441     event Upgraded(address indexed implementation);
442 
443     /**
444      * @dev Returns the current implementation address.
445      */
446     function _getImplementation() internal view returns (address) {
447         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
448     }
449 
450     /**
451      * @dev Stores a new address in the EIP1967 implementation slot.
452      */
453     function _setImplementation(address newImplementation) private {
454         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
455         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
456     }
457 
458     /**
459      * @dev Perform implementation upgrade
460      *
461      * Emits an {Upgraded} event.
462      */
463     function _upgradeTo(address newImplementation) internal {
464         _setImplementation(newImplementation);
465         emit Upgraded(newImplementation);
466     }
467 
468     /**
469      * @dev Perform implementation upgrade with additional setup call.
470      *
471      * Emits an {Upgraded} event.
472      */
473     function _upgradeToAndCall(
474         address newImplementation,
475         bytes memory data,
476         bool forceCall
477     ) internal {
478         _upgradeTo(newImplementation);
479         if (data.length > 0 || forceCall) {
480             Address.functionDelegateCall(newImplementation, data);
481         }
482     }
483 
484     /**
485      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
486      *
487      * Emits an {Upgraded} event.
488      */
489     function _upgradeToAndCallUUPS(
490         address newImplementation,
491         bytes memory data,
492         bool forceCall
493     ) internal {
494         // Upgrades from old implementations will perform a rollback test. This test requires the new
495         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
496         // this special case will break upgrade paths from old UUPS implementation to new ones.
497         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
498             _setImplementation(newImplementation);
499         } else {
500             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
501                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
502             } catch {
503                 revert("ERC1967Upgrade: new implementation is not UUPS");
504             }
505             _upgradeToAndCall(newImplementation, data, forceCall);
506         }
507     }
508 
509     /**
510      * @dev Storage slot with the admin of the contract.
511      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
512      * validated in the constructor.
513      */
514     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
515 
516     /**
517      * @dev Emitted when the admin account has changed.
518      */
519     event AdminChanged(address previousAdmin, address newAdmin);
520 
521     /**
522      * @dev Returns the current admin.
523      */
524     function _getAdmin() internal view returns (address) {
525         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
526     }
527 
528     /**
529      * @dev Stores a new address in the EIP1967 admin slot.
530      */
531     function _setAdmin(address newAdmin) private {
532         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
533         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
534     }
535 
536     /**
537      * @dev Changes the admin of the proxy.
538      *
539      * Emits an {AdminChanged} event.
540      */
541     function _changeAdmin(address newAdmin) internal {
542         emit AdminChanged(_getAdmin(), newAdmin);
543         _setAdmin(newAdmin);
544     }
545 
546     /**
547      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
548      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
549      */
550     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
551 
552     /**
553      * @dev Emitted when the beacon is upgraded.
554      */
555     event BeaconUpgraded(address indexed beacon);
556 
557     /**
558      * @dev Returns the current beacon.
559      */
560     function _getBeacon() internal view returns (address) {
561         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
562     }
563 
564     /**
565      * @dev Stores a new beacon in the EIP1967 beacon slot.
566      */
567     function _setBeacon(address newBeacon) private {
568         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
569         require(
570             Address.isContract(IBeacon(newBeacon).implementation()),
571             "ERC1967: beacon implementation is not a contract"
572         );
573         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
574     }
575 
576     /**
577      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
578      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
579      *
580      * Emits a {BeaconUpgraded} event.
581      */
582     function _upgradeBeaconToAndCall(
583         address newBeacon,
584         bytes memory data,
585         bool forceCall
586     ) internal {
587         _setBeacon(newBeacon);
588         emit BeaconUpgraded(newBeacon);
589         if (data.length > 0 || forceCall) {
590             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
591         }
592     }
593 }
594 
595 // OpenZeppelin Contracts v4.4.1 (proxy/ERC1967/ERC1967Proxy.sol)
596 /**
597  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
598  * implementation address that can be changed. This address is stored in storage in the location specified by
599  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
600  * implementation behind the proxy.
601  */
602 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
603     /**
604      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
605      *
606      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
607      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
608      */
609     constructor(address _logic, bytes memory _data) payable {
610         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
611         _upgradeToAndCall(_logic, _data, false);
612     }
613 
614     /**
615      * @dev Returns the current implementation address.
616      */
617     function _implementation() internal view virtual override returns (address impl) {
618         return ERC1967Upgrade._getImplementation();
619     }
620 }