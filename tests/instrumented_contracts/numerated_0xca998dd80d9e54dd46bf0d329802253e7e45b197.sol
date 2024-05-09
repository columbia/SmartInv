1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      *
28      * Furthermore, `isContract` will also return true if the target contract within
29      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
30      * which only has an effect at the end of a transaction.
31      * ====
32      *
33      * [IMPORTANT]
34      * ====
35      * You shouldn't rely on `isContract` to protect against flash loan attacks!
36      *
37      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
38      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
39      * constructor.
40      * ====
41      */
42     function isContract(address account) internal view returns (bool) {
43         // This method relies on extcodesize/address.code.length, which returns 0
44         // for contracts in construction, since the code is only stored at the end
45         // of the constructor execution.
46 
47         return account.code.length > 0;
48     }
49 
50     /**
51      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
52      * `recipient`, forwarding all available gas and reverting on errors.
53      *
54      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
55      * of certain opcodes, possibly making contracts go over the 2300 gas limit
56      * imposed by `transfer`, making them unable to receive funds via
57      * `transfer`. {sendValue} removes this limitation.
58      *
59      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
60      *
61      * IMPORTANT: because control is transferred to `recipient`, care must be
62      * taken to not create reentrancy vulnerabilities. Consider using
63      * {ReentrancyGuard} or the
64      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
65      */
66     function sendValue(address payable recipient, uint256 amount) internal {
67         require(address(this).balance >= amount, "Address: insufficient balance");
68 
69         (bool success, ) = recipient.call{value: amount}("");
70         require(success, "Address: unable to send value, recipient may have reverted");
71     }
72 
73     /**
74      * @dev Performs a Solidity function call using a low level `call`. A
75      * plain `call` is an unsafe replacement for a function call: use this
76      * function instead.
77      *
78      * If `target` reverts with a revert reason, it is bubbled up by this
79      * function (like regular Solidity function calls).
80      *
81      * Returns the raw returned data. To convert to the expected return value,
82      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
83      *
84      * Requirements:
85      *
86      * - `target` must be a contract.
87      * - calling `target` with `data` must not revert.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
92         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
93     }
94 
95     /**
96      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
97      * `errorMessage` as a fallback revert reason when `target` reverts.
98      *
99      * _Available since v3.1._
100      */
101     function functionCall(
102         address target,
103         bytes memory data,
104         string memory errorMessage
105     ) internal returns (bytes memory) {
106         return functionCallWithValue(target, data, 0, errorMessage);
107     }
108 
109     /**
110      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
111      * but also transferring `value` wei to `target`.
112      *
113      * Requirements:
114      *
115      * - the calling contract must have an ETH balance of at least `value`.
116      * - the called Solidity function must be `payable`.
117      *
118      * _Available since v3.1._
119      */
120     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
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
137         (bool success, bytes memory returndata) = target.call{value: value}(data);
138         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
139     }
140 
141     /**
142      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
143      * but performing a static call.
144      *
145      * _Available since v3.3._
146      */
147     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
148         return functionStaticCall(target, data, "Address: low-level static call failed");
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
153      * but performing a static call.
154      *
155      * _Available since v3.3._
156      */
157     function functionStaticCall(
158         address target,
159         bytes memory data,
160         string memory errorMessage
161     ) internal view returns (bytes memory) {
162         (bool success, bytes memory returndata) = target.staticcall(data);
163         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
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
187         (bool success, bytes memory returndata) = target.delegatecall(data);
188         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
189     }
190 
191     /**
192      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
193      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
194      *
195      * _Available since v4.8._
196      */
197     function verifyCallResultFromTarget(
198         address target,
199         bool success,
200         bytes memory returndata,
201         string memory errorMessage
202     ) internal view returns (bytes memory) {
203         if (success) {
204             if (returndata.length == 0) {
205                 // only check isContract if the call was successful and the return data is empty
206                 // otherwise we already know that it was a contract
207                 require(isContract(target), "Address: call to non-contract");
208             }
209             return returndata;
210         } else {
211             _revert(returndata, errorMessage);
212         }
213     }
214 
215     /**
216      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
217      * revert reason or using the provided one.
218      *
219      * _Available since v4.3._
220      */
221     function verifyCallResult(
222         bool success,
223         bytes memory returndata,
224         string memory errorMessage
225     ) internal pure returns (bytes memory) {
226         if (success) {
227             return returndata;
228         } else {
229             _revert(returndata, errorMessage);
230         }
231     }
232 
233     function _revert(bytes memory returndata, string memory errorMessage) private pure {
234         // Look for revert reason and bubble it up if present
235         if (returndata.length > 0) {
236             // The easiest way to bubble the revert reason is using memory via assembly
237             /// @solidity memory-safe-assembly
238             assembly {
239                 let returndata_size := mload(returndata)
240                 revert(add(32, returndata), returndata_size)
241             }
242         } else {
243             revert(errorMessage);
244         }
245     }
246 }
247 
248 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol
249 
250 
251 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/IERC20Permit.sol)
252 
253 pragma solidity ^0.8.0;
254 
255 /**
256  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
257  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
258  *
259  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
260  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
261  * need to send a transaction, and thus is not required to hold Ether at all.
262  */
263 interface IERC20Permit {
264     /**
265      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
266      * given ``owner``'s signed approval.
267      *
268      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
269      * ordering also apply here.
270      *
271      * Emits an {Approval} event.
272      *
273      * Requirements:
274      *
275      * - `spender` cannot be the zero address.
276      * - `deadline` must be a timestamp in the future.
277      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
278      * over the EIP712-formatted function arguments.
279      * - the signature must use ``owner``'s current nonce (see {nonces}).
280      *
281      * For more information on the signature format, see the
282      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
283      * section].
284      */
285     function permit(
286         address owner,
287         address spender,
288         uint256 value,
289         uint256 deadline,
290         uint8 v,
291         bytes32 r,
292         bytes32 s
293     ) external;
294 
295     /**
296      * @dev Returns the current nonce for `owner`. This value must be
297      * included whenever a signature is generated for {permit}.
298      *
299      * Every successful call to {permit} increases ``owner``'s nonce by one. This
300      * prevents a signature from being used multiple times.
301      */
302     function nonces(address owner) external view returns (uint256);
303 
304     /**
305      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
306      */
307     // solhint-disable-next-line func-name-mixedcase
308     function DOMAIN_SEPARATOR() external view returns (bytes32);
309 }
310 
311 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
312 
313 
314 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
315 
316 pragma solidity ^0.8.0;
317 
318 /**
319  * @dev Interface of the ERC20 standard as defined in the EIP.
320  */
321 interface IERC20 {
322     /**
323      * @dev Emitted when `value` tokens are moved from one account (`from`) to
324      * another (`to`).
325      *
326      * Note that `value` may be zero.
327      */
328     event Transfer(address indexed from, address indexed to, uint256 value);
329 
330     /**
331      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
332      * a call to {approve}. `value` is the new allowance.
333      */
334     event Approval(address indexed owner, address indexed spender, uint256 value);
335 
336     /**
337      * @dev Returns the amount of tokens in existence.
338      */
339     function totalSupply() external view returns (uint256);
340 
341     /**
342      * @dev Returns the amount of tokens owned by `account`.
343      */
344     function balanceOf(address account) external view returns (uint256);
345 
346     /**
347      * @dev Moves `amount` tokens from the caller's account to `to`.
348      *
349      * Returns a boolean value indicating whether the operation succeeded.
350      *
351      * Emits a {Transfer} event.
352      */
353     function transfer(address to, uint256 amount) external returns (bool);
354 
355     /**
356      * @dev Returns the remaining number of tokens that `spender` will be
357      * allowed to spend on behalf of `owner` through {transferFrom}. This is
358      * zero by default.
359      *
360      * This value changes when {approve} or {transferFrom} are called.
361      */
362     function allowance(address owner, address spender) external view returns (uint256);
363 
364     /**
365      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
366      *
367      * Returns a boolean value indicating whether the operation succeeded.
368      *
369      * IMPORTANT: Beware that changing an allowance with this method brings the risk
370      * that someone may use both the old and the new allowance by unfortunate
371      * transaction ordering. One possible solution to mitigate this race
372      * condition is to first reduce the spender's allowance to 0 and set the
373      * desired value afterwards:
374      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
375      *
376      * Emits an {Approval} event.
377      */
378     function approve(address spender, uint256 amount) external returns (bool);
379 
380     /**
381      * @dev Moves `amount` tokens from `from` to `to` using the
382      * allowance mechanism. `amount` is then deducted from the caller's
383      * allowance.
384      *
385      * Returns a boolean value indicating whether the operation succeeded.
386      *
387      * Emits a {Transfer} event.
388      */
389     function transferFrom(address from, address to, uint256 amount) external returns (bool);
390 }
391 
392 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
393 
394 
395 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/utils/SafeERC20.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 
400 
401 
402 /**
403  * @title SafeERC20
404  * @dev Wrappers around ERC20 operations that throw on failure (when the token
405  * contract returns false). Tokens that return no value (and instead revert or
406  * throw on failure) are also supported, non-reverting calls are assumed to be
407  * successful.
408  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
409  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
410  */
411 library SafeERC20 {
412     using Address for address;
413 
414     /**
415      * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
416      * non-reverting calls are assumed to be successful.
417      */
418     function safeTransfer(IERC20 token, address to, uint256 value) internal {
419         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
420     }
421 
422     /**
423      * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
424      * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
425      */
426     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
427         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
428     }
429 
430     /**
431      * @dev Deprecated. This function has issues similar to the ones found in
432      * {IERC20-approve}, and its usage is discouraged.
433      *
434      * Whenever possible, use {safeIncreaseAllowance} and
435      * {safeDecreaseAllowance} instead.
436      */
437     function safeApprove(IERC20 token, address spender, uint256 value) internal {
438         // safeApprove should only be called when setting an initial allowance,
439         // or when resetting it to zero. To increase and decrease it, use
440         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
441         require(
442             (value == 0) || (token.allowance(address(this), spender) == 0),
443             "SafeERC20: approve from non-zero to non-zero allowance"
444         );
445         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
446     }
447 
448     /**
449      * @dev Increase the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
450      * non-reverting calls are assumed to be successful.
451      */
452     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
453         uint256 oldAllowance = token.allowance(address(this), spender);
454         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance + value));
455     }
456 
457     /**
458      * @dev Decrease the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
459      * non-reverting calls are assumed to be successful.
460      */
461     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
462         unchecked {
463             uint256 oldAllowance = token.allowance(address(this), spender);
464             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
465             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance - value));
466         }
467     }
468 
469     /**
470      * @dev Set the calling contract's allowance toward `spender` to `value`. If `token` returns no value,
471      * non-reverting calls are assumed to be successful. Compatible with tokens that require the approval to be set to
472      * 0 before setting it to a non-zero value.
473      */
474     function forceApprove(IERC20 token, address spender, uint256 value) internal {
475         bytes memory approvalCall = abi.encodeWithSelector(token.approve.selector, spender, value);
476 
477         if (!_callOptionalReturnBool(token, approvalCall)) {
478             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
479             _callOptionalReturn(token, approvalCall);
480         }
481     }
482 
483     /**
484      * @dev Use a ERC-2612 signature to set the `owner` approval toward `spender` on `token`.
485      * Revert on invalid signature.
486      */
487     function safePermit(
488         IERC20Permit token,
489         address owner,
490         address spender,
491         uint256 value,
492         uint256 deadline,
493         uint8 v,
494         bytes32 r,
495         bytes32 s
496     ) internal {
497         uint256 nonceBefore = token.nonces(owner);
498         token.permit(owner, spender, value, deadline, v, r, s);
499         uint256 nonceAfter = token.nonces(owner);
500         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
501     }
502 
503     /**
504      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
505      * on the return value: the return value is optional (but if data is returned, it must not be false).
506      * @param token The token targeted by the call.
507      * @param data The call data (encoded using abi.encode or one of its variants).
508      */
509     function _callOptionalReturn(IERC20 token, bytes memory data) private {
510         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
511         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
512         // the target address contains contract code and also asserts for success in the low-level call.
513 
514         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
515         require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
516     }
517 
518     /**
519      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
520      * on the return value: the return value is optional (but if data is returned, it must not be false).
521      * @param token The token targeted by the call.
522      * @param data The call data (encoded using abi.encode or one of its variants).
523      *
524      * This is a variant of {_callOptionalReturn} that silents catches all reverts and returns a bool instead.
525      */
526     function _callOptionalReturnBool(IERC20 token, bytes memory data) private returns (bool) {
527         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
528         // we're implementing it ourselves. We cannot use {Address-functionCall} here since this should return false
529         // and not revert is the subcall reverts.
530 
531         (bool success, bytes memory returndata) = address(token).call(data);
532         return
533             success && (returndata.length == 0 || abi.decode(returndata, (bool))) && Address.isContract(address(token));
534     }
535 }
536 
537 // File: @openzeppelin/contracts/utils/Context.sol
538 
539 
540 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 /**
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
560         return msg.data;
561     }
562 }
563 
564 // File: @openzeppelin/contracts/access/Ownable.sol
565 
566 
567 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
568 
569 pragma solidity ^0.8.0;
570 
571 
572 /**
573  * @dev Contract module which provides a basic access control mechanism, where
574  * there is an account (an owner) that can be granted exclusive access to
575  * specific functions.
576  *
577  * By default, the owner account will be the one that deploys the contract. This
578  * can later be changed with {transferOwnership}.
579  *
580  * This module is used through inheritance. It will make available the modifier
581  * `onlyOwner`, which can be applied to your functions to restrict their use to
582  * the owner.
583  */
584 abstract contract Ownable is Context {
585     address private _owner;
586 
587     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
588 
589     /**
590      * @dev Initializes the contract setting the deployer as the initial owner.
591      */
592     constructor() {
593         _transferOwnership(_msgSender());
594     }
595 
596     /**
597      * @dev Throws if called by any account other than the owner.
598      */
599     modifier onlyOwner() {
600         _checkOwner();
601         _;
602     }
603 
604     /**
605      * @dev Returns the address of the current owner.
606      */
607     function owner() public view virtual returns (address) {
608         return _owner;
609     }
610 
611     /**
612      * @dev Throws if the sender is not the owner.
613      */
614     function _checkOwner() internal view virtual {
615         require(owner() == _msgSender(), "Ownable: caller is not the owner");
616     }
617 
618     /**
619      * @dev Leaves the contract without owner. It will not be possible to call
620      * `onlyOwner` functions. Can only be called by the current owner.
621      *
622      * NOTE: Renouncing ownership will leave the contract without an owner,
623      * thereby disabling any functionality that is only available to the owner.
624      */
625     function renounceOwnership() public virtual onlyOwner {
626         _transferOwnership(address(0));
627     }
628 
629     /**
630      * @dev Transfers ownership of the contract to a new account (`newOwner`).
631      * Can only be called by the current owner.
632      */
633     function transferOwnership(address newOwner) public virtual onlyOwner {
634         require(newOwner != address(0), "Ownable: new owner is the zero address");
635         _transferOwnership(newOwner);
636     }
637 
638     /**
639      * @dev Transfers ownership of the contract to a new account (`newOwner`).
640      * Internal function without access restriction.
641      */
642     function _transferOwnership(address newOwner) internal virtual {
643         address oldOwner = _owner;
644         _owner = newOwner;
645         emit OwnershipTransferred(oldOwner, newOwner);
646     }
647 }
648 
649 // File: IStakingPlatform.sol
650 
651 
652 pragma solidity =0.8.10;
653 
654 /// @author RetreebInc
655 /// @title Interface Staking Platform with fixed APY and lockup
656 interface IStakingPlatform {
657     /**
658      * @notice function that start the staking
659      * @dev set `startPeriod` to the current current `block.timestamp`
660      * set `lockupPeriod` which is `block.timestamp` + `lockupDuration`
661      * and `endPeriod` which is `startPeriod` + `stakingDuration`
662      */
663     function startStaking() external;
664 
665     /**
666      * @notice function that allows a user to deposit tokens
667      * @dev user must first approve the amount to deposit before calling this function,
668      * cannot exceed the `maxAmountStaked`
669      * @param amount, the amount to be deposited
670      * @dev `endPeriod` to equal 0 (Staking didn't started yet),
671      * or `endPeriod` more than current `block.timestamp` (staking not finished yet)
672      * @dev `totalStaked + amount` must be less than `stakingMax`
673      * @dev that the amount deposited should greater than 0
674      */
675     function deposit(uint amount) external;
676 
677     /**
678      * @notice function that allows a user to withdraw its initial deposit
679      * @dev must be called only when `block.timestamp` >= `endPeriod`
680      * @dev `block.timestamp` higher than `lockupPeriod` (lockupPeriod finished)
681      * withdraw reset all states variable for the `msg.sender` to 0, and claim rewards
682      * if rewards to claim
683      */
684     function withdrawAll() external;
685 
686     /**
687      * @notice function that allows a user to withdraw its initial deposit
688      * @param amount, amount to withdraw
689      * @dev `block.timestamp` must be higher than `lockupPeriod` (lockupPeriod finished)
690      * @dev `amount` must be higher than `0`
691      * @dev `amount` must be lower or equal to the amount staked
692      * withdraw reset all states variable for the `msg.sender` to 0, and claim rewards
693      * if rewards to claim
694      */
695     function withdraw(uint amount) external;
696 
697     /**
698      * @notice function that returns the amount of total Staked tokens
699      * for a specific user
700      * @param stakeHolder, address of the user to check
701      * @return uint amount of the total deposited Tokens by the caller
702      */
703     function amountStaked(address stakeHolder) external view returns (uint);
704 
705     /**
706      * @notice function that returns the amount of total Staked tokens
707      * on the smart contract
708      * @return uint amount of the total deposited Tokens
709      */
710     function totalDeposited() external view returns (uint);
711 
712     /**
713      * @notice function that returns the amount of pending rewards
714      * that can be claimed by the user
715      * @param stakeHolder, address of the user to be checked
716      * @return uint amount of claimable rewards
717      */
718     function rewardOf(address stakeHolder) external view returns (uint);
719 
720     /**
721      * @notice function that claims pending rewards
722      * @dev transfer the pending rewards to the `msg.sender`
723      */
724     function claimRewards() external;
725 
726     /**
727      * @dev Emitted when `amount` tokens are deposited into
728      * staking platform
729      */
730     event Deposit(address indexed owner, uint amount);
731 
732     /**
733      * @dev Emitted when user withdraw deposited `amount`
734      */
735     event Withdraw(address indexed owner, uint amount);
736 
737     /**
738      * @dev Emitted when `stakeHolder` claim rewards
739      */
740     event Claim(address indexed stakeHolder, uint amount);
741 
742     /**
743      * @dev Emitted when staking has started
744      */
745     event StartStaking(uint startPeriod, uint lockupPeriod, uint endingPeriod);
746 }
747 // File: DummyStaking_rewards.sol
748 
749 
750 pragma solidity =0.8.10;
751 
752 
753 
754 
755 
756 /// @author www.github.com/jscrui
757 /// @title Staking Platform with fixed APY and lockup
758 contract StakingPlatform is IStakingPlatform, Ownable {
759     using SafeERC20 for IERC20;
760 
761     IERC20 public immutable token;
762     IStakingPlatform public immutable oldStaking;
763     bool isStarted;
764 
765     uint private _totalStaked;
766     uint internal _precision = 1E6;
767 
768     mapping(address => bool) alreadyMigrated;
769     mapping(address => uint) claimedRewards;
770 
771     /**
772      * @notice constructor contains all the parameters of the staking platform
773      * @dev all parameters are immutable
774      */
775     constructor(address _token, address _oldStaking) {
776         token = IERC20(_token);
777         oldStaking = IStakingPlatform(_oldStaking);
778     }    
779 
780     function startStaking() external override onlyOwner {
781         isStarted = true;
782     }
783 
784     function totalDeposited() external view returns (uint) {
785         return oldStaking.totalDeposited();
786     }
787 
788     function withdraw(uint amount) public pure {
789         require(1 == 2+amount, "This function is not available in this contract");
790     }
791 
792     function deposit(uint amount) public pure {
793         require(1 == 2+amount, "This function is not available in this contract");
794     }
795 
796     function claimRewards() external {        
797         require(!alreadyMigrated[_msgSender()], "User migrated.");
798 
799         uint _claimedRewards = claimedRewards[_msgSender()]; 
800 
801         uint256 amountRewards = oldStaking.rewardOf(_msgSender());  
802         require(amountRewards > 0, "No rewards to claim."); 
803 
804         claimedRewards[_msgSender()] = amountRewards; 
805 
806         token.safeTransfer(_msgSender(), decimalsFixer(amountRewards-_claimedRewards)); 
807 
808     }    
809     
810     function withdrawAll() external {
811         require(!isStarted, "Migration has not started.");
812         require(!alreadyMigrated[_msgSender()], "User migrated.");
813 
814         uint256 amount = oldStaking.amountStaked(_msgSender());
815         
816         uint256 totalAmount = amount;    
817         require(totalAmount > 0, "Nothing to withdraw");
818 
819         alreadyMigrated[_msgSender()] = true;            
820 
821         token.safeTransfer(_msgSender(), decimalsFixer(totalAmount));
822     }
823 
824     function amountStaked(address stakeHolder) external view returns (uint){
825         return oldStaking.amountStaked(stakeHolder);
826     }
827    
828     function rewardOf(address stakeHolder) external view returns (uint){
829         return oldStaking.rewardOf(stakeHolder);
830     }
831 
832     /** This function will receive a 18 decimals _amount and should return the same number but with 9 decimals */
833     function decimalsFixer(uint256 _amount) internal pure returns (uint){
834         return _amount/1E9;
835     }
836 
837     /** this function is to recover tokens once migration is already completed */    
838     function recoverTokens() external onlyOwner {
839         uint256 amount = token.balanceOf(address(this));
840         token.safeTransfer(_msgSender(), amount);
841     }
842  
843 }