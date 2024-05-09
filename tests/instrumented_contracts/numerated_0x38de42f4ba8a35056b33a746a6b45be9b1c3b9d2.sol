1 // File: Address.sol
2 
3 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      *
26      * [IMPORTANT]
27      * ====
28      * You shouldn't rely on `isContract` to protect against flash loan attacks!
29      *
30      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
31      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
32      * constructor.
33      * ====
34      */
35     function isContract(address account) internal view returns (bool) {
36         // This method relies on extcodesize/address.code.length, which returns 0
37         // for contracts in construction, since the code is only stored at the end
38         // of the constructor execution.
39 
40         return account.code.length > 0;
41     }
42 
43     /**
44      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
45      * `recipient`, forwarding all available gas and reverting on errors.
46      *
47      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
48      * of certain opcodes, possibly making contracts go over the 2300 gas limit
49      * imposed by `transfer`, making them unable to receive funds via
50      * `transfer`. {sendValue} removes this limitation.
51      *
52      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
53      *
54      * IMPORTANT: because control is transferred to `recipient`, care must be
55      * taken to not create reentrancy vulnerabilities. Consider using
56      * {ReentrancyGuard} or the
57      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
58      */
59     function sendValue(address payable recipient, uint256 amount) internal {
60         require(address(this).balance >= amount, "Address: insufficient balance");
61 
62         (bool success, ) = recipient.call{value: amount}("");
63         require(success, "Address: unable to send value, recipient may have reverted");
64     }
65 
66     /**
67      * @dev Performs a Solidity function call using a low level `call`. A
68      * plain `call` is an unsafe replacement for a function call: use this
69      * function instead.
70      *
71      * If `target` reverts with a revert reason, it is bubbled up by this
72      * function (like regular Solidity function calls).
73      *
74      * Returns the raw returned data. To convert to the expected return value,
75      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
76      *
77      * Requirements:
78      *
79      * - `target` must be a contract.
80      * - calling `target` with `data` must not revert.
81      *
82      * _Available since v3.1._
83      */
84     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
85         return functionCall(target, data, "Address: low-level call failed");
86     }
87 
88     /**
89      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
90      * `errorMessage` as a fallback revert reason when `target` reverts.
91      *
92      * _Available since v3.1._
93      */
94     function functionCall(
95         address target,
96         bytes memory data,
97         string memory errorMessage
98     ) internal returns (bytes memory) {
99         return functionCallWithValue(target, data, 0, errorMessage);
100     }
101 
102     /**
103      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
104      * but also transferring `value` wei to `target`.
105      *
106      * Requirements:
107      *
108      * - the calling contract must have an ETH balance of at least `value`.
109      * - the called Solidity function must be `payable`.
110      *
111      * _Available since v3.1._
112      */
113     function functionCallWithValue(
114         address target,
115         bytes memory data,
116         uint256 value
117     ) internal returns (bytes memory) {
118         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
119     }
120 
121     /**
122      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
123      * with `errorMessage` as a fallback revert reason when `target` reverts.
124      *
125      * _Available since v3.1._
126      */
127     function functionCallWithValue(
128         address target,
129         bytes memory data,
130         uint256 value,
131         string memory errorMessage
132     ) internal returns (bytes memory) {
133         require(address(this).balance >= value, "Address: insufficient balance for call");
134         require(isContract(target), "Address: call to non-contract");
135 
136         (bool success, bytes memory returndata) = target.call{value: value}(data);
137         return verifyCallResult(success, returndata, errorMessage);
138     }
139 
140     /**
141      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
142      * but performing a static call.
143      *
144      * _Available since v3.3._
145      */
146     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
147         return functionStaticCall(target, data, "Address: low-level static call failed");
148     }
149 
150     /**
151      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
152      * but performing a static call.
153      *
154      * _Available since v3.3._
155      */
156     function functionStaticCall(
157         address target,
158         bytes memory data,
159         string memory errorMessage
160     ) internal view returns (bytes memory) {
161         require(isContract(target), "Address: static call to non-contract");
162 
163         (bool success, bytes memory returndata) = target.staticcall(data);
164         return verifyCallResult(success, returndata, errorMessage);
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
169      * but performing a delegate call.
170      *
171      * _Available since v3.4._
172      */
173     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
179      * but performing a delegate call.
180      *
181      * _Available since v3.4._
182      */
183     function functionDelegateCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         require(isContract(target), "Address: delegate call to non-contract");
189 
190         (bool success, bytes memory returndata) = target.delegatecall(data);
191         return verifyCallResult(success, returndata, errorMessage);
192     }
193 
194     /**
195      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
196      * revert reason using the provided one.
197      *
198      * _Available since v4.3._
199      */
200     function verifyCallResult(
201         bool success,
202         bytes memory returndata,
203         string memory errorMessage
204     ) internal pure returns (bytes memory) {
205         if (success) {
206             return returndata;
207         } else {
208             // Look for revert reason and bubble it up if present
209             if (returndata.length > 0) {
210                 // The easiest way to bubble the revert reason is using memory via assembly
211 
212                 assembly {
213                     let returndata_size := mload(returndata)
214                     revert(add(32, returndata), returndata_size)
215                 }
216             } else {
217                 revert(errorMessage);
218             }
219         }
220     }
221 }
222 
223 // File: IBeacon.sol
224 
225 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
226 
227 /**
228  * @dev This is the interface that {BeaconProxy} expects of its beacon.
229  */
230 interface IBeacon {
231     /**
232      * @dev Must return an address that can be used as a delegate call target.
233      *
234      * {BeaconProxy} will check that this address is a contract.
235      */
236     function implementation() external view returns (address);
237 }
238 
239 // File: Proxy.sol
240 
241 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/Proxy.sol)
242 
243 /**
244  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
245  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
246  * be specified by overriding the virtual {_implementation} function.
247  *
248  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
249  * different contract through the {_delegate} function.
250  *
251  * The success and return data of the delegated call will be returned back to the caller of the proxy.
252  */
253 abstract contract Proxy {
254     /**
255      * @dev Delegates the current call to `implementation`.
256      *
257      * This function does not return to its internal call site, it will return directly to the external caller.
258      */
259     function _delegate(address implementation) internal virtual {
260         assembly {
261             // Copy msg.data. We take full control of memory in this inline assembly
262             // block because it will not return to Solidity code. We overwrite the
263             // Solidity scratch pad at memory position 0.
264             calldatacopy(0, 0, calldatasize())
265 
266             // Call the implementation.
267             // out and outsize are 0 because we don't know the size yet.
268             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
269 
270             // Copy the returned data.
271             returndatacopy(0, 0, returndatasize())
272 
273             switch result
274             // delegatecall returns 0 on error.
275             case 0 {
276                 revert(0, returndatasize())
277             }
278             default {
279                 return(0, returndatasize())
280             }
281         }
282     }
283 
284     /**
285      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
286      * and {_fallback} should delegate.
287      */
288     function _implementation() internal view virtual returns (address);
289 
290     /**
291      * @dev Delegates the current call to the address returned by `_implementation()`.
292      *
293      * This function does not return to its internall call site, it will return directly to the external caller.
294      */
295     function _fallback() internal virtual {
296         _beforeFallback();
297         _delegate(_implementation());
298     }
299 
300     /**
301      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
302      * function in the contract matches the call data.
303      */
304     fallback() external payable virtual {
305         _fallback();
306     }
307 
308     /**
309      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
310      * is empty.
311      */
312     receive() external payable virtual {
313         _fallback();
314     }
315 
316     /**
317      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
318      * call, or as part of the Solidity `fallback` or `receive` functions.
319      *
320      * If overriden should call `super._beforeFallback()`.
321      */
322     function _beforeFallback() internal virtual {}
323 }
324 
325 // File: StorageSlot.sol
326 
327 // OpenZeppelin Contracts v4.4.1 (utils/StorageSlot.sol)
328 
329 /**
330  * @dev Library for reading and writing primitive types to specific storage slots.
331  *
332  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
333  * This library helps with reading and writing to such slots without the need for inline assembly.
334  *
335  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
336  *
337  * Example usage to set ERC1967 implementation slot:
338  * ```
339  * contract ERC1967 {
340  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
341  *
342  *     function _getImplementation() internal view returns (address) {
343  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
344  *     }
345  *
346  *     function _setImplementation(address newImplementation) internal {
347  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
348  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
349  *     }
350  * }
351  * ```
352  *
353  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
354  */
355 library StorageSlot {
356     struct AddressSlot {
357         address value;
358     }
359 
360     struct BooleanSlot {
361         bool value;
362     }
363 
364     struct Bytes32Slot {
365         bytes32 value;
366     }
367 
368     struct Uint256Slot {
369         uint256 value;
370     }
371 
372     /**
373      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
374      */
375     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
376         assembly {
377             r.slot := slot
378         }
379     }
380 
381     /**
382      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
383      */
384     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
385         assembly {
386             r.slot := slot
387         }
388     }
389 
390     /**
391      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
392      */
393     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
394         assembly {
395             r.slot := slot
396         }
397     }
398 
399     /**
400      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
401      */
402     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
403         assembly {
404             r.slot := slot
405         }
406     }
407 }
408 
409 // File: draft-IERC1822.sol
410 
411 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
412 
413 /**
414  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
415  * proxy whose upgrades are fully controlled by the current implementation.
416  */
417 interface IERC1822Proxiable {
418     /**
419      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
420      * address.
421      *
422      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
423      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
424      * function revert if invoked through a proxy.
425      */
426     function proxiableUUID() external view returns (bytes32);
427 }
428 
429 // File: ERC1967Upgrade.sol
430 
431 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
432 
433 /**
434  * @dev This abstract contract provides getters and event emitting update functions for
435  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
436  *
437  * _Available since v4.1._
438  *
439  * @custom:oz-upgrades-unsafe-allow delegatecall
440  */
441 abstract contract ERC1967Upgrade {
442     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
443     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
444 
445     /**
446      * @dev Storage slot with the address of the current implementation.
447      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
448      * validated in the constructor.
449      */
450     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
451 
452     /**
453      * @dev Emitted when the implementation is upgraded.
454      */
455     event Upgraded(address indexed implementation);
456 
457     /**
458      * @dev Returns the current implementation address.
459      */
460     function _getImplementation() internal view returns (address) {
461         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
462     }
463 
464     /**
465      * @dev Stores a new address in the EIP1967 implementation slot.
466      */
467     function _setImplementation(address newImplementation) private {
468         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
469         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
470     }
471 
472     /**
473      * @dev Perform implementation upgrade
474      *
475      * Emits an {Upgraded} event.
476      */
477     function _upgradeTo(address newImplementation) internal {
478         _setImplementation(newImplementation);
479         emit Upgraded(newImplementation);
480     }
481 
482     /**
483      * @dev Perform implementation upgrade with additional setup call.
484      *
485      * Emits an {Upgraded} event.
486      */
487     function _upgradeToAndCall(
488         address newImplementation,
489         bytes memory data,
490         bool forceCall
491     ) internal {
492         _upgradeTo(newImplementation);
493         if (data.length > 0 || forceCall) {
494             Address.functionDelegateCall(newImplementation, data);
495         }
496     }
497 
498     /**
499      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
500      *
501      * Emits an {Upgraded} event.
502      */
503     function _upgradeToAndCallUUPS(
504         address newImplementation,
505         bytes memory data,
506         bool forceCall
507     ) internal {
508         // Upgrades from old implementations will perform a rollback test. This test requires the new
509         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
510         // this special case will break upgrade paths from old UUPS implementation to new ones.
511         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
512             _setImplementation(newImplementation);
513         } else {
514             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
515                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
516             } catch {
517                 revert("ERC1967Upgrade: new implementation is not UUPS");
518             }
519             _upgradeToAndCall(newImplementation, data, forceCall);
520         }
521     }
522 
523     /**
524      * @dev Storage slot with the admin of the contract.
525      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
526      * validated in the constructor.
527      */
528     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
529 
530     /**
531      * @dev Emitted when the admin account has changed.
532      */
533     event AdminChanged(address previousAdmin, address newAdmin);
534 
535     /**
536      * @dev Returns the current admin.
537      */
538     function _getAdmin() internal view returns (address) {
539         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
540     }
541 
542     /**
543      * @dev Stores a new address in the EIP1967 admin slot.
544      */
545     function _setAdmin(address newAdmin) private {
546         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
547         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
548     }
549 
550     /**
551      * @dev Changes the admin of the proxy.
552      *
553      * Emits an {AdminChanged} event.
554      */
555     function _changeAdmin(address newAdmin) internal {
556         emit AdminChanged(_getAdmin(), newAdmin);
557         _setAdmin(newAdmin);
558     }
559 
560     /**
561      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
562      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
563      */
564     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
565 
566     /**
567      * @dev Emitted when the beacon is upgraded.
568      */
569     event BeaconUpgraded(address indexed beacon);
570 
571     /**
572      * @dev Returns the current beacon.
573      */
574     function _getBeacon() internal view returns (address) {
575         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
576     }
577 
578     /**
579      * @dev Stores a new beacon in the EIP1967 beacon slot.
580      */
581     function _setBeacon(address newBeacon) private {
582         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
583         require(
584             Address.isContract(IBeacon(newBeacon).implementation()),
585             "ERC1967: beacon implementation is not a contract"
586         );
587         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
588     }
589 
590     /**
591      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
592      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
593      *
594      * Emits a {BeaconUpgraded} event.
595      */
596     function _upgradeBeaconToAndCall(
597         address newBeacon,
598         bytes memory data,
599         bool forceCall
600     ) internal {
601         _setBeacon(newBeacon);
602         emit BeaconUpgraded(newBeacon);
603         if (data.length > 0 || forceCall) {
604             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
605         }
606     }
607 }
608 
609 // File: ERC1967Proxy.sol
610 
611 // OpenZeppelin Contracts v4.4.1 (proxy/ERC1967/ERC1967Proxy.sol)
612 
613 /**
614  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
615  * implementation address that can be changed. This address is stored in storage in the location specified by
616  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
617  * implementation behind the proxy.
618  */
619 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
620     /**
621      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
622      *
623      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
624      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
625      */
626     constructor(address _logic, bytes memory _data) payable {
627         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
628         _upgradeToAndCall(_logic, _data, false);
629     }
630 
631     /**
632      * @dev Returns the current implementation address.
633      */
634     function _implementation() internal view virtual override returns (address impl) {
635         return ERC1967Upgrade._getImplementation();
636     }
637 }
638 
639 // File: nProxy.sol
640 
641 contract nProxy is ERC1967Proxy {
642     constructor(
643         address _logic,
644         bytes memory _data
645     ) ERC1967Proxy(_logic, _data) {}
646 
647     receive() external payable override {
648         // Allow ETH transfers to succeed
649     }
650 
651     function getImplementation() external view returns (address) {
652         return _getImplementation();
653     }
654 }