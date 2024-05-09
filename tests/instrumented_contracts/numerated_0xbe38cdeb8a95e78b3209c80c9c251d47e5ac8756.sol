1 /**
2  *Submitted for verification at polygonscan.com on 2021-09-28
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-09-15
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Collection of functions related to the address type
15  */
16 library Address {
17     /**
18      * @dev Returns true if `account` is a contract.
19      *
20      * [IMPORTANT]
21      * ====
22      * It is unsafe to assume that an address for which this function returns
23      * false is an externally-owned account (EOA) and not a contract.
24      *
25      * Among others, `isContract` will return false for the following
26      * types of addresses:
27      *
28      *  - an externally-owned account
29      *  - a contract in construction
30      *  - an address where a contract will be created
31      *  - an address where a contract lived, but was destroyed
32      * ====
33      */
34     function isContract(address account) internal view returns (bool) {
35         // This method relies on extcodesize, which returns 0 for contracts in
36         // construction, since the code is only stored at the end of the
37         // constructor execution.
38 
39         uint256 size;
40         assembly {
41             size := extcodesize(account)
42         }
43         return size > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return _verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return _verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return _verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     function _verifyCallResult(
198         bool success,
199         bytes memory returndata,
200         string memory errorMessage
201     ) private pure returns (bytes memory) {
202         if (success) {
203             return returndata;
204         } else {
205             // Look for revert reason and bubble it up if present
206             if (returndata.length > 0) {
207                 // The easiest way to bubble the revert reason is using memory via assembly
208 
209                 assembly {
210                     let returndata_size := mload(returndata)
211                     revert(add(32, returndata), returndata_size)
212                 }
213             } else {
214                 revert(errorMessage);
215             }
216         }
217     }
218 }
219 
220 /**
221  * @dev Library for reading and writing primitive types to specific storage slots.
222  *
223  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
224  * This library helps with reading and writing to such slots without the need for inline assembly.
225  *
226  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
227  *
228  * Example usage to set ERC1967 implementation slot:
229  * ```
230  * contract ERC1967 {
231  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
232  *
233  *     function _getImplementation() internal view returns (address) {
234  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
235  *     }
236  *
237  *     function _setImplementation(address newImplementation) internal {
238  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
239  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
240  *     }
241  * }
242  * ```
243  *
244  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
245  */
246 library StorageSlot {
247     struct AddressSlot {
248         address value;
249     }
250 
251     struct BooleanSlot {
252         bool value;
253     }
254 
255     struct Bytes32Slot {
256         bytes32 value;
257     }
258 
259     struct Uint256Slot {
260         uint256 value;
261     }
262 
263     /**
264      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
265      */
266     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
267         assembly {
268             r.slot := slot
269         }
270     }
271 
272     /**
273      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
274      */
275     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
276         assembly {
277             r.slot := slot
278         }
279     }
280 
281     /**
282      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
283      */
284     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
285         assembly {
286             r.slot := slot
287         }
288     }
289 
290     /**
291      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
292      */
293     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
294         assembly {
295             r.slot := slot
296         }
297     }
298 }
299 
300 /**
301  * @dev https://eips.ethereum.org/EIPS/eip-1167[EIP 1167] is a standard for
302  * deploying minimal proxy contracts, also known as "clones".
303  *
304  * > To simply and cheaply clone contract functionality in an immutable way, this standard specifies
305  * > a minimal bytecode implementation that delegates all calls to a known, fixed address.
306  *
307  * The library includes functions to deploy a proxy using either `create` (traditional deployment) or `create2`
308  * (salted deterministic deployment). It also includes functions to predict the addresses of clones deployed using the
309  * deterministic method.
310  *
311  * _Available since v3.4._
312  */
313 library Clones {
314     /**
315      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
316      *
317      * This function uses the create opcode, which should never revert.
318      */
319     function clone(address implementation) internal returns (address instance) {
320         assembly {
321             let ptr := mload(0x40)
322             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
323             mstore(add(ptr, 0x14), shl(0x60, implementation))
324             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
325             instance := create(0, ptr, 0x37)
326         }
327         require(instance != address(0), "ERC1167: create failed");
328     }
329 
330     /**
331      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
332      *
333      * This function uses the create2 opcode and a `salt` to deterministically deploy
334      * the clone. Using the same `implementation` and `salt` multiple time will revert, since
335      * the clones cannot be deployed twice at the same address.
336      */
337     function cloneDeterministic(address implementation, bytes32 salt) internal returns (address instance) {
338         assembly {
339             let ptr := mload(0x40)
340             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
341             mstore(add(ptr, 0x14), shl(0x60, implementation))
342             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
343             instance := create2(0, ptr, 0x37, salt)
344         }
345         require(instance != address(0), "ERC1167: create2 failed");
346     }
347 
348     /**
349      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
350      */
351     function predictDeterministicAddress(
352         address implementation,
353         bytes32 salt,
354         address deployer
355     ) internal pure returns (address predicted) {
356         assembly {
357             let ptr := mload(0x40)
358             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
359             mstore(add(ptr, 0x14), shl(0x60, implementation))
360             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
361             mstore(add(ptr, 0x38), shl(0x60, deployer))
362             mstore(add(ptr, 0x4c), salt)
363             mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
364             predicted := keccak256(add(ptr, 0x37), 0x55)
365         }
366     }
367 
368     /**
369      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
370      */
371     function predictDeterministicAddress(address implementation, bytes32 salt)
372         internal
373         view
374         returns (address predicted)
375     {
376         return predictDeterministicAddress(implementation, salt, address(this));
377     }
378 }
379 
380 /**
381  * @dev This is the interface that {BeaconProxy} expects of its beacon.
382  */
383 interface IBeacon {
384     /**
385      * @dev Must return an address that can be used as a delegate call target.
386      *
387      * {BeaconProxy} will check that this address is a contract.
388      */
389     function implementation() external view returns (address);
390 }
391 
392 /**
393  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
394  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
395  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
396  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
397  *
398  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
399  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
400  *
401  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
402  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
403  */
404 abstract contract Initializable {
405     /**
406      * @dev Indicates that the contract has been initialized.
407      */
408     bool private _initialized;
409 
410     /**
411      * @dev Indicates that the contract is in the process of being initialized.
412      */
413     bool private _initializing;
414 
415     /**
416      * @dev Modifier to protect an initializer function from being invoked twice.
417      */
418     modifier initializer() {
419         require(_initializing || !_initialized, "Initializable: contract is already initialized");
420 
421         bool isTopLevelCall = !_initializing;
422         if (isTopLevelCall) {
423             _initializing = true;
424             _initialized = true;
425         }
426 
427         _;
428 
429         if (isTopLevelCall) {
430             _initializing = false;
431         }
432     }
433 }
434 
435 /*
436  * @dev Provides information about the current execution context, including the
437  * sender of the transaction and its data. While these are generally available
438  * via msg.sender and msg.data, they should not be accessed in such a direct
439  * manner, since when dealing with meta-transactions the account sending and
440  * paying for execution may not be the actual sender (as far as an application
441  * is concerned).
442  *
443  * This contract is only required for intermediate, library-like contracts.
444  */
445 abstract contract Context {
446     function _msgSender() internal view virtual returns (address) {
447         return msg.sender;
448     }
449 
450     function _msgData() internal view virtual returns (bytes calldata) {
451         return msg.data;
452     }
453 }
454 
455 /**
456  * @dev Contract module which provides a basic access control mechanism, where
457  * there is an account (an owner) that can be granted exclusive access to
458  * specific functions.
459  *
460  * By default, the owner account will be the one that deploys the contract. This
461  * can later be changed with {transferOwnership}.
462  *
463  * This module is used through inheritance. It will make available the modifier
464  * `onlyOwner`, which can be applied to your functions to restrict their use to
465  * the owner.
466  */
467 abstract contract Ownable is Context {
468     address private _owner;
469 
470     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
471 
472     /**
473      * @dev Initializes the contract setting the deployer as the initial owner.
474      */
475     constructor() {
476         _setOwner(_msgSender());
477     }
478 
479     /**
480      * @dev Returns the address of the current owner.
481      */
482     function owner() public view virtual returns (address) {
483         return _owner;
484     }
485 
486     /**
487      * @dev Throws if called by any account other than the owner.
488      */
489     modifier onlyOwner() {
490         require(owner() == _msgSender(), "Ownable: caller is not the owner");
491         _;
492     }
493 
494     /**
495      * @dev Leaves the contract without owner. It will not be possible to call
496      * `onlyOwner` functions anymore. Can only be called by the current owner.
497      *
498      * NOTE: Renouncing ownership will leave the contract without an owner,
499      * thereby removing any functionality that is only available to the owner.
500      */
501     function renounceOwnership() public virtual onlyOwner {
502         _setOwner(address(0));
503     }
504 
505     /**
506      * @dev Transfers ownership of the contract to a new account (`newOwner`).
507      * Can only be called by the current owner.
508      */
509     function transferOwnership(address newOwner) public virtual onlyOwner {
510         require(newOwner != address(0), "Ownable: new owner is the zero address");
511         _setOwner(newOwner);
512     }
513 
514     function _setOwner(address newOwner) private {
515         address oldOwner = _owner;
516         _owner = newOwner;
517         emit OwnershipTransferred(oldOwner, newOwner);
518     }
519 }
520 
521 /**
522  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
523  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
524  * be specified by overriding the virtual {_implementation} function.
525  *
526  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
527  * different contract through the {_delegate} function.
528  *
529  * The success and return data of the delegated call will be returned back to the caller of the proxy.
530  */
531 abstract contract Proxy {
532     /**
533      * @dev Delegates the current call to `implementation`.
534      *
535      * This function does not return to its internall call site, it will return directly to the external caller.
536      */
537     function _delegate(address implementation) internal virtual {
538         assembly {
539             // Copy msg.data. We take full control of memory in this inline assembly
540             // block because it will not return to Solidity code. We overwrite the
541             // Solidity scratch pad at memory position 0.
542             calldatacopy(0, 0, calldatasize())
543 
544             // Call the implementation.
545             // out and outsize are 0 because we don't know the size yet.
546             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
547 
548             // Copy the returned data.
549             returndatacopy(0, 0, returndatasize())
550 
551             switch result
552             // delegatecall returns 0 on error.
553             case 0 {
554                 revert(0, returndatasize())
555             }
556             default {
557                 return(0, returndatasize())
558             }
559         }
560     }
561 
562     /**
563      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
564      * and {_fallback} should delegate.
565      */
566     function _implementation() internal view virtual returns (address);
567 
568     /**
569      * @dev Delegates the current call to the address returned by `_implementation()`.
570      *
571      * This function does not return to its internall call site, it will return directly to the external caller.
572      */
573     function _fallback() internal virtual {
574         _beforeFallback();
575         _delegate(_implementation());
576     }
577 
578     /**
579      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
580      * function in the contract matches the call data.
581      */
582     fallback() external payable virtual {
583         _fallback();
584     }
585 
586     /**
587      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
588      * is empty.
589      */
590     receive() external payable virtual {
591         _fallback();
592     }
593 
594     /**
595      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
596      * call, or as part of the Solidity `fallback` or `receive` functions.
597      *
598      * If overriden should call `super._beforeFallback()`.
599      */
600     function _beforeFallback() internal virtual {}
601 }
602 
603 /**
604  * @dev This abstract contract provides getters and event emitting update functions for
605  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
606  *
607  * _Available since v4.1._
608  *
609  * @custom:oz-upgrades-unsafe-allow delegatecall
610  */
611 abstract contract ERC1967Upgrade {
612     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
613     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
614 
615     /**
616      * @dev Storage slot with the address of the current implementation.
617      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
618      * validated in the constructor.
619      */
620     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
621 
622     /**
623      * @dev Emitted when the implementation is upgraded.
624      */
625     event Upgraded(address indexed implementation);
626 
627     /**
628      * @dev Returns the current implementation address.
629      */
630     function _getImplementation() internal view returns (address) {
631         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
632     }
633 
634     /**
635      * @dev Stores a new address in the EIP1967 implementation slot.
636      */
637     function _setImplementation(address newImplementation) private {
638         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
639         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
640     }
641 
642     /**
643      * @dev Perform implementation upgrade
644      *
645      * Emits an {Upgraded} event.
646      */
647     function _upgradeTo(address newImplementation) internal {
648         _setImplementation(newImplementation);
649         emit Upgraded(newImplementation);
650     }
651 
652     /**
653      * @dev Perform implementation upgrade with additional setup call.
654      *
655      * Emits an {Upgraded} event.
656      */
657     function _upgradeToAndCall(
658         address newImplementation,
659         bytes memory data,
660         bool forceCall
661     ) internal {
662         _upgradeTo(newImplementation);
663         if (data.length > 0 || forceCall) {
664             Address.functionDelegateCall(newImplementation, data);
665         }
666     }
667 
668     /**
669      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
670      *
671      * Emits an {Upgraded} event.
672      */
673     function _upgradeToAndCallSecure(
674         address newImplementation,
675         bytes memory data,
676         bool forceCall
677     ) internal {
678         address oldImplementation = _getImplementation();
679 
680         // Initial upgrade and setup call
681         _setImplementation(newImplementation);
682         if (data.length > 0 || forceCall) {
683             Address.functionDelegateCall(newImplementation, data);
684         }
685 
686         // Perform rollback test if not already in progress
687         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
688         if (!rollbackTesting.value) {
689             // Trigger rollback using upgradeTo from the new implementation
690             rollbackTesting.value = true;
691             Address.functionDelegateCall(
692                 newImplementation,
693                 abi.encodeWithSignature("upgradeTo(address)", oldImplementation)
694             );
695             rollbackTesting.value = false;
696             // Check rollback was effective
697             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
698             // Finally reset to the new implementation and log the upgrade
699             _upgradeTo(newImplementation);
700         }
701     }
702 
703     /**
704      * @dev Storage slot with the admin of the contract.
705      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
706      * validated in the constructor.
707      */
708     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
709 
710     /**
711      * @dev Emitted when the admin account has changed.
712      */
713     event AdminChanged(address previousAdmin, address newAdmin);
714 
715     /**
716      * @dev Returns the current admin.
717      */
718     function _getAdmin() internal view returns (address) {
719         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
720     }
721 
722     /**
723      * @dev Stores a new address in the EIP1967 admin slot.
724      */
725     function _setAdmin(address newAdmin) private {
726         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
727         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
728     }
729 
730     /**
731      * @dev Changes the admin of the proxy.
732      *
733      * Emits an {AdminChanged} event.
734      */
735     function _changeAdmin(address newAdmin) internal {
736         emit AdminChanged(_getAdmin(), newAdmin);
737         _setAdmin(newAdmin);
738     }
739 
740     /**
741      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
742      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
743      */
744     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
745 
746     /**
747      * @dev Emitted when the beacon is upgraded.
748      */
749     event BeaconUpgraded(address indexed beacon);
750 
751     /**
752      * @dev Returns the current beacon.
753      */
754     function _getBeacon() internal view returns (address) {
755         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
756     }
757 
758     /**
759      * @dev Stores a new beacon in the EIP1967 beacon slot.
760      */
761     function _setBeacon(address newBeacon) private {
762         require(Address.isContract(newBeacon), "ERC1967: new beacon is not a contract");
763         require(
764             Address.isContract(IBeacon(newBeacon).implementation()),
765             "ERC1967: beacon implementation is not a contract"
766         );
767         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
768     }
769 
770     /**
771      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
772      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
773      *
774      * Emits a {BeaconUpgraded} event.
775      */
776     function _upgradeBeaconToAndCall(
777         address newBeacon,
778         bytes memory data,
779         bool forceCall
780     ) internal {
781         _setBeacon(newBeacon);
782         emit BeaconUpgraded(newBeacon);
783         if (data.length > 0 || forceCall) {
784             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
785         }
786     }
787 }
788 
789 /**
790  * @title Telcoin, LLC.
791  * @dev Implements Openzeppelin Audited Contracts
792  *
793  * @notice This contract implements a proxy that gets the implementation address for each call from a {UpgradeableBeacon}.
794  *
795  * The beacon address is stored in storage slot `uint256(keccak256('eip1967.proxy.beacon')) - 1`, so that it doesn't
796  * conflict with the storage layout of the implementation behind the proxy.
797  *
798  * _Available since v3.4._
799  */
800 contract CloneableProxy is Proxy, ERC1967Upgrade, Initializable {
801     /**
802      * @dev Initializes the proxy with `beacon`.
803      *
804      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon. This
805      * will typically be an encoded function call, and allows initializating the storage of the proxy like a Solidity
806      * constructor.
807      *
808      * Requirements:
809      *
810      * - `beacon` must be a contract with the interface {IBeacon}.
811      */
812     function initialize(address beacon, bytes memory data) external payable initializer() {
813         assert(_BEACON_SLOT == bytes32(uint256(keccak256("eip1967.proxy.beacon")) - 1));
814         _upgradeBeaconToAndCall(beacon, data, false);
815     }
816 
817     /**
818      * @dev Returns the current beacon address.
819      */
820     function _beacon() internal view virtual returns (address) {
821         return _getBeacon();
822     }
823 
824     /**
825      * @dev Returns the current implementation address of the associated beacon.
826      */
827     function _implementation() internal view virtual override returns (address) {
828         return IBeacon(_getBeacon()).implementation();
829     }
830 
831     /**
832      * @dev Changes the proxy to use a new beacon. Deprecated: see {_upgradeBeaconToAndCall}.
833      *
834      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon.
835      *
836      * Requirements:
837      *
838      * - `beacon` must be a contract.
839      * - The implementation returned by `beacon` must be a contract.
840      */
841     function _setBeacon(address beacon, bytes memory data) internal virtual {
842         _upgradeBeaconToAndCall(beacon, data, false);
843     }
844 }
845 
846 /**
847  * @title Telcoin, LLC.
848  * @dev Implements Openzeppelin Audited Contracts
849  *
850  * @notice Contract is designed to make duplicates of a proxy contract
851  *
852  * By default, the owner account will be the one that deploys the contract. This
853  * can later be changed with {transferOwnership}.
854  *
855  * This module is used through inheritance. It will make available the modifier
856  * `onlyOwner`, which can be applied to your functions to restrict their use to
857  * the owner.
858  */
859 contract CloneFactory is Ownable {
860   //event emits new contract address
861   event Deployed(address indexed proxyAddress) anonymous;
862   //immutable template for cloning
863   address public immutable proxyImplementation;
864 
865   /**
866    * @notice The creating address becomes the owner
867    * @dev Creates the base clonable template
868    */
869   constructor() Ownable() {
870     proxyImplementation = address(new CloneableProxy());
871   }
872 
873   /**
874    * @notice Clones an existing proxy and initializes the contract
875    * @param beacon is the address of the beacon to the logic contract
876    * @param data is the initialization data of the logic contract
877    * Can only be called by the current owner.
878    *
879    * Emits a {Deployed} event.
880    */
881   function createProxy(address beacon, bytes memory data) external onlyOwner() {
882     address payable clone = payable(Clones.clone(proxyImplementation));
883     CloneableProxy(clone).initialize(beacon, data);
884     emit Deployed(clone);
885   }
886 }