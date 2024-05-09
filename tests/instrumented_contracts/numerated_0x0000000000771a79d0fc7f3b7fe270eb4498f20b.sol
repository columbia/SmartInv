1 // SPDX-License-Identifier: MIT
2 /**
3  * MCT XENFT - XEN batch mint and manage with NFT
4  * To Use this Dapp: https://mct.xyz/xenft
5  *
6  * https://mct.xyz - The all-in-one toolbox for your crypto adventure
7 */
8 
9 //  __  __   _____  _______      __   ____     __ ______
10 // |  \/  | / ____||__   __|     \ \ / /\ \   / /|___  /
11 // | \  / || |        | |         \ V /  \ \_/ /    / /
12 // | |\/| || |        | |          > <    \   /    / /
13 // | |  | || |____    | |    _    / . \    | |    / /__
14 // |_|  |_| \_____|   |_|   (_)  /_/ \_\   |_|   /_____|
15 
16 
17 pragma solidity ^0.8.16;
18 
19 
20 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
21 /**
22  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
23  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
24  * be specified by overriding the virtual {_implementation} function.
25  *
26  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
27  * different contract through the {_delegate} function.
28  *
29  * The success and return data of the delegated call will be returned back to the caller of the proxy.
30  */
31 abstract contract Proxy {
32     /**
33      * @dev Delegates the current call to `implementation`.
34      *
35      * This function does not return to its internal call site, it will return directly to the external caller.
36      */
37     function _delegate(address implementation) internal virtual {
38         assembly {
39             // Copy msg.data. We take full control of memory in this inline assembly
40             // block because it will not return to Solidity code. We overwrite the
41             // Solidity scratch pad at memory position 0.
42             calldatacopy(0, 0, calldatasize())
43 
44             // Call the implementation.
45             // out and outsize are 0 because we don't know the size yet.
46             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
47 
48             // Copy the returned data.
49             returndatacopy(0, 0, returndatasize())
50 
51             switch result
52             // delegatecall returns 0 on error.
53             case 0 {
54                 revert(0, returndatasize())
55             }
56             default {
57                 return(0, returndatasize())
58             }
59         }
60     }
61 
62     /**
63      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
64      * and {_fallback} should delegate.
65      */
66     function _implementation() internal view virtual returns (address);
67 
68     /**
69      * @dev Delegates the current call to the address returned by `_implementation()`.
70      *
71      * This function does not return to its internal call site, it will return directly to the external caller.
72      */
73     function _fallback() internal virtual {
74         _beforeFallback();
75         _delegate(_implementation());
76     }
77 
78     /**
79      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
80      * function in the contract matches the call data.
81      */
82     fallback() external payable virtual {
83         _fallback();
84     }
85 
86     /**
87      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
88      * is empty.
89      */
90     receive() external payable virtual {
91         _fallback();
92     }
93 
94     /**
95      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
96      * call, or as part of the Solidity `fallback` or `receive` functions.
97      *
98      * If overridden should call `super._beforeFallback()`.
99      */
100     function _beforeFallback() internal virtual {}
101 }
102 
103 
104 
105 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
106 /**
107  * @dev This is the interface that {BeaconProxy} expects of its beacon.
108  */
109 interface IBeacon {
110     /**
111      * @dev Must return an address that can be used as a delegate call target.
112      *
113      * {BeaconProxy} will check that this address is a contract.
114      */
115     function implementation() external view returns (address);
116 }
117 
118 
119 
120 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
121 /**
122  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
123  * proxy whose upgrades are fully controlled by the current implementation.
124  */
125 interface IERC1822Proxiable {
126     /**
127      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
128      * address.
129      *
130      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
131      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
132      * function revert if invoked through a proxy.
133      */
134     function proxiableUUID() external view returns (bytes32);
135 }
136 
137 
138 
139 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
140 /**
141  * @dev Collection of functions related to the address type
142  */
143 library Address {
144     /**
145      * @dev Returns true if `account` is a contract.
146      *
147      * [IMPORTANT]
148      * ====
149      * It is unsafe to assume that an address for which this function returns
150      * false is an externally-owned account (EOA) and not a contract.
151      *
152      * Among others, `isContract` will return false for the following
153      * types of addresses:
154      *
155      *  - an externally-owned account
156      *  - a contract in construction
157      *  - an address where a contract will be created
158      *  - an address where a contract lived, but was destroyed
159      * ====
160      *
161      * [IMPORTANT]
162      * ====
163      * You shouldn't rely on `isContract` to protect against flash loan attacks!
164      *
165      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
166      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
167      * constructor.
168      * ====
169      */
170     function isContract(address account) internal view returns (bool) {
171         // This method relies on extcodesize/address.code.length, which returns 0
172         // for contracts in construction, since the code is only stored at the end
173         // of the constructor execution.
174 
175         return account.code.length > 0;
176     }
177 
178     /**
179      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
180      * `recipient`, forwarding all available gas and reverting on errors.
181      *
182      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
183      * of certain opcodes, possibly making contracts go over the 2300 gas limit
184      * imposed by `transfer`, making them unable to receive funds via
185      * `transfer`. {sendValue} removes this limitation.
186      *
187      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
188      *
189      * IMPORTANT: because control is transferred to `recipient`, care must be
190      * taken to not create reentrancy vulnerabilities. Consider using
191      * {ReentrancyGuard} or the
192      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
193      */
194     function sendValue(address payable recipient, uint256 amount) internal {
195         require(address(this).balance >= amount, "Address: insufficient balance");
196 
197         (bool success, ) = recipient.call{value: amount}("");
198         require(success, "Address: unable to send value, recipient may have reverted");
199     }
200 
201     /**
202      * @dev Performs a Solidity function call using a low level `call`. A
203      * plain `call` is an unsafe replacement for a function call: use this
204      * function instead.
205      *
206      * If `target` reverts with a revert reason, it is bubbled up by this
207      * function (like regular Solidity function calls).
208      *
209      * Returns the raw returned data. To convert to the expected return value,
210      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
211      *
212      * Requirements:
213      *
214      * - `target` must be a contract.
215      * - calling `target` with `data` must not revert.
216      *
217      * _Available since v3.1._
218      */
219     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
220         return functionCall(target, data, "Address: low-level call failed");
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
225      * `errorMessage` as a fallback revert reason when `target` reverts.
226      *
227      * _Available since v3.1._
228      */
229     function functionCall(
230         address target,
231         bytes memory data,
232         string memory errorMessage
233     ) internal returns (bytes memory) {
234         return functionCallWithValue(target, data, 0, errorMessage);
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
239      * but also transferring `value` wei to `target`.
240      *
241      * Requirements:
242      *
243      * - the calling contract must have an ETH balance of at least `value`.
244      * - the called Solidity function must be `payable`.
245      *
246      * _Available since v3.1._
247      */
248     function functionCallWithValue(
249         address target,
250         bytes memory data,
251         uint256 value
252     ) internal returns (bytes memory) {
253         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
258      * with `errorMessage` as a fallback revert reason when `target` reverts.
259      *
260      * _Available since v3.1._
261      */
262     function functionCallWithValue(
263         address target,
264         bytes memory data,
265         uint256 value,
266         string memory errorMessage
267     ) internal returns (bytes memory) {
268         require(address(this).balance >= value, "Address: insufficient balance for call");
269         require(isContract(target), "Address: call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.call{value: value}(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
277      * but performing a static call.
278      *
279      * _Available since v3.3._
280      */
281     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
282         return functionStaticCall(target, data, "Address: low-level static call failed");
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
287      * but performing a static call.
288      *
289      * _Available since v3.3._
290      */
291     function functionStaticCall(
292         address target,
293         bytes memory data,
294         string memory errorMessage
295     ) internal view returns (bytes memory) {
296         require(isContract(target), "Address: static call to non-contract");
297 
298         (bool success, bytes memory returndata) = target.staticcall(data);
299         return verifyCallResult(success, returndata, errorMessage);
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
304      * but performing a delegate call.
305      *
306      * _Available since v3.4._
307      */
308     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
309         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
314      * but performing a delegate call.
315      *
316      * _Available since v3.4._
317      */
318     function functionDelegateCall(
319         address target,
320         bytes memory data,
321         string memory errorMessage
322     ) internal returns (bytes memory) {
323         require(isContract(target), "Address: delegate call to non-contract");
324 
325         (bool success, bytes memory returndata) = target.delegatecall(data);
326         return verifyCallResult(success, returndata, errorMessage);
327     }
328 
329     /**
330      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
331      * revert reason using the provided one.
332      *
333      * _Available since v4.3._
334      */
335     function verifyCallResult(
336         bool success,
337         bytes memory returndata,
338         string memory errorMessage
339     ) internal pure returns (bytes memory) {
340         if (success) {
341             return returndata;
342         } else {
343             // Look for revert reason and bubble it up if present
344             if (returndata.length > 0) {
345                 // The easiest way to bubble the revert reason is using memory via assembly
346                 /// @solidity memory-safe-assembly
347                 assembly {
348                     let returndata_size := mload(returndata)
349                     revert(add(32, returndata), returndata_size)
350                 }
351             } else {
352                 revert(errorMessage);
353             }
354         }
355     }
356 }
357 
358 
359 
360 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
361 /**
362  * @dev Library for reading and writing primitive types to specific storage slots.
363  *
364  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
365  * This library helps with reading and writing to such slots without the need for inline assembly.
366  *
367  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
368  *
369  * Example usage to set ERC1967 implementation slot:
370  * ```
371  * contract ERC1967 {
372  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
373  *
374  *     function _getImplementation() internal view returns (address) {
375  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
376  *     }
377  *
378  *     function _setImplementation(address newImplementation) internal {
379  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
380  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
381  *     }
382  * }
383  * ```
384  *
385  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
386  */
387 library StorageSlot {
388     struct AddressSlot {
389         address value;
390     }
391 
392     struct BooleanSlot {
393         bool value;
394     }
395 
396     struct Bytes32Slot {
397         bytes32 value;
398     }
399 
400     struct Uint256Slot {
401         uint256 value;
402     }
403 
404     /**
405      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
406      */
407     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
408         /// @solidity memory-safe-assembly
409         assembly {
410             r.slot := slot
411         }
412     }
413 
414     /**
415      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
416      */
417     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
418         /// @solidity memory-safe-assembly
419         assembly {
420             r.slot := slot
421         }
422     }
423 
424     /**
425      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
426      */
427     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
428         /// @solidity memory-safe-assembly
429         assembly {
430             r.slot := slot
431         }
432     }
433 
434     /**
435      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
436      */
437     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
438         /// @solidity memory-safe-assembly
439         assembly {
440             r.slot := slot
441         }
442     }
443 }
444 
445 
446 
447 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
448 /**
449  * @dev This abstract contract provides getters and event emitting update functions for
450  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
451  *
452  * _Available since v4.1._
453  *
454  * @custom:oz-upgrades-unsafe-allow delegatecall
455  */
456 abstract contract ERC1967Upgrade {
457     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
458     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
459 
460     /**
461      * @dev Storage slot with the address of the current implementation.
462      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
463      * validated in the constructor.
464      */
465     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
466 
467     /**
468      * @dev Emitted when the implementation is upgraded.
469      */
470     event Upgraded(address indexed implementation);
471 
472     /**
473      * @dev Returns the current implementation address.
474      */
475     function _getImplementation() internal view returns (address) {
476         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
477     }
478 
479     /**
480      * @dev Stores a new address in the EIP1967 implementation slot.
481      */
482     function _setImplementation(address newImplementation) private {
483         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
484         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
485     }
486 
487     /**
488      * @dev Perform implementation upgrade
489      *
490      * Emits an {Upgraded} event.
491      */
492     function _upgradeTo(address newImplementation) internal {
493         _setImplementation(newImplementation);
494         emit Upgraded(newImplementation);
495     }
496 
497     /**
498      * @dev Perform implementation upgrade with additional setup call.
499      *
500      * Emits an {Upgraded} event.
501      */
502     function _upgradeToAndCall(
503         address newImplementation,
504         bytes memory data,
505         bool forceCall
506     ) internal {
507         _upgradeTo(newImplementation);
508         if (data.length > 0 || forceCall) {
509             Address.functionDelegateCall(newImplementation, data);
510         }
511     }
512 
513     /**
514      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
515      *
516      * Emits an {Upgraded} event.
517      */
518     function _upgradeToAndCallUUPS(
519         address newImplementation,
520         bytes memory data,
521         bool forceCall
522     ) internal {
523         // Upgrades from old implementations will perform a rollback test. This test requires the new
524         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
525         // this special case will break upgrade paths from old UUPS implementation to new ones.
526         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
527             _setImplementation(newImplementation);
528         } else {
529             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
530                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
531             } catch {
532                 revert("ERC1967Upgrade: new implementation is not UUPS");
533             }
534             _upgradeToAndCall(newImplementation, data, forceCall);
535         }
536     }
537 
538     /**
539      * @dev Storage slot with the admin of the contract.
540      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
541      * validated in the constructor.
542      */
543     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
544 
545     /**
546      * @dev Emitted when the admin account has changed.
547      */
548     event AdminChanged(address previousAdmin, address newAdmin);
549 
550     /**
551      * @dev Returns the current admin.
552      */
553     function _getAdmin() internal view returns (address) {
554         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
555     }
556 
557     /**
558      * @dev Stores a new address in the EIP1967 admin slot.
559      */
560     function _setAdmin(address newAdmin) private {
561         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
562         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
563     }
564 
565     /**
566      * @dev Changes the admin of the proxy.
567      *
568      * Emits an {AdminChanged} event.
569      */
570     function _changeAdmin(address newAdmin) internal {
571         emit AdminChanged(_getAdmin(), newAdmin);
572         _setAdmin(newAdmin);
573     }
574 
575     /**
576      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
577      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
578      */
579     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
580 
581     /**
582      * @dev Emitted when the beacon is upgraded.
583      */
584     event BeaconUpgraded(address indexed beacon);
585 
586     /**
587      * @dev Returns the current beacon.
588      */
589     function _getBeacon() internal view returns (address) {
590         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
591     }
592 
593     /**
594      * @dev Stores a new beacon in the EIP1967 beacon slot.
595      */
596     function _setBeacon(address newBeacon) private {
597         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
598         require(
599             Address.isContract(IBeacon(newBeacon).implementation()),
600             "ERC1967: beacon implementation is not a contract"
601         );
602         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
603     }
604 
605     /**
606      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
607      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
608      *
609      * Emits a {BeaconUpgraded} event.
610      */
611     function _upgradeBeaconToAndCall(
612         address newBeacon,
613         bytes memory data,
614         bool forceCall
615     ) internal {
616         _setBeacon(newBeacon);
617         emit BeaconUpgraded(newBeacon);
618         if (data.length > 0 || forceCall) {
619             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
620         }
621     }
622 }
623 
624 
625 
626 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
627 /**
628  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
629  * implementation address that can be changed. This address is stored in storage in the location specified by
630  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
631  * implementation behind the proxy.
632  */
633 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
634     /**
635      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
636      *
637      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
638      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
639      */
640     constructor(address _logic, bytes memory _data) payable {
641         _upgradeToAndCall(_logic, _data, false);
642     }
643 
644     /**
645      * @dev Returns the current implementation address.
646      */
647     function _implementation() internal view virtual override returns (address impl) {
648         return ERC1967Upgrade._getImplementation();
649     }
650 }
651 
652 
653 
654 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/transparent/TransparentUpgradeableProxy.sol)
655 /**
656  * @dev This contract implements a proxy that is upgradeable by an admin.
657  *
658  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
659  * clashing], which can potentially be used in an attack, this contract uses the
660  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
661  * things that go hand in hand:
662  *
663  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
664  * that call matches one of the admin functions exposed by the proxy itself.
665  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
666  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
667  * "admin cannot fallback to proxy target".
668  *
669  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
670  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
671  * to sudden errors when trying to call a function from the proxy implementation.
672  *
673  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
674  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
675  */
676 contract TransparentUpgradeableProxy is ERC1967Proxy {
677     /**
678      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
679      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
680      */
681     constructor(
682         address _logic,
683         address admin_,
684         bytes memory _data
685     ) payable ERC1967Proxy(_logic, _data) {
686         _changeAdmin(admin_);
687     }
688 
689     /**
690      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
691      */
692     modifier ifAdmin() {
693         if (msg.sender == _getAdmin()) {
694             _;
695         } else {
696             _fallback();
697         }
698     }
699 
700     /**
701      * @dev Returns the current admin.
702      *
703      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
704      *
705      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
706      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
707      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
708      */
709     function admin() external ifAdmin returns (address admin_) {
710         admin_ = _getAdmin();
711     }
712 
713     /**
714      * @dev Returns the current implementation.
715      *
716      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
717      *
718      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
719      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
720      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
721      */
722     function implementation() external ifAdmin returns (address implementation_) {
723         implementation_ = _implementation();
724     }
725 
726     /**
727      * @dev Changes the admin of the proxy.
728      *
729      * Emits an {AdminChanged} event.
730      *
731      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
732      */
733     function changeAdmin(address newAdmin) external virtual ifAdmin {
734         _changeAdmin(newAdmin);
735     }
736 
737     /**
738      * @dev Upgrade the implementation of the proxy.
739      *
740      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
741      */
742     function upgradeTo(address newImplementation) external ifAdmin {
743         _upgradeToAndCall(newImplementation, bytes(""), false);
744     }
745 
746     /**
747      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
748      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
749      * proxied contract.
750      *
751      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
752      */
753     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
754         _upgradeToAndCall(newImplementation, data, true);
755     }
756 
757     /**
758      * @dev Returns the current admin.
759      */
760     function _admin() internal view virtual returns (address) {
761         return _getAdmin();
762     }
763 
764     /**
765      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
766      */
767     function _beforeFallback() internal virtual override {
768         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
769         super._beforeFallback();
770     }
771 }
772 
773 
774 
775 /**
776  * @dev TransparentUpgradeableProxy where admin is allowed to call implementation methods.
777  */
778 contract MctXenft is TransparentUpgradeableProxy {
779     /**
780      * @dev Initializes an upgradeable proxy backed by the implementation at `_logic`.
781      */
782     constructor(address _logic)
783         TransparentUpgradeableProxy(
784             _logic,
785             tx.origin,
786             abi.encodeWithSignature("initialize()")
787         )
788     {}
789 
790     /**
791      * @dev Override to allow admin access the fallback function.
792      */
793     function _beforeFallback() internal override {}
794 }