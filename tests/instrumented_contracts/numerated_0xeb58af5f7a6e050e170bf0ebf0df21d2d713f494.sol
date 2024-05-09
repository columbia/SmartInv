1 //SPDX-License-Identifier: None
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Library for reading and writing primitive types to specific storage slots.
6  *
7  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
8  * This library helps with reading and writing to such slots without the need for inline assembly.
9  *
10  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
11  *
12  * Example usage to set ERC1967 implementation slot:
13  * ```
14  * contract ERC1967 {
15  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
16  *
17  *     function _getImplementation() internal view returns (address) {
18  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
19  *     }
20  *
21  *     function _setImplementation(address newImplementation) internal {
22  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
23  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
24  *     }
25  * }
26  * ```
27  *
28  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
29  */
30 library StorageSlot {
31     struct AddressSlot {
32         address value;
33     }
34 
35     struct BooleanSlot {
36         bool value;
37     }
38 
39     struct Bytes32Slot {
40         bytes32 value;
41     }
42 
43     struct Uint256Slot {
44         uint256 value;
45     }
46 
47     /**
48      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
49      */
50     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
51         assembly {
52             r.slot := slot
53         }
54     }
55 
56     /**
57      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
58      */
59     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
60         assembly {
61             r.slot := slot
62         }
63     }
64 
65     /**
66      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
67      */
68     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
69         assembly {
70             r.slot := slot
71         }
72     }
73 
74     /**
75      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
76      */
77     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
78         assembly {
79             r.slot := slot
80         }
81     }
82 }
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev Collection of functions related to the address type
88  */
89 library Address {
90     /**
91      * @dev Returns true if `account` is a contract.
92      *
93      * [IMPORTANT]
94      * ====
95      * It is unsafe to assume that an address for which this function returns
96      * false is an externally-owned account (EOA) and not a contract.
97      *
98      * Among others, `isContract` will return false for the following
99      * types of addresses:
100      *
101      *  - an externally-owned account
102      *  - a contract in construction
103      *  - an address where a contract will be created
104      *  - an address where a contract lived, but was destroyed
105      * ====
106      */
107     function isContract(address account) internal view returns (bool) {
108         // This method relies on extcodesize, which returns 0 for contracts in
109         // construction, since the code is only stored at the end of the
110         // constructor execution.
111 
112         uint256 size;
113         assembly {
114             size := extcodesize(account)
115         }
116         return size > 0;
117     }
118 
119     /**
120      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
121      * `recipient`, forwarding all available gas and reverting on errors.
122      *
123      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
124      * of certain opcodes, possibly making contracts go over the 2300 gas limit
125      * imposed by `transfer`, making them unable to receive funds via
126      * `transfer`. {sendValue} removes this limitation.
127      *
128      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
129      *
130      * IMPORTANT: because control is transferred to `recipient`, care must be
131      * taken to not create reentrancy vulnerabilities. Consider using
132      * {ReentrancyGuard} or the
133      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
134      */
135     function sendValue(address payable recipient, uint256 amount) internal {
136         require(address(this).balance >= amount, "Address: insufficient balance");
137 
138         (bool success, ) = recipient.call{value: amount}("");
139         require(success, "Address: unable to send value, recipient may have reverted");
140     }
141 
142     /**
143      * @dev Performs a Solidity function call using a low level `call`. A
144      * plain `call` is an unsafe replacement for a function call: use this
145      * function instead.
146      *
147      * If `target` reverts with a revert reason, it is bubbled up by this
148      * function (like regular Solidity function calls).
149      *
150      * Returns the raw returned data. To convert to the expected return value,
151      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
152      *
153      * Requirements:
154      *
155      * - `target` must be a contract.
156      * - calling `target` with `data` must not revert.
157      *
158      * _Available since v3.1._
159      */
160     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
161         return functionCall(target, data, "Address: low-level call failed");
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
166      * `errorMessage` as a fallback revert reason when `target` reverts.
167      *
168      * _Available since v3.1._
169      */
170     function functionCall(
171         address target,
172         bytes memory data,
173         string memory errorMessage
174     ) internal returns (bytes memory) {
175         return functionCallWithValue(target, data, 0, errorMessage);
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
180      * but also transferring `value` wei to `target`.
181      *
182      * Requirements:
183      *
184      * - the calling contract must have an ETH balance of at least `value`.
185      * - the called Solidity function must be `payable`.
186      *
187      * _Available since v3.1._
188      */
189     function functionCallWithValue(
190         address target,
191         bytes memory data,
192         uint256 value
193     ) internal returns (bytes memory) {
194         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
199      * with `errorMessage` as a fallback revert reason when `target` reverts.
200      *
201      * _Available since v3.1._
202      */
203     function functionCallWithValue(
204         address target,
205         bytes memory data,
206         uint256 value,
207         string memory errorMessage
208     ) internal returns (bytes memory) {
209         require(address(this).balance >= value, "Address: insufficient balance for call");
210         require(isContract(target), "Address: call to non-contract");
211 
212         (bool success, bytes memory returndata) = target.call{value: value}(data);
213         return verifyCallResult(success, returndata, errorMessage);
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
218      * but performing a static call.
219      *
220      * _Available since v3.3._
221      */
222     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
223         return functionStaticCall(target, data, "Address: low-level static call failed");
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
228      * but performing a static call.
229      *
230      * _Available since v3.3._
231      */
232     function functionStaticCall(
233         address target,
234         bytes memory data,
235         string memory errorMessage
236     ) internal view returns (bytes memory) {
237         require(isContract(target), "Address: static call to non-contract");
238 
239         (bool success, bytes memory returndata) = target.staticcall(data);
240         return verifyCallResult(success, returndata, errorMessage);
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
245      * but performing a delegate call.
246      *
247      * _Available since v3.4._
248      */
249     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
250         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
255      * but performing a delegate call.
256      *
257      * _Available since v3.4._
258      */
259     function functionDelegateCall(
260         address target,
261         bytes memory data,
262         string memory errorMessage
263     ) internal returns (bytes memory) {
264         require(isContract(target), "Address: delegate call to non-contract");
265 
266         (bool success, bytes memory returndata) = target.delegatecall(data);
267         return verifyCallResult(success, returndata, errorMessage);
268     }
269 
270     /**
271      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
272      * revert reason using the provided one.
273      *
274      * _Available since v4.3._
275      */
276     function verifyCallResult(
277         bool success,
278         bytes memory returndata,
279         string memory errorMessage
280     ) internal pure returns (bytes memory) {
281         if (success) {
282             return returndata;
283         } else {
284             // Look for revert reason and bubble it up if present
285             if (returndata.length > 0) {
286                 // The easiest way to bubble the revert reason is using memory via assembly
287 
288                 assembly {
289                     let returndata_size := mload(returndata)
290                     revert(add(32, returndata), returndata_size)
291                 }
292             } else {
293                 revert(errorMessage);
294             }
295         }
296     }
297 }
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @dev This is the interface that {BeaconProxy} expects of its beacon.
303  */
304 interface IBeacon {
305     /**
306      * @dev Must return an address that can be used as a delegate call target.
307      *
308      * {BeaconProxy} will check that this address is a contract.
309      */
310     function implementation() external view returns (address);
311 }
312 
313 pragma solidity ^0.8.2;
314 
315 /**
316  * @dev This abstract contract provides getters and event emitting update functions for
317  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
318  *
319  * _Available since v4.1._
320  *
321  * @custom:oz-upgrades-unsafe-allow delegatecall
322  */
323 abstract contract ERC1967Upgrade {
324     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
325     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
326 
327     /**
328      * @dev Storage slot with the address of the current implementation.
329      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
330      * validated in the constructor.
331      */
332     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
333 
334     /**
335      * @dev Emitted when the implementation is upgraded.
336      */
337     event Upgraded(address indexed implementation);
338 
339     /**
340      * @dev Returns the current implementation address.
341      */
342     function _getImplementation() internal view returns (address) {
343         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
344     }
345 
346     /**
347      * @dev Stores a new address in the EIP1967 implementation slot.
348      */
349     function _setImplementation(address newImplementation) private {
350         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
351         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
352     }
353 
354     /**
355      * @dev Perform implementation upgrade
356      *
357      * Emits an {Upgraded} event.
358      */
359     function _upgradeTo(address newImplementation) internal {
360         _setImplementation(newImplementation);
361         emit Upgraded(newImplementation);
362     }
363 
364     /**
365      * @dev Perform implementation upgrade with additional setup call.
366      *
367      * Emits an {Upgraded} event.
368      */
369     function _upgradeToAndCall(
370         address newImplementation,
371         bytes memory data,
372         bool forceCall
373     ) internal {
374         _upgradeTo(newImplementation);
375         if (data.length > 0 || forceCall) {
376             Address.functionDelegateCall(newImplementation, data);
377         }
378     }
379 
380     /**
381      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
382      *
383      * Emits an {Upgraded} event.
384      */
385     function _upgradeToAndCallSecure(
386         address newImplementation,
387         bytes memory data,
388         bool forceCall
389     ) internal {
390         address oldImplementation = _getImplementation();
391 
392         // Initial upgrade and setup call
393         _setImplementation(newImplementation);
394         if (data.length > 0 || forceCall) {
395             Address.functionDelegateCall(newImplementation, data);
396         }
397 
398         // Perform rollback test if not already in progress
399         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
400         if (!rollbackTesting.value) {
401             // Trigger rollback using upgradeTo from the new implementation
402             rollbackTesting.value = true;
403             Address.functionDelegateCall(
404                 newImplementation,
405                 abi.encodeWithSignature("upgradeTo(address)", oldImplementation)
406             );
407             rollbackTesting.value = false;
408             // Check rollback was effective
409             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
410             // Finally reset to the new implementation and log the upgrade
411             _upgradeTo(newImplementation);
412         }
413     }
414 
415     /**
416      * @dev Storage slot with the admin of the contract.
417      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
418      * validated in the constructor.
419      */
420     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
421 
422     /**
423      * @dev Emitted when the admin account has changed.
424      */
425     event AdminChanged(address previousAdmin, address newAdmin);
426 
427     /**
428      * @dev Returns the current admin.
429      */
430     function _getAdmin() internal view returns (address) {
431         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
432     }
433 
434     /**
435      * @dev Stores a new address in the EIP1967 admin slot.
436      */
437     function _setAdmin(address newAdmin) private {
438         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
439         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
440     }
441 
442     /**
443      * @dev Changes the admin of the proxy.
444      *
445      * Emits an {AdminChanged} event.
446      */
447     function _changeAdmin(address newAdmin) internal {
448         emit AdminChanged(_getAdmin(), newAdmin);
449         _setAdmin(newAdmin);
450     }
451 
452     /**
453      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
454      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
455      */
456     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
457 
458     /**
459      * @dev Emitted when the beacon is upgraded.
460      */
461     event BeaconUpgraded(address indexed beacon);
462 
463     /**
464      * @dev Returns the current beacon.
465      */
466     function _getBeacon() internal view returns (address) {
467         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
468     }
469 
470     /**
471      * @dev Stores a new beacon in the EIP1967 beacon slot.
472      */
473     function _setBeacon(address newBeacon) private {
474         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
475         require(
476             Address.isContract(IBeacon(newBeacon).implementation()),
477             "ERC1967: beacon implementation is not a contract"
478         );
479         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
480     }
481 
482     /**
483      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
484      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
485      *
486      * Emits a {BeaconUpgraded} event.
487      */
488     function _upgradeBeaconToAndCall(
489         address newBeacon,
490         bytes memory data,
491         bool forceCall
492     ) internal {
493         _setBeacon(newBeacon);
494         emit BeaconUpgraded(newBeacon);
495         if (data.length > 0 || forceCall) {
496             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
497         }
498     }
499 }
500 
501 pragma solidity ^0.8.0;
502 
503 /**
504  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
505  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
506  * be specified by overriding the virtual {_implementation} function.
507  *
508  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
509  * different contract through the {_delegate} function.
510  *
511  * The success and return data of the delegated call will be returned back to the caller of the proxy.
512  */
513 abstract contract Proxy {
514     /**
515      * @dev Delegates the current call to `implementation`.
516      *
517      * This function does not return to its internall call site, it will return directly to the external caller.
518      */
519     function _delegate(address implementation) internal virtual {
520         assembly {
521             // Copy msg.data. We take full control of memory in this inline assembly
522             // block because it will not return to Solidity code. We overwrite the
523             // Solidity scratch pad at memory position 0.
524             calldatacopy(0, 0, calldatasize())
525 
526             // Call the implementation.
527             // out and outsize are 0 because we don't know the size yet.
528             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
529 
530             // Copy the returned data.
531             returndatacopy(0, 0, returndatasize())
532 
533             switch result
534             // delegatecall returns 0 on error.
535             case 0 {
536                 revert(0, returndatasize())
537             }
538             default {
539                 return(0, returndatasize())
540             }
541         }
542     }
543 
544     /**
545      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
546      * and {_fallback} should delegate.
547      */
548     function _implementation() internal view virtual returns (address);
549 
550     /**
551      * @dev Delegates the current call to the address returned by `_implementation()`.
552      *
553      * This function does not return to its internall call site, it will return directly to the external caller.
554      */
555     function _fallback() internal virtual {
556         _beforeFallback();
557         _delegate(_implementation());
558     }
559 
560     /**
561      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
562      * function in the contract matches the call data.
563      */
564     fallback() external payable virtual {
565         _fallback();
566     }
567 
568     /**
569      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
570      * is empty.
571      */
572     receive() external payable virtual {
573         _fallback();
574     }
575 
576     /**
577      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
578      * call, or as part of the Solidity `fallback` or `receive` functions.
579      *
580      * If overriden should call `super._beforeFallback()`.
581      */
582     function _beforeFallback() internal virtual {}
583 }
584 
585 pragma solidity ^0.8.0;
586 
587 /**
588  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
589  * implementation address that can be changed. This address is stored in storage in the location specified by
590  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
591  * implementation behind the proxy.
592  */
593 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
594     /**
595      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
596      *
597      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
598      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
599      */
600     constructor(address _logic, bytes memory _data) payable {
601         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
602         _upgradeToAndCall(_logic, _data, false);
603     }
604 
605     /**
606      * @dev Returns the current implementation address.
607      */
608     function _implementation() internal view virtual override returns (address impl) {
609         return ERC1967Upgrade._getImplementation();
610     }
611 }
612 
613 pragma solidity ^0.8.0;
614 
615 /**
616  * @dev This contract implements a proxy that is upgradeable by an admin.
617  *
618  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
619  * clashing], which can potentially be used in an attack, this contract uses the
620  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
621  * things that go hand in hand:
622  *
623  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
624  * that call matches one of the admin functions exposed by the proxy itself.
625  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
626  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
627  * "admin cannot fallback to proxy target".
628  *
629  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
630  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
631  * to sudden errors when trying to call a function from the proxy implementation.
632  *
633  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
634  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
635  */
636 contract TransparentUpgradeableProxy is ERC1967Proxy {
637     /**
638      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
639      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
640      */
641     constructor(
642         address _logic,
643         address admin_,
644         bytes memory _data
645     ) payable ERC1967Proxy(_logic, _data) {
646         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
647         _changeAdmin(admin_);
648     }
649 
650     /**
651      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
652      */
653     modifier ifAdmin() {
654         if (msg.sender == _getAdmin()) {
655             _;
656         } else {
657             _fallback();
658         }
659     }
660 
661     /**
662      * @dev Returns the current admin.
663      *
664      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
665      *
666      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
667      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
668      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
669      */
670     function admin() external ifAdmin returns (address admin_) {
671         admin_ = _getAdmin();
672     }
673 
674     /**
675      * @dev Returns the current implementation.
676      *
677      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
678      *
679      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
680      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
681      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
682      */
683     function implementation() external ifAdmin returns (address implementation_) {
684         implementation_ = _implementation();
685     }
686 
687     /**
688      * @dev Changes the admin of the proxy.
689      *
690      * Emits an {AdminChanged} event.
691      *
692      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
693      */
694     function changeAdmin(address newAdmin) external virtual ifAdmin {
695         _changeAdmin(newAdmin);
696     }
697 
698     /**
699      * @dev Upgrade the implementation of the proxy.
700      *
701      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
702      */
703     function upgradeTo(address newImplementation) external ifAdmin {
704         _upgradeToAndCall(newImplementation, bytes(""), false);
705     }
706 
707     /**
708      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
709      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
710      * proxied contract.
711      *
712      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
713      */
714     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
715         _upgradeToAndCall(newImplementation, data, true);
716     }
717 
718     /**
719      * @dev Returns the current admin.
720      */
721     function _admin() internal view virtual returns (address) {
722         return _getAdmin();
723     }
724 
725     /**
726      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
727      */
728     function _beforeFallback() internal virtual override {
729         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
730         super._beforeFallback();
731     }
732 }