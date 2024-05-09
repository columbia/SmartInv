1 // SPDX-License-Identifier: MIT
2 /*
3 made by COOL0312, jug200712
4 2022.01.22
5 **/
6 
7 pragma solidity ^0.8.0;
8 
9 
10 library Address {
11     /**
12      * @dev Returns true if `account` is a contract.
13      *
14      * [IMPORTANT]
15      * ====
16      * It is unsafe to assume that an address for which this function returns
17      * false is an externally-owned account (EOA) and not a contract.
18      *
19      * Among others, `isContract` will return false for the following
20      * types of addresses:
21      *
22      *  - an externally-owned account
23      *  - a contract in construction
24      *  - an address where a contract will be created
25      *  - an address where a contract lived, but was destroyed
26      * ====
27      */
28     function isContract(address account) internal view returns (bool) {
29         // This method relies on extcodesize, which returns 0 for contracts in
30         // construction, since the code is only stored at the end of the
31         // constructor execution.
32 
33         uint256 size;
34         // solhint-disable-next-line no-inline-assembly
35         assembly { size := extcodesize(account) }
36         return size > 0;
37     }
38 
39     /**
40      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
41      * `recipient`, forwarding all available gas and reverting on errors.
42      *
43      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
44      * of certain opcodes, possibly making contracts go over the 2300 gas limit
45      * imposed by `transfer`, making them unable to receive funds via
46      * `transfer`. {sendValue} removes this limitation.
47      *
48      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
49      *
50      * IMPORTANT: because control is transferred to `recipient`, care must be
51      * taken to not create reentrancy vulnerabilities. Consider using
52      * {ReentrancyGuard} or the
53      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
54      */
55     function sendValue(address payable recipient, uint256 amount) internal {
56         require(address(this).balance >= amount, "Address: insufficient balance");
57 
58         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
59         (bool success, ) = recipient.call{ value: amount }("");
60         require(success, "Address: unable to send value, recipient may have reverted");
61     }
62 
63     /**
64      * @dev Performs a Solidity function call using a low level `call`. A
65      * plain`call` is an unsafe replacement for a function call: use this
66      * function instead.
67      *
68      * If `target` reverts with a revert reason, it is bubbled up by this
69      * function (like regular Solidity function calls).
70      *
71      * Returns the raw returned data. To convert to the expected return value,
72      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
73      *
74      * Requirements:
75      *
76      * - `target` must be a contract.
77      * - calling `target` with `data` must not revert.
78      *
79      * _Available since v3.1._
80      */
81     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
82       return functionCall(target, data, "Address: low-level call failed");
83     }
84 
85     /**
86      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
87      * `errorMessage` as a fallback revert reason when `target` reverts.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
92         return functionCallWithValue(target, data, 0, errorMessage);
93     }
94 
95     /**
96      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
97      * but also transferring `value` wei to `target`.
98      *
99      * Requirements:
100      *
101      * - the calling contract must have an ETH balance of at least `value`.
102      * - the called Solidity function must be `payable`.
103      *
104      * _Available since v3.1._
105      */
106     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
112      * with `errorMessage` as a fallback revert reason when `target` reverts.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
117         require(address(this).balance >= value, "Address: insufficient balance for call");
118         require(isContract(target), "Address: call to non-contract");
119 
120         // solhint-disable-next-line avoid-low-level-calls
121         (bool success, bytes memory returndata) = target.call{ value: value }(data);
122         return _verifyCallResult(success, returndata, errorMessage);
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
127      * but performing a static call.
128      *
129      * _Available since v3.3._
130      */
131     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
132         return functionStaticCall(target, data, "Address: low-level static call failed");
133     }
134 
135     /**
136      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
137      * but performing a static call.
138      *
139      * _Available since v3.3._
140      */
141     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
142         require(isContract(target), "Address: static call to non-contract");
143 
144         // solhint-disable-next-line avoid-low-level-calls
145         (bool success, bytes memory returndata) = target.staticcall(data);
146         return _verifyCallResult(success, returndata, errorMessage);
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
151      * but performing a delegate call.
152      *
153      * _Available since v3.4._
154      */
155     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
156         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
161      * but performing a delegate call.
162      *
163      * _Available since v3.4._
164      */
165     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
166         require(isContract(target), "Address: delegate call to non-contract");
167 
168         // solhint-disable-next-line avoid-low-level-calls
169         (bool success, bytes memory returndata) = target.delegatecall(data);
170         return _verifyCallResult(success, returndata, errorMessage);
171     }
172 
173     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
174         if (success) {
175             return returndata;
176         } else {
177             // Look for revert reason and bubble it up if present
178             if (returndata.length > 0) {
179                 // The easiest way to bubble the revert reason is using memory via assembly
180 
181                 // solhint-disable-next-line no-inline-assembly
182                 assembly {
183                     let returndata_size := mload(returndata)
184                     revert(add(32, returndata), returndata_size)
185                 }
186             } else {
187                 revert(errorMessage);
188             }
189         }
190     }
191 }
192 
193 abstract contract Context {
194     function _msgSender() internal view virtual returns (address) {
195         return msg.sender;
196     }
197 
198     function _msgData() internal view virtual returns (bytes calldata) {
199         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
200         return msg.data;
201     }
202 }
203 
204 abstract contract Proxy {
205     /**
206      * @dev Delegates the current call to `implementation`.
207      *
208      * This function does not return to its internall call site, it will return directly to the external caller.
209      */
210     function _delegate(address implementation) internal virtual {
211         // solhint-disable-next-line no-inline-assembly
212         assembly {
213             // Copy msg.data. We take full control of memory in this inline assembly
214             // block because it will not return to Solidity code. We overwrite the
215             // Solidity scratch pad at memory position 0.
216             calldatacopy(0, 0, calldatasize())
217 
218             // Call the implementation.
219             // out and outsize are 0 because we don't know the size yet.
220             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
221 
222             // Copy the returned data.
223             returndatacopy(0, 0, returndatasize())
224 
225             switch result
226             // delegatecall returns 0 on error.
227             case 0 { revert(0, returndatasize()) }
228             default { return(0, returndatasize()) }
229         }
230     }
231 
232     /**
233      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
234      * and {_fallback} should delegate.
235      */
236     function _implementation() internal view virtual returns (address);
237 
238     /**
239      * @dev Delegates the current call to the address returned by `_implementation()`.
240      *
241      * This function does not return to its internall call site, it will return directly to the external caller.
242      */
243     function _fallback() internal virtual {
244         _beforeFallback();
245         _delegate(_implementation());
246     }
247 
248     /**
249      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
250      * function in the contract matches the call data.
251      */
252     fallback () external payable virtual {
253         _fallback();
254     }
255 
256     /**
257      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
258      * is empty.
259      */
260     receive () external payable virtual {
261         _fallback();
262     }
263 
264     /**
265      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
266      * call, or as part of the Solidity `fallback` or `receive` functions.
267      *
268      * If overriden should call `super._beforeFallback()`.
269      */
270     function _beforeFallback() internal virtual {
271     }
272 }
273 
274 abstract contract ERC1967Upgrade {
275     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
276     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
277 
278     /**
279      * @dev Storage slot with the address of the current implementation.
280      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
281      * validated in the constructor.
282      */
283     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
284 
285     /**
286      * @dev Emitted when the implementation is upgraded.
287      */
288     event Upgraded(address indexed implementation);
289 
290     /**
291      * @dev Returns the current implementation address.
292      */
293     function _getImplementation() internal view returns (address) {
294         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
295     }
296 
297     /**
298      * @dev Stores a new address in the EIP1967 implementation slot.
299      */
300     function _setImplementation(address newImplementation) private {
301         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
302         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
303     }
304 
305     /**
306      * @dev Perform implementation upgrade
307      *
308      * Emits an {Upgraded} event.
309      */
310     function _upgradeTo(address newImplementation) internal {
311         _setImplementation(newImplementation);
312         emit Upgraded(newImplementation);
313     }
314 
315     /**
316      * @dev Perform implementation upgrade with additional setup call.
317      *
318      * Emits an {Upgraded} event.
319      */
320     function _upgradeToAndCall(address newImplementation, bytes memory data, bool forceCall) internal {
321         _setImplementation(newImplementation);
322         emit Upgraded(newImplementation);
323         if (data.length > 0 || forceCall) {
324             Address.functionDelegateCall(newImplementation, data);
325         }
326     }
327 
328     /**
329      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
330      *
331      * Emits an {Upgraded} event.
332      */
333     function _upgradeToAndCallSecure(address newImplementation, bytes memory data, bool forceCall) internal {
334         address oldImplementation = _getImplementation();
335 
336         // Initial upgrade and setup call
337         _setImplementation(newImplementation);
338         if (data.length > 0 || forceCall) {
339             Address.functionDelegateCall(newImplementation, data);
340         }
341 
342         // Perform rollback test if not already in progress
343         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
344         if (!rollbackTesting.value) {
345             // Trigger rollback using upgradeTo from the new implementation
346             rollbackTesting.value = true;
347             Address.functionDelegateCall(
348                 newImplementation,
349                 abi.encodeWithSignature(
350                     "upgradeTo(address)",
351                     oldImplementation
352                 )
353             );
354             rollbackTesting.value = false;
355             // Check rollback was effective
356             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
357             // Finally reset to the new implementation and log the upgrade
358             _setImplementation(newImplementation);
359             emit Upgraded(newImplementation);
360         }
361     }
362 
363     /**
364      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
365      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
366      *
367      * Emits a {BeaconUpgraded} event.
368      */
369     function _upgradeBeaconToAndCall(address newBeacon, bytes memory data, bool forceCall) internal {
370         _setBeacon(newBeacon);
371         emit BeaconUpgraded(newBeacon);
372         if (data.length > 0 || forceCall) {
373             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
374         }
375     }
376 
377     /**
378      * @dev Storage slot with the admin of the contract.
379      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
380      * validated in the constructor.
381      */
382     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
383 
384     /**
385      * @dev Emitted when the admin account has changed.
386      */
387     event AdminChanged(address previousAdmin, address newAdmin);
388 
389     /**
390      * @dev Returns the current admin.
391      */
392     function _getAdmin() internal view returns (address) {
393         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
394     }
395 
396     /**
397      * @dev Stores a new address in the EIP1967 admin slot.
398      */
399     function _setAdmin(address newAdmin) private {
400         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
401         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
402     }
403 
404     /**
405      * @dev Changes the admin of the proxy.
406      *
407      * Emits an {AdminChanged} event.
408      */
409     function _changeAdmin(address newAdmin) internal {
410         emit AdminChanged(_getAdmin(), newAdmin);
411         _setAdmin(newAdmin);
412     }
413 
414     /**
415      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
416      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
417      */
418     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
419 
420     /**
421      * @dev Emitted when the beacon is upgraded.
422      */
423     event BeaconUpgraded(address indexed beacon);
424 
425     /**
426      * @dev Returns the current beacon.
427      */
428     function _getBeacon() internal view returns (address) {
429         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
430     }
431 
432     /**
433      * @dev Stores a new beacon in the EIP1967 beacon slot.
434      */
435     function _setBeacon(address newBeacon) private {
436         require(
437             Address.isContract(newBeacon),
438             "ERC1967: new beacon is not a contract"
439         );
440         require(
441             Address.isContract(IBeacon(newBeacon).implementation()),
442             "ERC1967: beacon implementation is not a contract"
443         );
444         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
445     }
446 }
447 
448 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
449     /**
450      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
451      *
452      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
453      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
454      */
455     constructor(address _logic, bytes memory _data) payable {
456         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
457         _upgradeToAndCall(_logic, _data, false);
458     }
459 
460     /**
461      * @dev Returns the current implementation address.
462      */
463     function _implementation() internal view virtual override returns (address impl) {
464         return ERC1967Upgrade._getImplementation();
465     }
466 }
467 
468 interface IBeacon {
469     /**
470      * @dev Must return an address that can be used as a delegate call target.
471      *
472      * {BeaconProxy} will check that this address is a contract.
473      */
474     function implementation() external view returns (address);
475 }
476 
477 abstract contract Ownable is Context {
478     address private _owner;
479 
480     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
481 
482     /**
483      * @dev Initializes the contract setting the deployer as the initial owner.
484      */
485     constructor () {
486         address msgSender = _msgSender();
487         _owner = msgSender;
488         emit OwnershipTransferred(address(0), msgSender);
489     }
490 
491     /**
492      * @dev Returns the address of the current owner.
493      */
494     function owner() public view virtual returns (address) {
495         return _owner;
496     }
497 
498     /**
499      * @dev Throws if called by any account other than the owner.
500      */
501     modifier onlyOwner() {
502         require(owner() == _msgSender(), "Ownable: caller is not the owner");
503         _;
504     }
505 
506     /**
507      * @dev Leaves the contract without owner. It will not be possible to call
508      * `onlyOwner` functions anymore. Can only be called by the current owner.
509      *
510      * NOTE: Renouncing ownership will leave the contract without an owner,
511      * thereby removing any functionality that is only available to the owner.
512      */
513     function renounceOwnership() public virtual onlyOwner {
514         emit OwnershipTransferred(_owner, address(0));
515         _owner = address(0);
516     }
517 
518     /**
519      * @dev Transfers ownership of the contract to a new account (`newOwner`).
520      * Can only be called by the current owner.
521      */
522     function transferOwnership(address newOwner) public virtual onlyOwner {
523         require(newOwner != address(0), "Ownable: new owner is the zero address");
524         emit OwnershipTransferred(_owner, newOwner);
525         _owner = newOwner;
526     }
527 }
528 
529 abstract contract UUPSUpgradeable is ERC1967Upgrade {
530     function upgradeTo(address newImplementation) external virtual {
531         _authorizeUpgrade(newImplementation);
532         _upgradeToAndCallSecure(newImplementation, bytes(""), false);
533     }
534 
535     function upgradeToAndCall(address newImplementation, bytes memory data) external payable virtual {
536         _authorizeUpgrade(newImplementation);
537         _upgradeToAndCallSecure(newImplementation, data, true);
538     }
539 
540     function _authorizeUpgrade(address newImplementation) internal virtual;
541 }
542 
543 abstract contract Proxiable is UUPSUpgradeable {
544     function _authorizeUpgrade(address newImplementation) internal override {
545         _beforeUpgrade(newImplementation);
546     }
547 
548     function _beforeUpgrade(address newImplementation) internal virtual;
549 }
550 
551 contract ChildOfProxiable is Proxiable {
552     function _beforeUpgrade(address newImplementation) internal virtual override {}
553 }
554 
555 contract ProxyAdmin is Ownable {
556 
557     /**
558      * @dev Returns the current implementation of `proxy`.
559      *
560      * Requirements:
561      *
562      * - This contract must be the admin of `proxy`.
563      */
564     function getProxyImplementation(TransparentUpgradeableProxy proxy) public view virtual returns (address) {
565         // We need to manually run the static call since the getter cannot be flagged as view
566         // bytes4(keccak256("implementation()")) == 0x5c60da1b
567         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"5c60da1b");
568         require(success);
569         return abi.decode(returndata, (address));
570     }
571 
572     /**
573      * @dev Returns the current admin of `proxy`.
574      *
575      * Requirements:
576      *
577      * - This contract must be the admin of `proxy`.
578      */
579     function getProxyAdmin(TransparentUpgradeableProxy proxy) public view virtual returns (address) {
580         // We need to manually run the static call since the getter cannot be flagged as view
581         // bytes4(keccak256("admin()")) == 0xf851a440
582         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"f851a440");
583         require(success);
584         return abi.decode(returndata, (address));
585     }
586 
587     /**
588      * @dev Changes the admin of `proxy` to `newAdmin`.
589      *
590      * Requirements:
591      *
592      * - This contract must be the current admin of `proxy`.
593      */
594     function changeProxyAdmin(TransparentUpgradeableProxy proxy, address newAdmin) public virtual onlyOwner {
595         proxy.changeAdmin(newAdmin);
596     }
597 
598     /**
599      * @dev Upgrades `proxy` to `implementation`. See {TransparentUpgradeableProxy-upgradeTo}.
600      *
601      * Requirements:
602      *
603      * - This contract must be the admin of `proxy`.
604      */
605     function upgrade(TransparentUpgradeableProxy proxy, address implementation) public virtual onlyOwner {
606         proxy.upgradeTo(implementation);
607     }
608 
609     /**
610      * @dev Upgrades `proxy` to `implementation` and calls a function on the new implementation. See
611      * {TransparentUpgradeableProxy-upgradeToAndCall}.
612      *
613      * Requirements:
614      *
615      * - This contract must be the admin of `proxy`.
616      */
617     function upgradeAndCall(TransparentUpgradeableProxy proxy, address implementation, bytes memory data) public payable virtual onlyOwner {
618         proxy.upgradeToAndCall{value: msg.value}(implementation, data);
619     }
620 }
621 
622 library StorageSlot {
623     struct AddressSlot {
624         address value;
625     }
626 
627     struct BooleanSlot {
628         bool value;
629     }
630 
631     struct Bytes32Slot {
632         bytes32 value;
633     }
634 
635     struct Uint256Slot {
636         uint256 value;
637     }
638 
639     /**
640      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
641      */
642     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
643         assembly {
644             r.slot := slot
645         }
646     }
647 
648     /**
649      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
650      */
651     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
652         assembly {
653             r.slot := slot
654         }
655     }
656 
657     /**
658      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
659      */
660     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
661         assembly {
662             r.slot := slot
663         }
664     }
665 
666     /**
667      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
668      */
669     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
670         assembly {
671             r.slot := slot
672         }
673     }
674 }
675 
676 contract TransparentUpgradeableProxy is ERC1967Proxy {
677     /**
678      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
679      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
680      */
681     constructor(address _logic, address admin_, bytes memory _data) payable ERC1967Proxy(_logic, _data) {
682         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
683         _changeAdmin(admin_);
684     }
685 
686     /**
687      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
688      */
689     modifier ifAdmin() {
690         if (msg.sender == _getAdmin()) {
691             _;
692         } else {
693             _fallback();
694         }
695     }
696 
697     /**
698      * @dev Returns the current admin.
699      *
700      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
701      *
702      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
703      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
704      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
705      */
706     function admin() external ifAdmin returns (address admin_) {
707         admin_ = _getAdmin();
708     }
709 
710     /**
711      * @dev Returns the current implementation.
712      *
713      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
714      *
715      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
716      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
717      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
718      */
719     function implementation() external ifAdmin returns (address implementation_) {
720         implementation_ = _implementation();
721     }
722 
723     /**
724      * @dev Changes the admin of the proxy.
725      *
726      * Emits an {AdminChanged} event.
727      *
728      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
729      */
730     function changeAdmin(address newAdmin) external virtual ifAdmin {
731         _changeAdmin(newAdmin);
732     }
733 
734     /**
735      * @dev Upgrade the implementation of the proxy.
736      *
737      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
738      */
739     function upgradeTo(address newImplementation) external ifAdmin {
740         _upgradeToAndCall(newImplementation, bytes(""), false);
741     }
742 
743     /**
744      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
745      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
746      * proxied contract.
747      *
748      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
749      */
750     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
751         _upgradeToAndCall(newImplementation, data, true);
752     }
753 
754     /**
755      * @dev Returns the current admin.
756      */
757     function _admin() internal view virtual returns (address) {
758         return _getAdmin();
759     }
760 
761     /**
762      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
763      */
764     function _beforeFallback() internal virtual override {
765         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
766         super._beforeFallback();
767     }
768 }
769 // Kept for backwards compatibility with older versions of Hardhat and Truffle plugins.
770 contract AdminUpgradeabilityProxy is TransparentUpgradeableProxy {
771     constructor(address logic, address admin, bytes memory data) payable TransparentUpgradeableProxy(logic, admin, data) {}
772 }