1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.2;
3 
4 /**
5  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
6  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
7  * be specified by overriding the virtual {_implementation} function.
8  *
9  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
10  * different contract through the {_delegate} function.
11  *
12  * The success and return data of the delegated call will be returned back to the caller of the proxy.
13  */
14 abstract contract Proxy {
15     /**
16      * @dev Delegates the current call to `implementation`.
17      *
18      * This function does not return to its internall call site, it will return directly to the external caller.
19      */
20     function _delegate(address implementation) internal virtual {
21         assembly {
22             // Copy msg.data. We take full control of memory in this inline assembly
23             // block because it will not return to Solidity code. We overwrite the
24             // Solidity scratch pad at memory position 0.
25             calldatacopy(0, 0, calldatasize())
26 
27             // Call the implementation.
28             // out and outsize are 0 because we don't know the size yet.
29             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
30 
31             // Copy the returned data.
32             returndatacopy(0, 0, returndatasize())
33 
34             switch result
35             // delegatecall returns 0 on error.
36             case 0 {
37                 revert(0, returndatasize())
38             }
39             default {
40                 return(0, returndatasize())
41             }
42         }
43     }
44 
45     /**
46      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
47      * and {_fallback} should delegate.
48      */
49     function _implementation() internal view virtual returns (address);
50 
51     /**
52      * @dev Delegates the current call to the address returned by `_implementation()`.
53      *
54      * This function does not return to its internall call site, it will return directly to the external caller.
55      */
56     function _fallback() internal virtual {
57         _beforeFallback();
58         _delegate(_implementation());
59     }
60 
61     /**
62      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
63      * function in the contract matches the call data.
64      */
65     fallback() external payable virtual {
66         _fallback();
67     }
68 
69     /**
70      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
71      * is empty.
72      */
73     receive() external payable virtual {
74         _fallback();
75     }
76 
77     /**
78      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
79      * call, or as part of the Solidity `fallback` or `receive` functions.
80      *
81      * If overriden should call `super._beforeFallback()`.
82      */
83     function _beforeFallback() internal virtual {}
84 }
85 
86 /**
87  * @dev This is the interface that {BeaconProxy} expects of its beacon.
88  */
89 interface IBeacon {
90     /**
91      * @dev Must return an address that can be used as a delegate call target.
92      *
93      * {BeaconProxy} will check that this address is a contract.
94      */
95     function implementation() external view returns (address);
96 }
97 
98 /**
99  * @dev Collection of functions related to the address type
100  */
101 library Address {
102     /**
103      * @dev Returns true if `account` is a contract.
104      *
105      * [IMPORTANT]
106      * ====
107      * It is unsafe to assume that an address for which this function returns
108      * false is an externally-owned account (EOA) and not a contract.
109      *
110      * Among others, `isContract` will return false for the following
111      * types of addresses:
112      *
113      *  - an externally-owned account
114      *  - a contract in construction
115      *  - an address where a contract will be created
116      *  - an address where a contract lived, but was destroyed
117      * ====
118      */
119     function isContract(address account) internal view returns (bool) {
120         // This method relies on extcodesize, which returns 0 for contracts in
121         // construction, since the code is only stored at the end of the
122         // constructor execution.
123 
124         uint256 size;
125         assembly {
126             size := extcodesize(account)
127         }
128         return size > 0;
129     }
130 
131     /**
132      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
133      * `recipient`, forwarding all available gas and reverting on errors.
134      *
135      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
136      * of certain opcodes, possibly making contracts go over the 2300 gas limit
137      * imposed by `transfer`, making them unable to receive funds via
138      * `transfer`. {sendValue} removes this limitation.
139      *
140      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
141      *
142      * IMPORTANT: because control is transferred to `recipient`, care must be
143      * taken to not create reentrancy vulnerabilities. Consider using
144      * {ReentrancyGuard} or the
145      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
146      */
147     function sendValue(address payable recipient, uint256 amount) internal {
148         require(address(this).balance >= amount, "Address: insufficient balance");
149 
150         (bool success, ) = recipient.call{value: amount}("");
151         require(success, "Address: unable to send value, recipient may have reverted");
152     }
153 
154     /**
155      * @dev Performs a Solidity function call using a low level `call`. A
156      * plain `call` is an unsafe replacement for a function call: use this
157      * function instead.
158      *
159      * If `target` reverts with a revert reason, it is bubbled up by this
160      * function (like regular Solidity function calls).
161      *
162      * Returns the raw returned data. To convert to the expected return value,
163      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
164      *
165      * Requirements:
166      *
167      * - `target` must be a contract.
168      * - calling `target` with `data` must not revert.
169      *
170      * _Available since v3.1._
171      */
172     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionCall(target, data, "Address: low-level call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
178      * `errorMessage` as a fallback revert reason when `target` reverts.
179      *
180      * _Available since v3.1._
181      */
182     function functionCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         return functionCallWithValue(target, data, 0, errorMessage);
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
192      * but also transferring `value` wei to `target`.
193      *
194      * Requirements:
195      *
196      * - the calling contract must have an ETH balance of at least `value`.
197      * - the called Solidity function must be `payable`.
198      *
199      * _Available since v3.1._
200      */
201     function functionCallWithValue(
202         address target,
203         bytes memory data,
204         uint256 value
205     ) internal returns (bytes memory) {
206         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
211      * with `errorMessage` as a fallback revert reason when `target` reverts.
212      *
213      * _Available since v3.1._
214      */
215     function functionCallWithValue(
216         address target,
217         bytes memory data,
218         uint256 value,
219         string memory errorMessage
220     ) internal returns (bytes memory) {
221         require(address(this).balance >= value, "Address: insufficient balance for call");
222         require(isContract(target), "Address: call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.call{value: value}(data);
225         return verifyCallResult(success, returndata, errorMessage);
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
230      * but performing a static call.
231      *
232      * _Available since v3.3._
233      */
234     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
235         return functionStaticCall(target, data, "Address: low-level static call failed");
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
240      * but performing a static call.
241      *
242      * _Available since v3.3._
243      */
244     function functionStaticCall(
245         address target,
246         bytes memory data,
247         string memory errorMessage
248     ) internal view returns (bytes memory) {
249         require(isContract(target), "Address: static call to non-contract");
250 
251         (bool success, bytes memory returndata) = target.staticcall(data);
252         return verifyCallResult(success, returndata, errorMessage);
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
257      * but performing a delegate call.
258      *
259      * _Available since v3.4._
260      */
261     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
262         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
267      * but performing a delegate call.
268      *
269      * _Available since v3.4._
270      */
271     function functionDelegateCall(
272         address target,
273         bytes memory data,
274         string memory errorMessage
275     ) internal returns (bytes memory) {
276         require(isContract(target), "Address: delegate call to non-contract");
277 
278         (bool success, bytes memory returndata) = target.delegatecall(data);
279         return verifyCallResult(success, returndata, errorMessage);
280     }
281 
282     /**
283      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
284      * revert reason using the provided one.
285      *
286      * _Available since v4.3._
287      */
288     function verifyCallResult(
289         bool success,
290         bytes memory returndata,
291         string memory errorMessage
292     ) internal pure returns (bytes memory) {
293         if (success) {
294             return returndata;
295         } else {
296             // Look for revert reason and bubble it up if present
297             if (returndata.length > 0) {
298                 // The easiest way to bubble the revert reason is using memory via assembly
299 
300                 assembly {
301                     let returndata_size := mload(returndata)
302                     revert(add(32, returndata), returndata_size)
303                 }
304             } else {
305                 revert(errorMessage);
306             }
307         }
308     }
309 }
310 
311 /**
312  * @dev Library for reading and writing primitive types to specific storage slots.
313  *
314  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
315  * This library helps with reading and writing to such slots without the need for inline assembly.
316  *
317  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
318  *
319  * Example usage to set ERC1967 implementation slot:
320  * ```
321  * contract ERC1967 {
322  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
323  *
324  *     function _getImplementation() internal view returns (address) {
325  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
326  *     }
327  *
328  *     function _setImplementation(address newImplementation) internal {
329  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
330  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
331  *     }
332  * }
333  * ```
334  *
335  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
336  */
337 library StorageSlot {
338     struct AddressSlot {
339         address value;
340     }
341 
342     struct BooleanSlot {
343         bool value;
344     }
345 
346     struct Bytes32Slot {
347         bytes32 value;
348     }
349 
350     struct Uint256Slot {
351         uint256 value;
352     }
353 
354     /**
355      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
356      */
357     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
358         assembly {
359             r.slot := slot
360         }
361     }
362 
363     /**
364      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
365      */
366     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
367         assembly {
368             r.slot := slot
369         }
370     }
371 
372     /**
373      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
374      */
375     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
376         assembly {
377             r.slot := slot
378         }
379     }
380 
381     /**
382      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
383      */
384     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
385         assembly {
386             r.slot := slot
387         }
388     }
389 }
390 
391 
392 
393 
394 /**
395  * @dev This abstract contract provides getters and event emitting update functions for
396  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
397  *
398  * _Available since v4.1._
399  *
400  * @custom:oz-upgrades-unsafe-allow delegatecall
401  */
402 abstract contract ERC1967Upgrade {
403     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
404     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
405 
406     /**
407      * @dev Storage slot with the address of the current implementation.
408      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
409      * validated in the constructor.
410      */
411     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
412 
413     /**
414      * @dev Emitted when the implementation is upgraded.
415      */
416     event Upgraded(address indexed implementation);
417 
418     /**
419      * @dev Returns the current implementation address.
420      */
421     function _getImplementation() internal view returns (address) {
422         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
423     }
424 
425     /**
426      * @dev Stores a new address in the EIP1967 implementation slot.
427      */
428     function _setImplementation(address newImplementation) private {
429         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
430         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
431     }
432 
433     /**
434      * @dev Perform implementation upgrade
435      *
436      * Emits an {Upgraded} event.
437      */
438     function _upgradeTo(address newImplementation) internal {
439         _setImplementation(newImplementation);
440         emit Upgraded(newImplementation);
441     }
442 
443     /**
444      * @dev Perform implementation upgrade with additional setup call.
445      *
446      * Emits an {Upgraded} event.
447      */
448     function _upgradeToAndCall(
449         address newImplementation,
450         bytes memory data,
451         bool forceCall
452     ) internal {
453         _upgradeTo(newImplementation);
454         if (data.length > 0 || forceCall) {
455             Address.functionDelegateCall(newImplementation, data);
456         }
457     }
458 
459     /**
460      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
461      *
462      * Emits an {Upgraded} event.
463      */
464     function _upgradeToAndCallSecure(
465         address newImplementation,
466         bytes memory data,
467         bool forceCall
468     ) internal {
469         address oldImplementation = _getImplementation();
470 
471         // Initial upgrade and setup call
472         _setImplementation(newImplementation);
473         if (data.length > 0 || forceCall) {
474             Address.functionDelegateCall(newImplementation, data);
475         }
476 
477         // Perform rollback test if not already in progress
478         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
479         if (!rollbackTesting.value) {
480             // Trigger rollback using upgradeTo from the new implementation
481             rollbackTesting.value = true;
482             Address.functionDelegateCall(
483                 newImplementation,
484                 abi.encodeWithSignature("upgradeTo(address)", oldImplementation)
485             );
486             rollbackTesting.value = false;
487             // Check rollback was effective
488             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
489             // Finally reset to the new implementation and log the upgrade
490             _upgradeTo(newImplementation);
491         }
492     }
493 
494     /**
495      * @dev Storage slot with the admin of the contract.
496      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
497      * validated in the constructor.
498      */
499     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
500 
501     /**
502      * @dev Emitted when the admin account has changed.
503      */
504     event AdminChanged(address previousAdmin, address newAdmin);
505 
506     /**
507      * @dev Returns the current admin.
508      */
509     function _getAdmin() internal view returns (address) {
510         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
511     }
512 
513     /**
514      * @dev Stores a new address in the EIP1967 admin slot.
515      */
516     function _setAdmin(address newAdmin) private {
517         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
518         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
519     }
520 
521     /**
522      * @dev Changes the admin of the proxy.
523      *
524      * Emits an {AdminChanged} event.
525      */
526     function _changeAdmin(address newAdmin) internal {
527         emit AdminChanged(_getAdmin(), newAdmin);
528         _setAdmin(newAdmin);
529     }
530 
531     /**
532      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
533      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
534      */
535     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
536 
537     /**
538      * @dev Emitted when the beacon is upgraded.
539      */
540     event BeaconUpgraded(address indexed beacon);
541 
542     /**
543      * @dev Returns the current beacon.
544      */
545     function _getBeacon() internal view returns (address) {
546         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
547     }
548 
549     /**
550      * @dev Stores a new beacon in the EIP1967 beacon slot.
551      */
552     function _setBeacon(address newBeacon) private {
553         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
554         require(
555             Address.isContract(IBeacon(newBeacon).implementation()),
556             "ERC1967: beacon implementation is not a contract"
557         );
558         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
559     }
560 
561     /**
562      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
563      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
564      *
565      * Emits a {BeaconUpgraded} event.
566      */
567     function _upgradeBeaconToAndCall(
568         address newBeacon,
569         bytes memory data,
570         bool forceCall
571     ) internal {
572         _setBeacon(newBeacon);
573         emit BeaconUpgraded(newBeacon);
574         if (data.length > 0 || forceCall) {
575             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
576         }
577     }
578 }
579 
580 
581 /**
582  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
583  * implementation address that can be changed. This address is stored in storage in the location specified by
584  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
585  * implementation behind the proxy.
586  */
587 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
588     /**
589      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
590      *
591      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
592      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
593      */
594     constructor(address _logic, bytes memory _data) payable {
595         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
596         _upgradeToAndCall(_logic, _data, false);
597     }
598 
599     /**
600      * @dev Returns the current implementation address.
601      */
602     function _implementation() internal view virtual override returns (address impl) {
603         return ERC1967Upgrade._getImplementation();
604     }
605 }
606 
607 /**
608  * @dev This contract implements a proxy that is upgradeable by an admin.
609  *
610  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
611  * clashing], which can potentially be used in an attack, this contract uses the
612  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
613  * things that go hand in hand:
614  *
615  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
616  * that call matches one of the admin functions exposed by the proxy itself.
617  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
618  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
619  * "admin cannot fallback to proxy target".
620  *
621  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
622  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
623  * to sudden errors when trying to call a function from the proxy implementation.
624  *
625  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
626  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
627  */
628 contract TransparentUpgradeableProxy is ERC1967Proxy {
629     /**
630      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
631      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
632      */
633     constructor(
634         address _logic,
635         address admin_,
636         bytes memory _data
637     ) payable ERC1967Proxy(_logic, _data) {
638         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
639         _changeAdmin(admin_);
640     }
641 
642     /**
643      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
644      */
645     modifier ifAdmin() {
646         if (msg.sender == _getAdmin()) {
647             _;
648         } else {
649             _fallback();
650         }
651     }
652 
653     /**
654      * @dev Returns the current admin.
655      *
656      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
657      *
658      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
659      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
660      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
661      */
662     function admin() external ifAdmin returns (address admin_) {
663         admin_ = _getAdmin();
664     }
665 
666     /**
667      * @dev Returns the current implementation.
668      *
669      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
670      *
671      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
672      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
673      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
674      */
675     function implementation() external ifAdmin returns (address implementation_) {
676         implementation_ = _implementation();
677     }
678 
679     /**
680      * @dev Changes the admin of the proxy.
681      *
682      * Emits an {AdminChanged} event.
683      *
684      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
685      */
686     function changeAdmin(address newAdmin) external virtual ifAdmin {
687         _changeAdmin(newAdmin);
688     }
689 
690     /**
691      * @dev Upgrade the implementation of the proxy.
692      *
693      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
694      */
695     function upgradeTo(address newImplementation) external ifAdmin {
696         _upgradeToAndCall(newImplementation, bytes(""), false);
697     }
698 
699     /**
700      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
701      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
702      * proxied contract.
703      *
704      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
705      */
706     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
707         _upgradeToAndCall(newImplementation, data, true);
708     }
709 
710     /**
711      * @dev Returns the current admin.
712      */
713     function _admin() internal view virtual returns (address) {
714         return _getAdmin();
715     }
716 
717     /**
718      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
719      */
720     function _beforeFallback() internal virtual override {
721         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
722         super._beforeFallback();
723     }
724 }
725 
726 
727 
728 contract OogaVerseERC721Proxy is TransparentUpgradeableProxy {
729     constructor(
730         address _logic,
731         address admin_,
732         bytes memory _data
733     ) TransparentUpgradeableProxy(_logic, admin_, _data) {
734 
735     }
736 }