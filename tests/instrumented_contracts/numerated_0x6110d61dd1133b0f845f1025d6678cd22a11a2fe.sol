1 // Sources flattened with hardhat v2.12.0 https://hardhat.org
2 
3 // File niy/proxy/Proxy.sol
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
12  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
13  * be specified by overriding the virtual {_implementation} function.
14  *
15  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
16  * different contract through the {_delegate} function.
17  *
18  * The success and return data of the delegated call will be returned back to the caller of the proxy.
19  */
20 abstract contract Proxy {
21     /**
22      * @dev Delegates the current call to `implementation`.
23      *
24      * This function does not return to its internal call site, it will return directly to the external caller.
25      */
26     function _delegate(address implementation) internal virtual {
27         assembly {
28             // Copy msg.data. We take full control of memory in this inline assembly
29             // block because it will not return to Solidity code. We overwrite the
30             // Solidity scratch pad at memory position 0.
31             calldatacopy(0, 0, calldatasize())
32 
33             // Call the implementation.
34             // out and outsize are 0 because we don't know the size yet.
35             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
36 
37             // Copy the returned data.
38             returndatacopy(0, 0, returndatasize())
39 
40             switch result
41             // delegatecall returns 0 on error.
42             case 0 {
43                 revert(0, returndatasize())
44             }
45             default {
46                 return(0, returndatasize())
47             }
48         }
49     }
50 
51     /**
52      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
53      * and {_fallback} should delegate.
54      */
55     function _implementation() internal view virtual returns (address);
56 
57     /**
58      * @dev Delegates the current call to the address returned by `_implementation()`.
59      *
60      * This function does not return to its internal call site, it will return directly to the external caller.
61      */
62     function _fallback() internal virtual {
63         _beforeFallback();
64         _delegate(_implementation());
65     }
66 
67     /**
68      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
69      * function in the contract matches the call data.
70      */
71     fallback() external payable virtual {
72         _fallback();
73     }
74 
75     /**
76      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
77      * is empty.
78      */
79     receive() external payable virtual {
80         _fallback();
81     }
82 
83     /**
84      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
85      * call, or as part of the Solidity `fallback` or `receive` functions.
86      *
87      * If overridden should call `super._beforeFallback()`.
88      */
89     function _beforeFallback() internal virtual {}
90 }
91 
92 
93 // File niy/proxy/beacon/IBeacon.sol
94 
95 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
96 
97 
98 /**
99  * @dev This is the interface that {BeaconProxy} expects of its beacon.
100  */
101 interface IBeacon {
102     /**
103      * @dev Must return an address that can be used as a delegate call target.
104      *
105      * {BeaconProxy} will check that this address is a contract.
106      */
107     function implementation() external view returns (address);
108 }
109 
110 
111 // File niy/interfaces/draft-IERC1822.sol
112 
113 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
114 
115 
116 /**
117  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
118  * proxy whose upgrades are fully controlled by the current implementation.
119  */
120 interface IERC1822Proxiable {
121     /**
122      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
123      * address.
124      *
125      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
126      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
127      * function revert if invoked through a proxy.
128      */
129     function proxiableUUID() external view returns (bytes32);
130 }
131 
132 
133 // File niy/utils/StorageSlot.sol
134 
135 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
136 
137 
138 /**
139  * @dev Library for reading and writing primitive types to specific storage slots.
140  *
141  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
142  * This library helps with reading and writing to such slots without the need for inline assembly.
143  *
144  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
145  *
146  * Example usage to set ERC1967 implementation slot:
147  * ```
148  * contract ERC1967 {
149  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
150  *
151  *     function _getImplementation() internal view returns (address) {
152  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
153  *     }
154  *
155  *     function _setImplementation(address newImplementation) internal {
156  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
157  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
158  *     }
159  * }
160  * ```
161  *
162  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
163  */
164 library StorageSlot {
165     struct AddressSlot {
166         address value;
167     }
168 
169     struct BooleanSlot {
170         bool value;
171     }
172 
173     struct Bytes32Slot {
174         bytes32 value;
175     }
176 
177     struct Uint256Slot {
178         uint256 value;
179     }
180 
181     /**
182      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
183      */
184     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
185         /// @solidity memory-safe-assembly
186         assembly {
187             r.slot := slot
188         }
189     }
190 
191     /**
192      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
193      */
194     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
195         /// @solidity memory-safe-assembly
196         assembly {
197             r.slot := slot
198         }
199     }
200 
201     /**
202      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
203      */
204     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
205         /// @solidity memory-safe-assembly
206         assembly {
207             r.slot := slot
208         }
209     }
210 
211     /**
212      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
213      */
214     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
215         /// @solidity memory-safe-assembly
216         assembly {
217             r.slot := slot
218         }
219     }
220 }
221 
222 
223 // File niy/utils/Address.sol
224 
225 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
226 
227 
228 /**
229  * @dev Collection of functions related to the address type
230  */
231 library Address {
232     /**
233      * @dev Returns true if `account` is a contract.
234      *
235      * [IMPORTANT]
236      * ====
237      * It is unsafe to assume that an address for which this function returns
238      * false is an externally-owned account (EOA) and not a contract.
239      *
240      * Among others, `isContract` will return false for the following
241      * types of addresses:
242      *
243      *  - an externally-owned account
244      *  - a contract in construction
245      *  - an address where a contract will be created
246      *  - an address where a contract lived, but was destroyed
247      * ====
248      *
249      * [IMPORTANT]
250      * ====
251      * You shouldn't rely on `isContract` to protect against flash loan attacks!
252      *
253      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
254      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
255      * constructor.
256      * ====
257      */
258     function isContract(address account) internal view returns (bool) {
259         // This method relies on extcodesize/address.code.length, which returns 0
260         // for contracts in construction, since the code is only stored at the end
261         // of the constructor execution.
262 
263         return account.code.length > 0;
264     }
265 
266     /**
267      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
268      * `recipient`, forwarding all available gas and reverting on errors.
269      *
270      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
271      * of certain opcodes, possibly making contracts go over the 2300 gas limit
272      * imposed by `transfer`, making them unable to receive funds via
273      * `transfer`. {sendValue} removes this limitation.
274      *
275      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
276      *
277      * IMPORTANT: because control is transferred to `recipient`, care must be
278      * taken to not create reentrancy vulnerabilities. Consider using
279      * {ReentrancyGuard} or the
280      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
281      */
282     function sendValue(address payable recipient, uint256 amount) internal {
283         require(address(this).balance >= amount, "Address: insufficient balance");
284 
285         (bool success, ) = recipient.call{value: amount}("");
286         require(success, "Address: unable to send value, recipient may have reverted");
287     }
288 
289     /**
290      * @dev Performs a Solidity function call using a low level `call`. A
291      * plain `call` is an unsafe replacement for a function call: use this
292      * function instead.
293      *
294      * If `target` reverts with a revert reason, it is bubbled up by this
295      * function (like regular Solidity function calls).
296      *
297      * Returns the raw returned data. To convert to the expected return value,
298      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
299      *
300      * Requirements:
301      *
302      * - `target` must be a contract.
303      * - calling `target` with `data` must not revert.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
308         return functionCall(target, data, "Address: low-level call failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
313      * `errorMessage` as a fallback revert reason when `target` reverts.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(
318         address target,
319         bytes memory data,
320         string memory errorMessage
321     ) internal returns (bytes memory) {
322         return functionCallWithValue(target, data, 0, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but also transferring `value` wei to `target`.
328      *
329      * Requirements:
330      *
331      * - the calling contract must have an ETH balance of at least `value`.
332      * - the called Solidity function must be `payable`.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(
337         address target,
338         bytes memory data,
339         uint256 value
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
346      * with `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(
351         address target,
352         bytes memory data,
353         uint256 value,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         require(address(this).balance >= value, "Address: insufficient balance for call");
357         require(isContract(target), "Address: call to non-contract");
358 
359         (bool success, bytes memory returndata) = target.call{value: value}(data);
360         return verifyCallResult(success, returndata, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but performing a static call.
366      *
367      * _Available since v3.3._
368      */
369     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
370         return functionStaticCall(target, data, "Address: low-level static call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
375      * but performing a static call.
376      *
377      * _Available since v3.3._
378      */
379     function functionStaticCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal view returns (bytes memory) {
384         require(isContract(target), "Address: static call to non-contract");
385 
386         (bool success, bytes memory returndata) = target.staticcall(data);
387         return verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but performing a delegate call.
393      *
394      * _Available since v3.4._
395      */
396     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
397         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
402      * but performing a delegate call.
403      *
404      * _Available since v3.4._
405      */
406     function functionDelegateCall(
407         address target,
408         bytes memory data,
409         string memory errorMessage
410     ) internal returns (bytes memory) {
411         require(isContract(target), "Address: delegate call to non-contract");
412 
413         (bool success, bytes memory returndata) = target.delegatecall(data);
414         return verifyCallResult(success, returndata, errorMessage);
415     }
416 
417     /**
418      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
419      * revert reason using the provided one.
420      *
421      * _Available since v4.3._
422      */
423     function verifyCallResult(
424         bool success,
425         bytes memory returndata,
426         string memory errorMessage
427     ) internal pure returns (bytes memory) {
428         if (success) {
429             return returndata;
430         } else {
431             // Look for revert reason and bubble it up if present
432             if (returndata.length > 0) {
433                 // The easiest way to bubble the revert reason is using memory via assembly
434                 /// @solidity memory-safe-assembly
435                 assembly {
436                     let returndata_size := mload(returndata)
437                     revert(add(32, returndata), returndata_size)
438                 }
439             } else {
440                 revert(errorMessage);
441             }
442         }
443     }
444 }
445 
446 
447 // File niy/proxy/ERC1967/ERC1967Upgrade.sol
448 
449 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
450 
451 
452 
453 
454 
455 /**
456  * @dev This abstract contract provides getters and event emitting update functions for
457  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
458  *
459  * _Available since v4.1._
460  *
461  * @custom:oz-upgrades-unsafe-allow delegatecall
462  */
463 abstract contract ERC1967Upgrade {
464     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
465     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
466 
467     /**
468      * @dev Storage slot with the address of the current implementation.
469      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
470      * validated in the constructor.
471      */
472     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
473 
474     /**
475      * @dev Emitted when the implementation is upgraded.
476      */
477     event Upgraded(address indexed implementation);
478 
479     /**
480      * @dev Returns the current implementation address.
481      */
482     function _getImplementation() internal view returns (address) {
483         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
484     }
485 
486     /**
487      * @dev Stores a new address in the EIP1967 implementation slot.
488      */
489     function _setImplementation(address newImplementation) private {
490         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
491         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
492     }
493 
494     /**
495      * @dev Perform implementation upgrade
496      *
497      * Emits an {Upgraded} event.
498      */
499     function _upgradeTo(address newImplementation) internal {
500         _setImplementation(newImplementation);
501         emit Upgraded(newImplementation);
502     }
503 
504     /**
505      * @dev Perform implementation upgrade with additional setup call.
506      *
507      * Emits an {Upgraded} event.
508      */
509     function _upgradeToAndCall(
510         address newImplementation,
511         bytes memory data,
512         bool forceCall
513     ) internal {
514         _upgradeTo(newImplementation);
515         if (data.length > 0 || forceCall) {
516             Address.functionDelegateCall(newImplementation, data);
517         }
518     }
519 
520     /**
521      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
522      *
523      * Emits an {Upgraded} event.
524      */
525     function _upgradeToAndCallUUPS(
526         address newImplementation,
527         bytes memory data,
528         bool forceCall
529     ) internal {
530         // Upgrades from old implementations will perform a rollback test. This test requires the new
531         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
532         // this special case will break upgrade paths from old UUPS implementation to new ones.
533         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
534             _setImplementation(newImplementation);
535         } else {
536             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
537                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
538             } catch {
539                 revert("ERC1967Upgrade: new implementation is not UUPS");
540             }
541             _upgradeToAndCall(newImplementation, data, forceCall);
542         }
543     }
544 
545     /**
546      * @dev Storage slot with the admin of the contract.
547      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
548      * validated in the constructor.
549      */
550     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
551 
552     /**
553      * @dev Emitted when the admin account has changed.
554      */
555     event AdminChanged(address previousAdmin, address newAdmin);
556 
557     /**
558      * @dev Returns the current admin.
559      */
560     function _getAdmin() internal view returns (address) {
561         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
562     }
563 
564     /**
565      * @dev Stores a new address in the EIP1967 admin slot.
566      */
567     function _setAdmin(address newAdmin) private {
568         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
569         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
570     }
571 
572     /**
573      * @dev Changes the admin of the proxy.
574      *
575      * Emits an {AdminChanged} event.
576      */
577     function _changeAdmin(address newAdmin) internal {
578         emit AdminChanged(_getAdmin(), newAdmin);
579         _setAdmin(newAdmin);
580     }
581 
582     /**
583      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
584      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
585      */
586     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
587 
588     /**
589      * @dev Emitted when the beacon is upgraded.
590      */
591     event BeaconUpgraded(address indexed beacon);
592 
593     /**
594      * @dev Returns the current beacon.
595      */
596     function _getBeacon() internal view returns (address) {
597         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
598     }
599 
600     /**
601      * @dev Stores a new beacon in the EIP1967 beacon slot.
602      */
603     function _setBeacon(address newBeacon) private {
604         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
605         require(
606             Address.isContract(IBeacon(newBeacon).implementation()),
607             "ERC1967: beacon implementation is not a contract"
608         );
609         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
610     }
611 
612     /**
613      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
614      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
615      *
616      * Emits a {BeaconUpgraded} event.
617      */
618     function _upgradeBeaconToAndCall(
619         address newBeacon,
620         bytes memory data,
621         bool forceCall
622     ) internal {
623         _setBeacon(newBeacon);
624         emit BeaconUpgraded(newBeacon);
625         if (data.length > 0 || forceCall) {
626             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
627         }
628     }
629 }
630 
631 
632 // File niy/proxy/beacon/BeaconProxy.sol
633 
634 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/beacon/BeaconProxy.sol)
635 
636 
637 
638 
639 /**
640  * @dev This contract implements a proxy that gets the implementation address for each call from an {UpgradeableBeacon}.
641  *
642  * The beacon address is stored in storage slot `uint256(keccak256('eip1967.proxy.beacon')) - 1`, so that it doesn't
643  * conflict with the storage layout of the implementation behind the proxy.
644  *
645  * _Available since v3.4._
646  */
647 contract BeaconProxy is Proxy, ERC1967Upgrade {
648     /**
649      * @dev Initializes the proxy with `beacon`.
650      *
651      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon. This
652      * will typically be an encoded function call, and allows initializing the storage of the proxy like a Solidity
653      * constructor.
654      *
655      * Requirements:
656      *
657      * - `beacon` must be a contract with the interface {IBeacon}.
658      */
659     constructor(address beacon, bytes memory data) payable {
660         _upgradeBeaconToAndCall(beacon, data, false);
661     }
662 
663     /**
664      * @dev Returns the current beacon address.
665      */
666     function _beacon() internal view virtual returns (address) {
667         return _getBeacon();
668     }
669 
670     /**
671      * @dev Returns the current implementation address of the associated beacon.
672      */
673     function _implementation() internal view virtual override returns (address) {
674         return IBeacon(_getBeacon()).implementation();
675     }
676 
677     /**
678      * @dev Changes the proxy to use a new beacon. Deprecated: see {_upgradeBeaconToAndCall}.
679      *
680      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon.
681      *
682      * Requirements:
683      *
684      * - `beacon` must be a contract.
685      * - The implementation returned by `beacon` must be a contract.
686      */
687     function _setBeacon(address beacon, bytes memory data) internal virtual {
688         _upgradeBeaconToAndCall(beacon, data, false);
689     }
690 }