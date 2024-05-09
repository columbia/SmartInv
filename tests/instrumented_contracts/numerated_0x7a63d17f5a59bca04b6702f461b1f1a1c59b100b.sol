1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.8.9;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Checks if provided address is not zero
11      */
12     function ensureNotZero(address _address) pure internal {
13         require(_address != address(0), "Zero address");
14     }
15 
16     /**
17      * @dev Returns true if `account` is a contract.
18      *
19      * [IMPORTANT]
20      * ====
21      * It is unsafe to assume that an address for which this function returns
22      * false is an externally-owned account (EOA) and not a contract.
23      *
24      * Among others, `isContract` will return false for the following
25      * types of addresses:
26      *
27      *  - an externally-owned account
28      *  - a contract in construction
29      *  - an address where a contract will be created
30      *  - an address where a contract lived, but was destroyed
31      * ====
32      *
33      * [IMPORTANT]
34      * ====
35      * You shouldn't rely on `isContract` to protect against flash loan attacks!
36      *
37      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
38      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
39      * constructor.
40      * ====
41      */
42     function isContract(address account) internal view returns (bool) {
43         // This method relies on extcodesize/address.code.length, which returns 0
44         // for contracts in construction, since the code is only stored at the end
45         // of the constructor execution.
46 
47         return account.code.length > 0;
48     }
49 
50     /**
51      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
52      * `recipient`, forwarding all available gas and reverting on errors.
53      *
54      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
55      * of certain opcodes, possibly making contracts go over the 2300 gas limit
56      * imposed by `transfer`, making them unable to receive funds via
57      * `transfer`. {sendValue} removes this limitation.
58      *
59      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
60      *
61      * IMPORTANT: because control is transferred to `recipient`, care must be
62      * taken to not create reentrancy vulnerabilities. Consider using
63      * {ReentrancyGuard} or the
64      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
65      */
66     function sendValue(address payable recipient, uint256 amount) internal {
67         require(address(this).balance >= amount, "Address: insufficient balance");
68 
69         (bool success, ) = recipient.call{value: amount}("");
70         require(success, "Address: unable to send value, recipient may have reverted");
71     }
72 
73     /**
74      * @dev Performs a Solidity function call using a low level `call`. A
75      * plain `call` is an unsafe replacement for a function call: use this
76      * function instead.
77      *
78      * If `target` reverts with a revert reason, it is bubbled up by this
79      * function (like regular Solidity function calls).
80      *
81      * Returns the raw returned data. To convert to the expected return value,
82      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
83      *
84      * Requirements:
85      *
86      * - `target` must be a contract.
87      * - calling `target` with `data` must not revert.
88      */
89     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
90         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
95      * `errorMessage` as a fallback revert reason when `target` reverts.
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      */
114     function functionCallWithValue(
115         address target,
116         bytes memory data,
117         uint256 value
118     ) internal returns (bytes memory) {
119         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
120     }
121 
122     /**
123      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
124      * with `errorMessage` as a fallback revert reason when `target` reverts.
125      */
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value,
130         string memory errorMessage
131     ) internal returns (bytes memory) {
132         require(address(this).balance >= value, "Address: insufficient balance for call");
133         require(isContract(target), "Address: call to non-contract");
134 
135         (bool success, bytes memory returndata) = target.call{value: value}(data);
136         return verifyCallResult(success, returndata, errorMessage);
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
141      * but performing a static call.
142      */
143     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
144         return functionStaticCall(target, data, "Address: low-level static call failed");
145     }
146 
147     /**
148      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
149      * but performing a static call.
150      */
151     function functionStaticCall(
152         address target,
153         bytes memory data,
154         string memory errorMessage
155     ) internal view returns (bytes memory) {
156         require(isContract(target), "Address: static call to non-contract");
157 
158         (bool success, bytes memory returndata) = target.staticcall(data);
159         return verifyCallResult(success, returndata, errorMessage);
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
164      * but performing a delegate call.
165      */
166     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
167         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
172      * but performing a delegate call.
173      */
174     function functionDelegateCall(
175         address target,
176         bytes memory data,
177         string memory errorMessage
178     ) internal returns (bytes memory) {
179         require(isContract(target), "Address: delegate call to non-contract");
180 
181         (bool success, bytes memory returndata) = target.delegatecall(data);
182         return verifyCallResult(success, returndata, errorMessage);
183     }
184 
185     /**
186      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
187      * revert reason using the provided one.
188      */
189     function verifyCallResult(
190         bool success,
191         bytes memory returndata,
192         string memory errorMessage
193     ) internal pure returns (bytes memory) {
194         if (success) {
195             return returndata;
196         } else {
197             // Look for revert reason and bubble it up if present
198             if (returndata.length > 0) {
199                 // The easiest way to bubble the revert reason is using memory via assembly
200                 /// @solidity memory-safe-assembly
201                 assembly {
202                     let returndata_size := mload(returndata)
203                     revert(add(32, returndata), returndata_size)
204                 }
205             } else {
206                 revert(errorMessage);
207             }
208         }
209     }
210 }
211 
212 /**
213  * @dev This is the interface that {BeaconProxy} expects of its beacon.
214  */
215 interface IBeacon {
216     /**
217      * @dev Must return an address that can be used as a delegate call target.
218      *
219      * {BeaconProxy} will check that this address is a contract.
220      */
221     function implementation() external view returns (address);
222 }
223 
224 /**
225  * @dev Library for reading and writing primitive types to specific storage slots.
226  *
227  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
228  * This library helps with reading and writing to such slots without the need for inline assembly.
229  *
230  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
231  *
232  * Example usage to set ERC1967 implementation slot:
233  * ```
234  * contract ERC1967 {
235  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
236  *
237  *     function _getImplementation() internal view returns (address) {
238  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
239  *     }
240  *
241  *     function _setImplementation(address newImplementation) internal {
242  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
243  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
244  *     }
245  * }
246  * ```
247  *
248  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
249  */
250 library StorageSlot {
251     struct AddressSlot {
252         address value;
253     }
254 
255     struct BooleanSlot {
256         bool value;
257     }
258 
259     struct Bytes32Slot {
260         bytes32 value;
261     }
262 
263     struct Uint256Slot {
264         uint256 value;
265     }
266 
267     /**
268      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
269      */
270     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
271         assembly {
272             r.slot := slot
273         }
274     }
275 
276     /**
277      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
278      */
279     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
280         assembly {
281             r.slot := slot
282         }
283     }
284 
285     /**
286      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
287      */
288     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
289         assembly {
290             r.slot := slot
291         }
292     }
293 
294     /**
295      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
296      */
297     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
298         assembly {
299             r.slot := slot
300         }
301     }
302 }
303 
304 /**
305  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
306  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
307  * be specified by overriding the virtual {_implementation} function.
308  *
309  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
310  * different contract through the {_delegate} function.
311  *
312  * The success and return data of the delegated call will be returned back to the caller of the proxy.
313  */
314 abstract contract Proxy {
315     /**
316      * @dev Delegates the current call to `implementation`.
317      *
318      * This function does not return to its internall call site, it will return directly to the external caller.
319      */
320     function _delegate(address implementation) internal virtual {
321         assembly {
322             // Copy msg.data. We take full control of memory in this inline assembly
323             // block because it will not return to Solidity code. We overwrite the
324             // Solidity scratch pad at memory position 0.
325             calldatacopy(0, 0, calldatasize())
326 
327             // Call the implementation.
328             // out and outsize are 0 because we don't know the size yet.
329             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
330 
331             // Copy the returned data.
332             returndatacopy(0, 0, returndatasize())
333 
334             switch result
335             // delegatecall returns 0 on error.
336             case 0 {
337                 revert(0, returndatasize())
338             }
339             default {
340                 return(0, returndatasize())
341             }
342         }
343     }
344 
345     /**
346      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
347      * and {_fallback} should delegate.
348      */
349     function _implementation() internal view virtual returns (address);
350 
351     /**
352      * @dev Delegates the current call to the address returned by `_implementation()`.
353      *
354      * This function does not return to its internall call site, it will return directly to the external caller.
355      */
356     function _fallback() internal virtual {
357         _beforeFallback();
358         _delegate(_implementation());
359     }
360 
361     /**
362      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
363      * function in the contract matches the call data.
364      */
365     fallback() external payable virtual {
366         _fallback();
367     }
368 
369     /**
370      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
371      * is empty.
372      */
373     receive() external payable virtual {
374         _fallback();
375     }
376 
377     /**
378      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
379      * call, or as part of the Solidity `fallback` or `receive` functions.
380      *
381      * If overriden should call `super._beforeFallback()`.
382      */
383     function _beforeFallback() internal virtual {}
384 }
385 
386 /**
387  * @dev This abstract contract provides getters and event emitting update functions for
388  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
389  *
390  * _Available since v4.1._
391  *
392  * @custom:oz-upgrades-unsafe-allow delegatecall
393  */
394 abstract contract ERC1967Upgrade {
395     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
396     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
397 
398     /**
399      * @dev Storage slot with the address of the current implementation.
400      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
401      * validated in the constructor.
402      */
403     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
404 
405     /**
406      * @dev Emitted when the implementation is upgraded.
407      */
408     event Upgraded(address indexed implementation);
409 
410     /**
411      * @dev Returns the current implementation address.
412      */
413     function _getImplementation() internal view returns (address) {
414         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
415     }
416 
417     /**
418      * @dev Stores a new address in the EIP1967 implementation slot.
419      */
420     function _setImplementation(address newImplementation) private {
421         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
422         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
423     }
424 
425     /**
426      * @dev Perform implementation upgrade
427      *
428      * Emits an {Upgraded} event.
429      */
430     function _upgradeTo(address newImplementation) internal {
431         _setImplementation(newImplementation);
432         emit Upgraded(newImplementation);
433     }
434 
435     /**
436      * @dev Perform implementation upgrade with additional setup call.
437      *
438      * Emits an {Upgraded} event.
439      */
440     function _upgradeToAndCall(
441         address newImplementation,
442         bytes memory data,
443         bool forceCall
444     ) internal {
445         _upgradeTo(newImplementation);
446         if (data.length > 0 || forceCall) {
447             Address.functionDelegateCall(newImplementation, data);
448         }
449     }
450 
451     /**
452      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
453      *
454      * Emits an {Upgraded} event.
455      */
456     function _upgradeToAndCallSecure(
457         address newImplementation,
458         bytes memory data,
459         bool forceCall
460     ) internal {
461         address oldImplementation = _getImplementation();
462 
463         // Initial upgrade and setup call
464         _setImplementation(newImplementation);
465         if (data.length > 0 || forceCall) {
466             Address.functionDelegateCall(newImplementation, data);
467         }
468 
469         // Perform rollback test if not already in progress
470         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
471         if (!rollbackTesting.value) {
472             // Trigger rollback using upgradeTo from the new implementation
473             rollbackTesting.value = true;
474             Address.functionDelegateCall(
475                 newImplementation,
476                 abi.encodeWithSignature("upgradeTo(address)", oldImplementation)
477             );
478             rollbackTesting.value = false;
479             // Check rollback was effective
480             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
481             // Finally reset to the new implementation and log the upgrade
482             _upgradeTo(newImplementation);
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
545         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
546         require(
547             Address.isContract(IBeacon(newBeacon).implementation()),
548             "ERC1967: beacon implementation is not a contract"
549         );
550         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
551     }
552 
553     /**
554      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
555      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
556      *
557      * Emits a {BeaconUpgraded} event.
558      */
559     function _upgradeBeaconToAndCall(
560         address newBeacon,
561         bytes memory data,
562         bool forceCall
563     ) internal {
564         _setBeacon(newBeacon);
565         emit BeaconUpgraded(newBeacon);
566         if (data.length > 0 || forceCall) {
567             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
568         }
569     }
570 }
571 
572 /**
573  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
574  * implementation address that can be changed. This address is stored in storage in the location specified by
575  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
576  * implementation behind the proxy.
577  */
578 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
579     /**
580      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
581      *
582      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
583      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
584      */
585     constructor(address _logic, bytes memory _data) payable {
586         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
587         _upgradeToAndCall(_logic, _data, false);
588     }
589 
590     /**
591      * @dev Returns the current implementation address.
592      */
593     function _implementation() internal view virtual override returns (address impl) {
594         return ERC1967Upgrade._getImplementation();
595     }
596 }
597 
598 /**
599  * @dev This contract implements a proxy that is upgradeable by an admin.
600  *
601  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
602  * clashing], which can potentially be used in an attack, this contract uses the
603  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
604  * things that go hand in hand:
605  *
606  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
607  * that call matches one of the admin functions exposed by the proxy itself.
608  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
609  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
610  * "admin cannot fallback to proxy target".
611  *
612  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
613  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
614  * to sudden errors when trying to call a function from the proxy implementation.
615  *
616  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
617  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
618  */
619 contract TransparentUpgradeableProxy is ERC1967Proxy {
620     /**
621      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
622      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
623      */
624     constructor(
625         address _logic,
626         address admin_,
627         bytes memory _data
628     ) payable ERC1967Proxy(_logic, _data) {
629         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
630         _changeAdmin(admin_);
631     }
632 
633     /**
634      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
635      */
636     modifier ifAdmin() {
637         if (msg.sender == _getAdmin()) {
638             _;
639         } else {
640             _fallback();
641         }
642     }
643 
644     /**
645      * @dev Returns the current admin.
646      *
647      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
648      *
649      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
650      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
651      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
652      */
653     function admin() external ifAdmin returns (address admin_) {
654         admin_ = _getAdmin();
655     }
656 
657     /**
658      * @dev Returns the current implementation.
659      *
660      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
661      *
662      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
663      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
664      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
665      */
666     function implementation() external ifAdmin returns (address implementation_) {
667         implementation_ = _implementation();
668     }
669 
670     /**
671      * @dev Changes the admin of the proxy.
672      *
673      * Emits an {AdminChanged} event.
674      *
675      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
676      */
677     function changeAdmin(address newAdmin) external virtual ifAdmin {
678         _changeAdmin(newAdmin);
679     }
680 
681     /**
682      * @dev Upgrade the implementation of the proxy.
683      *
684      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
685      */
686     function upgradeTo(address newImplementation) external ifAdmin {
687         _upgradeToAndCall(newImplementation, bytes(""), false);
688     }
689 
690     /**
691      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
692      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
693      * proxied contract.
694      *
695      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
696      */
697     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
698         _upgradeToAndCall(newImplementation, data, true);
699     }
700 
701     /**
702      * @dev Returns the current admin.
703      */
704     function _admin() internal view virtual returns (address) {
705         return _getAdmin();
706     }
707 
708     /**
709      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
710      */
711     function _beforeFallback() internal virtual override {
712         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
713         super._beforeFallback();
714     }
715 }