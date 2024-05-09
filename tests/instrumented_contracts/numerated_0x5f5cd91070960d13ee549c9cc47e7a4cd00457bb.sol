1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor () internal {
46         address msgSender = _msgSender();
47         _owner = msgSender;
48         emit OwnershipTransferred(address(0), msgSender);
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(_owner == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         emit OwnershipTransferred(_owner, newOwner);
85         _owner = newOwner;
86     }
87 }
88 
89 /**
90  * @dev Collection of functions related to the address type
91  */
92 library Address {
93     /**
94      * @dev Returns true if `account` is a contract.
95      *
96      * [IMPORTANT]
97      * ====
98      * It is unsafe to assume that an address for which this function returns
99      * false is an externally-owned account (EOA) and not a contract.
100      *
101      * Among others, `isContract` will return false for the following
102      * types of addresses:
103      *
104      *  - an externally-owned account
105      *  - a contract in construction
106      *  - an address where a contract will be created
107      *  - an address where a contract lived, but was destroyed
108      * ====
109      */
110     function isContract(address account) internal view returns (bool) {
111         // This method relies on extcodesize, which returns 0 for contracts in
112         // construction, since the code is only stored at the end of the
113         // constructor execution.
114 
115         uint256 size;
116         // solhint-disable-next-line no-inline-assembly
117         assembly { size := extcodesize(account) }
118         return size > 0;
119     }
120 
121     /**
122      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
123      * `recipient`, forwarding all available gas and reverting on errors.
124      *
125      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
126      * of certain opcodes, possibly making contracts go over the 2300 gas limit
127      * imposed by `transfer`, making them unable to receive funds via
128      * `transfer`. {sendValue} removes this limitation.
129      *
130      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
131      *
132      * IMPORTANT: because control is transferred to `recipient`, care must be
133      * taken to not create reentrancy vulnerabilities. Consider using
134      * {ReentrancyGuard} or the
135      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
136      */
137     function sendValue(address payable recipient, uint256 amount) internal {
138         require(address(this).balance >= amount, "Address: insufficient balance");
139 
140         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
141         (bool success, ) = recipient.call{ value: amount }("");
142         require(success, "Address: unable to send value, recipient may have reverted");
143     }
144 
145     /**
146      * @dev Performs a Solidity function call using a low level `call`. A
147      * plain`call` is an unsafe replacement for a function call: use this
148      * function instead.
149      *
150      * If `target` reverts with a revert reason, it is bubbled up by this
151      * function (like regular Solidity function calls).
152      *
153      * Returns the raw returned data. To convert to the expected return value,
154      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
155      *
156      * Requirements:
157      *
158      * - `target` must be a contract.
159      * - calling `target` with `data` must not revert.
160      *
161      * _Available since v3.1._
162      */
163     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
164       return functionCall(target, data, "Address: low-level call failed");
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
169      * `errorMessage` as a fallback revert reason when `target` reverts.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
174         return functionCallWithValue(target, data, 0, errorMessage);
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
179      * but also transferring `value` wei to `target`.
180      *
181      * Requirements:
182      *
183      * - the calling contract must have an ETH balance of at least `value`.
184      * - the called Solidity function must be `payable`.
185      *
186      * _Available since v3.1._
187      */
188     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
194      * with `errorMessage` as a fallback revert reason when `target` reverts.
195      *
196      * _Available since v3.1._
197      */
198     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
199         require(address(this).balance >= value, "Address: insufficient balance for call");
200         require(isContract(target), "Address: call to non-contract");
201 
202         // solhint-disable-next-line avoid-low-level-calls
203         (bool success, bytes memory returndata) = target.call{ value: value }(data);
204         return _verifyCallResult(success, returndata, errorMessage);
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
209      * but performing a static call.
210      *
211      * _Available since v3.3._
212      */
213     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
214         return functionStaticCall(target, data, "Address: low-level static call failed");
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
219      * but performing a static call.
220      *
221      * _Available since v3.3._
222      */
223     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
224         require(isContract(target), "Address: static call to non-contract");
225 
226         // solhint-disable-next-line avoid-low-level-calls
227         (bool success, bytes memory returndata) = target.staticcall(data);
228         return _verifyCallResult(success, returndata, errorMessage);
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
233      * but performing a delegate call.
234      *
235      * _Available since v3.3._
236      */
237     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
238         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
243      * but performing a delegate call.
244      *
245      * _Available since v3.3._
246      */
247     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
248         require(isContract(target), "Address: delegate call to non-contract");
249 
250         // solhint-disable-next-line avoid-low-level-calls
251         (bool success, bytes memory returndata) = target.delegatecall(data);
252         return _verifyCallResult(success, returndata, errorMessage);
253     }
254 
255     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
256         if (success) {
257             return returndata;
258         } else {
259             // Look for revert reason and bubble it up if present
260             if (returndata.length > 0) {
261                 // The easiest way to bubble the revert reason is using memory via assembly
262 
263                 // solhint-disable-next-line no-inline-assembly
264                 assembly {
265                     let returndata_size := mload(returndata)
266                     revert(add(32, returndata), returndata_size)
267                 }
268             } else {
269                 revert(errorMessage);
270             }
271         }
272     }
273 }
274 
275 /**
276  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
277  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
278  * be specified by overriding the virtual {_implementation} function.
279  * 
280  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
281  * different contract through the {_delegate} function.
282  * 
283  * The success and return data of the delegated call will be returned back to the caller of the proxy.
284  */
285 abstract contract Proxy {
286     /**
287      * @dev Delegates the current call to `implementation`.
288      * 
289      * This function does not return to its internall call site, it will return directly to the external caller.
290      */
291     function _delegate(address implementation) internal {
292         // solhint-disable-next-line no-inline-assembly
293         assembly {
294             // Copy msg.data. We take full control of memory in this inline assembly
295             // block because it will not return to Solidity code. We overwrite the
296             // Solidity scratch pad at memory position 0.
297             calldatacopy(0, 0, calldatasize())
298 
299             // Call the implementation.
300             // out and outsize are 0 because we don't know the size yet.
301             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
302 
303             // Copy the returned data.
304             returndatacopy(0, 0, returndatasize())
305 
306             switch result
307             // delegatecall returns 0 on error.
308             case 0 { revert(0, returndatasize()) }
309             default { return(0, returndatasize()) }
310         }
311     }
312 
313     /**
314      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
315      * and {_fallback} should delegate.
316      */
317     function _implementation() internal virtual view returns (address);
318 
319     /**
320      * @dev Delegates the current call to the address returned by `_implementation()`.
321      * 
322      * This function does not return to its internall call site, it will return directly to the external caller.
323      */
324     function _fallback() internal {
325         _beforeFallback();
326         _delegate(_implementation());
327     }
328 
329     /**
330      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
331      * function in the contract matches the call data.
332      */
333     fallback () external payable {
334         _fallback();
335     }
336 
337     /**
338      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
339      * is empty.
340      */
341     receive () external payable {
342         _fallback();
343     }
344 
345     /**
346      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
347      * call, or as part of the Solidity `fallback` or `receive` functions.
348      * 
349      * If overriden should call `super._beforeFallback()`.
350      */
351     function _beforeFallback() internal virtual {
352     }
353 }
354 
355 /**
356  * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
357  * implementation address that can be changed. This address is stored in storage in the location specified by
358  * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
359  * implementation behind the proxy.
360  * 
361  * Upgradeability is only provided internally through {_upgradeTo}. For an externally upgradeable proxy see
362  * {TransparentUpgradeableProxy}.
363  */
364 contract UpgradeableProxy is Proxy {
365     /**
366      * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
367      * 
368      * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
369      * function call, and allows initializating the storage of the proxy like a Solidity constructor.
370      */
371     constructor(address _logic, bytes memory _data) public payable {
372         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
373         _setImplementation(_logic);
374         if(_data.length > 0) {
375             // solhint-disable-next-line avoid-low-level-calls
376             (bool success,) = _logic.delegatecall(_data);
377             require(success);
378         }
379     }
380 
381     /**
382      * @dev Emitted when the implementation is upgraded.
383      */
384     event Upgraded(address indexed implementation);
385 
386     /**
387      * @dev Storage slot with the address of the current implementation.
388      * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
389      * validated in the constructor.
390      */
391     bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
392 
393     /**
394      * @dev Returns the current implementation address.
395      */
396     function _implementation() internal override view returns (address impl) {
397         bytes32 slot = _IMPLEMENTATION_SLOT;
398         // solhint-disable-next-line no-inline-assembly
399         assembly {
400             impl := sload(slot)
401         }
402     }
403 
404     /**
405      * @dev Upgrades the proxy to a new implementation.
406      * 
407      * Emits an {Upgraded} event.
408      */
409     function _upgradeTo(address newImplementation) internal {
410         _setImplementation(newImplementation);
411         emit Upgraded(newImplementation);
412     }
413 
414     /**
415      * @dev Stores a new address in the EIP1967 implementation slot.
416      */
417     function _setImplementation(address newImplementation) private {
418         require(Address.isContract(newImplementation), "UpgradeableProxy: new implementation is not a contract");
419 
420         bytes32 slot = _IMPLEMENTATION_SLOT;
421 
422         // solhint-disable-next-line no-inline-assembly
423         assembly {
424             sstore(slot, newImplementation)
425         }
426     }
427 }
428 
429 /**
430  * @dev This contract implements a proxy that is upgradeable by an admin.
431  * 
432  * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
433  * clashing], which can potentially be used in an attack, this contract uses the
434  * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
435  * things that go hand in hand:
436  * 
437  * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
438  * that call matches one of the admin functions exposed by the proxy itself.
439  * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
440  * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
441  * "admin cannot fallback to proxy target".
442  * 
443  * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
444  * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
445  * to sudden errors when trying to call a function from the proxy implementation.
446  * 
447  * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
448  * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
449  */
450 contract TransparentUpgradeableProxy is UpgradeableProxy {
451     /**
452      * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
453      * optionally initialized with `_data` as explained in {UpgradeableProxy-constructor}.
454      */
455     constructor(address _logic, address admin_, bytes memory _data) public payable UpgradeableProxy(_logic, _data) {
456         assert(_ADMIN_SLOT == bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1));
457         _setAdmin(admin_);
458     }
459 
460     /**
461      * @dev Emitted when the admin account has changed.
462      */
463     event AdminChanged(address previousAdmin, address newAdmin);
464 
465     /**
466      * @dev Storage slot with the admin of the contract.
467      * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
468      * validated in the constructor.
469      */
470     bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
471 
472     /**
473      * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
474      */
475     modifier ifAdmin() {
476         if (msg.sender == _admin()) {
477             _;
478         } else {
479             _fallback();
480         }
481     }
482 
483     /**
484      * @dev Returns the current admin.
485      * 
486      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
487      * 
488      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
489      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
490      * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
491      */
492     function admin() external ifAdmin returns (address admin_) {
493         admin_ = _admin();
494     }
495 
496     /**
497      * @dev Returns the current implementation.
498      * 
499      * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
500      * 
501      * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
502      * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
503      * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
504      */
505     function implementation() external ifAdmin returns (address implementation_) {
506         implementation_ = _implementation();
507     }
508 
509     /**
510      * @dev Changes the admin of the proxy.
511      * 
512      * Emits an {AdminChanged} event.
513      * 
514      * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
515      */
516     function changeAdmin(address newAdmin) external ifAdmin {
517         require(newAdmin != address(0), "TransparentUpgradeableProxy: new admin is the zero address");
518         emit AdminChanged(_admin(), newAdmin);
519         _setAdmin(newAdmin);
520     }
521 
522     /**
523      * @dev Upgrade the implementation of the proxy.
524      * 
525      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
526      */
527     function upgradeTo(address newImplementation) external ifAdmin {
528         _upgradeTo(newImplementation);
529     }
530 
531     /**
532      * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
533      * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
534      * proxied contract.
535      * 
536      * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
537      */
538     function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
539         _upgradeTo(newImplementation);
540         // solhint-disable-next-line avoid-low-level-calls
541         (bool success,) = newImplementation.delegatecall(data);
542         require(success);
543     }
544 
545     /**
546      * @dev Returns the current admin.
547      */
548     function _admin() internal view returns (address adm) {
549         bytes32 slot = _ADMIN_SLOT;
550         // solhint-disable-next-line no-inline-assembly
551         assembly {
552             adm := sload(slot)
553         }
554     }
555 
556     /**
557      * @dev Stores a new address in the EIP1967 admin slot.
558      */
559     function _setAdmin(address newAdmin) private {
560         bytes32 slot = _ADMIN_SLOT;
561 
562         // solhint-disable-next-line no-inline-assembly
563         assembly {
564             sstore(slot, newAdmin)
565         }
566     }
567 
568     /**
569      * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
570      */
571     function _beforeFallback() internal override virtual {
572         require(msg.sender != _admin(), "TransparentUpgradeableProxy: admin cannot fallback to proxy target");
573         super._beforeFallback();
574     }
575 }
576 
577 /**
578  * @dev This is an auxiliary contract meant to be assigned as the admin of a {TransparentUpgradeableProxy}. For an
579  * explanation of why you would want to use this see the documentation for {TransparentUpgradeableProxy}.
580  */
581 contract ProxyAdmin is Ownable {
582 
583     /**
584      * @dev Returns the current implementation of `proxy`.
585      * 
586      * Requirements:
587      * 
588      * - This contract must be the admin of `proxy`.
589      */
590     function getProxyImplementation(TransparentUpgradeableProxy proxy) public view returns (address) {
591         // We need to manually run the static call since the getter cannot be flagged as view
592         // bytes4(keccak256("implementation()")) == 0x5c60da1b
593         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"5c60da1b");
594         require(success);
595         return abi.decode(returndata, (address));
596     }
597 
598     /**
599      * @dev Returns the current admin of `proxy`.
600      * 
601      * Requirements:
602      * 
603      * - This contract must be the admin of `proxy`.
604      */
605     function getProxyAdmin(TransparentUpgradeableProxy proxy) public view returns (address) {
606         // We need to manually run the static call since the getter cannot be flagged as view
607         // bytes4(keccak256("admin()")) == 0xf851a440
608         (bool success, bytes memory returndata) = address(proxy).staticcall(hex"f851a440");
609         require(success);
610         return abi.decode(returndata, (address));
611     }
612 
613     /**
614      * @dev Changes the admin of `proxy` to `newAdmin`.
615      * 
616      * Requirements:
617      * 
618      * - This contract must be the current admin of `proxy`.
619      */
620     function changeProxyAdmin(TransparentUpgradeableProxy proxy, address newAdmin) public onlyOwner {
621         proxy.changeAdmin(newAdmin);
622     }
623 
624     /**
625      * @dev Upgrades `proxy` to `implementation`. See {TransparentUpgradeableProxy-upgradeTo}.
626      * 
627      * Requirements:
628      * 
629      * - This contract must be the admin of `proxy`.
630      */
631     function upgrade(TransparentUpgradeableProxy proxy, address implementation) public onlyOwner {
632         proxy.upgradeTo(implementation);
633     }
634 
635     /**
636      * @dev Upgrades `proxy` to `implementation` and calls a function on the new implementation. See
637      * {TransparentUpgradeableProxy-upgradeToAndCall}.
638      * 
639      * Requirements:
640      * 
641      * - This contract must be the admin of `proxy`.
642      */
643     function upgradeAndCall(TransparentUpgradeableProxy proxy, address implementation, bytes memory data) public payable onlyOwner {
644         proxy.upgradeToAndCall{value: msg.value}(implementation, data);
645     }
646 }