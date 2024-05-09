1 /*
2  * @title ERC1967Proxy for Origin Dollar Governance token (OGV)
3  * @author Origin Protocol Labs
4  *
5  * Origin Protocol
6  * https://originprotocol.com
7  * https://ousd.com
8  *
9  * Released under the MIT license
10  * https://github.com/OriginProtocol/origin-dollar
11  * https://github.com/OriginProtocol/ousd-governance
12  *
13  * Copyright 2022 Origin Protocol Labs
14  *
15  * Permission is hereby granted, free of charge, to any person obtaining a copy
16  * of this software and associated documentation files (the "Software"), to deal
17  * in the Software without restriction, including without limitation the rights
18  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
19  * copies of the Software, and to permit persons to whom the Software is
20  * furnished to do so, subject to the following conditions:
21  *
22  * The above copyright notice and this permission notice shall be included in
23  * all copies or substantial portions of the Software.
24  *
25  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
26  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
27  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
28  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
29  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
30  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
31  * SOFTWARE.
32  */
33  
34 // SPDX-License-Identifier: MIT
35 // OpenZeppelin Contracts v4.4.1 (proxy/ERC1967/ERC1967Proxy.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/Proxy.sol)
40 
41 /**
42  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
43  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
44  * be specified by overriding the virtual {_implementation} function.
45  *
46  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
47  * different contract through the {_delegate} function.
48  *
49  * The success and return data of the delegated call will be returned back to the caller of the proxy.
50  */
51 abstract contract Proxy {
52     /**
53      * @dev Delegates the current call to `implementation`.
54      *
55      * This function does not return to its internal call site, it will return directly to the external caller.
56      */
57     function _delegate(address implementation) internal virtual {
58         assembly {
59             // Copy msg.data. We take full control of memory in this inline assembly
60             // block because it will not return to Solidity code. We overwrite the
61             // Solidity scratch pad at memory position 0.
62             calldatacopy(0, 0, calldatasize())
63 
64             // Call the implementation.
65             // out and outsize are 0 because we don't know the size yet.
66             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
67 
68             // Copy the returned data.
69             returndatacopy(0, 0, returndatasize())
70 
71             switch result
72             // delegatecall returns 0 on error.
73             case 0 {
74                 revert(0, returndatasize())
75             }
76             default {
77                 return(0, returndatasize())
78             }
79         }
80     }
81 
82     /**
83      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
84      * and {_fallback} should delegate.
85      */
86     function _implementation() internal view virtual returns (address);
87 
88     /**
89      * @dev Delegates the current call to the address returned by `_implementation()`.
90      *
91      * This function does not return to its internal call site, it will return directly to the external caller.
92      */
93     function _fallback() internal virtual {
94         _beforeFallback();
95         _delegate(_implementation());
96     }
97 
98     /**
99      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
100      * function in the contract matches the call data.
101      */
102     fallback() external payable virtual {
103         _fallback();
104     }
105 
106     /**
107      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
108      * is empty.
109      */
110     receive() external payable virtual {
111         _fallback();
112     }
113 
114     /**
115      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
116      * call, or as part of the Solidity `fallback` or `receive` functions.
117      *
118      * If overridden should call `super._beforeFallback()`.
119      */
120     function _beforeFallback() internal virtual {}
121 }
122 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
123 
124 
125 
126 // OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)
127 
128 
129 
130 /**
131  * @dev This is the interface that {BeaconProxy} expects of its beacon.
132  */
133 interface IBeacon {
134     /**
135      * @dev Must return an address that can be used as a delegate call target.
136      *
137      * {BeaconProxy} will check that this address is a contract.
138      */
139     function implementation() external view returns (address);
140 }
141 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)
142 
143 
144 
145 /**
146  * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
147  * proxy whose upgrades are fully controlled by the current implementation.
148  */
149 interface IERC1822Proxiable {
150     /**
151      * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
152      * address.
153      *
154      * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
155      * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
156      * function revert if invoked through a proxy.
157      */
158     function proxiableUUID() external view returns (bytes32);
159 }
160 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
161 
162 
163 
164 /**
165  * @dev Collection of functions related to the address type
166  */
167 library Address {
168     /**
169      * @dev Returns true if `account` is a contract.
170      *
171      * [IMPORTANT]
172      * ====
173      * It is unsafe to assume that an address for which this function returns
174      * false is an externally-owned account (EOA) and not a contract.
175      *
176      * Among others, `isContract` will return false for the following
177      * types of addresses:
178      *
179      *  - an externally-owned account
180      *  - a contract in construction
181      *  - an address where a contract will be created
182      *  - an address where a contract lived, but was destroyed
183      * ====
184      *
185      * [IMPORTANT]
186      * ====
187      * You shouldn't rely on `isContract` to protect against flash loan attacks!
188      *
189      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
190      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
191      * constructor.
192      * ====
193      */
194     function isContract(address account) internal view returns (bool) {
195         // This method relies on extcodesize/address.code.length, which returns 0
196         // for contracts in construction, since the code is only stored at the end
197         // of the constructor execution.
198 
199         return account.code.length > 0;
200     }
201 
202     /**
203      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
204      * `recipient`, forwarding all available gas and reverting on errors.
205      *
206      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
207      * of certain opcodes, possibly making contracts go over the 2300 gas limit
208      * imposed by `transfer`, making them unable to receive funds via
209      * `transfer`. {sendValue} removes this limitation.
210      *
211      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
212      *
213      * IMPORTANT: because control is transferred to `recipient`, care must be
214      * taken to not create reentrancy vulnerabilities. Consider using
215      * {ReentrancyGuard} or the
216      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
217      */
218     function sendValue(address payable recipient, uint256 amount) internal {
219         require(address(this).balance >= amount, "Address: insufficient balance");
220 
221         (bool success, ) = recipient.call{value: amount}("");
222         require(success, "Address: unable to send value, recipient may have reverted");
223     }
224 
225     /**
226      * @dev Performs a Solidity function call using a low level `call`. A
227      * plain `call` is an unsafe replacement for a function call: use this
228      * function instead.
229      *
230      * If `target` reverts with a revert reason, it is bubbled up by this
231      * function (like regular Solidity function calls).
232      *
233      * Returns the raw returned data. To convert to the expected return value,
234      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
235      *
236      * Requirements:
237      *
238      * - `target` must be a contract.
239      * - calling `target` with `data` must not revert.
240      *
241      * _Available since v3.1._
242      */
243     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
244         return functionCall(target, data, "Address: low-level call failed");
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
249      * `errorMessage` as a fallback revert reason when `target` reverts.
250      *
251      * _Available since v3.1._
252      */
253     function functionCall(
254         address target,
255         bytes memory data,
256         string memory errorMessage
257     ) internal returns (bytes memory) {
258         return functionCallWithValue(target, data, 0, errorMessage);
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
263      * but also transferring `value` wei to `target`.
264      *
265      * Requirements:
266      *
267      * - the calling contract must have an ETH balance of at least `value`.
268      * - the called Solidity function must be `payable`.
269      *
270      * _Available since v3.1._
271      */
272     function functionCallWithValue(
273         address target,
274         bytes memory data,
275         uint256 value
276     ) internal returns (bytes memory) {
277         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
282      * with `errorMessage` as a fallback revert reason when `target` reverts.
283      *
284      * _Available since v3.1._
285      */
286     function functionCallWithValue(
287         address target,
288         bytes memory data,
289         uint256 value,
290         string memory errorMessage
291     ) internal returns (bytes memory) {
292         require(address(this).balance >= value, "Address: insufficient balance for call");
293         require(isContract(target), "Address: call to non-contract");
294 
295         (bool success, bytes memory returndata) = target.call{value: value}(data);
296         return verifyCallResult(success, returndata, errorMessage);
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
301      * but performing a static call.
302      *
303      * _Available since v3.3._
304      */
305     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
306         return functionStaticCall(target, data, "Address: low-level static call failed");
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
311      * but performing a static call.
312      *
313      * _Available since v3.3._
314      */
315     function functionStaticCall(
316         address target,
317         bytes memory data,
318         string memory errorMessage
319     ) internal view returns (bytes memory) {
320         require(isContract(target), "Address: static call to non-contract");
321 
322         (bool success, bytes memory returndata) = target.staticcall(data);
323         return verifyCallResult(success, returndata, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but performing a delegate call.
329      *
330      * _Available since v3.4._
331      */
332     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
333         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
338      * but performing a delegate call.
339      *
340      * _Available since v3.4._
341      */
342     function functionDelegateCall(
343         address target,
344         bytes memory data,
345         string memory errorMessage
346     ) internal returns (bytes memory) {
347         require(isContract(target), "Address: delegate call to non-contract");
348 
349         (bool success, bytes memory returndata) = target.delegatecall(data);
350         return verifyCallResult(success, returndata, errorMessage);
351     }
352 
353     /**
354      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
355      * revert reason using the provided one.
356      *
357      * _Available since v4.3._
358      */
359     function verifyCallResult(
360         bool success,
361         bytes memory returndata,
362         string memory errorMessage
363     ) internal pure returns (bytes memory) {
364         if (success) {
365             return returndata;
366         } else {
367             // Look for revert reason and bubble it up if present
368             if (returndata.length > 0) {
369                 // The easiest way to bubble the revert reason is using memory via assembly
370 
371                 assembly {
372                     let returndata_size := mload(returndata)
373                     revert(add(32, returndata), returndata_size)
374                 }
375             } else {
376                 revert(errorMessage);
377             }
378         }
379     }
380 }
381 // OpenZeppelin Contracts v4.4.1 (utils/StorageSlot.sol)
382 
383 
384 
385 /**
386  * @dev Library for reading and writing primitive types to specific storage slots.
387  *
388  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
389  * This library helps with reading and writing to such slots without the need for inline assembly.
390  *
391  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
392  *
393  * Example usage to set ERC1967 implementation slot:
394  * ```
395  * contract ERC1967 {
396  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
397  *
398  *     function _getImplementation() internal view returns (address) {
399  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
400  *     }
401  *
402  *     function _setImplementation(address newImplementation) internal {
403  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
404  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
405  *     }
406  * }
407  * ```
408  *
409  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
410  */
411 library StorageSlot {
412     struct AddressSlot {
413         address value;
414     }
415 
416     struct BooleanSlot {
417         bool value;
418     }
419 
420     struct Bytes32Slot {
421         bytes32 value;
422     }
423 
424     struct Uint256Slot {
425         uint256 value;
426     }
427 
428     /**
429      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
430      */
431     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
432         assembly {
433             r.slot := slot
434         }
435     }
436 
437     /**
438      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
439      */
440     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
441         assembly {
442             r.slot := slot
443         }
444     }
445 
446     /**
447      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
448      */
449     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
450         assembly {
451             r.slot := slot
452         }
453     }
454 
455     /**
456      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
457      */
458     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
459         assembly {
460             r.slot := slot
461         }
462     }
463 }
464 
465 /**
466  * @dev This abstract contract provides getters and event emitting update functions for
467  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
468  *
469  * _Available since v4.1._
470  *
471  * @custom:oz-upgrades-unsafe-allow delegatecall
472  */
473 abstract contract ERC1967Upgrade {
474     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
475     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
476 
477     /**
478      * @dev Storage slot with the address of the current implementation.
479      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
480      * validated in the constructor.
481      */
482     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
483 
484     /**
485      * @dev Emitted when the implementation is upgraded.
486      */
487     event Upgraded(address indexed implementation);
488 
489     /**
490      * @dev Returns the current implementation address.
491      */
492     function _getImplementation() internal view returns (address) {
493         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
494     }
495 
496     /**
497      * @dev Stores a new address in the EIP1967 implementation slot.
498      */
499     function _setImplementation(address newImplementation) private {
500         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
501         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
502     }
503 
504     /**
505      * @dev Perform implementation upgrade
506      *
507      * Emits an {Upgraded} event.
508      */
509     function _upgradeTo(address newImplementation) internal {
510         _setImplementation(newImplementation);
511         emit Upgraded(newImplementation);
512     }
513 
514     /**
515      * @dev Perform implementation upgrade with additional setup call.
516      *
517      * Emits an {Upgraded} event.
518      */
519     function _upgradeToAndCall(
520         address newImplementation,
521         bytes memory data,
522         bool forceCall
523     ) internal {
524         _upgradeTo(newImplementation);
525         if (data.length > 0 || forceCall) {
526             Address.functionDelegateCall(newImplementation, data);
527         }
528     }
529 
530     /**
531      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
532      *
533      * Emits an {Upgraded} event.
534      */
535     function _upgradeToAndCallUUPS(
536         address newImplementation,
537         bytes memory data,
538         bool forceCall
539     ) internal {
540         // Upgrades from old implementations will perform a rollback test. This test requires the new
541         // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
542         // this special case will break upgrade paths from old UUPS implementation to new ones.
543         if (StorageSlot.getBooleanSlot(_ROLLBACK_SLOT).value) {
544             _setImplementation(newImplementation);
545         } else {
546             try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
547                 require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
548             } catch {
549                 revert("ERC1967Upgrade: new implementation is not UUPS");
550             }
551             _upgradeToAndCall(newImplementation, data, forceCall);
552         }
553     }
554 
555     /**
556      * @dev Storage slot with the admin of the contract.
557      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
558      * validated in the constructor.
559      */
560     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
561 
562     /**
563      * @dev Emitted when the admin account has changed.
564      */
565     event AdminChanged(address previousAdmin, address newAdmin);
566 
567     /**
568      * @dev Returns the current admin.
569      */
570     function _getAdmin() internal view returns (address) {
571         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
572     }
573 
574     /**
575      * @dev Stores a new address in the EIP1967 admin slot.
576      */
577     function _setAdmin(address newAdmin) private {
578         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
579         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
580     }
581 
582     /**
583      * @dev Changes the admin of the proxy.
584      *
585      * Emits an {AdminChanged} event.
586      */
587     function _changeAdmin(address newAdmin) internal {
588         emit AdminChanged(_getAdmin(), newAdmin);
589         _setAdmin(newAdmin);
590     }
591 
592     /**
593      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
594      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
595      */
596     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
597 
598     /**
599      * @dev Emitted when the beacon is upgraded.
600      */
601     event BeaconUpgraded(address indexed beacon);
602 
603     /**
604      * @dev Returns the current beacon.
605      */
606     function _getBeacon() internal view returns (address) {
607         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
608     }
609 
610     /**
611      * @dev Stores a new beacon in the EIP1967 beacon slot.
612      */
613     function _setBeacon(address newBeacon) private {
614         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
615         require(
616             Address.isContract(IBeacon(newBeacon).implementation()),
617             "ERC1967: beacon implementation is not a contract"
618         );
619         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
620     }
621 
622     /**
623      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
624      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
625      *
626      * Emits a {BeaconUpgraded} event.
627      */
628     function _upgradeBeaconToAndCall(
629         address newBeacon,
630         bytes memory data,
631         bool forceCall
632     ) internal {
633         _setBeacon(newBeacon);
634         emit BeaconUpgraded(newBeacon);
635         if (data.length > 0 || forceCall) {
636             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
637         }
638     }
639 }
640 
641 /**
642  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
643  * implementation address that can be changed. This address is stored in storage in the location specified by
644  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
645  * implementation behind the proxy.
646  */
647 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
648     /**
649      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
650      *
651      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
652      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
653      */
654     constructor(address _logic, bytes memory _data) payable {
655         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
656         _upgradeToAndCall(_logic, _data, false);
657     }
658 
659     /**
660      * @dev Returns the current implementation address.
661      */
662     function _implementation() internal view virtual override returns (address impl) {
663         return ERC1967Upgrade._getImplementation();
664     }
665 }