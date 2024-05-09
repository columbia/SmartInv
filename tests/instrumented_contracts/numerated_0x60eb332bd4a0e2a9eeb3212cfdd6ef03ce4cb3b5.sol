1 // File: @openzeppelin/contracts/utils/StorageSlot.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/StorageSlot.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Library for reading and writing primitive types to specific storage slots.
10  *
11  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
12  * This library helps with reading and writing to such slots without the need for inline assembly.
13  *
14  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
15  *
16  * Example usage to set ERC1967 implementation slot:
17  * ```
18  * contract ERC1967 {
19  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
20  *
21  *     function _getImplementation() internal view returns (address) {
22  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
23  *     }
24  *
25  *     function _setImplementation(address newImplementation) internal {
26  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
27  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
28  *     }
29  * }
30  * ```
31  *
32  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
33  */
34 library StorageSlot {
35     struct AddressSlot {
36         address value;
37     }
38 
39     struct BooleanSlot {
40         bool value;
41     }
42 
43     struct Bytes32Slot {
44         bytes32 value;
45     }
46 
47     struct Uint256Slot {
48         uint256 value;
49     }
50 
51     /**
52      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
53      */
54     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
55         assembly {
56             r.slot := slot
57         }
58     }
59 
60     /**
61      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
62      */
63     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
64         assembly {
65             r.slot := slot
66         }
67     }
68 
69     /**
70      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
71      */
72     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
73         assembly {
74             r.slot := slot
75         }
76     }
77 
78     /**
79      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
80      */
81     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
82         assembly {
83             r.slot := slot
84         }
85     }
86 }
87 
88 // File: @openzeppelin/contracts/utils/Address.sol
89 
90 
91 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
92 
93 pragma solidity ^0.8.1;
94 
95 /**
96  * @dev Collection of functions related to the address type
97  */
98 library Address {
99     /**
100      * @dev Returns true if `account` is a contract.
101      *
102      * [IMPORTANT]
103      * ====
104      * It is unsafe to assume that an address for which this function returns
105      * false is an externally-owned account (EOA) and not a contract.
106      *
107      * Among others, `isContract` will return false for the following
108      * types of addresses:
109      *
110      *  - an externally-owned account
111      *  - a contract in construction
112      *  - an address where a contract will be created
113      *  - an address where a contract lived, but was destroyed
114      * ====
115      *
116      * [IMPORTANT]
117      * ====
118      * You shouldn't rely on `isContract` to protect against flash loan attacks!
119      *
120      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
121      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
122      * constructor.
123      * ====
124      */
125     function isContract(address account) internal view returns (bool) {
126         // This method relies on extcodesize/address.code.length, which returns 0
127         // for contracts in construction, since the code is only stored at the end
128         // of the constructor execution.
129 
130         return account.code.length > 0;
131     }
132 
133     /**
134      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
135      * `recipient`, forwarding all available gas and reverting on errors.
136      *
137      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
138      * of certain opcodes, possibly making contracts go over the 2300 gas limit
139      * imposed by `transfer`, making them unable to receive funds via
140      * `transfer`. {sendValue} removes this limitation.
141      *
142      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
143      *
144      * IMPORTANT: because control is transferred to `recipient`, care must be
145      * taken to not create reentrancy vulnerabilities. Consider using
146      * {ReentrancyGuard} or the
147      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
148      */
149     function sendValue(address payable recipient, uint256 amount) internal {
150         require(address(this).balance >= amount, "Address: insufficient balance");
151 
152         (bool success, ) = recipient.call{value: amount}("");
153         require(success, "Address: unable to send value, recipient may have reverted");
154     }
155 
156     /**
157      * @dev Performs a Solidity function call using a low level `call`. A
158      * plain `call` is an unsafe replacement for a function call: use this
159      * function instead.
160      *
161      * If `target` reverts with a revert reason, it is bubbled up by this
162      * function (like regular Solidity function calls).
163      *
164      * Returns the raw returned data. To convert to the expected return value,
165      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
166      *
167      * Requirements:
168      *
169      * - `target` must be a contract.
170      * - calling `target` with `data` must not revert.
171      *
172      * _Available since v3.1._
173      */
174     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
175         return functionCall(target, data, "Address: low-level call failed");
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
180      * `errorMessage` as a fallback revert reason when `target` reverts.
181      *
182      * _Available since v3.1._
183      */
184     function functionCall(
185         address target,
186         bytes memory data,
187         string memory errorMessage
188     ) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, 0, errorMessage);
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
194      * but also transferring `value` wei to `target`.
195      *
196      * Requirements:
197      *
198      * - the calling contract must have an ETH balance of at least `value`.
199      * - the called Solidity function must be `payable`.
200      *
201      * _Available since v3.1._
202      */
203     function functionCallWithValue(
204         address target,
205         bytes memory data,
206         uint256 value
207     ) internal returns (bytes memory) {
208         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
213      * with `errorMessage` as a fallback revert reason when `target` reverts.
214      *
215      * _Available since v3.1._
216      */
217     function functionCallWithValue(
218         address target,
219         bytes memory data,
220         uint256 value,
221         string memory errorMessage
222     ) internal returns (bytes memory) {
223         require(address(this).balance >= value, "Address: insufficient balance for call");
224         require(isContract(target), "Address: call to non-contract");
225 
226         (bool success, bytes memory returndata) = target.call{value: value}(data);
227         return verifyCallResult(success, returndata, errorMessage);
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
232      * but performing a static call.
233      *
234      * _Available since v3.3._
235      */
236     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
237         return functionStaticCall(target, data, "Address: low-level static call failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
242      * but performing a static call.
243      *
244      * _Available since v3.3._
245      */
246     function functionStaticCall(
247         address target,
248         bytes memory data,
249         string memory errorMessage
250     ) internal view returns (bytes memory) {
251         require(isContract(target), "Address: static call to non-contract");
252 
253         (bool success, bytes memory returndata) = target.staticcall(data);
254         return verifyCallResult(success, returndata, errorMessage);
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
259      * but performing a delegate call.
260      *
261      * _Available since v3.4._
262      */
263     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
264         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
269      * but performing a delegate call.
270      *
271      * _Available since v3.4._
272      */
273     function functionDelegateCall(
274         address target,
275         bytes memory data,
276         string memory errorMessage
277     ) internal returns (bytes memory) {
278         require(isContract(target), "Address: delegate call to non-contract");
279 
280         (bool success, bytes memory returndata) = target.delegatecall(data);
281         return verifyCallResult(success, returndata, errorMessage);
282     }
283 
284     /**
285      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
286      * revert reason using the provided one.
287      *
288      * _Available since v4.3._
289      */
290     function verifyCallResult(
291         bool success,
292         bytes memory returndata,
293         string memory errorMessage
294     ) internal pure returns (bytes memory) {
295         if (success) {
296             return returndata;
297         } else {
298             // Look for revert reason and bubble it up if present
299             if (returndata.length > 0) {
300                 // The easiest way to bubble the revert reason is using memory via assembly
301 
302                 assembly {
303                     let returndata_size := mload(returndata)
304                     revert(add(32, returndata), returndata_size)
305                 }
306             } else {
307                 revert(errorMessage);
308             }
309         }
310     }
311 }
312 
313 // File: @openzeppelin/contracts/interfaces/draft-IERC1822.sol
314 
315 
316 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
317 
318 pragma solidity ^0.8.0;
319 
320 /**
321  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
322  * proxy whose upgrades are fully controlled by the current implementation.
323  */
324 interface IERC1822Proxiable {
325     /**
326      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
327      * address.
328      *
329      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
330      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
331      * function revert if invoked through a proxy.
332      */
333     function proxiableUUID() external view returns (bytes32);
334 }
335 
336 // File: @openzeppelin/contracts/proxy/beacon/IBeacon.sol
337 
338 
339 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
340 
341 pragma solidity ^0.8.0;
342 
343 /**
344  * @dev This is the interface that {BeaconProxy} expects of its beacon.
345  */
346 interface IBeacon {
347     /**
348      * @dev Must return an address that can be used as a delegate call target.
349      *
350      * {BeaconProxy} will check that this address is a contract.
351      */
352     function implementation() external view returns (address);
353 }
354 
355 // File: @openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol
356 
357 
358 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
359 
360 pragma solidity ^0.8.2;
361 
362 
363 
364 
365 
366 /**
367  * @dev This abstract contract provides getters and event emitting update functions for
368  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
369  *
370  * _Available since v4.1._
371  *
372  * @custom:oz-upgrades-unsafe-allow delegatecall
373  */
374 abstract contract ERC1967Upgrade {
375     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
376     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
377 
378     /**
379      * @dev Storage slot with the address of the current implementation.
380      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
381      * validated in the constructor.
382      */
383     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
384 
385     /**
386      * @dev Emitted when the implementation is upgraded.
387      */
388     event Upgraded(address indexed implementation);
389 
390     /**
391      * @dev Returns the current implementation address.
392      */
393     function _getImplementation() internal view returns (address) {
394         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
395     }
396 
397     /**
398      * @dev Stores a new address in the EIP1967 implementation slot.
399      */
400     function _setImplementation(address newImplementation) private {
401         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
402         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
403     }
404 
405     /**
406      * @dev Perform implementation upgrade
407      *
408      * Emits an {Upgraded} event.
409      */
410     function _upgradeTo(address newImplementation) internal {
411         _setImplementation(newImplementation);
412         emit Upgraded(newImplementation);
413     }
414 
415     /**
416      * @dev Perform implementation upgrade with additional setup call.
417      *
418      * Emits an {Upgraded} event.
419      */
420     function _upgradeToAndCall(
421         address newImplementation,
422         bytes memory data,
423         bool forceCall
424     ) internal {
425         _upgradeTo(newImplementation);
426         if (data.length > 0 || forceCall) {
427             Address.functionDelegateCall(newImplementation, data);
428         }
429     }
430 
431     /**
432      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
433      *
434      * Emits an {Upgraded} event.
435      */
436     function _upgradeToAndCallUUPS(
437         address newImplementation,
438         bytes memory data,
439         bool forceCall
440     ) internal {
441         // Upgrades from old implementations will perform a rollback test. This test requires the new
442         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
443         // this special case will break upgrade paths from old UUPS implementation to new ones.
444         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
445             _setImplementation(newImplementation);
446         } else {
447             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
448                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
449             } catch {
450                 revert("ERC1967Upgrade: new implementation is not UUPS");
451             }
452             _upgradeToAndCall(newImplementation, data, forceCall);
453         }
454     }
455 
456     /**
457      * @dev Storage slot with the admin of the contract.
458      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
459      * validated in the constructor.
460      */
461     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
462 
463     /**
464      * @dev Emitted when the admin account has changed.
465      */
466     event AdminChanged(address previousAdmin, address newAdmin);
467 
468     /**
469      * @dev Returns the current admin.
470      */
471     function _getAdmin() internal view returns (address) {
472         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
473     }
474 
475     /**
476      * @dev Stores a new address in the EIP1967 admin slot.
477      */
478     function _setAdmin(address newAdmin) private {
479         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
480         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
481     }
482 
483     /**
484      * @dev Changes the admin of the proxy.
485      *
486      * Emits an {AdminChanged} event.
487      */
488     function _changeAdmin(address newAdmin) internal {
489         emit AdminChanged(_getAdmin(), newAdmin);
490         _setAdmin(newAdmin);
491     }
492 
493     /**
494      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
495      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
496      */
497     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
498 
499     /**
500      * @dev Emitted when the beacon is upgraded.
501      */
502     event BeaconUpgraded(address indexed beacon);
503 
504     /**
505      * @dev Returns the current beacon.
506      */
507     function _getBeacon() internal view returns (address) {
508         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
509     }
510 
511     /**
512      * @dev Stores a new beacon in the EIP1967 beacon slot.
513      */
514     function _setBeacon(address newBeacon) private {
515         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
516         require(
517             Address.isContract(IBeacon(newBeacon).implementation()),
518             "ERC1967: beacon implementation is not a contract"
519         );
520         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
521     }
522 
523     /**
524      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
525      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
526      *
527      * Emits a {BeaconUpgraded} event.
528      */
529     function _upgradeBeaconToAndCall(
530         address newBeacon,
531         bytes memory data,
532         bool forceCall
533     ) internal {
534         _setBeacon(newBeacon);
535         emit BeaconUpgraded(newBeacon);
536         if (data.length > 0 || forceCall) {
537             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
538         }
539     }
540 }
541 
542 // File: @openzeppelin/contracts/proxy/Proxy.sol
543 
544 
545 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
546 
547 pragma solidity ^0.8.0;
548 
549 /**
550  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
551  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
552  * be specified by overriding the virtual {_implementation} function.
553  *
554  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
555  * different contract through the {_delegate} function.
556  *
557  * The success and return data of the delegated call will be returned back to the caller of the proxy.
558  */
559 abstract contract Proxy {
560     /**
561      * @dev Delegates the current call to `implementation`.
562      *
563      * This function does not return to its internal call site, it will return directly to the external caller.
564      */
565     function _delegate(address implementation) internal virtual {
566         assembly {
567             // Copy msg.data. We take full control of memory in this inline assembly
568             // block because it will not return to Solidity code. We overwrite the
569             // Solidity scratch pad at memory position 0.
570             calldatacopy(0, 0, calldatasize())
571 
572             // Call the implementation.
573             // out and outsize are 0 because we don't know the size yet.
574             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
575 
576             // Copy the returned data.
577             returndatacopy(0, 0, returndatasize())
578 
579             switch result
580             // delegatecall returns 0 on error.
581             case 0 {
582                 revert(0, returndatasize())
583             }
584             default {
585                 return(0, returndatasize())
586             }
587         }
588     }
589 
590     /**
591      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
592      * and {_fallback} should delegate.
593      */
594     function _implementation() internal view virtual returns (address);
595 
596     /**
597      * @dev Delegates the current call to the address returned by `_implementation()`.
598      *
599      * This function does not return to its internal call site, it will return directly to the external caller.
600      */
601     function _fallback() internal virtual {
602         _beforeFallback();
603         _delegate(_implementation());
604     }
605 
606     /**
607      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
608      * function in the contract matches the call data.
609      */
610     fallback() external payable virtual {
611         _fallback();
612     }
613 
614     /**
615      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
616      * is empty.
617      */
618     receive() external payable virtual {
619         _fallback();
620     }
621 
622     /**
623      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
624      * call, or as part of the Solidity `fallback` or `receive` functions.
625      *
626      * If overridden should call `super._beforeFallback()`.
627      */
628     function _beforeFallback() internal virtual {}
629 }
630 
631 // File: @openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol
632 
633 
634 // OpenZeppelin Contracts v4.4.1 (proxy/ERC1967/ERC1967Proxy.sol)
635 
636 pragma solidity ^0.8.0;
637 
638 
639 
640 /**
641  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
642  * implementation address that can be changed. This address is stored in storage in the location specified by
643  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
644  * implementation behind the proxy.
645  */
646 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
647     /**
648      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
649      *
650      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
651      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
652      */
653     constructor(address _logic, bytes memory _data) payable {
654         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
655         _upgradeToAndCall(_logic, _data, false);
656     }
657 
658     /**
659      * @dev Returns the current implementation address.
660      */
661     function _implementation() internal view virtual override returns (address impl) {
662         return ERC1967Upgrade._getImplementation();
663     }
664 }
665 
666 // File: @openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol
667 
668 
669 // OpenZeppelin Contracts v4.4.1 (proxy/transparent/TransparentUpgradeableProxy.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 
674 /**
675  * @dev This contract implements a proxy that is upgradeable by an admin.
676  *
677  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
678  * clashing], which can potentially be used in an attack, this contract uses the
679  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
680  * things that go hand in hand:
681  *
682  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
683  * that call matches one of the admin functions exposed by the proxy itself.
684  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
685  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
686  * "admin cannot fallback to proxy target".
687  *
688  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
689  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
690  * to sudden errors when trying to call a function from the proxy implementation.
691  *
692  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
693  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
694  */
695 contract TransparentUpgradeableProxy is ERC1967Proxy {
696     /**
697      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
698      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
699      */
700     constructor(
701         address _logic,
702         address admin_,
703         bytes memory _data
704     ) payable ERC1967Proxy(_logic, _data) {
705         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
706         _changeAdmin(admin_);
707     }
708 
709     /**
710      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
711      */
712     modifier ifAdmin() {
713         if (msg.sender == _getAdmin()) {
714             _;
715         } else {
716             _fallback();
717         }
718     }
719 
720     /**
721      * @dev Returns the current admin.
722      *
723      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
724      *
725      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
726      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
727      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
728      */
729     function admin() external ifAdmin returns (address admin_) {
730         admin_ = _getAdmin();
731     }
732 
733     /**
734      * @dev Returns the current implementation.
735      *
736      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
737      *
738      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
739      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
740      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
741      */
742     function implementation() external ifAdmin returns (address implementation_) {
743         implementation_ = _implementation();
744     }
745 
746     /**
747      * @dev Changes the admin of the proxy.
748      *
749      * Emits an {AdminChanged} event.
750      *
751      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
752      */
753     function changeAdmin(address newAdmin) external virtual ifAdmin {
754         _changeAdmin(newAdmin);
755     }
756 
757     /**
758      * @dev Upgrade the implementation of the proxy.
759      *
760      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
761      */
762     function upgradeTo(address newImplementation) external ifAdmin {
763         _upgradeToAndCall(newImplementation, bytes(""), false);
764     }
765 
766     /**
767      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
768      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
769      * proxied contract.
770      *
771      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
772      */
773     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
774         _upgradeToAndCall(newImplementation, data, true);
775     }
776 
777     /**
778      * @dev Returns the current admin.
779      */
780     function _admin() internal view virtual returns (address) {
781         return _getAdmin();
782     }
783 
784     /**
785      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
786      */
787     function _beforeFallback() internal virtual override {
788         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
789         super._beforeFallback();
790     }
791 }
792 
793 // File: contracts/DID/proxy.sol
794 
795 
796 pragma solidity ^0.8.14;