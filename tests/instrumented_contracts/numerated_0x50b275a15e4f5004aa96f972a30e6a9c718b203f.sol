1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
7 
8 pragma solidity ^0.8.1;
9 
10 /**
11  * @dev Collection of functions related to the address type
12  */
13 library AddressUpgradeable {
14     /**
15      * @dev Returns true if `account` is a contract.
16      *
17      * [IMPORTANT]
18      * ====
19      * It is unsafe to assume that an address for which this function returns
20      * false is an externally-owned account (EOA) and not a contract.
21      *
22      * Among others, `isContract` will return false for the following
23      * types of addresses:
24      *
25      *  - an externally-owned account
26      *  - a contract in construction
27      *  - an address where a contract will be created
28      *  - an address where a contract lived, but was destroyed
29      *
30      * Furthermore, `isContract` will also return true if the target contract within
31      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
32      * which only has an effect at the end of a transaction.
33      * ====
34      *
35      * [IMPORTANT]
36      * ====
37      * You shouldn't rely on `isContract` to protect against flash loan attacks!
38      *
39      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
40      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
41      * constructor.
42      * ====
43      */
44     function isContract(address account) internal view returns (bool) {
45         // This method relies on extcodesize/address.code.length, which returns 0
46         // for contracts in construction, since the code is only stored at the end
47         // of the constructor execution.
48 
49         return account.code.length > 0;
50     }
51 
52     /**
53      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
54      * `recipient`, forwarding all available gas and reverting on errors.
55      *
56      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
57      * of certain opcodes, possibly making contracts go over the 2300 gas limit
58      * imposed by `transfer`, making them unable to receive funds via
59      * `transfer`. {sendValue} removes this limitation.
60      *
61      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
62      *
63      * IMPORTANT: because control is transferred to `recipient`, care must be
64      * taken to not create reentrancy vulnerabilities. Consider using
65      * {ReentrancyGuard} or the
66      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
67      */
68     function sendValue(address payable recipient, uint256 amount) internal {
69         require(address(this).balance >= amount, "Address: insufficient balance");
70 
71         (bool success, ) = recipient.call{value: amount}("");
72         require(success, "Address: unable to send value, recipient may have reverted");
73     }
74 
75     /**
76      * @dev Performs a Solidity function call using a low level `call`. A
77      * plain `call` is an unsafe replacement for a function call: use this
78      * function instead.
79      *
80      * If `target` reverts with a revert reason, it is bubbled up by this
81      * function (like regular Solidity function calls).
82      *
83      * Returns the raw returned data. To convert to the expected return value,
84      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
85      *
86      * Requirements:
87      *
88      * - `target` must be a contract.
89      * - calling `target` with `data` must not revert.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
99      * `errorMessage` as a fallback revert reason when `target` reverts.
100      *
101      * _Available since v3.1._
102      */
103     function functionCall(
104         address target,
105         bytes memory data,
106         string memory errorMessage
107     ) internal returns (bytes memory) {
108         return functionCallWithValue(target, data, 0, errorMessage);
109     }
110 
111     /**
112      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
113      * but also transferring `value` wei to `target`.
114      *
115      * Requirements:
116      *
117      * - the calling contract must have an ETH balance of at least `value`.
118      * - the called Solidity function must be `payable`.
119      *
120      * _Available since v3.1._
121      */
122     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
124     }
125 
126     /**
127      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
128      * with `errorMessage` as a fallback revert reason when `target` reverts.
129      *
130      * _Available since v3.1._
131      */
132     function functionCallWithValue(
133         address target,
134         bytes memory data,
135         uint256 value,
136         string memory errorMessage
137     ) internal returns (bytes memory) {
138         require(address(this).balance >= value, "Address: insufficient balance for call");
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
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
164         (bool success, bytes memory returndata) = target.staticcall(data);
165         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
170      * but performing a delegate call.
171      *
172      * _Available since v3.4._
173      */
174     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
175         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
180      * but performing a delegate call.
181      *
182      * _Available since v3.4._
183      */
184     function functionDelegateCall(
185         address target,
186         bytes memory data,
187         string memory errorMessage
188     ) internal returns (bytes memory) {
189         (bool success, bytes memory returndata) = target.delegatecall(data);
190         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
191     }
192 
193     /**
194      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
195      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
196      *
197      * _Available since v4.8._
198      */
199     function verifyCallResultFromTarget(
200         address target,
201         bool success,
202         bytes memory returndata,
203         string memory errorMessage
204     ) internal view returns (bytes memory) {
205         if (success) {
206             if (returndata.length == 0) {
207                 // only check isContract if the call was successful and the return data is empty
208                 // otherwise we already know that it was a contract
209                 require(isContract(target), "Address: call to non-contract");
210             }
211             return returndata;
212         } else {
213             _revert(returndata, errorMessage);
214         }
215     }
216 
217     /**
218      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
219      * revert reason or using the provided one.
220      *
221      * _Available since v4.3._
222      */
223     function verifyCallResult(
224         bool success,
225         bytes memory returndata,
226         string memory errorMessage
227     ) internal pure returns (bytes memory) {
228         if (success) {
229             return returndata;
230         } else {
231             _revert(returndata, errorMessage);
232         }
233     }
234 
235     function _revert(bytes memory returndata, string memory errorMessage) private pure {
236         // Look for revert reason and bubble it up if present
237         if (returndata.length > 0) {
238             // The easiest way to bubble the revert reason is using memory via assembly
239             /// @solidity memory-safe-assembly
240             assembly {
241                 let returndata_size := mload(returndata)
242                 revert(add(32, returndata), returndata_size)
243             }
244         } else {
245             revert(errorMessage);
246         }
247     }
248 }
249 
250 // File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
251 
252 
253 // OpenZeppelin Contracts (last updated v4.9.0) (proxy/utils/Initializable.sol)
254 
255 pragma solidity ^0.8.2;
256 
257 
258 /**
259  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
260  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
261  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
262  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
263  *
264  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
265  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
266  * case an upgrade adds a module that needs to be initialized.
267  *
268  * For example:
269  *
270  * [.hljs-theme-light.nopadding]
271  * ```solidity
272  * contract MyToken is ERC20Upgradeable {
273  *     function initialize() initializer public {
274  *         __ERC20_init("MyToken", "MTK");
275  *     }
276  * }
277  *
278  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
279  *     function initializeV2() reinitializer(2) public {
280  *         __ERC20Permit_init("MyToken");
281  *     }
282  * }
283  * ```
284  *
285  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
286  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
287  *
288  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
289  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
290  *
291  * [CAUTION]
292  * ====
293  * Avoid leaving a contract uninitialized.
294  *
295  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
296  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
297  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
298  *
299  * [.hljs-theme-light.nopadding]
300  * ```
301  * /// @custom:oz-upgrades-unsafe-allow constructor
302  * constructor() {
303  *     _disableInitializers();
304  * }
305  * ```
306  * ====
307  */
308 abstract contract Initializable {
309     /**
310      * @dev Indicates that the contract has been initialized.
311      * @custom:oz-retyped-from bool
312      */
313     uint8 private _initialized;
314 
315     /**
316      * @dev Indicates that the contract is in the process of being initialized.
317      */
318     bool private _initializing;
319 
320     /**
321      * @dev Triggered when the contract has been initialized or reinitialized.
322      */
323     event Initialized(uint8 version);
324 
325     /**
326      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
327      * `onlyInitializing` functions can be used to initialize parent contracts.
328      *
329      * Similar to `reinitializer(1)`, except that functions marked with `initializer` can be nested in the context of a
330      * constructor.
331      *
332      * Emits an {Initialized} event.
333      */
334     modifier initializer() {
335         bool isTopLevelCall = !_initializing;
336         require(
337             (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
338             "Initializable: contract is already initialized"
339         );
340         _initialized = 1;
341         if (isTopLevelCall) {
342             _initializing = true;
343         }
344         _;
345         if (isTopLevelCall) {
346             _initializing = false;
347             emit Initialized(1);
348         }
349     }
350 
351     /**
352      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
353      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
354      * used to initialize parent contracts.
355      *
356      * A reinitializer may be used after the original initialization step. This is essential to configure modules that
357      * are added through upgrades and that require initialization.
358      *
359      * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
360      * cannot be nested. If one is invoked in the context of another, execution will revert.
361      *
362      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
363      * a contract, executing them in the right order is up to the developer or operator.
364      *
365      * WARNING: setting the version to 255 will prevent any future reinitialization.
366      *
367      * Emits an {Initialized} event.
368      */
369     modifier reinitializer(uint8 version) {
370         require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
371         _initialized = version;
372         _initializing = true;
373         _;
374         _initializing = false;
375         emit Initialized(version);
376     }
377 
378     /**
379      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
380      * {initializer} and {reinitializer} modifiers, directly or indirectly.
381      */
382     modifier onlyInitializing() {
383         require(_initializing, "Initializable: contract is not initializing");
384         _;
385     }
386 
387     /**
388      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
389      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
390      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
391      * through proxies.
392      *
393      * Emits an {Initialized} event the first time it is successfully executed.
394      */
395     function _disableInitializers() internal virtual {
396         require(!_initializing, "Initializable: contract is initializing");
397         if (_initialized != type(uint8).max) {
398             _initialized = type(uint8).max;
399             emit Initialized(type(uint8).max);
400         }
401     }
402 
403     /**
404      * @dev Returns the highest version that has been initialized. See {reinitializer}.
405      */
406     function _getInitializedVersion() internal view returns (uint8) {
407         return _initialized;
408     }
409 
410     /**
411      * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
412      */
413     function _isInitializing() internal view returns (bool) {
414         return _initializing;
415     }
416 }
417 
418 // File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
419 
420 
421 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
422 
423 pragma solidity ^0.8.0;
424 
425 
426 /**
427  * @dev Provides information about the current execution context, including the
428  * sender of the transaction and its data. While these are generally available
429  * via msg.sender and msg.data, they should not be accessed in such a direct
430  * manner, since when dealing with meta-transactions the account sending and
431  * paying for execution may not be the actual sender (as far as an application
432  * is concerned).
433  *
434  * This contract is only required for intermediate, library-like contracts.
435  */
436 abstract contract ContextUpgradeable is Initializable {
437     function __Context_init() internal onlyInitializing {
438     }
439 
440     function __Context_init_unchained() internal onlyInitializing {
441     }
442     function _msgSender() internal view virtual returns (address) {
443         return msg.sender;
444     }
445 
446     function _msgData() internal view virtual returns (bytes calldata) {
447         return msg.data;
448     }
449 
450     /**
451      * @dev This empty reserved space is put in place to allow future versions to add new
452      * variables without shifting down storage in the inheritance chain.
453      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
454      */
455     uint256[50] private __gap;
456 }
457 
458 // File: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol
459 
460 
461 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 
466 
467 /**
468  * @dev Contract module which provides a basic access control mechanism, where
469  * there is an account (an owner) that can be granted exclusive access to
470  * specific functions.
471  *
472  * By default, the owner account will be the one that deploys the contract. This
473  * can later be changed with {transferOwnership}.
474  *
475  * This module is used through inheritance. It will make available the modifier
476  * `onlyOwner`, which can be applied to your functions to restrict their use to
477  * the owner.
478  */
479 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
480     address private _owner;
481 
482     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
483 
484     /**
485      * @dev Initializes the contract setting the deployer as the initial owner.
486      */
487     function __Ownable_init() internal onlyInitializing {
488         __Ownable_init_unchained();
489     }
490 
491     function __Ownable_init_unchained() internal onlyInitializing {
492         _transferOwnership(_msgSender());
493     }
494 
495     /**
496      * @dev Throws if called by any account other than the owner.
497      */
498     modifier onlyOwner() {
499         _checkOwner();
500         _;
501     }
502 
503     /**
504      * @dev Returns the address of the current owner.
505      */
506     function owner() public view virtual returns (address) {
507         return _owner;
508     }
509 
510     /**
511      * @dev Throws if the sender is not the owner.
512      */
513     function _checkOwner() internal view virtual {
514         require(owner() == _msgSender(), "Ownable: caller is not the owner");
515     }
516 
517     /**
518      * @dev Leaves the contract without owner. It will not be possible to call
519      * `onlyOwner` functions. Can only be called by the current owner.
520      *
521      * NOTE: Renouncing ownership will leave the contract without an owner,
522      * thereby disabling any functionality that is only available to the owner.
523      */
524     function renounceOwnership() public virtual onlyOwner {
525         _transferOwnership(address(0));
526     }
527 
528     /**
529      * @dev Transfers ownership of the contract to a new account (`newOwner`).
530      * Can only be called by the current owner.
531      */
532     function transferOwnership(address newOwner) public virtual onlyOwner {
533         require(newOwner != address(0), "Ownable: new owner is the zero address");
534         _transferOwnership(newOwner);
535     }
536 
537     /**
538      * @dev Transfers ownership of the contract to a new account (`newOwner`).
539      * Internal function without access restriction.
540      */
541     function _transferOwnership(address newOwner) internal virtual {
542         address oldOwner = _owner;
543         _owner = newOwner;
544         emit OwnershipTransferred(oldOwner, newOwner);
545     }
546 
547     /**
548      * @dev This empty reserved space is put in place to allow future versions to add new
549      * variables without shifting down storage in the inheritance chain.
550      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
551      */
552     uint256[49] private __gap;
553 }
554 
555 // File: @openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol
556 
557 
558 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 
563 
564 /**
565  * @dev Contract module which allows children to implement an emergency stop
566  * mechanism that can be triggered by an authorized account.
567  *
568  * This module is used through inheritance. It will make available the
569  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
570  * the functions of your contract. Note that they will not be pausable by
571  * simply including this module, only once the modifiers are put in place.
572  */
573 abstract contract PausableUpgradeable is Initializable, ContextUpgradeable {
574     /**
575      * @dev Emitted when the pause is triggered by `account`.
576      */
577     event Paused(address account);
578 
579     /**
580      * @dev Emitted when the pause is lifted by `account`.
581      */
582     event Unpaused(address account);
583 
584     bool private _paused;
585 
586     /**
587      * @dev Initializes the contract in unpaused state.
588      */
589     function __Pausable_init() internal onlyInitializing {
590         __Pausable_init_unchained();
591     }
592 
593     function __Pausable_init_unchained() internal onlyInitializing {
594         _paused = false;
595     }
596 
597     /**
598      * @dev Modifier to make a function callable only when the contract is not paused.
599      *
600      * Requirements:
601      *
602      * - The contract must not be paused.
603      */
604     modifier whenNotPaused() {
605         _requireNotPaused();
606         _;
607     }
608 
609     /**
610      * @dev Modifier to make a function callable only when the contract is paused.
611      *
612      * Requirements:
613      *
614      * - The contract must be paused.
615      */
616     modifier whenPaused() {
617         _requirePaused();
618         _;
619     }
620 
621     /**
622      * @dev Returns true if the contract is paused, and false otherwise.
623      */
624     function paused() public view virtual returns (bool) {
625         return _paused;
626     }
627 
628     /**
629      * @dev Throws if the contract is paused.
630      */
631     function _requireNotPaused() internal view virtual {
632         require(!paused(), "Pausable: paused");
633     }
634 
635     /**
636      * @dev Throws if the contract is not paused.
637      */
638     function _requirePaused() internal view virtual {
639         require(paused(), "Pausable: not paused");
640     }
641 
642     /**
643      * @dev Triggers stopped state.
644      *
645      * Requirements:
646      *
647      * - The contract must not be paused.
648      */
649     function _pause() internal virtual whenNotPaused {
650         _paused = true;
651         emit Paused(_msgSender());
652     }
653 
654     /**
655      * @dev Returns to normal state.
656      *
657      * Requirements:
658      *
659      * - The contract must be paused.
660      */
661     function _unpause() internal virtual whenPaused {
662         _paused = false;
663         emit Unpaused(_msgSender());
664     }
665 
666     /**
667      * @dev This empty reserved space is put in place to allow future versions to add new
668      * variables without shifting down storage in the inheritance chain.
669      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
670      */
671     uint256[49] private __gap;
672 }
673 
674 // File: @openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol
675 
676 
677 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
678 
679 pragma solidity ^0.8.0;
680 
681 /**
682  * @dev Interface of the ERC20 standard as defined in the EIP.
683  */
684 interface IERC20Upgradeable {
685     /**
686      * @dev Emitted when `value` tokens are moved from one account (`from`) to
687      * another (`to`).
688      *
689      * Note that `value` may be zero.
690      */
691     event Transfer(address indexed from, address indexed to, uint256 value);
692 
693     /**
694      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
695      * a call to {approve}. `value` is the new allowance.
696      */
697     event Approval(address indexed owner, address indexed spender, uint256 value);
698 
699     /**
700      * @dev Returns the amount of tokens in existence.
701      */
702     function totalSupply() external view returns (uint256);
703 
704     /**
705      * @dev Returns the amount of tokens owned by `account`.
706      */
707     function balanceOf(address account) external view returns (uint256);
708 
709     /**
710      * @dev Moves `amount` tokens from the caller's account to `to`.
711      *
712      * Returns a boolean value indicating whether the operation succeeded.
713      *
714      * Emits a {Transfer} event.
715      */
716     function transfer(address to, uint256 amount) external returns (bool);
717 
718     /**
719      * @dev Returns the remaining number of tokens that `spender` will be
720      * allowed to spend on behalf of `owner` through {transferFrom}. This is
721      * zero by default.
722      *
723      * This value changes when {approve} or {transferFrom} are called.
724      */
725     function allowance(address owner, address spender) external view returns (uint256);
726 
727     /**
728      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
729      *
730      * Returns a boolean value indicating whether the operation succeeded.
731      *
732      * IMPORTANT: Beware that changing an allowance with this method brings the risk
733      * that someone may use both the old and the new allowance by unfortunate
734      * transaction ordering. One possible solution to mitigate this race
735      * condition is to first reduce the spender's allowance to 0 and set the
736      * desired value afterwards:
737      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
738      *
739      * Emits an {Approval} event.
740      */
741     function approve(address spender, uint256 amount) external returns (bool);
742 
743     /**
744      * @dev Moves `amount` tokens from `from` to `to` using the
745      * allowance mechanism. `amount` is then deducted from the caller's
746      * allowance.
747      *
748      * Returns a boolean value indicating whether the operation succeeded.
749      *
750      * Emits a {Transfer} event.
751      */
752     function transferFrom(address from, address to, uint256 amount) external returns (bool);
753 }
754 
755 // File: @openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20MetadataUpgradeable.sol
756 
757 
758 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
759 
760 pragma solidity ^0.8.0;
761 
762 
763 /**
764  * @dev Interface for the optional metadata functions from the ERC20 standard.
765  *
766  * _Available since v4.1._
767  */
768 interface IERC20MetadataUpgradeable is IERC20Upgradeable {
769     /**
770      * @dev Returns the name of the token.
771      */
772     function name() external view returns (string memory);
773 
774     /**
775      * @dev Returns the symbol of the token.
776      */
777     function symbol() external view returns (string memory);
778 
779     /**
780      * @dev Returns the decimals places of the token.
781      */
782     function decimals() external view returns (uint8);
783 }
784 
785 // File: @openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol
786 
787 
788 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
789 
790 pragma solidity ^0.8.0;
791 
792 
793 
794 
795 
796 /**
797  * @dev Implementation of the {IERC20} interface.
798  *
799  * This implementation is agnostic to the way tokens are created. This means
800  * that a supply mechanism has to be added in a derived contract using {_mint}.
801  * For a generic mechanism see {ERC20PresetMinterPauser}.
802  *
803  * TIP: For a detailed writeup see our guide
804  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
805  * to implement supply mechanisms].
806  *
807  * The default value of {decimals} is 18. To change this, you should override
808  * this function so it returns a different value.
809  *
810  * We have followed general OpenZeppelin Contracts guidelines: functions revert
811  * instead returning `false` on failure. This behavior is nonetheless
812  * conventional and does not conflict with the expectations of ERC20
813  * applications.
814  *
815  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
816  * This allows applications to reconstruct the allowance for all accounts just
817  * by listening to said events. Other implementations of the EIP may not emit
818  * these events, as it isn't required by the specification.
819  *
820  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
821  * functions have been added to mitigate the well-known issues around setting
822  * allowances. See {IERC20-approve}.
823  */
824 contract ERC20Upgradeable is Initializable, ContextUpgradeable, IERC20Upgradeable, IERC20MetadataUpgradeable {
825     mapping(address => uint256) private _balances;
826 
827     mapping(address => mapping(address => uint256)) private _allowances;
828 
829     uint256 private _totalSupply;
830 
831     string private _name;
832     string private _symbol;
833 
834     /**
835      * @dev Sets the values for {name} and {symbol}.
836      *
837      * All two of these values are immutable: they can only be set once during
838      * construction.
839      */
840     function __ERC20_init(string memory name_, string memory symbol_) internal onlyInitializing {
841         __ERC20_init_unchained(name_, symbol_);
842     }
843 
844     function __ERC20_init_unchained(string memory name_, string memory symbol_) internal onlyInitializing {
845         _name = name_;
846         _symbol = symbol_;
847     }
848 
849     /**
850      * @dev Returns the name of the token.
851      */
852     function name() public view virtual override returns (string memory) {
853         return _name;
854     }
855 
856     /**
857      * @dev Returns the symbol of the token, usually a shorter version of the
858      * name.
859      */
860     function symbol() public view virtual override returns (string memory) {
861         return _symbol;
862     }
863 
864     /**
865      * @dev Returns the number of decimals used to get its user representation.
866      * For example, if `decimals` equals `2`, a balance of `505` tokens should
867      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
868      *
869      * Tokens usually opt for a value of 18, imitating the relationship between
870      * Ether and Wei. This is the default value returned by this function, unless
871      * it's overridden.
872      *
873      * NOTE: This information is only used for _display_ purposes: it in
874      * no way affects any of the arithmetic of the contract, including
875      * {IERC20-balanceOf} and {IERC20-transfer}.
876      */
877     function decimals() public view virtual override returns (uint8) {
878         return 18;
879     }
880 
881     /**
882      * @dev See {IERC20-totalSupply}.
883      */
884     function totalSupply() public view virtual override returns (uint256) {
885         return _totalSupply;
886     }
887 
888     /**
889      * @dev See {IERC20-balanceOf}.
890      */
891     function balanceOf(address account) public view virtual override returns (uint256) {
892         return _balances[account];
893     }
894 
895     /**
896      * @dev See {IERC20-transfer}.
897      *
898      * Requirements:
899      *
900      * - `to` cannot be the zero address.
901      * - the caller must have a balance of at least `amount`.
902      */
903     function transfer(address to, uint256 amount) public virtual override returns (bool) {
904         address owner = _msgSender();
905         _transfer(owner, to, amount);
906         return true;
907     }
908 
909     /**
910      * @dev See {IERC20-allowance}.
911      */
912     function allowance(address owner, address spender) public view virtual override returns (uint256) {
913         return _allowances[owner][spender];
914     }
915 
916     /**
917      * @dev See {IERC20-approve}.
918      *
919      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
920      * `transferFrom`. This is semantically equivalent to an infinite approval.
921      *
922      * Requirements:
923      *
924      * - `spender` cannot be the zero address.
925      */
926     function approve(address spender, uint256 amount) public virtual override returns (bool) {
927         address owner = _msgSender();
928         _approve(owner, spender, amount);
929         return true;
930     }
931 
932     /**
933      * @dev See {IERC20-transferFrom}.
934      *
935      * Emits an {Approval} event indicating the updated allowance. This is not
936      * required by the EIP. See the note at the beginning of {ERC20}.
937      *
938      * NOTE: Does not update the allowance if the current allowance
939      * is the maximum `uint256`.
940      *
941      * Requirements:
942      *
943      * - `from` and `to` cannot be the zero address.
944      * - `from` must have a balance of at least `amount`.
945      * - the caller must have allowance for ``from``'s tokens of at least
946      * `amount`.
947      */
948     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
949         address spender = _msgSender();
950         _spendAllowance(from, spender, amount);
951         _transfer(from, to, amount);
952         return true;
953     }
954 
955     /**
956      * @dev Atomically increases the allowance granted to `spender` by the caller.
957      *
958      * This is an alternative to {approve} that can be used as a mitigation for
959      * problems described in {IERC20-approve}.
960      *
961      * Emits an {Approval} event indicating the updated allowance.
962      *
963      * Requirements:
964      *
965      * - `spender` cannot be the zero address.
966      */
967     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
968         address owner = _msgSender();
969         _approve(owner, spender, allowance(owner, spender) + addedValue);
970         return true;
971     }
972 
973     /**
974      * @dev Atomically decreases the allowance granted to `spender` by the caller.
975      *
976      * This is an alternative to {approve} that can be used as a mitigation for
977      * problems described in {IERC20-approve}.
978      *
979      * Emits an {Approval} event indicating the updated allowance.
980      *
981      * Requirements:
982      *
983      * - `spender` cannot be the zero address.
984      * - `spender` must have allowance for the caller of at least
985      * `subtractedValue`.
986      */
987     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
988         address owner = _msgSender();
989         uint256 currentAllowance = allowance(owner, spender);
990         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
991         unchecked {
992             _approve(owner, spender, currentAllowance - subtractedValue);
993         }
994 
995         return true;
996     }
997 
998     /**
999      * @dev Moves `amount` of tokens from `from` to `to`.
1000      *
1001      * This internal function is equivalent to {transfer}, and can be used to
1002      * e.g. implement automatic token fees, slashing mechanisms, etc.
1003      *
1004      * Emits a {Transfer} event.
1005      *
1006      * Requirements:
1007      *
1008      * - `from` cannot be the zero address.
1009      * - `to` cannot be the zero address.
1010      * - `from` must have a balance of at least `amount`.
1011      */
1012     function _transfer(address from, address to, uint256 amount) internal virtual {
1013         require(from != address(0), "ERC20: transfer from the zero address");
1014         require(to != address(0), "ERC20: transfer to the zero address");
1015 
1016         _beforeTokenTransfer(from, to, amount);
1017 
1018         uint256 fromBalance = _balances[from];
1019         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1020         unchecked {
1021             _balances[from] = fromBalance - amount;
1022             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1023             // decrementing then incrementing.
1024             _balances[to] += amount;
1025         }
1026 
1027         emit Transfer(from, to, amount);
1028 
1029         _afterTokenTransfer(from, to, amount);
1030     }
1031 
1032     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1033      * the total supply.
1034      *
1035      * Emits a {Transfer} event with `from` set to the zero address.
1036      *
1037      * Requirements:
1038      *
1039      * - `account` cannot be the zero address.
1040      */
1041     function _mint(address account, uint256 amount) internal virtual {
1042         require(account != address(0), "ERC20: mint to the zero address");
1043 
1044         _beforeTokenTransfer(address(0), account, amount);
1045 
1046         _totalSupply += amount;
1047         unchecked {
1048             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1049             _balances[account] += amount;
1050         }
1051         emit Transfer(address(0), account, amount);
1052 
1053         _afterTokenTransfer(address(0), account, amount);
1054     }
1055 
1056     /**
1057      * @dev Destroys `amount` tokens from `account`, reducing the
1058      * total supply.
1059      *
1060      * Emits a {Transfer} event with `to` set to the zero address.
1061      *
1062      * Requirements:
1063      *
1064      * - `account` cannot be the zero address.
1065      * - `account` must have at least `amount` tokens.
1066      */
1067     function _burn(address account, uint256 amount) internal virtual {
1068         require(account != address(0), "ERC20: burn from the zero address");
1069 
1070         _beforeTokenTransfer(account, address(0), amount);
1071 
1072         uint256 accountBalance = _balances[account];
1073         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1074         unchecked {
1075             _balances[account] = accountBalance - amount;
1076             // Overflow not possible: amount <= accountBalance <= totalSupply.
1077             _totalSupply -= amount;
1078         }
1079 
1080         emit Transfer(account, address(0), amount);
1081 
1082         _afterTokenTransfer(account, address(0), amount);
1083     }
1084 
1085     /**
1086      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1087      *
1088      * This internal function is equivalent to `approve`, and can be used to
1089      * e.g. set automatic allowances for certain subsystems, etc.
1090      *
1091      * Emits an {Approval} event.
1092      *
1093      * Requirements:
1094      *
1095      * - `owner` cannot be the zero address.
1096      * - `spender` cannot be the zero address.
1097      */
1098     function _approve(address owner, address spender, uint256 amount) internal virtual {
1099         require(owner != address(0), "ERC20: approve from the zero address");
1100         require(spender != address(0), "ERC20: approve to the zero address");
1101 
1102         _allowances[owner][spender] = amount;
1103         emit Approval(owner, spender, amount);
1104     }
1105 
1106     /**
1107      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1108      *
1109      * Does not update the allowance amount in case of infinite allowance.
1110      * Revert if not enough allowance is available.
1111      *
1112      * Might emit an {Approval} event.
1113      */
1114     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1115         uint256 currentAllowance = allowance(owner, spender);
1116         if (currentAllowance != type(uint256).max) {
1117             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1118             unchecked {
1119                 _approve(owner, spender, currentAllowance - amount);
1120             }
1121         }
1122     }
1123 
1124     /**
1125      * @dev Hook that is called before any transfer of tokens. This includes
1126      * minting and burning.
1127      *
1128      * Calling conditions:
1129      *
1130      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1131      * will be transferred to `to`.
1132      * - when `from` is zero, `amount` tokens will be minted for `to`.
1133      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1134      * - `from` and `to` are never both zero.
1135      *
1136      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1137      */
1138     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1139 
1140     /**
1141      * @dev Hook that is called after any transfer of tokens. This includes
1142      * minting and burning.
1143      *
1144      * Calling conditions:
1145      *
1146      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1147      * has been transferred to `to`.
1148      * - when `from` is zero, `amount` tokens have been minted for `to`.
1149      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1150      * - `from` and `to` are never both zero.
1151      *
1152      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1153      */
1154     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1155 
1156     /**
1157      * @dev This empty reserved space is put in place to allow future versions to add new
1158      * variables without shifting down storage in the inheritance chain.
1159      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1160      */
1161     uint256[45] private __gap;
1162 }
1163 
1164 // File: @openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol
1165 
1166 
1167 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1168 
1169 pragma solidity ^0.8.0;
1170 
1171 
1172 
1173 
1174 /**
1175  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1176  * tokens and those that they have an allowance for, in a way that can be
1177  * recognized off-chain (via event analysis).
1178  */
1179 abstract contract ERC20BurnableUpgradeable is Initializable, ContextUpgradeable, ERC20Upgradeable {
1180     function __ERC20Burnable_init() internal onlyInitializing {
1181     }
1182 
1183     function __ERC20Burnable_init_unchained() internal onlyInitializing {
1184     }
1185     /**
1186      * @dev Destroys `amount` tokens from the caller.
1187      *
1188      * See {ERC20-_burn}.
1189      */
1190     function burn(uint256 amount) public virtual {
1191         _burn(_msgSender(), amount);
1192     }
1193 
1194     /**
1195      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1196      * allowance.
1197      *
1198      * See {ERC20-_burn} and {ERC20-allowance}.
1199      *
1200      * Requirements:
1201      *
1202      * - the caller must have allowance for ``accounts``'s tokens of at least
1203      * `amount`.
1204      */
1205     function burnFrom(address account, uint256 amount) public virtual {
1206         _spendAllowance(account, _msgSender(), amount);
1207         _burn(account, amount);
1208     }
1209 
1210     /**
1211      * @dev This empty reserved space is put in place to allow future versions to add new
1212      * variables without shifting down storage in the inheritance chain.
1213      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1214      */
1215     uint256[50] private __gap;
1216 }
1217 
1218 // File: contracts/WSTOR.sol
1219 
1220 
1221 pragma solidity ^0.8.9;
1222 
1223 
1224 
1225 
1226 
1227 
1228 contract StorageChain is Initializable, ERC20Upgradeable, ERC20BurnableUpgradeable, PausableUpgradeable, OwnableUpgradeable {
1229     /// @custom:oz-upgrades-unsafe-allow constructor
1230     constructor() {
1231         initialize();
1232     }
1233 
1234     function initialize() initializer public {
1235         __ERC20_init("StorageChain", "WSTOR");
1236         __ERC20Burnable_init();
1237         __Pausable_init();
1238         __Ownable_init();
1239     }
1240 
1241     function pause() public onlyOwner {
1242         _pause();
1243     }
1244 
1245     function unpause() public onlyOwner {
1246         _unpause();
1247     }
1248 
1249     function mint(address to, uint256 amount) public onlyOwner {
1250         _mint(to, amount);
1251     }
1252 
1253     function _beforeTokenTransfer(address from, address to, uint256 amount)
1254         internal
1255         whenNotPaused
1256         override
1257     {
1258         super._beforeTokenTransfer(from, to,    amount);
1259     }
1260 }