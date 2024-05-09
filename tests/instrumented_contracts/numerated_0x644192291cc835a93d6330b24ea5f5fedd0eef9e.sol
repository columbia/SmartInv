1 // Sources flattened with hardhat v2.12.7 https://hardhat.org
2 
3 // File Address.sol
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts (last updated v4.5.0-rc.0) (utils/Address.sol)
7 
8 pragma solidity ^0.8.1;
9 
10 /**
11  * @dev Collection of functions related to the address type
12  */
13 library Address {
14     /**
15      * @dev Returns true if `account` is a contract.
16      *
17      * [IMPORTANT]
18      * ====
19      * It is unsafe to assume that an address for which this function returns
20      * false is an externally-owned account (EOA) and not a contract.
21      *
22      * Among others, `isContract` will return false for the following
23      * types of addresses:
24      *
25      *  - an externally-owned account
26      *  - a contract in construction
27      *  - an address where a contract will be created
28      *  - an address where a contract lived, but was destroyed
29      * ====
30      *
31      * [IMPORTANT]
32      * ====
33      * You shouldn't rely on `isContract` to protect against flash loan attacks!
34      *
35      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
36      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
37      * constructor.
38      * ====
39      */
40     function isContract(address account) internal view returns (bool) {
41         // This method relies on extcodesize/address.code.length, which returns 0
42         // for contracts in construction, since the code is only stored at the end
43         // of the constructor execution.
44 
45         return account.code.length > 0;
46     }
47 
48     /**
49      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
50      * `recipient`, forwarding all available gas and reverting on errors.
51      *
52      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
53      * of certain opcodes, possibly making contracts go over the 2300 gas limit
54      * imposed by `transfer`, making them unable to receive funds via
55      * `transfer`. {sendValue} removes this limitation.
56      *
57      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
58      *
59      * IMPORTANT: because control is transferred to `recipient`, care must be
60      * taken to not create reentrancy vulnerabilities. Consider using
61      * {ReentrancyGuard} or the
62      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
63      */
64     function sendValue(address payable recipient, uint256 amount) internal {
65         require(address(this).balance >= amount, "Address: insufficient balance");
66 
67         (bool success, ) = recipient.call{value: amount}("");
68         require(success, "Address: unable to send value, recipient may have reverted");
69     }
70 
71     /**
72      * @dev Performs a Solidity function call using a low level `call`. A
73      * plain `call` is an unsafe replacement for a function call: use this
74      * function instead.
75      *
76      * If `target` reverts with a revert reason, it is bubbled up by this
77      * function (like regular Solidity function calls).
78      *
79      * Returns the raw returned data. To convert to the expected return value,
80      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
81      *
82      * Requirements:
83      *
84      * - `target` must be a contract.
85      * - calling `target` with `data` must not revert.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
90         return functionCall(target, data, "Address: low-level call failed");
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
95      * `errorMessage` as a fallback revert reason when `target` reverts.
96      *
97      * _Available since v3.1._
98      */
99     function functionCall(
100         address target,
101         bytes memory data,
102         string memory errorMessage
103     ) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, 0, errorMessage);
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
109      * but also transferring `value` wei to `target`.
110      *
111      * Requirements:
112      *
113      * - the calling contract must have an ETH balance of at least `value`.
114      * - the called Solidity function must be `payable`.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(
119         address target,
120         bytes memory data,
121         uint256 value
122     ) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
124     }
125 
126     /**
127      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
128      * with `errorMessage` as a fallback revert reason when `target` reverts.
129      *
130      * _Available since v3.1._
131      */
132     function functionCallWithValue(
133         address target,
134         bytes memory data,
135         uint256 value,
136         string memory errorMessage
137     ) internal returns (bytes memory) {
138         require(address(this).balance >= value, "Address: insufficient balance for call");
139         require(isContract(target), "Address: call to non-contract");
140 
141         (bool success, bytes memory returndata) = target.call{value: value}(data);
142         return verifyCallResult(success, returndata, errorMessage);
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
147      * but performing a static call.
148      *
149      * _Available since v3.3._
150      */
151     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
152         return functionStaticCall(target, data, "Address: low-level static call failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
157      * but performing a static call.
158      *
159      * _Available since v3.3._
160      */
161     function functionStaticCall(
162         address target,
163         bytes memory data,
164         string memory errorMessage
165     ) internal view returns (bytes memory) {
166         require(isContract(target), "Address: static call to non-contract");
167 
168         (bool success, bytes memory returndata) = target.staticcall(data);
169         return verifyCallResult(success, returndata, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but performing a delegate call.
175      *
176      * _Available since v3.4._
177      */
178     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
179         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
184      * but performing a delegate call.
185      *
186      * _Available since v3.4._
187      */
188     function functionDelegateCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         require(isContract(target), "Address: delegate call to non-contract");
194 
195         (bool success, bytes memory returndata) = target.delegatecall(data);
196         return verifyCallResult(success, returndata, errorMessage);
197     }
198 
199     /**
200      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
201      * revert reason using the provided one.
202      *
203      * _Available since v4.3._
204      */
205     function verifyCallResult(
206         bool success,
207         bytes memory returndata,
208         string memory errorMessage
209     ) internal pure returns (bytes memory) {
210         if (success) {
211             return returndata;
212         } else {
213             // Look for revert reason and bubble it up if present
214             if (returndata.length > 0) {
215                 // The easiest way to bubble the revert reason is using memory via assembly
216 
217                 assembly {
218                     let returndata_size := mload(returndata)
219                     revert(add(32, returndata), returndata_size)
220                 }
221             } else {
222                 revert(errorMessage);
223             }
224         }
225     }
226 }
227 
228 
229 // File draft-IERC1822.sol
230 
231 // OpenZeppelin Contracts (last updated v4.5.0-rc.0) (interfaces/draft-IERC1822.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
237  * proxy whose upgrades are fully controlled by the current implementation.
238  */
239 interface IERC1822Proxiable {
240     /**
241      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
242      * address.
243      *
244      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
245      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
246      * function revert if invoked through a proxy.
247      */
248     function proxiableUUID() external view returns (bytes32);
249 }
250 
251 
252 // File IBeacon.sol
253 
254 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 /**
259  * @dev This is the interface that {BeaconProxy} expects of its beacon.
260  */
261 interface IBeacon {
262     /**
263      * @dev Must return an address that can be used as a delegate call target.
264      *
265      * {BeaconProxy} will check that this address is a contract.
266      */
267     function implementation() external view returns (address);
268 }
269 
270 
271 // File StorageSlot.sol
272 
273 // OpenZeppelin Contracts v4.4.1 (utils/StorageSlot.sol)
274 
275 pragma solidity ^0.8.0;
276 
277 /**
278  * @dev Library for reading and writing primitive types to specific storage slots.
279  *
280  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
281  * This library helps with reading and writing to such slots without the need for inline assembly.
282  *
283  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
284  *
285  * Example usage to set ERC1967 implementation slot:
286  * ```
287  * contract ERC1967 {
288  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
289  *
290  *     function _getImplementation() internal view returns (address) {
291  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
292  *     }
293  *
294  *     function _setImplementation(address newImplementation) internal {
295  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
296  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
297  *     }
298  * }
299  * ```
300  *
301  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
302  */
303 library StorageSlot {
304     struct AddressSlot {
305         address value;
306     }
307 
308     struct BooleanSlot {
309         bool value;
310     }
311 
312     struct Bytes32Slot {
313         bytes32 value;
314     }
315 
316     struct Uint256Slot {
317         uint256 value;
318     }
319 
320     /**
321      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
322      */
323     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
324         assembly {
325             r.slot := slot
326         }
327     }
328 
329     /**
330      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
331      */
332     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
333         assembly {
334             r.slot := slot
335         }
336     }
337 
338     /**
339      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
340      */
341     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
342         assembly {
343             r.slot := slot
344         }
345     }
346 
347     /**
348      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
349      */
350     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
351         assembly {
352             r.slot := slot
353         }
354     }
355 }
356 
357 
358 // File ERC1967Upgrade.sol
359 
360 // OpenZeppelin Contracts (last updated v4.5.0-rc.0) (proxy/ERC1967/ERC1967Upgrade.sol)
361 
362 pragma solidity ^0.8.2;
363 
364 
365 
366 
367 /**
368  * @dev This abstract contract provides getters and event emitting update functions for
369  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
370  *
371  * _Available since v4.1._
372  *
373  * @custom:oz-upgrades-unsafe-allow delegatecall
374  */
375 abstract contract ERC1967Upgrade {
376     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
377     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
378 
379     /**
380      * @dev Storage slot with the address of the current implementation.
381      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
382      * validated in the constructor.
383      */
384     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
385 
386     /**
387      * @dev Emitted when the implementation is upgraded.
388      */
389     event Upgraded(address indexed implementation);
390 
391     /**
392      * @dev Returns the current implementation address.
393      */
394     function _getImplementation() internal view returns (address) {
395         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
396     }
397 
398     /**
399      * @dev Stores a new address in the EIP1967 implementation slot.
400      */
401     function _setImplementation(address newImplementation) private {
402         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
403         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
404     }
405 
406     /**
407      * @dev Perform implementation upgrade
408      *
409      * Emits an {Upgraded} event.
410      */
411     function _upgradeTo(address newImplementation) internal {
412         _setImplementation(newImplementation);
413         emit Upgraded(newImplementation);
414     }
415 
416     /**
417      * @dev Perform implementation upgrade with additional setup call.
418      *
419      * Emits an {Upgraded} event.
420      */
421     function _upgradeToAndCall(
422         address newImplementation,
423         bytes memory data,
424         bool forceCall
425     ) internal {
426         _upgradeTo(newImplementation);
427         if (data.length > 0 || forceCall) {
428             Address.functionDelegateCall(newImplementation, data);
429         }
430     }
431 
432     /**
433      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
434      *
435      * Emits an {Upgraded} event.
436      */
437     function _upgradeToAndCallUUPS(
438         address newImplementation,
439         bytes memory data,
440         bool forceCall
441     ) internal {
442         // Upgrades from old implementations will perform a rollback test. This test requires the new
443         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
444         // this special case will break upgrade paths from old UUPS implementation to new ones.
445         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
446             _setImplementation(newImplementation);
447         } else {
448             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
449                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
450             } catch {
451                 revert("ERC1967Upgrade: new implementation is not UUPS");
452             }
453             _upgradeToAndCall(newImplementation, data, forceCall);
454         }
455     }
456 
457     /**
458      * @dev Storage slot with the admin of the contract.
459      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
460      * validated in the constructor.
461      */
462     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
463 
464     /**
465      * @dev Emitted when the admin account has changed.
466      */
467     event AdminChanged(address previousAdmin, address newAdmin);
468 
469     /**
470      * @dev Returns the current admin.
471      */
472     function _getAdmin() internal view virtual returns (address) {
473         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
474     }
475 
476     /**
477      * @dev Stores a new address in the EIP1967 admin slot.
478      */
479     function _setAdmin(address newAdmin) private {
480         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
481         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
482     }
483 
484     /**
485      * @dev Changes the admin of the proxy.
486      *
487      * Emits an {AdminChanged} event.
488      */
489     function _changeAdmin(address newAdmin) internal {
490         emit AdminChanged(_getAdmin(), newAdmin);
491         _setAdmin(newAdmin);
492     }
493 
494     /**
495      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
496      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
497      */
498     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
499 
500     /**
501      * @dev Emitted when the beacon is upgraded.
502      */
503     event BeaconUpgraded(address indexed beacon);
504 
505     /**
506      * @dev Returns the current beacon.
507      */
508     function _getBeacon() internal view returns (address) {
509         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
510     }
511 
512     /**
513      * @dev Stores a new beacon in the EIP1967 beacon slot.
514      */
515     function _setBeacon(address newBeacon) private {
516         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
517         require(Address.isContract(IBeacon(newBeacon).implementation()), "ERC1967: beacon implementation is not a contract");
518         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
519     }
520 
521     /**
522      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
523      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
524      *
525      * Emits a {BeaconUpgraded} event.
526      */
527     function _upgradeBeaconToAndCall(
528         address newBeacon,
529         bytes memory data,
530         bool forceCall
531     ) internal {
532         _setBeacon(newBeacon);
533         emit BeaconUpgraded(newBeacon);
534         if (data.length > 0 || forceCall) {
535             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
536         }
537     }
538 }
539 
540 
541 // File Proxy.sol
542 
543 // OpenZeppelin Contracts (last updated v4.5.0-rc.0) (proxy/Proxy.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 /**
548  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
549  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
550  * be specified by overriding the virtual {_implementation} function.
551  *
552  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
553  * different contract through the {_delegate} function.
554  *
555  * The success and return data of the delegated call will be returned back to the caller of the proxy.
556  */
557 abstract contract Proxy {
558     /**
559      * @dev Delegates the current call to `implementation`.
560      *
561      * This function does not return to its internal call site, it will return directly to the external caller.
562      */
563     function _delegate(address implementation) internal virtual {
564         assembly {
565             // Copy msg.data. We take full control of memory in this inline assembly
566             // block because it will not return to Solidity code. We overwrite the
567             // Solidity scratch pad at memory position 0.
568             calldatacopy(0, 0, calldatasize())
569 
570             // Call the implementation.
571             // out and outsize are 0 because we don't know the size yet.
572             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
573 
574             // Copy the returned data.
575             returndatacopy(0, 0, returndatasize())
576 
577             switch result
578             // delegatecall returns 0 on error.
579             case 0 {
580                 revert(0, returndatasize())
581             }
582             default {
583                 return(0, returndatasize())
584             }
585         }
586     }
587 
588     /**
589      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
590      * and {_fallback} should delegate.
591      */
592     function _implementation() internal view virtual returns (address);
593 
594     /**
595      * @dev Delegates the current call to the address returned by `_implementation()`.
596      *
597      * This function does not return to its internall call site, it will return directly to the external caller.
598      */
599     function _fallback() internal virtual {
600         _beforeFallback();
601         _delegate(_implementation());
602     }
603 
604     /**
605      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
606      * function in the contract matches the call data.
607      */
608     fallback() external payable virtual {
609         _fallback();
610     }
611 
612     /**
613      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
614      * is empty.
615      */
616     receive() external payable virtual {
617         _fallback();
618     }
619 
620     /**
621      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
622      * call, or as part of the Solidity `fallback` or `receive` functions.
623      *
624      * If overriden should call `super._beforeFallback()`.
625      */
626     function _beforeFallback() internal virtual {}
627 }
628 
629 
630 // File ERC1967Proxy.sol
631 
632 // OpenZeppelin Contracts v4.4.1 (proxy/ERC1967/ERC1967Proxy.sol)
633 
634 pragma solidity ^0.8.0;
635 
636 
637 /**
638  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
639  * implementation address that can be changed. This address is stored in storage in the location specified by
640  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
641  * implementation behind the proxy.
642  */
643 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
644     /**
645      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
646      *
647      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
648      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
649      */
650     constructor(address _logic, bytes memory _data) payable {
651         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
652         _upgradeToAndCall(_logic, _data, false);
653     }
654 
655     /**
656      * @dev Returns the current implementation address.
657      */
658     function _implementation() internal view virtual override returns (address impl) {
659         return ERC1967Upgrade._getImplementation();
660     }
661 }
662 
663 
664 // File OptimizedTransparentUpgradeableProxy.sol
665 
666 // OpenZeppelin Contracts v4.4.1 (proxy/transparent/TransparentUpgradeableProxy.sol)
667 
668 pragma solidity ^0.8.0;
669 
670 /**
671  * @dev This contract implements a proxy that is upgradeable by an admin.
672  *
673  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
674  * clashing], which can potentially be used in an attack, this contract uses the
675  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
676  * things that go hand in hand:
677  *
678  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
679  * that call matches one of the admin functions exposed by the proxy itself.
680  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
681  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
682  * "admin cannot fallback to proxy target".
683  *
684  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
685  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
686  * to sudden errors when trying to call a function from the proxy implementation.
687  *
688  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
689  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
690  */
691 contract OptimizedTransparentUpgradeableProxy is ERC1967Proxy {
692     address internal immutable _ADMIN;
693 
694     /**
695      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
696      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
697      */
698     constructor(
699         address _logic,
700         address admin_,
701         bytes memory _data
702     ) payable ERC1967Proxy(_logic, _data) {
703         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
704         _ADMIN = admin_;
705 
706         // still store it to work with EIP-1967
707         bytes32 slot = _ADMIN_SLOT;
708         // solhint-disable-next-line no-inline-assembly
709         assembly {
710             sstore(slot, admin_)
711         }
712         emit AdminChanged(address(0), admin_);
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
753      * @dev Upgrade the implementation of the proxy.
754      *
755      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
756      */
757     function upgradeTo(address newImplementation) external ifAdmin {
758         _upgradeToAndCall(newImplementation, bytes(""), false);
759     }
760 
761     /**
762      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
763      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
764      * proxied contract.
765      *
766      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
767      */
768     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
769         _upgradeToAndCall(newImplementation, data, true);
770     }
771 
772     /**
773      * @dev Returns the current admin.
774      */
775     function _admin() internal view virtual returns (address) {
776         return _getAdmin();
777     }
778 
779     /**
780      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
781      */
782     function _beforeFallback() internal virtual override {
783         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
784         super._beforeFallback();
785     }
786 
787     function _getAdmin() internal view virtual override returns (address) {
788         return _ADMIN;
789     }
790 }
791 
792 
793 // File flattened.sol