1 // Sources flattened with hardhat v2.8.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/proxy/Proxy.sol@v4.5.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/Proxy.sol)
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
52      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
53      * and {_fallback} should delegate.
54      */
55     function _implementation() internal view virtual returns (address);
56 
57     /**
58      * @dev Delegates the current call to the address returned by `_implementation()`.
59      *
60      * This function does not return to its internall call site, it will return directly to the external caller.
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
87      * If overriden should call `super._beforeFallback()`.
88      */
89     function _beforeFallback() internal virtual {}
90 }
91 
92 
93 // File @openzeppelin/contracts/proxy/beacon/IBeacon.sol@v4.5.0
94 
95 
96 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
97 
98 pragma solidity ^0.8.0;
99 
100 /**
101  * @dev This is the interface that {BeaconProxy} expects of its beacon.
102  */
103 interface IBeacon {
104     /**
105      * @dev Must return an address that can be used as a delegate call target.
106      *
107      * {BeaconProxy} will check that this address is a contract.
108      */
109     function implementation() external view returns (address);
110 }
111 
112 
113 // File @openzeppelin/contracts/interfaces/draft-IERC1822.sol@v4.5.0
114 
115 
116 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
122  * proxy whose upgrades are fully controlled by the current implementation.
123  */
124 interface IERC1822Proxiable {
125     /**
126      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
127      * address.
128      *
129      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
130      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
131      * function revert if invoked through a proxy.
132      */
133     function proxiableUUID() external view returns (bytes32);
134 }
135 
136 
137 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
138 
139 
140 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
141 
142 pragma solidity ^0.8.1;
143 
144 /**
145  * @dev Collection of functions related to the address type
146  */
147 library Address {
148     /**
149      * @dev Returns true if `account` is a contract.
150      *
151      * [IMPORTANT]
152      * ====
153      * It is unsafe to assume that an address for which this function returns
154      * false is an externally-owned account (EOA) and not a contract.
155      *
156      * Among others, `isContract` will return false for the following
157      * types of addresses:
158      *
159      *  - an externally-owned account
160      *  - a contract in construction
161      *  - an address where a contract will be created
162      *  - an address where a contract lived, but was destroyed
163      * ====
164      *
165      * [IMPORTANT]
166      * ====
167      * You shouldn't rely on `isContract` to protect against flash loan attacks!
168      *
169      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
170      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
171      * constructor.
172      * ====
173      */
174     function isContract(address account) internal view returns (bool) {
175         // This method relies on extcodesize/address.code.length, which returns 0
176         // for contracts in construction, since the code is only stored at the end
177         // of the constructor execution.
178 
179         return account.code.length > 0;
180     }
181 
182     /**
183      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
184      * `recipient`, forwarding all available gas and reverting on errors.
185      *
186      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
187      * of certain opcodes, possibly making contracts go over the 2300 gas limit
188      * imposed by `transfer`, making them unable to receive funds via
189      * `transfer`. {sendValue} removes this limitation.
190      *
191      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
192      *
193      * IMPORTANT: because control is transferred to `recipient`, care must be
194      * taken to not create reentrancy vulnerabilities. Consider using
195      * {ReentrancyGuard} or the
196      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
197      */
198     function sendValue(address payable recipient, uint256 amount) internal {
199         require(address(this).balance >= amount, "Address: insufficient balance");
200 
201         (bool success, ) = recipient.call{value: amount}("");
202         require(success, "Address: unable to send value, recipient may have reverted");
203     }
204 
205     /**
206      * @dev Performs a Solidity function call using a low level `call`. A
207      * plain `call` is an unsafe replacement for a function call: use this
208      * function instead.
209      *
210      * If `target` reverts with a revert reason, it is bubbled up by this
211      * function (like regular Solidity function calls).
212      *
213      * Returns the raw returned data. To convert to the expected return value,
214      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
215      *
216      * Requirements:
217      *
218      * - `target` must be a contract.
219      * - calling `target` with `data` must not revert.
220      *
221      * _Available since v3.1._
222      */
223     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
224         return functionCall(target, data, "Address: low-level call failed");
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
229      * `errorMessage` as a fallback revert reason when `target` reverts.
230      *
231      * _Available since v3.1._
232      */
233     function functionCall(
234         address target,
235         bytes memory data,
236         string memory errorMessage
237     ) internal returns (bytes memory) {
238         return functionCallWithValue(target, data, 0, errorMessage);
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
243      * but also transferring `value` wei to `target`.
244      *
245      * Requirements:
246      *
247      * - the calling contract must have an ETH balance of at least `value`.
248      * - the called Solidity function must be `payable`.
249      *
250      * _Available since v3.1._
251      */
252     function functionCallWithValue(
253         address target,
254         bytes memory data,
255         uint256 value
256     ) internal returns (bytes memory) {
257         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
262      * with `errorMessage` as a fallback revert reason when `target` reverts.
263      *
264      * _Available since v3.1._
265      */
266     function functionCallWithValue(
267         address target,
268         bytes memory data,
269         uint256 value,
270         string memory errorMessage
271     ) internal returns (bytes memory) {
272         require(address(this).balance >= value, "Address: insufficient balance for call");
273         require(isContract(target), "Address: call to non-contract");
274 
275         (bool success, bytes memory returndata) = target.call{value: value}(data);
276         return verifyCallResult(success, returndata, errorMessage);
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
281      * but performing a static call.
282      *
283      * _Available since v3.3._
284      */
285     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
286         return functionStaticCall(target, data, "Address: low-level static call failed");
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
291      * but performing a static call.
292      *
293      * _Available since v3.3._
294      */
295     function functionStaticCall(
296         address target,
297         bytes memory data,
298         string memory errorMessage
299     ) internal view returns (bytes memory) {
300         require(isContract(target), "Address: static call to non-contract");
301 
302         (bool success, bytes memory returndata) = target.staticcall(data);
303         return verifyCallResult(success, returndata, errorMessage);
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
308      * but performing a delegate call.
309      *
310      * _Available since v3.4._
311      */
312     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
313         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
318      * but performing a delegate call.
319      *
320      * _Available since v3.4._
321      */
322     function functionDelegateCall(
323         address target,
324         bytes memory data,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         require(isContract(target), "Address: delegate call to non-contract");
328 
329         (bool success, bytes memory returndata) = target.delegatecall(data);
330         return verifyCallResult(success, returndata, errorMessage);
331     }
332 
333     /**
334      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
335      * revert reason using the provided one.
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
347             // Look for revert reason and bubble it up if present
348             if (returndata.length > 0) {
349                 // The easiest way to bubble the revert reason is using memory via assembly
350 
351                 assembly {
352                     let returndata_size := mload(returndata)
353                     revert(add(32, returndata), returndata_size)
354                 }
355             } else {
356                 revert(errorMessage);
357             }
358         }
359     }
360 }
361 
362 
363 // File @openzeppelin/contracts/utils/StorageSlot.sol@v4.5.0
364 
365 
366 // OpenZeppelin Contracts v4.4.1 (utils/StorageSlot.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 /**
371  * @dev Library for reading and writing primitive types to specific storage slots.
372  *
373  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
374  * This library helps with reading and writing to such slots without the need for inline assembly.
375  *
376  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
377  *
378  * Example usage to set ERC1967 implementation slot:
379  * ```
380  * contract ERC1967 {
381  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
382  *
383  *     function _getImplementation() internal view returns (address) {
384  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
385  *     }
386  *
387  *     function _setImplementation(address newImplementation) internal {
388  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
389  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
390  *     }
391  * }
392  * ```
393  *
394  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
395  */
396 library StorageSlot {
397     struct AddressSlot {
398         address value;
399     }
400 
401     struct BooleanSlot {
402         bool value;
403     }
404 
405     struct Bytes32Slot {
406         bytes32 value;
407     }
408 
409     struct Uint256Slot {
410         uint256 value;
411     }
412 
413     /**
414      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
415      */
416     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
417         assembly {
418             r.slot := slot
419         }
420     }
421 
422     /**
423      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
424      */
425     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
426         assembly {
427             r.slot := slot
428         }
429     }
430 
431     /**
432      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
433      */
434     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
435         assembly {
436             r.slot := slot
437         }
438     }
439 
440     /**
441      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
442      */
443     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
444         assembly {
445             r.slot := slot
446         }
447     }
448 }
449 
450 
451 // File @openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol@v4.5.0
452 
453 
454 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
455 
456 pragma solidity ^0.8.2;
457 
458 
459 
460 
461 /**
462  * @dev This abstract contract provides getters and event emitting update functions for
463  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
464  *
465  * _Available since v4.1._
466  *
467  * @custom:oz-upgrades-unsafe-allow delegatecall
468  */
469 abstract contract ERC1967Upgrade {
470     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
471     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
472 
473     /**
474      * @dev Storage slot with the address of the current implementation.
475      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
476      * validated in the constructor.
477      */
478     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
479 
480     /**
481      * @dev Emitted when the implementation is upgraded.
482      */
483     event Upgraded(address indexed implementation);
484 
485     /**
486      * @dev Returns the current implementation address.
487      */
488     function _getImplementation() internal view returns (address) {
489         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
490     }
491 
492     /**
493      * @dev Stores a new address in the EIP1967 implementation slot.
494      */
495     function _setImplementation(address newImplementation) private {
496         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
497         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
498     }
499 
500     /**
501      * @dev Perform implementation upgrade
502      *
503      * Emits an {Upgraded} event.
504      */
505     function _upgradeTo(address newImplementation) internal {
506         _setImplementation(newImplementation);
507         emit Upgraded(newImplementation);
508     }
509 
510     /**
511      * @dev Perform implementation upgrade with additional setup call.
512      *
513      * Emits an {Upgraded} event.
514      */
515     function _upgradeToAndCall(
516         address newImplementation,
517         bytes memory data,
518         bool forceCall
519     ) internal {
520         _upgradeTo(newImplementation);
521         if (data.length > 0 || forceCall) {
522             Address.functionDelegateCall(newImplementation, data);
523         }
524     }
525 
526     /**
527      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
528      *
529      * Emits an {Upgraded} event.
530      */
531     function _upgradeToAndCallUUPS(
532         address newImplementation,
533         bytes memory data,
534         bool forceCall
535     ) internal {
536         // Upgrades from old implementations will perform a rollback test. This test requires the new
537         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
538         // this special case will break upgrade paths from old UUPS implementation to new ones.
539         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
540             _setImplementation(newImplementation);
541         } else {
542             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
543                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
544             } catch {
545                 revert("ERC1967Upgrade: new implementation is not UUPS");
546             }
547             _upgradeToAndCall(newImplementation, data, forceCall);
548         }
549     }
550 
551     /**
552      * @dev Storage slot with the admin of the contract.
553      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
554      * validated in the constructor.
555      */
556     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
557 
558     /**
559      * @dev Emitted when the admin account has changed.
560      */
561     event AdminChanged(address previousAdmin, address newAdmin);
562 
563     /**
564      * @dev Returns the current admin.
565      */
566     function _getAdmin() internal view returns (address) {
567         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
568     }
569 
570     /**
571      * @dev Stores a new address in the EIP1967 admin slot.
572      */
573     function _setAdmin(address newAdmin) private {
574         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
575         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
576     }
577 
578     /**
579      * @dev Changes the admin of the proxy.
580      *
581      * Emits an {AdminChanged} event.
582      */
583     function _changeAdmin(address newAdmin) internal {
584         emit AdminChanged(_getAdmin(), newAdmin);
585         _setAdmin(newAdmin);
586     }
587 
588     /**
589      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
590      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
591      */
592     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
593 
594     /**
595      * @dev Emitted when the beacon is upgraded.
596      */
597     event BeaconUpgraded(address indexed beacon);
598 
599     /**
600      * @dev Returns the current beacon.
601      */
602     function _getBeacon() internal view returns (address) {
603         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
604     }
605 
606     /**
607      * @dev Stores a new beacon in the EIP1967 beacon slot.
608      */
609     function _setBeacon(address newBeacon) private {
610         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
611         require(
612             Address.isContract(IBeacon(newBeacon).implementation()),
613             "ERC1967: beacon implementation is not a contract"
614         );
615         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
616     }
617 
618     /**
619      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
620      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
621      *
622      * Emits a {BeaconUpgraded} event.
623      */
624     function _upgradeBeaconToAndCall(
625         address newBeacon,
626         bytes memory data,
627         bool forceCall
628     ) internal {
629         _setBeacon(newBeacon);
630         emit BeaconUpgraded(newBeacon);
631         if (data.length > 0 || forceCall) {
632             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
633         }
634     }
635 }
636 
637 
638 // File @openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol@v4.5.0
639 
640 
641 // OpenZeppelin Contracts v4.4.1 (proxy/ERC1967/ERC1967Proxy.sol)
642 
643 pragma solidity ^0.8.0;
644 
645 
646 /**
647  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
648  * implementation address that can be changed. This address is stored in storage in the location specified by
649  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
650  * implementation behind the proxy.
651  */
652 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
653     /**
654      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
655      *
656      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
657      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
658      */
659     constructor(address _logic, bytes memory _data) payable {
660         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
661         _upgradeToAndCall(_logic, _data, false);
662     }
663 
664     /**
665      * @dev Returns the current implementation address.
666      */
667     function _implementation() internal view virtual override returns (address impl) {
668         return ERC1967Upgrade._getImplementation();
669     }
670 }
671 
672 
673 // File @openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol@v4.5.0
674 
675 
676 // OpenZeppelin Contracts v4.4.1 (proxy/transparent/TransparentUpgradeableProxy.sol)
677 
678 pragma solidity ^0.8.0;
679 
680 /**
681  * @dev This contract implements a proxy that is upgradeable by an admin.
682  *
683  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
684  * clashing], which can potentially be used in an attack, this contract uses the
685  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
686  * things that go hand in hand:
687  *
688  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
689  * that call matches one of the admin functions exposed by the proxy itself.
690  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
691  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
692  * "admin cannot fallback to proxy target".
693  *
694  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
695  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
696  * to sudden errors when trying to call a function from the proxy implementation.
697  *
698  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
699  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
700  */
701 contract TransparentUpgradeableProxy is ERC1967Proxy {
702     /**
703      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
704      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
705      */
706     constructor(
707         address _logic,
708         address admin_,
709         bytes memory _data
710     ) payable ERC1967Proxy(_logic, _data) {
711         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
712         _changeAdmin(admin_);
713     }
714 
715     /**
716      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
717      */
718     modifier ifAdmin() {
719         if (msg.sender == _getAdmin()) {
720             _;
721         } else {
722             _fallback();
723         }
724     }
725 
726     /**
727      * @dev Returns the current admin.
728      *
729      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
730      *
731      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
732      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
733      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
734      */
735     function admin() external ifAdmin returns (address admin_) {
736         admin_ = _getAdmin();
737     }
738 
739     /**
740      * @dev Returns the current implementation.
741      *
742      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
743      *
744      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
745      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
746      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
747      */
748     function implementation() external ifAdmin returns (address implementation_) {
749         implementation_ = _implementation();
750     }
751 
752     /**
753      * @dev Changes the admin of the proxy.
754      *
755      * Emits an {AdminChanged} event.
756      *
757      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
758      */
759     function changeAdmin(address newAdmin) external virtual ifAdmin {
760         _changeAdmin(newAdmin);
761     }
762 
763     /**
764      * @dev Upgrade the implementation of the proxy.
765      *
766      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
767      */
768     function upgradeTo(address newImplementation) external ifAdmin {
769         _upgradeToAndCall(newImplementation, bytes(""), false);
770     }
771 
772     /**
773      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
774      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
775      * proxied contract.
776      *
777      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
778      */
779     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
780         _upgradeToAndCall(newImplementation, data, true);
781     }
782 
783     /**
784      * @dev Returns the current admin.
785      */
786     function _admin() internal view virtual returns (address) {
787         return _getAdmin();
788     }
789 
790     /**
791      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
792      */
793     function _beforeFallback() internal virtual override {
794         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
795         super._beforeFallback();
796     }
797 }
798 
799 
800 // File contracts/BSPTStakingProxy.sol
801 
802 /*
803  * Copyright © 2022 Blocksquare d.o.o.
804  */
805 
806 pragma solidity 0.8.14;
807 
808 /// @title Blocksquare Property Token Staking Proxy
809 /// @author David Šenica
810 contract BSPTStakingProxy is TransparentUpgradeableProxy {
811     constructor(
812         address logic,
813         address admin,
814         bytes memory data
815     ) TransparentUpgradeableProxy(logic, admin, data) {}
816 }