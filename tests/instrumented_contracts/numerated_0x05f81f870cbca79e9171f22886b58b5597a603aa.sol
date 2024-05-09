1 // Sources flattened with hardhat v2.12.0 https://hardhat.org
2 
3 // File contracts/oz/proxy/Proxy.sol
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/Proxy.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
12  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
13  * be specified by overriding the virtual {_implementation} function.
14  *
15  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
16  * different contract through the {_delegate} function.
17  *
18  * The success and return data of the delegated call will be returned back to the caller of the proxy.
19  */
20 abstract contract Proxy {
21   /**
22    * @dev Delegates the current call to `implementation`.
23    *
24    * This function does not return to its internal call site, it will return directly to the external caller.
25    */
26   function _delegate(address implementation) internal virtual {
27     assembly {
28       // Copy msg.data. We take full control of memory in this inline assembly
29       // block because it will not return to Solidity code. We overwrite the
30       // Solidity scratch pad at memory position 0.
31       calldatacopy(0, 0, calldatasize())
32 
33       // Call the implementation.
34       // out and outsize are 0 because we don't know the size yet.
35       let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
36 
37       // Copy the returned data.
38       returndatacopy(0, 0, returndatasize())
39 
40       switch result
41       // delegatecall returns 0 on error.
42       case 0 {
43         revert(0, returndatasize())
44       }
45       default {
46         return(0, returndatasize())
47       }
48     }
49   }
50 
51   /**
52    * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
53    * and {_fallback} should delegate.
54    */
55   function _implementation() internal view virtual returns (address);
56 
57   /**
58    * @dev Delegates the current call to the address returned by `_implementation()`.
59    *
60    * This function does not return to its internall call site, it will return directly to the external caller.
61    */
62   function _fallback() internal virtual {
63     _beforeFallback();
64     _delegate(_implementation());
65   }
66 
67   /**
68    * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
69    * function in the contract matches the call data.
70    */
71   fallback() external payable virtual {
72     _fallback();
73   }
74 
75   /**
76    * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
77    * is empty.
78    */
79   receive() external payable virtual {
80     _fallback();
81   }
82 
83   /**
84    * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
85    * call, or as part of the Solidity `fallback` or `receive` functions.
86    *
87    * If overriden should call `super._beforeFallback()`.
88    */
89   function _beforeFallback() internal virtual {}
90 }
91 
92 
93 // File contracts/oz/interfaces/draft-IERC1822.sol
94 
95 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
96 
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
101  * proxy whose upgrades are fully controlled by the current implementation.
102  */
103 interface IERC1822Proxiable {
104   /**
105    * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
106    * address.
107    *
108    * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
109    * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
110    * function revert if invoked through a proxy.
111    */
112   function proxiableUUID() external view returns (bytes32);
113 }
114 
115 
116 // File contracts/oz/utils/Address.sol
117 
118 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
119 
120 pragma solidity ^0.8.1;
121 
122 /**
123  * @dev Collection of functions related to the address type
124  */
125 library Address {
126   /**
127    * @dev Returns true if `account` is a contract.
128    *
129    * [IMPORTANT]
130    * ====
131    * It is unsafe to assume that an address for which this function returns
132    * false is an externally-owned account (EOA) and not a contract.
133    *
134    * Among others, `isContract` will return false for the following
135    * types of addresses:
136    *
137    *  - an externally-owned account
138    *  - a contract in construction
139    *  - an address where a contract will be created
140    *  - an address where a contract lived, but was destroyed
141    * ====
142    *
143    * [IMPORTANT]
144    * ====
145    * You shouldn't rely on `isContract` to protect against flash loan attacks!
146    *
147    * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
148    * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
149    * constructor.
150    * ====
151    */
152   function isContract(address account) internal view returns (bool) {
153     // This method relies on extcodesize/address.code.length, which returns 0
154     // for contracts in construction, since the code is only stored at the end
155     // of the constructor execution.
156 
157     return account.code.length > 0;
158   }
159 
160   /**
161    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
162    * `recipient`, forwarding all available gas and reverting on errors.
163    *
164    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
165    * of certain opcodes, possibly making contracts go over the 2300 gas limit
166    * imposed by `transfer`, making them unable to receive funds via
167    * `transfer`. {sendValue} removes this limitation.
168    *
169    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
170    *
171    * IMPORTANT: because control is transferred to `recipient`, care must be
172    * taken to not create reentrancy vulnerabilities. Consider using
173    * {ReentrancyGuard} or the
174    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
175    */
176   function sendValue(address payable recipient, uint256 amount) internal {
177     require(address(this).balance >= amount, "Address: insufficient balance");
178 
179     (bool success, ) = recipient.call{value: amount}("");
180     require(
181       success,
182       "Address: unable to send value, recipient may have reverted"
183     );
184   }
185 
186   /**
187    * @dev Performs a Solidity function call using a low level `call`. A
188    * plain `call` is an unsafe replacement for a function call: use this
189    * function instead.
190    *
191    * If `target` reverts with a revert reason, it is bubbled up by this
192    * function (like regular Solidity function calls).
193    *
194    * Returns the raw returned data. To convert to the expected return value,
195    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
196    *
197    * Requirements:
198    *
199    * - `target` must be a contract.
200    * - calling `target` with `data` must not revert.
201    *
202    * _Available since v3.1._
203    */
204   function functionCall(address target, bytes memory data)
205     internal
206     returns (bytes memory)
207   {
208     return functionCall(target, data, "Address: low-level call failed");
209   }
210 
211   /**
212    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
213    * `errorMessage` as a fallback revert reason when `target` reverts.
214    *
215    * _Available since v3.1._
216    */
217   function functionCall(
218     address target,
219     bytes memory data,
220     string memory errorMessage
221   ) internal returns (bytes memory) {
222     return functionCallWithValue(target, data, 0, errorMessage);
223   }
224 
225   /**
226    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
227    * but also transferring `value` wei to `target`.
228    *
229    * Requirements:
230    *
231    * - the calling contract must have an ETH balance of at least `value`.
232    * - the called Solidity function must be `payable`.
233    *
234    * _Available since v3.1._
235    */
236   function functionCallWithValue(
237     address target,
238     bytes memory data,
239     uint256 value
240   ) internal returns (bytes memory) {
241     return
242       functionCallWithValue(
243         target,
244         data,
245         value,
246         "Address: low-level call with value failed"
247       );
248   }
249 
250   /**
251    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
252    * with `errorMessage` as a fallback revert reason when `target` reverts.
253    *
254    * _Available since v3.1._
255    */
256   function functionCallWithValue(
257     address target,
258     bytes memory data,
259     uint256 value,
260     string memory errorMessage
261   ) internal returns (bytes memory) {
262     require(
263       address(this).balance >= value,
264       "Address: insufficient balance for call"
265     );
266     require(isContract(target), "Address: call to non-contract");
267 
268     (bool success, bytes memory returndata) = target.call{value: value}(data);
269     return verifyCallResult(success, returndata, errorMessage);
270   }
271 
272   /**
273    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
274    * but performing a static call.
275    *
276    * _Available since v3.3._
277    */
278   function functionStaticCall(address target, bytes memory data)
279     internal
280     view
281     returns (bytes memory)
282   {
283     return
284       functionStaticCall(target, data, "Address: low-level static call failed");
285   }
286 
287   /**
288    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
289    * but performing a static call.
290    *
291    * _Available since v3.3._
292    */
293   function functionStaticCall(
294     address target,
295     bytes memory data,
296     string memory errorMessage
297   ) internal view returns (bytes memory) {
298     require(isContract(target), "Address: static call to non-contract");
299 
300     (bool success, bytes memory returndata) = target.staticcall(data);
301     return verifyCallResult(success, returndata, errorMessage);
302   }
303 
304   /**
305    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
306    * but performing a delegate call.
307    *
308    * _Available since v3.4._
309    */
310   function functionDelegateCall(address target, bytes memory data)
311     internal
312     returns (bytes memory)
313   {
314     return
315       functionDelegateCall(
316         target,
317         data,
318         "Address: low-level delegate call failed"
319       );
320   }
321 
322   /**
323    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
324    * but performing a delegate call.
325    *
326    * _Available since v3.4._
327    */
328   function functionDelegateCall(
329     address target,
330     bytes memory data,
331     string memory errorMessage
332   ) internal returns (bytes memory) {
333     require(isContract(target), "Address: delegate call to non-contract");
334 
335     (bool success, bytes memory returndata) = target.delegatecall(data);
336     return verifyCallResult(success, returndata, errorMessage);
337   }
338 
339   /**
340    * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
341    * revert reason using the provided one.
342    *
343    * _Available since v4.3._
344    */
345   function verifyCallResult(
346     bool success,
347     bytes memory returndata,
348     string memory errorMessage
349   ) internal pure returns (bytes memory) {
350     if (success) {
351       return returndata;
352     } else {
353       // Look for revert reason and bubble it up if present
354       if (returndata.length > 0) {
355         // The easiest way to bubble the revert reason is using memory via assembly
356 
357         assembly {
358           let returndata_size := mload(returndata)
359           revert(add(32, returndata), returndata_size)
360         }
361       } else {
362         revert(errorMessage);
363       }
364     }
365   }
366 }
367 
368 
369 // File contracts/oz/utils/StorageSlot.sol
370 
371 // OpenZeppelin Contracts v4.4.1 (utils/StorageSlot.sol)
372 
373 pragma solidity ^0.8.0;
374 
375 /**
376  * @dev Library for reading and writing primitive types to specific storage slots.
377  *
378  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
379  * This library helps with reading and writing to such slots without the need for inline assembly.
380  *
381  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
382  *
383  * Example usage to set ERC1967 implementation slot:
384  * ```
385  * contract ERC1967 {
386  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
387  *
388  *     function _getImplementation() internal view returns (address) {
389  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
390  *     }
391  *
392  *     function _setImplementation(address newImplementation) internal {
393  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
394  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
395  *     }
396  * }
397  * ```
398  *
399  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
400  */
401 library StorageSlot {
402   struct AddressSlot {
403     address value;
404   }
405 
406   struct BooleanSlot {
407     bool value;
408   }
409 
410   struct Bytes32Slot {
411     bytes32 value;
412   }
413 
414   struct Uint256Slot {
415     uint256 value;
416   }
417 
418   /**
419    * @dev Returns an `AddressSlot` with member `value` located at `slot`.
420    */
421   function getAddressSlot(bytes32 slot)
422     internal
423     pure
424     returns (AddressSlot storage r)
425   {
426     assembly {
427       r.slot := slot
428     }
429   }
430 
431   /**
432    * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
433    */
434   function getBooleanSlot(bytes32 slot)
435     internal
436     pure
437     returns (BooleanSlot storage r)
438   {
439     assembly {
440       r.slot := slot
441     }
442   }
443 
444   /**
445    * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
446    */
447   function getBytes32Slot(bytes32 slot)
448     internal
449     pure
450     returns (Bytes32Slot storage r)
451   {
452     assembly {
453       r.slot := slot
454     }
455   }
456 
457   /**
458    * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
459    */
460   function getUint256Slot(bytes32 slot)
461     internal
462     pure
463     returns (Uint256Slot storage r)
464   {
465     assembly {
466       r.slot := slot
467     }
468   }
469 }
470 
471 
472 // File contracts/oz/proxy/beacon/IBeacon.sol
473 
474 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
475 
476 pragma solidity ^0.8.0;
477 
478 /**
479  * @dev This is the interface that {BeaconProxy} expects of its beacon.
480  */
481 interface IBeacon {
482   /**
483    * @dev Must return an address that can be used as a delegate call target.
484    *
485    * {BeaconProxy} will check that this address is a contract.
486    */
487   function implementation() external view returns (address);
488 }
489 
490 
491 // File contracts/oz/proxy/ERC1967/ERC1967Upgrade.sol
492 
493 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
494 
495 pragma solidity ^0.8.2;
496 
497 
498 
499 
500 /**
501  * @dev This abstract contract provides getters and event emitting update functions for
502  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
503  *
504  * _Available since v4.1._
505  *
506  * @custom:oz-upgrades-unsafe-allow delegatecall
507  */
508 abstract contract ERC1967Upgrade {
509   // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
510   bytes32 private constant _ROLLBACK_SLOT =
511     0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
512 
513   /**
514    * @dev Storage slot with the address of the current implementation.
515    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
516    * validated in the constructor.
517    */
518   bytes32 internal constant _IMPLEMENTATION_SLOT =
519     0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
520 
521   /**
522    * @dev Emitted when the implementation is upgraded.
523    */
524   event Upgraded(address indexed implementation);
525 
526   /**
527    * @dev Returns the current implementation address.
528    */
529   function _getImplementation() internal view returns (address) {
530     return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
531   }
532 
533   /**
534    * @dev Stores a new address in the EIP1967 implementation slot.
535    */
536   function _setImplementation(address newImplementation) private {
537     require(
538       Address.isContract(newImplementation),
539       "ERC1967: new implementation is not a contract"
540     );
541     StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
542   }
543 
544   /**
545    * @dev Perform implementation upgrade
546    *
547    * Emits an {Upgraded} event.
548    */
549   function _upgradeTo(address newImplementation) internal {
550     _setImplementation(newImplementation);
551     emit Upgraded(newImplementation);
552   }
553 
554   /**
555    * @dev Perform implementation upgrade with additional setup call.
556    *
557    * Emits an {Upgraded} event.
558    */
559   function _upgradeToAndCall(
560     address newImplementation,
561     bytes memory data,
562     bool forceCall
563   ) internal {
564     _upgradeTo(newImplementation);
565     if (data.length > 0 || forceCall) {
566       Address.functionDelegateCall(newImplementation, data);
567     }
568   }
569 
570   /**
571    * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
572    *
573    * Emits an {Upgraded} event.
574    */
575   function _upgradeToAndCallUUPS(
576     address newImplementation,
577     bytes memory data,
578     bool forceCall
579   ) internal {
580     // Upgrades from old implementations will perform a rollback test. This test requires the new
581     // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
582     // this special case will break upgrade paths from old UUPS implementation to new ones.
583     if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
584       _setImplementation(newImplementation);
585     } else {
586       try IERC1822Proxiable(newImplementation).proxiableUUID() returns (
587         bytes32 slot
588       ) {
589         require(
590           slot == _IMPLEMENTATION_SLOT,
591           "ERC1967Upgrade: unsupported proxiableUUID"
592         );
593       } catch {
594         revert("ERC1967Upgrade: new implementation is not UUPS");
595       }
596       _upgradeToAndCall(newImplementation, data, forceCall);
597     }
598   }
599 
600   /**
601    * @dev Storage slot with the admin of the contract.
602    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
603    * validated in the constructor.
604    */
605   bytes32 internal constant _ADMIN_SLOT =
606     0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
607 
608   /**
609    * @dev Emitted when the admin account has changed.
610    */
611   event AdminChanged(address previousAdmin, address newAdmin);
612 
613   /**
614    * @dev Returns the current admin.
615    */
616   function _getAdmin() internal view returns (address) {
617     return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
618   }
619 
620   /**
621    * @dev Stores a new address in the EIP1967 admin slot.
622    */
623   function _setAdmin(address newAdmin) private {
624     require(newAdmin != address(0), "ERC1967: new admin is the zero address");
625     StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
626   }
627 
628   /**
629    * @dev Changes the admin of the proxy.
630    *
631    * Emits an {AdminChanged} event.
632    */
633   function _changeAdmin(address newAdmin) internal {
634     emit AdminChanged(_getAdmin(), newAdmin);
635     _setAdmin(newAdmin);
636   }
637 
638   /**
639    * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
640    * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
641    */
642   bytes32 internal constant _BEACON_SLOT =
643     0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
644 
645   /**
646    * @dev Emitted when the beacon is upgraded.
647    */
648   event BeaconUpgraded(address indexed beacon);
649 
650   /**
651    * @dev Returns the current beacon.
652    */
653   function _getBeacon() internal view returns (address) {
654     return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
655   }
656 
657   /**
658    * @dev Stores a new beacon in the EIP1967 beacon slot.
659    */
660   function _setBeacon(address newBeacon) private {
661     require(
662       Address.isContract(newBeacon),
663       "ERC1967: new beacon is not a contract"
664     );
665     require(
666       Address.isContract(IBeacon(newBeacon).implementation()),
667       "ERC1967: beacon implementation is not a contract"
668     );
669     StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
670   }
671 
672   /**
673    * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
674    * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
675    *
676    * Emits a {BeaconUpgraded} event.
677    */
678   function _upgradeBeaconToAndCall(
679     address newBeacon,
680     bytes memory data,
681     bool forceCall
682   ) internal {
683     _setBeacon(newBeacon);
684     emit BeaconUpgraded(newBeacon);
685     if (data.length > 0 || forceCall) {
686       Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
687     }
688   }
689 }
690 
691 
692 // File contracts/oz/proxy/beacon/BeaconProxy.sol
693 
694 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/BeaconProxy.sol)
695 
696 pragma solidity ^0.8.0;
697 
698 
699 
700 /**
701  * @dev This contract implements a proxy that gets the implementation address for each call from a {UpgradeableBeacon}.
702  *
703  * The beacon address is stored in storage slot `uint256(keccak256('eip1967.proxy.beacon')) - 1`, so that it doesn't
704  * conflict with the storage layout of the implementation behind the proxy.
705  *
706  * _Available since v3.4._
707  */
708 contract BeaconProxy is Proxy, ERC1967Upgrade {
709   /**
710    * @dev Initializes the proxy with `beacon`.
711    *
712    * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon. This
713    * will typically be an encoded function call, and allows initializating the storage of the proxy like a Solidity
714    * constructor.
715    *
716    * Requirements:
717    *
718    * - `beacon` must be a contract with the interface {IBeacon}.
719    */
720   constructor(address beacon, bytes memory data) payable {
721     assert(
722       _BEACON_SLOT == bytes32(uint256(keccak256("eip1967.proxy.beacon")) - 1)
723     );
724     _upgradeBeaconToAndCall(beacon, data, false);
725   }
726 
727   /**
728    * @dev Returns the current beacon address.
729    */
730   function _beacon() internal view virtual returns (address) {
731     return _getBeacon();
732   }
733 
734   /**
735    * @dev Returns the current implementation address of the associated beacon.
736    */
737   function _implementation() internal view virtual override returns (address) {
738     return IBeacon(_getBeacon()).implementation();
739   }
740 
741   /**
742    * @dev Changes the proxy to use a new beacon. Deprecated: see {_upgradeBeaconToAndCall}.
743    *
744    * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon.
745    *
746    * Requirements:
747    *
748    * - `beacon` must be a contract.
749    * - The implementation returned by `beacon` must be a contract.
750    */
751   function _setBeacon(address beacon, bytes memory data) internal virtual {
752     _upgradeBeaconToAndCall(beacon, data, false);
753   }
754 }