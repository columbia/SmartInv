1 /**
2  *Submitted for verification at Arbiscan on 2022-06-19
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Library for reading and writing primitive types to specific storage slots.
11  *
12  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
13  * This library helps with reading and writing to such slots without the need for inline assembly.
14  *
15  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
16  *
17  * Example usage to set ERC1967 implementation slot:
18  * ```
19  * contract ERC1967 {
20  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
21  *
22  *     function _getImplementation() internal view returns (address) {
23  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
24  *     }
25  *
26  *     function _setImplementation(address newImplementation) internal {
27  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
28  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
29  *     }
30  * }
31  * ```
32  *
33  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
34  */
35 library StorageSlot {
36     struct AddressSlot {
37         address value;
38     }
39 
40     struct BooleanSlot {
41         bool value;
42     }
43 
44     struct Bytes32Slot {
45         bytes32 value;
46     }
47 
48     struct Uint256Slot {
49         uint256 value;
50     }
51 
52     /**
53      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
54      */
55     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
56         assembly {
57             r.slot := slot
58         }
59     }
60 
61     /**
62      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
63      */
64     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
65         assembly {
66             r.slot := slot
67         }
68     }
69 
70     /**
71      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
72      */
73     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
74         assembly {
75             r.slot := slot
76         }
77     }
78 
79     /**
80      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
81      */
82     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
83         assembly {
84             r.slot := slot
85         }
86     }
87 }
88 
89 /**
90  * @dev Collection of functions related to the address type
91  */
92 library Address {
93     /**
94      * @dev Returns true if `account` is a contract.
95      *
96      * [IMPORTANT]
97      * ====
98      * It is unsafe to assume that an address for which this function returns
99      * false is an externally-owned account (EOA) and not a contract.
100      *
101      * Among others, `isContract` will return false for the following
102      * types of addresses:
103      *
104      *  - an externally-owned account
105      *  - a contract in construction
106      *  - an address where a contract will be created
107      *  - an address where a contract lived, but was destroyed
108      * ====
109      */
110     function isContract(address account) internal view returns (bool) {
111         // This method relies on extcodesize, which returns 0 for contracts in
112         // construction, since the code is only stored at the end of the
113         // constructor execution.
114 
115         uint256 size;
116         // solhint-disable-next-line no-inline-assembly
117         assembly { size := extcodesize(account) }
118         return size > 0;
119     }
120 
121     /**
122      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
123      * `recipient`, forwarding all available gas and reverting on errors.
124      *
125      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
126      * of certain opcodes, possibly making contracts go over the 2300 gas limit
127      * imposed by `transfer`, making them unable to receive funds via
128      * `transfer`. {sendValue} removes this limitation.
129      *
130      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
131      *
132      * IMPORTANT: because control is transferred to `recipient`, care must be
133      * taken to not create reentrancy vulnerabilities. Consider using
134      * {ReentrancyGuard} or the
135      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
136      */
137     function sendValue(address payable recipient, uint256 amount) internal {
138         require(address(this).balance >= amount, "Address: insufficient balance");
139 
140         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
141         (bool success, ) = recipient.call{ value: amount }("");
142         require(success, "Address: unable to send value, recipient may have reverted");
143     }
144 
145     /**
146      * @dev Performs a Solidity function call using a low level `call`. A
147      * plain`call` is an unsafe replacement for a function call: use this
148      * function instead.
149      *
150      * If `target` reverts with a revert reason, it is bubbled up by this
151      * function (like regular Solidity function calls).
152      *
153      * Returns the raw returned data. To convert to the expected return value,
154      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
155      *
156      * Requirements:
157      *
158      * - `target` must be a contract.
159      * - calling `target` with `data` must not revert.
160      *
161      * _Available since v3.1._
162      */
163     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
164       return functionCall(target, data, "Address: low-level call failed");
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
169      * `errorMessage` as a fallback revert reason when `target` reverts.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
174         return functionCallWithValue(target, data, 0, errorMessage);
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
179      * but also transferring `value` wei to `target`.
180      *
181      * Requirements:
182      *
183      * - the calling contract must have an ETH balance of at least `value`.
184      * - the called Solidity function must be `payable`.
185      *
186      * _Available since v3.1._
187      */
188     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
194      * with `errorMessage` as a fallback revert reason when `target` reverts.
195      *
196      * _Available since v3.1._
197      */
198     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
199         require(address(this).balance >= value, "Address: insufficient balance for call");
200         require(isContract(target), "Address: call to non-contract");
201 
202         // solhint-disable-next-line avoid-low-level-calls
203         (bool success, bytes memory returndata) = target.call{ value: value }(data);
204         return _verifyCallResult(success, returndata, errorMessage);
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
209      * but performing a static call.
210      *
211      * _Available since v3.3._
212      */
213     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
214         return functionStaticCall(target, data, "Address: low-level static call failed");
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
219      * but performing a static call.
220      *
221      * _Available since v3.3._
222      */
223     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
224         require(isContract(target), "Address: static call to non-contract");
225 
226         // solhint-disable-next-line avoid-low-level-calls
227         (bool success, bytes memory returndata) = target.staticcall(data);
228         return _verifyCallResult(success, returndata, errorMessage);
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
233      * but performing a delegate call.
234      *
235      * _Available since v3.4._
236      */
237     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
238         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
243      * but performing a delegate call.
244      *
245      * _Available since v3.4._
246      */
247     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
248         require(isContract(target), "Address: delegate call to non-contract");
249 
250         // solhint-disable-next-line avoid-low-level-calls
251         (bool success, bytes memory returndata) = target.delegatecall(data);
252         return _verifyCallResult(success, returndata, errorMessage);
253     }
254 
255     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
256         if (success) {
257             return returndata;
258         } else {
259             // Look for revert reason and bubble it up if present
260             if (returndata.length > 0) {
261                 // The easiest way to bubble the revert reason is using memory via assembly
262 
263                 // solhint-disable-next-line no-inline-assembly
264                 assembly {
265                     let returndata_size := mload(returndata)
266                     revert(add(32, returndata), returndata_size)
267                 }
268             } else {
269                 revert(errorMessage);
270             }
271         }
272     }
273 }
274 
275 /**
276  * @dev This is the interface that {BeaconProxy} expects of its beacon.
277  */
278 interface IBeacon {
279     /**
280      * @dev Must return an address that can be used as a delegate call target.
281      *
282      * {BeaconProxy} will check that this address is a contract.
283      */
284     function implementation() external view returns (address);
285 }
286 
287 /**
288  * @dev This abstract contract provides getters and event emitting update functions for
289  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
290  *
291  * _Available since v4.1._
292  *
293  * @custom:oz-upgrades-unsafe-allow delegatecall
294  */
295 abstract contract ERC1967Upgrade {
296     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
297     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
298 
299     /**
300      * @dev Storage slot with the address of the current implementation.
301      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
302      * validated in the constructor.
303      */
304     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
305 
306     /**
307      * @dev Emitted when the implementation is upgraded.
308      */
309     event Upgraded(address indexed implementation);
310 
311     /**
312      * @dev Returns the current implementation address.
313      */
314     function _getImplementation() internal view returns (address) {
315         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
316     }
317 
318     /**
319      * @dev Stores a new address in the EIP1967 implementation slot.
320      */
321     function _setImplementation(address newImplementation) private {
322         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
323         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
324     }
325 
326     /**
327      * @dev Perform implementation upgrade
328      *
329      * Emits an {Upgraded} event.
330      */
331     function _upgradeTo(address newImplementation) internal {
332         _setImplementation(newImplementation);
333         emit Upgraded(newImplementation);
334     }
335 
336     /**
337      * @dev Perform implementation upgrade with additional setup call.
338      *
339      * Emits an {Upgraded} event.
340      */
341     function _upgradeToAndCall(address newImplementation, bytes memory data, bool forceCall) internal {
342         _setImplementation(newImplementation);
343         emit Upgraded(newImplementation);
344         if (data.length > 0 || forceCall) {
345             Address.functionDelegateCall(newImplementation, data);
346         }
347     }
348 
349     /**
350      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
351      *
352      * Emits an {Upgraded} event.
353      */
354     function _upgradeToAndCallSecure(address newImplementation, bytes memory data, bool forceCall) internal {
355         address oldImplementation = _getImplementation();
356 
357         // Initial upgrade and setup call
358         _setImplementation(newImplementation);
359         if (data.length > 0 || forceCall) {
360             Address.functionDelegateCall(newImplementation, data);
361         }
362 
363         // Perform rollback test if not already in progress
364         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
365         if (!rollbackTesting.value) {
366             // Trigger rollback using upgradeTo from the new implementation
367             rollbackTesting.value = true;
368             Address.functionDelegateCall(
369                 newImplementation,
370                 abi.encodeWithSignature(
371                     "upgradeTo(address)",
372                     oldImplementation
373                 )
374             );
375             rollbackTesting.value = false;
376             // Check rollback was effective
377             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
378             // Finally reset to the new implementation and log the upgrade
379             _setImplementation(newImplementation);
380             emit Upgraded(newImplementation);
381         }
382     }
383 
384     /**
385      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
386      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
387      *
388      * Emits a {BeaconUpgraded} event.
389      */
390     function _upgradeBeaconToAndCall(address newBeacon, bytes memory data, bool forceCall) internal {
391         _setBeacon(newBeacon);
392         emit BeaconUpgraded(newBeacon);
393         if (data.length > 0 || forceCall) {
394             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
395         }
396     }
397 
398     /**
399      * @dev Storage slot with the admin of the contract.
400      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
401      * validated in the constructor.
402      */
403     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
404 
405     /**
406      * @dev Emitted when the admin account has changed.
407      */
408     event AdminChanged(address previousAdmin, address newAdmin);
409 
410     /**
411      * @dev Returns the current admin.
412      */
413     function _getAdmin() internal view returns (address) {
414         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
415     }
416 
417     /**
418      * @dev Stores a new address in the EIP1967 admin slot.
419      */
420     function _setAdmin(address newAdmin) private {
421         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
422         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
423     }
424 
425     /**
426      * @dev Changes the admin of the proxy.
427      *
428      * Emits an {AdminChanged} event.
429      */
430     function _changeAdmin(address newAdmin) internal {
431         emit AdminChanged(_getAdmin(), newAdmin);
432         _setAdmin(newAdmin);
433     }
434 
435     /**
436      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
437      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
438      */
439     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
440 
441     /**
442      * @dev Emitted when the beacon is upgraded.
443      */
444     event BeaconUpgraded(address indexed beacon);
445 
446     /**
447      * @dev Returns the current beacon.
448      */
449     function _getBeacon() internal view returns (address) {
450         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
451     }
452 
453     /**
454      * @dev Stores a new beacon in the EIP1967 beacon slot.
455      */
456     function _setBeacon(address newBeacon) private {
457         require(
458             Address.isContract(newBeacon),
459             "ERC1967: new beacon is not a contract"
460         );
461         require(
462             Address.isContract(IBeacon(newBeacon).implementation()),
463             "ERC1967: beacon implementation is not a contract"
464         );
465         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
466     }
467 }
468 
469 /**
470  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
471  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
472  * be specified by overriding the virtual {_implementation} function.
473  *
474  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
475  * different contract through the {_delegate} function.
476  *
477  * The success and return data of the delegated call will be returned back to the caller of the proxy.
478  */
479 abstract contract Proxy {
480     /**
481      * @dev Delegates the current call to `implementation`.
482      *
483      * This function does not return to its internall call site, it will return directly to the external caller.
484      */
485     function _delegate(address implementation) internal virtual {
486         // solhint-disable-next-line no-inline-assembly
487         assembly {
488             // Copy msg.data. We take full control of memory in this inline assembly
489             // block because it will not return to Solidity code. We overwrite the
490             // Solidity scratch pad at memory position 0.
491             calldatacopy(0, 0, calldatasize())
492 
493             // Call the implementation.
494             // out and outsize are 0 because we don't know the size yet.
495             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
496 
497             // Copy the returned data.
498             returndatacopy(0, 0, returndatasize())
499 
500             switch result
501             // delegatecall returns 0 on error.
502             case 0 { revert(0, returndatasize()) }
503             default { return(0, returndatasize()) }
504         }
505     }
506 
507     /**
508      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
509      * and {_fallback} should delegate.
510      */
511     function _implementation() internal view virtual returns (address);
512 
513     /**
514      * @dev Delegates the current call to the address returned by `_implementation()`.
515      *
516      * This function does not return to its internall call site, it will return directly to the external caller.
517      */
518     function _fallback() internal virtual {
519         _beforeFallback();
520         _delegate(_implementation());
521     }
522 
523     /**
524      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
525      * function in the contract matches the call data.
526      */
527     fallback () external payable virtual {
528         _fallback();
529     }
530 
531     /**
532      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
533      * is empty.
534      */
535     receive () external payable virtual {
536         _fallback();
537     }
538 
539     /**
540      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
541      * call, or as part of the Solidity `fallback` or `receive` functions.
542      *
543      * If overriden should call `super._beforeFallback()`.
544      */
545     function _beforeFallback() internal virtual {
546     }
547 }
548 
549 /**
550  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
551  * implementation address that can be changed. This address is stored in storage in the location specified by
552  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
553  * implementation behind the proxy.
554  */
555 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
556     /**
557      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
558      *
559      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
560      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
561      */
562     constructor(address _logic, bytes memory _data) payable {
563         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
564         _upgradeToAndCall(_logic, _data, false);
565     }
566 
567     /**
568      * @dev Returns the current implementation address.
569      */
570     function _implementation() internal view virtual override returns (address impl) {
571         return ERC1967Upgrade._getImplementation();
572     }
573 }
574 
575 /**
576  * @dev This contract implements a proxy that is upgradeable by an admin.
577  *
578  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
579  * clashing], which can potentially be used in an attack, this contract uses the
580  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
581  * things that go hand in hand:
582  *
583  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
584  * that call matches one of the admin functions exposed by the proxy itself.
585  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
586  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
587  * "admin cannot fallback to proxy target".
588  *
589  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
590  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
591  * to sudden errors when trying to call a function from the proxy implementation.
592  *
593  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
594  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
595  */
596 contract TransparentUpgradeableProxy is ERC1967Proxy {
597     /**
598      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
599      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
600      */
601     constructor(address _logic, address admin_, bytes memory _data) payable ERC1967Proxy(_logic, _data) {
602         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
603         _changeAdmin(admin_);
604     }
605 
606     /**
607      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
608      */
609     modifier ifAdmin() {
610         if (msg.sender == _getAdmin()) {
611             _;
612         } else {
613             _fallback();
614         }
615     }
616 
617     /**
618      * @dev Returns the current admin.
619      *
620      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
621      *
622      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
623      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
624      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
625      */
626     function admin() external ifAdmin returns (address admin_) {
627         admin_ = _getAdmin();
628     }
629 
630     /**
631      * @dev Returns the current implementation.
632      *
633      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
634      *
635      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
636      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
637      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
638      */
639     function implementation() external ifAdmin returns (address implementation_) {
640         implementation_ = _implementation();
641     }
642 
643     /**
644      * @dev Changes the admin of the proxy.
645      *
646      * Emits an {AdminChanged} event.
647      *
648      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
649      */
650     function changeAdmin(address newAdmin) external virtual ifAdmin {
651         _changeAdmin(newAdmin);
652     }
653 
654     /**
655      * @dev Upgrade the implementation of the proxy.
656      *
657      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
658      */
659     function upgradeTo(address newImplementation) external ifAdmin {
660         _upgradeToAndCall(newImplementation, bytes(""), false);
661     }
662 
663     /**
664      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
665      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
666      * proxied contract.
667      *
668      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
669      */
670     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
671         _upgradeToAndCall(newImplementation, data, true);
672     }
673 
674     /**
675      * @dev Returns the current admin.
676      */
677     function _admin() internal view virtual returns (address) {
678         return _getAdmin();
679     }
680 
681     /**
682      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
683      */
684     function _beforeFallback() internal virtual override {
685         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
686         super._beforeFallback();
687     }
688 }