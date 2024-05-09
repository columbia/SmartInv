1 // Sources flattened with hardhat v2.6.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/proxy/Proxy.sol@v4.3.2
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
11  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
12  * be specified by overriding the virtual {_implementation} function.
13  *
14  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
15  * different contract through the {_delegate} function.
16  *
17  * The success and return data of the delegated call will be returned back to the caller of the proxy.
18  */
19 abstract contract Proxy {
20     /**
21      * @dev Delegates the current call to `implementation`.
22      *
23      * This function does not return to its internall call site, it will return directly to the external caller.
24      */
25     function _delegate(address implementation) internal virtual {
26         assembly {
27             // Copy msg.data. We take full control of memory in this inline assembly
28             // block because it will not return to Solidity code. We overwrite the
29             // Solidity scratch pad at memory position 0.
30             calldatacopy(0, 0, calldatasize())
31 
32             // Call the implementation.
33             // out and outsize are 0 because we don't know the size yet.
34             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
35 
36             // Copy the returned data.
37             returndatacopy(0, 0, returndatasize())
38 
39             switch result
40             // delegatecall returns 0 on error.
41             case 0 {
42                 revert(0, returndatasize())
43             }
44             default {
45                 return(0, returndatasize())
46             }
47         }
48     }
49 
50     /**
51      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
52      * and {_fallback} should delegate.
53      */
54     function _implementation() internal view virtual returns (address);
55 
56     /**
57      * @dev Delegates the current call to the address returned by `_implementation()`.
58      *
59      * This function does not return to its internall call site, it will return directly to the external caller.
60      */
61     function _fallback() internal virtual {
62         _beforeFallback();
63         _delegate(_implementation());
64     }
65 
66     /**
67      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
68      * function in the contract matches the call data.
69      */
70     fallback() external payable virtual {
71         _fallback();
72     }
73 
74     /**
75      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
76      * is empty.
77      */
78     receive() external payable virtual {
79         _fallback();
80     }
81 
82     /**
83      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
84      * call, or as part of the Solidity `fallback` or `receive` functions.
85      *
86      * If overriden should call `super._beforeFallback()`.
87      */
88     function _beforeFallback() internal virtual {}
89 }
90 
91 
92 // File @openzeppelin/contracts/proxy/beacon/IBeacon.sol@v4.3.2
93 
94 
95 
96 pragma solidity ^0.8.0;
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
111 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
112 
113 
114 
115 pragma solidity ^0.8.0;
116 
117 /**
118  * @dev Collection of functions related to the address type
119  */
120 library Address {
121     /**
122      * @dev Returns true if `account` is a contract.
123      *
124      * [IMPORTANT]
125      * ====
126      * It is unsafe to assume that an address for which this function returns
127      * false is an externally-owned account (EOA) and not a contract.
128      *
129      * Among others, `isContract` will return false for the following
130      * types of addresses:
131      *
132      *  - an externally-owned account
133      *  - a contract in construction
134      *  - an address where a contract will be created
135      *  - an address where a contract lived, but was destroyed
136      * ====
137      */
138     function isContract(address account) internal view returns (bool) {
139         // This method relies on extcodesize, which returns 0 for contracts in
140         // construction, since the code is only stored at the end of the
141         // constructor execution.
142 
143         uint256 size;
144         assembly {
145             size := extcodesize(account)
146         }
147         return size > 0;
148     }
149 
150     /**
151      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
152      * `recipient`, forwarding all available gas and reverting on errors.
153      *
154      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
155      * of certain opcodes, possibly making contracts go over the 2300 gas limit
156      * imposed by `transfer`, making them unable to receive funds via
157      * `transfer`. {sendValue} removes this limitation.
158      *
159      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
160      *
161      * IMPORTANT: because control is transferred to `recipient`, care must be
162      * taken to not create reentrancy vulnerabilities. Consider using
163      * {ReentrancyGuard} or the
164      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
165      */
166     function sendValue(address payable recipient, uint256 amount) internal {
167         require(address(this).balance >= amount, "Address: insufficient balance");
168 
169         (bool success, ) = recipient.call{value: amount}("");
170         require(success, "Address: unable to send value, recipient may have reverted");
171     }
172 
173     /**
174      * @dev Performs a Solidity function call using a low level `call`. A
175      * plain `call` is an unsafe replacement for a function call: use this
176      * function instead.
177      *
178      * If `target` reverts with a revert reason, it is bubbled up by this
179      * function (like regular Solidity function calls).
180      *
181      * Returns the raw returned data. To convert to the expected return value,
182      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
183      *
184      * Requirements:
185      *
186      * - `target` must be a contract.
187      * - calling `target` with `data` must not revert.
188      *
189      * _Available since v3.1._
190      */
191     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
192         return functionCall(target, data, "Address: low-level call failed");
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
197      * `errorMessage` as a fallback revert reason when `target` reverts.
198      *
199      * _Available since v3.1._
200      */
201     function functionCall(
202         address target,
203         bytes memory data,
204         string memory errorMessage
205     ) internal returns (bytes memory) {
206         return functionCallWithValue(target, data, 0, errorMessage);
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
211      * but also transferring `value` wei to `target`.
212      *
213      * Requirements:
214      *
215      * - the calling contract must have an ETH balance of at least `value`.
216      * - the called Solidity function must be `payable`.
217      *
218      * _Available since v3.1._
219      */
220     function functionCallWithValue(
221         address target,
222         bytes memory data,
223         uint256 value
224     ) internal returns (bytes memory) {
225         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
230      * with `errorMessage` as a fallback revert reason when `target` reverts.
231      *
232      * _Available since v3.1._
233      */
234     function functionCallWithValue(
235         address target,
236         bytes memory data,
237         uint256 value,
238         string memory errorMessage
239     ) internal returns (bytes memory) {
240         require(address(this).balance >= value, "Address: insufficient balance for call");
241         require(isContract(target), "Address: call to non-contract");
242 
243         (bool success, bytes memory returndata) = target.call{value: value}(data);
244         return verifyCallResult(success, returndata, errorMessage);
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
249      * but performing a static call.
250      *
251      * _Available since v3.3._
252      */
253     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
254         return functionStaticCall(target, data, "Address: low-level static call failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
259      * but performing a static call.
260      *
261      * _Available since v3.3._
262      */
263     function functionStaticCall(
264         address target,
265         bytes memory data,
266         string memory errorMessage
267     ) internal view returns (bytes memory) {
268         require(isContract(target), "Address: static call to non-contract");
269 
270         (bool success, bytes memory returndata) = target.staticcall(data);
271         return verifyCallResult(success, returndata, errorMessage);
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
276      * but performing a delegate call.
277      *
278      * _Available since v3.4._
279      */
280     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
281         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
286      * but performing a delegate call.
287      *
288      * _Available since v3.4._
289      */
290     function functionDelegateCall(
291         address target,
292         bytes memory data,
293         string memory errorMessage
294     ) internal returns (bytes memory) {
295         require(isContract(target), "Address: delegate call to non-contract");
296 
297         (bool success, bytes memory returndata) = target.delegatecall(data);
298         return verifyCallResult(success, returndata, errorMessage);
299     }
300 
301     /**
302      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
303      * revert reason using the provided one.
304      *
305      * _Available since v4.3._
306      */
307     function verifyCallResult(
308         bool success,
309         bytes memory returndata,
310         string memory errorMessage
311     ) internal pure returns (bytes memory) {
312         if (success) {
313             return returndata;
314         } else {
315             // Look for revert reason and bubble it up if present
316             if (returndata.length > 0) {
317                 // The easiest way to bubble the revert reason is using memory via assembly
318 
319                 assembly {
320                     let returndata_size := mload(returndata)
321                     revert(add(32, returndata), returndata_size)
322                 }
323             } else {
324                 revert(errorMessage);
325             }
326         }
327     }
328 }
329 
330 
331 // File @openzeppelin/contracts/utils/StorageSlot.sol@v4.3.2
332 
333 
334 
335 pragma solidity ^0.8.0;
336 
337 /**
338  * @dev Library for reading and writing primitive types to specific storage slots.
339  *
340  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
341  * This library helps with reading and writing to such slots without the need for inline assembly.
342  *
343  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
344  *
345  * Example usage to set ERC1967 implementation slot:
346  * ```
347  * contract ERC1967 {
348  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
349  *
350  *     function _getImplementation() internal view returns (address) {
351  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
352  *     }
353  *
354  *     function _setImplementation(address newImplementation) internal {
355  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
356  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
357  *     }
358  * }
359  * ```
360  *
361  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
362  */
363 library StorageSlot {
364     struct AddressSlot {
365         address value;
366     }
367 
368     struct BooleanSlot {
369         bool value;
370     }
371 
372     struct Bytes32Slot {
373         bytes32 value;
374     }
375 
376     struct Uint256Slot {
377         uint256 value;
378     }
379 
380     /**
381      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
382      */
383     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
384         assembly {
385             r.slot := slot
386         }
387     }
388 
389     /**
390      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
391      */
392     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
393         assembly {
394             r.slot := slot
395         }
396     }
397 
398     /**
399      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
400      */
401     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
402         assembly {
403             r.slot := slot
404         }
405     }
406 
407     /**
408      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
409      */
410     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
411         assembly {
412             r.slot := slot
413         }
414     }
415 }
416 
417 
418 // File @openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol@v4.3.2
419 
420 
421 
422 pragma solidity ^0.8.2;
423 
424 
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
496     function _upgradeToAndCallSecure(
497         address newImplementation,
498         bytes memory data,
499         bool forceCall
500     ) internal {
501         address oldImplementation = _getImplementation();
502 
503         // Initial upgrade and setup call
504         _setImplementation(newImplementation);
505         if (data.length > 0 || forceCall) {
506             Address.functionDelegateCall(newImplementation, data);
507         }
508 
509         // Perform rollback test if not already in progress
510         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
511         if (!rollbackTesting.value) {
512             // Trigger rollback using upgradeTo from the new implementation
513             rollbackTesting.value = true;
514             Address.functionDelegateCall(
515                 newImplementation,
516                 abi.encodeWithSignature("upgradeTo(address)", oldImplementation)
517             );
518             rollbackTesting.value = false;
519             // Check rollback was effective
520             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
521             // Finally reset to the new implementation and log the upgrade
522             _upgradeTo(newImplementation);
523         }
524     }
525 
526     /**
527      * @dev Storage slot with the admin of the contract.
528      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
529      * validated in the constructor.
530      */
531     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
532 
533     /**
534      * @dev Emitted when the admin account has changed.
535      */
536     event AdminChanged(address previousAdmin, address newAdmin);
537 
538     /**
539      * @dev Returns the current admin.
540      */
541     function _getAdmin() internal view returns (address) {
542         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
543     }
544 
545     /**
546      * @dev Stores a new address in the EIP1967 admin slot.
547      */
548     function _setAdmin(address newAdmin) private {
549         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
550         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
551     }
552 
553     /**
554      * @dev Changes the admin of the proxy.
555      *
556      * Emits an {AdminChanged} event.
557      */
558     function _changeAdmin(address newAdmin) internal {
559         emit AdminChanged(_getAdmin(), newAdmin);
560         _setAdmin(newAdmin);
561     }
562 
563     /**
564      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
565      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
566      */
567     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
568 
569     /**
570      * @dev Emitted when the beacon is upgraded.
571      */
572     event BeaconUpgraded(address indexed beacon);
573 
574     /**
575      * @dev Returns the current beacon.
576      */
577     function _getBeacon() internal view returns (address) {
578         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
579     }
580 
581     /**
582      * @dev Stores a new beacon in the EIP1967 beacon slot.
583      */
584     function _setBeacon(address newBeacon) private {
585         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
586         require(
587             Address.isContract(IBeacon(newBeacon).implementation()),
588             "ERC1967: beacon implementation is not a contract"
589         );
590         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
591     }
592 
593     /**
594      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
595      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
596      *
597      * Emits a {BeaconUpgraded} event.
598      */
599     function _upgradeBeaconToAndCall(
600         address newBeacon,
601         bytes memory data,
602         bool forceCall
603     ) internal {
604         _setBeacon(newBeacon);
605         emit BeaconUpgraded(newBeacon);
606         if (data.length > 0 || forceCall) {
607             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
608         }
609     }
610 }
611 
612 
613 // File @openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol@v4.3.2
614 
615 
616 
617 pragma solidity ^0.8.0;
618 
619 
620 /**
621  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
622  * implementation address that can be changed. This address is stored in storage in the location specified by
623  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
624  * implementation behind the proxy.
625  */
626 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
627     /**
628      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
629      *
630      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
631      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
632      */
633     constructor(address _logic, bytes memory _data) payable {
634         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
635         _upgradeToAndCall(_logic, _data, false);
636     }
637 
638     /**
639      * @dev Returns the current implementation address.
640      */
641     function _implementation() internal view virtual override returns (address impl) {
642         return ERC1967Upgrade._getImplementation();
643     }
644 }
645 
646 
647 // File @openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol@v4.3.2
648 
649 
650 
651 pragma solidity ^0.8.0;
652 
653 /**
654  * @dev This contract implements a proxy that is upgradeable by an admin.
655  *
656  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
657  * clashing], which can potentially be used in an attack, this contract uses the
658  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
659  * things that go hand in hand:
660  *
661  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
662  * that call matches one of the admin functions exposed by the proxy itself.
663  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
664  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
665  * "admin cannot fallback to proxy target".
666  *
667  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
668  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
669  * to sudden errors when trying to call a function from the proxy implementation.
670  *
671  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
672  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
673  */
674 contract TransparentUpgradeableProxy is ERC1967Proxy {
675     /**
676      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
677      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
678      */
679     constructor(
680         address _logic,
681         address admin_,
682         bytes memory _data
683     ) payable ERC1967Proxy(_logic, _data) {
684         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
685         _changeAdmin(admin_);
686     }
687 
688     /**
689      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
690      */
691     modifier ifAdmin() {
692         if (msg.sender == _getAdmin()) {
693             _;
694         } else {
695             _fallback();
696         }
697     }
698 
699     /**
700      * @dev Returns the current admin.
701      *
702      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
703      *
704      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
705      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
706      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
707      */
708     function admin() external ifAdmin returns (address admin_) {
709         admin_ = _getAdmin();
710     }
711 
712     /**
713      * @dev Returns the current implementation.
714      *
715      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
716      *
717      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
718      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
719      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
720      */
721     function implementation() external ifAdmin returns (address implementation_) {
722         implementation_ = _implementation();
723     }
724 
725     /**
726      * @dev Changes the admin of the proxy.
727      *
728      * Emits an {AdminChanged} event.
729      *
730      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
731      */
732     function changeAdmin(address newAdmin) external virtual ifAdmin {
733         _changeAdmin(newAdmin);
734     }
735 
736     /**
737      * @dev Upgrade the implementation of the proxy.
738      *
739      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
740      */
741     function upgradeTo(address newImplementation) external ifAdmin {
742         _upgradeToAndCall(newImplementation, bytes(""), false);
743     }
744 
745     /**
746      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
747      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
748      * proxied contract.
749      *
750      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
751      */
752     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
753         _upgradeToAndCall(newImplementation, data, true);
754     }
755 
756     /**
757      * @dev Returns the current admin.
758      */
759     function _admin() internal view virtual returns (address) {
760         return _getAdmin();
761     }
762 
763     /**
764      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
765      */
766     function _beforeFallback() internal virtual override {
767         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
768         super._beforeFallback();
769     }
770 }
771 
772 
773 // File contracts/bico-token/bico/BicoTokenProxy.sol
774 
775 // contracts/bico-token/bico/BicoToken.sol
776 
777 
778 pragma solidity ^0.8.0;
779 
780 /**
781  * @dev This contract implements a proxy that is upgradeable by an admin.
782  *
783  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
784  * clashing], which can potentially be used in an attack, this contract uses the
785  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
786  * things that go hand in hand:
787  *
788  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
789  * that call matches one of the admin functions exposed by the proxy itself.
790  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
791  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
792  * "admin cannot fallback to proxy target".
793  *
794  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
795  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
796  * to sudden errors when trying to call a function from the proxy implementation.
797  *
798  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
799  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
800  */
801 contract BicoTokenProxy is TransparentUpgradeableProxy {
802     constructor (address _implementation,address _admin)
803     TransparentUpgradeableProxy(_implementation,_admin,bytes("")) {
804     }
805 
806     function getAdmin() external view returns (address adm) {
807       bytes32 slot = _ADMIN_SLOT;
808       assembly {
809         adm := sload(slot)
810       }
811     }
812 
813     function getImplementation() external view returns (address impl) {
814       bytes32 slot = _IMPLEMENTATION_SLOT;
815       assembly {
816         impl := sload(slot)
817       }
818     }    
819 }