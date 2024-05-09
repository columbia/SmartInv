1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-15
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         assembly {
37             size := extcodesize(account)
38         }
39         return size > 0;
40     }
41 
42     /**
43      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
44      * `recipient`, forwarding all available gas and reverting on errors.
45      *
46      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
47      * of certain opcodes, possibly making contracts go over the 2300 gas limit
48      * imposed by `transfer`, making them unable to receive funds via
49      * `transfer`. {sendValue} removes this limitation.
50      *
51      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
52      *
53      * IMPORTANT: because control is transferred to `recipient`, care must be
54      * taken to not create reentrancy vulnerabilities. Consider using
55      * {ReentrancyGuard} or the
56      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
57      */
58     function sendValue(address payable recipient, uint256 amount) internal {
59         require(address(this).balance >= amount, "Address: insufficient balance");
60 
61         (bool success, ) = recipient.call{value: amount}("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain `call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84         return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(
94         address target,
95         bytes memory data,
96         string memory errorMessage
97     ) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, 0, errorMessage);
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
103      * but also transferring `value` wei to `target`.
104      *
105      * Requirements:
106      *
107      * - the calling contract must have an ETH balance of at least `value`.
108      * - the called Solidity function must be `payable`.
109      *
110      * _Available since v3.1._
111      */
112     function functionCallWithValue(
113         address target,
114         bytes memory data,
115         uint256 value
116     ) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
118     }
119 
120     /**
121      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
122      * with `errorMessage` as a fallback revert reason when `target` reverts.
123      *
124      * _Available since v3.1._
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
136         return _verifyCallResult(success, returndata, errorMessage);
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
141      * but performing a static call.
142      *
143      * _Available since v3.3._
144      */
145     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
146         return functionStaticCall(target, data, "Address: low-level static call failed");
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
151      * but performing a static call.
152      *
153      * _Available since v3.3._
154      */
155     function functionStaticCall(
156         address target,
157         bytes memory data,
158         string memory errorMessage
159     ) internal view returns (bytes memory) {
160         require(isContract(target), "Address: static call to non-contract");
161 
162         (bool success, bytes memory returndata) = target.staticcall(data);
163         return _verifyCallResult(success, returndata, errorMessage);
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
168      * but performing a delegate call.
169      *
170      * _Available since v3.4._
171      */
172     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
178      * but performing a delegate call.
179      *
180      * _Available since v3.4._
181      */
182     function functionDelegateCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(isContract(target), "Address: delegate call to non-contract");
188 
189         (bool success, bytes memory returndata) = target.delegatecall(data);
190         return _verifyCallResult(success, returndata, errorMessage);
191     }
192 
193     function _verifyCallResult(
194         bool success,
195         bytes memory returndata,
196         string memory errorMessage
197     ) private pure returns (bytes memory) {
198         if (success) {
199             return returndata;
200         } else {
201             // Look for revert reason and bubble it up if present
202             if (returndata.length > 0) {
203                 // The easiest way to bubble the revert reason is using memory via assembly
204 
205                 assembly {
206                     let returndata_size := mload(returndata)
207                     revert(add(32, returndata), returndata_size)
208                 }
209             } else {
210                 revert(errorMessage);
211             }
212         }
213     }
214 }
215 
216 /**
217  * @dev Library for reading and writing primitive types to specific storage slots.
218  *
219  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
220  * This library helps with reading and writing to such slots without the need for inline assembly.
221  *
222  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
223  *
224  * Example usage to set ERC1967 implementation slot:
225  * ```
226  * contract ERC1967 {
227  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
228  *
229  *     function _getImplementation() internal view returns (address) {
230  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
231  *     }
232  *
233  *     function _setImplementation(address newImplementation) internal {
234  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
235  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
236  *     }
237  * }
238  * ```
239  *
240  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
241  */
242 library StorageSlot {
243     struct AddressSlot {
244         address value;
245     }
246 
247     struct BooleanSlot {
248         bool value;
249     }
250 
251     struct Bytes32Slot {
252         bytes32 value;
253     }
254 
255     struct Uint256Slot {
256         uint256 value;
257     }
258 
259     /**
260      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
261      */
262     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
263         assembly {
264             r.slot := slot
265         }
266     }
267 
268     /**
269      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
270      */
271     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
272         assembly {
273             r.slot := slot
274         }
275     }
276 
277     /**
278      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
279      */
280     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
281         assembly {
282             r.slot := slot
283         }
284     }
285 
286     /**
287      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
288      */
289     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
290         assembly {
291             r.slot := slot
292         }
293     }
294 }
295 
296 /**
297  * @dev https://eips.ethereum.org/EIPS/eip-1167[EIP 1167] is a standard for
298  * deploying minimal proxy contracts, also known as "clones".
299  *
300  * > To simply and cheaply clone contract functionality in an immutable way, this standard specifies
301  * > a minimal bytecode implementation that delegates all calls to a known, fixed address.
302  *
303  * The library includes functions to deploy a proxy using either `create` (traditional deployment) or `create2`
304  * (salted deterministic deployment). It also includes functions to predict the addresses of clones deployed using the
305  * deterministic method.
306  *
307  * _Available since v3.4._
308  */
309 library Clones {
310     /**
311      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
312      *
313      * This function uses the create opcode, which should never revert.
314      */
315     function clone(address implementation) internal returns (address instance) {
316         assembly {
317             let ptr := mload(0x40)
318             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
319             mstore(add(ptr, 0x14), shl(0x60, implementation))
320             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
321             instance := create(0, ptr, 0x37)
322         }
323         require(instance != address(0), "ERC1167: create failed");
324     }
325 
326     /**
327      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
328      *
329      * This function uses the create2 opcode and a `salt` to deterministically deploy
330      * the clone. Using the same `implementation` and `salt` multiple time will revert, since
331      * the clones cannot be deployed twice at the same address.
332      */
333     function cloneDeterministic(address implementation, bytes32 salt) internal returns (address instance) {
334         assembly {
335             let ptr := mload(0x40)
336             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
337             mstore(add(ptr, 0x14), shl(0x60, implementation))
338             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
339             instance := create2(0, ptr, 0x37, salt)
340         }
341         require(instance != address(0), "ERC1167: create2 failed");
342     }
343 
344     /**
345      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
346      */
347     function predictDeterministicAddress(
348         address implementation,
349         bytes32 salt,
350         address deployer
351     ) internal pure returns (address predicted) {
352         assembly {
353             let ptr := mload(0x40)
354             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
355             mstore(add(ptr, 0x14), shl(0x60, implementation))
356             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
357             mstore(add(ptr, 0x38), shl(0x60, deployer))
358             mstore(add(ptr, 0x4c), salt)
359             mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
360             predicted := keccak256(add(ptr, 0x37), 0x55)
361         }
362     }
363 
364     /**
365      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
366      */
367     function predictDeterministicAddress(address implementation, bytes32 salt)
368         internal
369         view
370         returns (address predicted)
371     {
372         return predictDeterministicAddress(implementation, salt, address(this));
373     }
374 }
375 
376 /**
377  * @dev This is the interface that {BeaconProxy} expects of its beacon.
378  */
379 interface IBeacon {
380     /**
381      * @dev Must return an address that can be used as a delegate call target.
382      *
383      * {BeaconProxy} will check that this address is a contract.
384      */
385     function implementation() external view returns (address);
386 }
387 
388 /**
389  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
390  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
391  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
392  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
393  *
394  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
395  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
396  *
397  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
398  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
399  */
400 abstract contract Initializable {
401     /**
402      * @dev Indicates that the contract has been initialized.
403      */
404     bool private _initialized;
405 
406     /**
407      * @dev Indicates that the contract is in the process of being initialized.
408      */
409     bool private _initializing;
410 
411     /**
412      * @dev Modifier to protect an initializer function from being invoked twice.
413      */
414     modifier initializer() {
415         require(_initializing || !_initialized, "Initializable: contract is already initialized");
416 
417         bool isTopLevelCall = !_initializing;
418         if (isTopLevelCall) {
419             _initializing = true;
420             _initialized = true;
421         }
422 
423         _;
424 
425         if (isTopLevelCall) {
426             _initializing = false;
427         }
428     }
429 }
430 
431 /*
432  * @dev Provides information about the current execution context, including the
433  * sender of the transaction and its data. While these are generally available
434  * via msg.sender and msg.data, they should not be accessed in such a direct
435  * manner, since when dealing with meta-transactions the account sending and
436  * paying for execution may not be the actual sender (as far as an application
437  * is concerned).
438  *
439  * This contract is only required for intermediate, library-like contracts.
440  */
441 abstract contract Context {
442     function _msgSender() internal view virtual returns (address) {
443         return msg.sender;
444     }
445 
446     function _msgData() internal view virtual returns (bytes calldata) {
447         return msg.data;
448     }
449 }
450 
451 /**
452  * @dev Contract module which provides a basic access control mechanism, where
453  * there is an account (an owner) that can be granted exclusive access to
454  * specific functions.
455  *
456  * By default, the owner account will be the one that deploys the contract. This
457  * can later be changed with {transferOwnership}.
458  *
459  * This module is used through inheritance. It will make available the modifier
460  * `onlyOwner`, which can be applied to your functions to restrict their use to
461  * the owner.
462  */
463 abstract contract Ownable is Context {
464     address private _owner;
465 
466     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
467 
468     /**
469      * @dev Initializes the contract setting the deployer as the initial owner.
470      */
471     constructor() {
472         _setOwner(_msgSender());
473     }
474 
475     /**
476      * @dev Returns the address of the current owner.
477      */
478     function owner() public view virtual returns (address) {
479         return _owner;
480     }
481 
482     /**
483      * @dev Throws if called by any account other than the owner.
484      */
485     modifier onlyOwner() {
486         require(owner() == _msgSender(), "Ownable: caller is not the owner");
487         _;
488     }
489 
490     /**
491      * @dev Leaves the contract without owner. It will not be possible to call
492      * `onlyOwner` functions anymore. Can only be called by the current owner.
493      *
494      * NOTE: Renouncing ownership will leave the contract without an owner,
495      * thereby removing any functionality that is only available to the owner.
496      */
497     function renounceOwnership() public virtual onlyOwner {
498         _setOwner(address(0));
499     }
500 
501     /**
502      * @dev Transfers ownership of the contract to a new account (`newOwner`).
503      * Can only be called by the current owner.
504      */
505     function transferOwnership(address newOwner) public virtual onlyOwner {
506         require(newOwner != address(0), "Ownable: new owner is the zero address");
507         _setOwner(newOwner);
508     }
509 
510     function _setOwner(address newOwner) private {
511         address oldOwner = _owner;
512         _owner = newOwner;
513         emit OwnershipTransferred(oldOwner, newOwner);
514     }
515 }
516 
517 /**
518  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
519  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
520  * be specified by overriding the virtual {_implementation} function.
521  *
522  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
523  * different contract through the {_delegate} function.
524  *
525  * The success and return data of the delegated call will be returned back to the caller of the proxy.
526  */
527 abstract contract Proxy {
528     /**
529      * @dev Delegates the current call to `implementation`.
530      *
531      * This function does not return to its internall call site, it will return directly to the external caller.
532      */
533     function _delegate(address implementation) internal virtual {
534         assembly {
535             // Copy msg.data. We take full control of memory in this inline assembly
536             // block because it will not return to Solidity code. We overwrite the
537             // Solidity scratch pad at memory position 0.
538             calldatacopy(0, 0, calldatasize())
539 
540             // Call the implementation.
541             // out and outsize are 0 because we don't know the size yet.
542             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
543 
544             // Copy the returned data.
545             returndatacopy(0, 0, returndatasize())
546 
547             switch result
548             // delegatecall returns 0 on error.
549             case 0 {
550                 revert(0, returndatasize())
551             }
552             default {
553                 return(0, returndatasize())
554             }
555         }
556     }
557 
558     /**
559      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
560      * and {_fallback} should delegate.
561      */
562     function _implementation() internal view virtual returns (address);
563 
564     /**
565      * @dev Delegates the current call to the address returned by `_implementation()`.
566      *
567      * This function does not return to its internall call site, it will return directly to the external caller.
568      */
569     function _fallback() internal virtual {
570         _beforeFallback();
571         _delegate(_implementation());
572     }
573 
574     /**
575      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
576      * function in the contract matches the call data.
577      */
578     fallback() external payable virtual {
579         _fallback();
580     }
581 
582     /**
583      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
584      * is empty.
585      */
586     receive() external payable virtual {
587         _fallback();
588     }
589 
590     /**
591      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
592      * call, or as part of the Solidity `fallback` or `receive` functions.
593      *
594      * If overriden should call `super._beforeFallback()`.
595      */
596     function _beforeFallback() internal virtual {}
597 }
598 
599 /**
600  * @dev This abstract contract provides getters and event emitting update functions for
601  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
602  *
603  * _Available since v4.1._
604  *
605  * @custom:oz-upgrades-unsafe-allow delegatecall
606  */
607 abstract contract ERC1967Upgrade {
608     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
609     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
610 
611     /**
612      * @dev Storage slot with the address of the current implementation.
613      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
614      * validated in the constructor.
615      */
616     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
617 
618     /**
619      * @dev Emitted when the implementation is upgraded.
620      */
621     event Upgraded(address indexed implementation);
622 
623     /**
624      * @dev Returns the current implementation address.
625      */
626     function _getImplementation() internal view returns (address) {
627         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
628     }
629 
630     /**
631      * @dev Stores a new address in the EIP1967 implementation slot.
632      */
633     function _setImplementation(address newImplementation) private {
634         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
635         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
636     }
637 
638     /**
639      * @dev Perform implementation upgrade
640      *
641      * Emits an {Upgraded} event.
642      */
643     function _upgradeTo(address newImplementation) internal {
644         _setImplementation(newImplementation);
645         emit Upgraded(newImplementation);
646     }
647 
648     /**
649      * @dev Perform implementation upgrade with additional setup call.
650      *
651      * Emits an {Upgraded} event.
652      */
653     function _upgradeToAndCall(
654         address newImplementation,
655         bytes memory data,
656         bool forceCall
657     ) internal {
658         _upgradeTo(newImplementation);
659         if (data.length > 0 || forceCall) {
660             Address.functionDelegateCall(newImplementation, data);
661         }
662     }
663 
664     /**
665      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
666      *
667      * Emits an {Upgraded} event.
668      */
669     function _upgradeToAndCallSecure(
670         address newImplementation,
671         bytes memory data,
672         bool forceCall
673     ) internal {
674         address oldImplementation = _getImplementation();
675 
676         // Initial upgrade and setup call
677         _setImplementation(newImplementation);
678         if (data.length > 0 || forceCall) {
679             Address.functionDelegateCall(newImplementation, data);
680         }
681 
682         // Perform rollback test if not already in progress
683         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
684         if (!rollbackTesting.value) {
685             // Trigger rollback using upgradeTo from the new implementation
686             rollbackTesting.value = true;
687             Address.functionDelegateCall(
688                 newImplementation,
689                 abi.encodeWithSignature("upgradeTo(address)", oldImplementation)
690             );
691             rollbackTesting.value = false;
692             // Check rollback was effective
693             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
694             // Finally reset to the new implementation and log the upgrade
695             _upgradeTo(newImplementation);
696         }
697     }
698 
699     /**
700      * @dev Storage slot with the admin of the contract.
701      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
702      * validated in the constructor.
703      */
704     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
705 
706     /**
707      * @dev Emitted when the admin account has changed.
708      */
709     event AdminChanged(address previousAdmin, address newAdmin);
710 
711     /**
712      * @dev Returns the current admin.
713      */
714     function _getAdmin() internal view returns (address) {
715         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
716     }
717 
718     /**
719      * @dev Stores a new address in the EIP1967 admin slot.
720      */
721     function _setAdmin(address newAdmin) private {
722         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
723         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
724     }
725 
726     /**
727      * @dev Changes the admin of the proxy.
728      *
729      * Emits an {AdminChanged} event.
730      */
731     function _changeAdmin(address newAdmin) internal {
732         emit AdminChanged(_getAdmin(), newAdmin);
733         _setAdmin(newAdmin);
734     }
735 
736     /**
737      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
738      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
739      */
740     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
741 
742     /**
743      * @dev Emitted when the beacon is upgraded.
744      */
745     event BeaconUpgraded(address indexed beacon);
746 
747     /**
748      * @dev Returns the current beacon.
749      */
750     function _getBeacon() internal view returns (address) {
751         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
752     }
753 
754     /**
755      * @dev Stores a new beacon in the EIP1967 beacon slot.
756      */
757     function _setBeacon(address newBeacon) private {
758         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
759         require(
760             Address.isContract(IBeacon(newBeacon).implementation()),
761             "ERC1967: beacon implementation is not a contract"
762         );
763         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
764     }
765 
766     /**
767      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
768      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
769      *
770      * Emits a {BeaconUpgraded} event.
771      */
772     function _upgradeBeaconToAndCall(
773         address newBeacon,
774         bytes memory data,
775         bool forceCall
776     ) internal {
777         _setBeacon(newBeacon);
778         emit BeaconUpgraded(newBeacon);
779         if (data.length > 0 || forceCall) {
780             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
781         }
782     }
783 }
784 
785 /**
786  * @title Telcoin, LLC.
787  * @dev Implements Openzeppelin Audited Contracts
788  *
789  * @notice This contract implements a proxy that gets the implementation address for each call from a {UpgradeableBeacon}.
790  *
791  * The beacon address is stored in storage slot `uint256(keccak256('eip1967.proxy.beacon')) - 1`, so that it doesn't
792  * conflict with the storage layout of the implementation behind the proxy.
793  *
794  * _Available since v3.4._
795  */
796 contract CloneableProxy is Proxy, ERC1967Upgrade, Initializable {
797     /**
798      * @dev Initializes the proxy with `beacon`.
799      *
800      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon. This
801      * will typically be an encoded function call, and allows initializating the storage of the proxy like a Solidity
802      * constructor.
803      *
804      * Requirements:
805      *
806      * - `beacon` must be a contract with the interface {IBeacon}.
807      */
808     function initialize(address beacon, bytes memory data) external payable initializer() {
809         assert(_BEACON_SLOT == bytes32(uint256(keccak256("eip1967.proxy.beacon")) - 1));
810         _upgradeBeaconToAndCall(beacon, data, false);
811     }
812 
813     /**
814      * @dev Returns the current beacon address.
815      */
816     function _beacon() internal view virtual returns (address) {
817         return _getBeacon();
818     }
819 
820     /**
821      * @dev Returns the current implementation address of the associated beacon.
822      */
823     function _implementation() internal view virtual override returns (address) {
824         return IBeacon(_getBeacon()).implementation();
825     }
826 
827     /**
828      * @dev Changes the proxy to use a new beacon. Deprecated: see {_upgradeBeaconToAndCall}.
829      *
830      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon.
831      *
832      * Requirements:
833      *
834      * - `beacon` must be a contract.
835      * - The implementation returned by `beacon` must be a contract.
836      */
837     function _setBeacon(address beacon, bytes memory data) internal virtual {
838         _upgradeBeaconToAndCall(beacon, data, false);
839     }
840 }
841 
842 /**
843  * @title Telcoin, LLC.
844  * @dev Implements Openzeppelin Audited Contracts
845  *
846  * @notice Contract is designed to make duplicates of a proxy contract
847  *
848  * By default, the owner account will be the one that deploys the contract. This
849  * can later be changed with {transferOwnership}.
850  *
851  * This module is used through inheritance. It will make available the modifier
852  * `onlyOwner`, which can be applied to your functions to restrict their use to
853  * the owner.
854  */
855 contract CloneFactory is Ownable {
856   //event emits new contract address
857   event Deployed(address indexed proxyAddress) anonymous;
858   //immutable template for cloning
859   address public immutable proxyImplementation;
860 
861   /**
862    * @notice The creating address becomes the owner
863    * @dev Creates the base clonable template
864    */
865   constructor() Ownable() {
866     proxyImplementation = address(new CloneableProxy());
867   }
868 
869   /**
870    * @notice Clones an existing proxy and initializes the contract
871    * @param beacon is the address of the beacon to the logic contract
872    * @param data is the initialization data of the logic contract
873    * Can only be called by the current owner.
874    *
875    * Emits a {Deployed} event.
876    */
877   function createProxy(address beacon, bytes memory data) external onlyOwner() {
878     address payable clone = payable(Clones.clone(proxyImplementation));
879     CloneableProxy(clone).initialize(beacon, data);
880     emit Deployed(clone);
881   }
882 }