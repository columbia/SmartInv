1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.5.0-rc.0) (proxy/Proxy.sol)
3 
4 pragma solidity 0.8.13;
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
24         // Copy msg.data. We take full control of memory in this inline assembly
25         // block because it will not return to Solidity code. We overwrite the
26         // Solidity scratch pad at memory position 0.
27             calldatacopy(0, 0, calldatasize())
28 
29         // Call the implementation.
30         // out and outsize are 0 because we don't know the size yet.
31             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
32 
33         // Copy the returned data.
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
87 
88 
89 // File contracts/proxy/OptimizeProxy/IBeacon.sol
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
102 
103 
104 // File contracts/proxy/OptimizeProxy/draft-IERC1822.sol
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
121 
122 
123 // File contracts/proxy/OptimizeProxy/Address.sol
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
342 
343 
344 // File contracts/proxy/OptimizeProxy/StorageSlot.sol
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
426 
427 // File contracts/proxy/OptimizeProxy/ERC1967Upgrade.sol
428 
429 
430 /**
431  * @dev This abstract contract provides getters and event emitting update functions for
432  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
433  *
434  * _Available since v4.1._
435  *
436  * @custom:oz-upgrades-unsafe-allow delegatecall
437  */
438 abstract contract ERC1967Upgrade {
439     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
440     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
441 
442     /**
443      * @dev Storage slot with the address of the current implementation.
444      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
445      * validated in the constructor.
446      */
447     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
448 
449     /**
450      * @dev Emitted when the implementation is upgraded.
451      */
452     event Upgraded(address indexed implementation);
453 
454     /**
455      * @dev Returns the current implementation address.
456      */
457     function _getImplementation() internal view returns (address) {
458         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
459     }
460 
461     /**
462      * @dev Stores a new address in the EIP1967 implementation slot.
463      */
464     function _setImplementation(address newImplementation) private {
465         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
466         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
467     }
468 
469     /**
470      * @dev Perform implementation upgrade
471      *
472      * Emits an {Upgraded} event.
473      */
474     function _upgradeTo(address newImplementation) internal {
475         _setImplementation(newImplementation);
476         emit Upgraded(newImplementation);
477     }
478 
479     /**
480      * @dev Perform implementation upgrade with additional setup call.
481      *
482      * Emits an {Upgraded} event.
483      */
484     function _upgradeToAndCall(
485         address newImplementation,
486         bytes memory data,
487         bool forceCall
488     ) internal {
489         _upgradeTo(newImplementation);
490         if (data.length > 0 || forceCall) {
491             Address.functionDelegateCall(newImplementation, data);
492         }
493     }
494 
495     /**
496      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
497      *
498      * Emits an {Upgraded} event.
499      */
500     function _upgradeToAndCallUUPS(
501         address newImplementation,
502         bytes memory data,
503         bool forceCall
504     ) internal {
505         // Upgrades from old implementations will perform a rollback test. This test requires the new
506         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
507         // this special case will break upgrade paths from old UUPS implementation to new ones.
508         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
509             _setImplementation(newImplementation);
510         } else {
511             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
512                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
513             } catch {
514                 revert("ERC1967Upgrade: new implementation is not UUPS");
515             }
516             _upgradeToAndCall(newImplementation, data, forceCall);
517         }
518     }
519 
520     /**
521      * @dev Storage slot with the admin of the contract.
522      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
523      * validated in the constructor.
524      */
525     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
526 
527     /**
528      * @dev Emitted when the admin account has changed.
529      */
530     event AdminChanged(address previousAdmin, address newAdmin);
531 
532     /**
533      * @dev Returns the current admin.
534      */
535     function _getAdmin() internal view virtual returns (address) {
536         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
537     }
538 
539     /**
540      * @dev Stores a new address in the EIP1967 admin slot.
541      */
542     function _setAdmin(address newAdmin) private {
543         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
544         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
545     }
546 
547     /**
548      * @dev Changes the admin of the proxy.
549      *
550      * Emits an {AdminChanged} event.
551      */
552     function _changeAdmin(address newAdmin) internal {
553         emit AdminChanged(_getAdmin(), newAdmin);
554         _setAdmin(newAdmin);
555     }
556 
557     /**
558      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
559      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
560      */
561     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
562 
563     /**
564      * @dev Emitted when the beacon is upgraded.
565      */
566     event BeaconUpgraded(address indexed beacon);
567 
568     /**
569      * @dev Returns the current beacon.
570      */
571     function _getBeacon() internal view returns (address) {
572         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
573     }
574 
575     /**
576      * @dev Stores a new beacon in the EIP1967 beacon slot.
577      */
578     function _setBeacon(address newBeacon) private {
579         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
580         require(Address.isContract(IBeacon(newBeacon).implementation()), "ERC1967: beacon implementation is not a contract");
581         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
582     }
583 
584     /**
585      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
586      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
587      *
588      * Emits a {BeaconUpgraded} event.
589      */
590     function _upgradeBeaconToAndCall(
591         address newBeacon,
592         bytes memory data,
593         bool forceCall
594     ) internal {
595         _setBeacon(newBeacon);
596         emit BeaconUpgraded(newBeacon);
597         if (data.length > 0 || forceCall) {
598             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
599         }
600     }
601 }
602 
603 
604 // File contracts/proxy/OptimizeProxy/ERC1967Proxy.sol
605 
606 /**
607  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
608  * implementation address that can be changed. This address is stored in storage in the location specified by
609  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
610  * implementation behind the proxy.
611  */
612 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
613     /**
614      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
615      *
616      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
617      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
618      */
619     constructor(address _logic, bytes memory _data) payable {
620         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
621         _upgradeToAndCall(_logic, _data, false);
622     }
623 
624     /**
625      * @dev Returns the current implementation address.
626      */
627     function _implementation() internal view virtual override returns (address impl) {
628         return ERC1967Upgrade._getImplementation();
629     }
630 }
631 
632 
633 // File contracts/proxy/OptimizeProxy/OptimizedTransparentUpgradeableProxy.sol
634 
635 /**
636  * @dev This contract implements a proxy that is upgradeable by an admin.
637  *
638  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
639  * clashing], which can potentially be used in an attack, this contract uses the
640  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
641  * things that go hand in hand:
642  *
643  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
644  * that call matches one of the admin functions exposed by the proxy itself.
645  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
646  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
647  * "admin cannot fallback to proxy target".
648  *
649  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
650  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
651  * to sudden errors when trying to call a function from the proxy implementation.
652  *
653  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
654  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
655  */
656 contract OptimizedTransparentUpgradeableProxy is ERC1967Proxy {
657     address internal immutable _ADMIN;
658 
659     /**
660      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
661      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
662      */
663     constructor(
664         address _logic,
665         address admin_,
666         bytes memory _data
667     ) payable ERC1967Proxy(_logic, _data) {
668         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
669         _ADMIN = admin_;
670 
671         // still store it to work with EIP-1967
672         bytes32 slot = _ADMIN_SLOT;
673         // solhint-disable-next-line no-inline-assembly
674         assembly {
675             sstore(slot, admin_)
676         }
677         emit AdminChanged(address(0), admin_);
678     }
679 
680     /**
681      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
682      */
683     modifier ifAdmin() {
684         if (msg.sender == _getAdmin()) {
685             _;
686         } else {
687             _fallback();
688         }
689     }
690 
691     /**
692      * @dev Returns the current admin.
693      *
694      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
695      *
696      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
697      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
698      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
699      */
700     function admin() external ifAdmin returns (address admin_) {
701         admin_ = _getAdmin();
702     }
703 
704     /**
705      * @dev Returns the current implementation.
706      *
707      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
708      *
709      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
710      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
711      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
712      */
713     function implementation() external ifAdmin returns (address implementation_) {
714         implementation_ = _implementation();
715     }
716 
717     /**
718      * @dev Upgrade the implementation of the proxy.
719      *
720      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
721      */
722     function upgradeTo(address newImplementation) external ifAdmin {
723         _upgradeToAndCall(newImplementation, bytes(""), false);
724     }
725 
726     /**
727      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
728      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
729      * proxied contract.
730      *
731      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
732      */
733     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
734         _upgradeToAndCall(newImplementation, data, true);
735     }
736 
737     /**
738      * @dev Returns the current admin.
739      */
740     function _admin() internal view virtual returns (address) {
741         return _getAdmin();
742     }
743 
744     /**
745      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
746      */
747     function _beforeFallback() internal virtual override {
748         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
749         super._beforeFallback();
750     }
751 
752     function _getAdmin() internal view virtual override returns (address) {
753         return _ADMIN;
754     }
755 }