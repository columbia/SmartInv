1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Library for reading and writing primitive types to specific storage slots.
7  *
8  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
9  * This library helps with reading and writing to such slots without the need for inline assembly.
10  *
11  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
12  *
13  * Example usage to set ERC1967 implementation slot:
14  * ```
15  * contract ERC1967 {
16  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
17  *
18  *     function _getImplementation() internal view returns (address) {
19  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
20  *     }
21  *
22  *     function _setImplementation(address newImplementation) internal {
23  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
24  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
25  *     }
26  * }
27  * ```
28  *
29  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
30  */
31 library StorageSlot {
32     struct AddressSlot {
33         address value;
34     }
35 
36     struct BooleanSlot {
37         bool value;
38     }
39 
40     struct Bytes32Slot {
41         bytes32 value;
42     }
43 
44     struct Uint256Slot {
45         uint256 value;
46     }
47 
48     /**
49      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
50      */
51     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
52         assembly {
53             r.slot := slot
54         }
55     }
56 
57     /**
58      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
59      */
60     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
61         assembly {
62             r.slot := slot
63         }
64     }
65 
66     /**
67      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
68      */
69     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
70         assembly {
71             r.slot := slot
72         }
73     }
74 
75     /**
76      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
77      */
78     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
79         assembly {
80             r.slot := slot
81         }
82     }
83 }
84 
85 /**
86  * @dev Collection of functions related to the address type
87  */
88 library Address {
89     /**
90      * @dev Returns true if `account` is a contract.
91      *
92      * [IMPORTANT]
93      * ====
94      * It is unsafe to assume that an address for which this function returns
95      * false is an externally-owned account (EOA) and not a contract.
96      *
97      * Among others, `isContract` will return false for the following
98      * types of addresses:
99      *
100      *  - an externally-owned account
101      *  - a contract in construction
102      *  - an address where a contract will be created
103      *  - an address where a contract lived, but was destroyed
104      * ====
105      */
106     function isContract(address account) internal view returns (bool) {
107         // This method relies on extcodesize, which returns 0 for contracts in
108         // construction, since the code is only stored at the end of the
109         // constructor execution.
110 
111         uint256 size;
112         // solhint-disable-next-line no-inline-assembly
113         assembly { size := extcodesize(account) }
114         return size > 0;
115     }
116 
117     /**
118      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
119      * `recipient`, forwarding all available gas and reverting on errors.
120      *
121      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
122      * of certain opcodes, possibly making contracts go over the 2300 gas limit
123      * imposed by `transfer`, making them unable to receive funds via
124      * `transfer`. {sendValue} removes this limitation.
125      *
126      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
127      *
128      * IMPORTANT: because control is transferred to `recipient`, care must be
129      * taken to not create reentrancy vulnerabilities. Consider using
130      * {ReentrancyGuard} or the
131      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
132      */
133     function sendValue(address payable recipient, uint256 amount) internal {
134         require(address(this).balance >= amount, "Address: insufficient balance");
135 
136         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
137         (bool success, ) = recipient.call{ value: amount }("");
138         require(success, "Address: unable to send value, recipient may have reverted");
139     }
140 
141     /**
142      * @dev Performs a Solidity function call using a low level `call`. A
143      * plain`call` is an unsafe replacement for a function call: use this
144      * function instead.
145      *
146      * If `target` reverts with a revert reason, it is bubbled up by this
147      * function (like regular Solidity function calls).
148      *
149      * Returns the raw returned data. To convert to the expected return value,
150      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
151      *
152      * Requirements:
153      *
154      * - `target` must be a contract.
155      * - calling `target` with `data` must not revert.
156      *
157      * _Available since v3.1._
158      */
159     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
160       return functionCall(target, data, "Address: low-level call failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
165      * `errorMessage` as a fallback revert reason when `target` reverts.
166      *
167      * _Available since v3.1._
168      */
169     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
170         return functionCallWithValue(target, data, 0, errorMessage);
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
175      * but also transferring `value` wei to `target`.
176      *
177      * Requirements:
178      *
179      * - the calling contract must have an ETH balance of at least `value`.
180      * - the called Solidity function must be `payable`.
181      *
182      * _Available since v3.1._
183      */
184     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
185         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
190      * with `errorMessage` as a fallback revert reason when `target` reverts.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
195         require(address(this).balance >= value, "Address: insufficient balance for call");
196         require(isContract(target), "Address: call to non-contract");
197 
198         // solhint-disable-next-line avoid-low-level-calls
199         (bool success, bytes memory returndata) = target.call{ value: value }(data);
200         return _verifyCallResult(success, returndata, errorMessage);
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
205      * but performing a static call.
206      *
207      * _Available since v3.3._
208      */
209     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
210         return functionStaticCall(target, data, "Address: low-level static call failed");
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
215      * but performing a static call.
216      *
217      * _Available since v3.3._
218      */
219     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
220         require(isContract(target), "Address: static call to non-contract");
221 
222         // solhint-disable-next-line avoid-low-level-calls
223         (bool success, bytes memory returndata) = target.staticcall(data);
224         return _verifyCallResult(success, returndata, errorMessage);
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
229      * but performing a delegate call.
230      *
231      * _Available since v3.4._
232      */
233     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
234         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
239      * but performing a delegate call.
240      *
241      * _Available since v3.4._
242      */
243     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
244         require(isContract(target), "Address: delegate call to non-contract");
245 
246         // solhint-disable-next-line avoid-low-level-calls
247         (bool success, bytes memory returndata) = target.delegatecall(data);
248         return _verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
252         if (success) {
253             return returndata;
254         } else {
255             // Look for revert reason and bubble it up if present
256             if (returndata.length > 0) {
257                 // The easiest way to bubble the revert reason is using memory via assembly
258 
259                 // solhint-disable-next-line no-inline-assembly
260                 assembly {
261                     let returndata_size := mload(returndata)
262                     revert(add(32, returndata), returndata_size)
263                 }
264             } else {
265                 revert(errorMessage);
266             }
267         }
268     }
269 }
270 
271 /**
272  * @dev This is the interface that {BeaconProxy} expects of its beacon.
273  */
274 interface IBeacon {
275     /**
276      * @dev Must return an address that can be used as a delegate call target.
277      *
278      * {BeaconProxy} will check that this address is a contract.
279      */
280     function implementation() external view returns (address);
281 }
282 
283 /**
284  * @dev This abstract contract provides getters and event emitting update functions for
285  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
286  *
287  * _Available since v4.1._
288  *
289  * @custom:oz-upgrades-unsafe-allow delegatecall
290  */
291 abstract contract ERC1967Upgrade {
292     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
293     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
294 
295     /**
296      * @dev Storage slot with the address of the current implementation.
297      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
298      * validated in the constructor.
299      */
300     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
301 
302     /**
303      * @dev Emitted when the implementation is upgraded.
304      */
305     event Upgraded(address indexed implementation);
306 
307     /**
308      * @dev Returns the current implementation address.
309      */
310     function _getImplementation() internal view returns (address) {
311         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
312     }
313 
314     /**
315      * @dev Stores a new address in the EIP1967 implementation slot.
316      */
317     function _setImplementation(address newImplementation) private {
318         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
319         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
320     }
321 
322     /**
323      * @dev Perform implementation upgrade
324      *
325      * Emits an {Upgraded} event.
326      */
327     function _upgradeTo(address newImplementation) internal {
328         _setImplementation(newImplementation);
329         emit Upgraded(newImplementation);
330     }
331 
332     /**
333      * @dev Perform implementation upgrade with additional setup call.
334      *
335      * Emits an {Upgraded} event.
336      */
337     function _upgradeToAndCall(address newImplementation, bytes memory data, bool forceCall) internal {
338         _setImplementation(newImplementation);
339         emit Upgraded(newImplementation);
340         if (data.length > 0 || forceCall) {
341             Address.functionDelegateCall(newImplementation, data);
342         }
343     }
344 
345     /**
346      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
347      *
348      * Emits an {Upgraded} event.
349      */
350     function _upgradeToAndCallSecure(address newImplementation, bytes memory data, bool forceCall) internal {
351         address oldImplementation = _getImplementation();
352 
353         // Initial upgrade and setup call
354         _setImplementation(newImplementation);
355         if (data.length > 0 || forceCall) {
356             Address.functionDelegateCall(newImplementation, data);
357         }
358 
359         // Perform rollback test if not already in progress
360         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
361         if (!rollbackTesting.value) {
362             // Trigger rollback using upgradeTo from the new implementation
363             rollbackTesting.value = true;
364             Address.functionDelegateCall(
365                 newImplementation,
366                 abi.encodeWithSignature(
367                     "upgradeTo(address)",
368                     oldImplementation
369                 )
370             );
371             rollbackTesting.value = false;
372             // Check rollback was effective
373             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
374             // Finally reset to the new implementation and log the upgrade
375             _setImplementation(newImplementation);
376             emit Upgraded(newImplementation);
377         }
378     }
379 
380     /**
381      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
382      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
383      *
384      * Emits a {BeaconUpgraded} event.
385      */
386     function _upgradeBeaconToAndCall(address newBeacon, bytes memory data, bool forceCall) internal {
387         _setBeacon(newBeacon);
388         emit BeaconUpgraded(newBeacon);
389         if (data.length > 0 || forceCall) {
390             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
391         }
392     }
393 
394     /**
395      * @dev Storage slot with the admin of the contract.
396      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
397      * validated in the constructor.
398      */
399     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
400 
401     /**
402      * @dev Emitted when the admin account has changed.
403      */
404     event AdminChanged(address previousAdmin, address newAdmin);
405 
406     /**
407      * @dev Returns the current admin.
408      */
409     function _getAdmin() internal view returns (address) {
410         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
411     }
412 
413     /**
414      * @dev Stores a new address in the EIP1967 admin slot.
415      */
416     function _setAdmin(address newAdmin) private {
417         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
418         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
419     }
420 
421     /**
422      * @dev Changes the admin of the proxy.
423      *
424      * Emits an {AdminChanged} event.
425      */
426     function _changeAdmin(address newAdmin) internal {
427         emit AdminChanged(_getAdmin(), newAdmin);
428         _setAdmin(newAdmin);
429     }
430 
431     /**
432      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
433      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
434      */
435     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
436 
437     /**
438      * @dev Emitted when the beacon is upgraded.
439      */
440     event BeaconUpgraded(address indexed beacon);
441 
442     /**
443      * @dev Returns the current beacon.
444      */
445     function _getBeacon() internal view returns (address) {
446         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
447     }
448 
449     /**
450      * @dev Stores a new beacon in the EIP1967 beacon slot.
451      */
452     function _setBeacon(address newBeacon) private {
453         require(
454             Address.isContract(newBeacon),
455             "ERC1967: new beacon is not a contract"
456         );
457         require(
458             Address.isContract(IBeacon(newBeacon).implementation()),
459             "ERC1967: beacon implementation is not a contract"
460         );
461         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
462     }
463 }
464 
465 /**
466  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
467  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
468  * be specified by overriding the virtual {_implementation} function.
469  *
470  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
471  * different contract through the {_delegate} function.
472  *
473  * The success and return data of the delegated call will be returned back to the caller of the proxy.
474  */
475 abstract contract Proxy {
476     /**
477      * @dev Delegates the current call to `implementation`.
478      *
479      * This function does not return to its internall call site, it will return directly to the external caller.
480      */
481     function _delegate(address implementation) internal virtual {
482         // solhint-disable-next-line no-inline-assembly
483         assembly {
484             // Copy msg.data. We take full control of memory in this inline assembly
485             // block because it will not return to Solidity code. We overwrite the
486             // Solidity scratch pad at memory position 0.
487             calldatacopy(0, 0, calldatasize())
488 
489             // Call the implementation.
490             // out and outsize are 0 because we don't know the size yet.
491             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
492 
493             // Copy the returned data.
494             returndatacopy(0, 0, returndatasize())
495 
496             switch result
497             // delegatecall returns 0 on error.
498             case 0 { revert(0, returndatasize()) }
499             default { return(0, returndatasize()) }
500         }
501     }
502 
503     /**
504      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
505      * and {_fallback} should delegate.
506      */
507     function _implementation() internal view virtual returns (address);
508 
509     /**
510      * @dev Delegates the current call to the address returned by `_implementation()`.
511      *
512      * This function does not return to its internall call site, it will return directly to the external caller.
513      */
514     function _fallback() internal virtual {
515         _beforeFallback();
516         _delegate(_implementation());
517     }
518 
519     /**
520      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
521      * function in the contract matches the call data.
522      */
523     fallback () external payable virtual {
524         _fallback();
525     }
526 
527     /**
528      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
529      * is empty.
530      */
531     receive () external payable virtual {
532         _fallback();
533     }
534 
535     /**
536      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
537      * call, or as part of the Solidity `fallback` or `receive` functions.
538      *
539      * If overriden should call `super._beforeFallback()`.
540      */
541     function _beforeFallback() internal virtual {
542     }
543 }
544 
545 /**
546  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
547  * implementation address that can be changed. This address is stored in storage in the location specified by
548  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
549  * implementation behind the proxy.
550  */
551 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
552     /**
553      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
554      *
555      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
556      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
557      */
558     constructor(address _logic, bytes memory _data) payable {
559         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
560         _upgradeToAndCall(_logic, _data, false);
561     }
562 
563     /**
564      * @dev Returns the current implementation address.
565      */
566     function _implementation() internal view virtual override returns (address impl) {
567         return ERC1967Upgrade._getImplementation();
568     }
569 }
570 
571 /**
572  * @dev This contract implements a proxy that is upgradeable by an admin.
573  *
574  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
575  * clashing], which can potentially be used in an attack, this contract uses the
576  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
577  * things that go hand in hand:
578  *
579  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
580  * that call matches one of the admin functions exposed by the proxy itself.
581  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
582  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
583  * "admin cannot fallback to proxy target".
584  *
585  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
586  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
587  * to sudden errors when trying to call a function from the proxy implementation.
588  *
589  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
590  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
591  */
592 contract TransparentUpgradeableProxy is ERC1967Proxy {
593     /**
594      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
595      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
596      */
597     constructor(address _logic, address admin_, bytes memory _data) payable ERC1967Proxy(_logic, _data) {
598         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
599         _changeAdmin(admin_);
600     }
601 
602     /**
603      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
604      */
605     modifier ifAdmin() {
606         if (msg.sender == _getAdmin()) {
607             _;
608         } else {
609             _fallback();
610         }
611     }
612 
613     /**
614      * @dev Returns the current admin.
615      *
616      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
617      *
618      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
619      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
620      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
621      */
622     function admin() external ifAdmin returns (address admin_) {
623         admin_ = _getAdmin();
624     }
625 
626     /**
627      * @dev Returns the current implementation.
628      *
629      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
630      *
631      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
632      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
633      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
634      */
635     function implementation() external ifAdmin returns (address implementation_) {
636         implementation_ = _implementation();
637     }
638 
639     /**
640      * @dev Changes the admin of the proxy.
641      *
642      * Emits an {AdminChanged} event.
643      *
644      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
645      */
646     function changeAdmin(address newAdmin) external virtual ifAdmin {
647         _changeAdmin(newAdmin);
648     }
649 
650     /**
651      * @dev Upgrade the implementation of the proxy.
652      *
653      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
654      */
655     function upgradeTo(address newImplementation) external ifAdmin {
656         _upgradeToAndCall(newImplementation, bytes(""), false);
657     }
658 
659     /**
660      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
661      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
662      * proxied contract.
663      *
664      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
665      */
666     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
667         _upgradeToAndCall(newImplementation, data, true);
668     }
669 
670     /**
671      * @dev Returns the current admin.
672      */
673     function _admin() internal view virtual returns (address) {
674         return _getAdmin();
675     }
676 
677     /**
678      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
679      */
680     function _beforeFallback() internal virtual override {
681         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
682         super._beforeFallback();
683     }
684 }