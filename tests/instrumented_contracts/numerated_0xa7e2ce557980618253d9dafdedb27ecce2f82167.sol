1 // Sources flattened with hardhat v2.9.3 https://hardhat.org
2 
3 // File contracts/proxy/Proxy.sol
4 
5 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
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
23      * This function does not return to its internal call site, it will return directly to the external caller.
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
51      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
52      * and {_fallback} should delegate.
53      */
54     function _implementation() internal view virtual returns (address);
55 
56     /**
57      * @dev Delegates the current call to the address returned by `_implementation()`.
58      *
59      * This function does not return to its internal call site, it will return directly to the external caller.
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
86      * If overridden should call `super._beforeFallback()`.
87      */
88     function _beforeFallback() internal virtual {}
89 }
90 
91 
92 // File contracts/utils/Address.sol
93 
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Collection of functions related to the address type
99  */
100 library Address {
101     /**
102      * @dev Returns true if `account` is a contract.
103      *
104      * [IMPORTANT]
105      * ====
106      * It is unsafe to assume that an address for which this function returns
107      * false is an externally-owned account (EOA) and not a contract.
108      *
109      * Among others, `isContract` will return false for the following
110      * types of addresses:
111      *
112      *  - an externally-owned account
113      *  - a contract in construction
114      *  - an address where a contract will be created
115      *  - an address where a contract lived, but was destroyed
116      * ====
117      */
118     function isContract(address account) internal view returns (bool) {
119         // This method relies on extcodesize, which returns 0 for contracts in
120         // construction, since the code is only stored at the end of the
121         // constructor execution.
122 
123         uint256 size;
124         assembly {
125             size := extcodesize(account)
126         }
127         return size > 0;
128     }
129 
130     /**
131      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
132      * `recipient`, forwarding all available gas and reverting on errors.
133      *
134      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
135      * of certain opcodes, possibly making contracts go over the 2300 gas limit
136      * imposed by `transfer`, making them unable to receive funds via
137      * `transfer`. {sendValue} removes this limitation.
138      *
139      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
140      *
141      * IMPORTANT: because control is transferred to `recipient`, care must be
142      * taken to not create reentrancy vulnerabilities. Consider using
143      * {ReentrancyGuard} or the
144      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
145      */
146     function sendValue(address payable recipient, uint256 amount) internal {
147         require(address(this).balance >= amount, "Address: insufficient balance");
148 
149         (bool success, ) = recipient.call{value: amount}("");
150         require(success, "Address: unable to send value, recipient may have reverted");
151     }
152 
153     /**
154      * @dev Performs a Solidity function call using a low level `call`. A
155      * plain `call` is an unsafe replacement for a function call: use this
156      * function instead.
157      *
158      * If `target` reverts with a revert reason, it is bubbled up by this
159      * function (like regular Solidity function calls).
160      *
161      * Returns the raw returned data. To convert to the expected return value,
162      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
163      *
164      * Requirements:
165      *
166      * - `target` must be a contract.
167      * - calling `target` with `data` must not revert.
168      *
169      * _Available since v3.1._
170      */
171     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
172         return functionCall(target, data, "Address: low-level call failed");
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
177      * `errorMessage` as a fallback revert reason when `target` reverts.
178      *
179      * _Available since v3.1._
180      */
181     function functionCall(
182         address target,
183         bytes memory data,
184         string memory errorMessage
185     ) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, 0, errorMessage);
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
191      * but also transferring `value` wei to `target`.
192      *
193      * Requirements:
194      *
195      * - the calling contract must have an ETH balance of at least `value`.
196      * - the called Solidity function must be `payable`.
197      *
198      * _Available since v3.1._
199      */
200     function functionCallWithValue(
201         address target,
202         bytes memory data,
203         uint256 value
204     ) internal returns (bytes memory) {
205         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
210      * with `errorMessage` as a fallback revert reason when `target` reverts.
211      *
212      * _Available since v3.1._
213      */
214     function functionCallWithValue(
215         address target,
216         bytes memory data,
217         uint256 value,
218         string memory errorMessage
219     ) internal returns (bytes memory) {
220         require(address(this).balance >= value, "Address: insufficient balance for call");
221         require(isContract(target), "Address: call to non-contract");
222 
223         (bool success, bytes memory returndata) = target.call{value: value}(data);
224         return verifyCallResult(success, returndata, errorMessage);
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
229      * but performing a static call.
230      *
231      * _Available since v3.3._
232      */
233     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
234         return functionStaticCall(target, data, "Address: low-level static call failed");
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
239      * but performing a static call.
240      *
241      * _Available since v3.3._
242      */
243     function functionStaticCall(
244         address target,
245         bytes memory data,
246         string memory errorMessage
247     ) internal view returns (bytes memory) {
248         require(isContract(target), "Address: static call to non-contract");
249 
250         (bool success, bytes memory returndata) = target.staticcall(data);
251         return verifyCallResult(success, returndata, errorMessage);
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
256      * but performing a delegate call.
257      *
258      * _Available since v3.4._
259      */
260     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
261         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
266      * but performing a delegate call.
267      *
268      * _Available since v3.4._
269      */
270     function functionDelegateCall(
271         address target,
272         bytes memory data,
273         string memory errorMessage
274     ) internal returns (bytes memory) {
275         require(isContract(target), "Address: delegate call to non-contract");
276 
277         (bool success, bytes memory returndata) = target.delegatecall(data);
278         return verifyCallResult(success, returndata, errorMessage);
279     }
280 
281     /**
282      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
283      * revert reason using the provided one.
284      *
285      * _Available since v4.3._
286      */
287     function verifyCallResult(
288         bool success,
289         bytes memory returndata,
290         string memory errorMessage
291     ) internal pure returns (bytes memory) {
292         if (success) {
293             return returndata;
294         } else {
295             // Look for revert reason and bubble it up if present
296             if (returndata.length > 0) {
297                 // The easiest way to bubble the revert reason is using memory via assembly
298 
299                 assembly {
300                     let returndata_size := mload(returndata)
301                     revert(add(32, returndata), returndata_size)
302                 }
303             } else {
304                 revert(errorMessage);
305             }
306         }
307     }
308 }
309 
310 
311 // File contracts/utils/StorageSlot.sol
312 
313 
314 pragma solidity ^0.8.0;
315 
316 /**
317  * @dev Library for reading and writing primitive types to specific storage slots.
318  *
319  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
320  * This library helps with reading and writing to such slots without the need for inline assembly.
321  *
322  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
323  *
324  * Example usage to set ERC1967 implementation slot:
325  * ```
326  * contract ERC1967 {
327  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
328  *
329  *     function _getImplementation() internal view returns (address) {
330  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
331  *     }
332  *
333  *     function _setImplementation(address newImplementation) internal {
334  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
335  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
336  *     }
337  * }
338  * ```
339  *
340  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
341  */
342 library StorageSlot {
343     struct AddressSlot {
344         address value;
345     }
346 
347     struct BooleanSlot {
348         bool value;
349     }
350 
351     struct Bytes32Slot {
352         bytes32 value;
353     }
354 
355     struct Uint256Slot {
356         uint256 value;
357     }
358 
359     /**
360      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
361      */
362     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
363         assembly {
364             r.slot := slot
365         }
366     }
367 
368     /**
369      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
370      */
371     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
372         assembly {
373             r.slot := slot
374         }
375     }
376 
377     /**
378      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
379      */
380     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
381         assembly {
382             r.slot := slot
383         }
384     }
385 
386     /**
387      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
388      */
389     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
390         assembly {
391             r.slot := slot
392         }
393     }
394 }
395 
396 
397 // File contracts/proxy/ERC1967/ERC1967Upgrade.sol
398 
399 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
400 
401 pragma solidity ^0.8.2;
402 
403 
404 /**
405  * @dev This abstract contract provides getters and event emitting update functions for
406  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
407  *
408  * _Available since v4.1._
409  *
410  * @custom:oz-upgrades-unsafe-allow delegatecall
411  */
412 abstract contract ERC1967Upgrade {
413     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
414     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
415 
416     /**
417      * @dev Storage slot with the address of the current implementation.
418      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
419      * validated in the constructor.
420      */
421     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
422 
423     /**
424      * @dev Emitted when the implementation is upgraded.
425      */
426     event Upgraded(address indexed implementation);
427 
428     /**
429      * @dev Returns the current implementation address.
430      */
431     function _getImplementation() internal view returns (address) {
432         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
433     }
434 
435     /**
436      * @dev Stores a new address in the EIP1967 implementation slot.
437      */
438     function _setImplementation(address newImplementation) private {
439         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
440         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
441     }
442 
443     /**
444      * @dev Perform implementation upgrade
445      *
446      * Emits an {Upgraded} event.
447      */
448     function _upgradeTo(address newImplementation) internal {
449         _setImplementation(newImplementation);
450         emit Upgraded(newImplementation);
451     }
452 
453     /**
454      * @dev Perform implementation upgrade with additional setup call.
455      *
456      * Emits an {Upgraded} event.
457      */
458     function _upgradeToAndCall(
459         address newImplementation,
460         bytes memory data,
461         bool forceCall
462     ) internal {
463         _upgradeTo(newImplementation);
464         if (data.length > 0 || forceCall) {
465             Address.functionDelegateCall(newImplementation, data);
466         }
467     }
468 
469     /**
470      * @dev Storage slot with the admin of the contract.
471      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
472      * validated in the constructor.
473      */
474     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
475 
476     /**
477      * @dev Emitted when the admin account has changed.
478      */
479     event AdminChanged(address previousAdmin, address newAdmin);
480 
481     /**
482      * @dev Returns the current admin.
483      */
484     function _getAdmin() internal view returns (address) {
485         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
486     }
487 
488     /**
489      * @dev Stores a new address in the EIP1967 admin slot.
490      */
491     function _setAdmin(address newAdmin) private {
492         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
493         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
494     }
495 
496     /**
497      * @dev Changes the admin of the proxy.
498      *
499      * Emits an {AdminChanged} event.
500      */
501     function _changeAdmin(address newAdmin) internal {
502         emit AdminChanged(_getAdmin(), newAdmin);
503         _setAdmin(newAdmin);
504     }
505 
506     /**
507      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
508      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
509      */
510     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
511 
512     /**
513      * @dev Emitted when the beacon is upgraded.
514      */
515     event BeaconUpgraded(address indexed beacon);
516 
517     /**
518      * @dev Returns the current beacon.
519      */
520     function _getBeacon() internal view returns (address) {
521         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
522     }
523 
524 }
525 
526 
527 // File contracts/proxy/ERC1967/ERC1967Proxy.sol
528 
529 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
536  * implementation address that can be changed. This address is stored in storage in the location specified by
537  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
538  * implementation behind the proxy.
539  */
540 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
541     /**
542      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
543      *
544      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
545      * function call, and allows initializing the storage of the proxy like a Solidity constructor.
546      */
547     constructor(address _logic, bytes memory _data) payable {
548         _upgradeToAndCall(_logic, _data, false);
549     }
550 
551     /**
552      * @dev Returns the current implementation address.
553      */
554     function _implementation() internal view virtual override returns (address impl) {
555         return ERC1967Upgrade._getImplementation();
556     }
557 }
558 
559 
560 // File contracts/proxy/TransparentUpgradeableProxy.sol
561 
562 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/transparent/TransparentUpgradeableProxy.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 /**
567  * @dev This contract implements a proxy that is upgradeable by an admin.
568  *
569  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
570  * clashing], which can potentially be used in an attack, this contract uses the
571  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
572  * things that go hand in hand:
573  *
574  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
575  * that call matches one of the admin functions exposed by the proxy itself.
576  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
577  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
578  * "admin cannot fallback to proxy target".
579  *
580  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
581  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
582  * to sudden errors when trying to call a function from the proxy implementation.
583  *
584  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
585  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
586  */
587 contract TransparentUpgradeableProxy is ERC1967Proxy {
588     /**
589      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
590      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
591      */
592     constructor(
593         address _logic,
594         address admin_,
595         bytes memory _data
596     ) payable ERC1967Proxy(_logic, _data) {
597         _changeAdmin(admin_);
598     }
599 
600     /**
601      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
602      */
603     modifier ifAdmin() {
604         if (msg.sender == _getAdmin()) {
605             _;
606         } else {
607             _fallback();
608         }
609     }
610 
611     /**
612      * @dev Returns the current admin.
613      *
614      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
615      *
616      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
617      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
618      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
619      */
620     function admin() external ifAdmin returns (address admin_) {
621         admin_ = _getAdmin();
622     }
623 
624     /**
625      * @dev Returns the current implementation.
626      *
627      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
628      *
629      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
630      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
631      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
632      */
633     function implementation() external ifAdmin returns (address implementation_) {
634         implementation_ = _implementation();
635     }
636 
637     /**
638      * @dev Changes the admin of the proxy.
639      *
640      * Emits an {AdminChanged} event.
641      *
642      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
643      */
644     function changeAdmin(address newAdmin) external virtual ifAdmin {
645         _changeAdmin(newAdmin);
646     }
647 
648     /**
649      * @dev Upgrade the implementation of the proxy.
650      *
651      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
652      */
653     function upgradeTo(address newImplementation) external ifAdmin {
654         _upgradeToAndCall(newImplementation, bytes(""), false);
655     }
656 
657     /**
658      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
659      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
660      * proxied contract.
661      *
662      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
663      */
664     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
665         _upgradeToAndCall(newImplementation, data, true);
666     }
667 
668     /**
669      * @dev Returns the current admin.
670      */
671     function _admin() internal view virtual returns (address) {
672         return _getAdmin();
673     }
674 
675     /**
676      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
677      */
678     function _beforeFallback() internal virtual override {
679         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
680         super._beforeFallback();
681     }
682 }