1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.6;
4 
5 
6 
7 // Part: Address
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
36         // solhint-disable-next-line no-inline-assembly
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
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
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: value }(data);
124         return _verifyCallResult(success, returndata, errorMessage);
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
129      * but performing a static call.
130      *
131      * _Available since v3.3._
132      */
133     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
134         return functionStaticCall(target, data, "Address: low-level static call failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
144         require(isContract(target), "Address: static call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.staticcall(data);
148         return _verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
153      * but performing a delegate call.
154      *
155      * _Available since v3.4._
156      */
157     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
163      * but performing a delegate call.
164      *
165      * _Available since v3.4._
166      */
167     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
168         require(isContract(target), "Address: delegate call to non-contract");
169 
170         // solhint-disable-next-line avoid-low-level-calls
171         (bool success, bytes memory returndata) = target.delegatecall(data);
172         return _verifyCallResult(success, returndata, errorMessage);
173     }
174 
175     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
176         if (success) {
177             return returndata;
178         } else {
179             // Look for revert reason and bubble it up if present
180             if (returndata.length > 0) {
181                 // The easiest way to bubble the revert reason is using memory via assembly
182 
183                 // solhint-disable-next-line no-inline-assembly
184                 assembly {
185                     let returndata_size := mload(returndata)
186                     revert(add(32, returndata), returndata_size)
187                 }
188             } else {
189                 revert(errorMessage);
190             }
191         }
192     }
193 }
194 
195 // Part: IBeacon
196 
197 /**
198  * @dev This is the interface that {BeaconProxy} expects of its beacon.
199  */
200 interface IBeacon {
201     /**
202      * @dev Must return an address that can be used as a delegate call target.
203      *
204      * {BeaconProxy} will check that this address is a contract.
205      */
206     function implementation() external view returns (address);
207 }
208 
209 // Part: Proxy
210 
211 /**
212  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
213  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
214  * be specified by overriding the virtual {_implementation} function.
215  *
216  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
217  * different contract through the {_delegate} function.
218  *
219  * The success and return data of the delegated call will be returned back to the caller of the proxy.
220  */
221 abstract contract Proxy {
222     /**
223      * @dev Delegates the current call to `implementation`.
224      *
225      * This function does not return to its internall call site, it will return directly to the external caller.
226      */
227     function _delegate(address implementation) internal virtual {
228         // solhint-disable-next-line no-inline-assembly
229         assembly {
230             // Copy msg.data. We take full control of memory in this inline assembly
231             // block because it will not return to Solidity code. We overwrite the
232             // Solidity scratch pad at memory position 0.
233             calldatacopy(0, 0, calldatasize())
234 
235             // Call the implementation.
236             // out and outsize are 0 because we don't know the size yet.
237             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
238 
239             // Copy the returned data.
240             returndatacopy(0, 0, returndatasize())
241 
242             switch result
243             // delegatecall returns 0 on error.
244             case 0 { revert(0, returndatasize()) }
245             default { return(0, returndatasize()) }
246         }
247     }
248 
249     /**
250      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
251      * and {_fallback} should delegate.
252      */
253     function _implementation() internal view virtual returns (address);
254 
255     /**
256      * @dev Delegates the current call to the address returned by `_implementation()`.
257      *
258      * This function does not return to its internall call site, it will return directly to the external caller.
259      */
260     function _fallback() internal virtual {
261         _beforeFallback();
262         _delegate(_implementation());
263     }
264 
265     /**
266      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
267      * function in the contract matches the call data.
268      */
269     fallback () external payable virtual {
270         _fallback();
271     }
272 
273     /**
274      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
275      * is empty.
276      */
277     receive () external payable virtual {
278         _fallback();
279     }
280 
281     /**
282      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
283      * call, or as part of the Solidity `fallback` or `receive` functions.
284      *
285      * If overriden should call `super._beforeFallback()`.
286      */
287     function _beforeFallback() internal virtual {
288     }
289 }
290 
291 // Part: StorageSlot
292 
293 /**
294  * @dev Library for reading and writing primitive types to specific storage slots.
295  *
296  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
297  * This library helps with reading and writing to such slots without the need for inline assembly.
298  *
299  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
300  *
301  * Example usage to set ERC1967 implementation slot:
302  * ```
303  * contract ERC1967 {
304  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
305  *
306  *     function _getImplementation() internal view returns (address) {
307  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
308  *     }
309  *
310  *     function _setImplementation(address newImplementation) internal {
311  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
312  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
313  *     }
314  * }
315  * ```
316  *
317  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
318  */
319 library StorageSlot {
320     struct AddressSlot {
321         address value;
322     }
323 
324     struct BooleanSlot {
325         bool value;
326     }
327 
328     struct Bytes32Slot {
329         bytes32 value;
330     }
331 
332     struct Uint256Slot {
333         uint256 value;
334     }
335 
336     /**
337      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
338      */
339     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
340         assembly {
341             r.slot := slot
342         }
343     }
344 
345     /**
346      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
347      */
348     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
349         assembly {
350             r.slot := slot
351         }
352     }
353 
354     /**
355      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
356      */
357     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
358         assembly {
359             r.slot := slot
360         }
361     }
362 
363     /**
364      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
365      */
366     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
367         assembly {
368             r.slot := slot
369         }
370     }
371 }
372 
373 // Part: ERC1967Upgrade
374 
375 /**
376  * @dev This abstract contract provides getters and event emitting update functions for
377  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
378  *
379  * _Available since v4.1._
380  *
381  * @custom:oz-upgrades-unsafe-allow delegatecall
382  */
383 abstract contract ERC1967Upgrade {
384     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
385     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
386 
387     /**
388      * @dev Storage slot with the address of the current implementation.
389      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
390      * validated in the constructor.
391      */
392     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
393 
394     /**
395      * @dev Emitted when the implementation is upgraded.
396      */
397     event Upgraded(address indexed implementation);
398 
399     /**
400      * @dev Returns the current implementation address.
401      */
402     function _getImplementation() internal view returns (address) {
403         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
404     }
405 
406     /**
407      * @dev Stores a new address in the EIP1967 implementation slot.
408      */
409     function _setImplementation(address newImplementation) private {
410         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
411         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
412     }
413 
414     /**
415      * @dev Perform implementation upgrade
416      *
417      * Emits an {Upgraded} event.
418      */
419     function _upgradeTo(address newImplementation) internal {
420         _setImplementation(newImplementation);
421         emit Upgraded(newImplementation);
422     }
423 
424     /**
425      * @dev Perform implementation upgrade with additional setup call.
426      *
427      * Emits an {Upgraded} event.
428      */
429     function _upgradeToAndCall(address newImplementation, bytes memory data, bool forceCall) internal {
430         _setImplementation(newImplementation);
431         emit Upgraded(newImplementation);
432         if (data.length > 0 || forceCall) {
433             Address.functionDelegateCall(newImplementation, data);
434         }
435     }
436 
437     /**
438      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
439      *
440      * Emits an {Upgraded} event.
441      */
442     function _upgradeToAndCallSecure(address newImplementation, bytes memory data, bool forceCall) internal {
443         address oldImplementation = _getImplementation();
444 
445         // Initial upgrade and setup call
446         _setImplementation(newImplementation);
447         if (data.length > 0 || forceCall) {
448             Address.functionDelegateCall(newImplementation, data);
449         }
450 
451         // Perform rollback test if not already in progress
452         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
453         if (!rollbackTesting.value) {
454             // Trigger rollback using upgradeTo from the new implementation
455             rollbackTesting.value = true;
456             Address.functionDelegateCall(
457                 newImplementation,
458                 abi.encodeWithSignature(
459                     "upgradeTo(address)",
460                     oldImplementation
461                 )
462             );
463             rollbackTesting.value = false;
464             // Check rollback was effective
465             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
466             // Finally reset to the new implementation and log the upgrade
467             _setImplementation(newImplementation);
468             emit Upgraded(newImplementation);
469         }
470     }
471 
472     /**
473      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
474      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
475      *
476      * Emits a {BeaconUpgraded} event.
477      */
478     function _upgradeBeaconToAndCall(address newBeacon, bytes memory data, bool forceCall) internal {
479         _setBeacon(newBeacon);
480         emit BeaconUpgraded(newBeacon);
481         if (data.length > 0 || forceCall) {
482             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
483         }
484     }
485 
486     /**
487      * @dev Storage slot with the admin of the contract.
488      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
489      * validated in the constructor.
490      */
491     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
492 
493     /**
494      * @dev Emitted when the admin account has changed.
495      */
496     event AdminChanged(address previousAdmin, address newAdmin);
497 
498     /**
499      * @dev Returns the current admin.
500      */
501     function _getAdmin() internal view returns (address) {
502         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
503     }
504 
505     /**
506      * @dev Stores a new address in the EIP1967 admin slot.
507      */
508     function _setAdmin(address newAdmin) private {
509         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
510         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
511     }
512 
513     /**
514      * @dev Changes the admin of the proxy.
515      *
516      * Emits an {AdminChanged} event.
517      */
518     function _changeAdmin(address newAdmin) internal {
519         emit AdminChanged(_getAdmin(), newAdmin);
520         _setAdmin(newAdmin);
521     }
522 
523     /**
524      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
525      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
526      */
527     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
528 
529     /**
530      * @dev Emitted when the beacon is upgraded.
531      */
532     event BeaconUpgraded(address indexed beacon);
533 
534     /**
535      * @dev Returns the current beacon.
536      */
537     function _getBeacon() internal view returns (address) {
538         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
539     }
540 
541     /**
542      * @dev Stores a new beacon in the EIP1967 beacon slot.
543      */
544     function _setBeacon(address newBeacon) private {
545         require(
546             Address.isContract(newBeacon),
547             "ERC1967: new beacon is not a contract"
548         );
549         require(
550             Address.isContract(IBeacon(newBeacon).implementation()),
551             "ERC1967: beacon implementation is not a contract"
552         );
553         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
554     }
555 }
556 
557 // Part: ERC1967Proxy
558 
559 /**
560  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
561  * implementation address that can be changed. This address is stored in storage in the location specified by
562  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
563  * implementation behind the proxy.
564  */
565 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
566     /**
567      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
568      *
569      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
570      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
571      */
572     constructor(address _logic, bytes memory _data) payable {
573         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
574         _upgradeToAndCall(_logic, _data, false);
575     }
576 
577     /**
578      * @dev Returns the current implementation address.
579      */
580     function _implementation() internal view virtual override returns (address impl) {
581         return ERC1967Upgrade._getImplementation();
582     }
583 }
584 
585 // Part: TransparentUpgradeableProxy
586 
587 /**
588  * @dev This contract implements a proxy that is upgradeable by an admin.
589  *
590  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
591  * clashing], which can potentially be used in an attack, this contract uses the
592  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
593  * things that go hand in hand:
594  *
595  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
596  * that call matches one of the admin functions exposed by the proxy itself.
597  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
598  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
599  * "admin cannot fallback to proxy target".
600  *
601  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
602  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
603  * to sudden errors when trying to call a function from the proxy implementation.
604  *
605  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
606  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
607  */
608 contract TransparentUpgradeableProxy is ERC1967Proxy {
609     /**
610      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
611      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
612      */
613     constructor(address _logic, address admin_, bytes memory _data) payable ERC1967Proxy(_logic, _data) {
614         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
615         _changeAdmin(admin_);
616     }
617 
618     /**
619      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
620      */
621     modifier ifAdmin() {
622         if (msg.sender == _getAdmin()) {
623             _;
624         } else {
625             _fallback();
626         }
627     }
628 
629     /**
630      * @dev Returns the current admin.
631      *
632      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
633      *
634      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
635      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
636      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
637      */
638     function admin() external ifAdmin returns (address admin_) {
639         admin_ = _getAdmin();
640     }
641 
642     /**
643      * @dev Returns the current implementation.
644      *
645      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
646      *
647      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
648      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
649      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
650      */
651     function implementation() external ifAdmin returns (address implementation_) {
652         implementation_ = _implementation();
653     }
654 
655     /**
656      * @dev Changes the admin of the proxy.
657      *
658      * Emits an {AdminChanged} event.
659      *
660      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
661      */
662     function changeAdmin(address newAdmin) external virtual ifAdmin {
663         _changeAdmin(newAdmin);
664     }
665 
666     /**
667      * @dev Upgrade the implementation of the proxy.
668      *
669      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
670      */
671     function upgradeTo(address newImplementation) external ifAdmin {
672         _upgradeToAndCall(newImplementation, bytes(""), false);
673     }
674 
675     /**
676      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
677      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
678      * proxied contract.
679      *
680      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
681      */
682     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
683         _upgradeToAndCall(newImplementation, data, true);
684     }
685 
686     /**
687      * @dev Returns the current admin.
688      */
689     function _admin() internal view virtual returns (address) {
690         return _getAdmin();
691     }
692 
693     /**
694      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
695      */
696     function _beforeFallback() internal virtual override {
697         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
698         super._beforeFallback();
699     }
700 }
701 
702 // File: PadProxy.sol
703 
704 // TODO rename this to Proxy
705 contract PadProxy is TransparentUpgradeableProxy {
706     
707     constructor(
708         address _logic,
709         address admin_,
710         bytes memory _data
711     ) payable TransparentUpgradeableProxy(_logic, admin_, _data) {}
712 }
