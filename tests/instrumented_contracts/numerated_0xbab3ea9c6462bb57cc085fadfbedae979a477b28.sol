1 // SPDX-License-Identifier: MIXED
2 
3 // Sources flattened with hardhat v2.11.2 https://hardhat.org
4 
5 // File @openzeppelin/contracts-v4.4.2/proxy/Proxy.sol@v4.4.2
6 
7 // License-Identifier: MIT
8 // OpenZeppelin Contracts v4.4.1 (proxy/Proxy.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
14  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
15  * be specified by overriding the virtual {_implementation} function.
16  *
17  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
18  * different contract through the {_delegate} function.
19  *
20  * The success and return data of the delegated call will be returned back to the caller of the proxy.
21  */
22 abstract contract Proxy {
23     /**
24      * @dev Delegates the current call to `implementation`.
25      *
26      * This function does not return to its internall call site, it will return directly to the external caller.
27      */
28     function _delegate(address implementation) internal virtual {
29         assembly {
30             // Copy msg.data. We take full control of memory in this inline assembly
31             // block because it will not return to Solidity code. We overwrite the
32             // Solidity scratch pad at memory position 0.
33             calldatacopy(0, 0, calldatasize())
34 
35             // Call the implementation.
36             // out and outsize are 0 because we don't know the size yet.
37             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
38 
39             // Copy the returned data.
40             returndatacopy(0, 0, returndatasize())
41 
42             switch result
43             // delegatecall returns 0 on error.
44             case 0 {
45                 revert(0, returndatasize())
46             }
47             default {
48                 return(0, returndatasize())
49             }
50         }
51     }
52 
53     /**
54      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
55      * and {_fallback} should delegate.
56      */
57     function _implementation() internal view virtual returns (address);
58 
59     /**
60      * @dev Delegates the current call to the address returned by `_implementation()`.
61      *
62      * This function does not return to its internall call site, it will return directly to the external caller.
63      */
64     function _fallback() internal virtual {
65         _beforeFallback();
66         _delegate(_implementation());
67     }
68 
69     /**
70      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
71      * function in the contract matches the call data.
72      */
73     fallback() external payable virtual {
74         _fallback();
75     }
76 
77     /**
78      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
79      * is empty.
80      */
81     receive() external payable virtual {
82         _fallback();
83     }
84 
85     /**
86      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
87      * call, or as part of the Solidity `fallback` or `receive` functions.
88      *
89      * If overriden should call `super._beforeFallback()`.
90      */
91     function _beforeFallback() internal virtual {}
92 }
93 
94 
95 // File @openzeppelin/contracts-v4.4.2/proxy/beacon/IBeacon.sol@v4.4.2
96 
97 // License-Identifier: MIT
98 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @dev This is the interface that {BeaconProxy} expects of its beacon.
104  */
105 interface IBeacon {
106     /**
107      * @dev Must return an address that can be used as a delegate call target.
108      *
109      * {BeaconProxy} will check that this address is a contract.
110      */
111     function implementation() external view returns (address);
112 }
113 
114 
115 // File @openzeppelin/contracts-v4.4.2/utils/StorageSlot.sol@v4.4.2
116 
117 // License-Identifier: MIT
118 // OpenZeppelin Contracts v4.4.1 (utils/StorageSlot.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Library for reading and writing primitive types to specific storage slots.
124  *
125  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
126  * This library helps with reading and writing to such slots without the need for inline assembly.
127  *
128  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
129  *
130  * Example usage to set ERC1967 implementation slot:
131  * ```
132  * contract ERC1967 {
133  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
134  *
135  *     function _getImplementation() internal view returns (address) {
136  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
137  *     }
138  *
139  *     function _setImplementation(address newImplementation) internal {
140  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
141  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
142  *     }
143  * }
144  * ```
145  *
146  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
147  */
148 library StorageSlot {
149     struct AddressSlot {
150         address value;
151     }
152 
153     struct BooleanSlot {
154         bool value;
155     }
156 
157     struct Bytes32Slot {
158         bytes32 value;
159     }
160 
161     struct Uint256Slot {
162         uint256 value;
163     }
164 
165     /**
166      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
167      */
168     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
169         assembly {
170             r.slot := slot
171         }
172     }
173 
174     /**
175      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
176      */
177     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
178         assembly {
179             r.slot := slot
180         }
181     }
182 
183     /**
184      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
185      */
186     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
187         assembly {
188             r.slot := slot
189         }
190     }
191 
192     /**
193      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
194      */
195     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
196         assembly {
197             r.slot := slot
198         }
199     }
200 }
201 
202 
203 // File @openzeppelin/contracts-v4.4.2/utils/Address.sol@v4.4.2
204 
205 // License-Identifier: MIT
206 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
207 
208 pragma solidity ^0.8.0;
209 
210 /**
211  * @dev Collection of functions related to the address type
212  */
213 library Address {
214     /**
215      * @dev Returns true if `account` is a contract.
216      *
217      * [IMPORTANT]
218      * ====
219      * It is unsafe to assume that an address for which this function returns
220      * false is an externally-owned account (EOA) and not a contract.
221      *
222      * Among others, `isContract` will return false for the following
223      * types of addresses:
224      *
225      *  - an externally-owned account
226      *  - a contract in construction
227      *  - an address where a contract will be created
228      *  - an address where a contract lived, but was destroyed
229      * ====
230      */
231     function isContract(address account) internal view returns (bool) {
232         // This method relies on extcodesize, which returns 0 for contracts in
233         // construction, since the code is only stored at the end of the
234         // constructor execution.
235 
236         uint256 size;
237         assembly {
238             size := extcodesize(account)
239         }
240         return size > 0;
241     }
242 
243     /**
244      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
245      * `recipient`, forwarding all available gas and reverting on errors.
246      *
247      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
248      * of certain opcodes, possibly making contracts go over the 2300 gas limit
249      * imposed by `transfer`, making them unable to receive funds via
250      * `transfer`. {sendValue} removes this limitation.
251      *
252      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
253      *
254      * IMPORTANT: because control is transferred to `recipient`, care must be
255      * taken to not create reentrancy vulnerabilities. Consider using
256      * {ReentrancyGuard} or the
257      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
258      */
259     function sendValue(address payable recipient, uint256 amount) internal {
260         require(address(this).balance >= amount, "Address: insufficient balance");
261 
262         (bool success, ) = recipient.call{value: amount}("");
263         require(success, "Address: unable to send value, recipient may have reverted");
264     }
265 
266     /**
267      * @dev Performs a Solidity function call using a low level `call`. A
268      * plain `call` is an unsafe replacement for a function call: use this
269      * function instead.
270      *
271      * If `target` reverts with a revert reason, it is bubbled up by this
272      * function (like regular Solidity function calls).
273      *
274      * Returns the raw returned data. To convert to the expected return value,
275      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
276      *
277      * Requirements:
278      *
279      * - `target` must be a contract.
280      * - calling `target` with `data` must not revert.
281      *
282      * _Available since v3.1._
283      */
284     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
285         return functionCall(target, data, "Address: low-level call failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
290      * `errorMessage` as a fallback revert reason when `target` reverts.
291      *
292      * _Available since v3.1._
293      */
294     function functionCall(
295         address target,
296         bytes memory data,
297         string memory errorMessage
298     ) internal returns (bytes memory) {
299         return functionCallWithValue(target, data, 0, errorMessage);
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
304      * but also transferring `value` wei to `target`.
305      *
306      * Requirements:
307      *
308      * - the calling contract must have an ETH balance of at least `value`.
309      * - the called Solidity function must be `payable`.
310      *
311      * _Available since v3.1._
312      */
313     function functionCallWithValue(
314         address target,
315         bytes memory data,
316         uint256 value
317     ) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
323      * with `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCallWithValue(
328         address target,
329         bytes memory data,
330         uint256 value,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         require(address(this).balance >= value, "Address: insufficient balance for call");
334         require(isContract(target), "Address: call to non-contract");
335 
336         (bool success, bytes memory returndata) = target.call{value: value}(data);
337         return verifyCallResult(success, returndata, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but performing a static call.
343      *
344      * _Available since v3.3._
345      */
346     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
347         return functionStaticCall(target, data, "Address: low-level static call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
352      * but performing a static call.
353      *
354      * _Available since v3.3._
355      */
356     function functionStaticCall(
357         address target,
358         bytes memory data,
359         string memory errorMessage
360     ) internal view returns (bytes memory) {
361         require(isContract(target), "Address: static call to non-contract");
362 
363         (bool success, bytes memory returndata) = target.staticcall(data);
364         return verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but performing a delegate call.
370      *
371      * _Available since v3.4._
372      */
373     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
374         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
379      * but performing a delegate call.
380      *
381      * _Available since v3.4._
382      */
383     function functionDelegateCall(
384         address target,
385         bytes memory data,
386         string memory errorMessage
387     ) internal returns (bytes memory) {
388         require(isContract(target), "Address: delegate call to non-contract");
389 
390         (bool success, bytes memory returndata) = target.delegatecall(data);
391         return verifyCallResult(success, returndata, errorMessage);
392     }
393 
394     /**
395      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
396      * revert reason using the provided one.
397      *
398      * _Available since v4.3._
399      */
400     function verifyCallResult(
401         bool success,
402         bytes memory returndata,
403         string memory errorMessage
404     ) internal pure returns (bytes memory) {
405         if (success) {
406             return returndata;
407         } else {
408             // Look for revert reason and bubble it up if present
409             if (returndata.length > 0) {
410                 // The easiest way to bubble the revert reason is using memory via assembly
411 
412                 assembly {
413                     let returndata_size := mload(returndata)
414                     revert(add(32, returndata), returndata_size)
415                 }
416             } else {
417                 revert(errorMessage);
418             }
419         }
420     }
421 }
422 
423 
424 // File @openzeppelin/contracts-v4.4.2/proxy/ERC1967/ERC1967Upgrade.sol@v4.4.2
425 
426 // License-Identifier: MIT
427 // OpenZeppelin Contracts v4.4.1 (proxy/ERC1967/ERC1967Upgrade.sol)
428 
429 pragma solidity ^0.8.2;
430 
431 
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
503     function _upgradeToAndCallSecure(
504         address newImplementation,
505         bytes memory data,
506         bool forceCall
507     ) internal {
508         address oldImplementation = _getImplementation();
509 
510         // Initial upgrade and setup call
511         _setImplementation(newImplementation);
512         if (data.length > 0 || forceCall) {
513             Address.functionDelegateCall(newImplementation, data);
514         }
515 
516         // Perform rollback test if not already in progress
517         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
518         if (!rollbackTesting.value) {
519             // Trigger rollback using upgradeTo from the new implementation
520             rollbackTesting.value = true;
521             Address.functionDelegateCall(
522                 newImplementation,
523                 abi.encodeWithSignature("upgradeTo(address)", oldImplementation)
524             );
525             rollbackTesting.value = false;
526             // Check rollback was effective
527             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
528             // Finally reset to the new implementation and log the upgrade
529             _upgradeTo(newImplementation);
530         }
531     }
532 
533     /**
534      * @dev Storage slot with the admin of the contract.
535      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
536      * validated in the constructor.
537      */
538     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
539 
540     /**
541      * @dev Emitted when the admin account has changed.
542      */
543     event AdminChanged(address previousAdmin, address newAdmin);
544 
545     /**
546      * @dev Returns the current admin.
547      */
548     function _getAdmin() internal view returns (address) {
549         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
550     }
551 
552     /**
553      * @dev Stores a new address in the EIP1967 admin slot.
554      */
555     function _setAdmin(address newAdmin) private {
556         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
557         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
558     }
559 
560     /**
561      * @dev Changes the admin of the proxy.
562      *
563      * Emits an {AdminChanged} event.
564      */
565     function _changeAdmin(address newAdmin) internal {
566         emit AdminChanged(_getAdmin(), newAdmin);
567         _setAdmin(newAdmin);
568     }
569 
570     /**
571      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
572      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
573      */
574     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
575 
576     /**
577      * @dev Emitted when the beacon is upgraded.
578      */
579     event BeaconUpgraded(address indexed beacon);
580 
581     /**
582      * @dev Returns the current beacon.
583      */
584     function _getBeacon() internal view returns (address) {
585         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
586     }
587 
588     /**
589      * @dev Stores a new beacon in the EIP1967 beacon slot.
590      */
591     function _setBeacon(address newBeacon) private {
592         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
593         require(
594             Address.isContract(IBeacon(newBeacon).implementation()),
595             "ERC1967: beacon implementation is not a contract"
596         );
597         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
598     }
599 
600     /**
601      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
602      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
603      *
604      * Emits a {BeaconUpgraded} event.
605      */
606     function _upgradeBeaconToAndCall(
607         address newBeacon,
608         bytes memory data,
609         bool forceCall
610     ) internal {
611         _setBeacon(newBeacon);
612         emit BeaconUpgraded(newBeacon);
613         if (data.length > 0 || forceCall) {
614             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
615         }
616     }
617 }
618 
619 
620 // File @openzeppelin/contracts-v4.4.2/proxy/ERC1967/ERC1967Proxy.sol@v4.4.2
621 
622 // License-Identifier: MIT
623 // OpenZeppelin Contracts v4.4.1 (proxy/ERC1967/ERC1967Proxy.sol)
624 
625 pragma solidity ^0.8.0;
626 
627 
628 /**
629  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
630  * implementation address that can be changed. This address is stored in storage in the location specified by
631  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
632  * implementation behind the proxy.
633  */
634 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
635     /**
636      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
637      *
638      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
639      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
640      */
641     constructor(address _logic, bytes memory _data) payable {
642         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
643         _upgradeToAndCall(_logic, _data, false);
644     }
645 
646     /**
647      * @dev Returns the current implementation address.
648      */
649     function _implementation() internal view virtual override returns (address impl) {
650         return ERC1967Upgrade._getImplementation();
651     }
652 }
653 
654 
655 // File contracts/bridge/wormhole/bridge/TokenBridge.sol
656 
657 // contracts/Wormhole.sol
658 // License-Identifier: Apache 2
659 
660 pragma solidity ^0.8.0;
661 
662 contract TokenBridge is ERC1967Proxy {
663     constructor(address implementation, bytes memory initData) ERC1967Proxy(implementation, initData) {}
664 }