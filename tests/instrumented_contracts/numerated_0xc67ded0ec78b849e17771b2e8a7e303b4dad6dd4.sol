1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.3;
4 
5 
6 
7 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         assembly {
37             size := extcodesize(account)
38         }
39         return size > 0;
40     }
41 
42     /**
43      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
44      * `recipient`, forwarding all available gas and reverting on errors.
45      *
46      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
47      * of certain opcodes, possibly making contracts go over the 2300 gas limit
48      * imposed by `transfer`, making them unable to receive funds via
49      * `transfer`. {sendValue} removes this limitation.
50      *
51      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
52      *
53      * IMPORTANT: because control is transferred to `recipient`, care must be
54      * taken to not create reentrancy vulnerabilities. Consider using
55      * {ReentrancyGuard} or the
56      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
57      */
58     function sendValue(address payable recipient, uint256 amount) internal {
59         require(address(this).balance >= amount, "Address: insufficient balance");
60 
61         (bool success, ) = recipient.call{value: amount}("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain `call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84         return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(
94         address target,
95         bytes memory data,
96         string memory errorMessage
97     ) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, 0, errorMessage);
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
103      * but also transferring `value` wei to `target`.
104      *
105      * Requirements:
106      *
107      * - the calling contract must have an ETH balance of at least `value`.
108      * - the called Solidity function must be `payable`.
109      *
110      * _Available since v3.1._
111      */
112     function functionCallWithValue(
113         address target,
114         bytes memory data,
115         uint256 value
116     ) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
118     }
119 
120     /**
121      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
122      * with `errorMessage` as a fallback revert reason when `target` reverts.
123      *
124      * _Available since v3.1._
125      */
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value,
130         string memory errorMessage
131     ) internal returns (bytes memory) {
132         require(address(this).balance >= value, "Address: insufficient balance for call");
133         require(isContract(target), "Address: call to non-contract");
134 
135         (bool success, bytes memory returndata) = target.call{value: value}(data);
136         return verifyCallResult(success, returndata, errorMessage);
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
141      * but performing a static call.
142      *
143      * _Available since v3.3._
144      */
145     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
146         return functionStaticCall(target, data, "Address: low-level static call failed");
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
151      * but performing a static call.
152      *
153      * _Available since v3.3._
154      */
155     function functionStaticCall(
156         address target,
157         bytes memory data,
158         string memory errorMessage
159     ) internal view returns (bytes memory) {
160         require(isContract(target), "Address: static call to non-contract");
161 
162         (bool success, bytes memory returndata) = target.staticcall(data);
163         return verifyCallResult(success, returndata, errorMessage);
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
168      * but performing a delegate call.
169      *
170      * _Available since v3.4._
171      */
172     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
178      * but performing a delegate call.
179      *
180      * _Available since v3.4._
181      */
182     function functionDelegateCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(isContract(target), "Address: delegate call to non-contract");
188 
189         (bool success, bytes memory returndata) = target.delegatecall(data);
190         return verifyCallResult(success, returndata, errorMessage);
191     }
192 
193     /**
194      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
195      * revert reason using the provided one.
196      *
197      * _Available since v4.3._
198      */
199     function verifyCallResult(
200         bool success,
201         bytes memory returndata,
202         string memory errorMessage
203     ) internal pure returns (bytes memory) {
204         if (success) {
205             return returndata;
206         } else {
207             // Look for revert reason and bubble it up if present
208             if (returndata.length > 0) {
209                 // The easiest way to bubble the revert reason is using memory via assembly
210 
211                 assembly {
212                     let returndata_size := mload(returndata)
213                     revert(add(32, returndata), returndata_size)
214                 }
215             } else {
216                 revert(errorMessage);
217             }
218         }
219     }
220 }
221 
222 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IBeacon
223 
224 /**
225  * @dev This is the interface that {BeaconProxy} expects of its beacon.
226  */
227 interface IBeacon {
228     /**
229      * @dev Must return an address that can be used as a delegate call target.
230      *
231      * {BeaconProxy} will check that this address is a contract.
232      */
233     function implementation() external view returns (address);
234 }
235 
236 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/Proxy
237 
238 /**
239  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
240  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
241  * be specified by overriding the virtual {_implementation} function.
242  *
243  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
244  * different contract through the {_delegate} function.
245  *
246  * The success and return data of the delegated call will be returned back to the caller of the proxy.
247  */
248 abstract contract Proxy {
249     /**
250      * @dev Delegates the current call to `implementation`.
251      *
252      * This function does not return to its internall call site, it will return directly to the external caller.
253      */
254     function _delegate(address implementation) internal virtual {
255         assembly {
256             // Copy msg.data. We take full control of memory in this inline assembly
257             // block because it will not return to Solidity code. We overwrite the
258             // Solidity scratch pad at memory position 0.
259             calldatacopy(0, 0, calldatasize())
260 
261             // Call the implementation.
262             // out and outsize are 0 because we don't know the size yet.
263             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
264 
265             // Copy the returned data.
266             returndatacopy(0, 0, returndatasize())
267 
268             switch result
269             // delegatecall returns 0 on error.
270             case 0 {
271                 revert(0, returndatasize())
272             }
273             default {
274                 return(0, returndatasize())
275             }
276         }
277     }
278 
279     /**
280      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
281      * and {_fallback} should delegate.
282      */
283     function _implementation() internal view virtual returns (address);
284 
285     /**
286      * @dev Delegates the current call to the address returned by `_implementation()`.
287      *
288      * This function does not return to its internall call site, it will return directly to the external caller.
289      */
290     function _fallback() internal virtual {
291         _beforeFallback();
292         _delegate(_implementation());
293     }
294 
295     /**
296      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
297      * function in the contract matches the call data.
298      */
299     fallback() external payable virtual {
300         _fallback();
301     }
302 
303     /**
304      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
305      * is empty.
306      */
307     receive() external payable virtual {
308         _fallback();
309     }
310 
311     /**
312      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
313      * call, or as part of the Solidity `fallback` or `receive` functions.
314      *
315      * If overriden should call `super._beforeFallback()`.
316      */
317     function _beforeFallback() internal virtual {}
318 }
319 
320 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/StorageSlot
321 
322 /**
323  * @dev Library for reading and writing primitive types to specific storage slots.
324  *
325  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
326  * This library helps with reading and writing to such slots without the need for inline assembly.
327  *
328  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
329  *
330  * Example usage to set ERC1967 implementation slot:
331  * ```
332  * contract ERC1967 {
333  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
334  *
335  *     function _getImplementation() internal view returns (address) {
336  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
337  *     }
338  *
339  *     function _setImplementation(address newImplementation) internal {
340  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
341  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
342  *     }
343  * }
344  * ```
345  *
346  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
347  */
348 library StorageSlot {
349     struct AddressSlot {
350         address value;
351     }
352 
353     struct BooleanSlot {
354         bool value;
355     }
356 
357     struct Bytes32Slot {
358         bytes32 value;
359     }
360 
361     struct Uint256Slot {
362         uint256 value;
363     }
364 
365     /**
366      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
367      */
368     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
369         assembly {
370             r.slot := slot
371         }
372     }
373 
374     /**
375      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
376      */
377     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
378         assembly {
379             r.slot := slot
380         }
381     }
382 
383     /**
384      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
385      */
386     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
387         assembly {
388             r.slot := slot
389         }
390     }
391 
392     /**
393      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
394      */
395     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
396         assembly {
397             r.slot := slot
398         }
399     }
400 }
401 
402 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/ERC1967Upgrade
403 
404 /**
405  * @dev This abstract contract provides getters and event emitting update functions for
406  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
407  *
408  * _Available since v4.1._
409  *
410  * @custom:oz-upgrades-unsafe-allow delegatecall
411  */
412 abstract contract ERC1967Upgrade {
413     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
414     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
415 
416     /**
417      * @dev Storage slot with the address of the current implementation.
418      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
419      * validated in the constructor.
420      */
421     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
422 
423     /**
424      * @dev Emitted when the implementation is upgraded.
425      */
426     event Upgraded(address indexed implementation);
427 
428     /**
429      * @dev Returns the current implementation address.
430      */
431     function _getImplementation() internal view returns (address) {
432         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
433     }
434 
435     /**
436      * @dev Stores a new address in the EIP1967 implementation slot.
437      */
438     function _setImplementation(address newImplementation) private {
439         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
440         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
441     }
442 
443     /**
444      * @dev Perform implementation upgrade
445      *
446      * Emits an {Upgraded} event.
447      */
448     function _upgradeTo(address newImplementation) internal {
449         _setImplementation(newImplementation);
450         emit Upgraded(newImplementation);
451     }
452 
453     /**
454      * @dev Perform implementation upgrade with additional setup call.
455      *
456      * Emits an {Upgraded} event.
457      */
458     function _upgradeToAndCall(
459         address newImplementation,
460         bytes memory data,
461         bool forceCall
462     ) internal {
463         _upgradeTo(newImplementation);
464         if (data.length > 0 || forceCall) {
465             Address.functionDelegateCall(newImplementation, data);
466         }
467     }
468 
469     /**
470      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
471      *
472      * Emits an {Upgraded} event.
473      */
474     function _upgradeToAndCallSecure(
475         address newImplementation,
476         bytes memory data,
477         bool forceCall
478     ) internal {
479         address oldImplementation = _getImplementation();
480 
481         // Initial upgrade and setup call
482         _setImplementation(newImplementation);
483         if (data.length > 0 || forceCall) {
484             Address.functionDelegateCall(newImplementation, data);
485         }
486 
487         // Perform rollback test if not already in progress
488         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
489         if (!rollbackTesting.value) {
490             // Trigger rollback using upgradeTo from the new implementation
491             rollbackTesting.value = true;
492             Address.functionDelegateCall(
493                 newImplementation,
494                 abi.encodeWithSignature("upgradeTo(address)", oldImplementation)
495             );
496             rollbackTesting.value = false;
497             // Check rollback was effective
498             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
499             // Finally reset to the new implementation and log the upgrade
500             _upgradeTo(newImplementation);
501         }
502     }
503 
504     /**
505      * @dev Storage slot with the admin of the contract.
506      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
507      * validated in the constructor.
508      */
509     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
510 
511     /**
512      * @dev Emitted when the admin account has changed.
513      */
514     event AdminChanged(address previousAdmin, address newAdmin);
515 
516     /**
517      * @dev Returns the current admin.
518      */
519     function _getAdmin() internal view returns (address) {
520         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
521     }
522 
523     /**
524      * @dev Stores a new address in the EIP1967 admin slot.
525      */
526     function _setAdmin(address newAdmin) private {
527         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
528         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
529     }
530 
531     /**
532      * @dev Changes the admin of the proxy.
533      *
534      * Emits an {AdminChanged} event.
535      */
536     function _changeAdmin(address newAdmin) internal {
537         emit AdminChanged(_getAdmin(), newAdmin);
538         _setAdmin(newAdmin);
539     }
540 
541     /**
542      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
543      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
544      */
545     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
546 
547     /**
548      * @dev Emitted when the beacon is upgraded.
549      */
550     event BeaconUpgraded(address indexed beacon);
551 
552     /**
553      * @dev Returns the current beacon.
554      */
555     function _getBeacon() internal view returns (address) {
556         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
557     }
558 
559     /**
560      * @dev Stores a new beacon in the EIP1967 beacon slot.
561      */
562     function _setBeacon(address newBeacon) private {
563         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
564         require(
565             Address.isContract(IBeacon(newBeacon).implementation()),
566             "ERC1967: beacon implementation is not a contract"
567         );
568         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
569     }
570 
571     /**
572      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
573      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
574      *
575      * Emits a {BeaconUpgraded} event.
576      */
577     function _upgradeBeaconToAndCall(
578         address newBeacon,
579         bytes memory data,
580         bool forceCall
581     ) internal {
582         _setBeacon(newBeacon);
583         emit BeaconUpgraded(newBeacon);
584         if (data.length > 0 || forceCall) {
585             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
586         }
587     }
588 }
589 
590 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/ERC1967Proxy
591 
592 /**
593  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
594  * implementation address that can be changed. This address is stored in storage in the location specified by
595  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
596  * implementation behind the proxy.
597  */
598 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
599     /**
600      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
601      *
602      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
603      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
604      */
605     constructor(address _logic, bytes memory _data) payable {
606         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
607         _upgradeToAndCall(_logic, _data, false);
608     }
609 
610     /**
611      * @dev Returns the current implementation address.
612      */
613     function _implementation() internal view virtual override returns (address impl) {
614         return ERC1967Upgrade._getImplementation();
615     }
616 }
617 
618 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/TransparentUpgradeableProxy
619 
620 /**
621  * @dev This contract implements a proxy that is upgradeable by an admin.
622  *
623  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
624  * clashing], which can potentially be used in an attack, this contract uses the
625  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
626  * things that go hand in hand:
627  *
628  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
629  * that call matches one of the admin functions exposed by the proxy itself.
630  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
631  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
632  * "admin cannot fallback to proxy target".
633  *
634  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
635  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
636  * to sudden errors when trying to call a function from the proxy implementation.
637  *
638  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
639  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
640  */
641 contract TransparentUpgradeableProxy is ERC1967Proxy {
642     /**
643      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
644      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
645      */
646     constructor(
647         address _logic,
648         address admin_,
649         bytes memory _data
650     ) payable ERC1967Proxy(_logic, _data) {
651         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
652         _changeAdmin(admin_);
653     }
654 
655     /**
656      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
657      */
658     modifier ifAdmin() {
659         if (msg.sender == _getAdmin()) {
660             _;
661         } else {
662             _fallback();
663         }
664     }
665 
666     /**
667      * @dev Returns the current admin.
668      *
669      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
670      *
671      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
672      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
673      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
674      */
675     function admin() external ifAdmin returns (address admin_) {
676         admin_ = _getAdmin();
677     }
678 
679     /**
680      * @dev Returns the current implementation.
681      *
682      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
683      *
684      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
685      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
686      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
687      */
688     function implementation() external ifAdmin returns (address implementation_) {
689         implementation_ = _implementation();
690     }
691 
692     /**
693      * @dev Changes the admin of the proxy.
694      *
695      * Emits an {AdminChanged} event.
696      *
697      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
698      */
699     function changeAdmin(address newAdmin) external virtual ifAdmin {
700         _changeAdmin(newAdmin);
701     }
702 
703     /**
704      * @dev Upgrade the implementation of the proxy.
705      *
706      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
707      */
708     function upgradeTo(address newImplementation) external ifAdmin {
709         _upgradeToAndCall(newImplementation, bytes(""), false);
710     }
711 
712     /**
713      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
714      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
715      * proxied contract.
716      *
717      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
718      */
719     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
720         _upgradeToAndCall(newImplementation, data, true);
721     }
722 
723     /**
724      * @dev Returns the current admin.
725      */
726     function _admin() internal view virtual returns (address) {
727         return _getAdmin();
728     }
729 
730     /**
731      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
732      */
733     function _beforeFallback() internal virtual override {
734         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
735         super._beforeFallback();
736     }
737 }
738 
739 // File: ProvablyRareGemProxy.sol
740 
741 contract ProvablyRareGemProxy is TransparentUpgradeableProxy {
742   constructor(
743     address _logic,
744     address admin_,
745     bytes memory _data
746   ) payable TransparentUpgradeableProxy(_logic, admin_, _data) {}
747 }
