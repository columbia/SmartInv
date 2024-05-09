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
91 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
92 
93 pragma solidity ^0.8.0;
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
115      */
116     function isContract(address account) internal view returns (bool) {
117         // This method relies on extcodesize, which returns 0 for contracts in
118         // construction, since the code is only stored at the end of the
119         // constructor execution.
120 
121         uint256 size;
122         assembly {
123             size := extcodesize(account)
124         }
125         return size > 0;
126     }
127 
128     /**
129      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
130      * `recipient`, forwarding all available gas and reverting on errors.
131      *
132      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
133      * of certain opcodes, possibly making contracts go over the 2300 gas limit
134      * imposed by `transfer`, making them unable to receive funds via
135      * `transfer`. {sendValue} removes this limitation.
136      *
137      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
138      *
139      * IMPORTANT: because control is transferred to `recipient`, care must be
140      * taken to not create reentrancy vulnerabilities. Consider using
141      * {ReentrancyGuard} or the
142      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
143      */
144     function sendValue(address payable recipient, uint256 amount) internal {
145         require(address(this).balance >= amount, "Address: insufficient balance");
146 
147         (bool success, ) = recipient.call{value: amount}("");
148         require(success, "Address: unable to send value, recipient may have reverted");
149     }
150 
151     /**
152      * @dev Performs a Solidity function call using a low level `call`. A
153      * plain `call` is an unsafe replacement for a function call: use this
154      * function instead.
155      *
156      * If `target` reverts with a revert reason, it is bubbled up by this
157      * function (like regular Solidity function calls).
158      *
159      * Returns the raw returned data. To convert to the expected return value,
160      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
161      *
162      * Requirements:
163      *
164      * - `target` must be a contract.
165      * - calling `target` with `data` must not revert.
166      *
167      * _Available since v3.1._
168      */
169     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
170         return functionCall(target, data, "Address: low-level call failed");
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
175      * `errorMessage` as a fallback revert reason when `target` reverts.
176      *
177      * _Available since v3.1._
178      */
179     function functionCall(
180         address target,
181         bytes memory data,
182         string memory errorMessage
183     ) internal returns (bytes memory) {
184         return functionCallWithValue(target, data, 0, errorMessage);
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
189      * but also transferring `value` wei to `target`.
190      *
191      * Requirements:
192      *
193      * - the calling contract must have an ETH balance of at least `value`.
194      * - the called Solidity function must be `payable`.
195      *
196      * _Available since v3.1._
197      */
198     function functionCallWithValue(
199         address target,
200         bytes memory data,
201         uint256 value
202     ) internal returns (bytes memory) {
203         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
208      * with `errorMessage` as a fallback revert reason when `target` reverts.
209      *
210      * _Available since v3.1._
211      */
212     function functionCallWithValue(
213         address target,
214         bytes memory data,
215         uint256 value,
216         string memory errorMessage
217     ) internal returns (bytes memory) {
218         require(address(this).balance >= value, "Address: insufficient balance for call");
219         require(isContract(target), "Address: call to non-contract");
220 
221         (bool success, bytes memory returndata) = target.call{value: value}(data);
222         return verifyCallResult(success, returndata, errorMessage);
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
227      * but performing a static call.
228      *
229      * _Available since v3.3._
230      */
231     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
232         return functionStaticCall(target, data, "Address: low-level static call failed");
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
237      * but performing a static call.
238      *
239      * _Available since v3.3._
240      */
241     function functionStaticCall(
242         address target,
243         bytes memory data,
244         string memory errorMessage
245     ) internal view returns (bytes memory) {
246         require(isContract(target), "Address: static call to non-contract");
247 
248         (bool success, bytes memory returndata) = target.staticcall(data);
249         return verifyCallResult(success, returndata, errorMessage);
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
254      * but performing a delegate call.
255      *
256      * _Available since v3.4._
257      */
258     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
259         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
264      * but performing a delegate call.
265      *
266      * _Available since v3.4._
267      */
268     function functionDelegateCall(
269         address target,
270         bytes memory data,
271         string memory errorMessage
272     ) internal returns (bytes memory) {
273         require(isContract(target), "Address: delegate call to non-contract");
274 
275         (bool success, bytes memory returndata) = target.delegatecall(data);
276         return verifyCallResult(success, returndata, errorMessage);
277     }
278 
279     /**
280      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
281      * revert reason using the provided one.
282      *
283      * _Available since v4.3._
284      */
285     function verifyCallResult(
286         bool success,
287         bytes memory returndata,
288         string memory errorMessage
289     ) internal pure returns (bytes memory) {
290         if (success) {
291             return returndata;
292         } else {
293             // Look for revert reason and bubble it up if present
294             if (returndata.length > 0) {
295                 // The easiest way to bubble the revert reason is using memory via assembly
296 
297                 assembly {
298                     let returndata_size := mload(returndata)
299                     revert(add(32, returndata), returndata_size)
300                 }
301             } else {
302                 revert(errorMessage);
303             }
304         }
305     }
306 }
307 
308 // File: @openzeppelin/contracts/proxy/beacon/IBeacon.sol
309 
310 
311 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
312 
313 pragma solidity ^0.8.0;
314 
315 /**
316  * @dev This is the interface that {BeaconProxy} expects of its beacon.
317  */
318 interface IBeacon {
319     /**
320      * @dev Must return an address that can be used as a delegate call target.
321      *
322      * {BeaconProxy} will check that this address is a contract.
323      */
324     function implementation() external view returns (address);
325 }
326 
327 // File: @openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol
328 
329 
330 // OpenZeppelin Contracts v4.4.1 (proxy/ERC1967/ERC1967Upgrade.sol)
331 
332 pragma solidity ^0.8.2;
333 
334 
335 
336 
337 /**
338  * @dev This abstract contract provides getters and event emitting update functions for
339  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
340  *
341  * _Available since v4.1._
342  *
343  * @custom:oz-upgrades-unsafe-allow delegatecall
344  */
345 abstract contract ERC1967Upgrade {
346     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
347     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
348 
349     /**
350      * @dev Storage slot with the address of the current implementation.
351      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
352      * validated in the constructor.
353      */
354     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
355 
356     /**
357      * @dev Emitted when the implementation is upgraded.
358      */
359     event Upgraded(address indexed implementation);
360 
361     /**
362      * @dev Returns the current implementation address.
363      */
364     function _getImplementation() internal view returns (address) {
365         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
366     }
367 
368     /**
369      * @dev Stores a new address in the EIP1967 implementation slot.
370      */
371     function _setImplementation(address newImplementation) private {
372         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
373         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
374     }
375 
376     /**
377      * @dev Perform implementation upgrade
378      *
379      * Emits an {Upgraded} event.
380      */
381     function _upgradeTo(address newImplementation) internal {
382         _setImplementation(newImplementation);
383         emit Upgraded(newImplementation);
384     }
385 
386     /**
387      * @dev Perform implementation upgrade with additional setup call.
388      *
389      * Emits an {Upgraded} event.
390      */
391     function _upgradeToAndCall(
392         address newImplementation,
393         bytes memory data,
394         bool forceCall
395     ) internal {
396         _upgradeTo(newImplementation);
397         if (data.length > 0 || forceCall) {
398             Address.functionDelegateCall(newImplementation, data);
399         }
400     }
401 
402     /**
403      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
404      *
405      * Emits an {Upgraded} event.
406      */
407     function _upgradeToAndCallSecure(
408         address newImplementation,
409         bytes memory data,
410         bool forceCall
411     ) internal {
412         address oldImplementation = _getImplementation();
413 
414         // Initial upgrade and setup call
415         _setImplementation(newImplementation);
416         if (data.length > 0 || forceCall) {
417             Address.functionDelegateCall(newImplementation, data);
418         }
419 
420         // Perform rollback test if not already in progress
421         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
422         if (!rollbackTesting.value) {
423             // Trigger rollback using upgradeTo from the new implementation
424             rollbackTesting.value = true;
425             Address.functionDelegateCall(
426                 newImplementation,
427                 abi.encodeWithSignature("upgradeTo(address)", oldImplementation)
428             );
429             rollbackTesting.value = false;
430             // Check rollback was effective
431             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
432             // Finally reset to the new implementation and log the upgrade
433             _upgradeTo(newImplementation);
434         }
435     }
436 
437     /**
438      * @dev Storage slot with the admin of the contract.
439      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
440      * validated in the constructor.
441      */
442     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
443 
444     /**
445      * @dev Emitted when the admin account has changed.
446      */
447     event AdminChanged(address previousAdmin, address newAdmin);
448 
449     /**
450      * @dev Returns the current admin.
451      */
452     function _getAdmin() internal view returns (address) {
453         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
454     }
455 
456     /**
457      * @dev Stores a new address in the EIP1967 admin slot.
458      */
459     function _setAdmin(address newAdmin) private {
460         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
461         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
462     }
463 
464     /**
465      * @dev Changes the admin of the proxy.
466      *
467      * Emits an {AdminChanged} event.
468      */
469     function _changeAdmin(address newAdmin) internal {
470         emit AdminChanged(_getAdmin(), newAdmin);
471         _setAdmin(newAdmin);
472     }
473 
474     /**
475      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
476      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
477      */
478     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
479 
480     /**
481      * @dev Emitted when the beacon is upgraded.
482      */
483     event BeaconUpgraded(address indexed beacon);
484 
485     /**
486      * @dev Returns the current beacon.
487      */
488     function _getBeacon() internal view returns (address) {
489         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
490     }
491 
492     /**
493      * @dev Stores a new beacon in the EIP1967 beacon slot.
494      */
495     function _setBeacon(address newBeacon) private {
496         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
497         require(
498             Address.isContract(IBeacon(newBeacon).implementation()),
499             "ERC1967: beacon implementation is not a contract"
500         );
501         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
502     }
503 
504     /**
505      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
506      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
507      *
508      * Emits a {BeaconUpgraded} event.
509      */
510     function _upgradeBeaconToAndCall(
511         address newBeacon,
512         bytes memory data,
513         bool forceCall
514     ) internal {
515         _setBeacon(newBeacon);
516         emit BeaconUpgraded(newBeacon);
517         if (data.length > 0 || forceCall) {
518             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
519         }
520     }
521 }
522 
523 // File: @openzeppelin/contracts/proxy/Proxy.sol
524 
525 
526 // OpenZeppelin Contracts v4.4.1 (proxy/Proxy.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 /**
531  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
532  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
533  * be specified by overriding the virtual {_implementation} function.
534  *
535  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
536  * different contract through the {_delegate} function.
537  *
538  * The success and return data of the delegated call will be returned back to the caller of the proxy.
539  */
540 abstract contract Proxy {
541     /**
542      * @dev Delegates the current call to `implementation`.
543      *
544      * This function does not return to its internall call site, it will return directly to the external caller.
545      */
546     function _delegate(address implementation) internal virtual {
547         assembly {
548             // Copy msg.data. We take full control of memory in this inline assembly
549             // block because it will not return to Solidity code. We overwrite the
550             // Solidity scratch pad at memory position 0.
551             calldatacopy(0, 0, calldatasize())
552 
553             // Call the implementation.
554             // out and outsize are 0 because we don't know the size yet.
555             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
556 
557             // Copy the returned data.
558             returndatacopy(0, 0, returndatasize())
559 
560             switch result
561             // delegatecall returns 0 on error.
562             case 0 {
563                 revert(0, returndatasize())
564             }
565             default {
566                 return(0, returndatasize())
567             }
568         }
569     }
570 
571     /**
572      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
573      * and {_fallback} should delegate.
574      */
575     function _implementation() internal view virtual returns (address);
576 
577     /**
578      * @dev Delegates the current call to the address returned by `_implementation()`.
579      *
580      * This function does not return to its internall call site, it will return directly to the external caller.
581      */
582     function _fallback() internal virtual {
583         _beforeFallback();
584         _delegate(_implementation());
585     }
586 
587     /**
588      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
589      * function in the contract matches the call data.
590      */
591     fallback() external payable virtual {
592         _fallback();
593     }
594 
595     /**
596      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
597      * is empty.
598      */
599     receive() external payable virtual {
600         _fallback();
601     }
602 
603     /**
604      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
605      * call, or as part of the Solidity `fallback` or `receive` functions.
606      *
607      * If overriden should call `super._beforeFallback()`.
608      */
609     function _beforeFallback() internal virtual {}
610 }
611 
612 // File: @openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol
613 
614 
615 // OpenZeppelin Contracts v4.4.1 (proxy/ERC1967/ERC1967Proxy.sol)
616 
617 pragma solidity ^0.8.0;
618 
619 
620 
621 /**
622  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
623  * implementation address that can be changed. This address is stored in storage in the location specified by
624  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
625  * implementation behind the proxy.
626  */
627 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
628     /**
629      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
630      *
631      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
632      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
633      */
634     constructor(address _logic, bytes memory _data) payable {
635         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
636         _upgradeToAndCall(_logic, _data, false);
637     }
638 
639     /**
640      * @dev Returns the current implementation address.
641      */
642     function _implementation() internal view virtual override returns (address impl) {
643         return ERC1967Upgrade._getImplementation();
644     }
645 }
646 
647 // File: @openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol
648 
649 
650 // OpenZeppelin Contracts v4.4.1 (proxy/transparent/TransparentUpgradeableProxy.sol)
651 
652 pragma solidity ^0.8.0;
653 
654 
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
686         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
687         _changeAdmin(admin_);
688     }
689 
690     /**
691      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
692      */
693     modifier ifAdmin() {
694         if (msg.sender == _getAdmin()) {
695             _;
696         } else {
697             _fallback();
698         }
699     }
700 
701     /**
702      * @dev Returns the current admin.
703      *
704      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
705      *
706      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
707      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
708      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
709      */
710     function admin() external ifAdmin returns (address admin_) {
711         admin_ = _getAdmin();
712     }
713 
714     /**
715      * @dev Returns the current implementation.
716      *
717      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
718      *
719      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
720      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
721      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
722      */
723     function implementation() external ifAdmin returns (address implementation_) {
724         implementation_ = _implementation();
725     }
726 
727     /**
728      * @dev Changes the admin of the proxy.
729      *
730      * Emits an {AdminChanged} event.
731      *
732      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
733      */
734     function changeAdmin(address newAdmin) external virtual ifAdmin {
735         _changeAdmin(newAdmin);
736     }
737 
738     /**
739      * @dev Upgrade the implementation of the proxy.
740      *
741      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
742      */
743     function upgradeTo(address newImplementation) external ifAdmin {
744         _upgradeToAndCall(newImplementation, bytes(""), false);
745     }
746 
747     /**
748      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
749      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
750      * proxied contract.
751      *
752      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
753      */
754     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
755         _upgradeToAndCall(newImplementation, data, true);
756     }
757 
758     /**
759      * @dev Returns the current admin.
760      */
761     function _admin() internal view virtual returns (address) {
762         return _getAdmin();
763     }
764 
765     /**
766      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
767      */
768     function _beforeFallback() internal virtual override {
769         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
770         super._beforeFallback();
771     }
772 }