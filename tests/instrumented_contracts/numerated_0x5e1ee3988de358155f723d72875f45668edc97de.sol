1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-22
3 */
4 
5 // SPDX-License-Identifier: MIT
6 /*
7 made by COOL0312, jug200712
8 2022.01.22
9 **/
10 
11 pragma solidity ^0.8.0;
12 
13 
14 library Address {
15     /**
16      * @dev Returns true if `account` is a contract.
17      *
18      * [IMPORTANT]
19      * ====
20      * It is unsafe to assume that an address for which this function returns
21      * false is an externally-owned account (EOA) and not a contract.
22      *
23      * Among others, `isContract` will return false for the following
24      * types of addresses:
25      *
26      *  - an externally-owned account
27      *  - a contract in construction
28      *  - an address where a contract will be created
29      *  - an address where a contract lived, but was destroyed
30      * ====
31      */
32     function isContract(address account) internal view returns (bool) {
33         // This method relies on extcodesize, which returns 0 for contracts in
34         // construction, since the code is only stored at the end of the
35         // constructor execution.
36 
37         uint256 size;
38         // solhint-disable-next-line no-inline-assembly
39         assembly { size := extcodesize(account) }
40         return size > 0;
41     }
42 
43     /**
44      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
45      * `recipient`, forwarding all available gas and reverting on errors.
46      *
47      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
48      * of certain opcodes, possibly making contracts go over the 2300 gas limit
49      * imposed by `transfer`, making them unable to receive funds via
50      * `transfer`. {sendValue} removes this limitation.
51      *
52      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
53      *
54      * IMPORTANT: because control is transferred to `recipient`, care must be
55      * taken to not create reentrancy vulnerabilities. Consider using
56      * {ReentrancyGuard} or the
57      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
58      */
59     function sendValue(address payable recipient, uint256 amount) internal {
60         require(address(this).balance >= amount, "Address: insufficient balance");
61 
62         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
63         (bool success, ) = recipient.call{ value: amount }("");
64         require(success, "Address: unable to send value, recipient may have reverted");
65     }
66 
67     /**
68      * @dev Performs a Solidity function call using a low level `call`. A
69      * plain`call` is an unsafe replacement for a function call: use this
70      * function instead.
71      *
72      * If `target` reverts with a revert reason, it is bubbled up by this
73      * function (like regular Solidity function calls).
74      *
75      * Returns the raw returned data. To convert to the expected return value,
76      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
77      *
78      * Requirements:
79      *
80      * - `target` must be a contract.
81      * - calling `target` with `data` must not revert.
82      *
83      * _Available since v3.1._
84      */
85     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
86       return functionCall(target, data, "Address: low-level call failed");
87     }
88 
89     /**
90      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
91      * `errorMessage` as a fallback revert reason when `target` reverts.
92      *
93      * _Available since v3.1._
94      */
95     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
96         return functionCallWithValue(target, data, 0, errorMessage);
97     }
98 
99     /**
100      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
101      * but also transferring `value` wei to `target`.
102      *
103      * Requirements:
104      *
105      * - the calling contract must have an ETH balance of at least `value`.
106      * - the called Solidity function must be `payable`.
107      *
108      * _Available since v3.1._
109      */
110     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
111         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
112     }
113 
114     /**
115      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
116      * with `errorMessage` as a fallback revert reason when `target` reverts.
117      *
118      * _Available since v3.1._
119      */
120     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
121         require(address(this).balance >= value, "Address: insufficient balance for call");
122         require(isContract(target), "Address: call to non-contract");
123 
124         // solhint-disable-next-line avoid-low-level-calls
125         (bool success, bytes memory returndata) = target.call{ value: value }(data);
126         return _verifyCallResult(success, returndata, errorMessage);
127     }
128 
129     /**
130      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
131      * but performing a static call.
132      *
133      * _Available since v3.3._
134      */
135     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
136         return functionStaticCall(target, data, "Address: low-level static call failed");
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
141      * but performing a static call.
142      *
143      * _Available since v3.3._
144      */
145     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
146         require(isContract(target), "Address: static call to non-contract");
147 
148         // solhint-disable-next-line avoid-low-level-calls
149         (bool success, bytes memory returndata) = target.staticcall(data);
150         return _verifyCallResult(success, returndata, errorMessage);
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
155      * but performing a delegate call.
156      *
157      * _Available since v3.4._
158      */
159     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
160         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
165      * but performing a delegate call.
166      *
167      * _Available since v3.4._
168      */
169     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
170         require(isContract(target), "Address: delegate call to non-contract");
171 
172         // solhint-disable-next-line avoid-low-level-calls
173         (bool success, bytes memory returndata) = target.delegatecall(data);
174         return _verifyCallResult(success, returndata, errorMessage);
175     }
176 
177     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
178         if (success) {
179             return returndata;
180         } else {
181             // Look for revert reason and bubble it up if present
182             if (returndata.length > 0) {
183                 // The easiest way to bubble the revert reason is using memory via assembly
184 
185                 // solhint-disable-next-line no-inline-assembly
186                 assembly {
187                     let returndata_size := mload(returndata)
188                     revert(add(32, returndata), returndata_size)
189                 }
190             } else {
191                 revert(errorMessage);
192             }
193         }
194     }
195 }
196 
197 abstract contract Context {
198     function _msgSender() internal view virtual returns (address) {
199         return msg.sender;
200     }
201 
202     function _msgData() internal view virtual returns (bytes calldata) {
203         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
204         return msg.data;
205     }
206 }
207 
208 abstract contract Proxy {
209     /**
210      * @dev Delegates the current call to `implementation`.
211      *
212      * This function does not return to its internall call site, it will return directly to the external caller.
213      */
214     function _delegate(address implementation) internal virtual {
215         // solhint-disable-next-line no-inline-assembly
216         assembly {
217             // Copy msg.data. We take full control of memory in this inline assembly
218             // block because it will not return to Solidity code. We overwrite the
219             // Solidity scratch pad at memory position 0.
220             calldatacopy(0, 0, calldatasize())
221 
222             // Call the implementation.
223             // out and outsize are 0 because we don't know the size yet.
224             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
225 
226             // Copy the returned data.
227             returndatacopy(0, 0, returndatasize())
228 
229             switch result
230             // delegatecall returns 0 on error.
231             case 0 { revert(0, returndatasize()) }
232             default { return(0, returndatasize()) }
233         }
234     }
235 
236     /**
237      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
238      * and {_fallback} should delegate.
239      */
240     function _implementation() internal view virtual returns (address);
241 
242     /**
243      * @dev Delegates the current call to the address returned by `_implementation()`.
244      *
245      * This function does not return to its internall call site, it will return directly to the external caller.
246      */
247     function _fallback() internal virtual {
248         _beforeFallback();
249         _delegate(_implementation());
250     }
251 
252     /**
253      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
254      * function in the contract matches the call data.
255      */
256     fallback () external payable virtual {
257         _fallback();
258     }
259 
260     /**
261      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
262      * is empty.
263      */
264     receive () external payable virtual {
265         _fallback();
266     }
267 
268     /**
269      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
270      * call, or as part of the Solidity `fallback` or `receive` functions.
271      *
272      * If overriden should call `super._beforeFallback()`.
273      */
274     function _beforeFallback() internal virtual {
275     }
276 }
277 
278 abstract contract ERC1967Upgrade {
279     // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
280     bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;
281 
282     /**
283      * @dev Storage slot with the address of the current implementation.
284      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
285      * validated in the constructor.
286      */
287     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
288 
289     /**
290      * @dev Emitted when the implementation is upgraded.
291      */
292     event Upgraded(address indexed implementation);
293 
294     /**
295      * @dev Returns the current implementation address.
296      */
297     function _getImplementation() internal view returns (address) {
298         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
299     }
300 
301     /**
302      * @dev Stores a new address in the EIP1967 implementation slot.
303      */
304     function _setImplementation(address newImplementation) private {
305         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
306         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
307     }
308 
309     /**
310      * @dev Perform implementation upgrade
311      *
312      * Emits an {Upgraded} event.
313      */
314     function _upgradeTo(address newImplementation) internal {
315         _setImplementation(newImplementation);
316         emit Upgraded(newImplementation);
317     }
318 
319     /**
320      * @dev Perform implementation upgrade with additional setup call.
321      *
322      * Emits an {Upgraded} event.
323      */
324     function _upgradeToAndCall(address newImplementation, bytes memory data, bool forceCall) internal {
325         _setImplementation(newImplementation);
326         emit Upgraded(newImplementation);
327         if (data.length > 0 || forceCall) {
328             Address.functionDelegateCall(newImplementation, data);
329         }
330     }
331 
332     /**
333      * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
334      *
335      * Emits an {Upgraded} event.
336      */
337     function _upgradeToAndCallSecure(address newImplementation, bytes memory data, bool forceCall) internal {
338         address oldImplementation = _getImplementation();
339 
340         // Initial upgrade and setup call
341         _setImplementation(newImplementation);
342         if (data.length > 0 || forceCall) {
343             Address.functionDelegateCall(newImplementation, data);
344         }
345 
346         // Perform rollback test if not already in progress
347         StorageSlot.BooleanSlot storage rollbackTesting = StorageSlot.getBooleanSlot(_ROLLBACK_SLOT);
348         if (!rollbackTesting.value) {
349             // Trigger rollback using upgradeTo from the new implementation
350             rollbackTesting.value = true;
351             Address.functionDelegateCall(
352                 newImplementation,
353                 abi.encodeWithSignature(
354                     "upgradeTo(address)",
355                     oldImplementation
356                 )
357             );
358             rollbackTesting.value = false;
359             // Check rollback was effective
360             require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
361             // Finally reset to the new implementation and log the upgrade
362             _setImplementation(newImplementation);
363             emit Upgraded(newImplementation);
364         }
365     }
366 
367     /**
368      * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
369      * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
370      *
371      * Emits a {BeaconUpgraded} event.
372      */
373     function _upgradeBeaconToAndCall(address newBeacon, bytes memory data, bool forceCall) internal {
374         _setBeacon(newBeacon);
375         emit BeaconUpgraded(newBeacon);
376         if (data.length > 0 || forceCall) {
377             Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
378         }
379     }
380 
381     /**
382      * @dev Storage slot with the admin of the contract.
383      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
384      * validated in the constructor.
385      */
386     bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
387 
388     /**
389      * @dev Emitted when the admin account has changed.
390      */
391     event AdminChanged(address previousAdmin, address newAdmin);
392 
393     /**
394      * @dev Returns the current admin.
395      */
396     function _getAdmin() internal view returns (address) {
397         return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
398     }
399 
400     /**
401      * @dev Stores a new address in the EIP1967 admin slot.
402      */
403     function _setAdmin(address newAdmin) private {
404         require(newAdmin != address(0), "ERC1967: new admin is the zero address");
405         StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
406     }
407 
408     /**
409      * @dev Changes the admin of the proxy.
410      *
411      * Emits an {AdminChanged} event.
412      */
413     function _changeAdmin(address newAdmin) internal {
414         emit AdminChanged(_getAdmin(), newAdmin);
415         _setAdmin(newAdmin);
416     }
417 
418     /**
419      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
420      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
421      */
422     bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
423 
424     /**
425      * @dev Emitted when the beacon is upgraded.
426      */
427     event BeaconUpgraded(address indexed beacon);
428 
429     /**
430      * @dev Returns the current beacon.
431      */
432     function _getBeacon() internal view returns (address) {
433         return StorageSlot.getAddressSlot(_BEACON_SLOT).value;
434     }
435 
436     /**
437      * @dev Stores a new beacon in the EIP1967 beacon slot.
438      */
439     function _setBeacon(address newBeacon) private {
440         require(
441             Address.isContract(newBeacon),
442             "ERC1967: new beacon is not a contract"
443         );
444         require(
445             Address.isContract(IBeacon(newBeacon).implementation()),
446             "ERC1967: beacon implementation is not a contract"
447         );
448         StorageSlot.getAddressSlot(_BEACON_SLOT).value = newBeacon;
449     }
450 }
451 
452 contract ERC1967Proxy is Proxy, ERC1967Upgrade {
453     /**
454      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
455      *
456      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
457      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
458      */
459     constructor(address _logic, bytes memory _data) payable {
460         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
461         _upgradeToAndCall(_logic, _data, false);
462     }
463 
464     /**
465      * @dev Returns the current implementation address.
466      */
467     function _implementation() internal view virtual override returns (address impl) {
468         return ERC1967Upgrade._getImplementation();
469     }
470 }
471 
472 interface IBeacon {
473     /**
474      * @dev Must return an address that can be used as a delegate call target.
475      *
476      * {BeaconProxy} will check that this address is a contract.
477      */
478     function implementation() external view returns (address);
479 }
480 
481 abstract contract Ownable is Context {
482     address private _owner;
483 
484     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
485 
486     /**
487      * @dev Initializes the contract setting the deployer as the initial owner.
488      */
489     constructor () {
490         address msgSender = _msgSender();
491         _owner = msgSender;
492         emit OwnershipTransferred(address(0), msgSender);
493     }
494 
495     /**
496      * @dev Returns the address of the current owner.
497      */
498     function owner() public view virtual returns (address) {
499         return _owner;
500     }
501 
502     /**
503      * @dev Throws if called by any account other than the owner.
504      */
505     modifier onlyOwner() {
506         require(owner() == _msgSender(), "Ownable: caller is not the owner");
507         _;
508     }
509 
510     /**
511      * @dev Leaves the contract without owner. It will not be possible to call
512      * `onlyOwner` functions anymore. Can only be called by the current owner.
513      *
514      * NOTE: Renouncing ownership will leave the contract without an owner,
515      * thereby removing any functionality that is only available to the owner.
516      */
517     function renounceOwnership() public virtual onlyOwner {
518         emit OwnershipTransferred(_owner, address(0));
519         _owner = address(0);
520     }
521 
522     /**
523      * @dev Transfers ownership of the contract to a new account (`newOwner`).
524      * Can only be called by the current owner.
525      */
526     function transferOwnership(address newOwner) public virtual onlyOwner {
527         require(newOwner != address(0), "Ownable: new owner is the zero address");
528         emit OwnershipTransferred(_owner, newOwner);
529         _owner = newOwner;
530     }
531 }
532 
533 abstract contract UUPSUpgradeable is ERC1967Upgrade {
534     function upgradeTo(address newImplementation) external virtual {
535         _authorizeUpgrade(newImplementation);
536         _upgradeToAndCallSecure(newImplementation, bytes(""), false);
537     }
538 
539     function upgradeToAndCall(address newImplementation, bytes memory data) external payable virtual {
540         _authorizeUpgrade(newImplementation);
541         _upgradeToAndCallSecure(newImplementation, data, true);
542     }
543 
544     function _authorizeUpgrade(address newImplementation) internal virtual;
545 }
546 
547 abstract contract Proxiable is UUPSUpgradeable {
548     function _authorizeUpgrade(address newImplementation) internal override {
549         _beforeUpgrade(newImplementation);
550     }
551 
552     function _beforeUpgrade(address newImplementation) internal virtual;
553 }
554 
555 contract ChildOfProxiable is Proxiable {
556     function _beforeUpgrade(address newImplementation) internal virtual override {}
557 }
558 
559 contract ProxyAdmin is Ownable {
560 
561     /**
562      * @dev Returns the current implementation of `proxy`.
563      *
564      * Requirements:
565      *
566      * - This contract must be the admin of `proxy`.
567      */
568     function getProxyImplementation(TransparentUpgradeableProxy proxy) public view virtual returns (address) {
569         // We need to manually run the static call since the getter cannot be flagged as view
570         // bytes4(keccak256("implementation()")) == 0x5c60da1b
571         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"5c60da1b");
572         require(success);
573         return abi.decode(returndata, (address));
574     }
575 
576     /**
577      * @dev Returns the current admin of `proxy`.
578      *
579      * Requirements:
580      *
581      * - This contract must be the admin of `proxy`.
582      */
583     function getProxyAdmin(TransparentUpgradeableProxy proxy) public view virtual returns (address) {
584         // We need to manually run the static call since the getter cannot be flagged as view
585         // bytes4(keccak256("admin()")) == 0xf851a440
586         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"f851a440");
587         require(success);
588         return abi.decode(returndata, (address));
589     }
590 
591     /**
592      * @dev Changes the admin of `proxy` to `newAdmin`.
593      *
594      * Requirements:
595      *
596      * - This contract must be the current admin of `proxy`.
597      */
598     function changeProxyAdmin(TransparentUpgradeableProxy proxy, address newAdmin) public virtual onlyOwner {
599         proxy.changeAdmin(newAdmin);
600     }
601 
602     /**
603      * @dev Upgrades `proxy` to `implementation`. See {TransparentUpgradeableProxy-upgradeTo}.
604      *
605      * Requirements:
606      *
607      * - This contract must be the admin of `proxy`.
608      */
609     function upgrade(TransparentUpgradeableProxy proxy, address implementation) public virtual onlyOwner {
610         proxy.upgradeTo(implementation);
611     }
612 
613     /**
614      * @dev Upgrades `proxy` to `implementation` and calls a function on the new implementation. See
615      * {TransparentUpgradeableProxy-upgradeToAndCall}.
616      *
617      * Requirements:
618      *
619      * - This contract must be the admin of `proxy`.
620      */
621     function upgradeAndCall(TransparentUpgradeableProxy proxy, address implementation, bytes memory data) public payable virtual onlyOwner {
622         proxy.upgradeToAndCall{value: msg.value}(implementation, data);
623     }
624 }
625 
626 library StorageSlot {
627     struct AddressSlot {
628         address value;
629     }
630 
631     struct BooleanSlot {
632         bool value;
633     }
634 
635     struct Bytes32Slot {
636         bytes32 value;
637     }
638 
639     struct Uint256Slot {
640         uint256 value;
641     }
642 
643     /**
644      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
645      */
646     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
647         assembly {
648             r.slot := slot
649         }
650     }
651 
652     /**
653      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
654      */
655     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
656         assembly {
657             r.slot := slot
658         }
659     }
660 
661     /**
662      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
663      */
664     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
665         assembly {
666             r.slot := slot
667         }
668     }
669 
670     /**
671      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
672      */
673     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
674         assembly {
675             r.slot := slot
676         }
677     }
678 }
679 
680 contract TransparentUpgradeableProxy is ERC1967Proxy {
681     /**
682      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
683      * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
684      */
685     constructor(address _logic, address admin_, bytes memory _data) payable ERC1967Proxy(_logic, _data) {
686         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
687         _changeAdmin(admin_);
688     }
689 
690     /**
691      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
692      */
693     modifier ifAdmin() {
694         if (msg.sender == _getAdmin()) {
695             _;
696         } else {
697             _fallback();
698         }
699     }
700 
701     /**
702      * @dev Returns the current admin.
703      *
704      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
705      *
706      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
707      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
708      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
709      */
710     function admin() external ifAdmin returns (address admin_) {
711         admin_ = _getAdmin();
712     }
713 
714     /**
715      * @dev Returns the current implementation.
716      *
717      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
718      *
719      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
720      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
721      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
722      */
723     function implementation() external ifAdmin returns (address implementation_) {
724         implementation_ = _implementation();
725     }
726 
727     /**
728      * @dev Changes the admin of the proxy.
729      *
730      * Emits an {AdminChanged} event.
731      *
732      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
733      */
734     function changeAdmin(address newAdmin) external virtual ifAdmin {
735         _changeAdmin(newAdmin);
736     }
737 
738     /**
739      * @dev Upgrade the implementation of the proxy.
740      *
741      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
742      */
743     function upgradeTo(address newImplementation) external ifAdmin {
744         _upgradeToAndCall(newImplementation, bytes(""), false);
745     }
746 
747     /**
748      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
749      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
750      * proxied contract.
751      *
752      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
753      */
754     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
755         _upgradeToAndCall(newImplementation, data, true);
756     }
757 
758     /**
759      * @dev Returns the current admin.
760      */
761     function _admin() internal view virtual returns (address) {
762         return _getAdmin();
763     }
764 
765     /**
766      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
767      */
768     function _beforeFallback() internal virtual override {
769         require(msg.sender != _getAdmin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
770         super._beforeFallback();
771     }
772 }
773 // Kept for backwards compatibility with older versions of Hardhat and Truffle plugins.
774 contract AdminUpgradeabilityProxy is TransparentUpgradeableProxy {
775     constructor(address logic, address admin, bytes memory data) payable TransparentUpgradeableProxy(logic, admin, data) {}
776 }