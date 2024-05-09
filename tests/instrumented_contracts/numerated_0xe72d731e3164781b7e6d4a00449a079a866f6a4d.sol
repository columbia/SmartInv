1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.10;
3 
4 
5 /**
6 
7  ________   _____   ____    ______      ____
8 /\_____  \ /\  __`\/\  _`\ /\  _  \    /\  _`\
9 \/____//'/'\ \ \/\ \ \ \L\ \ \ \L\ \   \ \ \/\ \  _ __   ___   _____     ____
10      //'/'  \ \ \ \ \ \ ,  /\ \  __ \   \ \ \ \ \/\`'__\/ __`\/\ '__`\  /',__\
11     //'/'___ \ \ \_\ \ \ \\ \\ \ \/\ \   \ \ \_\ \ \ \//\ \L\ \ \ \L\ \/\__, `\
12     /\_______\\ \_____\ \_\ \_\ \_\ \_\   \ \____/\ \_\\ \____/\ \ ,__/\/\____/
13     \/_______/ \/_____/\/_/\/ /\/_/\/_/    \/___/  \/_/ \/___/  \ \ \/  \/___/
14                                                                  \ \_\
15                                                                   \/_/
16 
17 Drop Powered by ZORA
18 
19  */
20 
21 
22 
23 // OpenZeppelin Contracts v4.4.1 (proxy/ERC1967/ERC1967Proxy.sol)
24 
25 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/Proxy.sol)
26 
27 /**
28  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
29  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
30  * be specified by overriding the virtual {_implementation} function.
31  *
32  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
33  * different contract through the {_delegate} function.
34  *
35  * The success and return data of the delegated call will be returned back to the caller of the proxy.
36  */
37 abstract contract Proxy {
38     /**
39      * @dev Delegates the current call to `implementation`.
40      *
41      * This function does not return to its internal call site, it will return directly to the external caller.
42      */
43     function _delegate(address implementation) internal virtual {
44         assembly {
45             // Copy msg.data. We take full control of memory in this inline assembly
46             // block because it will not return to Solidity code. We overwrite the
47             // Solidity scratch pad at memory position 0.
48             calldatacopy(0, 0, calldatasize())
49 
50             // Call the implementation.
51             // out and outsize are 0 because we don't know the size yet.
52             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
53 
54             // Copy the returned data.
55             returndatacopy(0, 0, returndatasize())
56 
57             switch result
58             // delegatecall returns 0 on error.
59             case 0 {
60                 revert(0, returndatasize())
61             }
62             default {
63                 return(0, returndatasize())
64             }
65         }
66     }
67 
68     /**
69      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
70      * and {_fallback} should delegate.
71      */
72     function _implementation() internal view virtual returns (address);
73 
74     /**
75      * @dev Delegates the current call to the address returned by `_implementation()`.
76      *
77      * This function does not return to its internal call site, it will return directly to the external caller.
78      */
79     function _fallback() internal virtual {
80         _beforeFallback();
81         _delegate(_implementation());
82     }
83 
84     /**
85      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
86      * function in the contract matches the call data.
87      */
88     fallback() external payable virtual {
89         _fallback();
90     }
91 
92     /**
93      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
94      * is empty.
95      */
96     receive() external payable virtual {
97         _fallback();
98     }
99 
100     /**
101      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
102      * call, or as part of the Solidity `fallback` or `receive` functions.
103      *
104      * If overriden should call `super._beforeFallback()`.
105      */
106     function _beforeFallback() internal virtual {}
107 }
108 
109 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
110 
111 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
112 
113 /**
114  * @dev This is the interface that {BeaconProxy} expects of its beacon.
115  */
116 interface IBeacon {
117     /**
118      * @dev Must return an address that can be used as a delegate call target.
119      *
120      * {BeaconProxy} will check that this address is a contract.
121      */
122     function implementation() external view returns (address);
123 }
124 
125 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
126 
127 /**
128  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
129  * proxy whose upgrades are fully controlled by the current implementation.
130  */
131 interface IERC1822Proxiable {
132     /**
133      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
134      * address.
135      *
136      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
137      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
138      * function revert if invoked through a proxy.
139      */
140     function proxiableUUID() external view returns (bytes32);
141 }
142 
143 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
144 
145 /**
146  * @dev Collection of functions related to the address type
147  */
148 library Address {
149     /**
150      * @dev Returns true if `account` is a contract.
151      *
152      * [IMPORTANT]
153      * ====
154      * It is unsafe to assume that an address for which this function returns
155      * false is an externally-owned account (EOA) and not a contract.
156      *
157      * Among others, `isContract` will return false for the following
158      * types of addresses:
159      *
160      *  - an externally-owned account
161      *  - a contract in construction
162      *  - an address where a contract will be created
163      *  - an address where a contract lived, but was destroyed
164      * ====
165      *
166      * [IMPORTANT]
167      * ====
168      * You shouldn't rely on `isContract` to protect against flash loan attacks!
169      *
170      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
171      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
172      * constructor.
173      * ====
174      */
175     function isContract(address account) internal view returns (bool) {
176         // This method relies on extcodesize/address.code.length, which returns 0
177         // for contracts in construction, since the code is only stored at the end
178         // of the constructor execution.
179 
180         return account.code.length > 0;
181     }
182 
183     /**
184      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
185      * `recipient`, forwarding all available gas and reverting on errors.
186      *
187      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
188      * of certain opcodes, possibly making contracts go over the 2300 gas limit
189      * imposed by `transfer`, making them unable to receive funds via
190      * `transfer`. {sendValue} removes this limitation.
191      *
192      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
193      *
194      * IMPORTANT: because control is transferred to `recipient`, care must be
195      * taken to not create reentrancy vulnerabilities. Consider using
196      * {ReentrancyGuard} or the
197      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
198      */
199     function sendValue(address payable recipient, uint256 amount) internal {
200         require(address(this).balance >= amount, "Address: insufficient balance");
201 
202         (bool success, ) = recipient.call{value: amount}("");
203         require(success, "Address: unable to send value, recipient may have reverted");
204     }
205 
206     /**
207      * @dev Performs a Solidity function call using a low level `call`. A
208      * plain `call` is an unsafe replacement for a function call: use this
209      * function instead.
210      *
211      * If `target` reverts with a revert reason, it is bubbled up by this
212      * function (like regular Solidity function calls).
213      *
214      * Returns the raw returned data. To convert to the expected return value,
215      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
216      *
217      * Requirements:
218      *
219      * - `target` must be a contract.
220      * - calling `target` with `data` must not revert.
221      *
222      * _Available since v3.1._
223      */
224     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
225         return functionCall(target, data, "Address: low-level call failed");
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
230      * `errorMessage` as a fallback revert reason when `target` reverts.
231      *
232      * _Available since v3.1._
233      */
234     function functionCall(
235         address target,
236         bytes memory data,
237         string memory errorMessage
238     ) internal returns (bytes memory) {
239         return functionCallWithValue(target, data, 0, errorMessage);
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
244      * but also transferring `value` wei to `target`.
245      *
246      * Requirements:
247      *
248      * - the calling contract must have an ETH balance of at least `value`.
249      * - the called Solidity function must be `payable`.
250      *
251      * _Available since v3.1._
252      */
253     function functionCallWithValue(
254         address target,
255         bytes memory data,
256         uint256 value
257     ) internal returns (bytes memory) {
258         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
263      * with `errorMessage` as a fallback revert reason when `target` reverts.
264      *
265      * _Available since v3.1._
266      */
267     function functionCallWithValue(
268         address target,
269         bytes memory data,
270         uint256 value,
271         string memory errorMessage
272     ) internal returns (bytes memory) {
273         require(address(this).balance >= value, "Address: insufficient balance for call");
274         require(isContract(target), "Address: call to non-contract");
275 
276         (bool success, bytes memory returndata) = target.call{value: value}(data);
277         return verifyCallResult(success, returndata, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but performing a static call.
283      *
284      * _Available since v3.3._
285      */
286     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
287         return functionStaticCall(target, data, "Address: low-level static call failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
292      * but performing a static call.
293      *
294      * _Available since v3.3._
295      */
296     function functionStaticCall(
297         address target,
298         bytes memory data,
299         string memory errorMessage
300     ) internal view returns (bytes memory) {
301         require(isContract(target), "Address: static call to non-contract");
302 
303         (bool success, bytes memory returndata) = target.staticcall(data);
304         return verifyCallResult(success, returndata, errorMessage);
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
309      * but performing a delegate call.
310      *
311      * _Available since v3.4._
312      */
313     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
314         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
319      * but performing a delegate call.
320      *
321      * _Available since v3.4._
322      */
323     function functionDelegateCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         require(isContract(target), "Address: delegate call to non-contract");
329 
330         (bool success, bytes memory returndata) = target.delegatecall(data);
331         return verifyCallResult(success, returndata, errorMessage);
332     }
333 
334     /**
335      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
336      * revert reason using the provided one.
337      *
338      * _Available since v4.3._
339      */
340     function verifyCallResult(
341         bool success,
342         bytes memory returndata,
343         string memory errorMessage
344     ) internal pure returns (bytes memory) {
345         if (success) {
346             return returndata;
347         } else {
348             // Look for revert reason and bubble it up if present
349             if (returndata.length > 0) {
350                 // The easiest way to bubble the revert reason is using memory via assembly
351 
352                 assembly {
353                     let returndata_size := mload(returndata)
354                     revert(add(32, returndata), returndata_size)
355                 }
356             } else {
357                 revert(errorMessage);
358             }
359         }
360     }
361 }
362 
363 // OpenZeppelin Contracts v4.4.1 (utils/StorageSlot.sol)
364 
365 /**
366  * @dev Library for reading and writing primitive types to specific storage slots.
367  *
368  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
369  * This library helps with reading and writing to such slots without the need for inline assembly.
370  *
371  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
372  *
373  * Example usage to set ERC1967 implementation slot:
374  * ```
375  * contract ERC1967 {
376  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
377  *
378  *     function _getImplementation() internal view returns (address) {
379  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
380  *     }
381  *
382  *     function _setImplementation(address newImplementation) internal {
383  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
384  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
385  *     }
386  * }
387  * ```
388  *
389  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
390  */
391 library StorageSlot {
392     struct AddressSlot {
393         address value;
394     }
395 
396     struct BooleanSlot {
397         bool value;
398     }
399 
400     struct Bytes32Slot {
401         bytes32 value;
402     }
403 
404     struct Uint256Slot {
405         uint256 value;
406     }
407 
408     /**
409      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
410      */
411     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
412         assembly {
413             r.slot := slot
414         }
415     }
416 
417     /**
418      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
419      */
420     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
421         assembly {
422             r.slot := slot
423         }
424     }
425 
426     /**
427      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
428      */
429     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
430         assembly {
431             r.slot := slot
432         }
433     }
434 
435     /**
436      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
437      */
438     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
439         assembly {
440             r.slot := slot
441         }
442     }
443 }
444 
445 /**
446  * @dev This abstract contract provides getters and event emitting update functions for
447  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
448  *
449  * _Available since v4.1._
450  *
451  * @custom:oz-upgrades-unsafe-allow delegatecall
452  */
453 abstract contract ERC1967Upgrade {
454     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
455     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
456 
457     /**
458      * @dev Storage slot with the address of the current implementation.
459      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
460      * validated in the constructor.
461      */
462     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
463 
464     /**
465      * @dev Emitted when the implementation is upgraded.
466      */
467     event Upgraded(address indexed implementation);
468 
469     /**
470      * @dev Returns the current implementation address.
471      */
472     function _getImplementation() internal view returns (address) {
473         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
474     }
475 
476     /**
477      * @dev Stores a new address in the EIP1967 implementation slot.
478      */
479     function _setImplementation(address newImplementation) private {
480         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
481         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
482     }
483 
484     /**
485      * @dev Perform implementation upgrade
486      *
487      * Emits an {Upgraded} event.
488      */
489     function _upgradeTo(address newImplementation) internal {
490         _setImplementation(newImplementation);
491         emit Upgraded(newImplementation);
492     }
493 
494     /**
495      * @dev Perform implementation upgrade with additional setup call.
496      *
497      * Emits an {Upgraded} event.
498      */
499     function _upgradeToAndCall(
500         address newImplementation,
501         bytes memory data,
502         bool forceCall
503     ) internal {
504         _upgradeTo(newImplementation);
505         if (data.length > 0 || forceCall) {
506             Address.functionDelegateCall(newImplementation, data);
507         }
508     }
509 
510     /**
511      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
512      *
513      * Emits an {Upgraded} event.
514      */
515     function _upgradeToAndCallUUPS(
516         address newImplementation,
517         bytes memory data,
518         bool forceCall
519     ) internal {
520         // Upgrades from old implementations will perform a rollback test. This test requires the new
521         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
522         // this special case will break upgrade paths from old UUPS implementation to new ones.
523         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
524             _setImplementation(newImplementation);
525         } else {
526             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
527                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
528             } catch {
529                 revert("ERC1967Upgrade: new implementation is not UUPS");
530             }
531             _upgradeToAndCall(newImplementation, data, forceCall);
532         }
533     }
534 
535     /**
536      * @dev Storage slot with the admin of the contract.
537      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
538      * validated in the constructor.
539      */
540     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
541 
542     /**
543      * @dev Emitted when the admin account has changed.
544      */
545     event AdminChanged(address previousAdmin, address newAdmin);
546 
547     /**
548      * @dev Returns the current admin.
549      */
550     function _getAdmin() internal view returns (address) {
551         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
552     }
553 
554     /**
555      * @dev Stores a new address in the EIP1967 admin slot.
556      */
557     function _setAdmin(address newAdmin) private {
558         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
559         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
560     }
561 
562     /**
563      * @dev Changes the admin of the proxy.
564      *
565      * Emits an {AdminChanged} event.
566      */
567     function _changeAdmin(address newAdmin) internal {
568         emit AdminChanged(_getAdmin(), newAdmin);
569         _setAdmin(newAdmin);
570     }
571 
572     /**
573      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
574      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
575      */
576     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
577 
578     /**
579      * @dev Emitted when the beacon is upgraded.
580      */
581     event BeaconUpgraded(address indexed beacon);
582 
583     /**
584      * @dev Returns the current beacon.
585      */
586     function _getBeacon() internal view returns (address) {
587         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
588     }
589 
590     /**
591      * @dev Stores a new beacon in the EIP1967 beacon slot.
592      */
593     function _setBeacon(address newBeacon) private {
594         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
595         require(
596             Address.isContract(IBeacon(newBeacon).implementation()),
597             "ERC1967: beacon implementation is not a contract"
598         );
599         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
600     }
601 
602     /**
603      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
604      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
605      *
606      * Emits a {BeaconUpgraded} event.
607      */
608     function _upgradeBeaconToAndCall(
609         address newBeacon,
610         bytes memory data,
611         bool forceCall
612     ) internal {
613         _setBeacon(newBeacon);
614         emit BeaconUpgraded(newBeacon);
615         if (data.length > 0 || forceCall) {
616             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
617         }
618     }
619 }
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
647 /// @dev Zora NFT Creator Proxy Access Contract
648 contract ERC721DropProxy is ERC1967Proxy {
649     constructor(address _logic, bytes memory _data)
650         payable
651         ERC1967Proxy(_logic, _data)
652     {}
653 }