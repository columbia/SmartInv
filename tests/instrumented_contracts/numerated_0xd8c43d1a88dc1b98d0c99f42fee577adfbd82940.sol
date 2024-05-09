1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Contract module that helps prevent reentrant calls to a function.
13  *
14  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
15  * available, which can be applied to functions to make sure there are no nested
16  * (reentrant) calls to them.
17  *
18  * Note that because there is a single `nonReentrant` guard, functions marked as
19  * `nonReentrant` may not call one another. This can be worked around by making
20  * those functions `private`, and then adding `external` `nonReentrant` entry
21  * points to them.
22  *
23  * TIP: If you would like to learn more about reentrancy and alternative ways
24  * to protect against it, check out our blog post
25  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
26  */
27 abstract contract ReentrancyGuard {
28     // Booleans are more expensive than uint256 or any type that takes up a full
29     // word because each write operation emits an extra SLOAD to first read the
30     // slot's contents, replace the bits taken up by the boolean, and then write
31     // back. This is the compiler's defense against contract upgrades and
32     // pointer aliasing, and it cannot be disabled.
33 
34     // The values being non-zero value makes deployment a bit more expensive,
35     // but in exchange the refund on every call to nonReentrant will be lower in
36     // amount. Since refunds are capped to a percentage of the total
37     // transaction's gas, it is best to keep them low in cases like this one, to
38     // increase the likelihood of the full refund coming into effect.
39     uint256 private constant _NOT_ENTERED = 1;
40     uint256 private constant _ENTERED = 2;
41 
42     uint256 private _status;
43 
44     constructor() {
45         _status = _NOT_ENTERED;
46     }
47 
48     /**
49      * @dev Prevents a contract from calling itself, directly or indirectly.
50      * Calling a `nonReentrant` function from another `nonReentrant`
51      * function is not supported. It is possible to prevent this from happening
52      * by making the `nonReentrant` function external, and making it call a
53      * `private` function that does the actual work.
54      */
55     modifier nonReentrant() {
56         // On the first call to nonReentrant, _notEntered will be true
57         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
58 
59         // Any calls to nonReentrant after this point will fail
60         _status = _ENTERED;
61 
62         _;
63 
64         // By storing the original value once again, a refund is triggered (see
65         // https://eips.ethereum.org/EIPS/eip-2200)
66         _status = _NOT_ENTERED;
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Address.sol
71 
72 
73 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
74 
75 pragma solidity ^0.8.1;
76 
77 /**
78  * @dev Collection of functions related to the address type
79  */
80 library Address {
81     /**
82      * @dev Returns true if `account` is a contract.
83      *
84      * [IMPORTANT]
85      * ====
86      * It is unsafe to assume that an address for which this function returns
87      * false is an externally-owned account (EOA) and not a contract.
88      *
89      * Among others, `isContract` will return false for the following
90      * types of addresses:
91      *
92      *  - an externally-owned account
93      *  - a contract in construction
94      *  - an address where a contract will be created
95      *  - an address where a contract lived, but was destroyed
96      * ====
97      *
98      * [IMPORTANT]
99      * ====
100      * You shouldn't rely on `isContract` to protect against flash loan attacks!
101      *
102      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
103      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
104      * constructor.
105      * ====
106      */
107     function isContract(address account) internal view returns (bool) {
108         // This method relies on extcodesize/address.code.length, which returns 0
109         // for contracts in construction, since the code is only stored at the end
110         // of the constructor execution.
111 
112         return account.code.length > 0;
113     }
114 
115     /**
116      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
117      * `recipient`, forwarding all available gas and reverting on errors.
118      *
119      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
120      * of certain opcodes, possibly making contracts go over the 2300 gas limit
121      * imposed by `transfer`, making them unable to receive funds via
122      * `transfer`. {sendValue} removes this limitation.
123      *
124      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
125      *
126      * IMPORTANT: because control is transferred to `recipient`, care must be
127      * taken to not create reentrancy vulnerabilities. Consider using
128      * {ReentrancyGuard} or the
129      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
130      */
131     function sendValue(address payable recipient, uint256 amount) internal {
132         require(address(this).balance >= amount, "Address: insufficient balance");
133 
134         (bool success, ) = recipient.call{value: amount}("");
135         require(success, "Address: unable to send value, recipient may have reverted");
136     }
137 
138     /**
139      * @dev Performs a Solidity function call using a low level `call`. A
140      * plain `call` is an unsafe replacement for a function call: use this
141      * function instead.
142      *
143      * If `target` reverts with a revert reason, it is bubbled up by this
144      * function (like regular Solidity function calls).
145      *
146      * Returns the raw returned data. To convert to the expected return value,
147      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
148      *
149      * Requirements:
150      *
151      * - `target` must be a contract.
152      * - calling `target` with `data` must not revert.
153      *
154      * _Available since v3.1._
155      */
156     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
157         return functionCall(target, data, "Address: low-level call failed");
158     }
159 
160     /**
161      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
162      * `errorMessage` as a fallback revert reason when `target` reverts.
163      *
164      * _Available since v3.1._
165      */
166     function functionCall(
167         address target,
168         bytes memory data,
169         string memory errorMessage
170     ) internal returns (bytes memory) {
171         return functionCallWithValue(target, data, 0, errorMessage);
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
176      * but also transferring `value` wei to `target`.
177      *
178      * Requirements:
179      *
180      * - the calling contract must have an ETH balance of at least `value`.
181      * - the called Solidity function must be `payable`.
182      *
183      * _Available since v3.1._
184      */
185     function functionCallWithValue(
186         address target,
187         bytes memory data,
188         uint256 value
189     ) internal returns (bytes memory) {
190         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
195      * with `errorMessage` as a fallback revert reason when `target` reverts.
196      *
197      * _Available since v3.1._
198      */
199     function functionCallWithValue(
200         address target,
201         bytes memory data,
202         uint256 value,
203         string memory errorMessage
204     ) internal returns (bytes memory) {
205         require(address(this).balance >= value, "Address: insufficient balance for call");
206         require(isContract(target), "Address: call to non-contract");
207 
208         (bool success, bytes memory returndata) = target.call{value: value}(data);
209         return verifyCallResult(success, returndata, errorMessage);
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
214      * but performing a static call.
215      *
216      * _Available since v3.3._
217      */
218     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
219         return functionStaticCall(target, data, "Address: low-level static call failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
224      * but performing a static call.
225      *
226      * _Available since v3.3._
227      */
228     function functionStaticCall(
229         address target,
230         bytes memory data,
231         string memory errorMessage
232     ) internal view returns (bytes memory) {
233         require(isContract(target), "Address: static call to non-contract");
234 
235         (bool success, bytes memory returndata) = target.staticcall(data);
236         return verifyCallResult(success, returndata, errorMessage);
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
241      * but performing a delegate call.
242      *
243      * _Available since v3.4._
244      */
245     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
246         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
251      * but performing a delegate call.
252      *
253      * _Available since v3.4._
254      */
255     function functionDelegateCall(
256         address target,
257         bytes memory data,
258         string memory errorMessage
259     ) internal returns (bytes memory) {
260         require(isContract(target), "Address: delegate call to non-contract");
261 
262         (bool success, bytes memory returndata) = target.delegatecall(data);
263         return verifyCallResult(success, returndata, errorMessage);
264     }
265 
266     /**
267      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
268      * revert reason using the provided one.
269      *
270      * _Available since v4.3._
271      */
272     function verifyCallResult(
273         bool success,
274         bytes memory returndata,
275         string memory errorMessage
276     ) internal pure returns (bytes memory) {
277         if (success) {
278             return returndata;
279         } else {
280             // Look for revert reason and bubble it up if present
281             if (returndata.length > 0) {
282                 // The easiest way to bubble the revert reason is using memory via assembly
283 
284                 assembly {
285                     let returndata_size := mload(returndata)
286                     revert(add(32, returndata), returndata_size)
287                 }
288             } else {
289                 revert(errorMessage);
290             }
291         }
292     }
293 }
294 
295 // File: @openzeppelin/contracts/proxy/utils/Initializable.sol
296 
297 
298 // OpenZeppelin Contracts (last updated v4.8.0-rc.1) (proxy/utils/Initializable.sol)
299 
300 pragma solidity ^0.8.2;
301 
302 
303 /**
304  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
305  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
306  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
307  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
308  *
309  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
310  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
311  * case an upgrade adds a module that needs to be initialized.
312  *
313  * For example:
314  *
315  * [.hljs-theme-light.nopadding]
316  * ```
317  * contract MyToken is ERC20Upgradeable {
318  *     function initialize() initializer public {
319  *         __ERC20_init("MyToken", "MTK");
320  *     }
321  * }
322  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
323  *     function initializeV2() reinitializer(2) public {
324  *         __ERC20Permit_init("MyToken");
325  *     }
326  * }
327  * ```
328  *
329  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
330  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
331  *
332  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
333  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
334  *
335  * [CAUTION]
336  * ====
337  * Avoid leaving a contract uninitialized.
338  *
339  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
340  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
341  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
342  *
343  * [.hljs-theme-light.nopadding]
344  * ```
345  * /// @custom:oz-upgrades-unsafe-allow constructor
346  * constructor() {
347  *     _disableInitializers();
348  * }
349  * ```
350  * ====
351  */
352 abstract contract Initializable {
353     /**
354      * @dev Indicates that the contract has been initialized.
355      * @custom:oz-retyped-from bool
356      */
357     uint8 private _initialized;
358 
359     /**
360      * @dev Indicates that the contract is in the process of being initialized.
361      */
362     bool private _initializing;
363 
364     /**
365      * @dev Triggered when the contract has been initialized or reinitialized.
366      */
367     event Initialized(uint8 version);
368 
369     /**
370      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
371      * `onlyInitializing` functions can be used to initialize parent contracts.
372      *
373      * Similar to `reinitializer(1)`, except that functions marked with `initializer` can be nested in the context of a
374      * constructor.
375      *
376      * Emits an {Initialized} event.
377      */
378     modifier initializer() {
379         bool isTopLevelCall = !_initializing;
380         require(
381             (isTopLevelCall && _initialized < 1) || (!Address.isContract(address(this)) && _initialized == 1),
382             "Initializable: contract is already initialized"
383         );
384         _initialized = 1;
385         if (isTopLevelCall) {
386             _initializing = true;
387         }
388         _;
389         if (isTopLevelCall) {
390             _initializing = false;
391             emit Initialized(1);
392         }
393     }
394 
395     /**
396      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
397      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
398      * used to initialize parent contracts.
399      *
400      * A reinitializer may be used after the original initialization step. This is essential to configure modules that
401      * are added through upgrades and that require initialization.
402      *
403      * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
404      * cannot be nested. If one is invoked in the context of another, execution will revert.
405      *
406      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
407      * a contract, executing them in the right order is up to the developer or operator.
408      *
409      * WARNING: setting the version to 255 will prevent any future reinitialization.
410      *
411      * Emits an {Initialized} event.
412      */
413     modifier reinitializer(uint8 version) {
414         require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
415         _initialized = version;
416         _initializing = true;
417         _;
418         _initializing = false;
419         emit Initialized(version);
420     }
421 
422     /**
423      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
424      * {initializer} and {reinitializer} modifiers, directly or indirectly.
425      */
426     modifier onlyInitializing() {
427         require(_initializing, "Initializable: contract is not initializing");
428         _;
429     }
430 
431     /**
432      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
433      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
434      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
435      * through proxies.
436      *
437      * Emits an {Initialized} event the first time it is successfully executed.
438      */
439     function _disableInitializers() internal virtual {
440         require(!_initializing, "Initializable: contract is initializing");
441         if (_initialized < type(uint8).max) {
442             _initialized = type(uint8).max;
443             emit Initialized(type(uint8).max);
444         }
445     }
446 
447     /**
448      * @dev Internal function that returns the initialized version. Returns `_initialized`
449      */
450     function _getInitializedVersion() internal view returns (uint8) {
451         return _initialized;
452     }
453 
454     /**
455      * @dev Internal function that returns the initialized version. Returns `_initializing`
456      */
457     function _isInitializing() internal view returns (bool) {
458         return _initializing;
459     }
460 }
461 
462 // File: @openzeppelin/contracts/utils/Context.sol
463 
464 
465 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 /**
470  * @dev Provides information about the current execution context, including the
471  * sender of the transaction and its data. While these are generally available
472  * via msg.sender and msg.data, they should not be accessed in such a direct
473  * manner, since when dealing with meta-transactions the account sending and
474  * paying for execution may not be the actual sender (as far as an application
475  * is concerned).
476  *
477  * This contract is only required for intermediate, library-like contracts.
478  */
479 abstract contract Context {
480     function _msgSender() internal view virtual returns (address) {
481         return msg.sender;
482     }
483 
484     function _msgData() internal view virtual returns (bytes calldata) {
485         return msg.data;
486     }
487 }
488 
489 // File: @openzeppelin/contracts/access/Ownable.sol
490 
491 
492 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 
497 /**
498  * @dev Contract module which provides a basic access control mechanism, where
499  * there is an account (an owner) that can be granted exclusive access to
500  * specific functions.
501  *
502  * By default, the owner account will be the one that deploys the contract. This
503  * can later be changed with {transferOwnership}.
504  *
505  * This module is used through inheritance. It will make available the modifier
506  * `onlyOwner`, which can be applied to your functions to restrict their use to
507  * the owner.
508  */
509 abstract contract Ownable is Context {
510     address private _owner;
511 
512     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
513 
514     /**
515      * @dev Initializes the contract setting the deployer as the initial owner.
516      */
517     constructor() {
518         _transferOwnership(_msgSender());
519     }
520 
521     /**
522      * @dev Returns the address of the current owner.
523      */
524     function owner() public view virtual returns (address) {
525         return _owner;
526     }
527 
528     /**
529      * @dev Throws if called by any account other than the owner.
530      */
531     modifier onlyOwner() {
532         require(owner() == _msgSender(), "Ownable: caller is not the owner");
533         _;
534     }
535 
536     /**
537      * @dev Leaves the contract without owner. It will not be possible to call
538      * `onlyOwner` functions anymore. Can only be called by the current owner.
539      *
540      * NOTE: Renouncing ownership will leave the contract without an owner,
541      * thereby removing any functionality that is only available to the owner.
542      */
543     function renounceOwnership() public virtual onlyOwner {
544         _transferOwnership(address(0));
545     }
546 
547     /**
548      * @dev Transfers ownership of the contract to a new account (`newOwner`).
549      * Can only be called by the current owner.
550      */
551     function transferOwnership(address newOwner) public virtual onlyOwner {
552         require(newOwner != address(0), "Ownable: new owner is the zero address");
553         _transferOwnership(newOwner);
554     }
555 
556     /**
557      * @dev Transfers ownership of the contract to a new account (`newOwner`).
558      * Internal function without access restriction.
559      */
560     function _transferOwnership(address newOwner) internal virtual {
561         address oldOwner = _owner;
562         _owner = newOwner;
563         emit OwnershipTransferred(oldOwner, newOwner);
564     }
565 }
566 
567 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
568 
569 
570 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
571 
572 pragma solidity ^0.8.0;
573 
574 /**
575  * @dev Interface of the ERC20 standard as defined in the EIP.
576  */
577 interface IERC20 {
578     /**
579      * @dev Returns the amount of tokens in existence.
580      */
581     function totalSupply() external view returns (uint256);
582 
583     /**
584      * @dev Returns the amount of tokens owned by `account`.
585      */
586     function balanceOf(address account) external view returns (uint256);
587 
588     /**
589      * @dev Moves `amount` tokens from the caller's account to `to`.
590      *
591      * Returns a boolean value indicating whether the operation succeeded.
592      *
593      * Emits a {Transfer} event.
594      */
595     function transfer(address to, uint256 amount) external returns (bool);
596 
597     /**
598      * @dev Returns the remaining number of tokens that `spender` will be
599      * allowed to spend on behalf of `owner` through {transferFrom}. This is
600      * zero by default.
601      *
602      * This value changes when {approve} or {transferFrom} are called.
603      */
604     function allowance(address owner, address spender) external view returns (uint256);
605 
606     /**
607      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
608      *
609      * Returns a boolean value indicating whether the operation succeeded.
610      *
611      * IMPORTANT: Beware that changing an allowance with this method brings the risk
612      * that someone may use both the old and the new allowance by unfortunate
613      * transaction ordering. One possible solution to mitigate this race
614      * condition is to first reduce the spender's allowance to 0 and set the
615      * desired value afterwards:
616      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
617      *
618      * Emits an {Approval} event.
619      */
620     function approve(address spender, uint256 amount) external returns (bool);
621 
622     /**
623      * @dev Moves `amount` tokens from `from` to `to` using the
624      * allowance mechanism. `amount` is then deducted from the caller's
625      * allowance.
626      *
627      * Returns a boolean value indicating whether the operation succeeded.
628      *
629      * Emits a {Transfer} event.
630      */
631     function transferFrom(
632         address from,
633         address to,
634         uint256 amount
635     ) external returns (bool);
636 
637     /**
638      * @dev Emitted when `value` tokens are moved from one account (`from`) to
639      * another (`to`).
640      *
641      * Note that `value` may be zero.
642      */
643     event Transfer(address indexed from, address indexed to, uint256 value);
644 
645     /**
646      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
647      * a call to {approve}. `value` is the new allowance.
648      */
649     event Approval(address indexed owner, address indexed spender, uint256 value);
650 }
651 
652 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
653 
654 
655 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
656 
657 pragma solidity ^0.8.0;
658 
659 
660 
661 /**
662  * @title SafeERC20
663  * @dev Wrappers around ERC20 operations that throw on failure (when the token
664  * contract returns false). Tokens that return no value (and instead revert or
665  * throw on failure) are also supported, non-reverting calls are assumed to be
666  * successful.
667  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
668  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
669  */
670 library SafeERC20 {
671     using Address for address;
672 
673     function safeTransfer(
674         IERC20 token,
675         address to,
676         uint256 value
677     ) internal {
678         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
679     }
680 
681     function safeTransferFrom(
682         IERC20 token,
683         address from,
684         address to,
685         uint256 value
686     ) internal {
687         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
688     }
689 
690     /**
691      * @dev Deprecated. This function has issues similar to the ones found in
692      * {IERC20-approve}, and its usage is discouraged.
693      *
694      * Whenever possible, use {safeIncreaseAllowance} and
695      * {safeDecreaseAllowance} instead.
696      */
697     function safeApprove(
698         IERC20 token,
699         address spender,
700         uint256 value
701     ) internal {
702         // safeApprove should only be called when setting an initial allowance,
703         // or when resetting it to zero. To increase and decrease it, use
704         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
705         require(
706             (value == 0) || (token.allowance(address(this), spender) == 0),
707             "SafeERC20: approve from non-zero to non-zero allowance"
708         );
709         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
710     }
711 
712     function safeIncreaseAllowance(
713         IERC20 token,
714         address spender,
715         uint256 value
716     ) internal {
717         uint256 newAllowance = token.allowance(address(this), spender) + value;
718         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
719     }
720 
721     function safeDecreaseAllowance(
722         IERC20 token,
723         address spender,
724         uint256 value
725     ) internal {
726         unchecked {
727             uint256 oldAllowance = token.allowance(address(this), spender);
728             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
729             uint256 newAllowance = oldAllowance - value;
730             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
731         }
732     }
733 
734     /**
735      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
736      * on the return value: the return value is optional (but if data is returned, it must not be false).
737      * @param token The token targeted by the call.
738      * @param data The call data (encoded using abi.encode or one of its variants).
739      */
740     function _callOptionalReturn(IERC20 token, bytes memory data) private {
741         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
742         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
743         // the target address contains contract code and also asserts for success in the low-level call.
744 
745         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
746         if (returndata.length > 0) {
747             // Return data is optional
748             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
749         }
750     }
751 }
752 
753 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
754 
755 
756 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
757 
758 pragma solidity ^0.8.0;
759 
760 
761 /**
762  * @dev Interface for the optional metadata functions from the ERC20 standard.
763  *
764  * _Available since v4.1._
765  */
766 interface IERC20Metadata is IERC20 {
767     /**
768      * @dev Returns the name of the token.
769      */
770     function name() external view returns (string memory);
771 
772     /**
773      * @dev Returns the symbol of the token.
774      */
775     function symbol() external view returns (string memory);
776 
777     /**
778      * @dev Returns the decimals places of the token.
779      */
780     function decimals() external view returns (uint8);
781 }
782 
783 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
784 
785 
786 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
787 
788 pragma solidity ^0.8.0;
789 
790 
791 
792 
793 /**
794  * @dev Implementation of the {IERC20} interface.
795  *
796  * This implementation is agnostic to the way tokens are created. This means
797  * that a supply mechanism has to be added in a derived contract using {_mint}.
798  * For a generic mechanism see {ERC20PresetMinterPauser}.
799  *
800  * TIP: For a detailed writeup see our guide
801  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
802  * to implement supply mechanisms].
803  *
804  * We have followed general OpenZeppelin Contracts guidelines: functions revert
805  * instead returning `false` on failure. This behavior is nonetheless
806  * conventional and does not conflict with the expectations of ERC20
807  * applications.
808  *
809  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
810  * This allows applications to reconstruct the allowance for all accounts just
811  * by listening to said events. Other implementations of the EIP may not emit
812  * these events, as it isn't required by the specification.
813  *
814  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
815  * functions have been added to mitigate the well-known issues around setting
816  * allowances. See {IERC20-approve}.
817  */
818 contract ERC20 is Context, IERC20, IERC20Metadata {
819     mapping(address => uint256) private _balances;
820 
821     mapping(address => mapping(address => uint256)) private _allowances;
822 
823     uint256 private _totalSupply;
824 
825     string private _name;
826     string private _symbol;
827 
828     /**
829      * @dev Sets the values for {name} and {symbol}.
830      *
831      * The default value of {decimals} is 18. To select a different value for
832      * {decimals} you should overload it.
833      *
834      * All two of these values are immutable: they can only be set once during
835      * construction.
836      */
837     constructor(string memory name_, string memory symbol_) {
838         _name = name_;
839         _symbol = symbol_;
840     }
841 
842     /**
843      * @dev Returns the name of the token.
844      */
845     function name() public view virtual override returns (string memory) {
846         return _name;
847     }
848 
849     /**
850      * @dev Returns the symbol of the token, usually a shorter version of the
851      * name.
852      */
853     function symbol() public view virtual override returns (string memory) {
854         return _symbol;
855     }
856 
857     /**
858      * @dev Returns the number of decimals used to get its user representation.
859      * For example, if `decimals` equals `2`, a balance of `505` tokens should
860      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
861      *
862      * Tokens usually opt for a value of 18, imitating the relationship between
863      * Ether and Wei. This is the value {ERC20} uses, unless this function is
864      * overridden;
865      *
866      * NOTE: This information is only used for _display_ purposes: it in
867      * no way affects any of the arithmetic of the contract, including
868      * {IERC20-balanceOf} and {IERC20-transfer}.
869      */
870     function decimals() public view virtual override returns (uint8) {
871         return 18;
872     }
873 
874     /**
875      * @dev See {IERC20-totalSupply}.
876      */
877     function totalSupply() public view virtual override returns (uint256) {
878         return _totalSupply;
879     }
880 
881     /**
882      * @dev See {IERC20-balanceOf}.
883      */
884     function balanceOf(address account) public view virtual override returns (uint256) {
885         return _balances[account];
886     }
887 
888     /**
889      * @dev See {IERC20-transfer}.
890      *
891      * Requirements:
892      *
893      * - `to` cannot be the zero address.
894      * - the caller must have a balance of at least `amount`.
895      */
896     function transfer(address to, uint256 amount) public virtual override returns (bool) {
897         address owner = _msgSender();
898         _transfer(owner, to, amount);
899         return true;
900     }
901 
902     /**
903      * @dev See {IERC20-allowance}.
904      */
905     function allowance(address owner, address spender) public view virtual override returns (uint256) {
906         return _allowances[owner][spender];
907     }
908 
909     /**
910      * @dev See {IERC20-approve}.
911      *
912      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
913      * `transferFrom`. This is semantically equivalent to an infinite approval.
914      *
915      * Requirements:
916      *
917      * - `spender` cannot be the zero address.
918      */
919     function approve(address spender, uint256 amount) public virtual override returns (bool) {
920         address owner = _msgSender();
921         _approve(owner, spender, amount);
922         return true;
923     }
924 
925     /**
926      * @dev See {IERC20-transferFrom}.
927      *
928      * Emits an {Approval} event indicating the updated allowance. This is not
929      * required by the EIP. See the note at the beginning of {ERC20}.
930      *
931      * NOTE: Does not update the allowance if the current allowance
932      * is the maximum `uint256`.
933      *
934      * Requirements:
935      *
936      * - `from` and `to` cannot be the zero address.
937      * - `from` must have a balance of at least `amount`.
938      * - the caller must have allowance for ``from``'s tokens of at least
939      * `amount`.
940      */
941     function transferFrom(
942         address from,
943         address to,
944         uint256 amount
945     ) public virtual override returns (bool) {
946         address spender = _msgSender();
947         _spendAllowance(from, spender, amount);
948         _transfer(from, to, amount);
949         return true;
950     }
951 
952     /**
953      * @dev Atomically increases the allowance granted to `spender` by the caller.
954      *
955      * This is an alternative to {approve} that can be used as a mitigation for
956      * problems described in {IERC20-approve}.
957      *
958      * Emits an {Approval} event indicating the updated allowance.
959      *
960      * Requirements:
961      *
962      * - `spender` cannot be the zero address.
963      */
964     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
965         address owner = _msgSender();
966         _approve(owner, spender, _allowances[owner][spender] + addedValue);
967         return true;
968     }
969 
970     /**
971      * @dev Atomically decreases the allowance granted to `spender` by the caller.
972      *
973      * This is an alternative to {approve} that can be used as a mitigation for
974      * problems described in {IERC20-approve}.
975      *
976      * Emits an {Approval} event indicating the updated allowance.
977      *
978      * Requirements:
979      *
980      * - `spender` cannot be the zero address.
981      * - `spender` must have allowance for the caller of at least
982      * `subtractedValue`.
983      */
984     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
985         address owner = _msgSender();
986         uint256 currentAllowance = _allowances[owner][spender];
987         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
988         unchecked {
989             _approve(owner, spender, currentAllowance - subtractedValue);
990         }
991 
992         return true;
993     }
994 
995     /**
996      * @dev Moves `amount` of tokens from `sender` to `recipient`.
997      *
998      * This internal function is equivalent to {transfer}, and can be used to
999      * e.g. implement automatic token fees, slashing mechanisms, etc.
1000      *
1001      * Emits a {Transfer} event.
1002      *
1003      * Requirements:
1004      *
1005      * - `from` cannot be the zero address.
1006      * - `to` cannot be the zero address.
1007      * - `from` must have a balance of at least `amount`.
1008      */
1009     function _transfer(
1010         address from,
1011         address to,
1012         uint256 amount
1013     ) internal virtual {
1014         require(from != address(0), "ERC20: transfer from the zero address");
1015         require(to != address(0), "ERC20: transfer to the zero address");
1016 
1017         _beforeTokenTransfer(from, to, amount);
1018 
1019         uint256 fromBalance = _balances[from];
1020         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1021         unchecked {
1022             _balances[from] = fromBalance - amount;
1023         }
1024         _balances[to] += amount;
1025 
1026         emit Transfer(from, to, amount);
1027 
1028         _afterTokenTransfer(from, to, amount);
1029     }
1030 
1031     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1032      * the total supply.
1033      *
1034      * Emits a {Transfer} event with `from` set to the zero address.
1035      *
1036      * Requirements:
1037      *
1038      * - `account` cannot be the zero address.
1039      */
1040     function _mint(address account, uint256 amount) internal virtual {
1041         require(account != address(0), "ERC20: mint to the zero address");
1042 
1043         _beforeTokenTransfer(address(0), account, amount);
1044 
1045         _totalSupply += amount;
1046         _balances[account] += amount;
1047         emit Transfer(address(0), account, amount);
1048 
1049         _afterTokenTransfer(address(0), account, amount);
1050     }
1051 
1052     /**
1053      * @dev Destroys `amount` tokens from `account`, reducing the
1054      * total supply.
1055      *
1056      * Emits a {Transfer} event with `to` set to the zero address.
1057      *
1058      * Requirements:
1059      *
1060      * - `account` cannot be the zero address.
1061      * - `account` must have at least `amount` tokens.
1062      */
1063     function _burn(address account, uint256 amount) internal virtual {
1064         require(account != address(0), "ERC20: burn from the zero address");
1065 
1066         _beforeTokenTransfer(account, address(0), amount);
1067 
1068         uint256 accountBalance = _balances[account];
1069         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1070         unchecked {
1071             _balances[account] = accountBalance - amount;
1072         }
1073         _totalSupply -= amount;
1074 
1075         emit Transfer(account, address(0), amount);
1076 
1077         _afterTokenTransfer(account, address(0), amount);
1078     }
1079 
1080     /**
1081      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1082      *
1083      * This internal function is equivalent to `approve`, and can be used to
1084      * e.g. set automatic allowances for certain subsystems, etc.
1085      *
1086      * Emits an {Approval} event.
1087      *
1088      * Requirements:
1089      *
1090      * - `owner` cannot be the zero address.
1091      * - `spender` cannot be the zero address.
1092      */
1093     function _approve(
1094         address owner,
1095         address spender,
1096         uint256 amount
1097     ) internal virtual {
1098         require(owner != address(0), "ERC20: approve from the zero address");
1099         require(spender != address(0), "ERC20: approve to the zero address");
1100 
1101         _allowances[owner][spender] = amount;
1102         emit Approval(owner, spender, amount);
1103     }
1104 
1105     /**
1106      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
1107      *
1108      * Does not update the allowance amount in case of infinite allowance.
1109      * Revert if not enough allowance is available.
1110      *
1111      * Might emit an {Approval} event.
1112      */
1113     function _spendAllowance(
1114         address owner,
1115         address spender,
1116         uint256 amount
1117     ) internal virtual {
1118         uint256 currentAllowance = allowance(owner, spender);
1119         if (currentAllowance != type(uint256).max) {
1120             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1121             unchecked {
1122                 _approve(owner, spender, currentAllowance - amount);
1123             }
1124         }
1125     }
1126 
1127     /**
1128      * @dev Hook that is called before any transfer of tokens. This includes
1129      * minting and burning.
1130      *
1131      * Calling conditions:
1132      *
1133      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1134      * will be transferred to `to`.
1135      * - when `from` is zero, `amount` tokens will be minted for `to`.
1136      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1137      * - `from` and `to` are never both zero.
1138      *
1139      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1140      */
1141     function _beforeTokenTransfer(
1142         address from,
1143         address to,
1144         uint256 amount
1145     ) internal virtual {}
1146 
1147     /**
1148      * @dev Hook that is called after any transfer of tokens. This includes
1149      * minting and burning.
1150      *
1151      * Calling conditions:
1152      *
1153      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1154      * has been transferred to `to`.
1155      * - when `from` is zero, `amount` tokens have been minted for `to`.
1156      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1157      * - `from` and `to` are never both zero.
1158      *
1159      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1160      */
1161     function _afterTokenTransfer(
1162         address from,
1163         address to,
1164         uint256 amount
1165     ) internal virtual {}
1166 }
1167 
1168 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1169 
1170 
1171 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1172 
1173 pragma solidity ^0.8.0;
1174 
1175 // CAUTION
1176 // This version of SafeMath should only be used with Solidity 0.8 or later,
1177 // because it relies on the compiler's built in overflow checks.
1178 
1179 /**
1180  * @dev Wrappers over Solidity's arithmetic operations.
1181  *
1182  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1183  * now has built in overflow checking.
1184  */
1185 library SafeMath {
1186     /**
1187      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1188      *
1189      * _Available since v3.4._
1190      */
1191     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1192         unchecked {
1193             uint256 c = a + b;
1194             if (c < a) return (false, 0);
1195             return (true, c);
1196         }
1197     }
1198 
1199     /**
1200      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1201      *
1202      * _Available since v3.4._
1203      */
1204     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1205         unchecked {
1206             if (b > a) return (false, 0);
1207             return (true, a - b);
1208         }
1209     }
1210 
1211     /**
1212      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1213      *
1214      * _Available since v3.4._
1215      */
1216     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1217         unchecked {
1218             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1219             // benefit is lost if 'b' is also tested.
1220             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1221             if (a == 0) return (true, 0);
1222             uint256 c = a * b;
1223             if (c / a != b) return (false, 0);
1224             return (true, c);
1225         }
1226     }
1227 
1228     /**
1229      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1230      *
1231      * _Available since v3.4._
1232      */
1233     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1234         unchecked {
1235             if (b == 0) return (false, 0);
1236             return (true, a / b);
1237         }
1238     }
1239 
1240     /**
1241      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1242      *
1243      * _Available since v3.4._
1244      */
1245     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1246         unchecked {
1247             if (b == 0) return (false, 0);
1248             return (true, a % b);
1249         }
1250     }
1251 
1252     /**
1253      * @dev Returns the addition of two unsigned integers, reverting on
1254      * overflow.
1255      *
1256      * Counterpart to Solidity's `+` operator.
1257      *
1258      * Requirements:
1259      *
1260      * - Addition cannot overflow.
1261      */
1262     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1263         return a + b;
1264     }
1265 
1266     /**
1267      * @dev Returns the subtraction of two unsigned integers, reverting on
1268      * overflow (when the result is negative).
1269      *
1270      * Counterpart to Solidity's `-` operator.
1271      *
1272      * Requirements:
1273      *
1274      * - Subtraction cannot overflow.
1275      */
1276     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1277         return a - b;
1278     }
1279 
1280     /**
1281      * @dev Returns the multiplication of two unsigned integers, reverting on
1282      * overflow.
1283      *
1284      * Counterpart to Solidity's `*` operator.
1285      *
1286      * Requirements:
1287      *
1288      * - Multiplication cannot overflow.
1289      */
1290     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1291         return a * b;
1292     }
1293 
1294     /**
1295      * @dev Returns the integer division of two unsigned integers, reverting on
1296      * division by zero. The result is rounded towards zero.
1297      *
1298      * Counterpart to Solidity's `/` operator.
1299      *
1300      * Requirements:
1301      *
1302      * - The divisor cannot be zero.
1303      */
1304     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1305         return a / b;
1306     }
1307 
1308     /**
1309      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1310      * reverting when dividing by zero.
1311      *
1312      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1313      * opcode (which leaves remaining gas untouched) while Solidity uses an
1314      * invalid opcode to revert (consuming all remaining gas).
1315      *
1316      * Requirements:
1317      *
1318      * - The divisor cannot be zero.
1319      */
1320     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1321         return a % b;
1322     }
1323 
1324     /**
1325      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1326      * overflow (when the result is negative).
1327      *
1328      * CAUTION: This function is deprecated because it requires allocating memory for the error
1329      * message unnecessarily. For custom revert reasons use {trySub}.
1330      *
1331      * Counterpart to Solidity's `-` operator.
1332      *
1333      * Requirements:
1334      *
1335      * - Subtraction cannot overflow.
1336      */
1337     function sub(
1338         uint256 a,
1339         uint256 b,
1340         string memory errorMessage
1341     ) internal pure returns (uint256) {
1342         unchecked {
1343             require(b <= a, errorMessage);
1344             return a - b;
1345         }
1346     }
1347 
1348     /**
1349      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1350      * division by zero. The result is rounded towards zero.
1351      *
1352      * Counterpart to Solidity's `/` operator. Note: this function uses a
1353      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1354      * uses an invalid opcode to revert (consuming all remaining gas).
1355      *
1356      * Requirements:
1357      *
1358      * - The divisor cannot be zero.
1359      */
1360     function div(
1361         uint256 a,
1362         uint256 b,
1363         string memory errorMessage
1364     ) internal pure returns (uint256) {
1365         unchecked {
1366             require(b > 0, errorMessage);
1367             return a / b;
1368         }
1369     }
1370 
1371     /**
1372      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1373      * reverting with custom message when dividing by zero.
1374      *
1375      * CAUTION: This function is deprecated because it requires allocating memory for the error
1376      * message unnecessarily. For custom revert reasons use {tryMod}.
1377      *
1378      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1379      * opcode (which leaves remaining gas untouched) while Solidity uses an
1380      * invalid opcode to revert (consuming all remaining gas).
1381      *
1382      * Requirements:
1383      *
1384      * - The divisor cannot be zero.
1385      */
1386     function mod(
1387         uint256 a,
1388         uint256 b,
1389         string memory errorMessage
1390     ) internal pure returns (uint256) {
1391         unchecked {
1392             require(b > 0, errorMessage);
1393             return a % b;
1394         }
1395     }
1396 }
1397 
1398 
1399 pragma solidity ^0.8.4;
1400 
1401 
1402 
1403 
1404 
1405 
1406 
1407 
1408 contract Deelance_Fluid_Staking is Ownable, Initializable, ReentrancyGuard {
1409 
1410     IERC20 public s_rewardsToken;
1411     IERC20 public s_stakingToken;
1412     // Staker info
1413     struct Staker {
1414         // The deposited tokens of the Staker
1415         uint256 deposited;
1416         // Last time of details update for Deposit
1417         uint256 timeOfLastUpdate;
1418         // Calculated, but unclaimed rewards. These are calculated each time
1419         // a user writes to the contract.
1420         uint256 unclaimedRewards;
1421     }
1422 
1423     
1424     uint256 public rewardsPerHour = 171; 
1425 
1426     // Minimum amount to stake
1427     uint256 public minStake = 800 * 10**18;
1428     uint256 public maxStake = 10000000000 * 10**18;
1429 
1430     uint256 public total_staked = 0;
1431 
1432     bool public isStakingActive = false;
1433 
1434     // Compounding frequency limit in seconds
1435     uint256 public compoundFreq = 14400; //4 hours
1436 
1437     // Mapping of address to Staker info
1438     mapping(address => Staker) internal stakers;
1439 
1440     event Staked(address indexed user, uint256 indexed amount);
1441     event WithdrewStake(address indexed user, uint256 indexed amount);
1442     event RewardsClaimed(address indexed user, uint256 indexed amount);
1443 
1444     // Constructor function
1445     constructor() {
1446         s_stakingToken = IERC20(0x7D60dE2E7D92Cb5C863bC82f8d59b37C59fC0A7A);
1447         s_rewardsToken = IERC20(0x7D60dE2E7D92Cb5C863bC82f8d59b37C59fC0A7A);
1448     }
1449 
1450     // If address has no Staker struct, initiate one. If address already was a stake,
1451     // calculate the rewards and add them to unclaimedRewards, reset the last time of
1452     // deposit and then add _amount to the already deposited amount.
1453     // stakes the amount staked.
1454     function deposit(uint256 _amount) external nonReentrant {
1455         require(isStakingActive != false, "Staking is not active");
1456         require(_amount >= minStake, "Amount smaller than minimimum deposit");
1457         require(_amount <= maxStake, "Amount is more than maximum deposit");
1458         require( stakers[msg.sender].deposited <= maxStake, "Amount is more than maximum deposit");
1459         require(
1460             IERC20(s_stakingToken).balanceOf(msg.sender) >= _amount,
1461             "Can't stake more than you own"
1462         );
1463         if (stakers[msg.sender].deposited == 0) {
1464             stakers[msg.sender].deposited = _amount;
1465             stakers[msg.sender].timeOfLastUpdate = block.timestamp;
1466         } else {
1467             uint256 rewards = calculateRewards(msg.sender);
1468             stakers[msg.sender].unclaimedRewards += rewards;
1469             stakers[msg.sender].deposited += _amount;
1470             stakers[msg.sender].timeOfLastUpdate = block.timestamp;
1471         }
1472         emit Staked(msg.sender, _amount);
1473         s_stakingToken.transferFrom(msg.sender, address(this), _amount);
1474         total_staked = total_staked + _amount;
1475     }
1476 
1477     function setisStakingActive (bool value) external onlyOwner{
1478         isStakingActive = value;
1479     }
1480 
1481     function setrewardPerhour (uint256 value) external onlyOwner{
1482         rewardsPerHour = value;
1483     }
1484 
1485     function setcompoundFreq (uint256 value) external onlyOwner{
1486         compoundFreq = value;
1487     }
1488 
1489     function setMinStakeamt (uint256 value) external onlyOwner{
1490         minStake = value;
1491     }
1492 
1493     function setMaxStakeamt (uint256 value) external onlyOwner{
1494         maxStake = value;
1495     }
1496 
1497     // Compound the rewards and reset the last time of update for Deposit info
1498     function stakeRewards() external nonReentrant {
1499         require(isStakingActive != false, "Staking is not active");
1500         require(stakers[msg.sender].deposited > 0, "You have no deposit");
1501         require(
1502             compoundRewardsTimer(msg.sender) == 0,
1503             "Tried to compound rewars too soon"
1504         );
1505         uint256 rewards = calculateRewards(msg.sender) +
1506             stakers[msg.sender].unclaimedRewards;
1507         stakers[msg.sender].unclaimedRewards = 0;
1508         stakers[msg.sender].deposited += rewards;
1509         stakers[msg.sender].timeOfLastUpdate = block.timestamp;
1510         total_staked = total_staked + rewards;
1511     }
1512 
1513     // release rewards for msg.sender
1514     function claimRewards() external nonReentrant {
1515         uint256 rewards = calculateRewards(msg.sender) +
1516             stakers[msg.sender].unclaimedRewards;
1517         require(rewards > 0, "You have no rewards");
1518         stakers[msg.sender].unclaimedRewards = 0;
1519         stakers[msg.sender].timeOfLastUpdate = block.timestamp;
1520         emit RewardsClaimed(msg.sender, rewards);
1521         s_rewardsToken.transfer(msg.sender, rewards);
1522     }
1523 
1524     // Withdraw specified amount of staked tokens
1525     function withdraw(uint256 _amount) external nonReentrant {
1526         require(
1527             stakers[msg.sender].deposited >= _amount,
1528             "Can't withdraw more than you have"
1529         );
1530         uint256 _rewards = calculateRewards(msg.sender);
1531         stakers[msg.sender].deposited -= _amount;
1532         stakers[msg.sender].unclaimedRewards += _rewards;
1533         stakers[msg.sender].timeOfLastUpdate = block.timestamp;
1534         emit WithdrewStake(msg.sender, _amount);
1535         s_stakingToken.transfer(msg.sender, _amount);
1536         total_staked = total_staked - _amount;
1537     }
1538 
1539     // Function useful for fron-end that returns user stake and rewards by address
1540     function getDepositInfo(address _user)
1541         public
1542         view
1543         returns (uint256 _stake, uint256 _rewards)
1544     {
1545         _stake = stakers[_user].deposited;
1546         _rewards =
1547             calculateRewards(_user) +
1548             stakers[_user].unclaimedRewards;
1549         return (_stake, _rewards);
1550     }
1551 
1552     // Utility function that returns the timer for restaking rewards
1553     function compoundRewardsTimer(address _user)
1554         public
1555         view
1556         returns (uint256 _timer)
1557     {
1558         if (stakers[_user].timeOfLastUpdate + compoundFreq <= block.timestamp) {
1559             return 0;
1560         } else {
1561             return
1562                 (stakers[_user].timeOfLastUpdate + compoundFreq) -
1563                 block.timestamp;
1564         }
1565     }
1566 
1567     function recoverothertokens(address tokenAddress, uint256 tokenAmount) public  onlyOwner {
1568         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1569     }
1570 
1571    
1572     function recoveretoken(address payable destination) public onlyOwner {
1573         destination.transfer(address(this).balance);
1574     }
1575 
1576     // Calculate the rewards since the last update on Deposit info
1577     function calculateRewards(address _staker)
1578         internal
1579         view
1580         returns (uint256 rewards)
1581     {
1582         return (((((block.timestamp - stakers[_staker].timeOfLastUpdate) *
1583             stakers[_staker].deposited) * rewardsPerHour) / 3600) / 10000000);
1584     }
1585 }