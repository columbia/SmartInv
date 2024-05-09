1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-07
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
10  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
11  * be specified by overriding the virtual {_implementation} function.
12  *
13  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
14  * different contract through the {_delegate} function.
15  *
16  * The success and return data of the delegated call will be returned back to the caller of the proxy.
17  */
18 abstract contract Proxy {
19     /**
20      * @dev Delegates the current call to `implementation`.
21      *
22      * This function does not return to its internall call site, it will return directly to the external caller.
23      */
24     function _delegate(address implementation) internal virtual {
25         // solhint-disable-next-line no-inline-assembly
26         assembly {
27         // Copy msg.data. We take full control of memory in this inline assembly
28         // block because it will not return to Solidity code. We overwrite the
29         // Solidity scratch pad at memory position 0.
30             calldatacopy(0, 0, calldatasize())
31 
32         // Call the implementation.
33         // out and outsize are 0 because we don't know the size yet.
34             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
35 
36         // Copy the returned data.
37             returndatacopy(0, 0, returndatasize())
38 
39             switch result
40             // delegatecall returns 0 on error.
41             case 0 { revert(0, returndatasize()) }
42             default { return(0, returndatasize()) }
43         }
44     }
45 
46     /**
47      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
48      * and {_fallback} should delegate.
49      */
50     function _implementation() internal view virtual returns (address);
51 
52     /**
53      * @dev Delegates the current call to the address returned by `_implementation()`.
54      *
55      * This function does not return to its internall call site, it will return directly to the external caller.
56      */
57     function _fallback() internal virtual {
58         _beforeFallback();
59         _delegate(_implementation());
60     }
61 
62     /**
63      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
64      * function in the contract matches the call data.
65      */
66     fallback () external payable virtual {
67         _fallback();
68     }
69 
70     /**
71      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
72      * is empty.
73      */
74     receive () external payable virtual {
75         _fallback();
76     }
77 
78     /**
79      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
80      * call, or as part of the Solidity `fallback` or `receive` functions.
81      *
82      * If overriden should call `super._beforeFallback()`.
83      */
84     function _beforeFallback() internal virtual {
85     }
86 }
87 
88 
89 /**
90  * @dev This abstract contract provides getters and event emitting update functions for
91  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
92  *
93  * _Available since v4.1._
94  *
95  */
96 abstract contract ERC1967Upgrade {
97     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
98     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
99 
100     /**
101      * @dev Storage slot with the address of the current implementation.
102      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
103      * validated in the constructor.
104      */
105     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
106 
107     /**
108      * @dev Emitted when the implementation is upgraded.
109      */
110     event Upgraded(address indexed implementation);
111 
112     /**
113      * @dev Returns the current implementation address.
114      */
115     function _getImplementation() internal view returns (address) {
116         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
117     }
118 
119     /**
120      * @dev Stores a new address in the EIP1967 implementation slot.
121      */
122     function _setImplementation(address newImplementation) private {
123         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
124         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
125     }
126 
127     /**
128      * @dev Perform implementation upgrade
129      *
130      * Emits an {Upgraded} event.
131      */
132     function _upgradeTo(address newImplementation) internal {
133         _setImplementation(newImplementation);
134         emit Upgraded(newImplementation);
135     }
136 
137     /**
138      * @dev Perform implementation upgrade with additional setup call.
139      *
140      * Emits an {Upgraded} event.
141      */
142     function _upgradeToAndCall(address newImplementation, bytes memory data, bool forceCall) internal {
143         _setImplementation(newImplementation);
144         emit Upgraded(newImplementation);
145         if (data.length > 0 || forceCall) {
146             Address.functionDelegateCall(newImplementation, data);
147         }
148     }
149 
150     /**
151      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
152      *
153      * Emits an {Upgraded} event.
154      */
155     function _upgradeToAndCallSecure(address newImplementation, bytes memory data, bool forceCall) internal {
156         address oldImplementation = _getImplementation();
157 
158         // Initial upgrade and setup call
159         _setImplementation(newImplementation);
160         if (data.length > 0 || forceCall) {
161             Address.functionDelegateCall(newImplementation, data);
162         }
163 
164         // Perform rollback test if not already in progress
165         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
166         if (!rollbackTesting.value) {
167             // Trigger rollback using upgradeTo from the new implementation
168             rollbackTesting.value = true;
169             Address.functionDelegateCall(
170                 newImplementation,
171                 abi.encodeWithSignature(
172                     "upgradeTo(address)",
173                     oldImplementation
174                 )
175             );
176             rollbackTesting.value = false;
177             // Check rollback was effective
178             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
179             // Finally reset to the new implementation and log the upgrade
180             _setImplementation(newImplementation);
181             emit Upgraded(newImplementation);
182         }
183     }
184 
185     /**
186      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
187      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
188      *
189      * Emits a {BeaconUpgraded} event.
190      */
191     function _upgradeBeaconToAndCall(address newBeacon, bytes memory data, bool forceCall) internal {
192         _setBeacon(newBeacon);
193         emit BeaconUpgraded(newBeacon);
194         if (data.length > 0 || forceCall) {
195             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
196         }
197     }
198 
199     /**
200      * @dev Storage slot with the admin of the contract.
201      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
202      * validated in the constructor.
203      */
204     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
205 
206     /**
207      * @dev Emitted when the admin account has changed.
208      */
209     event AdminChanged(address previousAdmin, address newAdmin);
210 
211     /**
212      * @dev Returns the current admin.
213      */
214     function _getAdmin() internal view returns (address) {
215         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
216     }
217 
218     /**
219      * @dev Stores a new address in the EIP1967 admin slot.
220      */
221     function _setAdmin(address newAdmin) private {
222         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
223         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
224     }
225 
226     /**
227      * @dev Changes the admin of the proxy.
228      *
229      * Emits an {AdminChanged} event.
230      */
231     function _changeAdmin(address newAdmin) internal {
232         emit AdminChanged(_getAdmin(), newAdmin);
233         _setAdmin(newAdmin);
234     }
235 
236     /**
237      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
238      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
239      */
240     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
241 
242     /**
243      * @dev Emitted when the beacon is upgraded.
244      */
245     event BeaconUpgraded(address indexed beacon);
246 
247     /**
248      * @dev Returns the current beacon.
249      */
250     function _getBeacon() internal view returns (address) {
251         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
252     }
253 
254     /**
255      * @dev Stores a new beacon in the EIP1967 beacon slot.
256      */
257     function _setBeacon(address newBeacon) private {
258         require(
259             Address.isContract(newBeacon),
260             "ERC1967: new beacon is not a contract"
261         );
262         require(
263             Address.isContract(IBeacon(newBeacon).implementation()),
264             "ERC1967: beacon implementation is not a contract"
265         );
266         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
267     }
268 }
269 
270 /**
271  * @dev This is the interface that {BeaconProxy} expects of its beacon.
272  */
273 interface IBeacon {
274     /**
275      * @dev Must return an address that can be used as a delegate call target.
276      *
277      * {BeaconProxy} will check that this address is a contract.
278      */
279     function implementation() external view returns (address);
280 }
281 
282 /**
283  * @dev Collection of functions related to the address type
284  */
285 library Address {
286     /**
287      * @dev Returns true if `account` is a contract.
288      *
289      * [IMPORTANT]
290      * ====
291      * It is unsafe to assume that an address for which this function returns
292      * false is an externally-owned account (EOA) and not a contract.
293      *
294      * Among others, `isContract` will return false for the following
295      * types of addresses:
296      *
297      *  - an externally-owned account
298      *  - a contract in construction
299      *  - an address where a contract will be created
300      *  - an address where a contract lived, but was destroyed
301      * ====
302      */
303     function isContract(address account) internal view returns (bool) {
304         // This method relies on extcodesize, which returns 0 for contracts in
305         // construction, since the code is only stored at the end of the
306         // constructor execution.
307 
308         uint256 size;
309         // solhint-disable-next-line no-inline-assembly
310         assembly { size := extcodesize(account) }
311         return size > 0;
312     }
313 
314     /**
315      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
316      * `recipient`, forwarding all available gas and reverting on errors.
317      *
318      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
319      * of certain opcodes, possibly making contracts go over the 2300 gas limit
320      * imposed by `transfer`, making them unable to receive funds via
321      * `transfer`. {sendValue} removes this limitation.
322      *
323      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
324      *
325      * IMPORTANT: because control is transferred to `recipient`, care must be
326      * taken to not create reentrancy vulnerabilities. Consider using
327      * {ReentrancyGuard} or the
328      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
329      */
330     function sendValue(address payable recipient, uint256 amount) internal {
331         require(address(this).balance >= amount, "Address: insufficient balance");
332 
333         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
334         (bool success, ) = recipient.call{ value: amount }("");
335         require(success, "Address: unable to send value, recipient may have reverted");
336     }
337 
338     /**
339      * @dev Performs a Solidity function call using a low level `call`. A
340      * plain`call` is an unsafe replacement for a function call: use this
341      * function instead.
342      *
343      * If `target` reverts with a revert reason, it is bubbled up by this
344      * function (like regular Solidity function calls).
345      *
346      * Returns the raw returned data. To convert to the expected return value,
347      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
348      *
349      * Requirements:
350      *
351      * - `target` must be a contract.
352      * - calling `target` with `data` must not revert.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
357         return functionCall(target, data, "Address: low-level call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
362      * `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
367         return functionCallWithValue(target, data, 0, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but also transferring `value` wei to `target`.
373      *
374      * Requirements:
375      *
376      * - the calling contract must have an ETH balance of at least `value`.
377      * - the called Solidity function must be `payable`.
378      *
379      * _Available since v3.1._
380      */
381     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
382         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
387      * with `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
392         require(address(this).balance >= value, "Address: insufficient balance for call");
393         require(isContract(target), "Address: call to non-contract");
394 
395         // solhint-disable-next-line avoid-low-level-calls
396         (bool success, bytes memory returndata) = target.call{ value: value }(data);
397         return _verifyCallResult(success, returndata, errorMessage);
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
402      * but performing a static call.
403      *
404      * _Available since v3.3._
405      */
406     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
407         return functionStaticCall(target, data, "Address: low-level static call failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
412      * but performing a static call.
413      *
414      * _Available since v3.3._
415      */
416     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
417         require(isContract(target), "Address: static call to non-contract");
418 
419         // solhint-disable-next-line avoid-low-level-calls
420         (bool success, bytes memory returndata) = target.staticcall(data);
421         return _verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but performing a delegate call.
427      *
428      * _Available since v3.4._
429      */
430     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
431         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
436      * but performing a delegate call.
437      *
438      * _Available since v3.4._
439      */
440     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
441         require(isContract(target), "Address: delegate call to non-contract");
442 
443         // solhint-disable-next-line avoid-low-level-calls
444         (bool success, bytes memory returndata) = target.delegatecall(data);
445         return _verifyCallResult(success, returndata, errorMessage);
446     }
447 
448     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
449         if (success) {
450             return returndata;
451         } else {
452             // Look for revert reason and bubble it up if present
453             if (returndata.length > 0) {
454                 // The easiest way to bubble the revert reason is using memory via assembly
455 
456                 // solhint-disable-next-line no-inline-assembly
457                 assembly {
458                     let returndata_size := mload(returndata)
459                     revert(add(32, returndata), returndata_size)
460                 }
461             } else {
462                 revert(errorMessage);
463             }
464         }
465     }
466 }
467 
468 /**
469  * @dev Library for reading and writing primitive types to specific storage slots.
470  *
471  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
472  * This library helps with reading and writing to such slots without the need for inline assembly.
473  *
474  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
475  *
476  * Example usage to set ERC1967 implementation slot:
477  * ```
478  * contract ERC1967 {
479  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
480  *
481  *     function _getImplementation() internal view returns (address) {
482  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
483  *     }
484  *
485  *     function _setImplementation(address newImplementation) internal {
486  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
487  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
488  *     }
489  * }
490  * ```
491  *
492  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
493  */
494 library StorageSlot {
495     struct AddressSlot {
496         address value;
497     }
498 
499     struct BooleanSlot {
500         bool value;
501     }
502 
503     struct Bytes32Slot {
504         bytes32 value;
505     }
506 
507     struct Uint256Slot {
508         uint256 value;
509     }
510 
511     /**
512      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
513      */
514     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
515         assembly {
516             r.slot := slot
517         }
518     }
519 
520     /**
521      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
522      */
523     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
524         assembly {
525             r.slot := slot
526         }
527     }
528 
529     /**
530      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
531      */
532     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
533         assembly {
534             r.slot := slot
535         }
536     }
537 
538     /**
539      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
540      */
541     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
542         assembly {
543             r.slot := slot
544         }
545     }
546 }
547 
548 /*
549  * @dev Provides information about the current execution context, including the
550  * sender of the transaction and its data. While these are generally available
551  * via msg.sender and msg.data, they should not be accessed in such a direct
552  * manner, since when dealing with meta-transactions the account sending and
553  * paying for execution may not be the actual sender (as far as an application
554  * is concerned).
555  *
556  * This contract is only required for intermediate, library-like contracts.
557  */
558 abstract contract Context {
559     function _msgSender() internal view virtual returns (address) {
560         return msg.sender;
561     }
562 
563     function _msgData() internal view virtual returns (bytes calldata) {
564         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
565         return msg.data;
566     }
567 }
568 
569 /**
570  * @dev Contract module which provides a basic access control mechanism, where
571  * there is an account (an owner) that can be granted exclusive access to
572  * specific functions.
573  *
574  * By default, the owner account will be the one that deploys the contract. This
575  * can later be changed with {transferOwnership}.
576  *
577  * This module is used through inheritance. It will make available the modifier
578  * `onlyOwner`, which can be applied to your functions to restrict their use to
579  * the owner.
580  */
581 abstract contract Ownable is Context {
582     address private _owner;
583 
584     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
585 
586     /**
587      * @dev Initializes the contract setting the deployer as the initial owner.
588      */
589     constructor () {
590         address msgSender = _msgSender();
591         _owner = msgSender;
592         emit OwnershipTransferred(address(0), msgSender);
593     }
594 
595     /**
596      * @dev Returns the address of the current owner.
597      */
598     function owner() public view virtual returns (address) {
599         return _owner;
600     }
601 
602     /**
603      * @dev Throws if called by any account other than the owner.
604      */
605     modifier onlyOwner() {
606         require(owner() == _msgSender(), "Ownable: caller is not the owner");
607         _;
608     }
609 
610     /**
611      * @dev Leaves the contract without owner. It will not be possible to call
612      * `onlyOwner` functions anymore. Can only be called by the current owner.
613      *
614      * NOTE: Renouncing ownership will leave the contract without an owner,
615      * thereby removing any functionality that is only available to the owner.
616      */
617     function renounceOwnership() public virtual onlyOwner {
618         emit OwnershipTransferred(_owner, address(0));
619         _owner = address(0);
620     }
621 
622     /**
623      * @dev Transfers ownership of the contract to a new account (`newOwner`).
624      * Can only be called by the current owner.
625      */
626     function transferOwnership(address newOwner) public virtual onlyOwner {
627         require(newOwner != address(0), "Ownable: new owner is the zero address");
628         emit OwnershipTransferred(_owner, newOwner);
629         _owner = newOwner;
630     }
631 }
632 
633 /**
634  * @dev This is an auxiliary contract meant to be assigned as the admin of a {TransparentUpgradeableProxy}. For an
635  * explanation of why you would want to use this see the documentation for {TransparentUpgradeableProxy}.
636  */
637 contract ProxyAdmin is Ownable {
638 
639     /**
640      * @dev Returns the current implementation of `proxy`.
641      *
642      * Requirements:
643      *
644      * - This contract must be the admin of `proxy`.
645      */
646     function getProxyImplementation(TransparentUpgradeableProxy proxy) public view virtual returns (address) {
647         // We need to manually run the static call since the getter cannot be flagged as view
648         // bytes4(keccak256("implementation()")) == 0x5c60da1b
649         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"5c60da1b");
650         require(success);
651         return abi.decode(returndata, (address));
652     }
653 
654     /**
655      * @dev Returns the current admin of `proxy`.
656      *
657      * Requirements:
658      *
659      * - This contract must be the admin of `proxy`.
660      */
661     function getProxyAdmin(TransparentUpgradeableProxy proxy) public view virtual returns (address) {
662         // We need to manually run the static call since the getter cannot be flagged as view
663         // bytes4(keccak256("admin()")) == 0xf851a440
664         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"f851a440");
665         require(success);
666         return abi.decode(returndata, (address));
667     }
668 
669     /**
670      * @dev Changes the admin of `proxy` to `newAdmin`.
671      *
672      * Requirements:
673      *
674      * - This contract must be the current admin of `proxy`.
675      */
676     function changeProxyAdmin(TransparentUpgradeableProxy proxy, address newAdmin) public virtual onlyOwner {
677         proxy.changeAdmin(newAdmin);
678     }
679 
680     /**
681      * @dev Upgrades `proxy` to `implementation`. See {TransparentUpgradeableProxy-upgradeTo}.
682      *
683      * Requirements:
684      *
685      * - This contract must be the admin of `proxy`.
686      */
687     function upgrade(TransparentUpgradeableProxy proxy, address implementation) public virtual onlyOwner {
688         proxy.upgradeTo(implementation);
689     }
690 
691     /**
692      * @dev Upgrades `proxy` to `implementation` and calls a function on the new implementation. See
693      * {TransparentUpgradeableProxy-upgradeToAndCall}.
694      *
695      * Requirements:
696      *
697      * - This contract must be the admin of `proxy`.
698      */
699     function upgradeAndCall(TransparentUpgradeableProxy proxy, address implementation, bytes memory data) public payable virtual onlyOwner {
700         proxy.upgradeToAndCall{value: msg.value}(implementation, data);
701     }
702 }
703 
704 
705 /**
706  * @dev Base contract for building openzeppelin-upgrades compatible implementations for the {ERC1967Proxy}. It includes
707  * publicly available upgrade functions that are called by the plugin and by the secure upgrade mechanism to verify
708  * continuation of the upgradability.
709  *
710  * The {_authorizeUpgrade} function MUST be overridden to include access restriction to the upgrade mechanism.
711  *
712  * _Available since v4.1._
713  */
714 abstract contract UUPSUpgradeable is ERC1967Upgrade {
715     function upgradeTo(address newImplementation) external virtual {
716         _authorizeUpgrade(newImplementation);
717         _upgradeToAndCallSecure(newImplementation, bytes(""), false);
718     }
719 
720     function upgradeToAndCall(address newImplementation, bytes memory data) external payable virtual {
721         _authorizeUpgrade(newImplementation);
722         _upgradeToAndCallSecure(newImplementation, data, true);
723     }
724 
725     function _authorizeUpgrade(address newImplementation) internal virtual;
726 }
727 
728 
729 abstract contract Proxiable is UUPSUpgradeable {
730     function _authorizeUpgrade(address newImplementation) internal override {
731         _beforeUpgrade(newImplementation);
732     }
733 
734     function _beforeUpgrade(address newImplementation) internal virtual;
735 }
736 
737 contract ChildOfProxiable is Proxiable {
738     function _beforeUpgrade(address newImplementation) internal virtual override {}
739 }
740 
741 
742 /**
743  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
744  * implementation address that can be changed. This address is stored in storage in the location specified by
745  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
746  * implementation behind the proxy.
747  */
748 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
749     /**
750      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
751      *
752      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
753      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
754      */
755     constructor(address _logic, bytes memory _data) payable {
756         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
757         _upgradeToAndCall(_logic, _data, false);
758     }
759 
760     /**
761      * @dev Returns the current implementation address.
762      */
763     function _implementation() internal view virtual override returns (address impl) {
764         return ERC1967Upgrade._getImplementation();
765     }
766 }
767 
768 /**
769  * @dev This contract implements a proxy that is upgradeable by an admin.
770  *
771  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
772  * clashing], which can potentially be used in an attack, this contract uses the
773  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
774  * things that go hand in hand:
775  *
776  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
777  * that call matches one of the admin functions exposed by the proxy itself.
778  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
779  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
780  * "admin cannot fallback to proxy target".
781  *
782  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
783  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
784  * to sudden errors when trying to call a function from the proxy implementation.
785  *
786  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
787  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
788  */
789 contract TransparentUpgradeableProxy is ERC1967Proxy {
790     /**
791      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
792      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
793      */
794     constructor(address _logic, address admin_, bytes memory _data) payable ERC1967Proxy(_logic, _data) {
795         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
796         _changeAdmin(admin_);
797     }
798 
799     /**
800      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
801      */
802     modifier ifAdmin() {
803         if (msg.sender == _getAdmin()) {
804             _;
805         } else {
806             _fallback();
807         }
808     }
809 
810     /**
811      * @dev Returns the current admin.
812      *
813      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
814      *
815      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
816      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
817      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
818      */
819     function admin() external ifAdmin returns (address admin_) {
820         admin_ = _getAdmin();
821     }
822 
823     /**
824      * @dev Returns the current implementation.
825      *
826      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
827      *
828      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
829      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
830      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
831      */
832     function implementation() external ifAdmin returns (address implementation_) {
833         implementation_ = _implementation();
834     }
835 
836     /**
837      * @dev Changes the admin of the proxy.
838      *
839      * Emits an {AdminChanged} event.
840      *
841      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
842      */
843     function changeAdmin(address newAdmin) external virtual ifAdmin {
844         _changeAdmin(newAdmin);
845     }
846 
847     /**
848      * @dev Upgrade the implementation of the proxy.
849      *
850      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
851      */
852     function upgradeTo(address newImplementation) external ifAdmin {
853         _upgradeToAndCall(newImplementation, bytes(""), false);
854     }
855 
856     /**
857      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
858      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
859      * proxied contract.
860      *
861      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
862      */
863     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
864         _upgradeToAndCall(newImplementation, data, true);
865     }
866 
867     /**
868      * @dev Returns the current admin.
869      */
870     function _admin() internal view virtual returns (address) {
871         return _getAdmin();
872     }
873 
874     /**
875      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
876      */
877     function _beforeFallback() internal virtual override {
878         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
879         super._beforeFallback();
880     }
881 }
882 
883 
884 // Kept for backwards compatibility with older versions of Hardhat and Truffle plugins.
885 contract AdminUpgradeabilityProxy is TransparentUpgradeableProxy {
886     constructor(address logic, address admin, bytes memory data) payable TransparentUpgradeableProxy(logic, admin, data) {}
887 }