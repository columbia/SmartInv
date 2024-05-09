1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         _nonReentrantBefore();
55         _;
56         _nonReentrantAfter();
57     }
58 
59     function _nonReentrantBefore() private {
60         // On the first call to nonReentrant, _status will be _NOT_ENTERED
61         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
62 
63         // Any calls to nonReentrant after this point will fail
64         _status = _ENTERED;
65     }
66 
67     function _nonReentrantAfter() private {
68         // By storing the original value once again, a refund is triggered (see
69         // https://eips.ethereum.org/EIPS/eip-2200)
70         _status = _NOT_ENTERED;
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Address.sol
75 
76 
77 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
78 
79 pragma solidity ^0.8.1;
80 
81 /**
82  * @dev Collection of functions related to the address type
83  */
84 library Address {
85     /**
86      * @dev Returns true if `account` is a contract.
87      *
88      * [IMPORTANT]
89      * ====
90      * It is unsafe to assume that an address for which this function returns
91      * false is an externally-owned account (EOA) and not a contract.
92      *
93      * Among others, `isContract` will return false for the following
94      * types of addresses:
95      *
96      *  - an externally-owned account
97      *  - a contract in construction
98      *  - an address where a contract will be created
99      *  - an address where a contract lived, but was destroyed
100      * ====
101      *
102      * [IMPORTANT]
103      * ====
104      * You shouldn't rely on `isContract` to protect against flash loan attacks!
105      *
106      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
107      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
108      * constructor.
109      * ====
110      */
111     function isContract(address account) internal view returns (bool) {
112         // This method relies on extcodesize/address.code.length, which returns 0
113         // for contracts in construction, since the code is only stored at the end
114         // of the constructor execution.
115 
116         return account.code.length > 0;
117     }
118 
119     /**
120      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
121      * `recipient`, forwarding all available gas and reverting on errors.
122      *
123      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
124      * of certain opcodes, possibly making contracts go over the 2300 gas limit
125      * imposed by `transfer`, making them unable to receive funds via
126      * `transfer`. {sendValue} removes this limitation.
127      *
128      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
129      *
130      * IMPORTANT: because control is transferred to `recipient`, care must be
131      * taken to not create reentrancy vulnerabilities. Consider using
132      * {ReentrancyGuard} or the
133      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
134      */
135     function sendValue(address payable recipient, uint256 amount) internal {
136         require(address(this).balance >= amount, "Address: insufficient balance");
137 
138         (bool success, ) = recipient.call{value: amount}("");
139         require(success, "Address: unable to send value, recipient may have reverted");
140     }
141 
142     /**
143      * @dev Performs a Solidity function call using a low level `call`. A
144      * plain `call` is an unsafe replacement for a function call: use this
145      * function instead.
146      *
147      * If `target` reverts with a revert reason, it is bubbled up by this
148      * function (like regular Solidity function calls).
149      *
150      * Returns the raw returned data. To convert to the expected return value,
151      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
152      *
153      * Requirements:
154      *
155      * - `target` must be a contract.
156      * - calling `target` with `data` must not revert.
157      *
158      * _Available since v3.1._
159      */
160     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
161         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
166      * `errorMessage` as a fallback revert reason when `target` reverts.
167      *
168      * _Available since v3.1._
169      */
170     function functionCall(
171         address target,
172         bytes memory data,
173         string memory errorMessage
174     ) internal returns (bytes memory) {
175         return functionCallWithValue(target, data, 0, errorMessage);
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
180      * but also transferring `value` wei to `target`.
181      *
182      * Requirements:
183      *
184      * - the calling contract must have an ETH balance of at least `value`.
185      * - the called Solidity function must be `payable`.
186      *
187      * _Available since v3.1._
188      */
189     function functionCallWithValue(
190         address target,
191         bytes memory data,
192         uint256 value
193     ) internal returns (bytes memory) {
194         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
199      * with `errorMessage` as a fallback revert reason when `target` reverts.
200      *
201      * _Available since v3.1._
202      */
203     function functionCallWithValue(
204         address target,
205         bytes memory data,
206         uint256 value,
207         string memory errorMessage
208     ) internal returns (bytes memory) {
209         require(address(this).balance >= value, "Address: insufficient balance for call");
210         (bool success, bytes memory returndata) = target.call{value: value}(data);
211         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
216      * but performing a static call.
217      *
218      * _Available since v3.3._
219      */
220     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
221         return functionStaticCall(target, data, "Address: low-level static call failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
226      * but performing a static call.
227      *
228      * _Available since v3.3._
229      */
230     function functionStaticCall(
231         address target,
232         bytes memory data,
233         string memory errorMessage
234     ) internal view returns (bytes memory) {
235         (bool success, bytes memory returndata) = target.staticcall(data);
236         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
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
260         (bool success, bytes memory returndata) = target.delegatecall(data);
261         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
262     }
263 
264     /**
265      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
266      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
267      *
268      * _Available since v4.8._
269      */
270     function verifyCallResultFromTarget(
271         address target,
272         bool success,
273         bytes memory returndata,
274         string memory errorMessage
275     ) internal view returns (bytes memory) {
276         if (success) {
277             if (returndata.length == 0) {
278                 // only check isContract if the call was successful and the return data is empty
279                 // otherwise we already know that it was a contract
280                 require(isContract(target), "Address: call to non-contract");
281             }
282             return returndata;
283         } else {
284             _revert(returndata, errorMessage);
285         }
286     }
287 
288     /**
289      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
290      * revert reason or using the provided one.
291      *
292      * _Available since v4.3._
293      */
294     function verifyCallResult(
295         bool success,
296         bytes memory returndata,
297         string memory errorMessage
298     ) internal pure returns (bytes memory) {
299         if (success) {
300             return returndata;
301         } else {
302             _revert(returndata, errorMessage);
303         }
304     }
305 
306     function _revert(bytes memory returndata, string memory errorMessage) private pure {
307         // Look for revert reason and bubble it up if present
308         if (returndata.length > 0) {
309             // The easiest way to bubble the revert reason is using memory via assembly
310             /// @solidity memory-safe-assembly
311             assembly {
312                 let returndata_size := mload(returndata)
313                 revert(add(32, returndata), returndata_size)
314             }
315         } else {
316             revert(errorMessage);
317         }
318     }
319 }
320 
321 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
322 
323 
324 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
325 
326 pragma solidity ^0.8.0;
327 
328 /**
329  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
330  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
331  *
332  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
333  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
334  * need to send a transaction, and thus is not required to hold Ether at all.
335  */
336 interface IERC20Permit {
337     /**
338      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
339      * given ``owner``'s signed approval.
340      *
341      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
342      * ordering also apply here.
343      *
344      * Emits an {Approval} event.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      * - `deadline` must be a timestamp in the future.
350      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
351      * over the EIP712-formatted function arguments.
352      * - the signature must use ``owner``'s current nonce (see {nonces}).
353      *
354      * For more information on the signature format, see the
355      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
356      * section].
357      */
358     function permit(
359         address owner,
360         address spender,
361         uint256 value,
362         uint256 deadline,
363         uint8 v,
364         bytes32 r,
365         bytes32 s
366     ) external;
367 
368     /**
369      * @dev Returns the current nonce for `owner`. This value must be
370      * included whenever a signature is generated for {permit}.
371      *
372      * Every successful call to {permit} increases ``owner``'s nonce by one. This
373      * prevents a signature from being used multiple times.
374      */
375     function nonces(address owner) external view returns (uint256);
376 
377     /**
378      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
379      */
380     // solhint-disable-next-line func-name-mixedcase
381     function DOMAIN_SEPARATOR() external view returns (bytes32);
382 }
383 
384 // File: @openzeppelin/contracts/utils/Context.sol
385 
386 
387 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
388 
389 pragma solidity ^0.8.0;
390 
391 /**
392  * @dev Provides information about the current execution context, including the
393  * sender of the transaction and its data. While these are generally available
394  * via msg.sender and msg.data, they should not be accessed in such a direct
395  * manner, since when dealing with meta-transactions the account sending and
396  * paying for execution may not be the actual sender (as far as an application
397  * is concerned).
398  *
399  * This contract is only required for intermediate, library-like contracts.
400  */
401 abstract contract Context {
402     function _msgSender() internal view virtual returns (address) {
403         return msg.sender;
404     }
405 
406     function _msgData() internal view virtual returns (bytes calldata) {
407         return msg.data;
408     }
409 }
410 
411 // File: @openzeppelin/contracts/access/Ownable.sol
412 
413 
414 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
415 
416 pragma solidity ^0.8.0;
417 
418 
419 /**
420  * @dev Contract module which provides a basic access control mechanism, where
421  * there is an account (an owner) that can be granted exclusive access to
422  * specific functions.
423  *
424  * By default, the owner account will be the one that deploys the contract. This
425  * can later be changed with {transferOwnership}.
426  *
427  * This module is used through inheritance. It will make available the modifier
428  * `onlyOwner`, which can be applied to your functions to restrict their use to
429  * the owner.
430  */
431 abstract contract Ownable is Context {
432     address private _owner;
433 
434     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
435 
436     /**
437      * @dev Initializes the contract setting the deployer as the initial owner.
438      */
439     constructor() {
440         _transferOwnership(_msgSender());
441     }
442 
443     /**
444      * @dev Throws if called by any account other than the owner.
445      */
446     modifier onlyOwner() {
447         _checkOwner();
448         _;
449     }
450 
451     /**
452      * @dev Returns the address of the current owner.
453      */
454     function owner() public view virtual returns (address) {
455         return _owner;
456     }
457 
458     /**
459      * @dev Throws if the sender is not the owner.
460      */
461     function _checkOwner() internal view virtual {
462         require(owner() == _msgSender(), "Ownable: caller is not the owner");
463     }
464 
465     /**
466      * @dev Leaves the contract without owner. It will not be possible to call
467      * `onlyOwner` functions anymore. Can only be called by the current owner.
468      *
469      * NOTE: Renouncing ownership will leave the contract without an owner,
470      * thereby removing any functionality that is only available to the owner.
471      */
472     function renounceOwnership() public virtual onlyOwner {
473         _transferOwnership(address(0));
474     }
475 
476     /**
477      * @dev Transfers ownership of the contract to a new account (`newOwner`).
478      * Can only be called by the current owner.
479      */
480     function transferOwnership(address newOwner) public virtual onlyOwner {
481         require(newOwner != address(0), "Ownable: new owner is the zero address");
482         _transferOwnership(newOwner);
483     }
484 
485     /**
486      * @dev Transfers ownership of the contract to a new account (`newOwner`).
487      * Internal function without access restriction.
488      */
489     function _transferOwnership(address newOwner) internal virtual {
490         address oldOwner = _owner;
491         _owner = newOwner;
492         emit OwnershipTransferred(oldOwner, newOwner);
493     }
494 }
495 
496 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
497 
498 
499 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
500 
501 pragma solidity ^0.8.0;
502 
503 /**
504  * @dev Interface of the ERC20 standard as defined in the EIP.
505  */
506 interface IERC20 {
507     /**
508      * @dev Emitted when `value` tokens are moved from one account (`from`) to
509      * another (`to`).
510      *
511      * Note that `value` may be zero.
512      */
513     event Transfer(address indexed from, address indexed to, uint256 value);
514 
515     /**
516      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
517      * a call to {approve}. `value` is the new allowance.
518      */
519     event Approval(address indexed owner, address indexed spender, uint256 value);
520 
521     /**
522      * @dev Returns the amount of tokens in existence.
523      */
524     function totalSupply() external view returns (uint256);
525 
526     /**
527      * @dev Returns the amount of tokens owned by `account`.
528      */
529     function balanceOf(address account) external view returns (uint256);
530 
531     /**
532      * @dev Moves `amount` tokens from the caller's account to `to`.
533      *
534      * Returns a boolean value indicating whether the operation succeeded.
535      *
536      * Emits a {Transfer} event.
537      */
538     function transfer(address to, uint256 amount) external returns (bool);
539 
540     /**
541      * @dev Returns the remaining number of tokens that `spender` will be
542      * allowed to spend on behalf of `owner` through {transferFrom}. This is
543      * zero by default.
544      *
545      * This value changes when {approve} or {transferFrom} are called.
546      */
547     function allowance(address owner, address spender) external view returns (uint256);
548 
549     /**
550      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
551      *
552      * Returns a boolean value indicating whether the operation succeeded.
553      *
554      * IMPORTANT: Beware that changing an allowance with this method brings the risk
555      * that someone may use both the old and the new allowance by unfortunate
556      * transaction ordering. One possible solution to mitigate this race
557      * condition is to first reduce the spender's allowance to 0 and set the
558      * desired value afterwards:
559      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
560      *
561      * Emits an {Approval} event.
562      */
563     function approve(address spender, uint256 amount) external returns (bool);
564 
565     /**
566      * @dev Moves `amount` tokens from `from` to `to` using the
567      * allowance mechanism. `amount` is then deducted from the caller's
568      * allowance.
569      *
570      * Returns a boolean value indicating whether the operation succeeded.
571      *
572      * Emits a {Transfer} event.
573      */
574     function transferFrom(
575         address from,
576         address to,
577         uint256 amount
578     ) external returns (bool);
579 }
580 
581 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
582 
583 
584 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 
589 
590 
591 /**
592  * @title SafeERC20
593  * @dev Wrappers around ERC20 operations that throw on failure (when the token
594  * contract returns false). Tokens that return no value (and instead revert or
595  * throw on failure) are also supported, non-reverting calls are assumed to be
596  * successful.
597  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
598  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
599  */
600 library SafeERC20 {
601     using Address for address;
602 
603     function safeTransfer(
604         IERC20 token,
605         address to,
606         uint256 value
607     ) internal {
608         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
609     }
610 
611     function safeTransferFrom(
612         IERC20 token,
613         address from,
614         address to,
615         uint256 value
616     ) internal {
617         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
618     }
619 
620     /**
621      * @dev Deprecated. This function has issues similar to the ones found in
622      * {IERC20-approve}, and its usage is discouraged.
623      *
624      * Whenever possible, use {safeIncreaseAllowance} and
625      * {safeDecreaseAllowance} instead.
626      */
627     function safeApprove(
628         IERC20 token,
629         address spender,
630         uint256 value
631     ) internal {
632         // safeApprove should only be called when setting an initial allowance,
633         // or when resetting it to zero. To increase and decrease it, use
634         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
635         require(
636             (value == 0) || (token.allowance(address(this), spender) == 0),
637             "SafeERC20: approve from non-zero to non-zero allowance"
638         );
639         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
640     }
641 
642     function safeIncreaseAllowance(
643         IERC20 token,
644         address spender,
645         uint256 value
646     ) internal {
647         uint256 newAllowance = token.allowance(address(this), spender) + value;
648         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
649     }
650 
651     function safeDecreaseAllowance(
652         IERC20 token,
653         address spender,
654         uint256 value
655     ) internal {
656         unchecked {
657             uint256 oldAllowance = token.allowance(address(this), spender);
658             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
659             uint256 newAllowance = oldAllowance - value;
660             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
661         }
662     }
663 
664     function safePermit(
665         IERC20Permit token,
666         address owner,
667         address spender,
668         uint256 value,
669         uint256 deadline,
670         uint8 v,
671         bytes32 r,
672         bytes32 s
673     ) internal {
674         uint256 nonceBefore = token.nonces(owner);
675         token.permit(owner, spender, value, deadline, v, r, s);
676         uint256 nonceAfter = token.nonces(owner);
677         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
678     }
679 
680     /**
681      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
682      * on the return value: the return value is optional (but if data is returned, it must not be false).
683      * @param token The token targeted by the call.
684      * @param data The call data (encoded using abi.encode or one of its variants).
685      */
686     function _callOptionalReturn(IERC20 token, bytes memory data) private {
687         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
688         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
689         // the target address contains contract code and also asserts for success in the low-level call.
690 
691         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
692         if (returndata.length > 0) {
693             // Return data is optional
694             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
695         }
696     }
697 }
698 
699 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
700 
701 
702 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 
707 /**
708  * @dev Interface for the optional metadata functions from the ERC20 standard.
709  *
710  * _Available since v4.1._
711  */
712 interface IERC20Metadata is IERC20 {
713     /**
714      * @dev Returns the name of the token.
715      */
716     function name() external view returns (string memory);
717 
718     /**
719      * @dev Returns the symbol of the token.
720      */
721     function symbol() external view returns (string memory);
722 
723     /**
724      * @dev Returns the decimals places of the token.
725      */
726     function decimals() external view returns (uint8);
727 }
728 
729 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
730 
731 
732 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
733 
734 pragma solidity ^0.8.0;
735 
736 
737 
738 
739 /**
740  * @dev Implementation of the {IERC20} interface.
741  *
742  * This implementation is agnostic to the way tokens are created. This means
743  * that a supply mechanism has to be added in a derived contract using {_mint}.
744  * For a generic mechanism see {ERC20PresetMinterPauser}.
745  *
746  * TIP: For a detailed writeup see our guide
747  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
748  * to implement supply mechanisms].
749  *
750  * We have followed general OpenZeppelin Contracts guidelines: functions revert
751  * instead returning `false` on failure. This behavior is nonetheless
752  * conventional and does not conflict with the expectations of ERC20
753  * applications.
754  *
755  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
756  * This allows applications to reconstruct the allowance for all accounts just
757  * by listening to said events. Other implementations of the EIP may not emit
758  * these events, as it isn't required by the specification.
759  *
760  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
761  * functions have been added to mitigate the well-known issues around setting
762  * allowances. See {IERC20-approve}.
763  */
764 contract ERC20 is Context, IERC20, IERC20Metadata {
765     mapping(address => uint256) private _balances;
766 
767     mapping(address => mapping(address => uint256)) private _allowances;
768 
769     uint256 private _totalSupply;
770 
771     string private _name;
772     string private _symbol;
773 
774     /**
775      * @dev Sets the values for {name} and {symbol}.
776      *
777      * The default value of {decimals} is 18. To select a different value for
778      * {decimals} you should overload it.
779      *
780      * All two of these values are immutable: they can only be set once during
781      * construction.
782      */
783     constructor(string memory name_, string memory symbol_) {
784         _name = name_;
785         _symbol = symbol_;
786     }
787 
788     /**
789      * @dev Returns the name of the token.
790      */
791     function name() public view virtual override returns (string memory) {
792         return _name;
793     }
794 
795     /**
796      * @dev Returns the symbol of the token, usually a shorter version of the
797      * name.
798      */
799     function symbol() public view virtual override returns (string memory) {
800         return _symbol;
801     }
802 
803     /**
804      * @dev Returns the number of decimals used to get its user representation.
805      * For example, if `decimals` equals `2`, a balance of `505` tokens should
806      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
807      *
808      * Tokens usually opt for a value of 18, imitating the relationship between
809      * Ether and Wei. This is the value {ERC20} uses, unless this function is
810      * overridden;
811      *
812      * NOTE: This information is only used for _display_ purposes: it in
813      * no way affects any of the arithmetic of the contract, including
814      * {IERC20-balanceOf} and {IERC20-transfer}.
815      */
816     function decimals() public view virtual override returns (uint8) {
817         return 18;
818     }
819 
820     /**
821      * @dev See {IERC20-totalSupply}.
822      */
823     function totalSupply() public view virtual override returns (uint256) {
824         return _totalSupply;
825     }
826 
827     /**
828      * @dev See {IERC20-balanceOf}.
829      */
830     function balanceOf(address account) public view virtual override returns (uint256) {
831         return _balances[account];
832     }
833 
834     /**
835      * @dev See {IERC20-transfer}.
836      *
837      * Requirements:
838      *
839      * - `to` cannot be the zero address.
840      * - the caller must have a balance of at least `amount`.
841      */
842     function transfer(address to, uint256 amount) public virtual override returns (bool) {
843         address owner = _msgSender();
844         _transfer(owner, to, amount);
845         return true;
846     }
847 
848     /**
849      * @dev See {IERC20-allowance}.
850      */
851     function allowance(address owner, address spender) public view virtual override returns (uint256) {
852         return _allowances[owner][spender];
853     }
854 
855     /**
856      * @dev See {IERC20-approve}.
857      *
858      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
859      * `transferFrom`. This is semantically equivalent to an infinite approval.
860      *
861      * Requirements:
862      *
863      * - `spender` cannot be the zero address.
864      */
865     function approve(address spender, uint256 amount) public virtual override returns (bool) {
866         address owner = _msgSender();
867         _approve(owner, spender, amount);
868         return true;
869     }
870 
871     /**
872      * @dev See {IERC20-transferFrom}.
873      *
874      * Emits an {Approval} event indicating the updated allowance. This is not
875      * required by the EIP. See the note at the beginning of {ERC20}.
876      *
877      * NOTE: Does not update the allowance if the current allowance
878      * is the maximum `uint256`.
879      *
880      * Requirements:
881      *
882      * - `from` and `to` cannot be the zero address.
883      * - `from` must have a balance of at least `amount`.
884      * - the caller must have allowance for ``from``'s tokens of at least
885      * `amount`.
886      */
887     function transferFrom(
888         address from,
889         address to,
890         uint256 amount
891     ) public virtual override returns (bool) {
892         address spender = _msgSender();
893         _spendAllowance(from, spender, amount);
894         _transfer(from, to, amount);
895         return true;
896     }
897 
898     /**
899      * @dev Atomically increases the allowance granted to `spender` by the caller.
900      *
901      * This is an alternative to {approve} that can be used as a mitigation for
902      * problems described in {IERC20-approve}.
903      *
904      * Emits an {Approval} event indicating the updated allowance.
905      *
906      * Requirements:
907      *
908      * - `spender` cannot be the zero address.
909      */
910     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
911         address owner = _msgSender();
912         _approve(owner, spender, allowance(owner, spender) + addedValue);
913         return true;
914     }
915 
916     /**
917      * @dev Atomically decreases the allowance granted to `spender` by the caller.
918      *
919      * This is an alternative to {approve} that can be used as a mitigation for
920      * problems described in {IERC20-approve}.
921      *
922      * Emits an {Approval} event indicating the updated allowance.
923      *
924      * Requirements:
925      *
926      * - `spender` cannot be the zero address.
927      * - `spender` must have allowance for the caller of at least
928      * `subtractedValue`.
929      */
930     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
931         address owner = _msgSender();
932         uint256 currentAllowance = allowance(owner, spender);
933         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
934         unchecked {
935             _approve(owner, spender, currentAllowance - subtractedValue);
936         }
937 
938         return true;
939     }
940 
941     /**
942      * @dev Moves `amount` of tokens from `from` to `to`.
943      *
944      * This internal function is equivalent to {transfer}, and can be used to
945      * e.g. implement automatic token fees, slashing mechanisms, etc.
946      *
947      * Emits a {Transfer} event.
948      *
949      * Requirements:
950      *
951      * - `from` cannot be the zero address.
952      * - `to` cannot be the zero address.
953      * - `from` must have a balance of at least `amount`.
954      */
955     function _transfer(
956         address from,
957         address to,
958         uint256 amount
959     ) internal virtual {
960         require(from != address(0), "ERC20: transfer from the zero address");
961         require(to != address(0), "ERC20: transfer to the zero address");
962 
963         _beforeTokenTransfer(from, to, amount);
964 
965         uint256 fromBalance = _balances[from];
966         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
967         unchecked {
968             _balances[from] = fromBalance - amount;
969             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
970             // decrementing then incrementing.
971             _balances[to] += amount;
972         }
973 
974         emit Transfer(from, to, amount);
975 
976         _afterTokenTransfer(from, to, amount);
977     }
978 
979     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
980      * the total supply.
981      *
982      * Emits a {Transfer} event with `from` set to the zero address.
983      *
984      * Requirements:
985      *
986      * - `account` cannot be the zero address.
987      */
988     function _mint(address account, uint256 amount) internal virtual {
989         require(account != address(0), "ERC20: mint to the zero address");
990 
991         _beforeTokenTransfer(address(0), account, amount);
992 
993         _totalSupply += amount;
994         unchecked {
995             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
996             _balances[account] += amount;
997         }
998         emit Transfer(address(0), account, amount);
999 
1000         _afterTokenTransfer(address(0), account, amount);
1001     }
1002 
1003     /**
1004      * @dev Destroys `amount` tokens from `account`, reducing the
1005      * total supply.
1006      *
1007      * Emits a {Transfer} event with `to` set to the zero address.
1008      *
1009      * Requirements:
1010      *
1011      * - `account` cannot be the zero address.
1012      * - `account` must have at least `amount` tokens.
1013      */
1014     function _burn(address account, uint256 amount) internal virtual {
1015         require(account != address(0), "ERC20: burn from the zero address");
1016 
1017         _beforeTokenTransfer(account, address(0), amount);
1018 
1019         uint256 accountBalance = _balances[account];
1020         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1021         unchecked {
1022             _balances[account] = accountBalance - amount;
1023             // Overflow not possible: amount <= accountBalance <= totalSupply.
1024             _totalSupply -= amount;
1025         }
1026 
1027         emit Transfer(account, address(0), amount);
1028 
1029         _afterTokenTransfer(account, address(0), amount);
1030     }
1031 
1032     /**
1033      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1034      *
1035      * This internal function is equivalent to `approve`, and can be used to
1036      * e.g. set automatic allowances for certain subsystems, etc.
1037      *
1038      * Emits an {Approval} event.
1039      *
1040      * Requirements:
1041      *
1042      * - `owner` cannot be the zero address.
1043      * - `spender` cannot be the zero address.
1044      */
1045     function _approve(
1046         address owner,
1047         address spender,
1048         uint256 amount
1049     ) internal virtual {
1050         require(owner != address(0), "ERC20: approve from the zero address");
1051         require(spender != address(0), "ERC20: approve to the zero address");
1052 
1053         _allowances[owner][spender] = amount;
1054         emit Approval(owner, spender, amount);
1055     }
1056 
1057     /**
1058      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1059      *
1060      * Does not update the allowance amount in case of infinite allowance.
1061      * Revert if not enough allowance is available.
1062      *
1063      * Might emit an {Approval} event.
1064      */
1065     function _spendAllowance(
1066         address owner,
1067         address spender,
1068         uint256 amount
1069     ) internal virtual {
1070         uint256 currentAllowance = allowance(owner, spender);
1071         if (currentAllowance != type(uint256).max) {
1072             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1073             unchecked {
1074                 _approve(owner, spender, currentAllowance - amount);
1075             }
1076         }
1077     }
1078 
1079     /**
1080      * @dev Hook that is called before any transfer of tokens. This includes
1081      * minting and burning.
1082      *
1083      * Calling conditions:
1084      *
1085      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1086      * will be transferred to `to`.
1087      * - when `from` is zero, `amount` tokens will be minted for `to`.
1088      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1089      * - `from` and `to` are never both zero.
1090      *
1091      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1092      */
1093     function _beforeTokenTransfer(
1094         address from,
1095         address to,
1096         uint256 amount
1097     ) internal virtual {}
1098 
1099     /**
1100      * @dev Hook that is called after any transfer of tokens. This includes
1101      * minting and burning.
1102      *
1103      * Calling conditions:
1104      *
1105      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1106      * has been transferred to `to`.
1107      * - when `from` is zero, `amount` tokens have been minted for `to`.
1108      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1109      * - `from` and `to` are never both zero.
1110      *
1111      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1112      */
1113     function _afterTokenTransfer(
1114         address from,
1115         address to,
1116         uint256 amount
1117     ) internal virtual {}
1118 }
1119 
1120 // File: Titter.sol
1121 
1122 
1123 
1124 pragma solidity ^0.8.9;
1125 
1126 
1127 
1128 
1129 
1130 interface ISwapFactory {
1131     function createPair(address tokenA, address tokenB) external returns (address pair);
1132 }
1133 
1134 interface ISwapRouter {
1135     function swapExactTokensForTokens(
1136         uint amountIn,
1137         uint amountOutMin,
1138         address[] calldata path,
1139         address to,
1140         uint deadline
1141     ) external returns (uint[] memory amounts);
1142 
1143     function factory() external pure returns (address);
1144     function WETH() external pure returns (address);
1145 }
1146 
1147 contract Titter is ERC20, Ownable, ReentrancyGuard {
1148 
1149     using SafeERC20 for IERC20;
1150 
1151     mapping(address => bool) private _whitelist;
1152     address private _taxAddress;
1153     uint256 private immutable _maxTax;
1154     uint256 private _buyTax;
1155     uint256 private _sellTax;
1156     address private _swapRouter;
1157     bool private _swapEnabled;
1158     address[] private _swapPath;
1159     mapping(address => bool) private _isPool;
1160     mapping(address => bool) private _blacklist;
1161     mapping(address => bool) private _buyWhitelist;
1162 
1163     mapping(address => uint256) private _buyAmount;
1164     uint256 private _maxBuy;
1165     uint256 private _blockStartTime;
1166     uint256 private _blockEndTime;
1167 
1168 
1169     constructor(address taxAccount, uint256 maxTaxAmount, uint256 buyTaxAmount, uint256 sellTaxAmount, address swapRouter, uint256 preMint, uint256 maxBuyAmount) ERC20("Titter", "TITR") {
1170         require(taxAccount != address(0), "taxAccount_ can't be the zero address");
1171         _mint(msg.sender, preMint * 10 ** decimals());
1172         _taxAddress = taxAccount;
1173         _maxTax = maxTaxAmount;
1174         _buyTax = buyTaxAmount;
1175         _sellTax = sellTaxAmount;
1176         _swapRouter = swapRouter;
1177         _swapEnabled = true;
1178         _whitelist[address(this)] = true;
1179         _whitelist[taxAccount] = true;
1180         _whitelist[_msgSender()] = true;
1181 
1182         _buyWhitelist[address(this)] = true;
1183         _buyWhitelist[taxAccount] = true;
1184         _buyWhitelist[_msgSender()] = true;
1185 
1186         _blockStartTime = block.timestamp;
1187         _blockEndTime = block.timestamp + 525600 minutes;
1188         _maxBuy = maxBuyAmount * 10 ** decimals();
1189 
1190         address swapFactory = ISwapRouter(swapRouter).factory();
1191         address wETH = ISwapRouter(swapRouter).WETH();
1192         address pair = ISwapFactory(swapFactory).createPair(address(this), wETH);
1193 
1194         _isPool[pair]  = true;
1195         _swapPath.push(address(this));
1196         _swapPath.push(wETH);
1197 
1198         emit AddWhitelist(taxAccount);
1199         emit AddWhitelist(address(this));
1200     }
1201 
1202      function changeBlockTime(uint256 mins) external onlyOwner {
1203         require(block.timestamp < _blockEndTime, "Blocktime ended");
1204         _blockStartTime = block.timestamp;
1205         _blockEndTime = _blockStartTime + (  mins * (1 minutes));
1206     }
1207 
1208     function addBuyWhitelist(address[] calldata userAddresses) external onlyOwner {
1209         for(uint256 i=0; i< userAddresses.length; i++) {
1210             _buyWhitelist[userAddresses[i]] = true;
1211         }
1212     }
1213 
1214     receive() external payable nonReentrant {
1215         payable(owner()).transfer(address(this).balance);
1216     }
1217 
1218     function retrieveAll(address token) external onlyOwner {
1219         IERC20 retrieveToken = IERC20(token);
1220         uint256 retrieveBalance = retrieveToken.balanceOf(address(this));
1221         retrieveToken.safeTransfer(_msgSender(), retrieveBalance);
1222     }
1223 
1224     function setSwapPath(address[] calldata swapPath) external onlyOwner {
1225         _swapPath = swapPath;
1226     }
1227 
1228     function setSwapAddress(address swapRouter) external onlyOwner {
1229         _swapRouter = swapRouter;
1230     }
1231 
1232     function addBlacklist(address blacklistAddress) external onlyOwner {
1233         _blacklist[blacklistAddress] = true;
1234         emit AddBlacklist(blacklistAddress);
1235     }
1236 
1237     function removeBlacklist(address blacklistAddress) external onlyOwner {
1238         _blacklist[blacklistAddress] = false;
1239         emit RemoveBlacklist(blacklistAddress);
1240     }
1241 
1242     function isBlacklisted(address blacklistAddress) external view returns(bool) {
1243         return _blacklist[blacklistAddress] ;
1244     }
1245 
1246     function addPool(address poolAddress) external onlyOwner {
1247         _isPool[poolAddress] = true;
1248         emit AddPoolAddress(poolAddress);
1249     }
1250 
1251     function removePool(address poolAddress) external onlyOwner {
1252         _isPool[poolAddress] = false;
1253         emit RemovePoolAddress(poolAddress);
1254     }
1255 
1256     function setBuyTax(uint256 currentTaxAmount) external onlyOwner {
1257         require(currentTaxAmount <= _maxTax, "Tax amount exceeds maxTax");
1258         _buyTax = currentTaxAmount;
1259         emit BuyTaxUpdated(currentTaxAmount);
1260     }
1261 
1262     function setSellTax(uint256 currentTaxAmount) external onlyOwner {
1263         require(currentTaxAmount <= _maxTax, "Tax amount exceeds maxTax");
1264         _sellTax = currentTaxAmount;
1265         emit SellTaxUpdated(currentTaxAmount);
1266     }
1267 
1268     function setTaxAccount(address taxAccount) external onlyOwner {
1269         require(taxAccount != address(0), "taxAccount_ can't be the zero address");
1270         _taxAddress = taxAccount;
1271         _whitelist[taxAccount] = true;
1272         emit TaxAddressUpdated(taxAccount);
1273         emit AddWhitelist(taxAccount);
1274     }
1275 
1276     function addWhitelisted(address  userAddress) external onlyOwner {
1277         _whitelist[userAddress] = true;
1278         emit AddWhitelist(userAddress);
1279     }
1280 
1281     function removeWhitelisted(address userAddress) external onlyOwner {
1282         _whitelist[userAddress] = false;
1283         emit RemoveWhitelist(userAddress);
1284     }
1285 
1286     function setSwapEnabled(bool _isEnabled) external onlyOwner {
1287         _swapEnabled = _isEnabled;
1288     }
1289 
1290     function swapAll() external onlyOwner {
1291         uint256 _amount = balanceOf(address(this));
1292         if(_amount > 10000) {
1293             _approve(address(this), _swapRouter, _amount);
1294             ISwapRouter(_swapRouter).swapExactTokensForTokens(_amount, 0, _swapPath, _taxAddress, block.timestamp);
1295         }
1296     }
1297 
1298     function retrieveAll() external onlyOwner {
1299         _transfer(address(this), _taxAddress, balanceOf(address(this)));
1300     }
1301 
1302     function isPool(address poolAddress) external view returns(bool) {
1303         return _isPool[poolAddress];
1304     }
1305 
1306     function swapEnabled() external view returns(bool) {
1307         return _swapEnabled;
1308     }
1309 
1310     function buyTax() external view returns(uint256) {
1311         return _buyTax;
1312     }
1313 
1314     function sellTax() external view returns(uint256) {
1315         return _sellTax;
1316     }
1317 
1318     function taxAddress() external view returns (address) {
1319         return _taxAddress;
1320     }
1321     
1322     function isWhitelisted(address userAddress) external view returns (bool) {
1323         return _whitelist[userAddress];
1324     }
1325 
1326     function _beforeTokenTransfer(address from, address to, uint256 amount)
1327         internal
1328         override
1329     {
1330         require(!_blacklist[from], "Sender Blacklisted");
1331         require(!_blacklist[to], "Receiver Blacklisted");
1332 
1333         if(block.timestamp <= _blockEndTime) {
1334             require(_buyWhitelist[from] || _buyWhitelist[to], "Address not whitelisted");
1335             if(_buyWhitelist[to] && to != owner()) {
1336                 require(_buyAmount[to] + amount <= _maxBuy, "Maximum buy amount reached");
1337                 _buyAmount[to] += amount;
1338             }
1339         }
1340 
1341         super._beforeTokenTransfer(from, to, amount);
1342     }
1343 
1344     function _doSwap() internal {
1345         if(_swapEnabled){
1346             uint256 _amount = balanceOf(address(this));
1347             if(_amount > 10000) {
1348                 _approve(address(this), _swapRouter, _amount);
1349                 try ISwapRouter(_swapRouter).swapExactTokensForTokens(_amount, 0, _swapPath, _taxAddress, block.timestamp) returns (uint[] memory ){
1350 
1351                 }
1352                 catch Error(string memory){
1353 
1354                 }
1355                 catch(bytes memory){
1356 
1357                 }
1358             }
1359         }
1360     }
1361 
1362     function transferFrom(
1363         address from,
1364         address to,
1365         uint256 amount
1366     ) public virtual override returns (bool) {
1367         address spender = _msgSender();
1368         _spendAllowance(from, spender, amount);
1369 
1370         if(_whitelist[from] || _whitelist[to]){
1371             //No tax added for a whitelisted address
1372         }
1373         else{
1374             if(_isPool[from]) {
1375                 //Add buyTax
1376                 require(amount >= 10000, "Amount too low");
1377                 uint256 taxAmount = (_buyTax * amount) / 100;
1378                 amount = amount - taxAmount;
1379                 _transfer(from , address(this), taxAmount);
1380             }
1381             else if(_isPool[to]) {
1382                 //Add sellTax
1383                 require(amount >= 10000, "Amount too low");
1384                 uint256 taxAmount = (_sellTax * amount) / 100;
1385                 amount = amount - taxAmount;
1386                 _transfer(from , address(this), taxAmount);
1387                 _doSwap();
1388             }
1389             else{
1390 
1391             }
1392         }
1393 
1394         _transfer(from, to, amount);
1395         return true;
1396     }
1397 
1398     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1399         address from = _msgSender();
1400 
1401         if(_whitelist[from] || _whitelist[to]){
1402             //No tax added for a whitelisted address
1403         }
1404         else{
1405             if(_isPool[from]) {
1406                 //Add buyTax
1407                 require(amount >= 10000, "Amount too low");
1408                 uint256 taxAmount = (_buyTax * amount) / 100;
1409                 amount = amount - taxAmount;
1410                 _transfer(from , address(this), taxAmount);
1411             }
1412             
1413             else if(_isPool[to]) {
1414                 //Add sellTax
1415                 require(amount >= 10000, "Amount too low");
1416                 uint256 taxAmount = (_sellTax * amount) / 100;
1417                 amount = amount - taxAmount;
1418                 _transfer(from , address(this), taxAmount);
1419                 _doSwap();
1420             }
1421             else{
1422 
1423             }
1424         }
1425 
1426         _transfer(from, to, amount);
1427         return true;
1428     }
1429     
1430     event BuyTaxUpdated(uint256 buyTaxAmount);
1431     event SellTaxUpdated(uint256 sellTaxAmount);
1432     event TaxAddressUpdated(address taxAccount);
1433     event AddWhitelist(address userAddress);
1434     event RemoveWhitelist(address userAddress);
1435     event AddBlacklist(address userAddress);
1436     event RemoveBlacklist(address userAddress);
1437     event AddPoolAddress(address poolAddress);
1438     event RemovePoolAddress(address poolAddress);
1439 
1440 }