1 // SPDX-License-Identifier: MIT
2 
3 // Sources flattened with hardhat v2.6.5 https://hardhat.org
4 
5 // File @openzeppelin/contracts/proxy/Proxy.sol@v4.3.2
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
91 // File @openzeppelin/contracts/proxy/beacon/IBeacon.sol@v4.3.2
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev This is the interface that {BeaconProxy} expects of its beacon.
97  */
98 interface IBeacon {
99     /**
100      * @dev Must return an address that can be used as a delegate call target.
101      *
102      * {BeaconProxy} will check that this address is a contract.
103      */
104     function implementation() external view returns (address);
105 }
106 
107 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
108 
109 pragma solidity ^0.8.0;
110 
111 /**
112  * @dev Collection of functions related to the address type
113  */
114 library Address {
115     /**
116      * @dev Returns true if `account` is a contract.
117      *
118      * [IMPORTANT]
119      * ====
120      * It is unsafe to assume that an address for which this function returns
121      * false is an externally-owned account (EOA) and not a contract.
122      *
123      * Among others, `isContract` will return false for the following
124      * types of addresses:
125      *
126      *  - an externally-owned account
127      *  - a contract in construction
128      *  - an address where a contract will be created
129      *  - an address where a contract lived, but was destroyed
130      * ====
131      */
132     function isContract(address account) internal view returns (bool) {
133         // This method relies on extcodesize, which returns 0 for contracts in
134         // construction, since the code is only stored at the end of the
135         // constructor execution.
136 
137         uint256 size;
138         assembly {
139             size := extcodesize(account)
140         }
141         return size > 0;
142     }
143 
144     /**
145      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
146      * `recipient`, forwarding all available gas and reverting on errors.
147      *
148      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
149      * of certain opcodes, possibly making contracts go over the 2300 gas limit
150      * imposed by `transfer`, making them unable to receive funds via
151      * `transfer`. {sendValue} removes this limitation.
152      *
153      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
154      *
155      * IMPORTANT: because control is transferred to `recipient`, care must be
156      * taken to not create reentrancy vulnerabilities. Consider using
157      * {ReentrancyGuard} or the
158      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
159      */
160     function sendValue(address payable recipient, uint256 amount) internal {
161         require(address(this).balance >= amount, "Address: insufficient balance");
162 
163         (bool success, ) = recipient.call{ value: amount }("");
164         require(success, "Address: unable to send value, recipient may have reverted");
165     }
166 
167     /**
168      * @dev Performs a Solidity function call using a low level `call`. A
169      * plain `call` is an unsafe replacement for a function call: use this
170      * function instead.
171      *
172      * If `target` reverts with a revert reason, it is bubbled up by this
173      * function (like regular Solidity function calls).
174      *
175      * Returns the raw returned data. To convert to the expected return value,
176      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
177      *
178      * Requirements:
179      *
180      * - `target` must be a contract.
181      * - calling `target` with `data` must not revert.
182      *
183      * _Available since v3.1._
184      */
185     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
186         return functionCall(target, data, "Address: low-level call failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
191      * `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCall(
196         address target,
197         bytes memory data,
198         string memory errorMessage
199     ) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, 0, errorMessage);
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
205      * but also transferring `value` wei to `target`.
206      *
207      * Requirements:
208      *
209      * - the calling contract must have an ETH balance of at least `value`.
210      * - the called Solidity function must be `payable`.
211      *
212      * _Available since v3.1._
213      */
214     function functionCallWithValue(
215         address target,
216         bytes memory data,
217         uint256 value
218     ) internal returns (bytes memory) {
219         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
224      * with `errorMessage` as a fallback revert reason when `target` reverts.
225      *
226      * _Available since v3.1._
227      */
228     function functionCallWithValue(
229         address target,
230         bytes memory data,
231         uint256 value,
232         string memory errorMessage
233     ) internal returns (bytes memory) {
234         require(address(this).balance >= value, "Address: insufficient balance for call");
235         require(isContract(target), "Address: call to non-contract");
236 
237         (bool success, bytes memory returndata) = target.call{ value: value }(data);
238         return verifyCallResult(success, returndata, errorMessage);
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
243      * but performing a static call.
244      *
245      * _Available since v3.3._
246      */
247     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
248         return functionStaticCall(target, data, "Address: low-level static call failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
253      * but performing a static call.
254      *
255      * _Available since v3.3._
256      */
257     function functionStaticCall(
258         address target,
259         bytes memory data,
260         string memory errorMessage
261     ) internal view returns (bytes memory) {
262         require(isContract(target), "Address: static call to non-contract");
263 
264         (bool success, bytes memory returndata) = target.staticcall(data);
265         return verifyCallResult(success, returndata, errorMessage);
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
270      * but performing a delegate call.
271      *
272      * _Available since v3.4._
273      */
274     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
275         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
280      * but performing a delegate call.
281      *
282      * _Available since v3.4._
283      */
284     function functionDelegateCall(
285         address target,
286         bytes memory data,
287         string memory errorMessage
288     ) internal returns (bytes memory) {
289         require(isContract(target), "Address: delegate call to non-contract");
290 
291         (bool success, bytes memory returndata) = target.delegatecall(data);
292         return verifyCallResult(success, returndata, errorMessage);
293     }
294 
295     /**
296      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
297      * revert reason using the provided one.
298      *
299      * _Available since v4.3._
300      */
301     function verifyCallResult(
302         bool success,
303         bytes memory returndata,
304         string memory errorMessage
305     ) internal pure returns (bytes memory) {
306         if (success) {
307             return returndata;
308         } else {
309             // Look for revert reason and bubble it up if present
310             if (returndata.length > 0) {
311                 // The easiest way to bubble the revert reason is using memory via assembly
312 
313                 assembly {
314                     let returndata_size := mload(returndata)
315                     revert(add(32, returndata), returndata_size)
316                 }
317             } else {
318                 revert(errorMessage);
319             }
320         }
321     }
322 }
323 
324 // File @openzeppelin/contracts/utils/StorageSlot.sol@v4.3.2
325 
326 pragma solidity ^0.8.0;
327 
328 /**
329  * @dev Library for reading and writing primitive types to specific storage slots.
330  *
331  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
332  * This library helps with reading and writing to such slots without the need for inline assembly.
333  *
334  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
335  *
336  * Example usage to set ERC1967 implementation slot:
337  * ```
338  * contract ERC1967 {
339  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
340  *
341  *     function _getImplementation() internal view returns (address) {
342  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
343  *     }
344  *
345  *     function _setImplementation(address newImplementation) internal {
346  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
347  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
348  *     }
349  * }
350  * ```
351  *
352  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
353  */
354 library StorageSlot {
355     struct AddressSlot {
356         address value;
357     }
358 
359     struct BooleanSlot {
360         bool value;
361     }
362 
363     struct Bytes32Slot {
364         bytes32 value;
365     }
366 
367     struct Uint256Slot {
368         uint256 value;
369     }
370 
371     /**
372      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
373      */
374     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
375         assembly {
376             r.slot := slot
377         }
378     }
379 
380     /**
381      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
382      */
383     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
384         assembly {
385             r.slot := slot
386         }
387     }
388 
389     /**
390      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
391      */
392     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
393         assembly {
394             r.slot := slot
395         }
396     }
397 
398     /**
399      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
400      */
401     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
402         assembly {
403             r.slot := slot
404         }
405     }
406 }
407 
408 // File @openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol@v4.3.2
409 
410 pragma solidity ^0.8.2;
411 
412 /**
413  * @dev This abstract contract provides getters and event emitting update functions for
414  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
415  *
416  * _Available since v4.1._
417  *
418  * @custom:oz-upgrades-unsafe-allow delegatecall
419  */
420 abstract contract ERC1967Upgrade {
421     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
422     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
423 
424     /**
425      * @dev Storage slot with the address of the current implementation.
426      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
427      * validated in the constructor.
428      */
429     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
430 
431     /**
432      * @dev Emitted when the implementation is upgraded.
433      */
434     event Upgraded(address indexed implementation);
435 
436     /**
437      * @dev Returns the current implementation address.
438      */
439     function _getImplementation() internal view returns (address) {
440         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
441     }
442 
443     /**
444      * @dev Stores a new address in the EIP1967 implementation slot.
445      */
446     function _setImplementation(address newImplementation) private {
447         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
448         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
449     }
450 
451     /**
452      * @dev Perform implementation upgrade
453      *
454      * Emits an {Upgraded} event.
455      */
456     function _upgradeTo(address newImplementation) internal {
457         _setImplementation(newImplementation);
458         emit Upgraded(newImplementation);
459     }
460 
461     /**
462      * @dev Perform implementation upgrade with additional setup call.
463      *
464      * Emits an {Upgraded} event.
465      */
466     function _upgradeToAndCall(
467         address newImplementation,
468         bytes memory data,
469         bool forceCall
470     ) internal {
471         _upgradeTo(newImplementation);
472         if (data.length > 0 || forceCall) {
473             Address.functionDelegateCall(newImplementation, data);
474         }
475     }
476 
477     /**
478      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
479      *
480      * Emits an {Upgraded} event.
481      */
482     function _upgradeToAndCallSecure(
483         address newImplementation,
484         bytes memory data,
485         bool forceCall
486     ) internal {
487         address oldImplementation = _getImplementation();
488 
489         // Initial upgrade and setup call
490         _setImplementation(newImplementation);
491         if (data.length > 0 || forceCall) {
492             Address.functionDelegateCall(newImplementation, data);
493         }
494 
495         // Perform rollback test if not already in progress
496         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
497         if (!rollbackTesting.value) {
498             // Trigger rollback using upgradeTo from the new implementation
499             rollbackTesting.value = true;
500             Address.functionDelegateCall(
501                 newImplementation,
502                 abi.encodeWithSignature("upgradeTo(address)", oldImplementation)
503             );
504             rollbackTesting.value = false;
505             // Check rollback was effective
506             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
507             // Finally reset to the new implementation and log the upgrade
508             _upgradeTo(newImplementation);
509         }
510     }
511 
512     /**
513      * @dev Storage slot with the admin of the contract.
514      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
515      * validated in the constructor.
516      */
517     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
518 
519     /**
520      * @dev Emitted when the admin account has changed.
521      */
522     event AdminChanged(address previousAdmin, address newAdmin);
523 
524     /**
525      * @dev Returns the current admin.
526      */
527     function _getAdmin() internal view returns (address) {
528         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
529     }
530 
531     /**
532      * @dev Stores a new address in the EIP1967 admin slot.
533      */
534     function _setAdmin(address newAdmin) private {
535         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
536         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
537     }
538 
539     /**
540      * @dev Changes the admin of the proxy.
541      *
542      * Emits an {AdminChanged} event.
543      */
544     function _changeAdmin(address newAdmin) internal {
545         emit AdminChanged(_getAdmin(), newAdmin);
546         _setAdmin(newAdmin);
547     }
548 
549     /**
550      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
551      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
552      */
553     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
554 
555     /**
556      * @dev Emitted when the beacon is upgraded.
557      */
558     event BeaconUpgraded(address indexed beacon);
559 
560     /**
561      * @dev Returns the current beacon.
562      */
563     function _getBeacon() internal view returns (address) {
564         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
565     }
566 
567     /**
568      * @dev Stores a new beacon in the EIP1967 beacon slot.
569      */
570     function _setBeacon(address newBeacon) private {
571         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
572         require(
573             Address.isContract(IBeacon(newBeacon).implementation()),
574             "ERC1967: beacon implementation is not a contract"
575         );
576         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
577     }
578 
579     /**
580      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
581      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
582      *
583      * Emits a {BeaconUpgraded} event.
584      */
585     function _upgradeBeaconToAndCall(
586         address newBeacon,
587         bytes memory data,
588         bool forceCall
589     ) internal {
590         _setBeacon(newBeacon);
591         emit BeaconUpgraded(newBeacon);
592         if (data.length > 0 || forceCall) {
593             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
594         }
595     }
596 }
597 
598 // File @openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol@v4.3.2
599 
600 pragma solidity ^0.8.0;
601 
602 /**
603  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
604  * implementation address that can be changed. This address is stored in storage in the location specified by
605  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
606  * implementation behind the proxy.
607  */
608 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
609     /**
610      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
611      *
612      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
613      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
614      */
615     constructor(address _logic, bytes memory _data) payable {
616         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
617         _upgradeToAndCall(_logic, _data, false);
618     }
619 
620     /**
621      * @dev Returns the current implementation address.
622      */
623     function _implementation() internal view virtual override returns (address impl) {
624         return ERC1967Upgrade._getImplementation();
625     }
626 }
627 
628 // File @openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol@v4.3.2
629 
630 pragma solidity ^0.8.0;
631 
632 /**
633  * @dev This contract implements a proxy that is upgradeable by an admin.
634  *
635  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
636  * clashing], which can potentially be used in an attack, this contract uses the
637  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
638  * things that go hand in hand:
639  *
640  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
641  * that call matches one of the admin functions exposed by the proxy itself.
642  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
643  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
644  * "admin cannot fallback to proxy target".
645  *
646  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
647  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
648  * to sudden errors when trying to call a function from the proxy implementation.
649  *
650  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
651  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
652  */
653 contract TransparentUpgradeableProxy is ERC1967Proxy {
654     /**
655      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
656      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
657      */
658     constructor(
659         address _logic,
660         address admin_,
661         bytes memory _data
662     ) payable ERC1967Proxy(_logic, _data) {
663         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
664         _changeAdmin(admin_);
665     }
666 
667     /**
668      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
669      */
670     modifier ifAdmin() {
671         if (msg.sender == _getAdmin()) {
672             _;
673         } else {
674             _fallback();
675         }
676     }
677 
678     /**
679      * @dev Returns the current admin.
680      *
681      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
682      *
683      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
684      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
685      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
686      */
687     function admin() external ifAdmin returns (address admin_) {
688         admin_ = _getAdmin();
689     }
690 
691     /**
692      * @dev Returns the current implementation.
693      *
694      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
695      *
696      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
697      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
698      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
699      */
700     function implementation() external ifAdmin returns (address implementation_) {
701         implementation_ = _implementation();
702     }
703 
704     /**
705      * @dev Changes the admin of the proxy.
706      *
707      * Emits an {AdminChanged} event.
708      *
709      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
710      */
711     function changeAdmin(address newAdmin) external virtual ifAdmin {
712         _changeAdmin(newAdmin);
713     }
714 
715     /**
716      * @dev Upgrade the implementation of the proxy.
717      *
718      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
719      */
720     function upgradeTo(address newImplementation) external ifAdmin {
721         _upgradeToAndCall(newImplementation, bytes(""), false);
722     }
723 
724     /**
725      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
726      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
727      * proxied contract.
728      *
729      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
730      */
731     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
732         _upgradeToAndCall(newImplementation, data, true);
733     }
734 
735     /**
736      * @dev Returns the current admin.
737      */
738     function _admin() internal view virtual returns (address) {
739         return _getAdmin();
740     }
741 
742     /**
743      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
744      */
745     function _beforeFallback() internal virtual override {
746         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
747         super._beforeFallback();
748     }
749 }
750 
751 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
752 
753 pragma solidity ^0.8.0;
754 
755 /**
756  * @dev Provides information about the current execution context, including the
757  * sender of the transaction and its data. While these are generally available
758  * via msg.sender and msg.data, they should not be accessed in such a direct
759  * manner, since when dealing with meta-transactions the account sending and
760  * paying for execution may not be the actual sender (as far as an application
761  * is concerned).
762  *
763  * This contract is only required for intermediate, library-like contracts.
764  */
765 abstract contract Context {
766     function _msgSender() internal view virtual returns (address) {
767         return msg.sender;
768     }
769 
770     function _msgData() internal view virtual returns (bytes calldata) {
771         return msg.data;
772     }
773 }
774 
775 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
776 
777 pragma solidity ^0.8.0;
778 
779 /**
780  * @dev Contract module which provides a basic access control mechanism, where
781  * there is an account (an owner) that can be granted exclusive access to
782  * specific functions.
783  *
784  * By default, the owner account will be the one that deploys the contract. This
785  * can later be changed with {transferOwnership}.
786  *
787  * This module is used through inheritance. It will make available the modifier
788  * `onlyOwner`, which can be applied to your functions to restrict their use to
789  * the owner.
790  */
791 abstract contract Ownable is Context {
792     address private _owner;
793 
794     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
795 
796     /**
797      * @dev Initializes the contract setting the deployer as the initial owner.
798      */
799     constructor() {
800         _setOwner(_msgSender());
801     }
802 
803     /**
804      * @dev Returns the address of the current owner.
805      */
806     function owner() public view virtual returns (address) {
807         return _owner;
808     }
809 
810     /**
811      * @dev Throws if called by any account other than the owner.
812      */
813     modifier onlyOwner() {
814         require(owner() == _msgSender(), "Ownable: caller is not the owner");
815         _;
816     }
817 
818     /**
819      * @dev Leaves the contract without owner. It will not be possible to call
820      * `onlyOwner` functions anymore. Can only be called by the current owner.
821      *
822      * NOTE: Renouncing ownership will leave the contract without an owner,
823      * thereby removing any functionality that is only available to the owner.
824      */
825     function renounceOwnership() public virtual onlyOwner {
826         _setOwner(address(0));
827     }
828 
829     /**
830      * @dev Transfers ownership of the contract to a new account (`newOwner`).
831      * Can only be called by the current owner.
832      */
833     function transferOwnership(address newOwner) public virtual onlyOwner {
834         require(newOwner != address(0), "Ownable: new owner is the zero address");
835         _setOwner(newOwner);
836     }
837 
838     function _setOwner(address newOwner) private {
839         address oldOwner = _owner;
840         _owner = newOwner;
841         emit OwnershipTransferred(oldOwner, newOwner);
842     }
843 }
844 
845 // File @openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol@v4.3.2
846 
847 pragma solidity ^0.8.0;
848 
849 /**
850  * @dev This is an auxiliary contract meant to be assigned as the admin of a {TransparentUpgradeableProxy}. For an
851  * explanation of why you would want to use this see the documentation for {TransparentUpgradeableProxy}.
852  */
853 contract ProxyAdmin is Ownable {
854     /**
855      * @dev Returns the current implementation of `proxy`.
856      *
857      * Requirements:
858      *
859      * - This contract must be the admin of `proxy`.
860      */
861     function getProxyImplementation(TransparentUpgradeableProxy proxy) public view virtual returns (address) {
862         // We need to manually run the static call since the getter cannot be flagged as view
863         // bytes4(keccak256("implementation()")) == 0x5c60da1b
864         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"5c60da1b");
865         require(success);
866         return abi.decode(returndata, (address));
867     }
868 
869     /**
870      * @dev Returns the current admin of `proxy`.
871      *
872      * Requirements:
873      *
874      * - This contract must be the admin of `proxy`.
875      */
876     function getProxyAdmin(TransparentUpgradeableProxy proxy) public view virtual returns (address) {
877         // We need to manually run the static call since the getter cannot be flagged as view
878         // bytes4(keccak256("admin()")) == 0xf851a440
879         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"f851a440");
880         require(success);
881         return abi.decode(returndata, (address));
882     }
883 
884     /**
885      * @dev Changes the admin of `proxy` to `newAdmin`.
886      *
887      * Requirements:
888      *
889      * - This contract must be the current admin of `proxy`.
890      */
891     function changeProxyAdmin(TransparentUpgradeableProxy proxy, address newAdmin) public virtual onlyOwner {
892         proxy.changeAdmin(newAdmin);
893     }
894 
895     /**
896      * @dev Upgrades `proxy` to `implementation`. See {TransparentUpgradeableProxy-upgradeTo}.
897      *
898      * Requirements:
899      *
900      * - This contract must be the admin of `proxy`.
901      */
902     function upgrade(TransparentUpgradeableProxy proxy, address implementation) public virtual onlyOwner {
903         proxy.upgradeTo(implementation);
904     }
905 
906     /**
907      * @dev Upgrades `proxy` to `implementation` and calls a function on the new implementation. See
908      * {TransparentUpgradeableProxy-upgradeToAndCall}.
909      *
910      * Requirements:
911      *
912      * - This contract must be the admin of `proxy`.
913      */
914     function upgradeAndCall(
915         TransparentUpgradeableProxy proxy,
916         address implementation,
917         bytes memory data
918     ) public payable virtual onlyOwner {
919         proxy.upgradeToAndCall{ value: msg.value }(implementation, data);
920     }
921 }
922 
923 // File contracts/test/TestProxy.sol
924 pragma solidity 0.8.9;
925 
926 contract TestProxy {}