1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
6  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
7  * be specified by overriding the virtual {_implementation} function.
8  *
9  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
10  * different contract through the {_delegate} function.
11  *
12  * The success and return data of the delegated call will be returned back to the caller of the proxy.
13  */
14 abstract contract Proxy {
15     /**
16      * @dev Delegates the current call to `implementation`.
17      *
18      * This function does not return to its internall call site, it will return directly to the external caller.
19      */
20     function _delegate(address implementation) internal virtual {
21         // solhint-disable-next-line no-inline-assembly
22         assembly {
23         // Copy msg.data. We take full control of memory in this inline assembly
24         // block because it will not return to Solidity code. We overwrite the
25         // Solidity scratch pad at memory position 0.
26             calldatacopy(0, 0, calldatasize())
27 
28         // Call the implementation.
29         // out and outsize are 0 because we don't know the size yet.
30             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
31 
32         // Copy the returned data.
33             returndatacopy(0, 0, returndatasize())
34 
35             switch result
36             // delegatecall returns 0 on error.
37             case 0 { revert(0, returndatasize()) }
38             default { return(0, returndatasize()) }
39         }
40     }
41 
42     /**
43      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
44      * and {_fallback} should delegate.
45      */
46     function _implementation() internal view virtual returns (address);
47 
48     /**
49      * @dev Delegates the current call to the address returned by `_implementation()`.
50      *
51      * This function does not return to its internall call site, it will return directly to the external caller.
52      */
53     function _fallback() internal virtual {
54         _beforeFallback();
55         _delegate(_implementation());
56     }
57 
58     /**
59      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
60      * function in the contract matches the call data.
61      */
62     fallback () external payable virtual {
63         _fallback();
64     }
65 
66     /**
67      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
68      * is empty.
69      */
70     receive () external payable virtual {
71         _fallback();
72     }
73 
74     /**
75      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
76      * call, or as part of the Solidity `fallback` or `receive` functions.
77      *
78      * If overriden should call `super._beforeFallback()`.
79      */
80     function _beforeFallback() internal virtual {
81     }
82 }
83 
84 
85 /**
86  * @dev This abstract contract provides getters and event emitting update functions for
87  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
88  *
89  * _Available since v4.1._
90  *
91  */
92 abstract contract ERC1967Upgrade {
93     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
94     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
95 
96     /**
97      * @dev Storage slot with the address of the current implementation.
98      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
99      * validated in the constructor.
100      */
101     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
102 
103     /**
104      * @dev Emitted when the implementation is upgraded.
105      */
106     event Upgraded(address indexed implementation);
107 
108     /**
109      * @dev Returns the current implementation address.
110      */
111     function _getImplementation() internal view returns (address) {
112         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
113     }
114 
115     /**
116      * @dev Stores a new address in the EIP1967 implementation slot.
117      */
118     function _setImplementation(address newImplementation) private {
119         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
120         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
121     }
122 
123     /**
124      * @dev Perform implementation upgrade
125      *
126      * Emits an {Upgraded} event.
127      */
128     function _upgradeTo(address newImplementation) internal {
129         _setImplementation(newImplementation);
130         emit Upgraded(newImplementation);
131     }
132 
133     /**
134      * @dev Perform implementation upgrade with additional setup call.
135      *
136      * Emits an {Upgraded} event.
137      */
138     function _upgradeToAndCall(address newImplementation, bytes memory data, bool forceCall) internal {
139         _setImplementation(newImplementation);
140         emit Upgraded(newImplementation);
141         if (data.length > 0 || forceCall) {
142             Address.functionDelegateCall(newImplementation, data);
143         }
144     }
145 
146     /**
147      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
148      *
149      * Emits an {Upgraded} event.
150      */
151     function _upgradeToAndCallSecure(address newImplementation, bytes memory data, bool forceCall) internal {
152         address oldImplementation = _getImplementation();
153 
154         // Initial upgrade and setup call
155         _setImplementation(newImplementation);
156         if (data.length > 0 || forceCall) {
157             Address.functionDelegateCall(newImplementation, data);
158         }
159 
160         // Perform rollback test if not already in progress
161         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
162         if (!rollbackTesting.value) {
163             // Trigger rollback using upgradeTo from the new implementation
164             rollbackTesting.value = true;
165             Address.functionDelegateCall(
166                 newImplementation,
167                 abi.encodeWithSignature(
168                     "upgradeTo(address)",
169                     oldImplementation
170                 )
171             );
172             rollbackTesting.value = false;
173             // Check rollback was effective
174             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
175             // Finally reset to the new implementation and log the upgrade
176             _setImplementation(newImplementation);
177             emit Upgraded(newImplementation);
178         }
179     }
180 
181     /**
182      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
183      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
184      *
185      * Emits a {BeaconUpgraded} event.
186      */
187     function _upgradeBeaconToAndCall(address newBeacon, bytes memory data, bool forceCall) internal {
188         _setBeacon(newBeacon);
189         emit BeaconUpgraded(newBeacon);
190         if (data.length > 0 || forceCall) {
191             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
192         }
193     }
194 
195     /**
196      * @dev Storage slot with the admin of the contract.
197      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
198      * validated in the constructor.
199      */
200     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
201 
202     /**
203      * @dev Emitted when the admin account has changed.
204      */
205     event AdminChanged(address previousAdmin, address newAdmin);
206 
207     /**
208      * @dev Returns the current admin.
209      */
210     function _getAdmin() internal view returns (address) {
211         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
212     }
213 
214     /**
215      * @dev Stores a new address in the EIP1967 admin slot.
216      */
217     function _setAdmin(address newAdmin) private {
218         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
219         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
220     }
221 
222     /**
223      * @dev Changes the admin of the proxy.
224      *
225      * Emits an {AdminChanged} event.
226      */
227     function _changeAdmin(address newAdmin) internal {
228         emit AdminChanged(_getAdmin(), newAdmin);
229         _setAdmin(newAdmin);
230     }
231 
232     /**
233      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
234      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
235      */
236     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
237 
238     /**
239      * @dev Emitted when the beacon is upgraded.
240      */
241     event BeaconUpgraded(address indexed beacon);
242 
243     /**
244      * @dev Returns the current beacon.
245      */
246     function _getBeacon() internal view returns (address) {
247         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
248     }
249 
250     /**
251      * @dev Stores a new beacon in the EIP1967 beacon slot.
252      */
253     function _setBeacon(address newBeacon) private {
254         require(
255             Address.isContract(newBeacon),
256             "ERC1967: new beacon is not a contract"
257         );
258         require(
259             Address.isContract(IBeacon(newBeacon).implementation()),
260             "ERC1967: beacon implementation is not a contract"
261         );
262         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
263     }
264 }
265 
266 /**
267  * @dev This is the interface that {BeaconProxy} expects of its beacon.
268  */
269 interface IBeacon {
270     /**
271      * @dev Must return an address that can be used as a delegate call target.
272      *
273      * {BeaconProxy} will check that this address is a contract.
274      */
275     function implementation() external view returns (address);
276 }
277 
278 /**
279  * @dev Collection of functions related to the address type
280  */
281 library Address {
282     /**
283      * @dev Returns true if `account` is a contract.
284      *
285      * [IMPORTANT]
286      * ====
287      * It is unsafe to assume that an address for which this function returns
288      * false is an externally-owned account (EOA) and not a contract.
289      *
290      * Among others, `isContract` will return false for the following
291      * types of addresses:
292      *
293      *  - an externally-owned account
294      *  - a contract in construction
295      *  - an address where a contract will be created
296      *  - an address where a contract lived, but was destroyed
297      * ====
298      */
299     function isContract(address account) internal view returns (bool) {
300         // This method relies on extcodesize, which returns 0 for contracts in
301         // construction, since the code is only stored at the end of the
302         // constructor execution.
303 
304         uint256 size;
305         // solhint-disable-next-line no-inline-assembly
306         assembly { size := extcodesize(account) }
307         return size > 0;
308     }
309 
310     /**
311      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
312      * `recipient`, forwarding all available gas and reverting on errors.
313      *
314      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
315      * of certain opcodes, possibly making contracts go over the 2300 gas limit
316      * imposed by `transfer`, making them unable to receive funds via
317      * `transfer`. {sendValue} removes this limitation.
318      *
319      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
320      *
321      * IMPORTANT: because control is transferred to `recipient`, care must be
322      * taken to not create reentrancy vulnerabilities. Consider using
323      * {ReentrancyGuard} or the
324      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
325      */
326     function sendValue(address payable recipient, uint256 amount) internal {
327         require(address(this).balance >= amount, "Address: insufficient balance");
328 
329         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
330         (bool success, ) = recipient.call{ value: amount }("");
331         require(success, "Address: unable to send value, recipient may have reverted");
332     }
333 
334     /**
335      * @dev Performs a Solidity function call using a low level `call`. A
336      * plain`call` is an unsafe replacement for a function call: use this
337      * function instead.
338      *
339      * If `target` reverts with a revert reason, it is bubbled up by this
340      * function (like regular Solidity function calls).
341      *
342      * Returns the raw returned data. To convert to the expected return value,
343      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
344      *
345      * Requirements:
346      *
347      * - `target` must be a contract.
348      * - calling `target` with `data` must not revert.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
353         return functionCall(target, data, "Address: low-level call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
358      * `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
363         return functionCallWithValue(target, data, 0, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but also transferring `value` wei to `target`.
369      *
370      * Requirements:
371      *
372      * - the calling contract must have an ETH balance of at least `value`.
373      * - the called Solidity function must be `payable`.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
378         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
383      * with `errorMessage` as a fallback revert reason when `target` reverts.
384      *
385      * _Available since v3.1._
386      */
387     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
388         require(address(this).balance >= value, "Address: insufficient balance for call");
389         require(isContract(target), "Address: call to non-contract");
390 
391         // solhint-disable-next-line avoid-low-level-calls
392         (bool success, bytes memory returndata) = target.call{ value: value }(data);
393         return _verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a static call.
399      *
400      * _Available since v3.3._
401      */
402     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
403         return functionStaticCall(target, data, "Address: low-level static call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a static call.
409      *
410      * _Available since v3.3._
411      */
412     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
413         require(isContract(target), "Address: static call to non-contract");
414 
415         // solhint-disable-next-line avoid-low-level-calls
416         (bool success, bytes memory returndata) = target.staticcall(data);
417         return _verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
422      * but performing a delegate call.
423      *
424      * _Available since v3.4._
425      */
426     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
427         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
432      * but performing a delegate call.
433      *
434      * _Available since v3.4._
435      */
436     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
437         require(isContract(target), "Address: delegate call to non-contract");
438 
439         // solhint-disable-next-line avoid-low-level-calls
440         (bool success, bytes memory returndata) = target.delegatecall(data);
441         return _verifyCallResult(success, returndata, errorMessage);
442     }
443 
444     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
445         if (success) {
446             return returndata;
447         } else {
448             // Look for revert reason and bubble it up if present
449             if (returndata.length > 0) {
450                 // The easiest way to bubble the revert reason is using memory via assembly
451 
452                 // solhint-disable-next-line no-inline-assembly
453                 assembly {
454                     let returndata_size := mload(returndata)
455                     revert(add(32, returndata), returndata_size)
456                 }
457             } else {
458                 revert(errorMessage);
459             }
460         }
461     }
462 }
463 
464 /**
465  * @dev Library for reading and writing primitive types to specific storage slots.
466  *
467  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
468  * This library helps with reading and writing to such slots without the need for inline assembly.
469  *
470  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
471  *
472  * Example usage to set ERC1967 implementation slot:
473  * ```
474  * contract ERC1967 {
475  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
476  *
477  *     function _getImplementation() internal view returns (address) {
478  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
479  *     }
480  *
481  *     function _setImplementation(address newImplementation) internal {
482  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
483  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
484  *     }
485  * }
486  * ```
487  *
488  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
489  */
490 library StorageSlot {
491     struct AddressSlot {
492         address value;
493     }
494 
495     struct BooleanSlot {
496         bool value;
497     }
498 
499     struct Bytes32Slot {
500         bytes32 value;
501     }
502 
503     struct Uint256Slot {
504         uint256 value;
505     }
506 
507     /**
508      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
509      */
510     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
511         assembly {
512             r.slot := slot
513         }
514     }
515 
516     /**
517      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
518      */
519     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
520         assembly {
521             r.slot := slot
522         }
523     }
524 
525     /**
526      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
527      */
528     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
529         assembly {
530             r.slot := slot
531         }
532     }
533 
534     /**
535      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
536      */
537     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
538         assembly {
539             r.slot := slot
540         }
541     }
542 }
543 
544 /*
545  * @dev Provides information about the current execution context, including the
546  * sender of the transaction and its data. While these are generally available
547  * via msg.sender and msg.data, they should not be accessed in such a direct
548  * manner, since when dealing with meta-transactions the account sending and
549  * paying for execution may not be the actual sender (as far as an application
550  * is concerned).
551  *
552  * This contract is only required for intermediate, library-like contracts.
553  */
554 abstract contract Context {
555     function _msgSender() internal view virtual returns (address) {
556         return msg.sender;
557     }
558 
559     function _msgData() internal view virtual returns (bytes calldata) {
560         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
561         return msg.data;
562     }
563 }
564 
565 /**
566  * @dev Contract module which provides a basic access control mechanism, where
567  * there is an account (an owner) that can be granted exclusive access to
568  * specific functions.
569  *
570  * By default, the owner account will be the one that deploys the contract. This
571  * can later be changed with {transferOwnership}.
572  *
573  * This module is used through inheritance. It will make available the modifier
574  * `onlyOwner`, which can be applied to your functions to restrict their use to
575  * the owner.
576  */
577 abstract contract Ownable is Context {
578     address private _owner;
579 
580     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
581 
582     /**
583      * @dev Initializes the contract setting the deployer as the initial owner.
584      */
585     constructor () {
586         address msgSender = _msgSender();
587         _owner = msgSender;
588         emit OwnershipTransferred(address(0), msgSender);
589     }
590 
591     /**
592      * @dev Returns the address of the current owner.
593      */
594     function owner() public view virtual returns (address) {
595         return _owner;
596     }
597 
598     /**
599      * @dev Throws if called by any account other than the owner.
600      */
601     modifier onlyOwner() {
602         require(owner() == _msgSender(), "Ownable: caller is not the owner");
603         _;
604     }
605 
606     /**
607      * @dev Leaves the contract without owner. It will not be possible to call
608      * `onlyOwner` functions anymore. Can only be called by the current owner.
609      *
610      * NOTE: Renouncing ownership will leave the contract without an owner,
611      * thereby removing any functionality that is only available to the owner.
612      */
613     function renounceOwnership() public virtual onlyOwner {
614         emit OwnershipTransferred(_owner, address(0));
615         _owner = address(0);
616     }
617 
618     /**
619      * @dev Transfers ownership of the contract to a new account (`newOwner`).
620      * Can only be called by the current owner.
621      */
622     function transferOwnership(address newOwner) public virtual onlyOwner {
623         require(newOwner != address(0), "Ownable: new owner is the zero address");
624         emit OwnershipTransferred(_owner, newOwner);
625         _owner = newOwner;
626     }
627 }
628 
629 /**
630  * @dev This is an auxiliary contract meant to be assigned as the admin of a {TransparentUpgradeableProxy}. For an
631  * explanation of why you would want to use this see the documentation for {TransparentUpgradeableProxy}.
632  */
633 contract ProxyAdmin is Ownable {
634 
635     /**
636      * @dev Returns the current implementation of `proxy`.
637      *
638      * Requirements:
639      *
640      * - This contract must be the admin of `proxy`.
641      */
642     function getProxyImplementation(TransparentUpgradeableProxy proxy) public view virtual returns (address) {
643         // We need to manually run the static call since the getter cannot be flagged as view
644         // bytes4(keccak256("implementation()")) == 0x5c60da1b
645         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"5c60da1b");
646         require(success);
647         return abi.decode(returndata, (address));
648     }
649 
650     /**
651      * @dev Returns the current admin of `proxy`.
652      *
653      * Requirements:
654      *
655      * - This contract must be the admin of `proxy`.
656      */
657     function getProxyAdmin(TransparentUpgradeableProxy proxy) public view virtual returns (address) {
658         // We need to manually run the static call since the getter cannot be flagged as view
659         // bytes4(keccak256("admin()")) == 0xf851a440
660         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"f851a440");
661         require(success);
662         return abi.decode(returndata, (address));
663     }
664 
665     /**
666      * @dev Changes the admin of `proxy` to `newAdmin`.
667      *
668      * Requirements:
669      *
670      * - This contract must be the current admin of `proxy`.
671      */
672     function changeProxyAdmin(TransparentUpgradeableProxy proxy, address newAdmin) public virtual onlyOwner {
673         proxy.changeAdmin(newAdmin);
674     }
675 
676     /**
677      * @dev Upgrades `proxy` to `implementation`. See {TransparentUpgradeableProxy-upgradeTo}.
678      *
679      * Requirements:
680      *
681      * - This contract must be the admin of `proxy`.
682      */
683     function upgrade(TransparentUpgradeableProxy proxy, address implementation) public virtual onlyOwner {
684         proxy.upgradeTo(implementation);
685     }
686 
687     /**
688      * @dev Upgrades `proxy` to `implementation` and calls a function on the new implementation. See
689      * {TransparentUpgradeableProxy-upgradeToAndCall}.
690      *
691      * Requirements:
692      *
693      * - This contract must be the admin of `proxy`.
694      */
695     function upgradeAndCall(TransparentUpgradeableProxy proxy, address implementation, bytes memory data) public payable virtual onlyOwner {
696         proxy.upgradeToAndCall{value: msg.value}(implementation, data);
697     }
698 }
699 
700 
701 /**
702  * @dev Base contract for building openzeppelin-upgrades compatible implementations for the {ERC1967Proxy}. It includes
703  * publicly available upgrade functions that are called by the plugin and by the secure upgrade mechanism to verify
704  * continuation of the upgradability.
705  *
706  * The {_authorizeUpgrade} function MUST be overridden to include access restriction to the upgrade mechanism.
707  *
708  * _Available since v4.1._
709  */
710 abstract contract UUPSUpgradeable is ERC1967Upgrade {
711     function upgradeTo(address newImplementation) external virtual {
712         _authorizeUpgrade(newImplementation);
713         _upgradeToAndCallSecure(newImplementation, bytes(""), false);
714     }
715 
716     function upgradeToAndCall(address newImplementation, bytes memory data) external payable virtual {
717         _authorizeUpgrade(newImplementation);
718         _upgradeToAndCallSecure(newImplementation, data, true);
719     }
720 
721     function _authorizeUpgrade(address newImplementation) internal virtual;
722 }
723 
724 
725 abstract contract Proxiable is UUPSUpgradeable {
726     function _authorizeUpgrade(address newImplementation) internal override {
727         _beforeUpgrade(newImplementation);
728     }
729 
730     function _beforeUpgrade(address newImplementation) internal virtual;
731 }
732 
733 contract ChildOfProxiable is Proxiable {
734     function _beforeUpgrade(address newImplementation) internal virtual override {}
735 }
736 
737 
738 /**
739  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
740  * implementation address that can be changed. This address is stored in storage in the location specified by
741  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
742  * implementation behind the proxy.
743  */
744 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
745     /**
746      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
747      *
748      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
749      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
750      */
751     constructor(address _logic, bytes memory _data) payable {
752         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
753         _upgradeToAndCall(_logic, _data, false);
754     }
755 
756     /**
757      * @dev Returns the current implementation address.
758      */
759     function _implementation() internal view virtual override returns (address impl) {
760         return ERC1967Upgrade._getImplementation();
761     }
762 }
763 
764 /**
765  * @dev This contract implements a proxy that is upgradeable by an admin.
766  *
767  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
768  * clashing], which can potentially be used in an attack, this contract uses the
769  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
770  * things that go hand in hand:
771  *
772  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
773  * that call matches one of the admin functions exposed by the proxy itself.
774  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
775  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
776  * "admin cannot fallback to proxy target".
777  *
778  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
779  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
780  * to sudden errors when trying to call a function from the proxy implementation.
781  *
782  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
783  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
784  */
785 contract TransparentUpgradeableProxy is ERC1967Proxy {
786     /**
787      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
788      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
789      */
790     constructor(address _logic, address admin_, bytes memory _data) payable ERC1967Proxy(_logic, _data) {
791         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
792         _changeAdmin(admin_);
793     }
794 
795     /**
796      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
797      */
798     modifier ifAdmin() {
799         if (msg.sender == _getAdmin()) {
800             _;
801         } else {
802             _fallback();
803         }
804     }
805 
806     /**
807      * @dev Returns the current admin.
808      *
809      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
810      *
811      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
812      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
813      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
814      */
815     function admin() external ifAdmin returns (address admin_) {
816         admin_ = _getAdmin();
817     }
818 
819     /**
820      * @dev Returns the current implementation.
821      *
822      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
823      *
824      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
825      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
826      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
827      */
828     function implementation() external ifAdmin returns (address implementation_) {
829         implementation_ = _implementation();
830     }
831 
832     /**
833      * @dev Changes the admin of the proxy.
834      *
835      * Emits an {AdminChanged} event.
836      *
837      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
838      */
839     function changeAdmin(address newAdmin) external virtual ifAdmin {
840         _changeAdmin(newAdmin);
841     }
842 
843     /**
844      * @dev Upgrade the implementation of the proxy.
845      *
846      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
847      */
848     function upgradeTo(address newImplementation) external ifAdmin {
849         _upgradeToAndCall(newImplementation, bytes(""), false);
850     }
851 
852     /**
853      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
854      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
855      * proxied contract.
856      *
857      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
858      */
859     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
860         _upgradeToAndCall(newImplementation, data, true);
861     }
862 
863     /**
864      * @dev Returns the current admin.
865      */
866     function _admin() internal view virtual returns (address) {
867         return _getAdmin();
868     }
869 
870     /**
871      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
872      */
873     function _beforeFallback() internal virtual override {
874         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
875         super._beforeFallback();
876     }
877 }
878 
879 
880 // Kept for backwards compatibility with older versions of Hardhat and Truffle plugins.
881 contract AdminUpgradeabilityProxy is TransparentUpgradeableProxy {
882     constructor(address logic, address admin, bytes memory data) payable TransparentUpgradeableProxy(logic, admin, data) {}
883 }