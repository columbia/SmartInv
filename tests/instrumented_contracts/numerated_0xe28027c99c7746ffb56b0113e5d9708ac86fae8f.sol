1 // File: @openzeppelin/contracts/proxy/beacon/IBeacon.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev This is the interface that {BeaconProxy} expects of its beacon.
9  */
10 interface IBeacon {
11     /**
12      * @dev Must return an address that can be used as a delegate call target.
13      *
14      * {BeaconProxy} will check that this address is a contract.
15      */
16     function implementation() external view returns (address);
17 }
18 
19 // File: @openzeppelin/contracts/proxy/Proxy.sol
20 
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
26  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
27  * be specified by overriding the virtual {_implementation} function.
28  *
29  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
30  * different contract through the {_delegate} function.
31  *
32  * The success and return data of the delegated call will be returned back to the caller of the proxy.
33  */
34 abstract contract Proxy {
35     /**
36      * @dev Delegates the current call to `implementation`.
37      *
38      * This function does not return to its internall call site, it will return directly to the external caller.
39      */
40     function _delegate(address implementation) internal virtual {
41         assembly {
42             // Copy msg.data. We take full control of memory in this inline assembly
43             // block because it will not return to Solidity code. We overwrite the
44             // Solidity scratch pad at memory position 0.
45             calldatacopy(0, 0, calldatasize())
46 
47             // Call the implementation.
48             // out and outsize are 0 because we don't know the size yet.
49             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
50 
51             // Copy the returned data.
52             returndatacopy(0, 0, returndatasize())
53 
54             switch result
55             // delegatecall returns 0 on error.
56             case 0 {
57                 revert(0, returndatasize())
58             }
59             default {
60                 return(0, returndatasize())
61             }
62         }
63     }
64 
65     /**
66      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
67      * and {_fallback} should delegate.
68      */
69     function _implementation() internal view virtual returns (address);
70 
71     /**
72      * @dev Delegates the current call to the address returned by `_implementation()`.
73      *
74      * This function does not return to its internall call site, it will return directly to the external caller.
75      */
76     function _fallback() internal virtual {
77         _beforeFallback();
78         _delegate(_implementation());
79     }
80 
81     /**
82      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
83      * function in the contract matches the call data.
84      */
85     fallback() external payable virtual {
86         _fallback();
87     }
88 
89     /**
90      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
91      * is empty.
92      */
93     receive() external payable virtual {
94         _fallback();
95     }
96 
97     /**
98      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
99      * call, or as part of the Solidity `fallback` or `receive` functions.
100      *
101      * If overriden should call `super._beforeFallback()`.
102      */
103     function _beforeFallback() internal virtual {}
104 }
105 
106 // File: @openzeppelin/contracts/utils/Address.sol
107 
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
163         (bool success, ) = recipient.call{value: amount}("");
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
237         (bool success, bytes memory returndata) = target.call{value: value}(data);
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
324 // File: @openzeppelin/contracts/utils/StorageSlot.sol
325 
326 
327 pragma solidity ^0.8.0;
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
409 // File: @openzeppelin/contracts/proxy/ERC1967/ERC1967Upgrade.sol
410 
411 
412 pragma solidity ^0.8.2;
413 
414 
415 
416 /**
417  * @dev This abstract contract provides getters and event emitting update functions for
418  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
419  *
420  * _Available since v4.1._
421  *
422  * @custom:oz-upgrades-unsafe-allow delegatecall
423  */
424 abstract contract ERC1967Upgrade {
425     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
426     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
427 
428     /**
429      * @dev Storage slot with the address of the current implementation.
430      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
431      * validated in the constructor.
432      */
433     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
434 
435     /**
436      * @dev Emitted when the implementation is upgraded.
437      */
438     event Upgraded(address indexed implementation);
439 
440     /**
441      * @dev Returns the current implementation address.
442      */
443     function _getImplementation() internal view returns (address) {
444         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
445     }
446 
447     /**
448      * @dev Stores a new address in the EIP1967 implementation slot.
449      */
450     function _setImplementation(address newImplementation) private {
451         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
452         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
453     }
454 
455     /**
456      * @dev Perform implementation upgrade
457      *
458      * Emits an {Upgraded} event.
459      */
460     function _upgradeTo(address newImplementation) internal {
461         _setImplementation(newImplementation);
462         emit Upgraded(newImplementation);
463     }
464 
465     /**
466      * @dev Perform implementation upgrade with additional setup call.
467      *
468      * Emits an {Upgraded} event.
469      */
470     function _upgradeToAndCall(
471         address newImplementation,
472         bytes memory data,
473         bool forceCall
474     ) internal {
475         _upgradeTo(newImplementation);
476         if (data.length > 0 || forceCall) {
477             Address.functionDelegateCall(newImplementation, data);
478         }
479     }
480 
481     /**
482      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
483      *
484      * Emits an {Upgraded} event.
485      */
486     function _upgradeToAndCallSecure(
487         address newImplementation,
488         bytes memory data,
489         bool forceCall
490     ) internal {
491         address oldImplementation = _getImplementation();
492 
493         // Initial upgrade and setup call
494         _setImplementation(newImplementation);
495         if (data.length > 0 || forceCall) {
496             Address.functionDelegateCall(newImplementation, data);
497         }
498 
499         // Perform rollback test if not already in progress
500         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
501         if (!rollbackTesting.value) {
502             // Trigger rollback using upgradeTo from the new implementation
503             rollbackTesting.value = true;
504             Address.functionDelegateCall(
505                 newImplementation,
506                 abi.encodeWithSignature("upgradeTo(address)", oldImplementation)
507             );
508             rollbackTesting.value = false;
509             // Check rollback was effective
510             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
511             // Finally reset to the new implementation and log the upgrade
512             _upgradeTo(newImplementation);
513         }
514     }
515 
516     /**
517      * @dev Storage slot with the admin of the contract.
518      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
519      * validated in the constructor.
520      */
521     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
522 
523     /**
524      * @dev Emitted when the admin account has changed.
525      */
526     event AdminChanged(address previousAdmin, address newAdmin);
527 
528     /**
529      * @dev Returns the current admin.
530      */
531     function _getAdmin() internal view returns (address) {
532         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
533     }
534 
535     /**
536      * @dev Stores a new address in the EIP1967 admin slot.
537      */
538     function _setAdmin(address newAdmin) private {
539         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
540         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
541     }
542 
543     /**
544      * @dev Changes the admin of the proxy.
545      *
546      * Emits an {AdminChanged} event.
547      */
548     function _changeAdmin(address newAdmin) internal {
549         emit AdminChanged(_getAdmin(), newAdmin);
550         _setAdmin(newAdmin);
551     }
552 
553     /**
554      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
555      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
556      */
557     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
558 
559     /**
560      * @dev Emitted when the beacon is upgraded.
561      */
562     event BeaconUpgraded(address indexed beacon);
563 
564     /**
565      * @dev Returns the current beacon.
566      */
567     function _getBeacon() internal view returns (address) {
568         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
569     }
570 
571     /**
572      * @dev Stores a new beacon in the EIP1967 beacon slot.
573      */
574     function _setBeacon(address newBeacon) private {
575         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
576         require(
577             Address.isContract(IBeacon(newBeacon).implementation()),
578             "ERC1967: beacon implementation is not a contract"
579         );
580         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
581     }
582 
583     /**
584      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
585      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
586      *
587      * Emits a {BeaconUpgraded} event.
588      */
589     function _upgradeBeaconToAndCall(
590         address newBeacon,
591         bytes memory data,
592         bool forceCall
593     ) internal {
594         _setBeacon(newBeacon);
595         emit BeaconUpgraded(newBeacon);
596         if (data.length > 0 || forceCall) {
597             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
598         }
599     }
600 }
601 
602 // File: @openzeppelin/contracts/proxy/beacon/BeaconProxy.sol
603 
604 
605 pragma solidity ^0.8.0;
606 
607 
608 
609 /**
610  * @dev This contract implements a proxy that gets the implementation address for each call from a {UpgradeableBeacon}.
611  *
612  * The beacon address is stored in storage slot `uint256(keccak256('eip1967.proxy.beacon')) - 1`, so that it doesn't
613  * conflict with the storage layout of the implementation behind the proxy.
614  *
615  * _Available since v3.4._
616  */
617 contract BeaconProxy is Proxy, ERC1967Upgrade {
618     /**
619      * @dev Initializes the proxy with `beacon`.
620      *
621      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon. This
622      * will typically be an encoded function call, and allows initializating the storage of the proxy like a Solidity
623      * constructor.
624      *
625      * Requirements:
626      *
627      * - `beacon` must be a contract with the interface {IBeacon}.
628      */
629     constructor(address beacon, bytes memory data) payable {
630         assert(_BEACON_SLOT == bytes32(uint256(keccak256("eip1967.proxy.beacon")) - 1));
631         _upgradeBeaconToAndCall(beacon, data, false);
632     }
633 
634     /**
635      * @dev Returns the current beacon address.
636      */
637     function _beacon() internal view virtual returns (address) {
638         return _getBeacon();
639     }
640 
641     /**
642      * @dev Returns the current implementation address of the associated beacon.
643      */
644     function _implementation() internal view virtual override returns (address) {
645         return IBeacon(_getBeacon()).implementation();
646     }
647 
648     /**
649      * @dev Changes the proxy to use a new beacon. Deprecated: see {_upgradeBeaconToAndCall}.
650      *
651      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon.
652      *
653      * Requirements:
654      *
655      * - `beacon` must be a contract.
656      * - The implementation returned by `beacon` must be a contract.
657      */
658     function _setBeacon(address beacon, bytes memory data) internal virtual {
659         _upgradeBeaconToAndCall(beacon, data, false);
660     }
661 }
662 
663 // File: contracts/bridge/token/Token.sol
664 
665 // contracts/Structs.sol
666 
667 pragma solidity ^0.8.0;
668 
669 contract BridgeToken is BeaconProxy {
670     constructor(address beacon, bytes memory data) BeaconProxy(beacon, data) {
671 
672     }
673 }