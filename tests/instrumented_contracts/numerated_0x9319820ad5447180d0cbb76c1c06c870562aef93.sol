1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
7  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
8  * be specified by overriding the virtual {_implementation} function.
9  *
10  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
11  * different contract through the {_delegate} function.
12  *
13  * The success and return data of the delegated call will be returned back to the caller of the proxy.
14  */
15 abstract contract Proxy {
16     /**
17      * @dev Delegates the current call to `implementation`.
18      *
19      * This function does not return to its internall call site, it will return directly to the external caller.
20      */
21     function _delegate(address implementation) internal virtual {
22         // solhint-disable-next-line no-inline-assembly
23         assembly {
24             // Copy msg.data. We take full control of memory in this inline assembly
25             // block because it will not return to Solidity code. We overwrite the
26             // Solidity scratch pad at memory position 0.
27             calldatacopy(0, 0, calldatasize())
28 
29             // Call the implementation.
30             // out and outsize are 0 because we don't know the size yet.
31             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
32 
33             // Copy the returned data.
34             returndatacopy(0, 0, returndatasize())
35 
36             switch result
37             // delegatecall returns 0 on error.
38             case 0 { revert(0, returndatasize()) }
39             default { return(0, returndatasize()) }
40         }
41     }
42 
43     /**
44      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
45      * and {_fallback} should delegate.
46      */
47     function _implementation() internal view virtual returns (address);
48 
49     /**
50      * @dev Delegates the current call to the address returned by `_implementation()`.
51      *
52      * This function does not return to its internall call site, it will return directly to the external caller.
53      */
54     function _fallback() internal virtual {
55         _beforeFallback();
56         _delegate(_implementation());
57     }
58 
59     /**
60      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
61      * function in the contract matches the call data.
62      */
63     fallback () external payable virtual {
64         _fallback();
65     }
66 
67     /**
68      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
69      * is empty.
70      */
71     receive () external payable virtual {
72         _fallback();
73     }
74 
75     /**
76      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
77      * call, or as part of the Solidity `fallback` or `receive` functions.
78      *
79      * If overriden should call `super._beforeFallback()`.
80      */
81     function _beforeFallback() internal virtual {
82     }
83 }
84 
85 /**
86  * @dev This is the interface that {BeaconProxy} expects of its beacon.
87  */
88 interface IBeacon {
89     /**
90      * @dev Must return an address that can be used as a delegate call target.
91      *
92      * {BeaconProxy} will check that this address is a contract.
93      */
94     function implementation() external view returns (address);
95 }
96 
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @dev Collection of functions related to the address type
101  */
102 library Address {
103     /**
104      * @dev Returns true if `account` is a contract.
105      *
106      * [IMPORTANT]
107      * ====
108      * It is unsafe to assume that an address for which this function returns
109      * false is an externally-owned account (EOA) and not a contract.
110      *
111      * Among others, `isContract` will return false for the following
112      * types of addresses:
113      *
114      *  - an externally-owned account
115      *  - a contract in construction
116      *  - an address where a contract will be created
117      *  - an address where a contract lived, but was destroyed
118      * ====
119      */
120     function isContract(address account) internal view returns (bool) {
121         // This method relies on extcodesize, which returns 0 for contracts in
122         // construction, since the code is only stored at the end of the
123         // constructor execution.
124 
125         uint256 size;
126         // solhint-disable-next-line no-inline-assembly
127         assembly { size := extcodesize(account) }
128         return size > 0;
129     }
130 
131     /**
132      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
133      * `recipient`, forwarding all available gas and reverting on errors.
134      *
135      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
136      * of certain opcodes, possibly making contracts go over the 2300 gas limit
137      * imposed by `transfer`, making them unable to receive funds via
138      * `transfer`. {sendValue} removes this limitation.
139      *
140      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
141      *
142      * IMPORTANT: because control is transferred to `recipient`, care must be
143      * taken to not create reentrancy vulnerabilities. Consider using
144      * {ReentrancyGuard} or the
145      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
146      */
147     function sendValue(address payable recipient, uint256 amount) internal {
148         require(address(this).balance >= amount, "Address: insufficient balance");
149 
150         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
151         (bool success, ) = recipient.call{ value: amount }("");
152         require(success, "Address: unable to send value, recipient may have reverted");
153     }
154 
155     /**
156      * @dev Performs a Solidity function call using a low level `call`. A
157      * plain`call` is an unsafe replacement for a function call: use this
158      * function instead.
159      *
160      * If `target` reverts with a revert reason, it is bubbled up by this
161      * function (like regular Solidity function calls).
162      *
163      * Returns the raw returned data. To convert to the expected return value,
164      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
165      *
166      * Requirements:
167      *
168      * - `target` must be a contract.
169      * - calling `target` with `data` must not revert.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
174       return functionCall(target, data, "Address: low-level call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
179      * `errorMessage` as a fallback revert reason when `target` reverts.
180      *
181      * _Available since v3.1._
182      */
183     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
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
198     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204      * with `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
209         require(address(this).balance >= value, "Address: insufficient balance for call");
210         require(isContract(target), "Address: call to non-contract");
211 
212         // solhint-disable-next-line avoid-low-level-calls
213         (bool success, bytes memory returndata) = target.call{ value: value }(data);
214         return _verifyCallResult(success, returndata, errorMessage);
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
219      * but performing a static call.
220      *
221      * _Available since v3.3._
222      */
223     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
224         return functionStaticCall(target, data, "Address: low-level static call failed");
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
229      * but performing a static call.
230      *
231      * _Available since v3.3._
232      */
233     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
234         require(isContract(target), "Address: static call to non-contract");
235 
236         // solhint-disable-next-line avoid-low-level-calls
237         (bool success, bytes memory returndata) = target.staticcall(data);
238         return _verifyCallResult(success, returndata, errorMessage);
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
243      * but performing a delegate call.
244      *
245      * _Available since v3.4._
246      */
247     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
248         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
253      * but performing a delegate call.
254      *
255      * _Available since v3.4._
256      */
257     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
258         require(isContract(target), "Address: delegate call to non-contract");
259 
260         // solhint-disable-next-line avoid-low-level-calls
261         (bool success, bytes memory returndata) = target.delegatecall(data);
262         return _verifyCallResult(success, returndata, errorMessage);
263     }
264 
265     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
266         if (success) {
267             return returndata;
268         } else {
269             // Look for revert reason and bubble it up if present
270             if (returndata.length > 0) {
271                 // The easiest way to bubble the revert reason is using memory via assembly
272 
273                 // solhint-disable-next-line no-inline-assembly
274                 assembly {
275                     let returndata_size := mload(returndata)
276                     revert(add(32, returndata), returndata_size)
277                 }
278             } else {
279                 revert(errorMessage);
280             }
281         }
282     }
283 }
284 
285 /**
286  * @dev Library for reading and writing primitive types to specific storage slots.
287  *
288  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
289  * This library helps with reading and writing to such slots without the need for inline assembly.
290  *
291  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
292  *
293  * Example usage to set ERC1967 implementation slot:
294  * ```
295  * contract ERC1967 {
296  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
297  *
298  *     function _getImplementation() internal view returns (address) {
299  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
300  *     }
301  *
302  *     function _setImplementation(address newImplementation) internal {
303  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
304  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
305  *     }
306  * }
307  * ```
308  *
309  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
310  */
311 library StorageSlot {
312     struct AddressSlot {
313         address value;
314     }
315 
316     struct BooleanSlot {
317         bool value;
318     }
319 
320     struct Bytes32Slot {
321         bytes32 value;
322     }
323 
324     struct Uint256Slot {
325         uint256 value;
326     }
327 
328     /**
329      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
330      */
331     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
332         assembly {
333             r.slot := slot
334         }
335     }
336 
337     /**
338      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
339      */
340     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
341         assembly {
342             r.slot := slot
343         }
344     }
345 
346     /**
347      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
348      */
349     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
350         assembly {
351             r.slot := slot
352         }
353     }
354 
355     /**
356      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
357      */
358     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
359         assembly {
360             r.slot := slot
361         }
362     }
363 }
364 
365 pragma solidity ^0.8.2;
366 
367 
368 
369 /**
370  * @dev This abstract contract provides getters and event emitting update functions for
371  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
372  *
373  * _Available since v4.1._
374  *
375  * @custom:oz-upgrades-unsafe-allow delegatecall
376  */
377 abstract contract ERC1967Upgrade {
378     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
379     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
380 
381     /**
382      * @dev Storage slot with the address of the current implementation.
383      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
384      * validated in the constructor.
385      */
386     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
387 
388     /**
389      * @dev Emitted when the implementation is upgraded.
390      */
391     event Upgraded(address indexed implementation);
392 
393     /**
394      * @dev Returns the current implementation address.
395      */
396     function _getImplementation() internal view returns (address) {
397         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
398     }
399 
400     /**
401      * @dev Stores a new address in the EIP1967 implementation slot.
402      */
403     function _setImplementation(address newImplementation) private {
404         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
405         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
406     }
407 
408     /**
409      * @dev Perform implementation upgrade
410      *
411      * Emits an {Upgraded} event.
412      */
413     function _upgradeTo(address newImplementation) internal {
414         _setImplementation(newImplementation);
415         emit Upgraded(newImplementation);
416     }
417 
418     /**
419      * @dev Perform implementation upgrade with additional setup call.
420      *
421      * Emits an {Upgraded} event.
422      */
423     function _upgradeToAndCall(address newImplementation, bytes memory data, bool forceCall) internal {
424         _setImplementation(newImplementation);
425         emit Upgraded(newImplementation);
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
436     function _upgradeToAndCallSecure(address newImplementation, bytes memory data, bool forceCall) internal {
437         address oldImplementation = _getImplementation();
438 
439         // Initial upgrade and setup call
440         _setImplementation(newImplementation);
441         if (data.length > 0 || forceCall) {
442             Address.functionDelegateCall(newImplementation, data);
443         }
444 
445         // Perform rollback test if not already in progress
446         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
447         if (!rollbackTesting.value) {
448             // Trigger rollback using upgradeTo from the new implementation
449             rollbackTesting.value = true;
450             Address.functionDelegateCall(
451                 newImplementation,
452                 abi.encodeWithSignature(
453                     "upgradeTo(address)",
454                     oldImplementation
455                 )
456             );
457             rollbackTesting.value = false;
458             // Check rollback was effective
459             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
460             // Finally reset to the new implementation and log the upgrade
461             _setImplementation(newImplementation);
462             emit Upgraded(newImplementation);
463         }
464     }
465 
466     /**
467      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
468      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
469      *
470      * Emits a {BeaconUpgraded} event.
471      */
472     function _upgradeBeaconToAndCall(address newBeacon, bytes memory data, bool forceCall) internal {
473         _setBeacon(newBeacon);
474         emit BeaconUpgraded(newBeacon);
475         if (data.length > 0 || forceCall) {
476             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
477         }
478     }
479 
480     /**
481      * @dev Storage slot with the admin of the contract.
482      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
483      * validated in the constructor.
484      */
485     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
486 
487     /**
488      * @dev Emitted when the admin account has changed.
489      */
490     event AdminChanged(address previousAdmin, address newAdmin);
491 
492     /**
493      * @dev Returns the current admin.
494      */
495     function _getAdmin() internal view returns (address) {
496         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
497     }
498 
499     /**
500      * @dev Stores a new address in the EIP1967 admin slot.
501      */
502     function _setAdmin(address newAdmin) private {
503         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
504         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
505     }
506 
507     /**
508      * @dev Changes the admin of the proxy.
509      *
510      * Emits an {AdminChanged} event.
511      */
512     function _changeAdmin(address newAdmin) internal {
513         emit AdminChanged(_getAdmin(), newAdmin);
514         _setAdmin(newAdmin);
515     }
516 
517     /**
518      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
519      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
520      */
521     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
522 
523     /**
524      * @dev Emitted when the beacon is upgraded.
525      */
526     event BeaconUpgraded(address indexed beacon);
527 
528     /**
529      * @dev Returns the current beacon.
530      */
531     function _getBeacon() internal view returns (address) {
532         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
533     }
534 
535     /**
536      * @dev Stores a new beacon in the EIP1967 beacon slot.
537      */
538     function _setBeacon(address newBeacon) private {
539         require(
540             Address.isContract(newBeacon),
541             "ERC1967: new beacon is not a contract"
542         );
543         require(
544             Address.isContract(IBeacon(newBeacon).implementation()),
545             "ERC1967: beacon implementation is not a contract"
546         );
547         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
548     }
549 }
550 
551 pragma solidity ^0.8.0;
552 
553 
554 /**
555  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
556  * implementation address that can be changed. This address is stored in storage in the location specified by
557  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
558  * implementation behind the proxy.
559  */
560 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
561     /**
562      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
563      *
564      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
565      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
566      */
567     constructor(address _logic, bytes memory _data) payable {
568         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
569         _upgradeToAndCall(_logic, _data, false);
570     }
571 
572     /**
573      * @dev Returns the current implementation address.
574      */
575     function _implementation() internal view virtual override returns (address impl) {
576         return ERC1967Upgrade._getImplementation();
577     }
578 }
579 
580 pragma solidity ^0.8.0;
581 
582 /**
583  * @dev This contract implements a proxy that is upgradeable by an admin.
584  *
585  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
586  * clashing], which can potentially be used in an attack, this contract uses the
587  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
588  * things that go hand in hand:
589  *
590  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
591  * that call matches one of the admin functions exposed by the proxy itself.
592  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
593  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
594  * "admin cannot fallback to proxy target".
595  *
596  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
597  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
598  * to sudden errors when trying to call a function from the proxy implementation.
599  *
600  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
601  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
602  */
603 contract TransparentUpgradeableProxy is ERC1967Proxy {
604     /**
605      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
606      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
607      */
608     constructor(address _logic, address admin_, bytes memory _data) payable ERC1967Proxy(_logic, _data) {
609         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
610         _changeAdmin(admin_);
611     }
612 
613     /**
614      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
615      */
616     modifier ifAdmin() {
617         if (msg.sender == _getAdmin()) {
618             _;
619         } else {
620             _fallback();
621         }
622     }
623 
624     /**
625      * @dev Returns the current admin.
626      *
627      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
628      *
629      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
630      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
631      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
632      */
633     function admin() external ifAdmin returns (address admin_) {
634         admin_ = _getAdmin();
635     }
636 
637     /**
638      * @dev Returns the current implementation.
639      *
640      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
641      *
642      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
643      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
644      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
645      */
646     function implementation() external ifAdmin returns (address implementation_) {
647         implementation_ = _implementation();
648     }
649 
650     /**
651      * @dev Changes the admin of the proxy.
652      *
653      * Emits an {AdminChanged} event.
654      *
655      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
656      */
657     function changeAdmin(address newAdmin) external virtual ifAdmin {
658         _changeAdmin(newAdmin);
659     }
660 
661     /**
662      * @dev Upgrade the implementation of the proxy.
663      *
664      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
665      */
666     function upgradeTo(address newImplementation) external ifAdmin {
667         _upgradeToAndCall(newImplementation, bytes(""), false);
668     }
669 
670     /**
671      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
672      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
673      * proxied contract.
674      *
675      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
676      */
677     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
678         _upgradeToAndCall(newImplementation, data, true);
679     }
680 
681     /**
682      * @dev Returns the current admin.
683      */
684     function _admin() internal view virtual returns (address) {
685         return _getAdmin();
686     }
687 
688     /**
689      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
690      */
691     function _beforeFallback() internal virtual override {
692         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
693         super._beforeFallback();
694     }
695 }
696 
697 contract OceidonBloxUpgradeableProxy is TransparentUpgradeableProxy {
698     constructor(address logic, address admin) TransparentUpgradeableProxy(logic, admin, '') public {
699     }
700 }