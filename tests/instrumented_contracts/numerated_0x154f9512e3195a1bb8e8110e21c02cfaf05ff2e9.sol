1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         _nonReentrantBefore();
54         _;
55         _nonReentrantAfter();
56     }
57 
58     function _nonReentrantBefore() private {
59         // On the first call to nonReentrant, _status will be _NOT_ENTERED
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         // Any calls to nonReentrant after this point will fail
63         _status = _ENTERED;
64     }
65 
66     function _nonReentrantAfter() private {
67         // By storing the original value once again, a refund is triggered (see
68         // https://eips.ethereum.org/EIPS/eip-2200)
69         _status = _NOT_ENTERED;
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Address.sol
74 
75 
76 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
77 
78 pragma solidity ^0.8.1;
79 
80 /**
81  * @dev Collection of functions related to the address type
82  */
83 library Address {
84     /**
85      * @dev Returns true if `account` is a contract.
86      *
87      * [IMPORTANT]
88      * ====
89      * It is unsafe to assume that an address for which this function returns
90      * false is an externally-owned account (EOA) and not a contract.
91      *
92      * Among others, `isContract` will return false for the following
93      * types of addresses:
94      *
95      *  - an externally-owned account
96      *  - a contract in construction
97      *  - an address where a contract will be created
98      *  - an address where a contract lived, but was destroyed
99      * ====
100      *
101      * [IMPORTANT]
102      * ====
103      * You shouldn't rely on `isContract` to protect against flash loan attacks!
104      *
105      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
106      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
107      * constructor.
108      * ====
109      */
110     function isContract(address account) internal view returns (bool) {
111         // This method relies on extcodesize/address.code.length, which returns 0
112         // for contracts in construction, since the code is only stored at the end
113         // of the constructor execution.
114 
115         return account.code.length > 0;
116     }
117 
118     /**
119      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
120      * `recipient`, forwarding all available gas and reverting on errors.
121      *
122      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
123      * of certain opcodes, possibly making contracts go over the 2300 gas limit
124      * imposed by `transfer`, making them unable to receive funds via
125      * `transfer`. {sendValue} removes this limitation.
126      *
127      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
128      *
129      * IMPORTANT: because control is transferred to `recipient`, care must be
130      * taken to not create reentrancy vulnerabilities. Consider using
131      * {ReentrancyGuard} or the
132      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
133      */
134     function sendValue(address payable recipient, uint256 amount) internal {
135         require(address(this).balance >= amount, "Address: insufficient balance");
136 
137         (bool success, ) = recipient.call{value: amount}("");
138         require(success, "Address: unable to send value, recipient may have reverted");
139     }
140 
141     /**
142      * @dev Performs a Solidity function call using a low level `call`. A
143      * plain `call` is an unsafe replacement for a function call: use this
144      * function instead.
145      *
146      * If `target` reverts with a revert reason, it is bubbled up by this
147      * function (like regular Solidity function calls).
148      *
149      * Returns the raw returned data. To convert to the expected return value,
150      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
151      *
152      * Requirements:
153      *
154      * - `target` must be a contract.
155      * - calling `target` with `data` must not revert.
156      *
157      * _Available since v3.1._
158      */
159     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
160         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
165      * `errorMessage` as a fallback revert reason when `target` reverts.
166      *
167      * _Available since v3.1._
168      */
169     function functionCall(
170         address target,
171         bytes memory data,
172         string memory errorMessage
173     ) internal returns (bytes memory) {
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
188     function functionCallWithValue(
189         address target,
190         bytes memory data,
191         uint256 value
192     ) internal returns (bytes memory) {
193         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
198      * with `errorMessage` as a fallback revert reason when `target` reverts.
199      *
200      * _Available since v3.1._
201      */
202     function functionCallWithValue(
203         address target,
204         bytes memory data,
205         uint256 value,
206         string memory errorMessage
207     ) internal returns (bytes memory) {
208         require(address(this).balance >= value, "Address: insufficient balance for call");
209         (bool success, bytes memory returndata) = target.call{value: value}(data);
210         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
215      * but performing a static call.
216      *
217      * _Available since v3.3._
218      */
219     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
220         return functionStaticCall(target, data, "Address: low-level static call failed");
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(
230         address target,
231         bytes memory data,
232         string memory errorMessage
233     ) internal view returns (bytes memory) {
234         (bool success, bytes memory returndata) = target.staticcall(data);
235         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
240      * but performing a delegate call.
241      *
242      * _Available since v3.4._
243      */
244     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
245         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(
255         address target,
256         bytes memory data,
257         string memory errorMessage
258     ) internal returns (bytes memory) {
259         (bool success, bytes memory returndata) = target.delegatecall(data);
260         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
261     }
262 
263     /**
264      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
265      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
266      *
267      * _Available since v4.8._
268      */
269     function verifyCallResultFromTarget(
270         address target,
271         bool success,
272         bytes memory returndata,
273         string memory errorMessage
274     ) internal view returns (bytes memory) {
275         if (success) {
276             if (returndata.length == 0) {
277                 // only check isContract if the call was successful and the return data is empty
278                 // otherwise we already know that it was a contract
279                 require(isContract(target), "Address: call to non-contract");
280             }
281             return returndata;
282         } else {
283             _revert(returndata, errorMessage);
284         }
285     }
286 
287     /**
288      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
289      * revert reason or using the provided one.
290      *
291      * _Available since v4.3._
292      */
293     function verifyCallResult(
294         bool success,
295         bytes memory returndata,
296         string memory errorMessage
297     ) internal pure returns (bytes memory) {
298         if (success) {
299             return returndata;
300         } else {
301             _revert(returndata, errorMessage);
302         }
303     }
304 
305     function _revert(bytes memory returndata, string memory errorMessage) private pure {
306         // Look for revert reason and bubble it up if present
307         if (returndata.length > 0) {
308             // The easiest way to bubble the revert reason is using memory via assembly
309             /// @solidity memory-safe-assembly
310             assembly {
311                 let returndata_size := mload(returndata)
312                 revert(add(32, returndata), returndata_size)
313             }
314         } else {
315             revert(errorMessage);
316         }
317     }
318 }
319 
320 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
321 
322 
323 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
324 
325 pragma solidity ^0.8.0;
326 
327 /**
328  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
329  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
330  *
331  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
332  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
333  * need to send a transaction, and thus is not required to hold Ether at all.
334  */
335 interface IERC20Permit {
336     /**
337      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
338      * given ``owner``'s signed approval.
339      *
340      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
341      * ordering also apply here.
342      *
343      * Emits an {Approval} event.
344      *
345      * Requirements:
346      *
347      * - `spender` cannot be the zero address.
348      * - `deadline` must be a timestamp in the future.
349      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
350      * over the EIP712-formatted function arguments.
351      * - the signature must use ``owner``'s current nonce (see {nonces}).
352      *
353      * For more information on the signature format, see the
354      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
355      * section].
356      */
357     function permit(
358         address owner,
359         address spender,
360         uint256 value,
361         uint256 deadline,
362         uint8 v,
363         bytes32 r,
364         bytes32 s
365     ) external;
366 
367     /**
368      * @dev Returns the current nonce for `owner`. This value must be
369      * included whenever a signature is generated for {permit}.
370      *
371      * Every successful call to {permit} increases ``owner``'s nonce by one. This
372      * prevents a signature from being used multiple times.
373      */
374     function nonces(address owner) external view returns (uint256);
375 
376     /**
377      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
378      */
379     // solhint-disable-next-line func-name-mixedcase
380     function DOMAIN_SEPARATOR() external view returns (bytes32);
381 }
382 
383 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
384 
385 
386 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
387 
388 pragma solidity ^0.8.0;
389 
390 /**
391  * @dev Interface of the ERC20 standard as defined in the EIP.
392  */
393 interface IERC20 {
394     /**
395      * @dev Emitted when `value` tokens are moved from one account (`from`) to
396      * another (`to`).
397      *
398      * Note that `value` may be zero.
399      */
400     event Transfer(address indexed from, address indexed to, uint256 value);
401 
402     /**
403      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
404      * a call to {approve}. `value` is the new allowance.
405      */
406     event Approval(address indexed owner, address indexed spender, uint256 value);
407 
408     /**
409      * @dev Returns the amount of tokens in existence.
410      */
411     function totalSupply() external view returns (uint256);
412 
413     /**
414      * @dev Returns the amount of tokens owned by `account`.
415      */
416     function balanceOf(address account) external view returns (uint256);
417 
418     /**
419      * @dev Moves `amount` tokens from the caller's account to `to`.
420      *
421      * Returns a boolean value indicating whether the operation succeeded.
422      *
423      * Emits a {Transfer} event.
424      */
425     function transfer(address to, uint256 amount) external returns (bool);
426 
427     /**
428      * @dev Returns the remaining number of tokens that `spender` will be
429      * allowed to spend on behalf of `owner` through {transferFrom}. This is
430      * zero by default.
431      *
432      * This value changes when {approve} or {transferFrom} are called.
433      */
434     function allowance(address owner, address spender) external view returns (uint256);
435 
436     /**
437      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
438      *
439      * Returns a boolean value indicating whether the operation succeeded.
440      *
441      * IMPORTANT: Beware that changing an allowance with this method brings the risk
442      * that someone may use both the old and the new allowance by unfortunate
443      * transaction ordering. One possible solution to mitigate this race
444      * condition is to first reduce the spender's allowance to 0 and set the
445      * desired value afterwards:
446      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
447      *
448      * Emits an {Approval} event.
449      */
450     function approve(address spender, uint256 amount) external returns (bool);
451 
452     /**
453      * @dev Moves `amount` tokens from `from` to `to` using the
454      * allowance mechanism. `amount` is then deducted from the caller's
455      * allowance.
456      *
457      * Returns a boolean value indicating whether the operation succeeded.
458      *
459      * Emits a {Transfer} event.
460      */
461     function transferFrom(
462         address from,
463         address to,
464         uint256 amount
465     ) external returns (bool);
466 }
467 
468 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
469 
470 
471 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
472 
473 pragma solidity ^0.8.0;
474 
475 
476 
477 
478 /**
479  * @title SafeERC20
480  * @dev Wrappers around ERC20 operations that throw on failure (when the token
481  * contract returns false). Tokens that return no value (and instead revert or
482  * throw on failure) are also supported, non-reverting calls are assumed to be
483  * successful.
484  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
485  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
486  */
487 library SafeERC20 {
488     using Address for address;
489 
490     function safeTransfer(
491         IERC20 token,
492         address to,
493         uint256 value
494     ) internal {
495         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
496     }
497 
498     function safeTransferFrom(
499         IERC20 token,
500         address from,
501         address to,
502         uint256 value
503     ) internal {
504         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
505     }
506 
507     /**
508      * @dev Deprecated. This function has issues similar to the ones found in
509      * {IERC20-approve}, and its usage is discouraged.
510      *
511      * Whenever possible, use {safeIncreaseAllowance} and
512      * {safeDecreaseAllowance} instead.
513      */
514     function safeApprove(
515         IERC20 token,
516         address spender,
517         uint256 value
518     ) internal {
519         // safeApprove should only be called when setting an initial allowance,
520         // or when resetting it to zero. To increase and decrease it, use
521         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
522         require(
523             (value == 0) || (token.allowance(address(this), spender) == 0),
524             "SafeERC20: approve from non-zero to non-zero allowance"
525         );
526         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
527     }
528 
529     function safeIncreaseAllowance(
530         IERC20 token,
531         address spender,
532         uint256 value
533     ) internal {
534         uint256 newAllowance = token.allowance(address(this), spender) + value;
535         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
536     }
537 
538     function safeDecreaseAllowance(
539         IERC20 token,
540         address spender,
541         uint256 value
542     ) internal {
543         unchecked {
544             uint256 oldAllowance = token.allowance(address(this), spender);
545             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
546             uint256 newAllowance = oldAllowance - value;
547             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
548         }
549     }
550 
551     function safePermit(
552         IERC20Permit token,
553         address owner,
554         address spender,
555         uint256 value,
556         uint256 deadline,
557         uint8 v,
558         bytes32 r,
559         bytes32 s
560     ) internal {
561         uint256 nonceBefore = token.nonces(owner);
562         token.permit(owner, spender, value, deadline, v, r, s);
563         uint256 nonceAfter = token.nonces(owner);
564         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
565     }
566 
567     /**
568      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
569      * on the return value: the return value is optional (but if data is returned, it must not be false).
570      * @param token The token targeted by the call.
571      * @param data The call data (encoded using abi.encode or one of its variants).
572      */
573     function _callOptionalReturn(IERC20 token, bytes memory data) private {
574         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
575         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
576         // the target address contains contract code and also asserts for success in the low-level call.
577 
578         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
579         if (returndata.length > 0) {
580             // Return data is optional
581             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
582         }
583     }
584 }
585 
586 // File: @openzeppelin/contracts/utils/Context.sol
587 
588 
589 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 /**
594  * @dev Provides information about the current execution context, including the
595  * sender of the transaction and its data. While these are generally available
596  * via msg.sender and msg.data, they should not be accessed in such a direct
597  * manner, since when dealing with meta-transactions the account sending and
598  * paying for execution may not be the actual sender (as far as an application
599  * is concerned).
600  *
601  * This contract is only required for intermediate, library-like contracts.
602  */
603 abstract contract Context {
604     function _msgSender() internal view virtual returns (address) {
605         return msg.sender;
606     }
607 
608     function _msgData() internal view virtual returns (bytes calldata) {
609         return msg.data;
610     }
611 }
612 
613 // File: @openzeppelin/contracts/access/Ownable.sol
614 
615 
616 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
617 
618 pragma solidity ^0.8.0;
619 
620 
621 /**
622  * @dev Contract module which provides a basic access control mechanism, where
623  * there is an account (an owner) that can be granted exclusive access to
624  * specific functions.
625  *
626  * By default, the owner account will be the one that deploys the contract. This
627  * can later be changed with {transferOwnership}.
628  *
629  * This module is used through inheritance. It will make available the modifier
630  * `onlyOwner`, which can be applied to your functions to restrict their use to
631  * the owner.
632  */
633 abstract contract Ownable is Context {
634     address private _owner;
635 
636     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
637 
638     /**
639      * @dev Initializes the contract setting the deployer as the initial owner.
640      */
641     constructor() {
642         _transferOwnership(_msgSender());
643     }
644 
645     /**
646      * @dev Throws if called by any account other than the owner.
647      */
648     modifier onlyOwner() {
649         _checkOwner();
650         _;
651     }
652 
653     /**
654      * @dev Returns the address of the current owner.
655      */
656     function owner() public view virtual returns (address) {
657         return _owner;
658     }
659 
660     /**
661      * @dev Throws if the sender is not the owner.
662      */
663     function _checkOwner() internal view virtual {
664         require(owner() == _msgSender(), "Ownable: caller is not the owner");
665     }
666 
667     /**
668      * @dev Leaves the contract without owner. It will not be possible to call
669      * `onlyOwner` functions anymore. Can only be called by the current owner.
670      *
671      * NOTE: Renouncing ownership will leave the contract without an owner,
672      * thereby removing any functionality that is only available to the owner.
673      */
674     function renounceOwnership() public virtual onlyOwner {
675         _transferOwnership(address(0));
676     }
677 
678     /**
679      * @dev Transfers ownership of the contract to a new account (`newOwner`).
680      * Can only be called by the current owner.
681      */
682     function transferOwnership(address newOwner) public virtual onlyOwner {
683         require(newOwner != address(0), "Ownable: new owner is the zero address");
684         _transferOwnership(newOwner);
685     }
686 
687     /**
688      * @dev Transfers ownership of the contract to a new account (`newOwner`).
689      * Internal function without access restriction.
690      */
691     function _transferOwnership(address newOwner) internal virtual {
692         address oldOwner = _owner;
693         _owner = newOwner;
694         emit OwnershipTransferred(oldOwner, newOwner);
695     }
696 }
697 
698 // File: contracts/STAKING/IStaking.sol
699 
700 
701 pragma solidity =0.8.10;
702 
703 /// @author RetreebInc
704 /// @title Interface Staking Platform with fixed APY and lockup
705 interface IStaking {
706     /**
707      * @notice function that start the staking
708      * @dev set `startPeriod` to the current current `block.timestamp`
709      * set `lockupPeriod` which is `block.timestamp` + `lockupDuration`
710      * and `endPeriod` which is `startPeriod` + `stakingDuration`
711      */
712     function startStaking() external;
713 
714     /**
715      * @notice function that allows a user to deposit tokens
716      * @dev user must first approve the amount to deposit before calling this function,
717      * cannot exceed the `maxAmountStaked`
718      * @param amount, the amount to be deposited
719      * @dev `endPeriod` to equal 0 (Staking didn't started yet),
720      * or `endPeriod` more than current `block.timestamp` (staking not finished yet)
721      * @dev `totalStaked + amount` must be less than `stakingMax`
722      * @dev that the amount deposited should greater than 0
723      */
724     function deposit(uint amount) external;
725 
726     /**
727      * @notice function that allows a user to withdraw its initial deposit
728      * @dev must be called only when `block.timestamp` >= `endPeriod`
729      * @dev `block.timestamp` higher than `lockupPeriod` (lockupPeriod finished)
730      * withdraw reset all states variable for the `msg.sender` to 0, and claim rewards
731      * if rewards to claim
732      */
733     function withdrawAll() external;
734 
735     /**
736      * @notice function that allows a user to withdraw its initial deposit
737      * @param amount, amount to withdraw
738      * @dev `block.timestamp` must be higher than `lockupPeriod` (lockupPeriod finished)
739      * @dev `amount` must be higher than `0`
740      * @dev `amount` must be lower or equal to the amount staked
741      * withdraw reset all states variable for the `msg.sender` to 0, and claim rewards
742      * if rewards to claim
743      */
744     function withdraw(uint amount) external;
745 
746     /**
747      * @notice function that returns the amount of total Staked tokens
748      * for a specific user
749      * @param stakeHolder, address of the user to check
750      * @return uint amount of the total deposited Tokens by the caller
751      */
752     function amountStaked(address stakeHolder) external view returns (uint);
753 
754     /**
755      * @notice function that returns the amount of total Staked tokens
756      * on the smart contract
757      * @return uint amount of the total deposited Tokens
758      */
759     function totalDeposited() external view returns (uint);
760 
761     /**
762      * @notice function that returns the amount of pending rewards
763      * that can be claimed by the user
764      * @param stakeHolder, address of the user to be checked
765      * @return uint amount of claimable rewards
766      */
767     function rewardOf(address stakeHolder) external view returns (uint);
768 
769     /**
770      * @notice function that claims pending rewards
771      * @dev transfer the pending rewards to the `msg.sender`
772      */
773     function claimRewards() external;
774 
775     /**
776      * @dev Emitted when `amount` tokens are deposited into
777      * staking platform
778      */
779     event Deposit(address indexed owner, uint amount);
780 
781     /**
782      * @dev Emitted when user withdraw deposited `amount`
783      */
784     event Withdraw(address indexed owner, uint amount);
785 
786     /**
787      * @dev Emitted when `stakeHolder` claim rewards
788      */
789     event Claim(address indexed stakeHolder, uint amount);
790 
791     /**
792      * @dev Emitted when staking has started
793      */
794     event StartStaking(uint startPeriod, uint lockupPeriod, uint endingPeriod);
795 }
796 // File: contracts/STAKING/Staking.sol
797 
798 
799 pragma solidity =0.8.10;
800 
801 
802 
803 
804 
805 
806 /// @title Staking Platform with fixed APY and lockup
807 contract Staking is IStaking, Ownable, ReentrancyGuard {
808     using SafeERC20 for IERC20;
809 
810     IERC20 public immutable token;
811 
812     uint8 public immutable fixedAPY;
813 
814     uint public immutable stakingDuration;
815     uint public immutable lockupDuration;
816     uint public immutable stakingMax;
817 
818     uint public startPeriod;
819     uint public lockupPeriod;
820     uint public endPeriod;
821 
822     uint private _totalStaked;
823     uint internal _precision = 1E6;
824 
825     mapping(address => uint) public staked;
826     mapping(address => uint) private _rewardsToClaim;
827     mapping(address => uint) private _userStartTime;
828 
829     /**
830      * @notice constructor contains all the parameters of the staking platform
831      * @dev all parameters are immutable
832      */
833     constructor(
834         address _token,
835         uint8 _fixedAPY,
836         uint _durationInDays,
837         uint _lockDurationInDays,
838         uint _maxAmountStaked
839     ) {
840         stakingDuration = _durationInDays * 1 days;
841         lockupDuration = _lockDurationInDays * 1 days;
842         token = IERC20(_token);
843         fixedAPY = _fixedAPY;
844         stakingMax = _maxAmountStaked;
845     }
846 
847     /**
848      * @notice function that start the staking
849      * @dev set `startPeriod` to the current current `block.timestamp`
850      * set `lockupPeriod` which is `block.timestamp` + `lockupDuration`
851      * and `endPeriod` which is `startPeriod` + `stakingDuration`
852      */
853     function startStaking() external override onlyOwner {
854         require(startPeriod == 0, "Staking has already started");
855         startPeriod = block.timestamp;
856         lockupPeriod = block.timestamp + lockupDuration;
857         endPeriod = block.timestamp + stakingDuration;
858         emit StartStaking(startPeriod, lockupDuration, endPeriod);
859     }
860 
861     /**
862      * @notice function that allows a user to deposit tokens
863      * @dev user must first approve the amount to deposit before calling this function,
864      * cannot exceed the `maxAmountStaked`
865      * @param amount, the amount to be deposited
866      * @dev `endPeriod` to equal 0 (Staking didn't started yet),
867      * or `endPeriod` more than current `block.timestamp` (staking not finished yet)
868      * @dev `totalStaked + amount` must be less than `stakingMax`
869      * @dev that the amount deposited should greater than 0
870      */
871     function deposit(uint amount) external override {
872         require(
873             endPeriod == 0 || endPeriod > block.timestamp,
874             "Staking period ended"
875         );
876         require(
877             _totalStaked + amount <= stakingMax,
878             "Amount staked exceeds MaxStake"
879         );
880         require(amount > 0, "Amount must be greater than 0");
881 
882         if (_userStartTime[_msgSender()] == 0) {
883             _userStartTime[_msgSender()] = block.timestamp;
884         }
885 
886         _updateRewards();
887 
888         staked[_msgSender()] += amount;
889         _totalStaked += amount;
890         token.safeTransferFrom(_msgSender(), address(this), amount);
891         emit Deposit(_msgSender(), amount);
892     }
893 
894     /**
895      * @notice function that allows a user to withdraw its initial deposit
896      * @param amount, amount to withdraw
897      * @dev `amount` must be higher than `0`
898      * @dev `amount` must be lower or equal to the amount staked
899      * withdraw reset all states variable for the `msg.sender` to 0, and claim rewards
900      * if rewards to claim
901      */
902     function withdraw(uint amount) external nonReentrant override {
903 
904         require(amount > 0, "Amount must be greater than 0");
905         require(
906             amount <= staked[_msgSender()],
907             "Amount higher than stakedAmount"
908         );
909 
910         _updateRewards();
911         if (_rewardsToClaim[_msgSender()] > 0) {
912             _claimRewards();
913         }
914         _totalStaked -= amount;
915         staked[_msgSender()] -= amount;
916         token.safeTransfer(_msgSender(), amount);
917 
918         emit Withdraw(_msgSender(), amount);
919     }
920 
921     /**
922      * @notice function that allows a user to withdraw its initial deposit
923      * @dev `block.timestamp` higher than `lockupPeriod` (lockupPeriod finished)
924      * withdraw reset all states variable for the `msg.sender` to 0, and claim rewards
925      * if rewards to claim
926      */
927     function withdrawAll() external nonReentrant override {
928 
929         _updateRewards();
930         if (_rewardsToClaim[_msgSender()] > 0) {
931             _claimRewards();
932         }
933 
934         _userStartTime[_msgSender()] = 0;
935         _totalStaked -= staked[_msgSender()];
936         uint stakedBalance = staked[_msgSender()];
937         staked[_msgSender()] = 0;
938         token.safeTransfer(_msgSender(), stakedBalance);
939 
940         emit Withdraw(_msgSender(), stakedBalance);
941     }
942 
943     /**
944      * @notice claim all remaining balance on the contract
945      * Residual balance is all the remaining tokens that have not been distributed
946      * (e.g, in case the number of stakeholders is not sufficient)
947      * Cannot claim initial stakeholders deposit
948      */
949     function withdrawResidualBalance() external onlyOwner {
950 
951         uint balance = token.balanceOf(address(this));
952         uint residualBalance = balance - (_totalStaked);
953         require(residualBalance > 0, "No residual Balance to withdraw");
954         token.safeTransfer(owner(), residualBalance);
955     }
956 
957     /**
958      * @notice function that returns the amount of total Staked tokens
959      * for a specific user
960      * @param stakeHolder, address of the user to check
961      * @return uint amount of the total deposited Tokens by the caller
962      */
963     function amountStaked(address stakeHolder)
964         external
965         view
966         override
967         returns (uint)
968     {
969         return staked[stakeHolder];
970     }
971 
972     /**
973      * @notice function that returns the amount of total Staked tokens
974      * on the smart contract
975      * @return uint amount of the total deposited Tokens
976      */
977     function totalDeposited() external view override returns (uint) {
978         return _totalStaked;
979     }
980 
981     /**
982      * @notice function that returns the amount of pending rewards
983      * that can be claimed by the user
984      * @param stakeHolder, address of the user to be checked
985      * @return uint amount of claimable rewards
986      */
987     function rewardOf(address stakeHolder)
988         external
989         view
990         override
991         returns (uint)
992     {
993         return _calculateRewards(stakeHolder);
994     }
995 
996     /**
997      * @notice function that claims pending rewards
998      * @dev transfer the pending rewards to the `msg.sender`
999      */
1000     function claimRewards() external override {
1001         _claimRewards();
1002     }
1003 
1004     /**
1005      * @notice calculate rewards based on the `fixedAPY`, `_percentageTimeRemaining()`
1006      * @dev the higher is the precision and the more the time remaining will be precise
1007      * @param stakeHolder, address of the user to be checked
1008      * @return uint amount of claimable tokens of the specified address
1009      */
1010     function _calculateRewards(address stakeHolder)
1011         internal
1012         view
1013         returns (uint)
1014     {
1015         if (startPeriod == 0 || staked[stakeHolder] == 0) {
1016             return 0;
1017         }
1018 
1019         return
1020             (((staked[stakeHolder] * fixedAPY) *
1021                 _percentageTimeRemaining(stakeHolder)) / (_precision * 100)) +
1022             _rewardsToClaim[stakeHolder];
1023     }
1024 
1025     /**
1026      * @notice function that returns the remaining time in seconds of the staking period
1027      * @dev the higher is the precision and the more the time remaining will be precise
1028      * @param stakeHolder, address of the user to be checked
1029      * @return uint percentage of time remaining * precision
1030      */
1031     function _percentageTimeRemaining(address stakeHolder)
1032         internal
1033         view
1034         returns (uint)
1035     {
1036         bool early = startPeriod > _userStartTime[stakeHolder];
1037         uint startTime;
1038         if (endPeriod > block.timestamp) {
1039             startTime = early ? startPeriod : _userStartTime[stakeHolder];
1040             uint timeRemaining = stakingDuration -
1041                 (block.timestamp - startTime);
1042             return
1043                 (_precision * (stakingDuration - timeRemaining)) /
1044                 stakingDuration;
1045         }
1046         startTime = early
1047             ? 0
1048             : stakingDuration - (endPeriod - _userStartTime[stakeHolder]);
1049         return (_precision * (stakingDuration - startTime)) / stakingDuration;
1050     }
1051 
1052     /**
1053      * @notice internal function that claims pending rewards
1054      * @dev transfer the pending rewards to the user address
1055      */
1056     function _claimRewards() private {
1057         _updateRewards();
1058 
1059         uint rewardsToClaim = _rewardsToClaim[_msgSender()];
1060         require(rewardsToClaim > 0, "Nothing to claim");
1061 
1062         _rewardsToClaim[_msgSender()] = 0;
1063         token.safeTransfer(_msgSender(), rewardsToClaim);
1064         emit Claim(_msgSender(), rewardsToClaim);
1065     }
1066 
1067     /**
1068      * @notice function that update pending rewards
1069      * and shift them to rewardsToClaim
1070      * @dev update rewards claimable
1071      * and check the time spent since deposit for the `msg.sender`
1072      */
1073     function _updateRewards() private {
1074         _rewardsToClaim[_msgSender()] = _calculateRewards(_msgSender());
1075         _userStartTime[_msgSender()] = (block.timestamp >= endPeriod)
1076             ? endPeriod
1077             : block.timestamp;
1078     }
1079 }