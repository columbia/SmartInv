1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-25
3 */
4 
5 // Sources flattened with hardhat v2.6.3 https://hardhat.org
6 
7 // File @openzeppelin/contracts/proxy/Proxy.sol@v4.3.1
8 // SPDX-License-Identifier: MIT
9 
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
15  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
16  * be specified by overriding the virtual {_implementation} function.
17  *
18  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
19  * different contract through the {_delegate} function.
20  *
21  * The success and return data of the delegated call will be returned back to the caller of the proxy.
22  */
23 abstract contract Proxy {
24     /**
25      * @dev Delegates the current call to `implementation`.
26      *
27      * This function does not return to its internall call site, it will return directly to the external caller.
28      */
29     function _delegate(address implementation) internal virtual {
30         assembly {
31             // Copy msg.data. We take full control of memory in this inline assembly
32             // block because it will not return to Solidity code. We overwrite the
33             // Solidity scratch pad at memory position 0.
34             calldatacopy(0, 0, calldatasize())
35 
36             // Call the implementation.
37             // out and outsize are 0 because we don't know the size yet.
38             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
39 
40             // Copy the returned data.
41             returndatacopy(0, 0, returndatasize())
42 
43             switch result
44             // delegatecall returns 0 on error.
45             case 0 {
46                 revert(0, returndatasize())
47             }
48             default {
49                 return(0, returndatasize())
50             }
51         }
52     }
53 
54     /**
55      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
56      * and {_fallback} should delegate.
57      */
58     function _implementation() internal view virtual returns (address);
59 
60     /**
61      * @dev Delegates the current call to the address returned by `_implementation()`.
62      *
63      * This function does not return to its internall call site, it will return directly to the external caller.
64      */
65     function _fallback() internal virtual {
66         _beforeFallback();
67         _delegate(_implementation());
68     }
69 
70     /**
71      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
72      * function in the contract matches the call data.
73      */
74     fallback() external payable virtual {
75         _fallback();
76     }
77 
78     /**
79      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
80      * is empty.
81      */
82     receive() external payable virtual {
83         _fallback();
84     }
85 
86     /**
87      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
88      * call, or as part of the Solidity `fallback` or `receive` functions.
89      *
90      * If overriden should call `super._beforeFallback()`.
91      */
92     function _beforeFallback() internal virtual {}
93 }
94 
95 
96 // File @openzeppelin/contracts/proxy/beacon/IBeacon.sol@v4.3.1
97 
98 
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @dev This is the interface that {BeaconProxy} expects of its beacon.
104  */
105 interface IBeacon {
106     /**
107      * @dev Must return an address that can be used as a delegate call target.
108      *
109      * {BeaconProxy} will check that this address is a contract.
110      */
111     function implementation() external view returns (address);
112 }
113 
114 
115 // File @openzeppelin/contracts/utils/Address.sol@v4.3.1
116 
117 
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Collection of functions related to the address type
123  */
124 library Address {
125     /**
126      * @dev Returns true if `account` is a contract.
127      *
128      * [IMPORTANT]
129      * ====
130      * It is unsafe to assume that an address for which this function returns
131      * false is an externally-owned account (EOA) and not a contract.
132      *
133      * Among others, `isContract` will return false for the following
134      * types of addresses:
135      *
136      *  - an externally-owned account
137      *  - a contract in construction
138      *  - an address where a contract will be created
139      *  - an address where a contract lived, but was destroyed
140      * ====
141      */
142     function isContract(address account) internal view returns (bool) {
143         // This method relies on extcodesize, which returns 0 for contracts in
144         // construction, since the code is only stored at the end of the
145         // constructor execution.
146 
147         uint256 size;
148         assembly {
149             size := extcodesize(account)
150         }
151         return size > 0;
152     }
153 
154     /**
155      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
156      * `recipient`, forwarding all available gas and reverting on errors.
157      *
158      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
159      * of certain opcodes, possibly making contracts go over the 2300 gas limit
160      * imposed by `transfer`, making them unable to receive funds via
161      * `transfer`. {sendValue} removes this limitation.
162      *
163      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
164      *
165      * IMPORTANT: because control is transferred to `recipient`, care must be
166      * taken to not create reentrancy vulnerabilities. Consider using
167      * {ReentrancyGuard} or the
168      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
169      */
170     function sendValue(address payable recipient, uint256 amount) internal {
171         require(address(this).balance >= amount, "Address: insufficient balance");
172 
173         (bool success, ) = recipient.call{value: amount}("");
174         require(success, "Address: unable to send value, recipient may have reverted");
175     }
176 
177     /**
178      * @dev Performs a Solidity function call using a low level `call`. A
179      * plain `call` is an unsafe replacement for a function call: use this
180      * function instead.
181      *
182      * If `target` reverts with a revert reason, it is bubbled up by this
183      * function (like regular Solidity function calls).
184      *
185      * Returns the raw returned data. To convert to the expected return value,
186      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
187      *
188      * Requirements:
189      *
190      * - `target` must be a contract.
191      * - calling `target` with `data` must not revert.
192      *
193      * _Available since v3.1._
194      */
195     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
196         return functionCall(target, data, "Address: low-level call failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
201      * `errorMessage` as a fallback revert reason when `target` reverts.
202      *
203      * _Available since v3.1._
204      */
205     function functionCall(
206         address target,
207         bytes memory data,
208         string memory errorMessage
209     ) internal returns (bytes memory) {
210         return functionCallWithValue(target, data, 0, errorMessage);
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
215      * but also transferring `value` wei to `target`.
216      *
217      * Requirements:
218      *
219      * - the calling contract must have an ETH balance of at least `value`.
220      * - the called Solidity function must be `payable`.
221      *
222      * _Available since v3.1._
223      */
224     function functionCallWithValue(
225         address target,
226         bytes memory data,
227         uint256 value
228     ) internal returns (bytes memory) {
229         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
234      * with `errorMessage` as a fallback revert reason when `target` reverts.
235      *
236      * _Available since v3.1._
237      */
238     function functionCallWithValue(
239         address target,
240         bytes memory data,
241         uint256 value,
242         string memory errorMessage
243     ) internal returns (bytes memory) {
244         require(address(this).balance >= value, "Address: insufficient balance for call");
245         require(isContract(target), "Address: call to non-contract");
246 
247         (bool success, bytes memory returndata) = target.call{value: value}(data);
248         return verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
253      * but performing a static call.
254      *
255      * _Available since v3.3._
256      */
257     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
258         return functionStaticCall(target, data, "Address: low-level static call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
263      * but performing a static call.
264      *
265      * _Available since v3.3._
266      */
267     function functionStaticCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal view returns (bytes memory) {
272         require(isContract(target), "Address: static call to non-contract");
273 
274         (bool success, bytes memory returndata) = target.staticcall(data);
275         return verifyCallResult(success, returndata, errorMessage);
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
280      * but performing a delegate call.
281      *
282      * _Available since v3.4._
283      */
284     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
285         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
290      * but performing a delegate call.
291      *
292      * _Available since v3.4._
293      */
294     function functionDelegateCall(
295         address target,
296         bytes memory data,
297         string memory errorMessage
298     ) internal returns (bytes memory) {
299         require(isContract(target), "Address: delegate call to non-contract");
300 
301         (bool success, bytes memory returndata) = target.delegatecall(data);
302         return verifyCallResult(success, returndata, errorMessage);
303     }
304 
305     /**
306      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
307      * revert reason using the provided one.
308      *
309      * _Available since v4.3._
310      */
311     function verifyCallResult(
312         bool success,
313         bytes memory returndata,
314         string memory errorMessage
315     ) internal pure returns (bytes memory) {
316         if (success) {
317             return returndata;
318         } else {
319             // Look for revert reason and bubble it up if present
320             if (returndata.length > 0) {
321                 // The easiest way to bubble the revert reason is using memory via assembly
322 
323                 assembly {
324                     let returndata_size := mload(returndata)
325                     revert(add(32, returndata), returndata_size)
326                 }
327             } else {
328                 revert(errorMessage);
329             }
330         }
331     }
332 }
333 
334 
335 // File @openzeppelin/contracts/utils/StorageSlot.sol@v4.3.1
336 
337 
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @dev Library for reading and writing primitive types to specific storage slots.
343  *
344  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
345  * This library helps with reading and writing to such slots without the need for inline assembly.
346  *
347  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
348  *
349  * Example usage to set ERC1967 implementation slot:
350  * ```
351  * contract ERC1967 {
352  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
353  *
354  *     function _getImplementation() internal view returns (address) {
355  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
356  *     }
357  *
358  *     function _setImplementation(address newImplementation) internal {
359  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
360  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
361  *     }
362  * }
363  * ```
364  *
365  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
366  */
367 library StorageSlot {
368     struct AddressSlot {
369         address value;
370     }
371 
372     struct BooleanSlot {
373         bool value;
374     }
375 
376     struct Bytes32Slot {
377         bytes32 value;
378     }
379 
380     struct Uint256Slot {
381         uint256 value;
382     }
383 
384     /**
385      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
386      */
387     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
388         assembly {
389             r.slot := slot
390         }
391     }
392 
393     /**
394      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
395      */
396     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
397         assembly {
398             r.slot := slot
399         }
400     }
401 
402     /**
403      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
404      */
405     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
406         assembly {
407             r.slot := slot
408         }
409     }
410 
411     /**
412      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
413      */
414     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
415         assembly {
416             r.slot := slot
417         }
418     }
419 }
420 
421 
422 // File @openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol@v4.3.1
423 
424 
425 
426 pragma solidity ^0.8.2;
427 
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
500     function _upgradeToAndCallSecure(
501         address newImplementation,
502         bytes memory data,
503         bool forceCall
504     ) internal {
505         address oldImplementation = _getImplementation();
506 
507         // Initial upgrade and setup call
508         _setImplementation(newImplementation);
509         if (data.length > 0 || forceCall) {
510             Address.functionDelegateCall(newImplementation, data);
511         }
512 
513         // Perform rollback test if not already in progress
514         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
515         if (!rollbackTesting.value) {
516             // Trigger rollback using upgradeTo from the new implementation
517             rollbackTesting.value = true;
518             Address.functionDelegateCall(
519                 newImplementation,
520                 abi.encodeWithSignature("upgradeTo(address)", oldImplementation)
521             );
522             rollbackTesting.value = false;
523             // Check rollback was effective
524             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
525             // Finally reset to the new implementation and log the upgrade
526             _upgradeTo(newImplementation);
527         }
528     }
529 
530     /**
531      * @dev Storage slot with the admin of the contract.
532      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
533      * validated in the constructor.
534      */
535     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
536 
537     /**
538      * @dev Emitted when the admin account has changed.
539      */
540     event AdminChanged(address previousAdmin, address newAdmin);
541 
542     /**
543      * @dev Returns the current admin.
544      */
545     function _getAdmin() internal view returns (address) {
546         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
547     }
548 
549     /**
550      * @dev Stores a new address in the EIP1967 admin slot.
551      */
552     function _setAdmin(address newAdmin) private {
553         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
554         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
555     }
556 
557     /**
558      * @dev Changes the admin of the proxy.
559      *
560      * Emits an {AdminChanged} event.
561      */
562     function _changeAdmin(address newAdmin) internal {
563         emit AdminChanged(_getAdmin(), newAdmin);
564         _setAdmin(newAdmin);
565     }
566 
567     /**
568      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
569      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
570      */
571     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
572 
573     /**
574      * @dev Emitted when the beacon is upgraded.
575      */
576     event BeaconUpgraded(address indexed beacon);
577 
578     /**
579      * @dev Returns the current beacon.
580      */
581     function _getBeacon() internal view returns (address) {
582         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
583     }
584 
585     /**
586      * @dev Stores a new beacon in the EIP1967 beacon slot.
587      */
588     function _setBeacon(address newBeacon) private {
589         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
590         require(
591             Address.isContract(IBeacon(newBeacon).implementation()),
592             "ERC1967: beacon implementation is not a contract"
593         );
594         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
595     }
596 
597     /**
598      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
599      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
600      *
601      * Emits a {BeaconUpgraded} event.
602      */
603     function _upgradeBeaconToAndCall(
604         address newBeacon,
605         bytes memory data,
606         bool forceCall
607     ) internal {
608         _setBeacon(newBeacon);
609         emit BeaconUpgraded(newBeacon);
610         if (data.length > 0 || forceCall) {
611             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
612         }
613     }
614 }
615 
616 
617 // File @openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol@v4.3.1
618 
619 
620 
621 pragma solidity ^0.8.0;
622 
623 
624 /**
625  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
626  * implementation address that can be changed. This address is stored in storage in the location specified by
627  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
628  * implementation behind the proxy.
629  */
630 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
631     /**
632      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
633      *
634      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
635      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
636      */
637     constructor(address _logic, bytes memory _data) payable {
638         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
639         _upgradeToAndCall(_logic, _data, false);
640     }
641 
642     /**
643      * @dev Returns the current implementation address.
644      */
645     function _implementation() internal view virtual override returns (address impl) {
646         return ERC1967Upgrade._getImplementation();
647     }
648 }
649 
650 
651 // File @openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol@v4.3.1
652 
653 
654 
655 pragma solidity ^0.8.0;
656 
657 /**
658  * @dev This contract implements a proxy that is upgradeable by an admin.
659  *
660  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
661  * clashing], which can potentially be used in an attack, this contract uses the
662  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
663  * things that go hand in hand:
664  *
665  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
666  * that call matches one of the admin functions exposed by the proxy itself.
667  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
668  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
669  * "admin cannot fallback to proxy target".
670  *
671  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
672  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
673  * to sudden errors when trying to call a function from the proxy implementation.
674  *
675  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
676  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
677  */
678 contract TransparentUpgradeableProxy is ERC1967Proxy {
679     /**
680      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
681      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
682      */
683     constructor(
684         address _logic,
685         address admin_,
686         bytes memory _data
687     ) payable ERC1967Proxy(_logic, _data) {
688         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
689         _changeAdmin(admin_);
690     }
691 
692     /**
693      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
694      */
695     modifier ifAdmin() {
696         if (msg.sender == _getAdmin()) {
697             _;
698         } else {
699             _fallback();
700         }
701     }
702 
703     /**
704      * @dev Returns the current admin.
705      *
706      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
707      *
708      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
709      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
710      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
711      */
712     function admin() external ifAdmin returns (address admin_) {
713         admin_ = _getAdmin();
714     }
715 
716     /**
717      * @dev Returns the current implementation.
718      *
719      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
720      *
721      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
722      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
723      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
724      */
725     function implementation() external ifAdmin returns (address implementation_) {
726         implementation_ = _implementation();
727     }
728 
729     /**
730      * @dev Changes the admin of the proxy.
731      *
732      * Emits an {AdminChanged} event.
733      *
734      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
735      */
736     function changeAdmin(address newAdmin) external virtual ifAdmin {
737         _changeAdmin(newAdmin);
738     }
739 
740     /**
741      * @dev Upgrade the implementation of the proxy.
742      *
743      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
744      */
745     function upgradeTo(address newImplementation) external ifAdmin {
746         _upgradeToAndCall(newImplementation, bytes(""), false);
747     }
748 
749     /**
750      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
751      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
752      * proxied contract.
753      *
754      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
755      */
756     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
757         _upgradeToAndCall(newImplementation, data, true);
758     }
759 
760     /**
761      * @dev Returns the current admin.
762      */
763     function _admin() internal view virtual returns (address) {
764         return _getAdmin();
765     }
766 
767     /**
768      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
769      */
770     function _beforeFallback() internal virtual override {
771         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
772         super._beforeFallback();
773     }
774 }
775 
776 
777 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
778 
779 
780 
781 pragma solidity ^0.8.0;
782 
783 /**
784  * @dev Provides information about the current execution context, including the
785  * sender of the transaction and its data. While these are generally available
786  * via msg.sender and msg.data, they should not be accessed in such a direct
787  * manner, since when dealing with meta-transactions the account sending and
788  * paying for execution may not be the actual sender (as far as an application
789  * is concerned).
790  *
791  * This contract is only required for intermediate, library-like contracts.
792  */
793 abstract contract Context {
794     function _msgSender() internal view virtual returns (address) {
795         return msg.sender;
796     }
797 
798     function _msgData() internal view virtual returns (bytes calldata) {
799         return msg.data;
800     }
801 }
802 
803 
804 // File contracts/BaiProxy.sol
805 
806 
807 pragma solidity ^0.8.2;
808 
809 
810 contract PkexProxy is Context, TransparentUpgradeableProxy {
811     constructor(address _logic)
812         payable
813         TransparentUpgradeableProxy(_logic, _msgSender(), bytes(""))
814     {}
815 }